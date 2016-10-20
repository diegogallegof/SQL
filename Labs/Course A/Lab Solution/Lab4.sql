--Challenge 1

ALTER TABLE SalesLT.MediaOutlet ADD CONSTRAINT IX_MediaOutlet UNIQUE CLUSTERED (
MediaOutletID
);
GO

CREATE UNIQUE CLUSTERED INDEX CIX_PrintMediaPlacement ON SalesLT.PrintMediaPlacement (
PrintMediaPlacementID ASC
);



--Challenge 2

USE [AdventureWorksLT]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [SalesLT].[PrintMediaPlacement] ([PublicationDate],[PlacementCost])
INCLUDE ([MediaOutletID],[PlacementDate],[RelatedProductID])
GO