-- јнализ блокировок

CREATE EVENT SESSION [LockAnalyze] ON SERVER
--  ласс событий Lock:Acquired указывает, что была получена блокировка дл€ ресурса
-- https://docs.microsoft.com/ru-ru/sql/relational-databases/event-classes/lock-acquired-event-class?view=sql-server-2017
ADD EVENT sqlserver.lock_acquired(
    ACTION (
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
--  ласс событий Lock:Cancel сигнализирует, что получение блокировки на ресурс было отменено
-- https://docs.microsoft.com/ru-ru/sql/relational-databases/event-classes/lock-cancel-event-class?view=sql-server-2017
ADD EVENT sqlserver.lock_cancel(
    ACTION (
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
--  ласс событий Lock:Timeout указывает на то, что запрос на захват некоторого ресурса превысил врем€ ожидани€
-- https://docs.microsoft.com/ru-ru/sql/relational-databases/event-classes/lock-timeout-event-class?view=sql-server-2017
ADD EVENT sqlserver.lock_timeout(
    WHERE ([duration]>(1) AND [resource_0]<>(0)))
ADD TARGET package0.event_file(SET 
    -- ѕуть к файлу хранени€ логов. ≈сли не указан, то используетс€ путь к каталогу логов SQL Server
    filename=N'LockAnalyze.xel',
    -- ћаксимальный размер файла в мегабайтах
    max_file_size=(1024),
    -- ћаксимальное количество файлов, после чего начнетс€ перезапись логов в более старых файлах.
    max_rollover_files=(5),
    metadatafile=N'LockAnalyze.xem')
WITH (
    MAX_MEMORY=4096 KB,
    EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,
    MAX_DISPATCH_LATENCY=15 SECONDS,
    MAX_EVENT_SIZE=0 KB,
    MEMORY_PARTITION_MODE=NONE,
    TRACK_CAUSALITY=OFF,
    STARTUP_STATE=OFF
)