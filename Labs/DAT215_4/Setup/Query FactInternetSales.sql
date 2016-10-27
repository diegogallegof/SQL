/************************************************************************
 * Step 1 - Only execute one step at a time								*
 *																		*
 * Use the sp_spaceused function and note the size of the current table.*
 * Also note the execution time. Record the vlaue below					*
 *																		*
 * e.g. data = 615,584 KB	(~600 MB)									*
 *																		*
 ************************************************************************/
SET STATISTICS TIME OFF
GO
USE [AdventureWorksDW]
GO

sp_spaceused 'dbo.FactInternetSales'
GO

/************************************************************************
 * Step 2 - Only execute one step at a time								*
 *																		*
 * Execute the below with Execution Plan on note the execution time.	*
 * Record the vlaue below.												*
 *																		*
 * e.g. CPU time = 5313 ms,  elapsed time = 14494 ms.					*
 *																		*
 ************************************************************************/

SET STATISTICS TIME ON
GO

SELECT SalesTerritoryRegion
		,p.EnglishProductName
		,d.WeekNumberOfYear
		,d.CalendarYear
		,SUM(fi.SalesAmount) Revenue
		,AVG(OrderQuantity) AverageQuantity
		,STDEV(UnitPrice) PriceStandardDeviation
		,SUM(TaxAmt) TotalTaxPayable
FROM dbo.FactInternetSales as fi
INNER JOIN dbo.DimProduct as p ON fi.ProductKey = p.ProductKey
INNER JOIN dbo.DimDate as d ON fi.OrderDate = d.FullDateAlternateKey
INNER JOIN dbo.DimSalesTerritory as st on fi.SalesTerritoryKey = st.SalesTerritoryKey
	AND fi.OrderDate BETWEEN '1/1/2007' AND '12/31/2007'
GROUP BY SalesTerritoryRegion, d.CalendarYear, d.WeekNumberOfYear, p.EnglishProductName
ORDER BY SalesTerritoryRegion, SUM(fi.SalesAmount) desc;