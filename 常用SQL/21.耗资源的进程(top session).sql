/*耗资源的进程（top session）*/
  SELECT   s.schemaname schema_name,
           DECODE (SIGN (48 - command),
                   1, TO_CHAR (command),
                   'Action Code #' || TO_CHAR (command))
              action,
           status session_status,
           s.osuser os_user_name,
           s.sid,
           p.spid,
           s.serial# serial_num,
           NVL (s.username, '[Oracle process]') user_name,
           s.terminal terminal,
           s.program program,
           st.VALUE criteria_value
    FROM   v$sesstat st, v$session s, v$process p
   WHERE   st.sid = s.sid
       AND st.statistic# = TO_NUMBER ('38')
       AND ('ALL' = 'ALL' OR s.status = 'ALL')
       AND p.addr = s.paddr
ORDER BY   st.VALUE DESC,
           p.spid ASC,
           s.username ASC,
           s.osuser ASC
