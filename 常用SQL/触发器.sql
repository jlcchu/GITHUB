CREATE OR REPLACE TRIGGER user_TRIG
   AFTER UPDATE of net_type_code
   ON tf_f_user
DECLARE
   PRAGMA AUTONOMOUS_TRANSACTION;
   DML_TYPE   VARCHAR2 (20);
BEGIN
IF UPDATING
   THEN
      DML_TYPE := 'UPDATE';
   END IF;

   INSERT INTO trig_sql
      SELECT SYSDATE,
             s.SID,
             s.SERIAL#,
             s.USERNAME,
             s.OSUSER,
             s.MACHINE,
             s.TERMINAL,
             s.PROGRAM,
             q.sql_text line,
             DML_TYPE,
             SYS_CONTEXT ('userenv', 'ip_address')
        FROM V$SQLAREA q, v$session s
       WHERE     s.audsid = (SELECT USERENV ('SESSIONID') FROM DUAL)
             AND s.SQL_ADDRESS = q.address;
   COMMIT;
END;
/




CREATE TABLE TRIG_SQL
(
  LT          DATE,
  SID         NUMBER,
  SERIAL#     NUMBER,
  USERNAME    VARCHAR2(30 BYTE),
  OSUSER      VARCHAR2(64 BYTE),
  MACHINE     VARCHAR2(32 BYTE),
  TERMINAL    VARCHAR2(16 BYTE),
  PROGRAM     VARCHAR2(64 BYTE),
  SQLTEXT     VARCHAR2(2000 BYTE),
  STATUS      VARCHAR2(30 BYTE),
  IP_ADDRESS  VARCHAR2(30 BYTE)
)
TABLESPACE TBS_IMPORT
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;