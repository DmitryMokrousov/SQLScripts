select der.cpu_time, dest.text, deqp.query_plan, der.* from sys.dm_exec_requests as der
CROSS APPLY sys.dm_exec_sql_text(der.sql_handle) dest
CROSS APPLY sys.dm_exec_query_plan(der.plan_handle) AS deqp

order by der.cpu_time desc