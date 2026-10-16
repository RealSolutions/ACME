--TODO Header
CREATE or alter  PROCEDURE silver.usp_load_budget
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @batch_id  VARCHAR(36)  = CONVERT(VARCHAR(36), NEWID());
    DECLARE @load_ts   DATETIME2(6) = SYSUTCDATETIME();
    DECLARE @high_date DATETIME2(6) = '9999-12-31';
    DECLARE @expired_changed INT, @expired_deleted INT, @inserted INT;

    BEGIN TRANSACTION;

        -- 4a. Close current rows whose tracked attributes changed
        UPDATE silver.budget
        SET    ValidTo     = @load_ts,
               IsCurrent   = 0,
               _batch_id   = @batch_id,
               _updated_at = @load_ts
        WHERE  IsCurrent = 1
          AND  EXISTS (SELECT 1
                       FROM   silver.vw_budget_source AS s
                       WHERE  s.suppliercode = silver.budget.suppliercode
                         AND  s.period       = silver.budget.period
                         AND  s.RowHash     <> silver.budget.RowHash);
        SET @expired_changed = @@ROWCOUNT;

        -- 4b. Close current rows whose key no longer exists in bronze
        UPDATE silver.budget
        SET    ValidTo     = @load_ts,
               IsCurrent   = 0,
               _batch_id   = @batch_id,
               _updated_at = @load_ts
        WHERE  IsCurrent = 1
          AND  NOT EXISTS (SELECT 1
                           FROM   silver.vw_budget_source AS s
                           WHERE  s.suppliercode = silver.budget.suppliercode
                             AND  s.period       = silver.budget.period);
        SET @expired_deleted = @@ROWCOUNT;

        -- 4c. Insert new keys and new versions of changed ones
        --     (anything in the source with no current row left after 4a)
        DECLARE @max_sk BIGINT = (SELECT ISNULL(MAX(BudgetSK), 0) FROM silver.budget);

        INSERT INTO silver.budget
            (BudgetSK, suppliercode, period, currencycode, budgetamountlocal, budgetnote,
          wbscode,
            costtype,    
             budget_year, budget_month, budget_period, version, source_file, loaded_at,
             RowHash, ValidFrom, ValidTo, IsCurrent, _batch_id, _created_at, _updated_at)
        SELECT
            @max_sk + ROW_NUMBER() OVER (ORDER BY s.suppliercode, s.period),
            s.suppliercode, s.period, s.currencycode, s.budgetamountlocal, s.budgetnote,
                        s.wbscode,
            s.costtype,    
            s.budget_year, s.budget_month, s.budget_period, s.version, s.source_file, s.loaded_at,
            s.RowHash, @load_ts, @high_date, 1, @batch_id, @load_ts, @load_ts
        FROM silver.vw_budget_source AS s
        WHERE NOT EXISTS (SELECT 1
                          FROM   silver.budget AS t
                          WHERE  t.suppliercode = s.suppliercode
                            AND  t.period       = s.period
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