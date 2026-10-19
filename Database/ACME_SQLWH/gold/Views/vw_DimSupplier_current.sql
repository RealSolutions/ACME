CREATE   VIEW Gold.vw_DimSupplier_current
AS
    SELECT 
        SupplierSK,
        SupplierCode, 
        SupplierName, 
        SupplierDisplayName,
        CountryName, 
        CurrencyCode, 
        SpendCategory, 
        PaymentTermsDays
    FROM   
        Gold.DimSupplier
    WHERE  
        IsCurrent = 1;
GO