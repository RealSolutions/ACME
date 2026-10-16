/* =============================================================================
   Silver load (SCD Type 2): ACME_SQLWH.bronze.budget -> ACME_SQLWH.silver.budget
   Run in the ACME_SQLWH warehouse (workspace: ACME).

   Source columns (bronze.budget): suppliercode, period, currencycode,
   budgetamountlocal, budgetnote, budget_year, budget_month, budget_period,
   version, source_file, loaded_at + _ingested_at/_source_system/_batch_id

   - Business key : suppliercode + period (one budget line per supplier per period)
   - Surrogate key: BudgetSK (BIGINT, assigned here, unique per version)
   - Tracked      : currencycode, budgetamountlocal, budgetnote, budget_year,
                    budget_month, budget_period, version. A change to any of these
                    closes the current row and inserts a new version.
   - Not tracked  : source_file, loaded_at (lineage only; a re-sent file with the
                    same numbers does not create a new version).
   - Duplicates   : if bronze has several rows for one key, the highest `version`
                    wins, then the latest loaded_at.
   - Deletes      : a key missing from bronze has its current row closed.
   - Intervals    : half-open [ValidFrom, ValidTo); current rows have ValidTo = 9999-12-31.
   - Re-runnable  : running twice with no bronze changes is a no-op.
   ============================================================================= */
CREATE  or alter VIEW silver.vw_budget_source
AS
    WITH ranked AS
    (
        SELECT
            LTRIM(RTRIM(b.suppliercode))        AS suppliercode,
            b.period,
            UPPER(LTRIM(RTRIM(b.currencycode))) AS currencycode,
            b.budgetamountlocal,
            b.budgetnote,
            b.wbscode,
            b.costtype,
            b.budget_year,
            b.budget_month,
            b.budget_period,
            b.version,
            b.source_file,
            b.loaded_at,
            ROW_NUMBER() OVER (PARTITION BY LTRIM(RTRIM(b.suppliercode)), b.period
                            ORDER BY b.version DESC, b.loaded_at DESC, b._ingested_at DESC) AS rn
        FROM bronze.budget AS b
        WHERE NULLIF(LTRIM(RTRIM(b.suppliercode)), '') IS NOT NULL
        AND b.period IS NOT NULL
    )
    SELECT
        suppliercode, 
        period, 
        currencycode,
        budgetamountlocal, 
        budgetnote,
        wbscode, 
        costtype,
        budget_year,
        budget_month, 
        budget_period, 
        version, 
        source_file, 
        loaded_at,
        -- '~' marks NULL so that NULL and '' hash differently.
        -- Float uses style 3 (17 significant digits) so small amount changes are caught.
        -- HASHBYTES returns VARBINARY(8000); convert explicitly to the 32-byte column type.
        CONVERT(VARBINARY(32), HASHBYTES('SHA2_256', CONCAT_WS('|',
            ISNULL(currencycode, '~'),
            ISNULL(CONVERT(VARCHAR(30), budgetamountlocal, 3), '~'),
            ISNULL(budgetnote, '~'),
            ISNULL(CAST(budget_year  AS VARCHAR(20)), '~'),
            ISNULL(CAST(budget_month AS VARCHAR(20)), '~'),
            ISNULL(CONVERT(VARCHAR(10), budget_period, 23), '~'),
            ISNULL(CAST(version AS VARCHAR(20)), '~')
        ))) AS RowHash
    FROM ranked
    WHERE rn = 1;

GO