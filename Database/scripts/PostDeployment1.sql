-- This file contains SQL statements that will be executed after the build script.
-- ---------------------------------------------------------------------------------
-- Load basic Lookup data values
-- ---------------------------------------------------------------------------------
TRUNCATE TABLE gold.dimcurrency
GO

INSERT INTO gold.dimcurrency (CurrencyCode, CurrencyName, DecimalPlaces, IsReporting)
VALUES
    ('GBP', 'Pound Sterling', 2, 1),
    ('EUR', 'Euro', 2, 0),
    ('JPY', 'Japanese Yen', 0, 0);
GO

TRUNCATE TABLE gold.dimperiod
GO
INSERT INTO gold.dimperiod (PeriodKey, PeriodStartDate, PeriodEndDate, CalendarYear, CalendarMonth, MonthName, MonthShort, FiscalYearStart, FiscalYearLabel, FiscalMonthNumber, FiscalQuarter, FiscalQuarterLabel, FiscalPeriodLabel)
VALUES
    (202604, '2026-04-01', '2026-04-30', 2026, 4, 'April', 'Apr', 2026, 'FY2026/27', 1, 1, 'Q1 FY26/27', 'P01 Apr-26'),
    (202605, '2026-05-01', '2026-05-31', 2026, 5, 'May', 'May', 2026, 'FY2026/27', 2, 1, 'Q1 FY26/27', 'P02 May-26'),
    (202606, '2026-06-01', '2026-06-30', 2026, 6, 'June', 'Jun', 2026, 'FY2026/27', 3, 1, 'Q1 FY26/27', 'P03 Jun-26'),
    (202607, '2026-07-01', '2026-07-31', 2026, 7, 'July', 'Jul', 2026, 'FY2026/27', 4, 2, 'Q2 FY26/27', 'P04 Jul-26'),
    (202608, '2026-08-01', '2026-08-31', 2026, 8, 'August', 'Aug', 2026, 'FY2026/27', 5, 2, 'Q2 FY26/27', 'P05 Aug-26'),
    (202609, '2026-09-01', '2026-09-30', 2026, 9, 'September', 'Sep', 2026, 'FY2026/27', 6, 2, 'Q2 FY26/27', 'P06 Sep-26'),
    (202610, '2026-10-01', '2026-10-31', 2026, 10, 'October', 'Oct', 2026, 'FY2026/27', 7, 3, 'Q3 FY26/27', 'P07 Oct-26'),
    (202611, '2026-11-01', '2026-11-30', 2026, 11, 'November', 'Nov', 2026, 'FY2026/27', 8, 3, 'Q3 FY26/27', 'P08 Nov-26'),
    (202612, '2026-12-01', '2026-12-31', 2026, 12, 'December', 'Dec', 2026, 'FY2026/27', 9, 3, 'Q3 FY26/27', 'P09 Dec-26'),
    (202701, '2027-01-01', '2027-01-31', 2027, 1, 'January', 'Jan', 2026, 'FY2026/27', 10, 4, 'Q4 FY26/27', 'P10 Jan-27'),
    (202702, '2027-02-01', '2027-02-28', 2027, 2, 'February', 'Feb', 2026, 'FY2026/27', 11, 4, 'Q4 FY26/27', 'P11 Feb-27'),
    (202703, '2027-03-01', '2027-03-31', 2027, 3, 'March', 'Mar', 2026, 'FY2026/27', 12, 4, 'Q4 FY26/27', 'P12 Mar-27');
GO

