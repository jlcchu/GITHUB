SELECT   a.cache_hit_percent,
         e.rowcache_hitratio,
         d.pin_ration_percent,
         d.get_ratio_percent,
         f.mem_sort_percent,
         b.latch_ratio_percent
  FROM   (SELECT   ROUND (
                      (1
                       - ( (s1.VALUE - s4.VALUE - s5.VALUE)
                          / (s2.VALUE + s3.VALUE - s4.VALUE - s5.VALUE)))
                      * 100,
                      2
                   )
                      cache_hit_percent
            FROM   v$sysstat s1,
                   v$sysstat s2,
                   v$sysstat s3,
                   v$sysstat s4,
                   v$sysstat s5
           WHERE   s1.NAME = 'physical reads'
               AND s2.NAME = 'consistent gets'
               AND s3.NAME = 'db block gets'
               AND s4.NAME = 'physical reads direct (lob)'
               AND s5.NAME = 'physical reads direct') a,
         (SELECT   ROUND (100 * (1 - SUM (misses) / SUM (gets)), 2) latch_ratio_percent FROM   v$latch) b,
         (SELECT   ROUND (100 * c.pin_RATIO / b.total, 2) pin_ration_percent,ROUND (100 * (a.get_ratio / b.total), 2) get_ratio_percent
            FROM   (SELECT   SUM (pinhitratio) pin_ratio FROM v$LIBRARYCACHE) c,
                   (SELECT   SUM (gethitratio) get_ratio FROM v$LIBRARYCACHE) a,
                   (SELECT   COUNT ( * ) total FROM v$LIBRARYCACHE) b) d,
         (SELECT   ROUND (100 * (1 - SUM (getmisses) / SUM (gets)), 2)
                      rowcache_hitratio
            FROM   v$rowcache) e,
         (SELECT   ROUND (100 * s1.VALUE / (s2.VALUE + s1.VALUE), 2)
                      mem_sort_percent
            FROM   v$sysstat s1, v$sysstat s2
           WHERE   s1.NAME = 'sorts (memory)'
               AND s2.NAME = 'sorts (disk)') f
