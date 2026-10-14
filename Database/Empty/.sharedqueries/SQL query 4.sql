SELECT OBJECT_SCHEMA_NAME(parent_object_id) AS schema_name,
       OBJECT_NAME(parent_object_id)        AS table_name,
       name                                 AS constraint_name,
       type_desc
FROM   sys.objects
WHERE  type IN ('PK', 'F', 'UQ')   -- primary key, foreign key, unique
ORDER  BY schema_name, table_name;

ALTER TABLE gold.factsupplier DROP CONSTRAINT IF EXISTS PK_gold_factsupplier;
PK_gold_factsupplier