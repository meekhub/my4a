create table tmp_majh_1x_call
(
acct_month varchar(20),
call_date varchar(20),
oppose_number varchar(20),
start_call_time varchar(20),
call_duration integer,
is_zhu_call varchar(20),
other_home_code varchar(20),
roam_type varchar(20),
cell_no varchar(20),
OPPOSE_CELL_ID varchar(20),
MSC_ID  varchar(20)
)

insert into tmp_majh_1x_call
select 
acct_month,call_date,oppose_number,start_call_time,call_duration,
case when org_trm_id='10' then '1' else '0' end is_zhu_call,
other_home_code,roam_type,cell_no,OPPOSE_CELL_ID,MSC_ID
 from dw_v_user_cdr_cdma where acct_month='201801'
 and area_no='720'
 and device_number='18903187616';
 
 
 
 select acct_month,count(*) from tmp_majh_1x_call group by acct_month


select * from tmp_majh_1x_call


--¹Ì»°

create table tmp_majh_tele_call
(
acct_month varchar(20),
call_date varchar(20),
oppose_number varchar(20),
start_call_time varchar(20),
call_duration integer,
is_zhu_call varchar(20),
other_home_code varchar(20),  
MSC_ID  varchar(20)
)

truncate table tmp_majh_tele_call;

select * from tmp_majh_tele_call where acct_month='201606'



select acct_month,count(*) from tmp_majh_tele_call group by acct_month

insert into tmp_majh_tele_call
select 
acct_month,call_date,oppose_number,start_call_time,call_duration,
case when org_trm_id='10' then '1' else '0' end is_zhu_call,
other_home_code,MSC_ID
 from DW_V_USER_CDR_TELE a where acct_month='201612'
 and area_no='720'
 and device_number='03185180001'



