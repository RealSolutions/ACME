/* =====================================================================
   SECTION B - BUDGET VS ACTUAL REPORTING
   ===================================================================== */

-- B1. Monthly budget vs actual per supplier, in supplier currency and GBP
SELECT 
   FiscalPeriodLabel, 
   SupplierName, 
   CurrencyCode,
   BudgetLocal, 
   ActualLocal,
   VarianceLocal,
   VariancePct,
   BudgetGBP, 
   ActualGBP, 
   VarianceGBP,
   VarianceStatus
FROM 
   gold.vw_SupplierMonthVariance
ORDER BY PeriodKey, SupplierSK;
GO

-- B2. One supplier, month by month, with running fiscal-YTD totals (change the name to drill in)
SELECT FiscalPeriodLabel, CurrencyCode,
       BudgetLocal, ActualLocal, VarianceLocal, VariancePct,
       SUM(BudgetLocal)   OVER (ORDER BY PeriodKey ROWS UNBOUNDED PRECEDING) AS YtdBudgetLocal,
       SUM(ActualLocal)   OVER (ORDER BY PeriodKey ROWS UNBOUNDED PRECEDING) AS YtdActualLocal,
       SUM(VarianceLocal) OVER (ORDER BY PeriodKey ROWS UNBOUNDED PRECEDING) AS YtdVarianceLocal
FROM 
   gold.vw_SupplierMonthVariance
WHERE SupplierName = 'Donald Duck Drives GmbH'
ORDER BY PeriodKey;
GO

-- B3. Company total per month in GBP, with fiscal YTD
SELECT FiscalPeriodLabel, FiscalQuarterLabel,
       SUM(BudgetGBP)   AS BudgetGBP,
       SUM(ActualGBP)   AS ActualGBP,
       SUM(VarianceGBP) AS VarianceGBP,
       CAST(SUM(VarianceGBP) * 100.0 / NULLIF(SUM(BudgetGBP), 0) AS decimal(9,2)) AS VariancePct,
       SUM(SUM(BudgetGBP)) OVER (ORDER BY PeriodKey ROWS UNBOUNDED PRECEDING) AS YtdBudgetGBP,
       SUM(SUM(ActualGBP)) OVER (ORDER BY PeriodKey ROWS UNBOUNDED PRECEDING) AS YtdActualGBP
FROM 
   gold.vw_SupplierMonthVariance
GROUP BY PeriodKey, FiscalPeriodLabel, FiscalQuarterLabel
ORDER BY PeriodKey;
GO

-- B4. Fiscal quarter per supplier (supplier currency and GBP)
SELECT FiscalQuarterLabel, SupplierName, CurrencyCode,
       BudgetLocal, ActualLocal, VarianceLocal, VariancePct,
       BudgetGBP, ActualGBP, VarianceGBP
FROM gold.vw_SupplierQuarterVariance
ORDER BY FiscalQuarter, SupplierSK;
GO

-- B5. Supplier x quarter variance matrix in GBP (one row per supplier)
SELECT SupplierName, CurrencyCode,
       SUM(CASE WHEN FiscalQuarter = 1 THEN VarianceGBP END) AS Q1_VarianceGBP,
       SUM(CASE WHEN FiscalQuarter = 2 THEN VarianceGBP END) AS Q2_VarianceGBP,
       SUM(CASE WHEN FiscalQuarter = 3 THEN VarianceGBP END) AS Q3_VarianceGBP,
       SUM(VarianceGBP)                                      AS YTD_VarianceGBP,
       CAST(SUM(VarianceGBP) * 100.0 / NULLIF(SUM(BudgetGBP), 0) AS decimal(9,2)) AS YTD_VariancePct
FROM gold.vw_SupplierQuarterVariance
GROUP BY SupplierSK, SupplierName, CurrencyCode
ORDER BY SupplierSK;
GO

-- B6. Supplier x month variance % matrix in supplier currency (heat-map style)
SELECT SupplierName, CurrencyCode,
       MAX(CASE WHEN CalendarMonth = 4  THEN VariancePct END) AS Apr,
       MAX(CASE WHEN CalendarMonth = 5  THEN VariancePct END) AS May,
       MAX(CASE WHEN CalendarMonth = 6  THEN VariancePct END) AS Jun,
       MAX(CASE WHEN CalendarMonth = 7  THEN VariancePct END) AS Jul,
       MAX(CASE WHEN CalendarMonth = 8  THEN VariancePct END) AS Aug,
       MAX(CASE WHEN CalendarMonth = 9  THEN VariancePct END) AS Sep,
       MAX(CASE WHEN CalendarMonth = 10 THEN VariancePct END) AS Oct,
       MAX(CASE WHEN CalendarMonth = 11 THEN VariancePct END) AS Nov,
       MAX(CASE WHEN CalendarMonth = 12 THEN VariancePct END) AS Dec
