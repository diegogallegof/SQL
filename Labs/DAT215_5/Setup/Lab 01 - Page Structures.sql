-- Task 1
SELECT db_name(database_id) AS Database_Name, 
	object_name([object_id]) AS Table_Name, 
	allocation_unit_type, 
	allocation_unit_type_desc,
	allocated_page_file_id, 
	allocated_page_page_id, 
	page_type, 
	page_type_desc 
FROM sys.dm_db_database_page_allocations(db_id('AdventureWorksLT'),NULL,NULL,NUll,
'DETAILED')
WHERE object_name([object_id])='Product'
AND page_type IS NOT NULL;


-- Task 2
SELECT db_name(database_id) AS Database_Name, 
	object_name([object_id]) AS Table_Name, 
	index_id,
	partition_number,
	index_type_desc,
	alloc_unit_type_desc,
	index_depth,
	index_level,
	avg_fragmentation_in_percent,
	fragment_count,
	avg_fragment_size_in_pages,
	page_count
from sys.dm_db_index_physical_stats (db_id('AdventureWorksLT'),NULL,NULL,NULL,NULL)
WHERE object_name([object_id])='Product'
