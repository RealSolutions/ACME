CREATE TABLE [Gold].[DimCurrency] (
    [CurrencyCode]  CHAR (3)     NOT NULL,
    [CurrencyName]  VARCHAR (50) NOT NULL,
    [DecimalPlaces] SMALLINT     NOT NULL,
    [IsReporting]   BIT          NOT NULL
);
GO
ALTER TABLE [Gold].[DimCurrency] ADD PRIMARY KEY NONCLUSTERED ([CurrencyCode] ASC) NOT ENFORCED;
GO