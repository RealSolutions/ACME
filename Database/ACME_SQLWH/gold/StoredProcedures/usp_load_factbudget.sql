/* =============================================================================
   Gold load: ACME_SQLWH.Silver.Budget -> ACME_SQLWH.Gold.FactBudget
   Run in the ACME_SQLWH warehouse (workspace: ACME).

   Gold.Budget is the Budget Fact table for reporting.
   - One row per current Budget line in Silver (IsCurrent = 1), keyed on BudgetSK.
   - SupplierSK is looked up from Gold.DimSupplier by SupplierCode, picking the
     Supplier Version that was valid on the Budget's Period date:
       1. 'PointInTime' - Period date falls inside [ValidFrom, ValidTo)
       2. 'Nearest'     - no Version covers that date (e.g. the Period is before
                          Supplier history began), so the closest Version is used
       3. 'Unknown'     - no Supplier with that code at all -> SupplierSK = -1
     SupplierMatchType records which rule was used.
   - Rebuilt in full each run (truncate + insert). Safe to re-run.
   Run order: Silver.usp_Load_Supplier -> Gold.usp_Load_Supplier
              -> Silver.usp_Load_Budget -> Gold.usp_Load_Budget
              
   ============================================================================= */
CREATE PROCEDURE Gold.usp_Load_FactBudget
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @loaded_at DATETIME2(6) = SYSUTCDATETIME();

    BEGIN TRANSACTION;

        TRUNCATE TABLE Gold.FactBudget;

        WITH CTE_Budget AS
        (
            -- current Budget lines with a usable Period date
            SELECT
                b.BudgetSK,
                b.SupplierCode,
                b.Period,
                b.CurrencyCode,
                b.BudgetAmountLocal, 
                b.BudgetNote, 
                b.Budget_Year, 
                b.Budget_Month, 
                b.Budget_Period,
                b.Version,
                COALESCE(b.Budget_Period,
                         CASE WHEN b.Budget_Year BETWEEN 1900 AND 9999
                               AND b.Budget_Month BETWEEN 1 AND 12
                              THEN DATEFROMPARTS(b.Budget_Year, b.Budget_Month, 1) END
                ) AS Period_Date,
                b.WBSCode,
                b.CostType
            FROM 
                Silver.Budget AS b
            WHERE 
                b.IsCurrent = 1
        ),
        CTE_candidates AS
        (
            -- every Supplier Version with the same code, ranked best match first
            SELECT
                b.BudgetSK,
                s.SupplierSK,
                CASE WHEN b.Period_Date >= CAST(s.ValidFrom AS DATE)
                      AND b.Period_Date <  CAST(s.ValidTo   AS DATE)
                     THEN 'PointInTime' ELSE 'Nearest' END AS Match_Type,
                ROW_NUMBER() OVER
                (
                    PARTITION BY b.BudgetSK
                    ORDER BY
                        -- 1. a Version that covers the Period date
                        CASE WHEN b.Period_Date >= CAST(s.ValidFrom AS DATE)
                              AND b.Period_Date <  CAST(s.ValidTo   AS DATE)
                             THEN 0 ELSE 1 END,
                        -- 2. otherwise the Version closest in time to the Period date
                        ISNULL(CASE WHEN b.Period_Date < CAST(s.ValidFrom AS DATE)
                                    THEN DATEDIFF(DAY, b.Period_Date, CAST(s.ValidFrom AS DATE))
                                    ELSE DATEDIFF(DAY, CAST(s.ValidTo AS DATE), b.Period_Date)
                               END, 0),
                        -- 3. tie-break: current Version, then most recent
                        s.IsCurrent DESC,
                        s.ValidFrom DESC
                ) AS rn
            FROM CTE_Budget AS b
            INNER JOIN Gold.DimSupplier AS s
                ON  s.SupplierCode = b.SupplierCode
                AND s.SupplierSK  <> -1
        )
        INSERT INTO Gold.FactBudget
        (
            BudgetSK, 
            SupplierSK,
            SupplierCode, 
            PeriodKey, 
            PeriodDate, 
            BudgetYear, 
            BudgetMonth,
            CurrencyCode, 
            BudgetAmountLocal, 
            BudgetNote, 
            Version,
            WBSCode,
            CostType,    
            SupplierMatchType, 
            _Loaded_At
        )
        SELECT
            b.BudgetSK,
            ISNULL(c.SupplierSK, -1),
            b.SupplierCode,
            b.Period,
            b.Period_Date,
            b.Budget_Year,
            b.Budget_Month,
            ISNULL(NULLIF(b.CurrencyCode, ''), 'UNK'),
            CAST(b.BudgetAmountLocal AS DECIMAL(19,4)),
            b.BudgetNote,
            b.Version,
            b.WBSCode,
            b.CostType,  
            ISNULL(c.Match_Type, 'Unknown') as SupplierMatchType,
            @loaded_at
        FROM CTE_Budget AS b
        LEFT JOIN CTE_candidates AS c
            ON  c.BudgetSK = b.BudgetSK
            AND c.rn = 1;

    COMMIT TRANSACTION;

    SELECT @loaded_at AS loaded_at,
           COUNT(*)                                                      AS rows_loaded,
           SUM(CASE WHEN SupplierMatchType = 'PointInTime' THEN 1 ELSE 0 END) AS matched_point_in_time,
           SUM(CASE WHEN SupplierMatchType = 'Nearest'     THEN 1 ELSE 0 END) AS matched_nearest,
           SUM(CASE WHEN SupplierMatchType = 'Unknown'     THEN 1 ELSE 0 END) AS unknown_Supplier
    FROM Gold.FactBudget;
END;

GO