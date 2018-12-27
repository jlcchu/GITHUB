select name,datatype_string,VALUE_STRING from v$sql_bind_capture where sql_id='aftr9jzr1f8f1';

查看DATE类型绑定变量的方法
这需要用到v$sql_bind_capture的特殊列ANYDATA，从文档中可以看到这列，但直接select是不显示的。需要使用ANYDATA列，具体语句如下：
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