CREATE TABLE [Silver].[Supplier] (
    [SupplierSK]       BIGINT         NOT NULL,
    [SupplierCode]     VARCHAR (8000) NOT NULL,
    [SupplierName]     VARCHAR (8000) NULL,
    [CountryName]      VARCHAR (8000) NULL,
    [CurrencyCode]     VARCHAR (8000) NULL,
    [SpendCategory]    VARCHAR (8000) NULL,
    [PaymentTermsDays] INT            NULL,
    [RowHash]          VARBINARY (32) NOT NULL,
    [ValidFrom]        DATETIME2 (6)  NOT NULL,
    [ValidTo]          DATETIME2 (6)  NOT NULL,
    [IsCurrent]        BIT            NOT NULL,
    [_Batch_Id]        VARCHAR (36)   NOT NULL,
    [_Created_At]      DATETIME2 (6)  NOT NULL,
    [_Updated_At]      DATETIME2 (6)  NOT NULL
);
GO

ALTER TABLE [Silver].[Supplier]
    ADD CONSTRAINT [PK_Silver_Supplier] PRIMARY KEY NONCLUSTERED ([SupplierSK] ASC) NOT ENFORCED;
GO