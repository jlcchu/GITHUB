--停  执行后 kill serssion
select 'exec sys.dbms_ijob.broken('||job||',true);' from dba_jobs where log_user like '%YL%';
--启
select 'exec sys.dbms_ijob.broken('||job||',false);' from dba_jobs where log_user like '%YL%';

--执行后需要 commit;
SELECT owner,
       job_name,
       state,
       last_start_date,
       last_run_duration,
       failure_count
  FROM dba_scheduler_jobs
 WHERE job_name = 'GATHER_STATS_JOB';
 
SELECT log_id,
       job_name,
       status,
       TO_CHAR (log_date, 'DD-MON-YYYY HH24:MI') log_date
  FROM dba_scheduler_job_run_details
 WHERE job_name = 'GATHER_STATS_JOB';
 
SELECT PROGRAM_ACTION
  FROM dba_scheduler_programs
 WHERE PROGRAM_NAME = 'GATHER_STATS_PROG';
 
--SYSDBA登录
exec dbms_scheduler.disable('SYS.GATHER_STATS_JOB');
--要重新启用：
exec dbms_scheduler.enable('SYS.GATHER_STATS_JOB');