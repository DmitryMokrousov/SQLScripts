CREATE EVENT SESSION [HeavyQueryByReads] ON SERVER
ADD EVENT sqlserver.rpc_completed(
    ACTION (
        sqlserver.client_app_name,
        sqlserver.client_hostname,
        sqlserver.client_pid,
        sqlserver.database_id,
        sqlserver.nt_username,
        sqlserver.query_hash,
        sqlserver.query_plan_hash,
        sqlserver.server_principal_name,
        sqlserver.session_id,
        sqlserver.sql_text,
        sqlserver.transaction_id,
        sqlserver.username)
    WHERE ([logical_reads]>(10000))),
ADD EVENT sqlserver.sql_batch_completed(
    ACTION (
        sqlserver.client_app_name,
        sqlserver.client_hostname,
        sqlserver.client_pid,
        sqlserver.database_id,
        sqlserver.nt_username,
        sqlserver.query_hash,
        sqlserver.query_plan_hash,
        sqlserver.server_principal_name,
        sqlserver.session_id,
        sqlserver.sql_text,
        sqlserver.transaction_id,
        sqlserver.username)
    WHERE ([logical_reads]>(10000)))
ADD TARGET package0.event_file(SET 
    -- ���� � ����� �������� �����. ���� �� ������, �� ������������ ���� � �������� ����� SQL Server
    filename=N'E:\����������\���������\������������������SQL\����������������������������\HeavyQueryByReads.xel',
    -- ������������ ������ ����� � ����������
    max_file_size=(1024),
    -- ������������ ���������� ������, ����� ���� �������� ���������� ����� � ����� ������ ������.
    max_rollover_files=(5),
    metadatafile=N'E:\����������\���������\������������������SQL\����������������������������\HeavyQueryByReads.xem')
WITH (
    MAX_MEMORY=4096 KB,
    EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,
    MAX_DISPATCH_LATENCY=15 SECONDS,
    MAX_EVENT_SIZE=0 KB,
    MEMORY_PARTITION_MODE=NONE,
    TRACK_CAUSALITY=OFF,
    STARTUP_STATE=OFF)