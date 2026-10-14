CREATE TABLE [silver].[supplier] (
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
    [_batch_id]        VARCHAR (36)   NOT NULL,
    [_created_at]      DATETIME2 (6)  NOT NULL,
    [_updated_at]      DATETIME2 (6)  NOT NULL
);
GO

ALTER TABLE [silver].[supplier]
    ADD CONSTRAINT [PK_silver_supplier] PRIMARY KEY NONCLUSTERED ([SupplierSK] ASC) NOT ENFORCED;
GO