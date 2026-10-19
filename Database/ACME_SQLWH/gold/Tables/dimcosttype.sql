CREATE TABLE [Gold].[DimCostType]
(
  [CostType] varchar(50) not null,
  [Description] varchar(255) NOT NULL
)
GO

--ALTER TABLE [Gold].[DimCostType] ADD PRIMARY KEY NONCLUSTERED ([CostType] ASC) NOT ENFORCED;
--GO