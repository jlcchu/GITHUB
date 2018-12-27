/*查询系统事件*/
Select s.SID,
       s.username,
       s.program,
       s.status,
       se.event,
       se.total_waits,
       se.total_timeouts,
       se.time_waited,
       se.average_wait
  from v$session s, v$session_event se
 Where s.sid = se.sid
   And se.event not like 'SQl * Net%'
   And s.status = 'ACTIVE'
   And s.username is not null
 order by total_waits;
 
/*查看等待（wait）情况*/
SELECT v$waitstat.class,
       v$waitstat.count count,
       SUM(v$sysstat.value) sum_value
  FROM v$waitstat, v$sysstat
 WHERE v$sysstat.name IN ('db block gets', 'consistent gets')
 group by v$waitstat.class, v$waitstat.count
