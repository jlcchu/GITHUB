/*дз╢Ф╨м╢еелеепР*/

SELECT   a.VALUE "Disk Sorts",
         b.VALUE "Memory Sorts",
         ROUND (
            (100 * b.VALUE)
            / DECODE ( (a.VALUE + b.VALUE), 0, 1, (a.VALUE + b.VALUE)),
            2
         )
            "Pct Memory Sorts"
  FROM   v$sysstat a, v$sysstat b
 WHERE   a.name = 'sorts (disk)'
     AND b.name = 'sorts (memory)';