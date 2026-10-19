/* =============================================================================
   Silver load (SCD Type 2): ACME_SQLWH.Bronze.Actual -> ACME_SQLWH.Silver.Actual
   Run in the ACME_SQLWH warehouse (workspace: ACME).

   Source columns (Bronze.Actual): Period, InvoiceNumber, InvoiceDate,
   PurchaseOrderNo, CurrencyCode, AmountLocal, Description, Version, source_file,
   loaded_at, Actual_year, Actual_month, Actual + _ingested_at/_source_system/_batch_id

   - Business key : InvoiceNumber (kept as-is, trimmed)
   - SupplierCode : derived = everything in InvoiceNumber before the first '-'
                    e.g. 'SUP001-000123' -> 'SUP001'. NULL if there is no '-'.
   - Surrogate key: ActualSK (BIGINT, assigned here, unique per Version)
   - Tracked      : Period, InvoiceDate, PurchaseOrderNo, CurrencyCode, AmountLocal,
                    Description, Version, Actual_year, Actual_month, Actual.
                    A change to any of these closes the current row and inserts a new Version.
   - Not tracked  : source_file, loaded_at (lineage only).
   - Duplicates   : if Bronze has several rows for one invoice, the highest `Version`
                    wins, then the latest loaded_at.
   - Deletes      : an invoice missing from Bronze has its current row closed.
   - Intervals    : half-open [ValidFrom, ValidTo); current rows have ValidTo = 9999-12-31.
   - Re-runnable  : running twice with no Bronze changes is a no-op.
   ============================================================================= */
CREATE PROCEDURE Silver.usp_Load_Actual
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @batch_id  VARCHAR(36)  = CONVERT(VARCHAR(36), NEWID());
    DECLARE @load_ts   DATETIME2(6) = SYSUTCDATETIME();
    DECLARE @high_date DATETIME2(6) = '9999-12-31';
    DECLARE @expired_changed INT, @expired_deleted INT, @inserted INT;

    BEGIN TRANSACTION;

        -- 4a. Close current rows whose tracked attributes changed
        UPDATE Silver.Actual
        SET    ValidTo     = @load_ts,
               IsCurrent   = 0,
               _Updated_At = @load_ts
        WHERE  IsCurrent = 1
          AND  EXISTS (SELECT 1
                       FROM   Silver.vw_Actual_Source AS s
                       WHERE  s.InvoiceNumber = Silver.Actual.InvoiceNumber
                         AND  s.RowHash      <> Silver.Actual.RowHash);
        SET @expired_changed = @@ROWCOUNT;

        -- 4b. Close current rows whose invoice no longer exists in Bronze
        UPDATE Silver.Actual
        SET    ValidTo     = @load_ts,
               IsCurrent   = 0,
               _Updated_At = @load_ts
        WHERE  IsCurrent = 1
          AND  NOT EXISTS (SELECT 1
                           FROM   Silver.vw_Actual_Source AS s
                           WHERE  s.InvoiceNumber = Silver.Actual.InvoiceNumber);
        SET @expired_deleted = @@ROWCOUNT;

        -- 4c. Insert new invoices and new Versions of changed ones
        --     (anything in the source with no current row left after 4a)
        DECLARE @max_sk BIGINT = (SELECT ISNULL(MAX(ActualSK), 0) FROM Silver.Actual);

        INSERT INTO Silver.Actual
        (
            ActualSK, 
            InvoiceNumber, 
            SupplierCode,
            Period,
            InvoiceDate,
            PurchaseOrderNo,
            CurrencyCode, 
            AmountLocal,
            Description,
            Version, 
            Actual_Year, 
            Actual_Month,
            Actual, 
            Source_File, 
            Loaded_At,
            WBSCode, 
            CostType,
            RowHash, 
            ValidFrom, 
            ValidTo, 
            IsCurrent, 
            _Created_At, 
            _Updated_At
        )
        SELECT
            @max_sk + ROW_NUMBER() OVER (ORDER BY s.InvoiceNumber),
            s.InvoiceNumber, 
            s.SupplierCode, 
            s.Period, 
            s.InvoiceDate, 
            s.PurchaseOrderNo,
            s.CurrencyCode, 
            s.AmountLocal, 
            s.Description, 
            s.Version, 
            s.Actual_Year, 
            s.Actual_Month,
            s.Actual, 
            s.Source_File, 
            s.Loaded_At,
            s.WBSCode, 
            s.CostType,
            s.RowHash, 
            @load_ts, 
            @high_date, 
            1,
            @load_ts, 
            @load_ts
        FROM Silver.vw_Actual_Source AS s
        WHERE NOT EXISTS (SELECT 1
                          FROM   Silver.Actual AS t
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