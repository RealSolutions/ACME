exec bronze.usp_load_supplier;
GO
exec silver.usp_load_supplier;
GO
exec gold.usp_load_dimsupplier;
GO

select * from bronze.supplier
select * from silver.supplier
select * from gold.dimsupplier


exec bronze.usp_load_budget;
GO
exec silver.usp_load_budget;
GO
exec gold.usp_load_factbudget;
GO

select * from bronze.budget
select * from silver.budget
select * from gold.factbudget


exec bronze.usp_load_actual;
GO
exec silver.usp_load_actual;
GO
exec gold.usp_load_factactual;
GO

select * from bronze.actual
select * from silver.actual
select * from gold.factactual