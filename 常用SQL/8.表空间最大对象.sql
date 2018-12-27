  SELECT owner, segment_name, SUM (bytes) / 1024 / 1024 / 1024 a
    FROM dba_segments a
   WHERE A.TABLESPACE_NAME = 'TBS_STA_DYZ_11'
GROUP BY owner, segment_name
ORDER BY a DESC;

  SELECT    'ALTER TABLE '
         || OWNER
         || '.'
         || SEGMENT_NAME
         || ' MOVE PARTITION '
         || PARTITION_NAME
         || ' TABLESPACE TBS_BIL_D02 parallel 8;'
    FROM dba_segments
   WHERE owner = 'UCR_ROAM' AND segment_name = 'TG_CDR07_NRI' and TABLESPACE_NAME = 'TBS_BIL_DROAM'
ORDER BY partition_name;

exec DBMS_STATS.delete_table_stats(ownname => 'UCR_UIF1',tabname => 'TL_B_IBTRADE_JK');
