select GROUP# ,BYTES/1024/1024 size_M,STATUS,ARCHIVED from v$log;
select MEMBER from v$logfile;

SELECT v$logfile.member, v$logfile.group#, v$log.status,v$log.ARCHIVED, v$log.bytes/1024/1024 ,v$log.thread#
FROM v$log, v$logfile 
WHERE v$log.group# = v$logfile.group#
ORDER BY v$log.thread#,v$logfile.group#;

alter database add logfile thread 1 group 5('+DATA/rac/onlinelog/group5') size 2g;
alter database add logfile thread 2 group 6('+DATA/rac/onlinelog/group6') size 2g;
alter database add logfile thread 1 group 7('+DATA/rac/onlinelog/group7') size 2g;
alter database add logfile thread 2 group 8('+DATA/rac/onlinelog/group8') size 2g;