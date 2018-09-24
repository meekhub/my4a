select t.*, t.rowid from tmp_majh_trm_0330 t where rownum>20000;

create table tmp_majh_0330_01 as 
select 
a.terminal_code,
b.device_no,
to_char(reg_date,'yyyymmdd')reg_date,
b.terminal_corp,
b.terminal_model,
a.flag
  from (select * from tmp_majh_trm_0330 where flag = 1) a,
       (select *
          from dw.dw_v_user_terminal_device_d b
         where acct_month = '201803'
           and day_id = '29'
           and to_char(reg_date,'yyyymmdd') between '20170322' and '20170531') b
 where a.terminal_code = b.terminal_code(+)



create table tmp_majh_0330_02 as 
select 
a.terminal_code,
b.device_no,
to_char(reg_date,'yyyymmdd')reg_date,
b.terminal_corp,
b.terminal_model,
a.flag
  from (select * from tmp_majh_trm_0330 where flag = 2) a,
       (select *
          from dw.dw_v_user_terminal_device_d b
         where acct_month = '201803'
           and day_id = '29'
           and to_char(reg_date,'yyyymmdd') between '20170301' and '20170631') b
 where a.terminal_code = b.terminal_code(+)
