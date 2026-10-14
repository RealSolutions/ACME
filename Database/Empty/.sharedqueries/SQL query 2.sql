drop table [gold].[factbudget] 
drop table [gold].[factsupplier]


SELECT OBJECT_SCHEMA_NAME(parent_object_id) AS schema_name,
       OBJECT_NAME(parent_object_id)        AS table_name,
       name                                 AS constraint_name,
       type_desc
FROM   sys.objects
WHERE  type IN ('PK', 'F', 'UQ')   -- primary key, foreign key, unique
ORDER  BY schema_name, table_name;


CREATE TABLE [gold].[dimsupplier] (
    [SupplierSK]          BIGINT         NOT NULL,
    [SupplierCode]        VARCHAR (8000) NOT NULL,
    [SupplierName]        VARCHAR (8000) NOT NULL,
    [SupplierDisplayName] VARCHAR (8000) NOT NULL,
    [CountryName]         VARCHAR (8000) NOT NULL,
    [CurrencyCode]        VARCHAR (8000) NOT NULL,
    [SpendCategory]       VARCHAR (8000) NOT NULL,
    [PaymentTermsDays]    INT            NULL,
    [ValidFrom]           DATETIME2 (6)  NOT NULL,
    [ValidTo]             DATETIME2 (6)  NOT NULL,
    [IsCurrent]           BIT            NOT NULL,
    [_loaded_at]          DATETIME2 (6)  NOT NULL
);
GO

ALTER TABLE [gold].[dimsupplier]
    ADD CONSTRAINT [PK_gold_dimsupplier] PRIMARY KEY NONCLUSTERED ([SupplierSK] ASC) NOT ENFORCED;
GO



CREATE TABLE [gold].[factbudget] (
    [BudgetSK]          BIGINT          NOT NULL,
    [SupplierSK]        BIGINT          NOT NULL,
    [SupplierCode]      VARCHAR (8000)  NOT NULL,
    [PeriodKey]         INT             NOT NULL,
    [PeriodDate]        DATE            NULL,
    [BudgetYear]        INT             NULL,
    [BudgetMonth]       INT             NULL,
    [CurrencyCode]      VARCHAR (8000)  NOT NULL,
    [BudgetAmountLocal] DECIMAL (19, 4) NULL,
    [BudgetNote]        VARCHAR (8000)  NULL,
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