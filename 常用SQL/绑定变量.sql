select name,datatype_string,VALUE_STRING from v$sql_bind_capture where sql_id='aftr9jzr1f8f1';

�鿴DATE���Ͱ󶨱����ķ���
����Ҫ�õ�v$sql_bind_capture��������ANYDATA�����ĵ��п��Կ������У���ֱ��select�ǲ���ʾ�ġ���Ҫʹ��ANYDATA�У�����������£�
select sql_id,
        name,
        datatype_string,
        case datatype
          when 180 then --TIMESTAMP
           to_char(ANYDATA.accesstimestamp(t.value_anydata),
                   'YYYY/MM/DD HH24:MI:SS')
          else
           t.value_string
        end as bind_value,
        last_captured
   from v$sql_bind_capture t
  where sql_id = 'gmbrbfjbrn7xu';