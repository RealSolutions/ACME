--TODO Header
CREATE   PROCEDURE Silver.usp_Load_Supplier
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @batch_id  VARCHAR(36)  = CONVERT(VARCHAR(36), NEWID());
    DECLARE @load_ts   DATETIME2(6) = SYSUTCDATETIME();
    DECLARE @high_date DATETIME2(6) = '9999-12-31';
    DECLARE @expired_changed INT, @expired_deleted INT, @inserted INT;

    BEGIN TRANSACTION;

        -- 4a. Unknown member, so Facts with no matching Supplier can point at -1
        IF NOT EXISTS (SELECT 1 FROM Silver.Supplier WHERE SupplierSK = -1)
        INSERT INTO Silver.Supplier
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
            _Batch_Id,
            _Created_At,
            _Updated_At
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
        UPDATE Silver.Supplier
        SET    ValidTo     = @load_ts,
               IsCurrent   = 0,
               _Batch_Id   = @batch_id,
               _Updated_At = @load_ts
        WHERE  IsCurrent = 1
          AND  SupplierSK <> -1
          AND  EXISTS (SELECT 1
                       FROM   Silver.vw_Supplier_Source AS s
                       WHERE  s.SupplierCode = Silver.Supplier.SupplierCode
                         AND  s.RowHash     <> Silver.Supplier.RowHash);
        SET @expired_changed = @@ROWCOUNT;

        -- 4c. Close current rows whose Supplier no longer exists in Bronze
        UPDATE Silver.Supplier
        SET    ValidTo     = @load_ts,
               IsCurrent   = 0,
               _Batch_Id   = @batch_id,
               _Updated_At = @load_ts
        WHERE  IsCurrent = 1
          AND  SupplierSK <> -1
          AND  NOT EXISTS (SELECT 1
                           FROM   Silver.vw_Supplier_Source AS s
                           WHERE  s.SupplierCode = Silver.Supplier.SupplierCode);
        SET @expired_deleted = @@ROWCOUNT;

        -- 4d. Insert new Suppliers and new Versions of changed ones
        --     (anything in the source with no current row left after 4b)
        DECLARE @max_sk BIGINT = (SELECT ISNULL(MAX(SupplierSK), 0) FROM Silver.Supplier);

        INSERT INTO Silver.Supplier
            (SupplierSK, 
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
             _Batch_Id, 
             _Created_At, 
             _Updated_At)
        SELECT
            @max_sk + ROW_NUMBER() OVER (ORDER BY s.SupplierCode),
            s.SupplierCode, 
            s.SupplierName, 
            s.CountryName, 
            s.CurrencyCode,
            s.SpendCategory,
            s.PaymentTermsDays,
            s.RowHash, 
            @load_ts, 
            @high_date, 
            1, @batch_id, 
            @load_ts, 
            @load_ts
        FROM 
        Silver.vw_Supplier_Source AS s
        WHERE NOT EXISTS (SELECT 1
                          FROM   Silver.Supplier AS t
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