--���ʧЧ����  --�账��
SELECT * FROM dba_indexes WHERE status = 'UNUSABLE' AND owner LIKE '%%'
--�����ؽ�����
SELECT    'alter index '
       || owner
       || '.'
       || index_name
       || ' rebuild nologging parallel 10; '
  FROM dba_indexes
 WHERE owner LIKE 'U%' AND status = 'UNUSABLE';
 
--��������
select dbms_metadata.get_ddl('INDEX', 'IDX_TG_CDR07_USERID', 'UCR_TJ15') FROM DUAL;

select index_owner, index_name, partition_name, status 
  from dba_ind_partitions
 where index_name = 'IDX_TG_CDR07_USERID' and index_owner = 'UCR_TJ15';

--�ؽ�����
ALTER INDEX UCR_TJ15.IDX_TG_CDR07_USERID REBUILD ONLINE;
alter index rebuild partition UCR_TJ15.P02 online;
alter index UCR_TJ15.IDX_TG_CDR07_USERID rebuild partition P0X online;

--��������Ƿ�ʹ�� 
alter index &index_name monitoring usage; 
alter index &index_name nomonitoring usage; 
select * from v$object_usage where index_name = &index_name; 