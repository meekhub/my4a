select t.*, t.rowid from tmp_majh_trm_0713_01 t;


select a.*,to_char(b.reg_date,'yyyymmddHH24MISS')reg_date from tmp_majh_trm_0713_01 a,
(select * from dw.dw_v_user_terminal_device_d b
where acct_month='201807'
and day_id='12')b
where a.terminal_code=b.terminal_code(+)
