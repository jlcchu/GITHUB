select 'alter index '||index_owner||'.'||index_name||' rebuild partition '||partition_name|| ' online  parallel 10;' from DBA_IND_PARTITIONS where  status = 'UNUSABLE' order by index_name;
select 'alter index '||owner ||'.'|| index_name||' rebuild nologging parallel 10; 'from dba_indexes where owner like 'U%'and status = 'UNUSABLE';

SELECT    'exec dbms_stats.gather_index_stats(ownname =>'''
       || index_owner
       || ''',indname => '''
       || index_name
       || ''', partname=>'''
       || partition_name
       || ''', degree => ''8'');' from DBA_IND_PARTITIONS where index_owner ='UCR_CRM4'