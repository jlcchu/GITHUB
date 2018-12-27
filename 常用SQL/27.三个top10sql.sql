SELECT   '硬盘读取量最大的top ' || ROWNUM t1_id,
         sql_disk_reads,
         disk_reads,
         address
  FROM   (  SELECT   sql_text sql_disk_reads, disk_reads, address
              FROM   v$sqlarea
          ORDER BY   disk_reads DESC)
 WHERE   ROWNUM < 11
UNION ALL
SELECT   '高速缓冲区使用最大的top ' || ROWNUM t2_id,
         sql_buffer_gets,
         buffer_gets,
         address
  FROM   (  SELECT   sql_text sql_buffer_gets, buffer_gets, address
              FROM   v$sqlarea
          ORDER BY   buffer_gets DESC)
 WHERE   ROWNUM < 11
UNION ALL
SELECT   '执行次数最多的top ' || ROWNUM t3_id,
         sql_executions,
         executions,
         address
  FROM   (  SELECT   sql_text sql_executions, executions, address
              FROM   v$sqlarea
          ORDER BY   executions DESC)
 WHERE   ROWNUM < 11