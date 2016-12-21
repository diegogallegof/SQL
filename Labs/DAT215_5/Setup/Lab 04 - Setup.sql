CREATE TABLE [SalesLT].[SalesTerritory](
	[TerritoryID] [int] PRIMARY KEY,
	[CountryRegionCode] [nvarchar](3) NOT NULL,
	[SalesLastYear] [money] NOT NULL)

GO

	INSERT [SalesLT].[SalesTerritory]
	VALUES (1,'GBR',0)

	INSERT [SalesLT].[SalesTerritory]
	VALUES (2,'USA',1000)