/* =====================================================================
Microsoft Fabric Warehouse: drop ALL user objects
1. Foreign key constraints
2. Primary key / unique constraints
3. Views
4. Tables
5. (Optional) procedures and functions, which can block schema drops
6. User schemas (dbo and system schemas are kept)

SAFETY: @Execute = 0 (default) only RETURNS the generated SQL so you
can review it. Set @Execute = 1 to actually run it.
NOTE: Fabric Warehouse has no cursors, so dynamic SQL is built with
STRING_AGG and run with sp_executesql.
===================================================================== */

/* ---------- 1. Foreign key constraints ---------- */
DECLARE @Execute bit = 0; -- 0 = preview only, 1 = execute
DECLARE @sql nvarchar(max);

SELECT @sql = STRING_AGG(CAST(
N'ALTER TABLE ' + QUOTENAME(s.name) + N'.' + QUOTENAME(t.name)
+ N' DROP CONSTRAINT ' + QUOTENAME(fk.name) + N';' AS nvarchar(max)), CHAR(10))
FROM sys.foreign_keys fk
JOIN sys.tables t ON fk.parent_object_id = t.object_id
JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE t.is_ms_shipped = 0;

IF @sql IS NOT NULL
BEGIN
IF @Execute = 1 EXEC sp_executesql @sql;
ELSE SELECT N'-- 1. Foreign keys' AS step, @sql AS generated_sql;
END;

/*
    ALTER TABLE [gold].[factactual] DROP CONSTRAINT [FK_gold_factactual_supplier];
    ALTER TABLE [gold].[factbudget] DROP CONSTRAINT [FK_gold_factbudget_supplier];
*/

-- --------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------

/* ---------- 2. Primary key / unique constraints ---------- */
DECLARE @Execute bit = 0; -- 0 = preview only, 1 = execute
DECLARE @sql nvarchar(max);
SET @sql = NULL;
SELECT @sql = STRING_AGG(CAST(
N'ALTER TABLE ' + QUOTENAME(s.name) + N'.' + QUOTENAME(t.name)
+ N' DROP CONSTRAINT ' + QUOTENAME(kc.name) + N';' AS nvarchar(max)), CHAR(10))
FROM sys.key_constraints kc
JOIN sys.tables t ON kc.parent_object_id = t.object_id
JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE t.is_ms_shipped = 0;

IF @sql IS NOT NULL
BEGIN
IF @Execute = 1 EXEC sp_executesql @sql;
ELSE SELECT N'-- 2. PK / unique constraints' AS step, @sql AS generated_sql;
END;
GO

/*
    ALTER TABLE [silver].[supplier] DROP CONSTRAINT [PK_silver_supplier];
*/
-- --------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------
/* ---------- 3. Views ---------- */
DECLARE @Execute bit = 0; -- 0 = preview only, 1 = execute
DECLARE @sql nvarchar(max);
SET @sql = NULL;
SELECT @sql = STRING_AGG(CAST(
N'DROP VIEW ' + QUOTENAME(s.name) + N'.' + QUOTENAME(v.name) + N';' AS nvarchar(max)), CHAR(10))
FROM sys.views v
JOIN sys.schemas s ON v.schema_id = s.schema_id
WHERE v.is_ms_shipped = 0
AND s.name NOT IN (N'sys', N'INFORMATION_SCHEMA', N'queryinsights');

IF @sql IS NOT NULL
BEGIN
IF @Execute = 1 EXEC sp_executesql @sql;
ELSE SELECT N'-- 3. Views' AS step, @sql AS generated_sql;
END;


/*
-- 3. Views	DROP VIEW [silver].[vw_supplier_source];
DROP VIEW [silver].[vw_budget_source];
DROP VIEW [silver].[vw_actual_source];
DROP VIEW [gold].[vw_SupplierMonthVariance];
DROP VIEW [gold].[vw_SupplierQuarterVarianc e];
DROP VIEW [gold].[vw_dimsupplier_current];
*/

/*
    -- 2. PK / unique constraints	ALTER TABLE [silver].[supplier] DROP CONSTRAINT [PK_silver_supplier];
    ALTER TABLE [gold].[factsupplier] DROP CONSTRAINT [PK_gold_factsupplier];
    ALTER TABLE [silver].[budget] DROP CONSTRAINT [PK_silver_budget];
    ALTER TABLE [silver].[actual] DROP CONSTRAINT [PK_silver_actual];
    ALTER TABLE [gold].[dimsupplier] DROP CONSTRAINT [PK_gold_dimsupplier];
    ALTER TABLE [gold].[factactual] DROP CONSTRAINT [PK_gold_factactual];
    ALTER TABLE [gold].[factbudget] DROP CONSTRAINT [PK_gold_factbudget];
*/

