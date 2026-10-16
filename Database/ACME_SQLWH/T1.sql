-- Write your own SQL object definition here, and it'll be included in your package.
--Loader Executor
EXEC bronze.usp_load_supplier
GO
EXEC silver.usp_load_supplier
GO
EXEC gold.usp_load_dimsupplier
GO

select * from  bronze.supplier
GO

select * from  silver.supplier
GO

select * from  gold.dimsupplier
GO



-- ----------------------------------------
EXEC bronze.usp_load_budget
GO
EXEC silver.usp_load_budget
GO
EXEC gold.usp_load_factbudget
GO

select * from  bronze.budget
GO

select * from  silver.budget
GO

select * from  gold.factbudget
GO


-- ----------------------------------------
truncate table  silver.actual
truncate table  gold.factactual
EXEC bronze.usp_load_actual
GO
EXEC silver.usp_load_actual
GO
EXEC gold.usp_load_factactual
GO

select * from  bronze.actual
GO

select * from  silver.actual
GO

select * from  gold.factactual
GO