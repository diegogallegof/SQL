--Challenge 1

--Nullability

ALTER TABLE DirectMarketing.Opportunity
ALTER COLUMN OpportunityID int NOT NULL;
GO
ALTER TABLE DirectMarketing.Opportunity
ALTER COLUMN ProspectID int NOT NULL;
GO
ALTER TABLE DirectMarketing.Opportunity
ALTER COLUMN DateRaised datetime NOT NULL;
GO
ALTER TABLE DirectMarketing.Opportunity
ALTER COLUMN Likelihood tinyint NOT NULL;
GO
ALTER TABLE DirectMarketing.Opportunity
ALTER COLUMN Rating char(1) NOT NULL;
GO
ALTER TABLE DirectMarketing.Opportunity
ALTER COLUMN EstimatedClosingDate date NOT NULL;
GO
ALTER TABLE DirectMarketing.Opportunity
ALTER COLUMN EstimatedRevenue decimal(10,2) NOT NULL;
GO

--Primary Key

ALTER TABLE DirectMarketing.Opportunity
ADD CONSTRAINT PK_Opportunity PRIMARY KEY CLUSTERED (OpportunityID, ProspectID);
GO

--Default

ALTER TABLE DirectMarketing.Opportunity
ADD CONSTRAINT dfDateRaised
DEFAULT (SYSDATETIME()) FOR DateRaised; 
GO

--Challenge 2

INSERT INTO [DirectMarketing].[Opportunity]
           ([OpportunityID]
           ,[ProspectID]
           ,[Likelihood]
           ,[Rating]
           ,[EstimatedClosingDate]
           ,[EstimatedRevenue])
     VALUES
           (1,1,8,'A','12/12/2013',123000.00)
GO