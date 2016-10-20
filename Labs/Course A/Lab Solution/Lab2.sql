--Challenge 1

CREATE SCHEMA DirectMarketing
AUTHORIZATION dbo;
GO


--Challenge 2

CREATE TABLE DirectMarketing.Competitor
(
CompetitorCode nvarchar(6) NOT NULL,
Name varchar(30) NOT NULL,
[Address] varchar(max) NULL,
Date_Entered varchar(10) NULL,
Strength_of_competition varchar(8) NULL,
Comments varchar(max) NULL
);
GO



CREATE TABLE DirectMarketing.TVAdvertisement
(
TV_Station nvarchar(15) NOT NULL,
City nvarchar(25) NULL,
CostPerAdvertisement float NULL,
TotalCostOfAllAdvertisements float NULL,
NumberOfAdvertisements varchar(4) NULL,
Date_Of_Advertisement_1 varchar(12) NULL,
Time_Of_Advertisement_1	int NULL,
Date_Of_Advertisement_2	varchar(12) NULL,
Time_Of_Advertisement_2	int NULL,
Date_Of_Advertisement_3	varchar(12) NULL,
Time_Of_Advertisement_3	int NULL,
Date_Of_Advertisement_4	varchar(12) NULL,
Time_Of_Advertisement_4	int NULL,
Date_Of_Advertisement_5	varchar(12) NULL,
Time_Of_Advertisement_5	int NULL
);
GO



CREATE TABLE DirectMarketing.CampaignResponse
(
ResponseOccurredWhen datetime, 
RelevantProspect int,
RespondedHow varchar(8),
ChargeFromReferrer float,
RevenueFromResponse float,
ResponseProfit AS (RevenueFromResponse - ChargeFromReferrer) PERSISTED
);
GO