-- --------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------
/* ---------- 4. Tables ---------- */
DECLARE @Execute bit = 0; -- 0 = preview only, 1 = execute
DECLARE @sql nvarchar(max);
SET @sql = NULL;
SELECT @sql = STRING_AGG(CAST(
N'DROP TABLE ' + QUOTENAME(s.name) + N'.' + QUOTENAME(t.name) + N';' AS nvarchar(max)), CHAR(10))
FROM sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE t.is_ms_shipped = 0;

IF @sql IS NOT NULL
BEGIN
IF @Execute = 1 EXEC sp_executesql @sql;
ELSE SELECT N'-- 4. Tables' AS step, @sql AS generated_sql;
END;

/*
-- 4. Tables	DROP TABLE [bronze].[supplier];
DROP TABLE [silver].[supplier];
DROP TABLE [gold].[factsupplier];
DROP TABLE [bronze].[budget];
DROP TABLE [silver].[budget];
DROP TABLE [bronze].[actual];
DROP TABLE [silver].[actual];
DROP TABLE [gold].[dimcurrency];
DROP TABLE [gold].[dimperiod];
DROP TABLE [gold].[factexchangerate];
DROP TABLE [gold].[dimsupplier];
DROP TABLE [gold].[factactual];
DROP TABLE [gold].[factbudget];
*/

-- --------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------
/* ---------- 5. Procedures & functions (needed to empty schemas) ---------- */
DECLARE @Execute bit = 0; -- 0 = preview only, 1 = execute
DECLARE @sql nvarchar(max);
SET @sql = NULL;
SELECT @sql = STRING_AGG(CAST(
CASE WHEN o.type = 'P' THEN N'DROP PROCEDURE ' ELSE N'DROP FUNCTION ' END
+ QUOTENAME(s.name) + N'.' + QUOTENAME(o.name) + N';' AS nvarchar(max)), CHAR(10))
FROM sys.objects o
JOIN sys.schemas s ON o.schema_id = s.schema_id
WHERE o.is_ms_shipped = 0
AND o.type IN ('P', 'FN', 'IF', 'TF')
AND s.name NOT IN (N'sys', N'INFORMATION_SCHEMA', N'queryinsights');

IF @sql IS NOT NULL
BEGIN
IF @Execute = 1 EXEC sp_executesql @sql;
ELSE SELECT N'-- 5. Procedures / functions' AS step, @sql AS generated_sql;
END;

/*
-- 5. Procedures / functions	DROP PROCEDURE [silver].[usp_load_budget];
DROP PROCEDURE [silver].[usp_load_supplier];
DROP PROCEDURE [silver].[usp_load_actual];
DROP PROCEDURE [gold].[usp_load_factactual];
DROP PROCEDURE [gold].[usp_load_supplier];
DROP PROCEDURE [gold].[usp_load_budget];
DROP PROCEDURE [gold].[usp_load_factsupplier];
DROP PROCEDURE [gold].[usp_load_factbudget];
DROP PROCEDURE [gold].[usp_load_dimsupplier];
DROP PROCEDURE [bronze].[usp_load_supplier];
DROP PROCEDURE [bronze].[usp_load_actual];
DROP PROCEDURE [bronze].[usp_load_budget];
*/

-- --------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------
/* ---------- 6. User schemas ---------- */
DECLARE @Execute bit = 0; -- 0 = preview only, 1 = execute
DECLARE @sql nvarchar(max);
SET @sql = NULL;
SELECT @sql = STRING_AGG(CAST(
N'DROP SCHEMA ' + QUOTENAME(s.name) + N';' AS nvarchar(max)), CHAR(10))
FROM sys.schemas s
WHERE s.name NOT IN (N'dbo', N'guest', N'sys', N'INFORMATION_SCHEMA', N'queryinsights')
AND s.schema_id < 16384; -- excludes fixed db_* role schemas

IF @sql IS NOT NULL
BEGIN
IF @Execute = 1 EXEC sp_executesql @sql;
ELSE SELECT N'-- 6. Schemas' AS step, @sql AS generated_sql;
END;

/*
-- 6. Schemas	DROP SCHEMA [_rsc];
DROP SCHEMA [silver];
DROP SCHEMA [gold];
DROP SCHEMA [bronze];
*/

DROP VIEW [silver].[vw_supplier_source]

DROP PROCEDURE [silver].[usp_load_budget]