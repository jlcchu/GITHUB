/*
              v$session_longops ��ͼ˵��

sofar:                   �Ѿ���ɵĹ���
otalwork :               ��������
START_TIME:              ��ʼʱ��
LAST_UPDATE_TIME:        ������ʱ��
TIME_REMAINING:          Ԥ����ɲ�����ʣ��ʱ��
ELAPSED_SECONDS:         �Ӳ�����ʼ�ܻ���ʱ��
CONTEXT:                 �����Ĺ�ϵ
*/

SELECT   username,
         sid,
         opname,
         ROUND (sofar * 100 / totalwork, 0) || '%' AS progress,
         time_remaining,
         SQL_FULLTEXT
  FROM   v$session_longops, v$sql
 WHERE   time_remaining <> 0
     AND sql_address = address
     AND sql_hash_value = hash_value;
     
--��ʱ�����е�����   
select * from v$session_longops where sid = '828';
