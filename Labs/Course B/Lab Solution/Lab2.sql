--Challenge 1
--Create TR_ProductListPrice_Update Trigger

CREATE TRIGGER SalesLT.TR_ProductListPrice_Update
ON SalesLT.Product
AFTER UPDATE
AS BEGIN
	SET NOCOUNT ON;
	INSERT SalesLT.ProductAudit(ProductID, UpdateTime, ModifyingUser, OriginalListPrice,NewListPrice)
	SELECT Inserted.ProductID,SYSDATETIME(),ORIGINAL_LOGIN(),deleted.ListPrice, inserted.ListPrice
	FROM deleted
	INNER JOIN inserted
	ON deleted.ProductID = inserted.ProductID
	WHERE deleted.ListPrice > 1000 OR inserted.ListPrice > 1000;
END;
GO
FROM SalesLT.Product AS p
WHERE (p.Color = @Color) OR (p.Color IS NULL AND @Color IS NULL)
ORDER BY Name;
END
GO

--Test the Behavior of the Trigger

UPDATE SalesLT.Product
SET ListPrice=3978.00
WHERE ProductID BETWEEN 749 and 753;
GO


SELECT * FROM SalesLT.ProductAudit;
GO

