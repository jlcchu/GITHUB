/*语句使用临时空间*/
SELECT S.sid || ',' || S.serial# sid_serial,
       S.username,
       T.blocks * TBS.block_size / 1024 / 1024 mb_used,
       T.tablespace,
       T.sqladdr address,
       Q.hash_value,
       Q.sql_text
  FROM v$sort_usage T, v$session S, v$sqlarea Q, dba_tablespaces TBS
 WHERE T.session_addr = S.saddr
   AND T.sqladdr = Q.address(+)
   AND T.tablespace = TBS.tablespace_name
 ORDER BY S.sid;
 
/*会话使用临时空间*/
SELECT S.sid || ',' || S.serial# sid_serial,
       S.username,
       S.osuser,
       P.spid,
       S.module,
       S.program,
       SUM(T.blocks) * TBS.block_size / 1024 / 1024 mb_used,
       T.tablespace,
       COUNT(*) sort_ops
  FROM v$sort_usage T, v$session S, dba_tablespaces TBS, v$process P
 WHERE T.session_addr = S.saddr
   AND S.paddr = P.addr
   AND T.tablespace = TBS.tablespace_name
 GROUP BY S.sid,
          S.serial#,
          S.username,
          S.osuser,
          P.spid,
          S.module,
          S.program,
          TBS.block_size,
          T.tablespace
 ORDER BY sid_serial;
