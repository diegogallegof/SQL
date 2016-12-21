-- Task 1 
-- Collect an actual execution plan for the query shown under the heading for task 1. 
-- Save the actual query plan on your desktop as plan1.sqlplan. Note the execution time.
USE AdventureWorksLT;
GO
SELECT c.CampaignName, c.CampaignStartDate, c.CampaignEndDate,
SUM(cr.ConvertedSaleValueUSD) AS SalesValue
FROM Proseware.Campaign AS c
JOIN Proseware.CampaignResponse AS cr
ON cr.CampaignID = c.CampaignID
WHERE cr.ConvertedToSale = 1
GROUP BY c.CampaignName, c.CampaignStartDate, c.CampaignEndDate
OPTION (RECOMPILE); --RECOMPILE option is used to ensure the plan is not drawn from the cache

-- Task 2 
-- Execute the following query to rebuild the statistics held for the 
-- Proseware.Campaign and Proseware.CampaignResponse tables.
ALTER TABLE Proseware.Campaign REBUILD
GO
ALTER TABLE Proseware.CampaignResponse REBUILD;
GO

-- Task 3
-- Re-run the query under the heading for task 1 and collect a new actual execution plan. 
-- Compare the new execution plan to the plan you saved in task 1 (as plan1.sqlplan)



