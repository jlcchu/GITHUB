--整表分析
EXECUTE dbms_stats.gather_table_stats(ownname => 'UCR_UIF1',tabname => 'TL_B_IBTRADE_JK', estimate_percent => NULL,method_opt => 'for all indexed columns',CASCADE => TRUE,degree => 8);
--按分区分析
EXECUTE dbms_stats.gather_table_stats(ownname => 'QGZXH',tabname => 'TJ_B_REP_BKZBJCSJ',partname=>'PART_201210',method_opt => 'for all indexed columns',cascade => TRUE,degree => 8,estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);
--分析索引
exec dbms_stats.gather_index_stats(ownname => 'UCR_STA4',indname => 'IDX_TF_F_ACCOUNTDEPOSIT_STA_1',degree => '8');
--按分区分析索引
exec dbms_stats.gather_index_stats(ownname => 'UCR_CRM3',indname => 'PK_TF_B_TRADE_SP', partname=>'PAR_TF_B_TRADE_SP_01', degree => '8');

--11G 需要添加 no_invalidate => false 立即生效

--整表分析
SELECT    'EXECUTE dbms_stats.gather_table_stats(ownname => '''
       || OWNER
       || ''',tabname =>'
       || ''''
       || table_NAME
       || ''',degree=>10,estimate_percent=>10,CASCADE => TRUE);'
  FROM DBA_tableS A
 WHERE A.OWNER = 'UCR_CRM1'
   AND table_name = 'TF_F_USER';

--按分区分析
SELECT    'EXECUTE dbms_stats.gather_table_stats(ownname => '''
       || table_OWNER
       || ''',tabname =>'
       || ''''
       || table_NAME
       || ''',partname=>'''
       || PARTITION_NAME
       || ''',degree=>10,estimate_percent=>10,CASCADE => TRUE);'
  FROM DBA_TAB_PARTITIONS A
 WHERE A.table_OWNER = 'UCR_CRM1'
   AND table_NAME = 'TF_F_USER';

select  'alter index '||index_owner||'.'||index_name||' rebuild partition '||partition_name|| ' online  parallel 10;'
from DBA_IND_PARTITIONS where  status = 'UNUSABLE' order by index_name;

select 'alter index '||owner ||'.'|| index_name||' rebuild nologging parallel 10; 'from dba_indexes
where owner like 'U%'and status = 'UNUSABLE'
--重建索引
SELECT    'alter index '
       || index_owner
       || '.'
       || index_name
       || ' rebuild partition '
       || partition_name
       || ' online parallel 8 nologging;'
  FROM dba_ind_partitions
 WHERE index_name = 'PK_TF_BH_TRADE' AND index_owner = 'UCR_CRM1';

EXECUTE dbms_stats.gather_table_stats(ownname => '&1',tabname => '&2', estimate_percent => NULL,method_opt => 'for all indexed columns',CASCADE => TRUE,degree => 8);

/*7天上没有被自动分析过的表*/
  SELECT owner,
         table_name,
         num_rows,
         last_analyzed
    FROM dba_tables
   WHERE     owner LIKE 'UCR_CRM%'
         AND last_analyzed <= SYSDATE - 7
         AND table_name LIKE 'TF_F%'
ORDER BY table_name;

  SELECT table_owner,
         table_name,
         num_rows,
         last_analyzed
    FROM DBA_TAB_PARTITIONS
   WHERE     table_owner IN ('UCR_ACT1', 'UCR_ACT1')
         AND last_analyzed <= SYSDATE - 7
         AND table_name LIKE 'TF_F%'
ORDER BY num_rows DESC;

  SELECT    'EXEC DBMS_STATS.gather_table_stats( '''
         || owner
         || ''','''
         || table_name
         || ''');'
    FROM dba_tables
   WHERE owner LIKE 'U%' AND last_analyzed <= SYSDATE - 7
ORDER BY num_rows;


SELECT    'exec dbms_stats.gather_index_stats(ownname =>'''
       || index_owner
       || ''',indname => '''
       || index_name
       || ''', partname=>'''
       || partition_name
       || ''', degree => ''8'');' from DBA_IND_PARTITIONS where index_owner ='UCR_CRM4';

SELECT    'exec dbms_stats.gather_index_stats(ownname =>'''
       || owner
       || ''',indname => '''
       || index_name
       || ''', degree => ''8'');'
  FROM dba_indexes
 WHERE owner = 'UCR_CRM4' AND last_analyzed < SYSDATE - 2;
