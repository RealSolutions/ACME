/* =============================================================================
   Gold load: ACME_SQLWH.Silver.Actual -> ACME_SQLWH.Gold.FactActual
   Run in the ACME_SQLWH warehouse (workspace: ACME).

   Gold.FactActual is the Actual-spend Fact table for reporting.
   - One row per current invoice in Silver (IsCurrent = 1), keyed on ActualSK.
   - SupplierSK is looked up from Gold.DimSupplier by SupplierCode, picking the
     Supplier Version that was valid on the invoice date
     (InvoiceDate, else the `Actual` Period date, else Actual_year/Actual_month):
       1. 'PointInTime' - the date falls inside [ValidFrom, ValidTo)
       2. 'Nearest'     - no Version covers that date (e.g. the invoice is before
                          Supplier history began), so the closest Version is used
       3. 'Unknown'     - no SupplierCode, or no Supplier with that code -> SupplierSK = -1
     SupplierMatchType records which rule was used.
   - Rebuilt in full each run (truncate + insert). Safe to re-run.
   Run order: Silver.usp_Load_Supplier -> Gold.usp_Load_Supplier
              -> Silver.usp_Load_Actual -> Gold.usp_Load_FactActual
   ============================================================================= */
CREATE PROCEDURE   Gold.usp_Load_FactActual
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @loaded_at DATETIME2(6) = SYSUTCDATETIME();

    BEGIN TRANSACTION;

        TRUNCATE TABLE Gold.FactActual;

        WITH CTE_Actual AS
        (
            -- current invoices with a Period date and a lookup date
            SELECT
                a.ActualSK, 
                a.InvoiceNumber, 
                a.SupplierCode, 
                a.Period, 
                a.InvoiceDate, 
                a.PurchaseOrderNo, 
                a.CurrencyCode, 
                a.AmountLocal, 
                a.Description, 
                a.WBSCode,
                a.CostType,
                a.[Actual_Year] AS Actual_Year,
                a.[Actual_Month] AS Actual_Month,
                a.Version,
                COALESCE(a.Actual,
                         CASE WHEN a.[Actual_Year] BETWEEN 1900 AND 9999
                             AND a.[Actual_Month] BETWEEN 1 AND 12
                            THEN DATEFROMPARTS(a.[Actual_Year], a.[Actual_Month], 1) END
                ) AS Period_Date
            FROM Silver.Actual AS a
            WHERE a.IsCurrent = 1
        ),
        CTE_dated AS
        (
            SELECT a.*, COALESCE(a.InvoiceDate, a.Period_Date) AS lookup_date
            FROM CTE_Actual AS a
        ),
        CTE_candidates AS
        (
            -- every Supplier Version with the same code, ranked best match first
            SELECT
                d.ActualSK,
                s.SupplierSK,
                CASE WHEN d.Lookup_Date >= CAST(s.ValidFrom AS DATE)
                      AND d.Lookup_Date <  CAST(s.ValidTo   AS DATE)
                     THEN 'PointInTime' ELSE 'Nearest' END AS match_type,
                ROW_NUMBER() OVER
                (
                    PARTITION BY d.ActualSK
                    ORDER BY
                        -- 1. a Version that covers the lookup date
                        CASE WHEN d.lookup_date >= CAST(s.ValidFrom AS DATE)
                              AND d.lookup_date <  CAST(s.ValidTo   AS DATE)
                             THEN 0 ELSE 1 END,
                        -- 2. otherwise the Version closest in time to the lookup date
                        ISNULL(CASE WHEN d.lookup_date < CAST(s.ValidFrom AS DATE)
                                    THEN DATEDIFF(DAY, d.Lookup_Date, CAST(s.ValidFrom AS DATE))
                                    ELSE DATEDIFF(DAY, CAST(s.ValidTo AS DATE), d.Lookup_Date)
                               END, 0),
                        -- 3. tie-break: current Version, then most recent
                        s.IsCurrent DESC,
                        s.ValidFrom DESC
                ) AS rn
            FROM CTE_dated AS d
            INNER JOIN Gold.DimSupplier AS s
                ON  s.SupplierCode = d.SupplierCode
                AND s.SupplierSK  <> -1
        )
        INSERT INTO Gold.FactActual
        (
            ActualSK, 
            SupplierSK, 
            SupplierCode, 
            InvoiceNumber, 
            InvoiceDate, 
            PurchaseOrderNo,
            PeriodKey, 
            PeriodDate, 
            ActualYear, 
            ActualMonth, 
            CurrencyCode, 
            AmountLocal,
            Description,
            WBSCode,
            CostType, 
            ActualVersion, 
            SupplierMatchType, 
            _Loaded_At
        )
        SELECT
            d.ActualSK,
            ISNULL(c.SupplierSK, -1),
            d.SupplierCode,
            d.InvoiceNumber,
            d.InvoiceDate,
            d.PurchaseOrderNo,
            d.Period,
            d.Period_Date,
            d.Actual_Year,
            d.Actual_Month,
            ISNULL(NULLIF(d.CurrencyCode, ''), 'UNK'),
            CAST(d.AmountLocal AS DECIMAL(19,4)),
            d.Description,
            d.WBSCode,
            d.CostType,
            d.Version,
            ISNULL(c.Match_Type, 'Unknown'),
            @loaded_at
        FROM CTE_dated AS d
        LEFT JOIN CTE_candidates AS c
            ON  c.ActualSK = d.ActualSK
            AND c.rn = 1;

    COMMIT TRANSACTION;

    SELECT @loaded_at AS loaded_at,
           COUNT(*)                                                           AS rows_loaded,
           SUM(CASE WHEN SupplierMatchType = 'PointInTime' THEN 1 ELSE 0 END) AS matched_point_in_time,
           SUM(CASE WHEN SupplierMatchType = 'Nearest'     THEN 1 ELSE 0 END) AS matched_nearest,
           SUM(CASE WHEN SupplierMatchType = 'Unknown'     THEN 1 ELSE 0 END) AS unknown_Supplier
    FROM Gold.FactActual;
END;

GO