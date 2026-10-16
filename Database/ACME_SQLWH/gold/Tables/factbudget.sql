/*
    DROP TABLE  [gold].[factbudget]
*/
CREATE TABLE [gold].[factbudget] (
    [BudgetSK]          BIGINT          NOT NULL,
    [SupplierSK]        BIGINT          NOT NULL,
    [SupplierCode]      VARCHAR (8000)  NOT NULL,
    [PeriodKey]      INT             NOT NULL,
    [PeriodDate]        DATE            NULL,
    [BudgetYear]        INT             NULL,
    [BudgetMonth]       INT             NULL,
    [CurrencyCode]      VARCHAR (8000)  NOT NULL,
    [BudgetAmountLocal] DECIMAL (19, 4) NULL,
    [BudgetNote]        VARCHAR (8000)  NULL,
    [wbscode]           varchar(50) null,
    [costtype]           varchar(50) null,
    [BudgetVersion]     INT             NULL,
    [SupplierMatchType] VARCHAR (20)    NOT NULL,
    [_loaded_at]        DATETIME2 (6)   NOT NULL
);
GO

ALTER TABLE [gold].[factbudget]
    ADD CONSTRAINT [FK_gold_factbudget_supplier] FOREIGN KEY ([SupplierSK]) REFERENCES [gold].[dimsupplier] ([SupplierSK]) NOT ENFORCED;
GO

ALTER TABLE [gold].[factbudget]
    ADD CONSTRAINT [PK_gold_factbudget] PRIMARY KEY NONCLUSTERED ([BudgetSK] ASC) NOT ENFORCED;
GO