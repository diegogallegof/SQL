--Step 3
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
SELECT [SalesOrderDetailID]
      ,[OrderQty]      
  FROM [SalesLT].[SalesOrderDetail]
  ORDER BY [SalesOrderDetailID]
GO

--Step 4
SET TRANSACTION ISOLATION LEVEL SNAPSHOT

--Step 5
SELECT [SalesOrderDetailID]
      ,[OrderQty]      
  FROM [SalesLT].[SalesOrderDetail]
  ORDER BY [SalesOrderDetailID]
GO

--Step 8
SELECT [SalesOrderDetailID]
      ,[OrderQty]      
  FROM [SalesLT].[SalesOrderDetail]
  ORDER BY [SalesOrderDetailID]
GO