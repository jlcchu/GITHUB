���ݿ�鵵�����ܵ�½
1)����ɾ���鵵�����ļ���֤rman���Ե�½
2)rman target /
delete noprompt archivelog until time "to_date('2018-10-10','YYYY-MM-DD')";
����
delete noprompt archivelog until time "to_date('2018-10-10 18:00:00','YYYY-MM-DD hh24:mi:ss')";
crosscheck archivelog all
delete expired archivelog all;

===============================================================================================

rman target /
delete archivelog all completed before 'sysdate-3';          --����3��ǰ��
delete force archivelog all completed before 'sysdate-1/24'; --����һСʱǰ����־
crosscheck archivelog all;                                   --�������ļ���ʵ�������ļ��Ĳ��
list expired archivelog all;                                 --�г�����ʧЧ�Ĺ鵵��־
delete expired archivelog all;                               --ͬ�������ļ�����Ϣ��ʵ�������ļ�����Ϣ������ɾ���ļ�

delete archivelog until sequence 16;                                                              --->ɾ��log sequenceΪ16��16֮ǰ�����й鵵��־
delete archivelog all completed before 'sysdate-7';                                               --->ɾ��ϵͳʱ��7����ǰ�Ĺ鵵��־������ɾ����������Ч�Ĺ鵵��־
delete archivelog from time 'sysdate-1';                                                          --->ע��������ɾ��ϵͳʱ��1�����ڵ����ڵĹ鵵��־ ɾ���ļ�
delete noprompt archivelog all completed before 'sysdate';                                        --->�����������ǰ���еĹ鵵��־
delete noprompt archivelog all completed before 'sysdate-0';                                      --->�����������ǰ���еĹ鵵��־
delete noprompt archivelog all;                                                                   --->ͬ��һ����
delete noprompt archivelog until time "to_date('2018-10-10','YYYY-MM-DD')";                       --->����ĳ������֮ǰ�Ĺ鵵 ɾ���ļ�
delete noprompt archivelog until time "to_date('2018-10-10 18:00:00','YYYY-MM-DD hh24:mi:ss')";   --->��������ʱ����֮ǰ�Ĺ鵵��־ ɾ���ļ�

#!/bin/sh

BACK_DIR=/oracle/clear_archlog/data
export DATE=`date +%F`
echo "      " >> $BACK_DIR/$DATE/rman_backup.log
echo `date '+%Y-%m-%d %H:%M:%S'` >> $BACK_DIR/$DATE/rman_backup.log
su - oracle -c "
mkdir -p $BACK_DIR/$DATE
rman log=$BACK_DIR/$DATE/rman_backup.log target / <<EOF
# delete force archivelog all completed before 'sysdate-1/24';  # ����ִ������鵵��־����������ֶ�����YES����������noprompt����
delete force noprompt archivelog all completed before 'sysdate-1/24';
exit;
EOF
"
echo "   " >> $BACK_DIR/$DATE/rman_backup.log
