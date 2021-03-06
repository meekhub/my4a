create table tmp_majh_trm_0718_02 as 
select t.*, b.device_no
  from tmp_majh_trm_0718_01 t,
       (select *
          from (select terminal_code,
                       device_no,
                       row_number() over(partition by terminal_code order by reg_date desc) rn
                  from dw.dw_v_user_terminal_d b
                 where acct_month = '201807'
                   and day_id = '17'
                   and to_char(reg_date, 'yyyymm') <= '201705')
         where rn = 1) b
 where t.terminal_code = b.terminal_code(+);
