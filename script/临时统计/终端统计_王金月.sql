select t.*, t.rowid from tmp_majh_0503_w_01 t


select 
a.terminal_code,to_char(b.reg_date,'yyyymmddHH24MISS')reg_date,
b.device_no,b.terminal_corp,b.terminal_model
 from tmp_majh_0503_w_01 a,
(
select * from dw.dw_v_user_terminal_device_d b
where acct_month='201805'
and day_id='02'
)b
where a.terminal_code=b.terminal_code(+)
