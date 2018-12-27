-- 最占资源的查询
SELECT snap_id,
       disk_reads_delta reads_delta,
       executions_delta exec_delta,
       disk_reads_delta / DECODE (executions_delta, 0, 1, executions_delta) rds_exec_ratio,
       sql_id
  FROM dba_hist_sqlstat
 WHERE disk_reads_delta > 100000
ORDER BY disk_reads_delta DESC;

--查看sql文本
select command_type, sql_text from dba_hist_sqltext where sql_id = '37d31t2yc6hz5';

--查看执行计划
select * from table(DBMS_XPLAN.DISPLAY_AWR('37d31t2yc6hz5'));
