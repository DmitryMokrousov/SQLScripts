SELECT TRAN_INFO.TRANSACTION_ID,
       SESSION_TRAN.session_id,
       DATEDIFF(mi, ISNULL(MIN(transaction_begin_time),
       GETDATE()),
       GETDATE())
  FROM sys.dm_tran_session_transactions AS SESSION_TRAN
  JOIN sys.dm_tran_active_transactions AS TRAN_INFO
    ON SESSION_TRAN.transaction_id = TRAN_INFO.transaction_id
 group by TRAN_INFO.TRANSACTION_ID, SESSION_TRAN.session_id