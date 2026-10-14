CREATE TABLE [silver].[actual] (
    [ActualSK]        BIGINT         NOT NULL,
    [InvoiceNumber]   VARCHAR (8000) NOT NULL,
    [SupplierCode]    VARCHAR (8000) NULL,
    [Period]          INT            NULL,
    [InvoiceDate]     DATE           NULL,
    [PurchaseOrderNo] VARCHAR (8000) NULL,
    [CurrencyCode]    VARCHAR (8000) NULL,
    [AmountLocal]     FLOAT (53)     NULL,
    [Description]     VARCHAR (8000) NULL,
    [version]         INT            NULL,
    [actual_year]     INT            NULL,
    [actual_month]    INT            NULL,
    [actual]          DATE           NULL,
    [source_file]     VARCHAR (8000) NULL,
    [loaded_at]       DATETIME2 (6)  NULL,
    [RowHash]         VARBINARY (32) NOT NULL,
    [ValidFrom]       DATETIME2 (6)  NOT NULL,
    [ValidTo]         DATETIME2 (6)  NOT NULL,
    [IsCurrent]       BIT            NOT NULL,
    [_batch_id]       VARCHAR (36)   NOT NULL,
    [_created_at]     DATETIME2 (6)  NOT NULL,
    [_updated_at]     DATETIME2 (6)  NOT NULL
);
GO

ALTER TABLE [silver].[actual]
    ADD CONSTRAINT [PK_silver_actual] PRIMARY KEY NONCLUSTERED ([ActualSK] ASC) NOT ENFORCED;
GO