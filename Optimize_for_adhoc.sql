
SELECT sc.*
FROM sys.configurations AS sc
WHERE sc.name = 'optimize for ad hoc workloads';


EXEC sp_configure 'optimize for ad hoc workloads', 0;
go
RECONFIGURE;
go