CREATE TABLE [gold].[factexchangerate] (
    [CurrencyCode] CHAR (3)        NOT NULL,
    [PeriodKey]    INT             NOT NULL,
    [RateType]     VARCHAR (10)    NOT NULL,
    [RateToGBP]    DECIMAL (18, 8) NOT NULL
);
GO