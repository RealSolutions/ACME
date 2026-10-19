/*
    DROP TABLE [Bronze].[Supplier]
*/
CREATE TABLE [Bronze].[Supplier] (
    [SupplierCode]     VARCHAR (8000) NULL,
    [SupplierName]     VARCHAR (8000) NULL,
    [CountryName]      VARCHAR (8000) NULL,
    [CurrencyCode]     VARCHAR (8000) NULL,
    [SpendCategory]    VARCHAR (8000) NULL,
    [PaymentTermsDays] INT            NULL,
    
    [_Ingested_At]     DATETIME2 (6)  NOT NULL,
    [_Source_System]   VARCHAR (100)  NOT NULL,
    [_Batch_Id]        VARCHAR (36)   NOT NULL
);
GO