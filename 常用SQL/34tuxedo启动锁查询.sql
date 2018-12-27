SELECT SID,
       id1,
       id2,
       TYPE
  FROM v$lock
 WHERE (id1, id2, TYPE) IN (SELECT id1, id2, TYPE
                              FROM v$lock
                             WHERE request > 0)