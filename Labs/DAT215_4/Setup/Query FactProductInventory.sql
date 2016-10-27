/************************************************************************
 * Step 1 - Only execute one step at a time								*
 *																		*
 * Use the sp_spaceused function and note the size of the current table.*
 *																		*
 * e.g. data = 45,552 KB												*
 *																		*
 ************************************************************************/
SET STATISTICS TIME OFF
GO
USE AdventureWorksDW
GO

sp_spaceused 'dbo.FactProductInventory';
GO

-------- end of Step 1 --------

/************************************************************************
 * Step 2 - Only execute one step at a time								*
 *																		*
 * Execute the below with Execution Plan on note the execution time.	*
 *																		*
 * e.g. CPU time = 2436 ms,  elapsed time = 4414 ms.					*
 ************************************************************************/

SET STATISTICS TIME ON
GO

SELECT p.EnglishProductName
		,d.WeekNumberOfYear
		,d.CalendarYear
		,AVG(fpi.UnitCost) AvgCost
		,SUM(fpi.UnitsOut) TotalUnits
		,MAX(fpi.UnitCost) HighestPrice
FROM dbo.FactProductInventory as fpi
INNER JOIN dbo.DimProduct as p ON fpi.ProductKey = p.ProductKey
INNER JOIN dbo.DimDate as d ON fpi.DateKey = d.DateKey
GROUP BY p.EnglishProductName,
		d.WeekNumberOfYear,
		d.CalendarYear
ORDER BY p.EnglishProductName,
		d.CalendarYear,
		d.WeekNumberOfYear;
GO