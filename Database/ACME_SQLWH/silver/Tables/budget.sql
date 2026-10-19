/*
    DROP TABLE [Silver].[Budget] 
*/
CREATE TABLE [Silver].[Budget] (
    [BudgetSK]          BIGINT         NOT NULL,
    [SupplierCode]      VARCHAR (8000) NOT NULL,
    [Period]            INT            NOT NULL,
    [CurrencyCode]      VARCHAR (8000) NULL,
    [BudgetAmountLocal] FLOAT (53)     NULL,
    [BudgetNote]       VARCHAR (8000) NULL,
    [Budget_Year]       INT            NULL,
    [Budget_Month]      INT            NULL,
    [Budget_Period]     DATE           NULL,
    [WBSCode]           VARCHAR(50)     null,
    [CostType]          VARCHAR(50)     null,
    [Version]           INT            NULL,
    [Source_File]       VARCHAR (8000) NULL,
    [Loaded_At]         DATETIME2 (6)  NULL,
    [RowHash]           VARBINARY (32) NOT NULL,
    [ValidFrom]         DATETIME2 (6)  NOT NULL,
    [ValidTo]           DATETIME2 (6)  NOT NULL,
    [IsCurrent]         BIT            NOT NULL,
    [_Batch_Id]         VARCHAR (36)   NOT NULL,
    [_Created_At]       DATETIME2 (6)  NOT NULL,
    [_Updated_At]       DATETIME2 (6)  NOT NULL
);
GO

ALTER TABLE [Silver].[Budget]
    ADD CONSTRAINT [PK_Silver_Budget] PRIMARY KEY NONCLUSTERED ([BudgetSK] ASC) NOT ENFORCED;
GO