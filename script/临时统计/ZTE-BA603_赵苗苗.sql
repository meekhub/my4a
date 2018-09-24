
create table tmp_majh_trm_0117 as
select
area_no,a.terminal_corp,a.terminal_model,a.terminal_code,to_char(reg_date,'yyyymmdd')reg_date,a.device_no,USER_NO
 from dw.dw_v_user_terminal_device_d a where acct_month='201801'
and day_id='22'
and area_no in ('183','187','720')
and to_char(reg_date,'yyyymmdd') between '20170901' and '20180122'
and terminal_model='ZTE-BA603';


create table tmp_majh_trm_0117_2 as
select a.*,case when b.user_no is not null then '1' else '0' end is_3no from tmp_majh_trm_0117 a,
(select user_no from dw.dw_v_user_base_info_user where acct_month='201712'
and  area_no in ('183','187','720')
and tele_type='2'
and IS_3NO_ADJUST='1')b
where a.user_no=b.user_no(+)


--µ¼³ö
select 
area_desc, 
terminal_corp, 
terminal_model, 
terminal_code, 
reg_date, 
device_no, 
user_no, 
is_3no

 from tmp_majh_trm_0117_2 t,dim.dim_area_no b
where t.area_no=b.area_no
