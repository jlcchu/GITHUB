SELECT * FROM V$SQLAREA ORDER BY VERSION_COUNT DESC;

select * from v$sql where sql_id='3883f4j5h63qr'

SELECT * FROM v$sql_shared_cursor WHERE sql_id IN ('3883f4j5h63qr');

SELECT *FROM V$SQL_BIND_CAPTURE WHERE sql_id='3883f4j5h63qr' AND  name=':VTRADE_TYPE_CODE' ORDER BY NAME  ;

SELECT NAME, DATATYPE_STRING, COUNT(*)
          FROM V$SQL_BIND_CAPTURE
         WHERE SQL_ID = '3883f4j5h63qr'
         GROUP BY NAME, DATATYPE_STRING
         ORDER BY NAME

SELECT substr(sql_text,1,100) "Stmt", count(*),
                sum(sharable_mem)    "Mem",
                sum(users_opening)   "Open",
                sum(executions)      "Exec"
          FROM crmdb.v$sql
         GROUP BY substr(sql_text,1,100)
        HAVING sum(sharable_mem) > 10000000;