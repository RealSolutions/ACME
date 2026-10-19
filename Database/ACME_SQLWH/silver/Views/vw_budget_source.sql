/* =============================================================================
   Silver load (SCD Type 2): ACME_SQLWH.Bronze.Budget -> ACME_SQLWH.Silver.Budget
   Run in the ACME_SQLWH warehouse (workspace: ACME).

   Source columns (Bronze.Budget): SupplierCode, Period, CurrencyCode,
   Budgetamountlocal, CBudgetNote, Budget_year, Budget_month, Budget_Period,
   Version, source_file, loaded_at + _ingested_at/_source_system/_batch_id

   - Business key : SupplierCode + Period (one Budget line per Supplier per Period)
   - Surrogate key: BudgetSK (BIGINT, assigned here, unique per Version)
   - Tracked      : CurrencyCode, Budgetamountlocal, CBudgetNote, Budget_year,
                    Budget_month, Budget_Period, Version. A change to any of these
                    closes the current row and inserts a new Version.
   - Not tracked  : source_file, loaded_at (lineage only; a re-sent file with the
                    same numbers does not create a new Version).
   - Duplicates   : if Bronze has several rows for one key, the highest `Version`
                    wins, then the latest loaded_at.
   - Deletes      : a key missing from Bronze has its current row closed.
   - Intervals    : half-open [ValidFrom, ValidTo); current rows have ValidTo = 9999-12-31.
   - Re-runnable  : running twice with no Bronze changes is a no-op.
   ============================================================================= */
CREATE VIEW Silver.vw_Budget_Source
AS
    WITH ranked AS
    (
        SELECT
            LTRIM(RTRIM(b.SupplierCode))        AS SupplierCode,
            b.Period,
            UPPER(LTRIM(RTRIM(b.CurrencyCode))) AS CurrencyCode,
            b.BudgetAmountLocal,
            b.BudgetNote,
            b.WBSCode,
            b.CostType,
            b.Budget_Year,
            b.Budget_Month,
            b.Budget_Period,
            b.Version,
            b.Source_File,
            b.Loaded_At,
            ROW_NUMBER() OVER (PARTITION BY LTRIM(RTRIM(b.SupplierCode)), b.Period
                            ORDER BY b.Version DESC, b.Loaded_At DESC, b._Ingested_At DESC) AS rn
        FROM Bronze.Budget AS b
        WHERE NULLIF(LTRIM(RTRIM(b.SupplierCode)), '') IS NOT NULL
        AND b.Period IS NOT NULL
    )
    SELECT
        r.SupplierCode, 
        r.Period, 
        r.CurrencyCode,
        r.BudgetAmountLocal, 
        r.BudgetNote,
        WBSCode, 
        r.CostType,
        r.Budget_Year,
        r.Budget_Month, 
        r.Budget_Period, 
        r.Version, 
        r.Source_File, 
        r.Loaded_At,
        -- '~' marks NULL so that NULL and '' hash differently.
        -- Float uses style 3 (17 significant digits) so small amount changes are caught.
        -- HASHBYTES returns VARBINARY(8000); convert explicitly to the 32-byte column type.
        CONVERT(VARBINARY(32), HASHBYTES('SHA2_256', CONCAT_WS('|',
            ISNULL(r.CurrencyCode, '~'),
            ISNULL(CONVERT(VARCHAR(30), r.BudgetAmountLocal, 3), '~'),
            ISNULL(r.BudgetNote, '~'),
            ISNULL(CAST(r.Budget_Year  AS VARCHAR(20)), '~'),
            ISNULL(CAST(r.Budget_Month AS VARCHAR(20)), '~'),
            ISNULL(CONVERT(VARCHAR(10), r.Budget_Period, 23), '~'),
            ISNULL(CAST(Version AS VARCHAR(20)), '~')
        ))) AS RowHash
    FROM ranked r
    WHERE rn = 1;

GO