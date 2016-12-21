--Step 1
SELECT [SalesOrderDetailID]
      ,[OrderQty]      
  FROM [SalesLT].[SalesOrderDetail]
  ORDER BY [SalesOrderDetailID]
GO

--Step 2
BEGIN TRAN
UPDATE SalesLT.SalesOrderDetail
SET OrderQty=OrderQty+1

--Step 6
UPDATE SalesLT.SalesOrderDetail
SET OrderQty=OrderQty+10

--Step 7
SELECT [SalesOrderDetailID]
      ,[OrderQty]      
  FROM [SalesLT].[SalesOrderDetail]
  ORDER BY [SalesOrderDetailID]
GO

--Step 9
ROLLBACK