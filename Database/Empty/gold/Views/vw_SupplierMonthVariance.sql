/*
    SELECT * FROM gold.vw_SupplierMonthVariance
*/
/*
CREATE OR ALTER VIEW gold.vw_SupplierMonthVariance
AS
WITH bud AS
(
    SELECT 
        SupplierSK, 
        PeriodKey, 
        SUM(BudgetAmountLocal) AS BudgetLocal
    FROM 
        gold.factbudget
    GROUP BY 
        SupplierSK,
        PeriodKey
),
act AS
(
    SELECT 
        SupplierSK, 
        PeriodKey, 
        SUM(AmountLocal) AS ActualLocal, 
        COUNT(*) AS InvoiceCount
    FROM 
        gold.factactual
    GROUP BY 
        SupplierSK, 
        PeriodKey
),
grid AS   -- full outer join keeps unbudgeted spend AND budgets with no invoices
(
    SELECT COALESCE(b.SupplierSK, a.SupplierSK) AS SupplierSK,
           COALESCE(b.PeriodKey,   a.PeriodKey)   AS PeriodKey,
           COALESCE(b.BudgetLocal, 0)             AS BudgetLocal,
           COALESCE(a.ActualLocal, 0)             AS ActualLocal,
           COALESCE(a.InvoiceCount, 0)            AS InvoiceCount,
           CASE WHEN b.SupplierSK IS NULL THEN 1 ELSE 0 END AS IsUnbudgeted
    FROM bud b
    FULL OUTER JOIN act a
      ON a.SupplierSK = b.SupplierSK
     AND a.PeriodKey   = b.PeriodKey
),
conv AS
(
    SELECT
        g.SupplierSK,
        g.PeriodKey,
        g.BudgetLocal,
        g.ActualLocal,
        g.InvoiceCount,
        g.IsUnbudgeted,

        s.SupplierCode,
        s.SupplierName, 
        s.CurrencyCode, 
        s.SpendCategory, 
        s.CountryName,
        rb.RateToGBP AS BudgetRate,
        COALESCE(ra.RateToGBP, rb.RateToGBP) AS ActualRate,   -- no actual rate yet (future month) -> budget rate
        CAST(ROUND(g.BudgetLocal * rb.RateToGBP, 2) AS decimal(19,2)) AS BudgetGBP,
        CAST(ROUND(g.ActualLocal * COALESCE(ra.RateToGBP, rb.RateToGBP), 2) AS decimal(19,2)) AS ActualGBP,
        CAST(ROUND(g.ActualLocal * rb.RateToGBP, 2) AS decimal(19,2)) AS ActualAtBudgetRateGBP
    FROM 
        grid g
    JOIN gold.dimsupplier s       ON s.SupplierSK = g.SupplierSK
    JOIN gold.factexchangerate rb ON rb.CurrencyCode = s.CurrencyCode AND rb.PeriodKey = g.PeriodKey AND rb.RateType = 'BUDGET'
    LEFT JOIN gold.factexchangerate ra ON ra.CurrencyCode = s.CurrencyCode AND ra.PeriodKey = g.PeriodKey AND ra.RateType = 'ACTUAL'
)
SELECT 
    c.SupplierSK, 
    c.SupplierCode, 
    c.SupplierName, 
    c.CountryName, 
    c.SpendCategory, 
    c.CurrencyCode,
    p.PeriodKey, 
    p.PeriodStartDate, 
    p.MonthShort, 
    p.CalendarYear, 
    p.CalendarMonth,
    p.FiscalYearLabel, 
    p.FiscalMonthNumber, 
    p.FiscalQuarter, 
    p.FiscalQuarterLabel, 
    p.FiscalPeriodLabel,
    c.InvoiceCount, 
    c.IsUnbudgeted,
    -- supplier (local) currency
    c.BudgetLocal,
    c.ActualLocal,
    c.ActualLocal - c.BudgetLocal                                         AS VarianceLocal,
    CAST(CASE WHEN c.BudgetLocal = 0 THEN NULL
                 ELSE (c.ActualLocal - c.BudgetLocal) * 100.0 / c.BudgetLocal END AS decimal(9,2)) AS VariancePct,
       -- reporting currency (GBP)
       c.BudgetRate, c.ActualRate,
       c.BudgetGBP,
       c.ActualGBP,
       c.ActualGBP - c.BudgetGBP                                             AS VarianceGBP,
       c.ActualAtBudgetRateGBP - c.BudgetGBP                                 AS SpendVarianceGBP,
       c.ActualGBP - c.ActualAtBudgetRateGBP                                 AS FxVarianceGBP,
       CASE WHEN c.BudgetLocal = 0 AND c.ActualLocal > 0 THEN 'Unbudgeted'
            WHEN c.ActualLocal > c.BudgetLocal * 1.05     THEN 'Over budget'
            WHEN c.ActualLocal < c.BudgetLocal * 0.95     THEN 'Under budget'
            ELSE 'On budget (+/-5%)' END                                     AS VarianceStatus
    FROM conv c
    JOIN gold.dimperiod p ON p.PeriodKey = c.PeriodKey;
GO
*/