SELECT component,
       current_size / 1024 / 1024 cur_size_M,
       max_size / 1024 / 1024 max_size_M
  FROM v$sga_dynamic_components