TRUNCATE TABLE gold.factexchangerate 
INSERT INTO gold.factexchangerate (CurrencyCode, PeriodKey, RateType, RateToGBP)
VALUES
    ('GBP', 202604, 'BUDGET', 1),
    ('GBP', 202604, 'ACTUAL', 1),
    ('GBP', 202605, 'BUDGET', 1),
    ('GBP', 202605, 'ACTUAL', 1),
    ('GBP', 202606, 'BUDGET', 1),
    ('GBP', 202606, 'ACTUAL', 1),
    ('GBP', 202607, 'BUDGET', 1),
    ('GBP', 202607, 'ACTUAL', 1),
    ('GBP', 202608, 'BUDGET', 1),
    ('GBP', 202608, 'ACTUAL', 1),
    ('GBP', 202609, 'BUDGET', 1),
    ('GBP', 202609, 'ACTUAL', 1),
    ('GBP', 202610, 'BUDGET', 1),
    ('GBP', 202610, 'ACTUAL', 1),
    ('GBP', 202611, 'BUDGET', 1),
    ('GBP', 202611, 'ACTUAL', 1),
    ('GBP', 202612, 'BUDGET', 1),
    ('GBP', 202612, 'ACTUAL', 1),
    ('GBP', 202701, 'BUDGET', 1),
    ('GBP', 202702, 'BUDGET', 1),
    ('GBP', 202703, 'BUDGET', 1),
    ('EUR', 202604, 'BUDGET', 0.85000000),
    ('EUR', 202604, 'ACTUAL', 0.85200000),
    ('EUR', 202605, 'BUDGET', 0.85000000),
    ('EUR', 202605, 'ACTUAL', 0.84850000),
    ('EUR', 202606, 'BUDGET', 0.85000000),
    ('EUR', 202606, 'ACTUAL', 0.84500000),
    ('EUR', 202607, 'BUDGET', 0.85000000),
    ('EUR', 202607, 'ACTUAL', 0.84100000),
    ('EUR', 202608, 'BUDGET', 0.85000000),
    ('EUR', 202608, 'ACTUAL', 0.83950000),
    ('EUR', 202609, 'BUDGET', 0.85000000),
    ('EUR', 202609, 'ACTUAL', 0.84400000),
    ('EUR', 202610, 'BUDGET', 0.85000000),
    ('EUR', 202610, 'ACTUAL', 0.85300000),
    ('EUR', 202611, 'BUDGET', 0.85000000),
    ('EUR', 202611, 'ACTUAL', 0.85750000),
    ('EUR', 202612, 'BUDGET', 0.85000000),
    ('EUR', 202612, 'ACTUAL', 0.86100000),
    ('EUR', 202701, 'BUDGET', 0.85000000),
    ('EUR', 202702, 'BUDGET', 0.85000000),
    ('EUR', 202703, 'BUDGET', 0.85000000),
    ('JPY', 202604, 'BUDGET', 0.00520000),
    ('JPY', 202604, 'ACTUAL', 0.00515000),
    ('JPY', 202605, 'BUDGET', 0.00520000),
    ('JPY', 202605, 'ACTUAL', 0.00512000),
    ('JPY', 202606, 'BUDGET', 0.00520000),
    ('JPY', 202606, 'ACTUAL', 0.00509000),
    ('JPY', 202607, 'BUDGET', 0.00520000),
    ('JPY', 202607, 'ACTUAL', 0.00506000),
    ('JPY', 202608, 'BUDGET', 0.00520000),
    ('JPY', 202608, 'ACTUAL', 0.00511000),
    ('JPY', 202609, 'BUDGET', 0.00520000),
    ('JPY', 202609, 'ACTUAL', 0.00518000),
    ('JPY', 202610, 'BUDGET', 0.00520000),
    ('JPY', 202610, 'ACTUAL', 0.00524000),
    ('JPY', 202611, 'BUDGET', 0.00520000),
    ('JPY', 202611, 'ACTUAL', 0.00529000),
    ('JPY', 202612, 'BUDGET', 0.00520000),
    ('JPY', 202612, 'ACTUAL', 0.00531000),
    ('JPY', 202701, 'BUDGET', 0.00520000),
    ('JPY', 202702, 'BUDGET', 0.00520000),
    ('JPY', 202703, 'BUDGET', 0.00520000);
GO