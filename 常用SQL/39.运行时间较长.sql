/*
              v$session_longops 视图说明

sofar:                   已经完成的工作
otalwork :               工作总量
START_TIME:              开始时间
LAST_UPDATE_TIME:        最后更新时间
TIME_REMAINING:          预计完成操作的剩余时间
ELAPSED_SECONDS:         从操作开始总花费时间
CONTEXT:                 上线文关系
*/

SELECT   username,
         sid,
         opname,
         ROUND (sofar * 100 / totalwork, 0) || '%' AS progress,
         time_remaining,
         SQL_FULLTEXT
  FROM   v$session_longops, v$sql
 WHERE   time_remaining <> 0
     AND sql_address = address
     AND sql_hash_value = hash_value;
     
--长时间运行的事物   
select * from v$session_longops where sid = '828';
