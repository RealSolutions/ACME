-- Write your own SQL object definition here, and it'll be included in your package.
if OBJECT_ID('[bronze].[actual]','U') IS NOT NULL DROP TABLE [bronze].[actual]
IS NOT NULL DROP TABLE [bronze].[budget]
IS NOT NULL DROP TABLE [bronze].[supplier]




IS NOT NULL DROP TABLE [silver].[actual]
IS NOT NULL DROP TABLE [silver].[budget]
[silver].[supplier]

[gold].[dimcurrency]
[gold].[dimperiod]
[gold].[dimsupplier]
[gold].[factactual]
[gold].[factbudget]
[gold].[factexchangerate]
[gold].[factsupplier]