FROM gold.vw_SupplierMonthVariance
WHERE CalendarYear = 2026
GROUP BY SupplierSK, SupplierName, CurrencyCode
ORDER BY SupplierSK;
GO

-- B7. Quarter totals in GBP with the FX bridge: how much of the variance is spend vs currency movement
SELECT FiscalQuarterLabel,
       SUM(BudgetGBP)        AS BudgetGBP,
       SUM(SpendVarianceGBP) AS SpendVarianceGBP,   -- more/less bought, at budget rate
       SUM(FxVarianceGBP)    AS FxVarianceGBP,      -- rate movement on what was bought
       SUM(ActualGBP)        AS ActualGBP,
       SUM(VarianceGBP)      AS TotalVarianceGBP
FROM gold.vw_SupplierQuarterVariance
GROUP BY FiscalQuarter, FiscalQuarterLabel
ORDER BY FiscalQuarter;
GO

-- B8. FX impact by currency and quarter (GBP suppliers always show 0)
SELECT CurrencyCode, FiscalQuarterLabel,
       SUM(ActualLocal)   AS ActualLocal,
       SUM(FxVarianceGBP) AS FxVarianceGBP
FROM gold.vw_SupplierQuarterVariance
GROUP BY CurrencyCode, FiscalQuarter, FiscalQuarterLabel
ORDER BY CurrencyCode, FiscalQuarter;
GO

-- B9. Exceptions: supplier-months more than 10% off budget, or unbudgeted / missing invoices
SELECT 
   FiscalPeriodLabel, 
   SupplierName, 
   CurrencyCode,
   BudgetLocal,
   ActualLocal, 
   VarianceLocal, 
   VariancePct, 
   VarianceGBP, 
   VarianceStatus
FROM 
   gold.vw_SupplierMonthVariance
WHERE ABS(VariancePct) > 10
   OR IsUnbudgeted = 1
   OR (BudgetLocal > 0 AND InvoiceCount = 0)
ORDER BY ABS(VarianceGBP) DESC;
GO

-- B10. Top 5 suppliers by fiscal-YTD overspend in GBP
SELECT TOP (5)
       SupplierName, CurrencyCode,
       SUM(BudgetGBP)   AS YtdBudgetGBP,
       SUM(ActualGBP)   AS YtdActualGBP,
       SUM(VarianceGBP) AS YtdVarianceGBP
FROM 
   gold.vw_SupplierMonthVariance
GROUP BY SupplierName, CurrencyCode
ORDER BY SUM(VarianceGBP) DESC;
GO

-- B11. Spend category view, fiscal YTD in GBP
SELECT SpendCategory,
       SUM(BudgetGBP)   AS BudgetGBP,
       SUM(ActualGBP)   AS ActualGBP,
       SUM(VarianceGBP) AS VarianceGBP,
       CAST(SUM(VarianceGBP) * 100.0 / NULLIF(SUM(BudgetGBP), 0) AS decimal(9,2)) AS VariancePct
FROM 
   gold.vw_SupplierMonthVariance
GROUP BY SpendCategory
ORDER BY VarianceGBP DESC;
GO

-- B12. Invoice drill-through for one supplier-month (e.g. the Nov-26 Simba Robotics spike)
SELECT 
   a.InvoiceNumber, 
   a.InvoiceDate, 
   a.PurchaseOrderNo, 
   a.CurrencyCode, 
   a.AmountLocal,
   r.RateToGBP AS ActualRateToGBP,
   CAST(ROUND(a.AmountLocal * r.RateToGBP, 2) AS decimal(19,2)) AS AmountGBP,
   a.Description
FROM 
   gold.factactual a
JOIN gold.dimsupplier s       ON s.SupplierSK = a.SupplierSK
JOIN gold.factexchangerate r  ON r.CurrencyCode = a.CurrencyCode AND r.PeriodKey = a.PeriodKey AND r.RateType = 'ACTUAL'
WHERE 
   s.SupplierName = 'Simba Robotics K.K.' AND a.PeriodKey = 202611
ORDER BY a.InvoiceDate;
GO