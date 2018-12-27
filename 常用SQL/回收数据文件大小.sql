SELECT    'alter database datafile '
       || CHR (39)
       || file_name
       || CHR (39)
       || ' resize '
       || CEIL (hwmsize * 1.2)
       || 'M;'
  FROM (  SELECT a.file_id,
                 a.file_name,
                 a.filesize,
                 b.freesize,
                 (a.filesize - b.freesize) usedsize,
                 c.hwmsize,
                 c.hwmsize - (a.filesize - b.freesize) unsedsize_belowhwm,
                 a.filesize - c.hwmsize canshrinksize
            FROM (SELECT file_id,
                         file_name,
                         ROUND (bytes / 1024 / 1024) filesize
                    FROM dba_data_files) a,
                 (  SELECT file_id,
                           ROUND (SUM (dfs.bytes) / 1024 / 1024) freesize
                      FROM dba_free_space dfs
                  GROUP BY file_id) b,
                 (  SELECT file_id, ROUND (MAX (block_id) * 8 / 1024) HWMsize
                      FROM dba_extents
                  GROUP BY file_id) c
           WHERE a.file_id = b.file_id AND a.file_id = c.file_id
        ORDER BY unsedsize_belowhwm DESC)