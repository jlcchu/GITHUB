------------------------------------------------------
alter table UCR_ACT1.TS_B_BILL enable row movement;
select 'alter table '||owner||'.'||segment_name||' modify partition '||partition_name||' shrink space cascade;' from dba_segments a where A.SEGMENT_NAME ='TS_B_BILL' and owner ='UCR_ACT4';
------------------------------------------------------
alter table UNSPRENYANG.LWJ_TF_BH_TRADE_BF move parallel 4;

ALTER TABLE table_name move partition partition_name parallel 4;

select 'alter table '||owner||'.'||segment_name||' move partition '||partition_name||' parallel 8;' from dba_segments a where A.SEGMENT_NAME ='TS_B_BILL' and owner ='UCR_ACT4';

select 'alter index '||index_owner||'.'||index_name||' rebuild partition '||partition_name|| ' online  parallel 10;' from DBA_IND_PARTITIONS where  status = 'UNUSABLE' order by index_name;
select 'alter index '||owner ||'.'|| index_name||' rebuild nologging parallel 10; 'from dba_indexes where owner like 'U%'and status = 'UNUSABLE'

EXECUTE dbms_stats.gather_table_stats(ownname => 'UCR_ACT1',tabname => 'TS_B_BILL', estimate_percent => NULL,method_opt => 'for all indexed columns',CASCADE => TRUE,degree => 8);
EXECUTE dbms_stats.gather_table_stats(ownname => 'UCR_ACT2',tabname => 'TS_B_BILL', estimate_percent => NULL,method_opt => 'for all indexed columns',CASCADE => TRUE,degree => 8);
EXECUTE dbms_stats.gather_table_stats(ownname => 'UCR_ACT3',tabname => 'TS_B_BILL', estimate_percent => NULL,method_opt => 'for all indexed columns',CASCADE => TRUE,degree => 8);
EXECUTE dbms_stats.gather_table_stats(ownname => 'UCR_ACT4',tabname => 'TS_B_BILL', estimate_percent => NULL,method_opt => 'for all indexed columns',CASCADE => TRUE,degree => 8);

select 'alter table '||owner||'.'||segment_name||' move tablespace TBS_YX_SMS parallel 8;'
from dba_segments a WHERE A.TABLESPACE_NAME = 'TBS_CDR_D03' and segment_type='TABLE';

select 'alter index '||owner||'.'||segment_name||' rebuild tablespace TBS_YX_SMS parallel 8;'
from dba_segments a WHERE A.TABLESPACE_NAME = 'TBS_CDR_D03' and segment_type='INDEX';

select 'alter table '||owner||'.'||segment_name||' move partition '||partition_name||' tablespace TBS_YX_SMS parallel 8;'
from dba_segments a WHERE A.TABLESPACE_NAME = 'TBS_CDR_D03' and segment_type='TABLE PARTITION';

select 'alter index '||owner||'.'||segment_name||' rebuild partition '||partition_name||' tablespace TBS_YX_SMS parallel 8;'
from dba_segments a WHERE A.TABLESPACE_NAME = 'TBS_CDR_D03' and segment_type='INDEX PARTITION';

select 'alter table '||owner||'.'||segment_name||' move partition '||partition_name||' tablespace TBS_BIL_DROAM parallel 8;'
from dba_segments a WHERE a.SEGMENT_NAME='TG_CDR05_NRI_GS' and owner ='UCR_ROAM'

SELECT 'alter table ' || XTABLE || ' move tablespace TBS_YX_SMS lob' || '(' ||
       COLUMN_NAME || ') store as ( tablespace TBS_YX_SMS);'
  FROM (SELECT XTABLE, WMSYS.WM_CONCAT(COLUMN_NAME) COLUMN_NAME
          FROM (SELECT OWNER || '.' || TABLE_NAME XTABLE,
                       COLUMN_NAME,
                       TABLESPACE_NAME
                  FROM DBA_LOBS
                 WHERE TABLESPACE_NAME = 'TBS_CDR_D03')
         GROUP BY XTABLE);

