drop table [Gold].[FactBudget] 
drop table [Gold].[FactSupplier]


SELECT OBJECT_SCHEMA_NAME(parent_object_id) AS schema_name,
       OBJECT_NAME(parent_object_id)        AS table_name,
       name                                 AS constraint_name,
       type_desc
FROM   sys.objects
WHERE  type IN ('PK', 'F', 'UQ')   -- primary key, foreign key, unique
ORDER  BY schema_name, table_name;


CREATE TABLE [Gold].[DimSupplier] (
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

ALTER TABLE [Gold].[DimSupplier]
    ADD CONSTRAINT [PK_Gold_DimSupplier] PRIMARY KEY NONCLUSTERED ([SupplierSK] ASC) NOT ENFORCED;
GO



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
    [CBudgetNote]        VARCHAR (8000)  NULL,
    [BudgetVersion]     INT             NULL,
    [SupplierMatchType] VARCHAR (20)    NOT NULL,
    [_loaded_at]        DATETIME2 (6)   NOT NULL
);
GO

ALTER TABLE [Gold].[FactBudget]
    ADD CONSTRAINT [FK_Gold_FactBudget_Supplier] FOREIGN KEY ([SupplierSK]) REFERENCES [Gold].[DimSupplier] ([SupplierSK]) NOT ENFORCED;
GO

ALTER TABLE [Gold].[FactBudget]
    ADD CONSTRAINT [PK_Gold_FactBudget] PRIMARY KEY NONCLUSTERED ([BudgetSK] ASC) NOT ENFORCED;
GO