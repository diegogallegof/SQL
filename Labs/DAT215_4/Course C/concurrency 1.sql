-- Module 5 Demonstration 1 File 1

-- Step 1: Switch this query window to use the AdventureWorksLT database

-- Step 2: Switch the Demo 1b - concurrency 2.sql query to use the AdventureWorksLT database

-- Step 3: Demonstrate the settings for ALLOW_SNAPSHOT_ISOLATION and READ_COMMITTED_SNAPSHOT 
SELECT name, snapshot_isolation_state, is_read_committed_snapshot_on FROM sys.databases;

-- Step 4: Examine the row the examples will change
-- The value of the Phone column is 170-555-0127
SELECT CustomerID, Phone FROM SalesLT.Customer WHERE CustomerID = 2;

-- Step 5: Demonstrate a dirty read in READ UNCOMMITTED isolation
-- Run the statement under the heading Query 1 in the Demo 1b - concurrency 2.sql file, then return to this query
-- Run the statements below. Note that the updated value for the Phone column is shown, even through the transaction is not committed
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
GO
SELECT CustomerID, Phone 
FROM SalesLT.Customer
WHERE CustomerID = 2;
GO

-- Step 6: Demonstrate that READ COMMITTED isolation with READ_COMMITTED_SNAPSHOT OFF prevents a dirty read
-- Note that in Azure SQL database, READ_COMMITTED_SNAPSHOT is ON by default and cannot be disabled.
-- Using the READCOMMITTEDLOCK table hint disables row versioning.
-- Demonstrate that this query waits 
-- Run the statement under the heading Query 2 in the Demo 1b - concurrency 2.sql file, then return to this query
-- Once the blocking session is rolled back, this query returns a value
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
SELECT CustomerID, Phone 
FROM SalesLT.Customer WITH (READCOMMITTEDLOCK)
WHERE CustomerID = 2;
GO

-- Step 7: Demonstrate that READ COMMITTED isolation with READ_COMMITTED_SNAPSHOT OFF allows a non-repeatable read
-- Run the following statements
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRANSACTION
	SELECT CustomerID, Phone 
	FROM SalesLT.Customer WITH (READCOMMITTEDLOCK)
	WHERE CustomerID = 2;

-- Run the statement under the heading Query 3 in the Demo 1b - concurrency 2.sql file, then return to this query
-- Run the following query. Note that the value of the Phone column has changed during the transaction
	SELECT CustomerID, Phone 
	FROM SalesLT.Customer WITH (READCOMMITTEDLOCK)
	WHERE CustomerID = 2;
COMMIT

-- Step 8: Demonstrate that REPEATABLE READ isolation prevents a non-repeatable read
-- Run the following statements
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
GO
BEGIN TRANSACTION
	SELECT CustomerID, Phone 
	FROM SalesLT.Customer
	WHERE CustomerID = 2;

-- Run the statement under the heading Query 4 in the Demo 1b - concurrency 2.sql file, then return to this query
-- Note that the query in the Demo 1b - concurrency 2.sql file is blocked
-- Run the following query. Note that the value of the Phone column has not changed during the transaction
-- Note that, once this transaction is committed, the query in the Demo 1b - concurrency 2.sql completes
	SELECT CustomerID, Phone 
	FROM SalesLT.Customer
	WHERE CustomerID = 2;
COMMIT

-- Step 9: Demonstrate that REPEATABLE READ isolation allows a phantom read
-- Run the following statements
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
GO
BEGIN TRANSACTION
	SELECT COUNT(*) AS CustCount 
	FROM SalesLT.Customer
	WHERE Phone < '111-555-2222';

-- Run the statement under the heading Query 5 in the Demo 1b - concurrency 2.sql file, then return to this query
-- Run the following query. Note that the value of the count has increased by one
	SELECT COUNT(*) AS CustCount 
	FROM SalesLT.Customer
	WHERE Phone < '111-555-2222';
COMMIT

-- Step 10: Demonstrate that SERIALIZABLE isolation prevents a phantom read
-- Run the following statements
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION
	SELECT COUNT(*) AS CustCount 
	FROM SalesLT.Customer
	WHERE Phone < '111-555-2222';

-- Run the statement under the heading Query 5 in the Demo 1b - concurrency 2.sql file, then return to this query
-- Note that the query in the Demo 1b - concurrency 2.sql file is blocked
-- Run the following query. Note that the value of the count matches the first query
-- Note that, once this transaction is committed, the query in the Demo 1b - concurrency 2.sql completes
	SELECT COUNT(*) AS CustCount 
	FROM SalesLT.Customer
	WHERE Phone < '111-555-2222';
COMMIT

-- Step 11: Demonstrate READ COMMITTED isolation with READ_COMMITTED_SNAPSHOT ON
-- Reset the Phone value for customerID = 2
UPDATE SalesLT.Customer SET Phone = N'170-555-0127' WHERE CustomerID = 2
GO
-- Run the statement under the heading Query 6 in the Demo 1b - concurrency 2.sql file, then return to this query
-- run the following statements. Note that the committed value of the row is returned
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
BEGIN TRANSACTION 
	SELECT CustomerID, Phone 
	FROM SalesLT.Customer
	WHERE CustomerID = 2;

-- Run the statement under the heading Query 7 in the Demo 1b - concurrency 2.sql file, then return to this query
-- Execute the following statements. Note that the updated value of the row is returned
	SELECT CustomerID, Phone 
	FROM SalesLT.Customer
	WHERE CustomerID = 2;
COMMIT

-- Step 12: Demonstrate SNAPSHOT isolation
-- Reset the Phone value for customerID = 2
UPDATE SalesLT.Customer SET Phone = N'170-555-0127' WHERE CustomerID = 2
GO
-- Run the statement under the heading Query 6 in the Demo 1b - concurrency 2.sql file, then return to this query
-- run the following statements. Note that the committed value of the row is returned
SET TRANSACTION ISOLATION LEVEL SNAPSHOT
GO
BEGIN TRANSACTION 
	SELECT CustomerID, Phone 
	FROM SalesLT.Customer
	WHERE CustomerID = 2;

-- Run the statement under the heading Query 7 in the Demo 1b - concurrency 2.sql file, then return to this query
-- Execute the following statements. Note that the original value of the row is still returned
	SELECT CustomerID, Phone 
	FROM SalesLT.Customer
	WHERE CustomerID = 2;
COMMIT

-- Step 13: Demonstrate an update conflict in SNAPSHOT isolation:
-- Reset the Phone value for customerID = 2
UPDATE SalesLT.Customer SET Phone = N'170-555-0127' WHERE CustomerID = 2
GO
-- Run the statement under the heading Query 6 in the Demo 1b - concurrency 2.sql file, then return to this query
-- run the following statements. Note that the committed value of the row is returned
SET TRANSACTION ISOLATION LEVEL SNAPSHOT
GO
BEGIN TRANSACTION 
	UPDATE SalesLT.Customer
	SET Phone = N'777-555-7777'
	WHERE CustomerID = 2;

-- Run the statement under the heading Query 7 in the Demo 1b - concurrency 2.sql file, then return to this query
-- Note the error message

-- Execute the following statement to show that the transaction was aborted
SELECT @@TRANCOUNT;
