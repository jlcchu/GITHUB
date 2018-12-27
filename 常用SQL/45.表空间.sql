SELECT a.tablespace_name,
       ROUND (a.bytes_alloc / 1024 / 1024) megs_alloc,
       ROUND (NVL (b.bytes_free, 0) / 1024 / 1024) megs_free,
       ROUND ( (a.bytes_alloc - NVL (b.bytes_free, 0)) / 1024 / 1024)
          megs_used,
       ROUND ( (NVL (b.bytes_free, 0) / a.bytes_alloc) * 100) Pct_Free,
       100 - ROUND ( (NVL (b.bytes_free, 0) / a.bytes_alloc) * 100) Pct_used,
       ROUND (maxbytes / 1048576) MAX
  FROM (  SELECT f.tablespace_name,
                 SUM (f.bytes) bytes_alloc,
                 SUM (
                    DECODE (f.autoextensible,
                            'YES', f.maxbytes,
                            'NO', f.bytes))
                    maxbytes
            FROM dba_data_files f
        GROUP BY tablespace_name) a,
       (  SELECT f.tablespace_name, SUM (f.bytes) bytes_free
            FROM dba_free_space f
        GROUP BY tablespace_name) b
 WHERE a.tablespace_name = b.tablespace_name(+)
UNION ALL
  SELECT h.tablespace_name,
         ROUND (SUM (h.bytes_free + h.bytes_used) / 1048576) megs_alloc,
         ROUND (
              SUM ( (h.bytes_free + h.bytes_used) - NVL (p.bytes_used, 0))
            / 1048576)
            megs_free,
         ROUND (SUM (NVL (p.bytes_used, 0)) / 1048576) megs_used,
         ROUND (
              (  SUM ( (h.bytes_free + h.bytes_used) - NVL (p.bytes_used, 0))
               / SUM (h.bytes_used + h.bytes_free))
            * 100)
            Pct_Free,
           100
         - ROUND (
                (  SUM ( (h.bytes_free + h.bytes_used) - NVL (p.bytes_used, 0))
                 / SUM (h.bytes_used + h.bytes_free))
              * 100)
            pct_used,
         ROUND (SUM (f.maxbytes) / 1048576) MAX
    FROM sys.v_$TEMP_SPACE_HEADER h,
         sys.v_$Temp_extent_pool p,
         dba_temp_files f
   WHERE     p.file_id(+) = h.file_id
         AND p.tablespace_name(+) = h.tablespace_name
         AND f.file_id = h.file_id
         AND f.tablespace_name = h.tablespace_name
GROUP BY h.tablespace_name
ORDER BY 1;



oracle12

SELECT a.tablespace_name,
       ROUND (a.bytes_alloc / 1024 / 1024)                          megs_alloc,
       ROUND (NVL (b.bytes_free, 0) / 1024 / 1024)                  megs_free,
       ROUND ( (a.bytes_alloc - NVL (b.bytes_free, 0)) / 1024 / 1024)
           megs_used,
       ROUND ( (NVL (b.bytes_free, 0) / a.bytes_alloc) * 100)       Pct_Free,
       100 - ROUND ( (NVL (b.bytes_free, 0) / a.bytes_alloc) * 100) Pct_used,
       ROUND (maxbytes / 1048576)                                   MAX,
       c.status,
       c.contents
  FROM (  SELECT f.tablespace_name,
                 SUM (f.bytes) bytes_alloc,
                 SUM (
                     DECODE (f.autoextensible,
                             'YES', f.maxbytes,
                             'NO', f.bytes))
                     maxbytes
            FROM dba_data_files f
        GROUP BY tablespace_name) a,
       (  SELECT f.tablespace_name, SUM (f.bytes) bytes_free
            FROM dba_free_space f
        GROUP BY tablespace_name) b,
       dba_tablespaces  c
 WHERE     a.tablespace_name = b.tablespace_name(+)
       AND a.tablespace_name = c.tablespace_name
UNION ALL
  SELECT h.tablespace_name,
         ROUND (SUM (h.bytes_free + h.bytes_used) / 1048576) megs_alloc,
         ROUND (
               SUM ( (h.bytes_free + h.bytes_used) - NVL (p.bytes_used, 0))
             / 1048576)
             megs_free,
         ROUND (SUM (NVL (p.bytes_used, 0)) / 1048576)     megs_used,
         ROUND (
               (  SUM ( (h.bytes_free + h.bytes_used) - NVL (p.bytes_used, 0))
                / SUM (h.bytes_used + h.bytes_free))
             * 100)
             Pct_Free,
           100
         - ROUND (
                 (  SUM (
                        (h.bytes_free + h.bytes_used) - NVL (p.bytes_used, 0))
                  / SUM (h.bytes_used + h.bytes_free))
               * 100)
             pct_used,
         ROUND (
             SUM (
                   DECODE (f.autoextensible,
                           'YES', f.maxbytes,
                           'NO', f.bytes)
                 / 1048576))
             MAX,
         c.status,
         c.contents
    FROM sys.v_$TEMP_SPACE_HEADER h,
         sys.v_$Temp_extent_pool p,
         dba_temp_files          f,
         dba_tablespaces         c
   WHERE     p.file_id(+) = h.file_id
         AND p.tablespace_name(+) = h.tablespace_name
         AND f.file_id = h.file_id
         AND f.tablespace_name = h.tablespace_name
         AND f.tablespace_name = c.tablespace_name
GROUP BY h.tablespace_name, c.status, c.contents
ORDER BY 1


DBA_LMT_FREE_SPACE
