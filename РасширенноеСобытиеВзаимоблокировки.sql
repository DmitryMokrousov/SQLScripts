-- ������ ����������������

CREATE EVENT SESSION [DeadlockAnalyze] ON SERVER 
-- ����� ������� Lock:Deadlock ������������ ��� ������������ ������������� ���������������� � ��������, ������� � ��� ���������.
-- https://docs.microsoft.com/ru-ru/sql/relational-databases/event-classes/lock-deadlock-event-class?view=sql-server-2017
ADD EVENT sqlserver.lock_deadlock(
    ACTION(
            sqlserver.client_app_name,
            sqlserver.client_hostname,
            sqlserver.client_pid,sqlserver.database_id,
            sqlserver.nt_username,
            sqlserver.server_principal_name,
            sqlserver.session_id,
            sqlserver.sql_text,
            sqlserver.transaction_id,
            sqlserver.username
        )
    ),
-- ����� ������� Lock:Deadlock Chain ������������ ��� ����������� ������� ������������� ����������������.
-- https://docs.microsoft.com/ru-ru/sql/relational-databases/event-classes/lock-deadlock-chain-event-class?view=sql-server-2017
ADD EVENT sqlserver.lock_deadlock_chain(
    ACTION(
            sqlserver.client_app_name,
            sqlserver.client_hostname,
            sqlserver.client_pid,
            sqlserver.database_id,
            sqlserver.nt_username,
            sqlserver.server_principal_name,
            sqlserver.session_id,
            sqlserver.sql_text,
            sqlserver.transaction_id,
            sqlserver.username
        )
    ),
-- ������� ����� � ������� ���������������� � ������� XML
ADD EVENT sqlserver.xml_deadlock_report(
    ACTION(
        sqlserver.client_app_name,
        sqlserver.client_hostname,
        sqlserver.client_pid,
        sqlserver.database_id,
        sqlserver.nt_username,
        sqlserver.server_principal_name,
        sqlserver.session_id,
        sqlserver.sql_text,
        sqlserver.transaction_id,
        sqlserver.username
        )
    )
ADD TARGET package0.event_file(SET
        -- ���� � ����� �������� �����. ���� �� ������, �� ������������ ���� � �������� ����� SQL Server
        filename=N'E:\����������\���������\������������������SQL\����������������\DeadlockAnalyze.xel',
        -- ������������ ������ ����� � ����������
        max_file_size=(10),
        -- ������������ ���������� ������, ����� ���� �������� ���������� ����� � ����� ������ ������.
        max_rollover_files=(5),
        metadatafile=N'E:\����������\���������\������������������SQL\����������������\DeadlockAnalyze.xem'
    )
WITH (
        MAX_MEMORY=4096 KB,
        EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,
        MAX_DISPATCH_LATENCY=15 SECONDS,
        MAX_EVENT_SIZE=0 KB,
        MEMORY_PARTITION_MODE=NONE,
        TRACK_CAUSALITY=OFF,
        STARTUP_STATE=OFF
    )