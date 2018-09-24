select t.*, t.rowid from tmp_majh_0403_x21_01 t;

create table tmp_majh_0403_x21_02 as
select 
b.area_no_desc,b.device_number,b.user_dinner,b.user_dinner_desc,a.TERMINAL_CODE,a.TERMINAL_MODEL,a.REG_DATE
 from 
(SELECT DEVICE_NO, TERMINAL_CODE, TERMINAL_CORP, TERMINAL_MODEL, to_char(REG_DATE,'yyyymmdd')REG_DATE,user_no
  FROM dw.dw_v_user_terminal_device_d C --终端首次注册
 WHERE ACCT_MONTH = TO_CHAR(SYSDATE - 1, 'YYYYMM')
   AND DAY_ID = TO_CHAR(SYSDATE - 1, 'DD') --昨日全量数据
   --and upper(terminal_model) like '%X21A%'
   and terminal_model in ('OB-PAAM00','OB-PACM00') )a,
   (
   select 
   area_no_desc,device_number,user_no,user_dinner,user_dinner_desc
    from dw.dw_v_user_base_info_day b
   where acct_month='201804'
   and day_id='09'
   and tele_type='2'
   and is_onnet='1'
   and to_char(innet_date,'yyyymmdd') between '20180401' and '20180407'
   and exists
   (select 1 from tmp_majh_0403_x21_01 x where b.user_dinner=x.user_dinner)
   )b
   where a.user_no=b.user_no;
   
  
select *
  from (select a.*,
               row_number() over(partition by device_number order by reg_date) rn
          from tmp_majh_0403_x21_02 a
        )
 where rn = 1



--导出
select 
area_no_desc 地市, 
device_number 手机号, 
user_dinner 套餐ID, 
user_dinner_desc 套餐名称, 
terminal_code 终端串码, 
terminal_model 型号, 
reg_date 注册日期
 from tmp_majh_0403_x21_02
