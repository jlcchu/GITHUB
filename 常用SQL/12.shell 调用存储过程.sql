/*shell 调用存储过程*/
sqlplus umon/c8t5r6s8@NGCRM1_TAF<<EOF
set serveroutput on ;
variable retcode varchar2(3000);
variable retMsg  varchar2(3000);
exec uop_crm1.p_syn_user_info('0',1,0,:retcode,:retMsg);
exit
EOF
!
