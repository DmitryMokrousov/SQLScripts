SELECT  session_id AS [SPID], 
  wait_time/1000 AS [WaitTime(sec)], 
  wait_type AS [WaitType], 
  Command, 
  percent_complete AS [PercentComplete], 
  estimated_completion_time/1000 AS [TimeRemaining(sec)]
FROM sys.dm_exec_requests
WHERE Command LIKE '%RESTORE%'
OR Command LIKE '%BACKUP%'
OR Command LIKE '%DBCC%';