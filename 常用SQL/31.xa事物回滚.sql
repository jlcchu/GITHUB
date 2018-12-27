SELECT    'exec dbms_transaction.purge_lost_db_entry('''
       || LOCAL_TRAN_ID
       || ''');'
  FROM DBA_2PC_NEIGHBORS;

select 'rollback force ''' || LOCAL_TRAN_ID || ''';' from dba_2pc_pending where state ='prepared';



SELECT KTUXEUSN ROLLBACK_SEGS_NUM,
KTUXESIZ UNDO_BLOCKS,
KTUXESLT,
KTUXESQN, /* Transaction ID */
KTUXESTA STATUS,
KTUXERDBF FILE_ID,
KTUXERDBB BLOCK_ID
FROM SYS.X$KTUXE
WHERE KTUXECFL = 'DEAD';


 bs
 
������
select ADDR,KTUXEUSN,KTUXESLT,KTUXESQN,KTUXESIZ from x$ktuxe where KTUXECFL='DEAD';


set serveroutput on
declare
  l_start number;
  l_end   number;
begin
  select ktuxesiz
    into l_start
    from x$ktuxe
   where KTUXEUSN = 43
     and KTUXESLT = 45; ---------�������ʵ����������д
  dbms_lock.sleep(60);  ---------������С���ʱ�䣬����̫С�����ܻᵼ�����ϴ�
  select ktuxesiz
    into l_end
    from x$ktuxe
   where KTUXEUSN = 43
     and KTUXESLT = 45; ---------�������ʵ����������д
  dbms_output.put_line('time cost Day:' ||
                       round(l_end / (l_start - l_end) / 60, 2));
end;
/