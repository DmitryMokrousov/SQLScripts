set transaction isolation level read uncommitted;
select ISNULL(cast(object_name(st.objectid, st.dbid) as nvarchar(max)), st.text),*
FROM (select er.sql_handle, es.session_id, es.transaction_isolation_level
 from sys.dm_exec_sessions es
 inner join sys.dm_exec_requests er on es.session_id = er.session_id
 WHERE es.transaction_isolation_level > 2) as sp
 cross apply sys.dm_exec_sql_text(sp.sql_handle) st