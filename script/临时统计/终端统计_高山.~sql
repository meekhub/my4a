select t.*, t.rowid from tmp_majh_0420 t;

create table tmp_majh_0420_2 as
select 
a.*,case when b.terminal_code is not null then 'ÊÇ' else '·ñ' end is_reg
 from tmp_majh_0420 a,
(
select terminal_code,reg_date from dw.dw_v_user_terminal_device_d b
where acct_month='201804'
and day_id='19'
)b
where a.terminal_code=b.terminal_code(+)
