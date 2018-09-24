select 
a.*,to_char(b.reg_date,'yyyymmddHH24miss')reg_date, b.device_no
 from tmp_majh_trm_0628 a,
(SELECT *
          FROM DW.DW_V_USER_TERMINAL_DEVICE_d A
         WHERE ACCT_MONTH = '201806'
         and day_id='27')b
         where a.terminal_code=b.terminal_code(+)
