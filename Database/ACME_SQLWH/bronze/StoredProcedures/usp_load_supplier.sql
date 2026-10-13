/* =============================================================================
   Bronze load: ACME_LH.dbo.supplier  ->  ACME_SQLWH.bronze.supplier
   Run in the ACME_SQLWH warehouse (workspace: ACME).

   Reads the lakehouse through its SQL analytics endpoint with a cross-database
   query. That works because both items are in the same workspace.
   Bronze = a raw copy of the source columns plus load-audit columns.
   Each run does a full reload (truncate + insert) so it is safe to re-run.
   ============================================================================= */
CREATE   PROCEDURE bronze.usp_load_supplier
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @batch_id    VARCHAR(36)  = CONVERT(VARCHAR(36), NEWID());
    DECLARE @ingested_at DATETIME2(6) = SYSUTCDATETIME();

    BEGIN TRANSACTION;

        TRUNCATE TABLE bronze.supplier;

        INSERT INTO bronze.supplier
        (
            SupplierCode, 
            SupplierName, 
            CountryName, 
            CurrencyCode,
            SpendCategory, 
            PaymentTermsDays, 
            _ingested_at, 
            _source_system, 
            _batch_id
        )
        SELECT
            s.SupplierCode, 
            s.SupplierName, 
            s.CountryName, 
            s.CurrencyCode,
            s.SpendCategory, 
            s.PaymentTermsDays, 
            @ingested_at, 
            'ACME_LH.dbo.supplier', 
            @batch_id
        FROM ACME_LH.dbo.supplier AS s;

    COMMIT TRANSACTION;
        SELECT @batch_id AS batch_id, @ingested_at AS ingested_at,
           (SELECT COUNT(*) FROM bronze.supplier) AS rows_loaded;
END;
GO