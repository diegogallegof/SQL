-- Create a Memory Optimized Table
USE AdventureWorksDW
GO
CREATE TABLE dbo.ShoppingCart
(SessionID INT NOT NULL,
TimeAdded DATETIME NOT NULL,
CustomerKey INT NOT NULL,
ProductKey INT NOT NULL,
Quantity INT NOT NULL
PRIMARY KEY NONCLUSTERED (SessionID, ProductKey)) 
WITH  (MEMORY_OPTIMIZED = ON,  DURABILITY = SCHEMA_AND_DATA);


-- Test the Table

USE AdventureWorksDW
GO

INSERT INTO dbo.ShoppingCart (SessionID, TimeAdded, CustomerKey, ProductKey, Quantity)
VALUES (1, GETDATE(), 2, 3, 1);

INSERT INTO dbo.ShoppingCart (SessionID, TimeAdded, CustomerKey, ProductKey, Quantity)
VALUES (1, GETDATE(), 2, 4, 1);

SELECT * FROM dbo.ShoppingCart;


-- Create AddItemToCart Native Procedure

USE AdventureWorksDW
GO
CREATE PROCEDURE dbo.AddItemToCart
@SessionID INT, @TimeAdded DATETIME, @CustomerKey INT, @ProductKey INT, @Quantity INT
WITH NATIVE_COMPILATION, SCHEMABINDING, EXECUTE AS OWNER
AS
BEGIN ATOMIC WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, LANGUAGE = 'us_english')
INSERT INTO dbo.ShoppingCart (SessionID, TimeAdded, CustomerKey, ProductKey, Quantity)
VALUES (@SessionID, @TimeAdded, @CustomerKey, @ProductKey, @Quantity)
END
GO

-- Create DeleteItemFromCart Native Procedure

USE AdventureWorksDW
GO
CREATE PROCEDURE dbo.DeleteItemFromCart
@SessionID INT, @ProductKey INT
WITH NATIVE_COMPILATION, SCHEMABINDING, EXECUTE AS OWNER
AS
BEGIN ATOMIC WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, LANGUAGE = 'us_english')
DELETE FROM dbo.ShoppingCart 
WHERE SessionID = @SessionID
AND ProductKey = @ProductKey
END
GO

-- Create EmptyCart Native Procedure

USE AdventureWorksDW
GO
CREATE PROCEDURE dbo.EmptyCart
@SessionID INT
WITH NATIVE_COMPILATION, SCHEMABINDING, EXECUTE AS OWNER
AS
BEGIN ATOMIC WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, LANGUAGE = 'us_english')
DELETE FROM dbo.ShoppingCart 
WHERE SessionID = @SessionID
END
GO

--Test the Procedures

--Step 1 - Use the InternetSales database
USE AdventureWorksDW
GO

--Step 2 - Add items to cart
DECLARE @now DATETIME = GETDATE();
EXEC dbo.AddItemToCart
	@SessionID = 3,
	@TimeAdded = @now,
	@CustomerKey = 2,
	@ProductKey = 3,
	@Quantity = 1;

EXEC dbo.AddItemToCart  
	@SessionID = 3,
	@TimeAdded = @now,
	@CustomerKey = 2,
	@ProductKey = 4,
	@Quantity = 1;

--Step 3 - Select items in cart	
SELECT * FROM dbo.ShoppingCart;

--Step 4 - Delete item from cart
EXEC dbo.DeleteItemFromCart 
	@SessionID = 3, 
	@ProductKey = 4;

--Step 5 - Select items in cart		
SELECT * FROM dbo.ShoppingCart;

--Step 6 - Empty cart	
EXEC dbo.EmptyCart 
	@SessionID = 3;
	
--Step 7 - Select items in cart	
SELECT * FROM dbo.ShoppingCart;

