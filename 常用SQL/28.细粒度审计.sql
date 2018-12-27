sqlplus /nolog
conn /as sysdbabegin
dbms_fga.add_policy (
object_schema=>'system', --方案名
object_name=>'nbstutb',  --表名
policy_name=>'nbstu',    --自定义的策略名
statement_types=> 'SELECT,DELETE,INSERT,UPDATE'
);
end;
/
清除试验数据：清除细粒审计的审计记录：
sqlplus /nolog
conn /as sysdba

DELETE   sys.fga_log$;

COMMIT;

=========创建审计的脚本==================
BEGIN
   DBMS_FGA.add_policy (object_schema   => 'UCR_PARAM',          --schema名(默认当前操作用户)?
                        object_name       => 'TD_S_TRADETYPE',      --被操作object对象?
                        policy_name       => 't1_audit',            --policy名(唯一)?
                        statement_types   => 'insert,update,delete' --受影响的操作?
                                                                   );
END;
/
=========例 子====================
EXEC dbms_fga.add_policy(object_schema => 'UCR_CEN1', object_name => 'TD_S_FOREGIFT', policy_name => 'TD_S_FOREGIFT_ACC',statement_types => 'insert,update,delete');

=========查看捕获策略====================
select * from dba_audit_policies;

=========查看捕获信息====================
  SELECT   timestamp,
           userhost,
           os_user,
           db_user,
           object_schema,
           object_name,
           statement_type,
           sql_text,
           policy_name
    FROM   dba_fga_audit_trail
ORDER BY   timestamp;

=========批量创建审计策略================

SELECT   'EXEC dbms_fga.add_policy(object_schema => ''UCR_CEN1'', object_name =>'''
         || TABLE_NAME
         || ''','
         || 'policy_name =>'''
         || policy_name
         || ''','
         || 'statement_types => ''insert,update,delete'');'
  FROM   dba_tables;

=========批量删除审计策略=================

SELECT   'EXEC dbms_fga.drop_policy(object_schema => ''UCR_CEN1'', object_name =>'''
         || TABLE_NAME
         || ''','
         || 'policy_name =>'''
         || policy_name
         || ''');'
  FROM   FGA;