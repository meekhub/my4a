select substr(t.stdaddr_name,
              instr(t.stdaddr_name, '/', 1, 1) + 1,
              instr(t.stdaddr_name, '/', 1, 2) -
              instr(t.stdaddr_name, '/', 1, 1) - 1) as area_desc,
       t.xiaoqu_no,
       t.stdaddr_name
  from alldmcode.dmcode_xiaoqu_std_addr_new t




select substr(t.stdaddr_name,
              instr(t.stdaddr_name, '/', 1, 1)+1,
              instr(t.stdaddr_name, '/', 1, 2) -
              instr(t.stdaddr_name, '/', 1, 1)-1)
  from dual
