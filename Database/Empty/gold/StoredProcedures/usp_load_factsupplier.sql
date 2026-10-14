--TODO Header
CREATE   PROCEDURE gold.usp_load_factsupplier
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @loaded_at DATETIME2(6) = SYSUTCDATETIME();

    BEGIN TRANSACTION;

        -- TODO only load changes
        delete from gold.dimsupplier;

        INSERT INTO gold.dimsupplier
        (
            SupplierSK, SupplierCode, SupplierName, SupplierDisplayName,
            CountryName, CurrencyCode, SpendCategory, PaymentTermsDays,
            ValidFrom, ValidTo, IsCurrent, _loaded_at
        )
        SELECT
            s.SupplierSK,
            s.SupplierCode,
            ISNULL(NULLIF(LTRIM(RTRIM(s.SupplierName)), ''), 'Unknown'),
            CASE WHEN s.SupplierSK = -1 THEN 'Unknown'
                 ELSE CONCAT(s.SupplierCode, ' - ',
                             ISNULL(NULLIF(LTRIM(RTRIM(s.SupplierName)), ''), 'Unknown'))
            END,
            ISNULL(NULLIF(LTRIM(RTRIM(s.CountryName)), ''), 'Unknown'),
            ISNULL(NULLIF(UPPER(LTRIM(RTRIM(s.CurrencyCode))), ''), 'UNK'),
            ISNULL(NULLIF(LTRIM(RTRIM(s.SpendCategory)), ''), 'Unknown'),
            s.PaymentTermsDays,
            s.ValidFrom,
            s.ValidTo,
            s.IsCurrent,
            @loaded_at
        FROM silver.supplier AS s;

    COMMIT TRANSACTION;

    SELECT @loaded_at AS loaded_at,
           COUNT(*)                                       AS rows_loaded,
           SUM(CASE WHEN IsCurrent = 1 THEN 1 ELSE 0 END) AS current_rows
    FROM gold.dimsupplier;
END;
GO