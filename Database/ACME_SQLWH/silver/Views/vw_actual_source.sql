CREATE   VIEW silver.vw_actual_source
AS
    WITH cleaned AS
    (
        SELECT
            LTRIM(RTRIM(a.InvoiceNumber))       AS InvoiceNumber,
            a.Period,
            a.InvoiceDate,
            a.PurchaseOrderNo,
            UPPER(LTRIM(RTRIM(a.CurrencyCode))) AS CurrencyCode,
            a.AmountLocal,
            a.Description,
            a.version,
            a.actual_year,
            a.actual_month,
            a.actual,
            a.wbscode,
            a.costtype,
            a.source_file,
            a.loaded_at,
            a._ingested_at
        FROM bronze.actual AS a
        WHERE NULLIF(LTRIM(RTRIM(a.InvoiceNumber)), '') IS NOT NULL
    ),
    ranked AS
    (
        SELECT
            c.*,
            -- SupplierCode = text before the first '-' (NULL when there is no '-')
            CASE WHEN CHARINDEX('-', c.InvoiceNumber) > 1
                THEN LTRIM(RTRIM(LEFT(c.InvoiceNumber, CHARINDEX('-', c.InvoiceNumber) - 1)))
            END AS SupplierCode,
            ROW_NUMBER() OVER (PARTITION BY c.InvoiceNumber
                            ORDER BY c.version DESC, c.loaded_at DESC, c._ingested_at DESC) AS rn
        FROM cleaned AS c
    )
    SELECT
        InvoiceNumber, SupplierCode, Period, InvoiceDate, PurchaseOrderNo, CurrencyCode,
        AmountLocal, Description, version, actual_year, actual_month, actual,
           wbscode,
            costtype,
        source_file,
         loaded_at,
        
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
            ISNULL(CAST(version AS VARCHAR(20)), '~'),
            ISNULL(CAST(actual_year  AS VARCHAR(20)), '~'),
            ISNULL(CAST(actual_month AS VARCHAR(20)), '~'),
            ISNULL(CONVERT(VARCHAR(10), actual, 23), '~')
        ))) AS RowHash
    FROM ranked
    WHERE rn = 1;

GO