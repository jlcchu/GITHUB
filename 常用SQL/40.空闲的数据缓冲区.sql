/*空闲的数据缓冲区 使用sys用户查询*/

  SELECT   DECODE (state,
                   0, 'FREE',
                   1, DECODE (lrba_seq, 0, 'AVAILABLE', 'BEING USED'),
                   3, 'BEING USED',
                   state)
              "BLOCK STATUS",
           COUNT ( * )
    FROM   x$bh
GROUP BY   DECODE (state,
                   0, 'FREE',
                   1, DECODE (lrba_seq, 0, 'AVAILABLE', 'BEING USED'),
                   3, 'BEING USED',
                   state);