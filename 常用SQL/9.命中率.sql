/*��ѯ��������������*/
SELECT   (  1
          - (  SUM (DECODE (name, 'physical reads', VALUE, 0))
             / (  SUM (DECODE (name, 'db block gets', VALUE, 0))
                + SUM (DECODE (name, 'consistent gets', VALUE, 0)))))
       * 100
           "Hit Ratio"
  FROM v$sysstat;

/*��ѯ�����ֵ仺��������*/
SELECT   (1 - (SUM (getmisses) / SUM (gets))) * 100 "Hit Ratio"
  FROM   v$rowcache;

/*�⻺��������*/
SELECT   SUM (Pins) / (SUM (Pins) + SUM (Reloads)) * 100 "Hit Ratio"
  FROM   V$LibraryCache;
