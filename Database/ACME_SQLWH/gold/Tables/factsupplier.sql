CREATE TABLE [gold].[factsupplier] (
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
    [_loaded_at]          DATETIME2 (6)  NOT NULL
);
GO

ALTER TABLE [gold].[factsupplier]
    ADD CONSTRAINT [PK_gold_factsupplier] PRIMARY KEY NONCLUSTERED ([SupplierSK] ASC) NOT ENFORCED;
GO