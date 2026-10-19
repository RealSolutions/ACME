CREATE TABLE [Gold].[DimWBSCode]
(
  [WBSCode] varchar(50) NOT NULL,  
  [ParentWBSCode] varchar(50) NULL,
  [WBSLevel] int NOT NULL,
  [SortOrder] int NOT NULL,
  [Description] varchar(255) NOT NULL  
)
GO
ALTER TABLE [Gold].[DimWBSCode]
    ADD CONSTRAINT [PK_GoldWBSCode] PRIMARY KEY NONCLUSTERED ([WBSCode] ASC) NOT ENFORCED;
GO