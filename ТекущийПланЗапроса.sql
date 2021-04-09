SELECT 
	sqltext.TEXT AS [����� �������],
	req.session_id AS [������],
	req.status AS [���������],
	req.command AS [��� �������],
	req.cpu_time AS [CPU],
	req.total_elapsed_time AS [����� ����������],
	qerPlan.query_plan AS [���� �������]
FROM sys.dm_exec_requests req
	CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS sqltext
	CROSS APPLY sys.dm_exec_query_plan(req.plan_handle) qerPlan