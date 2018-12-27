/*求出无效的对象 */
select 'alter PROCEDURE ' ||owner||'.'|| object_name || ' compile;'
  from dba_objects
 where status = 'INVALID'
   and owner <>'SYS'
   and object_type in ('PACKAGE', 'PACKAGE BODY','PROCEDURE');

select owner, object_name, object_type, status
  from dba_objects
 where status = 'INVALID';


Select owner, object_type, object_name, object_id, status,
    'alter '||object_type||' '||owner||'.'||OBJECT_NAME|| ' compile;'
   from DBA_OBJECTS
 where object_id in (Select object_id
                        from (select object_id, referenced_object_id
                                FROM PUBLIC_DEPENDENCY
                               where referenced_object_id <> object_id
                              ) a
                     connect by prior object_id = referenced_object_id
                  start with referenced_object_id =(Select object_id                                                          
                                                      from DBA_OBJECTS
                                                     where owner = 'UCR_CEN1'
                                                       and object_name = 'TD_S_STATIC'
                                                       and object_type = 'TABLE' 
                                                    )
                       )
 ;