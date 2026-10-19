/*
    DROP TABLE [Silver].[Actual]
*/
CREATE TABLE [Silver].[Actual] (
    [ActualSK]        BIGINT         NOT NULL,
    [InvoiceNumber]   VARCHAR (8000) NOT NULL,
    [SupplierCode]    VARCHAR (8000) NULL,
    [Period]          INT            NULL,
    [InvoiceDate]     DATE           NULL,
    [PurchaseOrderNo] VARCHAR (8000) NULL,
    [CurrencyCode]    VARCHAR (8000) NULL,
    [AmountLocal]     FLOAT (53)     NULL,
    [Description]     VARCHAR (8000) NULL,
    [WBSCode]         VARCHAR(50) null,
    [CostType]        VARCHAR(50) null,    
    [Version]         INT            NULL,
    [Actual_Year]     INT            NULL,
    [Actual_Month]    INT            NULL,
    [Actual]          DATE           NULL,
    [Source_File]     VARCHAR (8000) NULL,
    [Loaded_At]       DATETIME2 (6)  NULL,
    [RowHash]         VARBINARY (32) NOT NULL,
    [ValidFrom]       DATETIME2 (6)  NOT NULL,
    [ValidTo]         DATETIME2 (6)  NOT NULL,
    [IsCurrent]       BIT            NOT NULL,
    [_Batch_Id]       VARCHAR (36)   NOT NULL,
    [_Created_At]     DATETIME2 (6)  NOT NULL,
    [_Updated_At]     DATETIME2 (6)  NOT NULL
);
GO

ALTER TABLE [Silver].[Actual]
    ADD CONSTRAINT [PK_Silver_Actual] PRIMARY KEY NONCLUSTERED ([ActualSK] ASC) NOT ENFORCED;
GO