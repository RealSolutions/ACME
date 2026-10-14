CREATE TABLE [bronze].[supplier] (
    [SupplierCode]     VARCHAR (8000) NULL,
    [SupplierName]     VARCHAR (8000) NULL,
    [CountryName]      VARCHAR (8000) NULL,
    [CurrencyCode]     VARCHAR (8000) NULL,
    [SpendCategory]    VARCHAR (8000) NULL,
    [PaymentTermsDays] INT            NULL,
    [_ingested_at]     DATETIME2 (6)  NOT NULL,
    [_source_system]   VARCHAR (100)  NOT NULL,
    [_batch_id]        VARCHAR (36)   NOT NULL
);
GO