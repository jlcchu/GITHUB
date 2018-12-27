SELECT session_id sid,
       owner,
       name,
       TYPE,
       mode_held held,
       mode_requested request
  FROM dba_ddl_locks
 WHERE name = 'P_CSM_UPDATE_ADSLDIREC_JL';
 
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
    and oc.name = 'p_insert_tf_f_notcarry_user';