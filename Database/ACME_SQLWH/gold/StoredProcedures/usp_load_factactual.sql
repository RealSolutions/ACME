/* =============================================================================
   Gold load: ACME_SQLWH.silver.actual -> ACME_SQLWH.gold.factactual
   Run in the ACME_SQLWH warehouse (workspace: ACME).

   gold.factactual is the actual-spend fact table for reporting.
   - One row per current invoice in silver (IsCurrent = 1), keyed on ActualSK.
   - SupplierSK is looked up from gold.factsupplier by SupplierCode, picking the
     supplier version that was valid on the invoice date
     (InvoiceDate, else the `actual` period date, else actual_year/actual_month):
       1. 'PointInTime' - the date falls inside [ValidFrom, ValidTo)
       2. 'Nearest'     - no version covers that date (e.g. the invoice is before
                          supplier history began), so the closest version is used
       3. 'Unknown'     - no SupplierCode, or no supplier with that code -> SupplierSK = -1
     SupplierMatchType records which rule was used.
   - Rebuilt in full each run (truncate + insert). Safe to re-run.
   Run order: silver.usp_load_supplier -> gold.usp_load_supplier
              -> silver.usp_load_actual -> gold.usp_load_factactual
   ============================================================================= */
CREATE   PROCEDURE gold.usp_load_factactual
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @loaded_at DATETIME2(6) = SYSUTCDATETIME();

    BEGIN TRANSACTION;

        TRUNCATE TABLE gold.factactual;

        WITH actual AS
        (
            -- current invoices with a period date and a lookup date
            SELECT
                a.*,
                COALESCE(a.actual,
                         CASE WHEN a.actual_year BETWEEN 1900 AND 9999
                               AND a.actual_month BETWEEN 1 AND 12
                              THEN DATEFROMPARTS(a.actual_year, a.actual_month, 1) END
                ) AS period_date
            FROM silver.actual AS a
            WHERE a.IsCurrent = 1
        ),
        dated AS
        (
            SELECT a.*, COALESCE(a.InvoiceDate, a.period_date) AS lookup_date
            FROM actual AS a
        ),
        candidates AS
        (
            -- every supplier version with the same code, ranked best match first
            SELECT
                d.ActualSK,
                s.SupplierSK,
                CASE WHEN d.lookup_date >= CAST(s.ValidFrom AS DATE)
                      AND d.lookup_date <  CAST(s.ValidTo   AS DATE)
                     THEN 'PointInTime' ELSE 'Nearest' END AS match_type,
                ROW_NUMBER() OVER
                (
                    PARTITION BY d.ActualSK
                    ORDER BY
                        -- 1. a version that covers the lookup date
                        CASE WHEN d.lookup_date >= CAST(s.ValidFrom AS DATE)
                              AND d.lookup_date <  CAST(s.ValidTo   AS DATE)
                             THEN 0 ELSE 1 END,
                        -- 2. otherwise the version closest in time to the lookup date
                        ISNULL(CASE WHEN d.lookup_date < CAST(s.ValidFrom AS DATE)
                                    THEN DATEDIFF(DAY, d.lookup_date, CAST(s.ValidFrom AS DATE))
                                    ELSE DATEDIFF(DAY, CAST(s.ValidTo AS DATE), d.lookup_date)
                               END, 0),
                        -- 3. tie-break: current version, then most recent
                        s.IsCurrent DESC,
                        s.ValidFrom DESC
                ) AS rn
            FROM dated AS d
            INNER JOIN gold.factsupplier AS s
                ON  s.SupplierCode = d.SupplierCode
                AND s.SupplierSK  <> -1
        )
        INSERT INTO gold.factactual
        (
            ActualSK, SupplierSK, SupplierCode, InvoiceNumber, InvoiceDate, PurchaseOrderNo,
            Period, PeriodDate, ActualYear, ActualMonth, CurrencyCode, AmountLocal,
            Description, ActualVersion, SupplierMatchType, _loaded_at
        )
        SELECT
            d.ActualSK,
            ISNULL(c.SupplierSK, -1),
            d.SupplierCode,
            d.InvoiceNumber,
            d.InvoiceDate,
            d.PurchaseOrderNo,
            d.Period,
            d.period_date,
            d.actual_year,
            d.actual_month,
            ISNULL(NULLIF(d.CurrencyCode, ''), 'UNK'),
            CAST(d.AmountLocal AS DECIMAL(19,4)),
            d.Description,
            d.version,
            ISNULL(c.match_type, 'Unknown'),
            @loaded_at
        FROM dated AS d
        LEFT JOIN candidates AS c
            ON  c.ActualSK = d.ActualSK
            AND c.rn = 1;

    COMMIT TRANSACTION;

    SELECT @loaded_at AS loaded_at,
           COUNT(*)                                                           AS rows_loaded,
           SUM(CASE WHEN SupplierMatchType = 'PointInTime' THEN 1 ELSE 0 END) AS matched_point_in_time,
           SUM(CASE WHEN SupplierMatchType = 'Nearest'     THEN 1 ELSE 0 END) AS matched_nearest,
           SUM(CASE WHEN SupplierMatchType = 'Unknown'     THEN 1 ELSE 0 END) AS unknown_supplier
    FROM gold.factactual;
END;

GO