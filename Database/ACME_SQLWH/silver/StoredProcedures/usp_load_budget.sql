--TODO Header
CREATE  PROCEDURE Silver.usp_Load_Budget
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @batch_id  VARCHAR(36)  = CONVERT(VARCHAR(36), NEWID());
    DECLARE @load_ts   DATETIME2(6) = SYSUTCDATETIME();
    DECLARE @high_date DATETIME2(6) = '9999-12-31';
    DECLARE @expired_changed INT, @expired_deleted INT, @inserted INT;

    BEGIN TRANSACTION;

        -- 4a. Close current rows whose tracked attributes changed
        UPDATE Silver.Budget
        SET    ValidTo     = @load_ts,
               IsCurrent   = 0,
               _Batch_Id   = @batch_id,
               _Updated_At = @load_ts
        WHERE  IsCurrent = 1
          AND  EXISTS (SELECT 1
                       FROM   Silver.vw_Budget_Source AS s
                       WHERE  s.SupplierCode = Silver.Budget.SupplierCode
                         AND  s.Period       = Silver.Budget.Period
                         AND  s.RowHash     <> Silver.Budget.RowHash);
        SET @expired_changed = @@ROWCOUNT;

        -- 4b. Close current rows whose key no longer exists in Bronze
        UPDATE Silver.Budget
        SET    ValidTo     = @load_ts,
               IsCurrent   = 0,
               _Batch_Id   = @batch_id,
               _Updated_At = @load_ts
        WHERE  IsCurrent = 1
          AND  NOT EXISTS (SELECT 1
                           FROM   Silver.vw_Budget_Source AS s
                           WHERE  s.SupplierCode = Silver.Budget.SupplierCode
                             AND  s.Period       = Silver.Budget.Period);
        SET @expired_deleted = @@ROWCOUNT;

        -- 4c. Insert new keys and new Versions of changed ones
        --     (anything in the source with no current row left after 4a)
        DECLARE @max_sk BIGINT = (SELECT ISNULL(MAX(BudgetSK), 0) FROM Silver.Budget);

        INSERT INTO Silver.Budget
        (
          BudgetSK, 
          SupplierCode, 
          Period, 
          CurrencyCode, 
          BudgetAmountLocal, 
          BudgetNote,
          WBSCode,
          CostType,    
          Budget_Year, 
          Budget_Month, 
          Budget_Period, 
          Version, 
          Source_File, 
          Loaded_At,
          RowHash, 
          ValidFrom, 
          ValidTo, 
          IsCurrent, 
          _Batch_Id, 
          _Created_At, 
          _Updated_At
    )
        SELECT
            @max_sk + ROW_NUMBER() OVER (ORDER BY s.SupplierCode, s.Period),
            s.SupplierCode, 
            s.Period, 
            s.CurrencyCode, 
            s.BudgetAmountLocal, 
            s.BudgetNote,
            s.WBSCode,
            s.CostType,    
            s.Budget_Year, 
            s.Budget_Month, 
            s.Budget_Period, 
            s.Version, 
            s.Source_File, 
            s.Loaded_At,
            s.RowHash, 
            @load_ts, 
            @high_date, 
            1, 
            @batch_id, 
            @load_ts, 
            @load_ts
        FROM Silver.vw_Budget_Source AS s
        WHERE NOT EXISTS (SELECT 1
                          FROM   Silver.Budget AS t
                          WHERE  t.SupplierCode = s.SupplierCode
                            AND  t.Period       = s.Period
                            AND  t.IsCurrent    = 1);
        SET @inserted = @@ROWCOUNT;

    COMMIT TRANSACTION;

    SELECT @batch_id        AS batch_id,
           @load_ts         AS load_ts,
           @inserted        AS rows_inserted,
           @expired_changed AS rows_expired_changed,
           @expired_deleted AS rows_expired_deleted;
END;
GO