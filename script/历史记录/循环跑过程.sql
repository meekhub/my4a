declare
v_month varchar2(20);
V_RETCODE varchar2(20);
V_RETINFO  varchar2(20);
begin
  for v_num in 201701 .. 201709 loop
    v_month := to_char(v_num);
    P_TMP_DW_V_USER_HUAXIAO_INFO_M(v_month,V_RETCODE,V_RETINFO);
  END LOOP;
end;
  
