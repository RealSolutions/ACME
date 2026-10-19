
CREATE   VIEW Silver.vw_Actual_Source
AS
    WITH cleaned AS
    (
        SELECT
            LTRIM(RTRIM(a.InvoiceNumber))       AS [InvoiceNumber],
            a.[Period],
            a.[InvoiceDate],
            a.[PurchaseOrderNo],
            UPPER(LTRIM(RTRIM(a.CurrencyCode))) AS [CurrencyCode],
            a.[AmountLocal],
            a.[Description],
            a.[Version],
            a.[Actual_Year],
            a.[Actual_Month],
            a.[Actual],
            a.[WBSCode],
            a.[CostType],
            a.[Source_File],
            a.[Loaded_At],
            a.[_Ingested_At]
        FROM 
            Bronze.Actual AS a
        WHERE NULLIF(LTRIM(RTRIM(a.[InvoiceNumber])), '') IS NOT NULL
    ),
    ranked AS
    (
        SELECT
        c.[InvoiceNumber],
            c.[Period], 
            c.[InvoiceDate], 
            c.[PurchaseOrderNo], 
            c.[CurrencyCode],
            c.[AmountLocal], 
            c.[Description], 
            c.[Version], 
            c.[Actual_Year], 
            c.[Actual_Month], 
            c.[Actual],
            c.[WBSCode],
            c.[CostType],
            c.[Source_File],
            c.[Loaded_At],
            c.[_Ingested_At],
            -- SupplierCode = text before the first '-' (NULL when there is no '-')
            CASE WHEN CHARINDEX('-', c.[InvoiceNumber]) > 1
                THEN LTRIM(RTRIM(LEFT(c.[InvoiceNumber], CHARINDEX('-', c.[InvoiceNumber]) - 1)))
            END AS [SupplierCode],
            ROW_NUMBER() OVER (PARTITION BY c.[InvoiceNumber]
                            ORDER BY c.[Version] DESC, c.[Loaded_At] DESC, c.[_Ingested_At] DESC) AS rn
        FROM cleaned AS c
    )
    SELECT
        [InvoiceNumber], 
        [SupplierCode], 
        [Period], 
        [InvoiceDate], 
        [PurchaseOrderNo], 
        [CurrencyCode],
        [AmountLocal], 
        [Description], 
        [Version], 
        [Actual_Year], 
        [Actual_Month], 
        [Actual],
        [WBSCode],
        [CostType],
        [Source_File],
        [Loaded_At],
        -- '~' marks NULL so that NULL and '' hash differently.
        -- Float uses style 3 (17 significant digits) so small amount changes are caught.
        -- HASHBYTES returns VARBINARY(8000); convert explicitly to the 32-byte column type.
        CONVERT(VARBINARY(32), HASHBYTES('SHA2_256', CONCAT_WS('|',
            ISNULL(CAST(Period AS VARCHAR(20)), '~'),
            ISNULL(CONVERT(VARCHAR(10), InvoiceDate, 23), '~'),
            ISNULL(PurchaseOrderNo, '~'),
            ISNULL(CurrencyCode, '~'),
            ISNULL(CONVERT(VARCHAR(30), AmountLocal, 3), '~'),
            ISNULL(Description, '~'),
            ISNULL(CAST(Version AS VARCHAR(20)), '~'),
            ISNULL(CAST(Actual_Year  AS VARCHAR(20)), '~'),
            ISNULL(CAST(Actual_Month AS VARCHAR(20)), '~'),
            ISNULL(CONVERT(VARCHAR(10), Actual, 23), '~')
        ))) AS RowHash
    FROM ranked
    WHERE rn = 1;

GO