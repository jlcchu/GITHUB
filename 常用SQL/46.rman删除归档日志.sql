数据库归档满不能登陆
1)首先删除归档物理文件保证rman可以登陆
2)rman target /
delete noprompt archivelog until time "to_date('2018-10-10','YYYY-MM-DD')";
或者
delete noprompt archivelog until time "to_date('2018-10-10 18:00:00','YYYY-MM-DD hh24:mi:ss')";
crosscheck archivelog all
delete expired archivelog all;

===============================================================================================

rman target /
delete archivelog all completed before 'sysdate-3';          --清理3天前的
delete force archivelog all completed before 'sysdate-1/24'; --清理一小时前的日志
crosscheck archivelog all;                                   --检查控制文件和实际物理文件的差别。
list expired archivelog all;                                 --列出所有失效的归档日志
delete expired archivelog all;                               --同步控制文件的信息和实际物理文件的信息，不会删除文件

delete archivelog until sequence 16;                                                              --->删除log sequence为16及16之前的所有归档日志
delete archivelog all completed before 'sysdate-7';                                               --->删除系统时间7天以前的归档日志，不会删除闪回区有效的归档日志
delete archivelog from time 'sysdate-1';                                                          --->注意这个命令，删除系统时间1天以内到现在的归档日志 删除文件
delete noprompt archivelog all completed before 'sysdate';                                        --->该命令清除当前所有的归档日志
delete noprompt archivelog all completed before 'sysdate-0';                                      --->该命令清除当前所有的归档日志
delete noprompt archivelog all;                                                                   --->同上一命令
delete noprompt archivelog until time "to_date('2018-10-10','YYYY-MM-DD')";                       --->清理到某天日期之前的归档 删除文件
delete noprompt archivelog until time "to_date('2018-10-10 18:00:00','YYYY-MM-DD hh24:mi:ss')";   --->清理到具体时分秒之前的归档日志 删除文件

#!/bin/sh

BACK_DIR=/oracle/clear_archlog/data
export DATE=`date +%F`
echo "      " >> $BACK_DIR/$DATE/rman_backup.log
echo `date '+%Y-%m-%d %H:%M:%S'` >> $BACK_DIR/$DATE/rman_backup.log
su - oracle -c "
mkdir -p $BACK_DIR/$DATE
rman log=$BACK_DIR/$DATE/rman_backup.log target / <<EOF
# delete force archivelog all completed before 'sysdate-1/24';  # 这里执行清除归档日志，如果不想手动输入YES，则可以添加noprompt参数
delete force noprompt archivelog all completed before 'sysdate-1/24';
exit;
EOF
"
echo "   " >> $BACK_DIR/$DATE/rman_backup.log
