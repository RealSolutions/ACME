CREATE TABLE [silver].[budget] (
    [BudgetSK]          BIGINT         NOT NULL,
    [suppliercode]      VARCHAR (8000) NOT NULL,
    [period]            INT            NOT NULL,
    [currencycode]      VARCHAR (8000) NULL,
    [budgetamountlocal] FLOAT (53)     NULL,
    [budgetnote]        VARCHAR (8000) NULL,
    [wbscode]           varchar(50)     null,
    [costype]           varchar(50)     null,
    [budget_year]       INT            NULL,
    [budget_month]      INT            NULL,
    [budget_period]     DATE           NULL,
    [version]           INT            NULL,
    [source_file]       VARCHAR (8000) NULL,
    [loaded_at]         DATETIME2 (6)  NULL,
    [RowHash]           VARBINARY (32) NOT NULL,
    [ValidFrom]         DATETIME2 (6)  NOT NULL,
    [ValidTo]           DATETIME2 (6)  NOT NULL,
    [IsCurrent]         BIT            NOT NULL,
    [_batch_id]         VARCHAR (36)   NOT NULL,
    [_created_at]       DATETIME2 (6)  NOT NULL,
    [_updated_at]       DATETIME2 (6)  NOT NULL
);
GO

ALTER TABLE [silver].[budget]
    ADD CONSTRAINT [PK_silver_budget] PRIMARY KEY NONCLUSTERED ([BudgetSK] ASC) NOT ENFORCED;
GO