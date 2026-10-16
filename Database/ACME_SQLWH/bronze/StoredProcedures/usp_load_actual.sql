/* =============================================================================
   Bronze load: ACME_LH.dbo.actual  ->  ACME_SQLWH.bronze.actual
   Run in the ACME_SQLWH warehouse (workspace: ACME).

   Reads the lakehouse through its SQL analytics endpoint with a cross-database
   query. That works because both items are in the same workspace.
   Bronze = a raw copy of the source columns plus load-audit columns.
   Each run does a full reload (truncate + insert) so it is safe to re-run.
   ============================================================================= */
CREATE   PROCEDURE bronze.usp_load_actual
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @batch_id    VARCHAR(36)  = CONVERT(VARCHAR(36), NEWID());
    DECLARE @ingested_at DATETIME2(6) = SYSUTCDATETIME();

    BEGIN TRANSACTION;

        TRUNCATE TABLE bronze.actual;

        INSERT INTO bronze.actual
        (
            Period, 
            InvoiceNumber, 
            InvoiceDate, 
            PurchaseOrderNo, 
            CurrencyCode,
            AmountLocal, 
            Description, 
            wbscode, 
            costtype,
            version, 
            source_file, 
            loaded_at,
            actual_year, 
            actual_month, 
            actual,
            _ingested_at, 
            _source_system, 
            _batch_id
        )
        SELECT
            a.Period, 
            a.InvoiceNumber, 
            a.InvoiceDate, 
            a.PurchaseOrderNo, 
            a.CurrencyCode,
            a.AmountLocal, 
            a.Description, 
            a.wbscode, 
            a.costtype,
            a.version, 
            a.source_file, 
            a.loaded_at,
            a.actual_year, 
            a.actual_month, 
            a.actual,
            @ingested_at, 
            'ACME_LH.dbo.actual', 
            @batch_id
        FROM 
            ACME_LH.dbo.actual AS a;

    COMMIT TRANSACTION;

    SELECT @batch_id AS batch_id, @ingested_at AS ingested_at,
           (SELECT COUNT(*) FROM bronze.actual) AS rows_loaded;
END;
GO