CREATE TABLE [gold].[factactual] (
    [ActualSK]          BIGINT          NOT NULL,
    [SupplierSK]        BIGINT          NOT NULL,
    [SupplierCode]      VARCHAR (8000)  NULL,
    [InvoiceNumber]     VARCHAR (8000)  NOT NULL,
    [InvoiceDate]       DATE            NULL,
    [PurchaseOrderNo]   VARCHAR (8000)  NULL,
    [Period]            INT             NULL,
    [PeriodDate]        DATE            NULL,
    [ActualYear]        INT             NULL,
    [ActualMonth]       INT             NULL,
    [CurrencyCode]      VARCHAR (8000)  NOT NULL,
    [AmountLocal]       DECIMAL (19, 4) NULL,
    [Description]       VARCHAR (8000)  NULL,
    [ActualVersion]     INT             NULL,
    [SupplierMatchType] VARCHAR (20)    NOT NULL,
    [_loaded_at]        DATETIME2 (6)   NOT NULL
);
GO

ALTER TABLE [gold].[factactual]
    ADD CONSTRAINT [FK_gold_factactual_supplier] FOREIGN KEY ([SupplierSK]) REFERENCES [gold].[factsupplier] ([SupplierSK]) NOT ENFORCED;
GO

ALTER TABLE [gold].[factactual]
    ADD CONSTRAINT [PK_gold_factactual] PRIMARY KEY NONCLUSTERED ([ActualSK] ASC) NOT ENFORCED;
GO