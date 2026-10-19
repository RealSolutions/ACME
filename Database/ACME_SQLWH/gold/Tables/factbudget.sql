/*
    DROP TABLE  [Gold].[FactBudget]
*/
CREATE TABLE [Gold].[FactBudget] (
    [BudgetSK]          BIGINT          NOT NULL,
    [SupplierSK]        BIGINT          NOT NULL,
    [SupplierCode]      VARCHAR (8000)  NOT NULL,
    [PeriodKey]         INT             NOT NULL,
    [PeriodDate]        DATE            NULL,
    [BudgetYear]        INT             NULL,
    [BudgetMonth]       INT             NULL,
    [CurrencyCode]      VARCHAR (8000)  NOT NULL,
    [BudgetAmountLocal] DECIMAL (19, 4) NULL,
    [BudgetNote]       VARCHAR (8000)  NULL,
    [WBSCode]           varchar(50) null,
    [CostType]          varchar(50) null,
    [Version]     INT             NULL,
    [SupplierMatchType] VARCHAR (20)    NOT NULL,
    [_Loaded_At]        DATETIME2 (6)   NOT NULL
);
GO

ALTER TABLE [Gold].[FactBudget]
    ADD CONSTRAINT [FK_Gold_FactBudget_Supplier] FOREIGN KEY ([SupplierSK]) REFERENCES [Gold].[DimSupplier] ([SupplierSK]) NOT ENFORCED;
GO

ALTER TABLE [Gold].[FactBudget]
    ADD CONSTRAINT [PK_Gold_FactBudget] PRIMARY KEY NONCLUSTERED ([BudgetSK] ASC) NOT ENFORCED;
GO