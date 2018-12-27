/*回滚段查看*/
  SELECT   ROWNUM,
           sys.dba_rollback_segs.segment_name Name,
           v$rollstat.extents Extents,
           v$rollstat.rssize Size_in_Bytes,
           v$rollstat.xacts XActs,
           v$rollstat.gets Gets,
           v$rollstat.waits Waits,
           v$rollstat.writes Writes,
           sys.dba_rollback_segs.status status
    FROM   v$rollstat, sys.dba_rollback_segs, v$rollname
   WHERE   v$rollname.name(+) = sys.dba_rollback_segs.segment_name
       AND v$rollstat.usn(+) = v$rollname.usn
ORDER BY   ROWNUM;

SELECT undoblockstotal "Total",
       undoblocksdone "Done",
       undoblockstotal - undoblocksdone "ToDo",
       DECODE (
          cputime,
          0, 'unknown',
          TO_CHAR (
               SYSDATE
             + (  (  (undoblockstotal - undoblocksdone)
                   / (undoblocksdone / cputime))
                / 86400),
             'yyyy-mm-dd hh24:mi:ss'))
          "Estimated time to complete",
       TO_CHAR (SYSDATE, 'yyyy-mm-dd hh24:mi:ss')
  FROM v$fast_start_transactions;
  
/*求回滚段正在处理的事务 */
select a.name, b.xacts, c.sid, c.serial#, d.sql_text
  from v$rollname    a,
       v$rollstat    b,
       v$session     c,
       v$sqltext     d,
       v$transaction e
 where a.usn = b.usn
   and b.usn = e.xidusn
   and c.taddr = e.addr
   and c.sql_address = d.address
   and c.sql_hash_value = d.hash_value
 order by a.name, c.sid, d.piece;
