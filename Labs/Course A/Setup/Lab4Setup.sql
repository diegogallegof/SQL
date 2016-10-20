CREATE TABLE SalesLT.MediaOutlet (
MediaOutletID INT NOT NULL,
MediaOutletName NVARCHAR(40),
PrimaryContact NVARCHAR (50),
City NVARCHAR (50)
);

GO
CREATE TABLE SalesLT.PrintMediaPlacement ( PrintMediaPlacementID INT NOT NULL,
MediaOutletID INT,
PlacementDate DATETIME,
PublicationDate DATETIME,
RelatedProductID INT,
PlacementCost DECIMAL(18,2)
);
