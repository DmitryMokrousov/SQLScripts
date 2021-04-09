--source
--https://www.mssqltips.com/sqlservertip/3347/drop-and-recreate-all-foreign-key-constraints-in-sql-server/

CREATE TABLE #x -- feel free to use a permanent table
(
  drop_script NVARCHAR(MAX),
  create_script NVARCHAR(MAX)
);
  
DECLARE @drop   NVARCHAR(MAX) = N'',
        @create NVARCHAR(MAX) = N'';

-- drop is easy, just build a simple concatenated list from sys.foreign_keys:
SELECT @drop += N'
ALTER TABLE ' + QUOTENAME(cs.name) + '.' + QUOTENAME(ct.name) 
    + ' DROP CONSTRAINT ' + QUOTENAME(fk.name) + ';'
FROM sys.foreign_keys AS fk
INNER JOIN sys.tables AS ct
  ON fk.parent_object_id = ct.[object_id]
INNER JOIN sys.schemas AS cs 
  ON ct.[schema_id] = cs.[schema_id];

INSERT #x(drop_script) SELECT @drop;

select * 
from #x