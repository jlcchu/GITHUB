/*检查是否有长时间没有提交的事务(ctime的单位是秒)*/
select l.ctime,
       s.status,
       s.username,
       s.sid,
       s.serial#,
       l.lmode,
       l.type,
       o.owner,
       o.object_name,
       o.object_type,
       s.terminal,
       s.machine,
       s.program,
       s.osuser,
       l.request,
       l.block,
       decode(l.type, 'TM', 'table lock', 'TX', 'row lock', null) lock_level
  from v$session s, v$lock l, dba_objects o
 where l.sid = s.sid
   and l.id1 = o.object_id(+)
   and s.status in ('INACTIVE', 'KILLED')
   and l.TYPE in ('TX', 'TM')
   and s.username is not null
 order by l.ctime desc
