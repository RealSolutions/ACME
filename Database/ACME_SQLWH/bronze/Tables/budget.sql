/*
    DROP TABLE [bronze].[budget]
*/
CREATE TABLE [bronze].[budget] (
    [suppliercode]      VARCHAR (8000) NULL,
    [period]            INT            NULL,
    [currencycode]      VARCHAR (8000) NULL,
    [budgetamountlocal] FLOAT (53)     NULL,
    [budgetnote]        VARCHAR (8000) NULL,
    [wbscode]           varchar(50) null,
    [costtype]           varchar(50) null,
    [budget_year]       INT            NULL,
    [budget_month]      INT            NULL,
    [budget_period]     DATE           NULL,
    [version]           INT            NULL,
    [source_file]       VARCHAR (8000) NULL,
    [loaded_at]         DATETIME2 (6)  NULL,
    [_ingested_at]      DATETIME2 (6)  NOT NULL,
    [_source_system]    VARCHAR (100)  NOT NULL,
    [_batch_id]         VARCHAR (36)   NOT NULL
);
GO