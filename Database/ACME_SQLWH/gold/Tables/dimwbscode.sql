CREATE TABLE [gold].[dimwbscode]
(
  [wbscode] varchar(50) NOT NULL PRIMARY KEY,  
  [parentwbscode] varchar(50) NULL,
  [wbslevel] int NOT NULL,
  [sortorder] int NOT NULL,
  [description] varchar(255) NOT NULL  
)
GO
