--Challenge 1

CREATE VIEW
SalesLT.OnlineProducts
AS
SELECT p.ProductID, p.Name, p.ProductNumber AS [Product Number], COALESCE(p.Color, 'N/A') AS Color,
p.Size,  p.ListPrice AS Price, p.Weight
FROM SalesLT.Product AS p
WHERE p.SellEndDate IS NULL AND p.SellStartDate IS NOT NULL;
GO



CREATE VIEW
SalesLT.AvailableModels
AS
SELECT p.ProductID AS [Product ID], p.Name, pm.ProductModelID AS [Product Model ID], pm.Name as [Product Model]
FROM SalesLT.Product AS p
INNER JOIN SalesLT.ProductModel AS pm
ON p.ProductModelID = pm.ProductModelID
WHERE p.SellEndDate IS NULL
AND p.SellStartDate IS NOT NULL;
GO

--Challenge2

CREATE VIEW SalesLT.NewCustomer
AS
SELECT CustomerID, FirstName, LastName, PasswordHash, PasswordSalt 
FROM SalesLT.Customer;
GO

INSERT INTO SalesLT.NewCustomer
VALUES
('Ed', 'Kish','Uw8sEe4ZGPvigEQEiSJ57Bd77SB77S','cjsKU4w=')
GO
