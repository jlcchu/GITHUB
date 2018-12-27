  SELECT NUM_ROWS,
         AVG_ROW_LEN * NUM_ROWS / 1024 / 1024 / 0.9 NEED,
         BLOCKS * 8 / 1024 TRUE,
         (BLOCKS * 8 / 1024 - AVG_ROW_LEN * NUM_ROWS / 1024 / 1024 / 0.9)
            RECOVER_MB,
         TABLE_NAME
    FROM dba_tables
   WHERE     tablespace_name = 'TBS_ACT_HDACT05'
         AND BLOCKS * 8 / 1024 - AVG_ROW_LEN * NUM_ROWS / 1024 / 1024 / 0.9 >
                100
         AND ROWNUM < 11
ORDER BY RECOVER_MB DESC;


ALTER TABLE UCR_ACT1.TS_BH_BILL_1122_BAK1 ENABLE ROW MOVEMENT;
ALTER TABLE  UCR_ACT1.TS_BH_BILL_1122_BAK1 SHRINK SPACE CASCADE;

select 'ALTER TABLE UCR_CRM1.'||TABLE_NAME||'  ENABLE ROW MOVEMENT;'  from dba_tables a where a.owner='UCR_CRM1';
select 'ALTER TABLE UCR_CRM1.'||TABLE_NAME||'  SHRINK SPACE CASCADE;' from dba_tables a where a.owner='UCR_CRM1';

SELECT      'ALTER TABLE '
         || OWNER
         || '.'
         || SEGMENT_NAME
         || ' ENABLE ROW MOVEMENT;'
  FROM   (  SELECT   OWNER, SEGMENT_NAME, SUM (bytes) a
              FROM   dba_segments
             WHERE   owner LIKE 'U%'
                 AND segment_type LIKE 'TABLE%'
          GROUP BY   OWNER, SEGMENT_NAME
          ORDER BY   SUM (bytes) DESC)
 WHERE   a > 1000000;
 
SELECT      'ALTER TABLE '
         || OWNER
         || '.'
         || SEGMENT_NAME
         || ' SHRINK SPACE CASCADE;'
  FROM   (  SELECT   OWNER, SEGMENT_NAME, SUM (bytes) a
              FROM   dba_segments
             WHERE   owner LIKE 'U%'
                 AND segment_type LIKE 'TABLE%'
          GROUP BY   OWNER, SEGMENT_NAME
          ORDER BY   SUM (bytes) DESC)
 WHERE   a > 1000000;
