/*
    DROP TABLE [Bronze].[Budget]
*/
CREATE TABLE [Bronze].[Budget] (
    [SupplierCode]      VARCHAR (8000) NULL,
    [Period]            INT            NULL,
    [CurrencyCode]      VARCHAR (8000) NULL,
    [BudgetAmountLocal] FLOAT (53)     NULL,
    [BudgetNote]        VARCHAR (8000) NULL,
    [WBSCode]           VARCHAR(50) null,
    [CostType]          VARCHAR(50) null,
    [Budget_Year]       INT            NULL,
    [Budget_Month]      INT            NULL,
    [Budget_Period]     DATE           NULL,
    [Version]           INT            NULL,
    [Source_File]       VARCHAR (8000) NULL,
    [Loaded_At]         DATETIME2 (6)  NULL,
    [_Ingested_At]      DATETIME2 (6)  NOT NULL,
    [_Source_System]    VARCHAR (100)  NOT NULL,
    [_Batch_Id]         VARCHAR (36)   NOT NULL
);
GO