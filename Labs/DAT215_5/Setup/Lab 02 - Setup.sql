USE AdventureWorksLT;
GO
CREATE SCHEMA Proseware;
GO
CREATE TABLE Proseware.Campaign
(CampaignID int PRIMARY KEY,
CampaignName varchar(20) NOT NULL,
CampaignTerritoryID int NOT NULL,
CampaignStartDate date NOT NULL,
CampaignEndDate date NOT NULL
)
GO
/*ALTER TABLE Proseware.Campaign WITH CHECK ADD  CONSTRAINT FK_Campaign_SalesTerritory FOREIGN KEY (CampaignTerritoryID)
REFERENCES Sales.SalesTerritory(TerritoryID)
GO
ALTER TABLE Proseware.Campaign CHECK CONSTRAINT FK_Campaign_SalesTerritory
GO
*/
INSERT Proseware.Campaign
(CampaignID, CampaignName, CampaignTerritoryID, CampaignStartDate, CampaignEndDate)
SELECT TOP (10000)
ROW_NUMBER() OVER (ORDER BY a.name, b.name),
CAST(1000000 +ROW_NUMBER() OVER (ORDER BY a.name, b.name) AS nvarchar(20)),
(ROW_NUMBER() OVER (ORDER BY a.name, b.name) % 10) + 1,
DATEADD(dd, ROW_NUMBER() OVER (ORDER BY a.name, b.name) % 3650, '2006-01-01'),
DATEADD(dd, (ROW_NUMBER() OVER (ORDER BY a.name, b.name) % 3650) + 30, '2006-01-01')
FROM SalesLT.Product AS a
CROSS JOIN SalesLT.Product AS b
GO
--CREATE INDEX ix_CampaignResponse_CampaignName ON Proseware.Campaign(CampaignName);
--DROP INDEX Proseware.Campaign.ix_CampaignResponse_CampaignName;

--truncate table Proseware.Campaign
--select * from Proseware.Campaign order by CampaignEndDate desc
GO
CREATE TABLE Proseware.CampaignResponse
(CampaignResponseID int IDENTITY(1,1) PRIMARY KEY,
CampaignID int NOT NULL,
ResponseDate date NOT NULL,
ConvertedToSale bit NOT NULL,
ConvertedSaleValueUSD decimal(20,2) NULL
)

GO
ALTER TABLE Proseware.CampaignResponse WITH CHECK ADD  CONSTRAINT FK_CampaignResponse_Campaign FOREIGN KEY (CampaignID)
REFERENCES Proseware.Campaign(CampaignID)
GO
ALTER TABLE Proseware.CampaignResponse CHECK CONSTRAINT FK_CampaignResponse_Campaign
GO

;
WITH myCTE
AS
(
	SELECT c.*,
	ROW_NUMBER() OVER (PARTITION BY c.CampaignID ORDER BY b.name ) as rn1,
	CASE WHEN c.CampaignID % 10 < 4 THEN 1 ELSE 0 END AS rnd1
	FROM Proseware.Campaign AS c
	CROSS JOIN SalesLT.Product AS b
)
INSERT Proseware.CampaignResponse
(CampaignID, ResponseDate, ConvertedToSale, ConvertedSaleValueUSD)
SELECT c.CampaignID,
DATEADD(dd, rn1 % 40, c.CampaignStartDate),
c.rnd1,
CASE WHEN rnd1 = 1 THEN rn1 * 1.99 ELSE NULL END
FROM myCTE AS c
WHERE c.rn1 <= c.CampaignID % 1000
GO

UPDATE STATISTICS Proseware.Campaign WITH ROWCOUNT = 10, PAGECOUNT=  10;
UPDATE STATISTICS Proseware.CampaignResponse WITH ROWCOUNT = 10, PAGECOUNT=  10;
GO

CREATE PROCEDURE Proseware.up_CampaignResponse_Add
(
	@CampaignName int,
	@ResponseDate date,
	@ConvertedToSale bit,
	@ConvertedSaleValueUSD decimal(20,2)
)
WITH RECOMPILE AS
	SET NOCOUNT ON	
	DECLARE @CampaignId int;

	-- lookup CampaignId
	SELECT @CampaignId = CampaignID
	FROM Proseware.Campaign
	WHERE CampaignName = @CampaignName;

	--insert values
	INSERT Proseware.CampaignResponse
	(CampaignID, ResponseDate, ConvertedToSale, ConvertedSaleValueUSD)
	VALUES
	(@CampaignId,@ResponseDate, @ConvertedToSale, @ConvertedSaleValueUSD);
GO