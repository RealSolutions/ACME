/* =============================================================================
   Bronze load: ACME_LH.dbo.budget  ->  ACME_SQLWH.bronze.budget
   Run in the ACME_SQLWH warehouse (workspace: ACME).

   Reads the lakehouse through its SQL analytics endpoint with a cross-database
   query. That works because both items are in the same workspace.
   Bronze = a raw copy of the source columns plus load-audit columns.
   Each run does a full reload (truncate + insert) so it is safe to re-run.
   ============================================================================= */
CREATE   PROCEDURE bronze.usp_load_budget
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @batch_id    VARCHAR(36)  = CONVERT(VARCHAR(36), NEWID());
    DECLARE @ingested_at DATETIME2(6) = SYSUTCDATETIME();

    BEGIN TRANSACTION;

        TRUNCATE TABLE bronze.budget;

        INSERT INTO bronze.budget
        (
            suppliercode, 
            period, 
            currencycode, 
            budgetamountlocal, 
            budgetnote,
            wbscode,
            costype,            
            budget_year, 
            budget_month, 
            budget_period, 
            version, 
            source_file, 
            loaded_at,
            _ingested_at, 
            _source_system, 
            _batch_id
        )
        SELECT
            b.suppliercode, 
            b.period, 
            b.currencycode,
            b.budgetamountlocal, 
            b.budgetnote,
            b.wbscode,
            b.costype,             
            b.budget_year, 
            b.budget_month, 
            b.budget_period, 
            b.version, 
            b.source_file, 
            b.loaded_at,
            @ingested_at, 
            'ACME_LH.dbo.budget', 
            @batch_id
        FROM 
            ACME_LH.dbo.budget AS b;

    COMMIT TRANSACTION;
        SELECT 
            @batch_id AS batch_id, 
            @ingested_at AS ingested_at,
            (SELECT COUNT(*) FROM bronze.budget) AS rows_loaded;
END;
GO