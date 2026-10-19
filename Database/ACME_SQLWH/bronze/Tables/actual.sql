
/*
    DROP TABLE [Bronze].[Actual]
*/
CREATE TABLE [Bronze].[Actual] (
    [Period]          INT            NULL,
    [InvoiceNumber]   VARCHAR (8000) NULL,
    [InvoiceDate]     DATE           NULL,
    [PurchaseOrderNo] VARCHAR (8000) NULL,
    [CurrencyCode]    VARCHAR (8000) NULL,
    [AmountLocal]     FLOAT (53)     NULL,
    [Description]     VARCHAR (8000) NULL,
    [WBSCode]         VARCHAR(50) null,
    [CostType]        VARCHAR(50) null,    
    [Version]         INT            NULL,
    [Source_File]     VARCHAR (8000) NULL,
    [Loaded_At]       DATETIME2 (6)  NULL,
    [Actual_Year]     INT            NULL,
    [Actual_Month]    INT            NULL,
    [Actual]          DATE           NULL,
    [_Ingested_At]    DATETIME2 (6)  NOT NULL,
    [_Source_System]  VARCHAR (100)  NOT NULL,
    [_Batch_Id]       VARCHAR (36)   NOT NULL
);
GO