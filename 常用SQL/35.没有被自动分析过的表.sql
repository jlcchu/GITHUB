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
