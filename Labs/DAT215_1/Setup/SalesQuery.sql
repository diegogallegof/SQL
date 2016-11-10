SELECT PMP.*, MO.City 
FROM SalesLT.PrintMediaPlacement PMP
JOIN SalesLT.MediaOutlet MO ON PMP.MediaOutletID=MO.MediaOutletID
WHERE PublicationDate BETWEEN '2016-09-1' AND '2016-09-30'
AND PlacementCost BETWEEN 1 AND 2000
ORDER BY PlacementCost DESC;