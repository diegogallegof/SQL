---------------------------------------------------------------------
-- Task 2 - Run a Workload
---------------------------------------------------------------------

DECLARE @start datetime2 = GETDATE(), @rnd int, @rc int;
WHILE DATEDIFF(ss,@start,GETDATE()) < 60 
BEGIN
	IF @@SPID % 10 = 9
	BEGIN
		SET @rnd = RAND()*10;
		EXEC Proseware.up_Campaign_Replace @rnd = @rnd;

	END
	ELSE
	BEGIN
		WAITFOR DELAY '00:00:01';
		EXEC Proseware.up_Campaign_Report
		WAITFOR DELAY '00:00:00.050';
	END


END


---------------------------------------------------------------------
-- Task 3 - Capture Lock Wait Statistics
---------------------------------------------------------------------
SELECT wait_type, waiting_tasks_count, wait_time_ms, 
max_wait_time_ms, signal_wait_time_ms
INTO #task3
FROM sys.dm_os_wait_stats
WHERE wait_type LIKE 'LCK%' 
AND wait_time_ms > 0
ORDER BY wait_time_ms DESC;

---------------------------------------------------------------------
-- Task 5 - Implement SNAPSHOT isolation (amend Lab Exercise 01 - stored procedure.sql)
---------------------------------------------------------------------
ALTER PROC Proseware.up_Campaign_Report
AS
	SET TRANSACTION ISOLATION LEVEL SNAPSHOT;
	SELECT TOP 10 * FROM Sales.SalesTerritory AS T
	JOIN (
		SELECT CampaignTerritoryID, 
		DATEPART(MONTH, CampaignStartDate) as start_month_number,
		DATEPART(MONTH, CampaignEndDate) as end_month_number, 
		COUNT(*) AS campaign_count
		FROM Proseware.Campaign 
		GROUP BY CampaignTerritoryID, DATEPART(MONTH, CampaignStartDate),DATEPART(MONTH, CampaignEndDate)
	) AS x
	ON x.CampaignTerritoryID = T.TerritoryID
	ORDER BY campaign_count;
GO

---------------------------------------------------------------------
-- Task 6 - Clear wait statistics
-- Rerun the query under the heading for Task 1
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Task 7 - Rerun the Workload
-- Rerun the sample workload by right-clicking 
-- D:\Labfiles\Lab05\Starter\start_load_exercise_01.ps1 and clicking "Run with PowerShell"
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Task 8 - Capture Lock Wait Statistics
-- Amend the query to capture lock wait statistics into a temporary table called #task8
---------------------------------------------------------------------
SELECT wait_type, waiting_tasks_count, wait_time_ms, 
max_wait_time_ms, signal_wait_time_ms
INTO 
FROM sys.dm_os_wait_stats
WHERE wait_type LIKE 'LCK%' 
AND wait_time_ms > 0
ORDER BY wait_time_ms DESC;

---------------------------------------------------------------------
-- Task 9 - Compare Overall Lock Wait Time
-- Execute the following query to compare the wait statistics captured in task 3 and in task 8
---------------------------------------------------------------------
SELECT SUM(t3.wait_time_ms) AS baseline_wait_time_ms,
SUM(t8.wait_time_ms) AS SNAPSHOT_wait_time_ms
FROM #task3 AS t3
FULL OUTER JOIN #task8 AS t8
ON t8.wait_type = t3.wait_type;

