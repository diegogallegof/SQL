USE AdventureWorksLT;
GO

SELECT * 
	FROM Production.Product
	WHERE [dbo].[IsRegexMatch] (Name, N'\b[Ww]heel\b') = 1; 


