/*±Ìø’º‰ÀÈ∆¨*/
--alter tablespace tablespace_name coalesce;

SELECT   DF.TABLESPACE_NAME "Tablespace",
           DF.BYTES / (1024 * 1024) "Total Size",
           SUM (FS.BYTES) / (1024 * 1024) "Free Size",
           ROUND (SUM (FS.BYTES) * 100 / DF.BYTES) "Pct Free",
           ROUND ( (DF.BYTES - SUM (FS.BYTES)) * 100 / DF.BYTES) "Pct Used",
           ROUND (
                100
              * SQRT (MAX (FS.BYTES) / SUM (FS.BYTES))
              * (1 / SQRT (SQRT (COUNT (FS.BYTES)))),
              2
           )
              FSFI
    FROM   DBA_FREE_SPACE FS, (  SELECT   TABLESPACE_NAME, SUM (BYTES) BYTES
                                   FROM   DBA_DATA_FILES
                               GROUP BY   TABLESPACE_NAME) DF
   WHERE   FS.TABLESPACE_NAME = DF.TABLESPACE_NAME
GROUP BY   DF.TABLESPACE_NAME, DF.BYTES
