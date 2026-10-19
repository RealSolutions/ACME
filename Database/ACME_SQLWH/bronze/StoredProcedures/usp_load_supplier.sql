/* =============================================================================
   Bronze load: ACME_LH.dbo.Supplier  ->  ACME_SQLWH.Bronze.Supplier
   Run in the ACME_SQLWH warehouse (workspace: ACME).

   Reads the lakehouse through its SQL analytics endpoint with a cross-database
   query. That works because both items are in the same workspace.
   Bronze = a raw copy of the source columns plus load-audit columns.
   Each run does a full reload (truncate + insert) so it is safe to re-run.
   ============================================================================= */
CREATE   PROCEDURE Bronze.usp_Load_Supplier
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @batch_id    VARCHAR(36)  = CONVERT(VARCHAR(36), NEWID());
    DECLARE @ingested_at DATETIME2(6) = SYSUTCDATETIME();

    BEGIN TRANSACTION;

        TRUNCATE TABLE Bronze.Supplier;

        INSERT INTO Bronze.Supplier
        (
            SupplierCode, 
            SupplierName, 
            CountryName, 
            CurrencyCode,
            SpendCategory, 
            PaymentTermsDays, 

            _Ingested_At, 
            _Source_System, 
            _Batch_Id
        )
        SELECT
            s.SupplierCode, 
            s.SupplierName, 
            s.CountryName, 
            s.CurrencyCode,
            s.SpendCategory, 
            s.PaymentTermsDays, 

            @ingested_at, 
            'ACME_LH.dbo.Supplier', 
            @batch_id
        FROM 
        ACME_LH.dbo.Supplier AS s;

    COMMIT TRANSACTION;
        SELECT @batch_id AS batch_id, @ingested_at AS ingested_at,
           (SELECT COUNT(*) FROM Bronze.Supplier) AS rows_loaded;
END;
GO