/*查找object为哪些进程所用*/
  SELECT   p.spid,
           s.sid,
           s.serial# serial_num,
           s.username user_name,
           a.TYPE object_type,
           s.osuser os_user_name,
           a.owner,
           a.object object_name,
           DECODE (SIGN (48 - command),
                   1, TO_CHAR (command),
                   'Action Code #' || TO_CHAR (command))
              action,
           p.program oracle_process,
           s.terminal terminal,
           s.program program,
           s.status session_status
    FROM   v$session s, v$access a, v$process p
   WHERE   s.paddr = p.addr
       AND s.TYPE = 'USER'
       AND a.sid = s.sid
       AND a.object = 'P_STA_ACCOUNTDEPOSIT_D_BACKUP'
ORDER BY   s.username, s.osuser;


select distinct 'kill -9 '||p.spid, s.sid, s.serial#,'ALTER SYSTEM KILL SESSION '''||s.sid||','||s.serial#||''';',oc.owner
 from v$db_object_cache   oc,
        v$object_dependency od,
        dba_kgllock         w,
        v$session           s,
        v$process           p
 where od.to_owner = oc.owner
    and od.to_name = oc.name
    and od.to_address = w.kgllkhdl
    and w.kgllkuse = s.saddr
    and p.addr = s.paddr
    and oc.name = 'p_insert_tf_f_notcarry_user' 