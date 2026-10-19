/* =============================================================================
   Bronze load: ACME_LH.dbo.Budget  ->  ACME_SQLWH.Bronze.Budget
   Run in the ACME_SQLWH warehouse (workspace: ACME).

   Reads the lakehouse through its SQL analytics endpoint with a cross-database
   query. That works because both items are in the same workspace.
   Bronze = a raw copy of the source columns plus load-audit columns.
   Each run does a full reload (truncate + insert) so it is safe to re-run.
   ============================================================================= */
CREATE PROCEDURE Bronze.usp_Load_Budget
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @batch_id    VARCHAR(36)  = CONVERT(VARCHAR(36), NEWID());
    DECLARE @ingested_at DATETIME2(6) = SYSUTCDATETIME();

    BEGIN TRANSACTION;

        TRUNCATE TABLE Bronze.Budget;

        INSERT INTO Bronze.Budget
        (
            SupplierCode, 
            Period, 
            CurrencyCode, 
            BudgetAmountLocal, 
            BudgetNote,         
            Budget_Year, 
            Budget_Month, 
            Budget_Period,
            WBSCode,
            CostType,                
            Version, 
            Source_File, 
            Loaded_At,
            _Ingested_At, 
            _Source_System, 
            _Batch_Id
        )
        SELECT
            b.SupplierCode, 
            b.Period, 
            b.CurrencyCode,
            b.BudgetAmountLocal, 
            b.BudgetNote,          
            b.Budget_Year, 
            b.Budget_Month, 
            b.Budget_Period, 
            b.WBSCode,
            b.CostType,               
            b.Version, 
            b.Source_File, 
            b.Loaded_At,
            @ingested_at, 
            'ACME_LH.dbo.Budget', 
            @batch_id
        FROM 
            ACME_LH.dbo.Budget AS b;

    COMMIT TRANSACTION;
        SELECT 
            @batch_id AS batch_id, 
            @ingested_at AS ingested_at,
            (SELECT COUNT(*) FROM Bronze.Budget) AS rows_loaded;
END;
GO