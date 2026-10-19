/* =============================================================================
   Bronze load: ACME_LH.dbo.Actual  ->  ACME_SQLWH.Bronze.Actual
   Run in the ACME_SQLWH warehouse (workspace: ACME).

   Reads the lakehouse through its SQL analytics endpoint with a cross-database
   query. That works because both items are in the same workspace.
   Bronze = a raw copy of the source columns plus load-audit columns.
   Each run does a full reload (truncate + insert) so it is safe to re-run.
   ============================================================================= */
CREATE PROCEDURE Bronze.usp_Load_Actual
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @batch_id    VARCHAR(36)  = CONVERT(VARCHAR(36), NEWID());
    DECLARE @ingested_at DATETIME2(6) = SYSUTCDATETIME();

    BEGIN TRANSACTION;

        TRUNCATE TABLE Bronze.Actual;

        INSERT INTO Bronze.Actual
        (
            Period, 
            InvoiceNumber, 
            InvoiceDate, 
            PurchaseOrderNo, 
            CurrencyCode,
            AmountLocal, 
            Description, 
            WBSCode,
            CostType,
            Version, 
            Source_File, 
            Loaded_At,
            Actual_Year, 
            Actual_Month, 
            Actual,
            _Ingested_At, 
            _Source_System, 
            _Batch_Id
        )
        SELECT
            a.Period, 
            a.InvoiceNumber, 
            a.InvoiceDate, 
            a.PurchaseOrderNo, 
            a.CurrencyCode,
            a.AmountLocal, 
            a.Description, 
            a.WBSCode, 
            a.CostType,
            a.Version, 
            a.Source_File, 
            a.Loaded_At,
            a.Actual_Year, 
            a.Actual_Month, 
            a.Actual,
            @ingested_at, 
            'ACME_LH.dbo.Actual', 
            @batch_id
        FROM 
            ACME_LH.dbo.Actual AS a;

    COMMIT TRANSACTION;

    SELECT @batch_id AS batch_id, @ingested_at AS ingested_at,
           (SELECT COUNT(*) FROM Bronze.Actual) AS rows_loaded;
END;
GO