 /*²éÑ¯Êý¾Ý¿âËø*/
 SELECT   /*+ RULE */
          ls.osuser os_user_name,ls.username user_name,
          DECODE (ls.TYPE,'RW','Row wait enqueue lock','TM','DML enqueue lock','TX','Transaction enqueue lock','UL','User supplied lock') lock_type,
          o.object_name object,
          DECODE (ls.lmode,  1, NULL, 2, 'Row Share', 3, 'Row Exclusive', 4, 'Share',  5, 'Share Row Exclusive', 6, 'Exclusive', NULL) lock_mode,
          o.owner,ls.sid,ls.serial# serial_num,ls.id1,ls.id2,ls.inst_id
   FROM   dba_objects o, (SELECT s.osuser,s.username,l.TYPE,l.lmode,s.sid,s.serial#,l.id1,l.id2,s.inst_id FROM gv$session s, gv$lock l WHERE s.sid = l.sid) ls
  WHERE   o.object_id = ls.id1 AND o.owner <> 'SYS' and ls.osuser<>'oracle'
ORDER BY   o.owner, o.object_name;

SELECT DECODE (request, 0, 'Holder:', 'Waiter:'),sid,TYPE,id1,id2,lmode,request,ctime
  FROM v$lock
 WHERE (id1, id2, TYPE) IN (SELECT id1, id2, TYPE FROM v$lock WHERE request > 0)
ORDER BY id1, request;

select 'alter system kill session ''' || A.SID || ',' || A.SERIAL# || '''' ||';' from v$session a where a.sid ='336';

SELECT KTUXEUSN, KTUXESLT, KTUXESQN, /* Transaction ID */ KTUXESTA Status,KTUXECFL Flags ,KTUXESIZ FROM x$ktuxe WHERE ktuxesta!='INACTIVE';

SELECT KTUXEUSN ROLLBACK_SEGS_NUM,KTUXESIZ UNDO_BLOCKS,KTUXESLT,KTUXESQN, /* Transaction ID */KTUXESTA STATUS,KTUXERDBF FILE_ID,KTUXERDBB BLOCK_ID FROM SYS.X$KTUXE WHERE KTUXECFL = 'DEAD';



select session_id from v$locked_object;