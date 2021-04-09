--http://sqlserverdb.blogspot.com/2011/08/how-to-check-autocreatestatistics-is.html
SELECT name AS 'Name', 
    is_auto_create_stats_on AS 'Auto Create Stats',
    is_auto_update_stats_on AS 'Auto Update Stats',
	is_auto_update_stats_async_on AS 'Auto Update Stats Async', 
    is_read_only AS 'Read Only' 
FROM sys.databases
WHERE database_ID > 4;

ALTER DATABASE WideWorldImporters SET AUTO_CREATE_STATISTICS ON;	
ALTER DATABASE WideWorldImporters SET AUTO_UPDATE_STATISTICS ON;
ALTER DATABASE WideWorldImporters SET AUTO_UPDATE_STATISTICS_ASYNC OFF;

ALTER DATABASE WideWorldImporters SET AUTO_CREATE_STATISTICS OFF;	
ALTER DATABASE WideWorldImporters SET AUTO_UPDATE_STATISTICS OFF;

set statistics io on;
set statistics time on;
set showplan_all on;


DBCC SHOW_Statistics (N'Application.CitiesCopy',N'CitiesCopy_StateProvinceId');

DBCC SHOW_Statistics (N'Application.CitiesCopy',N'IX_APCC_CityName');

DBCC SHOW_Statistics (N'Application.CitiesCopy',N'CityName');


UPDATE STATISTICS Application.CitiesCopy;
UPDATE STATISTICS Application.CitiesCopy WITH FULLSCAN;


--https://www.mssqltips.com/sqlservertip/2734/what-are-the-sql-server-wasys-statistics/
SELECT stat.name AS 'Statistics',
 OBJECT_NAME(stat.object_id) AS 'Object',
 COL_NAME(scol.object_id, scol.column_id) AS 'Column'
FROM sys.stats AS stat (NOLOCK) Join sys.stats_columns AS scol (NOLOCK)
 ON stat.stats_id = scol.stats_id AND stat.object_id = scol.object_id
 INNER JOIN sys.tables AS tab (NOLOCK) on tab.object_id = stat.object_id
WHERE stat.name like '_WA%'
ORDER BY stat.name;