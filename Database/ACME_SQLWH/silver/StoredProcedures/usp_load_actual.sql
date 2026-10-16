/* =============================================================================
   Silver load (SCD Type 2): ACME_SQLWH.bronze.actual -> ACME_SQLWH.silver.actual
   Run in the ACME_SQLWH warehouse (workspace: ACME).

   Source columns (bronze.actual): Period, InvoiceNumber, InvoiceDate,
   PurchaseOrderNo, CurrencyCode, AmountLocal, Description, version, source_file,
   loaded_at, actual_year, actual_month, actual + _ingested_at/_source_system/_batch_id

   - Business key : InvoiceNumber (kept as-is, trimmed)
   - SupplierCode : derived = everything in InvoiceNumber before the first '-'
                    e.g. 'SUP001-000123' -> 'SUP001'. NULL if there is no '-'.
   - Surrogate key: ActualSK (BIGINT, assigned here, unique per version)
   - Tracked      : Period, InvoiceDate, PurchaseOrderNo, CurrencyCode, AmountLocal,
                    Description, version, actual_year, actual_month, actual.
                    A change to any of these closes the current row and inserts a new version.
   - Not tracked  : source_file, loaded_at (lineage only).
   - Duplicates   : if bronze has several rows for one invoice, the highest `version`
                    wins, then the latest loaded_at.
   - Deletes      : an invoice missing from bronze has its current row closed.
   - Intervals    : half-open [ValidFrom, ValidTo); current rows have ValidTo = 9999-12-31.
   - Re-runnable  : running twice with no bronze changes is a no-op.
   ============================================================================= */
CREATE or alter    PROCEDURE silver.usp_load_actual
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @batch_id  VARCHAR(36)  = CONVERT(VARCHAR(36), NEWID());
    DECLARE @load_ts   DATETIME2(6) = SYSUTCDATETIME();
    DECLARE @high_date DATETIME2(6) = '9999-12-31';
    DECLARE @expired_changed INT, @expired_deleted INT, @inserted INT;

    BEGIN TRANSACTION;

        -- 4a. Close current rows whose tracked attributes changed
        UPDATE silver.actual
        SET    ValidTo     = @load_ts,
               IsCurrent   = 0,
               _batch_id   = @batch_id,
               _updated_at = @load_ts
        WHERE  IsCurrent = 1
          AND  EXISTS (SELECT 1
                       FROM   silver.vw_actual_source AS s
                       WHERE  s.InvoiceNumber = silver.actual.InvoiceNumber
                         AND  s.RowHash      <> silver.actual.RowHash);
        SET @expired_changed = @@ROWCOUNT;

        -- 4b. Close current rows whose invoice no longer exists in bronze
        UPDATE silver.actual
        SET    ValidTo     = @load_ts,
               IsCurrent   = 0,
               _batch_id   = @batch_id,
               _updated_at = @load_ts
        WHERE  IsCurrent = 1
          AND  NOT EXISTS (SELECT 1
                           FROM   silver.vw_actual_source AS s
                           WHERE  s.InvoiceNumber = silver.actual.InvoiceNumber);
        SET @expired_deleted = @@ROWCOUNT;

        -- 4c. Insert new invoices and new versions of changed ones
        --     (anything in the source with no current row left after 4a)
        DECLARE @max_sk BIGINT = (SELECT ISNULL(MAX(ActualSK), 0) FROM silver.actual);

        INSERT INTO silver.actual
            (ActualSK, InvoiceNumber, SupplierCode, Period, InvoiceDate, PurchaseOrderNo,
             CurrencyCode, AmountLocal, Description, version, actual_year, actual_month,
             actual, source_file, loaded_at,wbscode, costtype,
             RowHash, ValidFrom, ValidTo, IsCurrent, _batch_id, _created_at, _updated_at)
        SELECT
            @max_sk + ROW_NUMBER() OVER (ORDER BY s.InvoiceNumber),
            s.InvoiceNumber, s.SupplierCode, s.Period, s.InvoiceDate, s.PurchaseOrderNo,
            s.CurrencyCode, s.AmountLocal, s.Description, s.version, s.actual_year, s.actual_month,
            s.actual, s.source_file, s.loaded_at,s.wbscode, s.costtype,
            s.RowHash, @load_ts, @high_date, 1, @batch_id, @load_ts, @load_ts
        FROM silver.vw_actual_source AS s
        WHERE NOT EXISTS (SELECT 1
                          FROM   silver.actual AS t
                          WHERE  t.InvoiceNumber = s.InvoiceNumber
                            AND  t.IsCurrent     = 1);
        SET @inserted = @@ROWCOUNT;

    COMMIT TRANSACTION;

    SELECT @batch_id        AS batch_id,
           @load_ts         AS load_ts,
           @inserted        AS rows_inserted,
           @expired_changed AS rows_expired_changed,
           @expired_deleted AS rows_expired_deleted;
END;
GO