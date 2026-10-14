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
 
SELECT  s.name,t.name 
FROM  sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE t.is_ms_shipped = 0
ORDER BY s.name;

===================================================================== */

DECLARE @Execute bit = 1; -- 0 = preview only, 1 = execute
DECLARE @sql nvarchar(max);

/* ---------- 1. Foreign key constraints ---------- */
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
GO

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

/* ---------- 3. Views ---------- */
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

/* ---------- 4. Tables ---------- */
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

/* ---------- 5. Procedures & functions (needed to empty schemas) ---------- */
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

/* ---------- 6. User schemas ---------- */
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
