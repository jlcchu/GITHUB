SELECT a.sid,
       a.username,
       b.xidusn,
       b.used_urec,
       b.used_ublk
  FROM v$session a, v$transaction b
 WHERE a.saddr = b.ses_addr;


set serveroutput on
set feedback off
prompt
prompt Looking for transactions that are rolling back ...
prompt

declare
  cursor tx is
    select
      s.username,
      t.xidusn,
      t.xidslot,
      t.xidsqn,
      x.ktuxesiz
    from
      sys.x$ktuxe  x,
      sys.v_$transaction  t,
      sys.v_$session  s
    where
      x.inst_id = userenv('Instance') and
      x.ktuxesta = 'ACTIVE' and
      x.ktuxesiz > 1 and
      t.xidusn = x.ktuxeusn and
      t.xidslot = x.ktuxeslt and
      t.xidsqn = x.ktuxesqn and
      s.saddr = t.ses_addr;
  user_name  varchar2(30);
  xid_usn    number;
  xid_slot   number;
  xid_sqn    number;
  used_ublk1 number;
  used_ublk2 number;
begin
  open tx;
  loop
    fetch tx into user_name, xid_usn, xid_slot, xid_sqn, used_ublk1;
    exit when tx%notfound;
    if tx%rowcount = 1
    then
      sys.dbms_lock.sleep(10);
    end if;
    select
      sum(ktuxesiz)
    into
      used_ublk2
    from
      sys.x$ktuxe
    where
      inst_id = userenv('Instance') and
      ktuxeusn = xid_usn and
      ktuxeslt = xid_slot and
      ktuxesqn = xid_sqn and
      ktuxesta = 'ACTIVE';
    if used_ublk2 < used_ublk1
    then
      sys.dbms_output.put_line(
        user_name ||
        '''s transaction ' ||
        xid_usn  || '.' ||
        xid_slot || '.' ||
        xid_sqn  ||
        ' will finish rolling back at approximately ' ||
        to_char(
          sysdate + used_ublk2 / (used_ublk1 - used_ublk2) / 6 / 60 / 24,
          'HH24:MI:SS DD-MON-YYYY'
        )
      );
    end if;
  end loop;
  if user_name is null
  then
    sys.dbms_output.put_line('No transactions appear to be rolling back.');
  end if;
end;
/
