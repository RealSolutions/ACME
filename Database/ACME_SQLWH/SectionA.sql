/* =====================================================================
   ACME Industries - Supplier Spend: Budget vs Actual
   03_sample_queries.sql   (SQL Server and Microsoft Fabric Warehouse)

   Section A - verify the data model and test data (every check should PASS)
   Section B - budget vs actual reporting: month, quarter, YTD, FX
   Variance = Actual - Budget  (positive = overspend)
   ===================================================================== */


/* =====================================================================
   SECTION A - DATA MODEL & TEST DATA VERIFICATION
   ===================================================================== */

-- A1. Row counts vs expected
SELECT t.TableName, t.ActualRows, e.ExpectedRows,
       CASE WHEN t.ActualRows = e.ExpectedRows THEN 'PASS' ELSE 'FAIL' END AS Result
FROM (
    SELECT 
        'gold.dimcurrency' AS TableName, 
        COUNT(*) AS ActualRows 
    FROM
        gold.dimcurrency
    UNION ALL SELECT 'gold.dimperiod',        COUNT(*) FROM gold.dimperiod
    UNION ALL SELECT 'gold.dimsupplier',      COUNT(*) FROM gold.dimsupplier
    UNION ALL SELECT 'gold.factexchangerate', COUNT(*) FROM gold.factexchangerate
    UNION ALL SELECT 'gold.factbudget',       COUNT(*) FROM gold.factbudget
    UNION ALL SELECT 'gold.factactual',  COUNT(*) FROM gold.factactual
) t
JOIN 
(
    VALUES 
        ('gold.DimCurrency', 3), 
        ('gold.DimPeriod', 12), 
        ('gold.dimsupplier', 12),
        ('gold.FactExchangeRate', 63), 
        ('gold.factbudget', 107), 
        ('gold.factactual', 214)
) e (TableName, ExpectedRows) ON e.TableName = t.TableName;
GO 

-- A2. Suppliers per currency (expect GBP 5, EUR 4, JPY 3)
SELECT CurrencyCode, 
    COUNT(*) AS Suppliers,
    STRING_AGG(SupplierName, ', ') AS SupplierNames
FROM 
    gold.dimsupplier
GROUP BY 
    CurrencyCode
ORDER BY 
    CurrencyCode;
GO

-- A3. Referential integrity (essential on Fabric, where FKs are NOT ENFORCED). Expect 0 for every check.
SELECT 'Budget -> Supplier' AS CheckName, COUNT(*) AS Orphans
FROM gold.factbudget f LEFT JOIN gold.dimsupplier d ON d.SupplierSK = f.SupplierSK WHERE d.SupplierSK IS NULL
UNION ALL
SELECT 'Budget -> Period', COUNT(*)
FROM gold.factbudget f LEFT JOIN gold.dimperiod d ON d.PeriodKey = f.PeriodKey WHERE d.PeriodKey IS NULL
UNION ALL
SELECT 'Actual -> Supplier', COUNT(*)
FROM gold.factactual f LEFT JOIN gold.dimsupplier d ON d.SupplierSK = f.SupplierSK WHERE d.SupplierSK IS NULL
UNION ALL
SELECT 'Actual -> Period', COUNT(*)
FROM gold.factactual f LEFT JOIN gold.dimperiod d ON d.PeriodKey = f.PeriodKey WHERE d.PeriodKey IS NULL
UNION ALL
SELECT 'Supplier -> Currency', COUNT(*)
FROM gold.dimsupplier f LEFT JOIN gold.dimcurrency d ON d.CurrencyCode = f.CurrencyCode WHERE d.CurrencyCode IS NULL;
GO




-- A4. Uniqueness (keys are not enforced on Fabric). Expect no rows.
SELECT 
    'Duplicate budget supplier-month' AS Issue, 
    SupplierSK, 
    PeriodKey, 
    COUNT(*) AS Cnt
FROM    
    gold.factbudget 
GROUP BY 
    SupplierSK, 
    PeriodKey 
    HAVING COUNT(*) > 1
UNION ALL
SELECT 
    'Duplicate invoice number', 
    SupplierSK, 
    NULL, 
    COUNT(*)
FROM 
    gold.factactual 
GROUP BY
    SupplierSK, 
    InvoiceNumber 
    HAVING COUNT(*) > 1;
GO

-- A5. Fact currency must equal the supplier's invoicing currency. Expect 0.
SELECT 
    'Budget' AS FactTable, 
    COUNT(*) AS Mismatches
FROM 
    gold.factbudget f JOIN gold.dimsupplier s ON s.SupplierSK = f.SupplierSK
WHERE 
    f.CurrencyCode <> s.CurrencyCode
UNION ALL
SELECT 
    'Actual', COUNT(*)
FROM 
    gold.factactual f JOIN gold.dimsupplier s ON s.SupplierSK = f.SupplierSK
WHERE 
    f.CurrencyCode <> s.CurrencyCode;
