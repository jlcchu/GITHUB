sqlplus /nolog
conn /as sysdbabegin
dbms_fga.add_policy (
object_schema=>'system', --������
object_name=>'nbstutb',  --����
policy_name=>'nbstu',    --�Զ���Ĳ�����
statement_types=> 'SELECT,DELETE,INSERT,UPDATE'
);
end;
/
����������ݣ����ϸ����Ƶ���Ƽ�¼��
sqlplus /nolog
conn /as sysdba

DELETE   sys.fga_log$;

COMMIT;

=========������ƵĽű�==================
BEGIN
   DBMS_FGA.add_policy (object_schema   => 'UCR_PARAM',          --schema��(Ĭ�ϵ�ǰ�����û�)?
                        object_name       => 'TD_S_TRADETYPE',      --������object����?
                        policy_name       => 't1_audit',            --policy��(Ψһ)?
                        statement_types   => 'insert,update,delete' --��Ӱ��Ĳ���?
                                                                   );
END;
/
=========�� ��====================
EXEC dbms_fga.add_policy(object_schema => 'UCR_CEN1', object_name => 'TD_S_FOREGIFT', policy_name => 'TD_S_FOREGIFT_ACC',statement_types => 'insert,update,delete');

=========�鿴�������====================
select * from dba_audit_policies;

=========�鿴������Ϣ====================
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

=========����������Ʋ���================

SELECT   'EXEC dbms_fga.add_policy(object_schema => ''UCR_CEN1'', object_name =>'''
         || TABLE_NAME
         || ''','
         || 'policy_name =>'''
         || policy_name
         || ''','
         || 'statement_types => ''insert,update,delete'');'
  FROM   dba_tables;

=========����ɾ����Ʋ���=================

SELECT   'EXEC dbms_fga.drop_policy(object_schema => ''UCR_CEN1'', object_name =>'''
         || TABLE_NAME
         || ''','
         || 'policy_name =>'''
         || policy_name
         || ''');'
  FROM   FGA;