/*求系统中较大的latch*/

  SELECT   name,
           SUM (gets),
           SUM (misses),
           SUM (sleeps),
           SUM (wait_time)
    FROM   v$latch_children
GROUP BY   name
  HAVING   SUM (gets) > 50
ORDER BY   2;