/*
DROP TABLE [Gold].[DimSupplier] 
*/
CREATE TABLE [Gold].[DimSupplier] (
    [SupplierSK]          BIGINT         NOT NULL,
    [SupplierCode]        VARCHAR (8000) NOT NULL,
    [SupplierName]        VARCHAR (8000) NOT NULL,
    [SupplierDisplayName] VARCHAR (8000) NOT NULL,
    [CountryName]         VARCHAR (8000) NOT NULL,
    [CurrencyCode]        VARCHAR (8000) NOT NULL,
    [SpendCategory]       VARCHAR (8000) NOT NULL,
    [PaymentTermsDays]    INT            NULL,
    [ValidFrom]           DATETIME2 (6)  NOT NULL,
    [ValidTo]             DATETIME2 (6)  NOT NULL,
    [IsCurrent]           BIT            NOT NULL,
    [_Loaded_At]          DATETIME2 (6)  NOT NULL
);
GO

ALTER TABLE [Gold].[DimSupplier]
    ADD CONSTRAINT [PK_Gold_DimSupplier] PRIMARY KEY NONCLUSTERED ([SupplierSK] ASC) NOT ENFORCED;
GO