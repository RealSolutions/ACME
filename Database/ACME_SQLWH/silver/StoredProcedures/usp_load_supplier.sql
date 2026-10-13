CREATE   PROCEDURE silver.usp_load_supplier
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @batch_id  VARCHAR(36)  = CONVERT(VARCHAR(36), NEWID());
    DECLARE @load_ts   DATETIME2(6) = SYSUTCDATETIME();
    DECLARE @high_date DATETIME2(6) = '9999-12-31';
    DECLARE @expired_changed INT, @expired_deleted INT, @inserted INT;

    BEGIN TRANSACTION;

        -- 4a. Unknown member, so facts with no matching supplier can point at -1
        IF NOT EXISTS (SELECT 1 FROM silver.supplier WHERE SupplierSK = -1)
        INSERT INTO silver.supplier
        (
            SupplierSK, 
            SupplierCode,
            SupplierName,
            CountryName,
            CurrencyCode,
            SpendCategory,
            PaymentTermsDays,
            RowHash,
            ValidFrom,
            ValidTo,
            IsCurrent,
            _batch_id,
            _created_at,
            _updated_at
        )
        VALUES
        (
            -1, 
            'UNKNOWN', 
            'Unknown', 
            'Unknown', 
            'UNK', 
            'Unknown', 
            NULL,
            0x00, 
            '1900-01-01', 
            @high_date, 
            1, 
            @batch_id, 
            @load_ts, 
            @load_ts
        );

        -- 4b. Close current rows whose attributes changed
        UPDATE silver.supplier
        SET    ValidTo     = @load_ts,
               IsCurrent   = 0,
               _batch_id   = @batch_id,
               _updated_at = @load_ts
        WHERE  IsCurrent = 1
          AND  SupplierSK <> -1
          AND  EXISTS (SELECT 1
                       FROM   silver.vw_supplier_source AS s
                       WHERE  s.SupplierCode = silver.supplier.SupplierCode
                         AND  s.RowHash     <> silver.supplier.RowHash);
        SET @expired_changed = @@ROWCOUNT;

        -- 4c. Close current rows whose supplier no longer exists in bronze
        UPDATE silver.supplier
        SET    ValidTo     = @load_ts,
               IsCurrent   = 0,
               _batch_id   = @batch_id,
               _updated_at = @load_ts
        WHERE  IsCurrent = 1
          AND  SupplierSK <> -1
          AND  NOT EXISTS (SELECT 1
                           FROM   silver.vw_supplier_source AS s
                           WHERE  s.SupplierCode = silver.supplier.SupplierCode);
        SET @expired_deleted = @@ROWCOUNT;

        -- 4d. Insert new suppliers and new versions of changed ones
        --     (anything in the source with no current row left after 4b)
        DECLARE @max_sk BIGINT = (SELECT ISNULL(MAX(SupplierSK), 0) FROM silver.supplier);

        INSERT INTO silver.supplier
            (SupplierSK, SupplierCode, SupplierName, CountryName, CurrencyCode,
             SpendCategory, PaymentTermsDays,
             RowHash, ValidFrom, ValidTo, IsCurrent, _batch_id, _created_at, _updated_at)
        SELECT
            @max_sk + ROW_NUMBER() OVER (ORDER BY s.SupplierCode),
            s.SupplierCode, s.SupplierName, s.CountryName, s.CurrencyCode,
            s.SpendCategory, s.PaymentTermsDays,
            s.RowHash, @load_ts, @high_date, 1, @batch_id, @load_ts, @load_ts
        FROM silver.vw_supplier_source AS s
        WHERE NOT EXISTS (SELECT 1
                          FROM   silver.supplier AS t
                          WHERE  t.SupplierCode = s.SupplierCode
                            AND  t.IsCurrent = 1);
        SET @inserted = @@ROWCOUNT;

    COMMIT TRANSACTION;

    SELECT @batch_id        AS batch_id,
           @load_ts         AS load_ts,
           @inserted        AS rows_inserted,
           @expired_changed AS rows_expired_changed,
           @expired_deleted AS rows_expired_deleted;
END;
GO