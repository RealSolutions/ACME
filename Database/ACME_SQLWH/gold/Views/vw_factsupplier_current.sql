-- 4. Optional: current-only view for reports that don't need history -------------
CREATE   VIEW gold.vw_factsupplier_current
AS
    SELECT SupplierSK, SupplierCode, SupplierName, SupplierDisplayName,
        CountryName, CurrencyCode, SpendCategory, PaymentTermsDays
    FROM   gold.factsupplier
    WHERE  IsCurrent = 1;
GO