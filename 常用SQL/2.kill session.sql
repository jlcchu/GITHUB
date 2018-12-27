/*被标记为KILLED的session(需要上主机kill)*/
SELECT   'kill -9 ' || a.spid, b.sid FROM v$process a, v$session b WHERE a.addr = b.paddr AND b.status = 'KILLED';

SELECT A.SID,A.SERIAL#,A.STATUS,A.OSUSER,A.PROGRAM,A.EVENT,B.PID,B.SPID,a.USERNAME,c.SQL_TEXT,c.SQL_FULLTEXT,
       'alter system kill session ''' || A.SID || ',' || A.SERIAL# || '''' || ' immediate;',' kill -9 ' || B.SPID || ';'
  FROM V$SESSION A, V$PROCESS B, v$sqlarea c
 WHERE a.SQL_ADDRESS = c.ADDRESS(+)
   AND A.PADDR = B.ADDR
   AND A.OSUSER = 'web'
   and a.username like 'CRM%'
   AND a.STATUS = 'ACTIVE'
   AND a.PROGRAM LIKE 'JDBC Thin Client%';

select  'alter system kill session ''' || A.SID || ',' || A.SERIAL# || '''' || ';' FROM V$SESSION a where sid ='3026'

set linesize 32767
col a       format a50
col machine format a10
col PROGRAM format a30
select 'alter system kill session ''' || SID || ',' || SERIAL# || '''' || ' immediate;' a,machine,PROGRAM from v$session where PROGRAM like '%JDBC%' and machine in ('crmweb1','crmweb2','crmweb3','crmweb4','crmweb5','crmweb6');
