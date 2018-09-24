select t.*, t.rowid from temp_user.tmp_majh_0904_01 t

update temp_user.tmp_majh_0904_01 set terminal_code=trim(terminal_code);



create table temp_user.tmp_majh_0904_02
(
idx_no number,
terminal_code varchar2(30),
is_reg varchar2(3),
device_number varchar2(20),
reg_date varchar2(30)
)

DECLARE
  V_MONTH VARCHAR2(100);
  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018' ORDER BY IDX_NO;
BEGIN
  FOR V_NUM IN 201708 .. 201708 LOOP
    V_MONTH := TO_CHAR(V_NUM);
    FOR C1 IN V_AREA LOOP
      insert into temp_user.tmp_majh_0904_02
    select 
        a.idx,
        a.terminal_code,
        case when to_char(b.reg_date,'yyyymm')<='201705' then '1' else '0' end,
        b.device_no,
        to_char(b.reg_date,'yyyymmdd HH24:mi:ss')
    from 
    temp_user.tmp_majh_0904_01 a,
    (select device_no,reg_date,terminal_code from dw.dw_v_user_terminal_device_m where acct_month=v_month
    and area_no=c1.area_no)b
    where a.terminal_code=b.terminal_code;
      COMMIT;
    END LOOP;
  END LOOP;
END;


select a.terminal_code,b.is_reg,b.device_number,b.reg_date from temp_user.tmp_majh_0904_01 a,
temp_user.tmp_majh_0904_02 b
where a.idx=b.idx_no(+) 
order by a.idx asc










