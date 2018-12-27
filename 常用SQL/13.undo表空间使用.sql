/*undo表空间使用*/

select b.name,a.*
 from v$session a,v$rollname b,v$transaction c
 where a.SADDR = c.SES_ADDR 
 and b.usn = c.XIDUSN;

SELECT r.name rbs,
       nvl(s.username, 'None') oracle_user,
       s.osuser client_user,
       p.username unix_user,
       s.sid,
       s.serial#,
       p.spid unix_pid,
       TO_CHAR(s.logon_time, 'mm/dd/yy hh24:mi:ss') as login_time,
       TO_CHAR(sysdate - (s.last_call_et) / 86400, 'mm/dd/yyhh24:mi:ss') as last_txn,
       t.used_ublk * TO_NUMBER(x.value) / 1024 / 1024 as undo_mb
  FROM v$process     p,
       v$rollname    r,
       v$session     s,
       v$transaction t,
       v$parameter   x 　　
 WHERE s.taddr = t.addr 　　
   AND s.paddr = p.addr 　　
   AND r.usn = t.xidusn(+) 　　
   AND x.name = 'db_block_size' 　　
 ORDER 　　BY r.name 
 
  SELECT r.status "Status",
         r.segment_name "Name",
         r.tablespace_name "Tablespace",
         s.extents "Extents",
         TO_CHAR ( (s.bytes / 1024 / 1024), '99999990.000') "Size"
    FROM sys.dba_rollback_segs r, sys.dba_segments s
   WHERE     r.segment_name = s.segment_name
         AND s.segment_type IN ('ROLLBACK', 'TYPE2 UNDO')
         AND s.tablespace_name = 'UNDOTBS1'
ORDER BY 5 DESC;

SELECT s.inst_id,g.usn,s.sid SID,s.serial# Serial,
       s.username 用户名,s.osuser,s.machine 机器名,s.client_info,
       t.start_time 开始时间,t.status 状态,
       t.used_ublk 撤消块,USED_UREC 撤消记录,
       t.cr_get 一致性取,t.cr_change 一致性变化,
       t.log_io "逻辑I/O",t.phy_io "物理I/O",
       t.noundo NoUndo,g.extents Extents,substr(s.program, 1, 50) 操作程序, q.sql_text
  FROM gv$session s, gv$transaction t, gv$rollstat g, gv$sqlarea q
 WHERE t.addr = s.taddr   --s.saddr=t.ses_addr
   AND t.xidusn = g.usn
   and s.sql_address = q.address(+)
   and s.inst_id=t.inst_id
   and s.inst_id=q.inst_id(+)
 ORDER BY t.used_ublk desc;
 
select KTUXEUSN,KTUXESIZ,sysdate from x$ktuxe where KTUXECFL='DEAD' and KTUXESIZ>0;