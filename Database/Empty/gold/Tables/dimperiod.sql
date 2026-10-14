CREATE TABLE [gold].[dimperiod] (
    [PeriodKey]          INT          NOT NULL,
    [PeriodStartDate]    DATE         NOT NULL,
    [PeriodEndDate]      DATE         NOT NULL,
    [CalendarYear]       SMALLINT     NOT NULL,
    [CalendarMonth]      SMALLINT     NOT NULL,
    [MonthName]          VARCHAR (10) NOT NULL,
    [MonthShort]         CHAR (3)     NOT NULL,
    [FiscalYearStart]    SMALLINT     NOT NULL,
    [FiscalYearLabel]    VARCHAR (10) NOT NULL,
    [FiscalMonthNumber]  SMALLINT     NOT NULL,
    [FiscalQuarter]      SMALLINT     NOT NULL,
    [FiscalQuarterLabel] VARCHAR (15) NOT NULL,
    [FiscalPeriodLabel]  VARCHAR (15) NOT NULL
);
GO