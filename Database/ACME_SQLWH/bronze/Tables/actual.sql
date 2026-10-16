
/*
    DROP TABLE [bronze].[actual]
*/
CREATE TABLE [bronze].[actual] (
    [Period]          INT            NULL,
    [InvoiceNumber]   VARCHAR (8000) NULL,
    [InvoiceDate]     DATE           NULL,
    [PurchaseOrderNo] VARCHAR (8000) NULL,
    [CurrencyCode]    VARCHAR (8000) NULL,
    [AmountLocal]     FLOAT (53)     NULL,
    [Description]     VARCHAR (8000) NULL,
    [wbscode]           varchar(50) null,
    [costtype]           varchar(50) null,    
    [version]         INT            NULL,
    [source_file]     VARCHAR (8000) NULL,
    [loaded_at]       DATETIME2 (6)  NULL,
    [actual_year]     INT            NULL,
    [actual_month]    INT            NULL,
    [actual]          DATE           NULL,
    [_ingested_at]    DATETIME2 (6)  NOT NULL,
    [_source_system]  VARCHAR (100)  NOT NULL,
    [_batch_id]       VARCHAR (36)   NOT NULL
);
GO