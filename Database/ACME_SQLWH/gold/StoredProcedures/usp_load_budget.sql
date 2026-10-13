CREATE   PROCEDURE gold.usp_load_budget
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @loaded_at DATETIME2(6) = SYSUTCDATETIME();

    BEGIN TRANSACTION;

        TRUNCATE TABLE gold.budget;

        WITH budget AS
        (
            -- current budget lines with a usable period date
            SELECT
                b.*,
                COALESCE(b.budget_period,
                         CASE WHEN b.budget_year BETWEEN 1900 AND 9999
                               AND b.budget_month BETWEEN 1 AND 12
                              THEN DATEFROMPARTS(b.budget_year, b.budget_month, 1) END
                ) AS period_date
            FROM silver.budget AS b
            WHERE b.IsCurrent = 1
        ),
        candidates AS
        (
            -- every supplier version with the same code, ranked best match first
            SELECT
                b.BudgetSK,
                s.SupplierSK,
                CASE WHEN b.period_date >= CAST(s.ValidFrom AS DATE)
                      AND b.period_date <  CAST(s.ValidTo   AS DATE)
                     THEN 'PointInTime' ELSE 'Nearest' END AS match_type,
                ROW_NUMBER() OVER
                (
                    PARTITION BY b.BudgetSK
                    ORDER BY
                        -- 1. a version that covers the period date
                        CASE WHEN b.period_date >= CAST(s.ValidFrom AS DATE)
                              AND b.period_date <  CAST(s.ValidTo   AS DATE)
                             THEN 0 ELSE 1 END,
                        -- 2. otherwise the version closest in time to the period date
                        ISNULL(CASE WHEN b.period_date < CAST(s.ValidFrom AS DATE)
                                    THEN DATEDIFF(DAY, b.period_date, CAST(s.ValidFrom AS DATE))
                                    ELSE DATEDIFF(DAY, CAST(s.ValidTo AS DATE), b.period_date)
                               END, 0),
                        -- 3. tie-break: current version, then most recent
                        s.IsCurrent DESC,
                        s.ValidFrom DESC
                ) AS rn
            FROM budget AS b
            INNER JOIN gold.supplier AS s
                ON  s.SupplierCode = b.suppliercode
                AND s.SupplierSK  <> -1
        )
        INSERT INTO gold.budget
        (
            BudgetSK, SupplierSK, SupplierCode, Period, PeriodDate, BudgetYear, BudgetMonth,
            CurrencyCode, BudgetAmountLocal, BudgetNote, BudgetVersion,
            SupplierMatchType, _loaded_at
        )
        SELECT
            b.BudgetSK,
            ISNULL(c.SupplierSK, -1),
            b.suppliercode,
            b.period,
            b.period_date,
            b.budget_year,
            b.budget_month,
            ISNULL(NULLIF(b.currencycode, ''), 'UNK'),
            CAST(b.budgetamountlocal AS DECIMAL(19,4)),
            b.budgetnote,
            b.version,
            ISNULL(c.match_type, 'Unknown'),
            @loaded_at
        FROM budget AS b
        LEFT JOIN candidates AS c
            ON  c.BudgetSK = b.BudgetSK
            AND c.rn = 1;

    COMMIT TRANSACTION;

    SELECT @loaded_at AS loaded_at,
           COUNT(*)                                                      AS rows_loaded,
           SUM(CASE WHEN SupplierMatchType = 'PointInTime' THEN 1 ELSE 0 END) AS matched_point_in_time,
           SUM(CASE WHEN SupplierMatchType = 'Nearest'     THEN 1 ELSE 0 END) AS matched_nearest,
           SUM(CASE WHEN SupplierMatchType = 'Unknown'     THEN 1 ELSE 0 END) AS unknown_supplier
    FROM gold.budget;
END;
GO