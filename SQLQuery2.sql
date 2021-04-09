SELECT *,
    [DirtyPageCount] * 8 / 1024 AS [DirtyPageMB],
    [CleanPageCount] * 8 / 1024 AS [CleanPageMB]
FROM
    (SELECT
        (CASE WHEN ([database_id] = 32767)
            THEN N'Resource Database'
            ELSE DB_NAME ([database_id]) END) AS [DatabaseName],
        SUM (CASE WHEN ([is_modified] = 1)
            THEN 1 ELSE 0 END) AS [DirtyPageCount],
        SUM (CASE WHEN ([is_modified] = 1)
            THEN 0 ELSE 1 END) AS [CleanPageCount]
    FROM sys.dm_os_buffer_descriptors
    GROUP BY [database_id]) AS [buffers]
ORDER BY [DatabaseName]
GO

DBCC CHECKDB('TritonUPP_Maymulin_30_08_15')

DBCC DROPCLEANBUFFERS

SELECT DB_ID('TritonUPP_Maymulin_30_08_15') AS [Database ID];  
GO

exec sp_spaceused;
go

SELECT
    (CASE WHEN ([database_id] = 32767)
        THEN N'Resource Database'
        ELSE DB_NAME ([database_id]) END) AS [DatabaseName],
    COUNT (*) * 8 / 1024 AS [MBUsed],
    SUM (CAST ([free_space_in_bytes] AS BIGINT)) / (1024 * 1024) AS [MBEmpty]
FROM sys.dm_os_buffer_descriptors
GROUP BY [database_id];
GO

USE [TritonUPP_Maymulin_30_08_15]
GO

CHECKPOINT
GO