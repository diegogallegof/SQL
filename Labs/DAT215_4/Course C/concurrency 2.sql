-- Module 5 Demonstration 1 File 2

-- Switch this query window to use your copy of the AdventureWorksLT database

-- Query 1
BEGIN TRANSACTION
	UPDATE SalesLT.Customer
	SET Phone = N'999-555-9999'
	WHERE CustomerID = 2;

-- Query 2
ROLLBACK

-- Query 3
UPDATE SalesLT.Customer
SET Phone = N'333-555-3333'
WHERE CustomerID = 2;

-- Query 4
UPDATE SalesLT.Customer
SET Phone = N'444-555-4444'
WHERE CustomerID = 2;

-- Query 5 -- adds a new row
INSERT SalesLT.Customer
(NameStyle, Title, FirstName, MiddleName, LastName, Suffix, CompanyName, SalesPerson, EmailAddress, Phone, PasswordHash, PasswordSalt, ModifiedDate)
SELECT NameStyle, Title, FirstName, MiddleName, LastName, Suffix,  N'Demo Sports' AS CompanyName, SalesPerson, EmailAddress, 
N'111-555-1111' AS Phone, PasswordHash, PasswordSalt, GETDATE() AS ModifiedDate
FROM SalesLT.Customer
WHERE CustomerID = 2;

-- Query 6
BEGIN TRANSACTION
	UPDATE SalesLT.Customer
	SET Phone = N'616-555-6161'
	WHERE CustomerID = 2;

-- Query 7
COMMIT

