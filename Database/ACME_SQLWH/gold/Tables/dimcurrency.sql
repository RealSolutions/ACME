CREATE TABLE [gold].[dimcurrency] (
    [CurrencyCode]  CHAR (3)     NOT NULL,
    [CurrencyName]  VARCHAR (50) NOT NULL,
    [DecimalPlaces] SMALLINT     NOT NULL,
    [IsReporting]   BIT          NOT NULL
);
GO