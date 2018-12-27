SELECT   t2.event,
         ROUND (100 * t2.time_waited / (t1.w1 + t3.cpu), 2)
            event_wait_percent
  FROM   (SELECT   SUM (time_waited) w1
            FROM   v$system_event
           WHERE   event NOT IN
                         ('smon timer',
                          'pmon timer',
                          'rdbms ipc message',
                          'Null event',
                          'parallel query dequeue',
                          'pipe get',
                          'client message',
                          'SQL*Net message to client',
                          'SQL*Net message from 

client',
                          'SQL*Net more data from client',
                          'dispatcher timer',
                          'virtual circuit status',
                          'lock manager wait for remote message',
                          'PX Idle Wait',
                          'PX Deq: Execution Msg',
                          'PX 

Deq: Table Q Normal',
                          'wakeup time manager',
                          'slave wait',
                          'i/o slave wait',
                          'jobq slave wait',
                          'null event',
                          'gcs remote message',
                          'gcs for action',
                          'ges remote message',
                          'queue messages',
                          'wait for unread message on broadcast 

channel',
                          'PX Deq Credit: send blkd',
                          'PX Deq: Execute Reply',
                          'PX Deq: Signal ACK',
                          'PX Deque wait',
                          'PX Deq Credit: need buffer',
                          'STREAMS apply coord waiting for slave 

message',
                          'STREAMS apply slave waiting for coord message',
                          'Queue Monitor Wait',
                          'Queue Monitor Slave Wait',
                          'wakeup event for builder',
                          'wakeup event for preparer',
                          'wakeup 

event for reader',
                          'wait for activate message',
                          'PX Deq: Par Recov Execute',
                          'PX Deq: Table Q Sample',
                          'STREAMS apply slave idle wait',
                          'STREAcapture process filter callback wait for 

ruleset',
                          'STREAMS fetch slave waiting for txns',
                          'STREAMS waiting for subscribers to catch up',
                          'Queue Monitor Shutdown Wait',
                          'AQ Proxy Cleanup Wait',
                          'knlqdeq',
                          'class slave wait',
                          'master wait',
                          'DIAG idle wait',
                          'ASM background timer',
                          'KSV master wait',
                          'EMON idle wait',
                          'Streams AQ: RAC qmn coordinator idle wait',
                          'Streams AQ: qmn coordinator idle wait',
                          'Streams AQ: qmn slave 

idle wait',
                          'Streams AQ: waiting for time management or cleanup tasks',
                          'Streams AQ: waiting for messages in the queue',
                          'Streams fetch slave: waiting for txns',
                          'Streams AQ: 

deallocate messages from Streams Pool',
                          'Streams AQ: delete acknowledged messages',
                          'LNS ASYNC archive log',
                          'LNS ASYNC dest activation',
                          'LNS ASYNC end of log',
                          'LogMiner: client waiting for transaction',
                          'LogMiner: slave waiting for activate message',
                          'LogMiner: wakeup event for builder',
                          'LogMiner: wakeup event for preparer',
                          'LogMiner: wakeup event for reader')) t1,
         (SELECT   *
            FROM   (SELECT   t.event,
                             t.total_waits,
                             t.total_timeouts,
                             t.time_waited,
                             t.average_wait,
                             ROWNUM num
                      FROM   (  SELECT   event,
                                         total_waits,
                                         total_timeouts,
                                         time_waited,
                                         average_wait
                                  FROM   v$system_event
                                 WHERE   event NOT IN
                                               ('smon timer',
                                                'pmon timer',
                                                'rdbms ipc message',
                                                'Null event',
                                                'parallel query dequeue',
                                                'pipe get',
                                                'client message',
                                                'SQL*Net message to client',
                                                'SQL*Net message from 

client',
                                                'SQL*Net more data from client',
                                                'dispatcher timer',
                                                'virtual circuit status',
                                                'lock manager wait for remote message',
                                                'PX Idle Wait',
                                                'PX Deq: Execution Msg',
                                                'PX 

Deq: Table Q Normal',
                                                'wakeup time manager',
                                                'slave wait',
                                                'i/o slave wait',
                                                'jobq slave wait',
                                                'null event',
                                                'gcs remote message',
                                                'gcs for action',
                                                'ges remote message',
                                                'queue messages',
                                                'wait for unread message on broadcast 

channel',
                                                'PX Deq Credit: send blkd',
                                                'PX Deq: Execute Reply',
                                                'PX Deq: Signal ACK',
                                                'PX Deque wait',
                                                'PX Deq Credit: need buffer',
                                                'STREAMS apply coord waiting for slave 

message',
                                                'STREAMS apply slave waiting for coord message',
                                                'Queue Monitor Wait',
                                                'Queue Monitor Slave Wait',
                                                'wakeup event for builder',
                                                'wakeup event for preparer',
                                                'wakeup 

event for reader',
                                                'wait for activate message',
                                                'PX Deq: Par Recov Execute',
                                                'PX Deq: Table Q Sample',
                                                'STREAMS apply slave idle wait',
                                                'STREAcapture process filter callback wait for 

ruleset',
                                                'STREAMS fetch slave waiting for txns',
                                                'STREAMS waiting for subscribers to catch up',
                                                'Queue Monitor Shutdown Wait',
                                                'AQ Proxy Cleanup Wait',
                                                'knlqdeq',
                                                'class slave wait',
                                                'master wait',
                                                'DIAG idle wait',
                                                'ASM background timer',
                                                'KSV master wait',
                                                'EMON idle wait',
                                                'Streams AQ: RAC qmn coordinator idle wait',
                                                'Streams AQ: qmn coordinator idle wait',
                                                'Streams AQ: qmn slave 

idle wait',
                                                'Streams AQ: waiting for time management or cleanup tasks',
                                                'Streams AQ: waiting for messages in the queue',
                                                'Streams fetch slave: waiting for txns',
                                                'Streams AQ: 

deallocate messages from Streams Pool',
                                                'Streams AQ: delete acknowledged messages',
                                                'LNS ASYNC archive log',
                                                'LNS ASYNC dest activation',
                                                'LNS ASYNC end of log',
                                                'LogMiner: client waiting for transaction',
                                                'LogMiner: slave waiting for activate message',
                                                'LogMiner: wakeup event for builder',
                                                'LogMiner: wakeup event for preparer',
                                                'LogMiner: wakeup event for reader')
                              ORDER BY   time_waited DESC) t)
           WHERE   num < 11) t2,
         (SELECT   VALUE CPU
            FROM   v$sysstat
           WHERE   NAME LIKE 'CPU used by this session') t3