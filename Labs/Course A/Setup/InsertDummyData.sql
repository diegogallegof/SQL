Declare @start int=1, @end int=32767
-- Use a CTE to create ID's
;With MediaIDS( Number ) as
(
    Select @start as Number
        union all
    Select Number + 1
        from MediaIDS
        where Number < @end
)
--Can only recurse 32767 times
INSERT INTO SalesLT.MediaOutlet
           (MediaOutletID
           ,MediaOutletName
           ,PrimaryContact
           ,City)
Select Number, 
NEWID() Name, -- random name etc
NEWID() Contact,
NEWID() City
from MediaIDS Option (MaxRecursion 32767);

;With MediaIDS( Number ) as
(
    Select @start as Number
        union all
    Select Number + 1
        from MediaIDS
        where Number < @end
)
--Can only recurse 32767 times
INSERT INTO SalesLT.PrintMediaPlacement
           (PrintMediaPlacementID
           ,MediaOutletID
           ,PlacementDate
           ,PublicationDate
		   ,RelatedProductID
		   ,PlacementCost)
Select Number,
ABS(CHECKSUM(NewId())) % 32767 MediaID,
GETDATE() - ABS(CHECKSUM(NewId())) % 365,
GETDATE() - ABS(CHECKSUM(NewId())) % 365,
ABS(CHECKSUM(NewId())) % 32767 ProductID,
RAND(ABS(CHECKSUM(NewId())) % 32767)*1000
from MediaIDS Option (MaxRecursion 32767);