--------------------------------------------------------
--整表分析
EXECUTE dbms_stats.gather_table_stats(ownname => 'UCR_UIF1',tabname => 'TL_B_IBTRADE_JK', estimate_percent => NULL,method_opt => 'for all indexed columns',CASCADE => TRUE,degree => 8);
--按分区分析
EXECUTE dbms_stats.gather_table_stats(ownname => 'QGZXH',tabname => 'TJ_B_REP_BKZBJCSJ',partname=>'PART_201210',method_opt => 'for all indexed columns',cascade => TRUE,degree => 8,estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);
--分析索引
exec dbms_stats.gather_index_stats(ownname => 'UCR_STA4',indname => 'IDX_TF_F_ACCOUNTDEPOSIT_STA_1',degree => '8');


  SELECT NUM_ROWS,
         AVG_ROW_LEN * NUM_ROWS / 1024 / 1024 / 0.9 NEED,
         BLOCKS * 8 / 1024 TRUE,
         (BLOCKS * 8 / 1024 - AVG_ROW_LEN * NUM_ROWS / 1024 / 1024 / 0.9)
            RECOVER_MB,
         TABLE_NAME
    FROM dba_tables
   WHERE     --tablespace_name = 'PSAPSR3'
         --AND
         BLOCKS * 8 / 1024 - AVG_ROW_LEN * NUM_ROWS / 1024 / 1024 / 0.9 >
                100
         AND ROWNUM < 11
ORDER BY RECOVER_MB DESC;












SELECT    'alter table '
       || owner
       || '.'
       || segment_name
       || ' move partition '
       || partition_name
       || ' parallel 8;'
  FROM dba_segments a
 WHERE A.SEGMENT_NAME = 'TF_F_ACCOUNTDEPOSIT' AND owner = 'UCR_ACT2';

select 'alter index '||index_owner||'.'||index_name||' rebuild partition '||partition_name|| ' online  parallel 10;' from DBA_IND_PARTITIONS where  status = 'UNUSABLE' order by index_name;

select 'alter index '||owner ||'.'|| index_name||' rebuild nologging parallel 10; 'from dba_indexes where owner like 'U%'and status = 'UNUSABLE'

EXECUTE dbms_stats.gather_table_stats(ownname => 'UCR_ACT1',tabname => 'TF_F_ACCOUNTDEPOSIT', estimate_percent => NULL,method_opt => 'for all indexed columns',CASCADE => TRUE,degree => 8);
EXECUTE dbms_stats.gather_table_stats(ownname => 'UCR_ACT2',tabname => 'TF_F_ACCOUNTDEPOSIT', estimate_percent => NULL,method_opt => 'for all indexed columns',CASCADE => TRUE,degree => 8);

EXECUTE dbms_stats.gather_table_stats(ownname => 'UCR_ACT3',tabname => 'TF_F_ACCOUNTDEPOSIT', estimate_percent => NULL,method_opt => 'for all indexed columns',CASCADE => TRUE,degree => 8);
EXECUTE dbms_stats.gather_table_stats(ownname => 'UCR_ACT4',tabname => 'TF_F_ACCOUNTDEPOSIT', estimate_percent => NULL,method_opt => 'for all indexed columns',CASCADE => TRUE,degree => 8);



EXECUTE dbms_stats.gather_table_stats(ownname => 'UCR_COUNT',tabname => 'TG_CDR_LONG_STAT_DETAIL_GN_04', estimate_percent => NULL,method_opt => 'for all indexed columns',CASCADE => TRUE,degree => 8);
EXECUTE dbms_stats.gather_table_stats(ownname => 'UCR_COUNT',tabname => 'TG_CDR_LONG_STAT_DETAIL_GN_03', estimate_percent => NULL,method_opt => 'for all indexed columns',CASCADE => TRUE,degree => 8);
