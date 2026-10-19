/*
    DROP TABLE  [Gold].[FactActual]
*/
CREATE TABLE [Gold].[FactActual] (
    [ActualSK]          BIGINT          NOT NULL,
    [SupplierSK]        BIGINT          NOT NULL,
    [SupplierCode]      VARCHAR (8000)  NULL,
    [InvoiceNumber]     VARCHAR (8000)  NOT NULL,
    [InvoiceDate]       DATE            NULL,
    [PurchaseOrderNo]   VARCHAR (8000)  NULL,
    [PeriodKey]         INT             NULL,
    [PeriodDate]        DATE            NULL,
    [ActualYear]        INT             NULL,
    [ActualMonth]       INT             NULL,
    [CurrencyCode]      VARCHAR (8000)  NOT NULL,
    [AmountLocal]       DECIMAL (19, 4) NULL,
    [Description]       VARCHAR (8000)  NULL,
    [WBSCode]           varchar(50) null,
    [CostType]           varchar(50) null,  
    [ActualVersion]     INT             NULL,
    [SupplierMatchType] VARCHAR (20)    NOT NULL,
    [_Loaded_At]        DATETIME2 (6)   NOT NULL
);
GO

ALTER TABLE [Gold].[FactActual]
    ADD CONSTRAINT [FK_Gold_FactActual_Supplier] FOREIGN KEY ([SupplierSK]) REFERENCES [Gold].[DimSupplier] ([SupplierSK]) NOT ENFORCED;
GO

ALTER TABLE [Gold].[FactActual]
    ADD CONSTRAINT [PK_Gold_FactActual] PRIMARY KEY NONCLUSTERED ([ActualSK] ASC) NOT ENFORCED;
GO