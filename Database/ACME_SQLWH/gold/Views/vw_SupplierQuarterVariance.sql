CREATE VIEW Gold.vw_SupplierQuarterVariance
AS
SELECT 
       SupplierSK, 
       SupplierCode, 
       SupplierName, 
       CurrencyCode,
       FiscalYearLabel, 
       FiscalQuarter, 
       FiscalQuarterLabel,
       SUM(BudgetLocal)      AS BudgetLocal,
       SUM(ActualLocal)      AS ActualLocal,
       SUM(VarianceLocal)    AS VarianceLocal,
       CAST(CASE WHEN SUM(BudgetLocal) = 0 THEN NULL
                 ELSE SUM(VarianceLocal) * 100.0 / SUM(BudgetLocal) END AS decimal(9,2)) AS VariancePct,
       SUM(BudgetGBP)        AS BudgetGBP,
       SUM(ActualGBP)        AS ActualGBP,
       SUM(VarianceGBP)      AS VarianceGBP,
       SUM(SpendVarianceGBP) AS SpendVarianceGBP,
       SUM(FxVarianceGBP)    AS FxVarianceGBP
FROM 
       Gold.vw_SupplierMonthVariance
GROUP BY 
       SupplierSK, 
       SupplierCode, 
       SupplierName, 
       CurrencyCode,
       FiscalYearLabel, 
       FiscalQuarter, 
       FiscalQuarterLabel;
GO
