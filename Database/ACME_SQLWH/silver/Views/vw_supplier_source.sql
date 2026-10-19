/* =============================================================================
   Silver load (SCD Type 2): ACME_SQLWH.Bronze.Supplier -> ACME_SQLWH.Silver.Supplier
   Run in the ACME_SQLWH warehouse (workspace: ACME).

   Source columns (Bronze.Supplier): SupplierCode, SupplierName, CountryName,
   CurrencyCode, SpendCategory, PaymentTermsDays + _ingested_at/_source_system/_batch_id

   - Business key : SupplierCode
   - Surrogate key: SupplierSK (BIGINT, assigned here; -1 = "Unknown" member)
   - History      : any change to a tracked attribute closes the current row
                    (ValidTo = load time, IsCurrent = 0) and inserts a new Version.
   - Deletes      : a SupplierCode missing from Bronze has its current row closed.
                    If it comes back later it gets a new Version (new SupplierSK).
   - Intervals    : half-open [ValidFrom, ValidTo); current rows have ValidTo = 9999-12-31.
   - Re-runnable  : running twice with no Bronze changes is a no-op.
   ============================================================================= */
CREATE   VIEW Silver.vw_Supplier_Source
AS
    WITH ranked AS
    (
        SELECT
            LTRIM(RTRIM(b.SupplierCode)) AS SupplierCode,
            b.SupplierName,
            b.CountryName,
            b.CurrencyCode,
            b.SpendCategory,
            b.PaymentTermsDays,
            ROW_NUMBER() OVER (PARTITION BY LTRIM(RTRIM(b.SupplierCode))
                            ORDER BY b._Ingested_At DESC) AS rn
        FROM Bronze.Supplier AS b
        WHERE NULLIF(LTRIM(RTRIM(b.SupplierCode)), '') IS NOT NULL
    )
    SELECT
        SupplierCode, 
        SupplierName, 
        CountryName, 
        CurrencyCode,
        SpendCategory, 
        PaymentTermsDays,
        -- '~' marks NULL so that NULL and '' hash differently.
        -- HASHBYTES returns VARBINARY(8000); SHA2_256 is always 32 bytes, so convert
        -- explicitly (Fabric rejects the implicit narrowing on insert).
        CONVERT(VARBINARY(32), HASHBYTES('SHA2_256', CONCAT_WS('|',
            ISNULL(SupplierName, '~'),
            ISNULL(CountryName, '~'),
            ISNULL(CurrencyCode, '~'),
            ISNULL(SpendCategory, '~'),
            ISNULL(CAST(PaymentTermsDays AS VARCHAR(20)), '~')
        ))) AS RowHash
    FROM ranked
    WHERE rn = 1;

GO