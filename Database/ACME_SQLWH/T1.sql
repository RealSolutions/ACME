-- Write your own SQL object definition here, and it'll be included in your package.
--Loader Executor
EXEC Bronze.usp_Load_Supplier
GO
EXEC Silver.usp_Load_Supplier
GO
EXEC Gold.usp_Load_DimSupplier
GO

select * from  Bronze.Supplier
GO

select * from  Silver.Supplier
GO

select * from  Gold.DimSupplier
GO



-- ----------------------------------------
EXEC Bronze.usp_Load_Budget
GO
EXEC Silver.usp_Load_Budget
GO
EXEC Gold.usp_Load_FactBudget
GO

select * from  Bronze.Budget
GO

select * from  Silver.Budget
GO

select * from  Gold.FactBudget
GO


-- ----------------------------------------
truncate table  Silver.Actual
truncate table  Gold.FactActual
EXEC Bronze.usp_Load_Actual
GO
EXEC Silver.usp_Load_Actual
GO
EXEC Gold.usp_Load_FactActual
GO

select * from  Bronze.Actual
GO

select * from  Silver.Actual
GO

select * from  Gold.FactActual
GO