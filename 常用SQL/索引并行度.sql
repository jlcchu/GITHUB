SELECT 'alter index ' || owner || '.' || index_name || ' noparallel;'
  FROM all_indexes
 WHERE     (   (TRIM (degree) != '1' AND TRIM (degree) != '0')
            OR (TRIM (instances) != '1' AND TRIM (instances) != '0'))
       AND owner LIKE 'UCR%';