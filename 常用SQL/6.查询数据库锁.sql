SELECT /*+ rule */
        　s.username,
         DECODE (l.TYPE,  'TM', 'TABLE LOCK',  'TX', 'ROW LOCK',  NULL)
            LOCK_LEVEL,
         　　o.object_name,
         　　s.sid,
         l.block　,
         l.*
    FROM v$session s, v$lock l, dba_objects o
   WHERE     --s.username = 'UOP_ACT3' AND 
         l.sid = s.sid　　
         AND l.id1 = o.object_id(+)
         AND s.username IS NOT NULL
ORDER BY s.username;

select s.SID, s.OSUSER, p.spid as OSPID, s.MACHINE, s.TERMINAL, s.PROGRAM
  from v$session s, v$process p
 where s.sid = 1742
   and s.paddr = p.addr;

select b.sql_text from v$session a, v$sql b where a.sid=1742 and a.SQL_ADDRESS=b.ADDRESS(+);

SELECT /*+ rule */
 systimestamp dt,
 　s.username,
 s.sid,
 l.block,
 s.OSUSER,
 p.spid       as OSPID,
 s.MACHINE,
 s.TERMINAL,
 s.PROGRAM,
 q.sql_text
 FROM v$session s, v$lock l,v$process  p,v$sql q　
 WHERE l.block = 1 and l.sid = s.sid and s.paddr = p.addr and s.SQL_ADDRESS = q.ADDRESS;

--如果想知道堵塞的sid及sql语句是什么,用下面语句(oracle10g测试通过),   
select distinct b.sid, a.piece, a.sql_text from v$sqltext_with_newlines a, (select decode(s.sql_address,'00',s.prev_sql_addr,sql_address) sql_address,decode(s.sql_hash_value,0, s.prev_hash_value,s.sql_hash_value) sql_hash_value, s.sid from v$session s,v$lock l WHERE l.sid = s.sid and l.block=1) b where rawtohex(a.address)=b.sql_address    and a.hash_value=b.sql_hash_value order by b.sid,a.piece ASC;
--如果想知道被堵塞sid及正执行的sql语句是什么,用下面语句(oracle10g测试通过)    
select distinct b.sid, a.piece, a.sql_text from v$sqltext_with_newlines a, (select decode(s.sql_address,'00',s.prev_sql_addr,sql_address) sql_address,decode(s.sql_hash_value,0, s.prev_hash_value,s.sql_hash_value) sql_hash_value, s.sid from v$session s WHERE s.sid in (select sid from v$lock where lmode=0 and id1=(select l.ID1 from v$lock l WHERE l.block=1 and rownum<2) )) b where rawtohex(a.address)=b.sql_address and a.hash_value=b.sql_hash_value order by a.piece ASC;
--查看持锁会话服务器端:oracle服务进程id
select a.sid, b.spid from (select s.sid, s.paddr from v$session s,v$lock l WHERE l.sid = s.sid and l.block=1) a, v$process b where a.paddr=b.addr;
--查看持锁会话客户端:用户程序进程id
select s.sid, s.process from v$session s,v$lock l WHERE l.sid = s.sid and l.block=1;
--如果客户端在unix上,process就是用户进程id.
--如果客户端在window上,process中前面数字就是用户进程id(如:728)
--     SID PROCESS
---------- ------------
--     147 728:3920

SELECT DECODE(request,0,'Holder: ','Waiter: ')||sid sess,type,id1,id2,lmode,request,ctime,block
FROM v$lock
WHERE (id1, id2, type) IN
(SELECT id1, id2, type FROM v$lock WHERE request >0) ORDER BY id1, request;

--ash
select a.*, b.*
  from SYS.wrh$_active_session_history a, v$event_name b
 where sql_id = '6720xvuc846b1'
   AND a.event_id = b.event_id
   and sample_time BETWEEN
       TO_DATE('2013/05/01 21:00', 'yyyy/mm/dd hh24:mi') AND
       TO_DATE('2013/05/01 22:35', 'yyyy/mm/dd hh24:mi');
       
select sid,type,id1,id2,lmode,request,block from v$lock where type in ('TM','TX') order by 1,2;