GO

-- A6. Invoice date must fall inside its PeriodKey month. Expect 0.
SELECT 
    COUNT(*) AS InvoicesOutsidePeriod
FROM 
    gold.factactual a
JOIN 
    gold.dimperiod p ON p.PeriodKey = a.PeriodKey
WHERE 
    a.InvoiceDate NOT BETWEEN p.PeriodStartDate AND p.PeriodEndDate;
GO


-- A7. Exchange-rate coverage: every currency needs a BUDGET rate for all 12 months
--     and an ACTUAL rate for every month that has invoices. Expect no rows.
SELECT 
    c.CurrencyCode, 
    p.PeriodKey,
     'Missing BUDGET rate' AS Issue
FROM 
    gold.dimcurrency c 
CROSS JOIN gold.dimperiod p
WHERE NOT EXISTS 
(
        SELECT 1 
        FROM 
            gold.factexchangerate r
        WHERE 
            r.CurrencyCode = c.CurrencyCode AND 
            r.PeriodKey = p.PeriodKey AND r.RateType = 'BUDGET'
)
UNION ALL
SELECT DISTINCT 
    a.CurrencyCode, 
    a.PeriodKey, 
    'Missing ACTUAL rate'
FROM 
    gold.factactual a
WHERE NOT EXISTS 
(
        SELECT 1 
        FROM gold.factexchangerate r
        WHERE 
        r.CurrencyCode = a.CurrencyCode AND r.PeriodKey = a.PeriodKey AND r.RateType = 'ACTUAL'
);
GO


-- A8. Coverage gaps (supplier-months with budget but no invoices, or invoices but no budget).
--     Expect exactly 2 rows: Simba Robotics Dec-26 (no invoices) and Baloo Bulk Logistics Aug-26 (unbudgeted).
SELECT SupplierName, FiscalPeriodLabel, BudgetLocal, ActualLocal, InvoiceCount, VarianceStatus
FROM gold.vw_SupplierMonthVariance
WHERE InvoiceCount = 0 OR IsUnbudgeted = 1
ORDER BY PeriodKey, SupplierName;
GO

 

-- A9. Control totals in supplier currency
SELECT x.CurrencyCode,
       x.BudgetLocal, e.ExpBudget,
       x.ActualLocal, e.ExpActual,
       CASE WHEN x.BudgetLocal = e.ExpBudget AND x.ActualLocal = e.ExpActual THEN 'PASS' ELSE 'FAIL' END AS Result
FROM (
    SELECT CurrencyCode, SUM(BudgetLocal) AS BudgetLocal, SUM(ActualLocal) AS ActualLocal
    FROM gold.vw_SupplierMonthVariance
    GROUP BY CurrencyCode
) x
JOIN (VALUES ('GBP',   1695860.00,   1700308.48),
             ('EUR',   1098390.00,   1134880.56),
             ('JPY', 166991000.00, 165616840.00)
     ) e (CurrencyCode, ExpBudget, ExpActual) ON e.CurrencyCode = x.CurrencyCode;
GO

-- A10. Control totals in GBP by fiscal quarter, and the variance bridge
--      (SpendVariance + FxVariance must equal total Variance).
SELECT q.FiscalQuarterLabel,
       q.BudgetGBP, e.ExpBudgetGBP,
       q.ActualGBP, e.ExpActualGBP,
       q.SpendVarianceGBP, q.FxVarianceGBP, q.VarianceGBP,
       CASE WHEN q.BudgetGBP = e.ExpBudgetGBP
             AND q.ActualGBP = e.ExpActualGBP
             AND q.SpendVarianceGBP = e.ExpSpendVar
             AND q.FxVarianceGBP    = e.ExpFxVar
             AND q.SpendVarianceGBP + q.FxVarianceGBP = q.VarianceGBP
            THEN 'PASS' ELSE 'FAIL' END AS Result
FROM (
    SELECT FiscalQuarter, FiscalQuarterLabel,
           SUM(BudgetGBP) AS BudgetGBP, SUM(ActualGBP) AS ActualGBP, SUM(VarianceGBP) AS VarianceGBP,
           SUM(SpendVarianceGBP) AS SpendVarianceGBP, SUM(FxVarianceGBP) AS FxVarianceGBP
    FROM gold.vw_SupplierMonthVariance
    GROUP BY FiscalQuarter, FiscalQuarterLabel
) q
JOIN (VALUES (1, 1208935.30, 1209979.21,   6135.83, -5091.92),
             (2, 1115415.20, 1170267.50,  62612.19, -7759.89),
             (3, 1173494.20, 1139523.86, -40428.18,  6457.84)
     ) e (FiscalQuarter, ExpBudgetGBP, ExpActualGBP, ExpSpendVar, ExpFxVar) ON e.FiscalQuarter = q.FiscalQuarter
ORDER BY 
    q.FiscalQuarter;
GO