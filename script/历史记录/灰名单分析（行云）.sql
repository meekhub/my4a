create table tmp_majh_0812_01
(
idx_no integer,
device_number varchar(20)
)

insert into tmp_majh_0812_01 {
select * from temp_user.tmp_majh_0812_01
}@hbdw

--
select user_dinner_desc,count(*) from tmp_majh_0812_01 a
left join
(select device_number,user_dinner_desc from dw_v_user_base_info_user where acct_month='201707'
and tele_type='2'
and is_onnet='ÊÇ')b
on a.device_number=b.device_number
group by user_dinner_desc

drop table tmp_majh_0815_01
create table tmp_majh_0815_01
(
device_number varchar(20),
call_cdr integer,
call_cdr_zhu integer,
long_num integer,
long_num_zhu integer,
dur_in15 integer,
dur_in_15_zhu integer
)

insert into tmp_majh_0815_01
select 
a.device_number,
count(*)call_cdr,
sum(case when B.ORG_TRM_ID = '10' then 1 else 0 end)call_cdr_zhu,
sum(case when B.long_type<>'10' then 1 else 0 end)long_num,
sum(case when B.long_type<>'10' and B.ORG_TRM_ID = '10' then 1 else 0 end)long_num_zhu,
sum(case when B.ORG_TRM_ID = '10' and b.call_duration<=15 then 1 else 0 end)dur_in_15,
sum(case when B.ORG_TRM_ID = '10' and B.long_type<>'10' and b.call_duration<=15 then 1 else 0 end)dur_in_15_zhu
 from (select distinct device_number from tmp_majh_0812_02) a
left join
(
select device_number,ORG_TRM_ID,CALL_DURATION,long_type from dw_v_user_cdr_cdma where acct_month='201707'
union  all
select device_number,ORG_TRM_ID,CALL_DURATION,long_type from dw_v_user_cdr_cdma_ocs where acct_month='201707'
)b
on a.device_number=b.device_number
group by a.device_number


select 
roam_area_code,count(*)
 from tmp_majh_0812_01 a
left join
(
select device_number,ORG_TRM_ID,CALL_DURATION,roam_area_code from dw_v_user_cdr_cdma where acct_month='201707'
and LONG_TYPE <> '10'
union  all
select device_number,ORG_TRM_ID,CALL_DURATION,roam_area_code from dw_v_user_cdr_cdma_ocs where acct_month='201707'
and LONG_TYPE <> '10'
)b
on a.device_number=b.device_number
group by roam_area_code



select * from dw_v_user_cdr_cdma where acct_month='201707' and call_date='31';




create table tmp_majh_0812_02
(
device_number varchar(20), 
total_cdr_num integer,
warn_type varchar(30)
)

insert into tmp_majh_0812_02 {
select * from temp_user.tmp_majh_0812_02
}@hbdw


select * from tmp_majh_0812_02;

select count(*),sum(case when ORG_TRM_ID = '10' then 1 else 0 end) from dw_v_user_cdr_cdma where acct_month='201707' 
and long_type<>'10'
and device_number='15303319922' 


select user_dinner_desc,count(*) from tmp_majh_0812_02 a
left join
(select device_number,user_dinner_desc,is_ocs,innet_date from dw_v_user_base_info_user where acct_month='201707'
and tele_type='2'
and is_onnet='ÊÇ')b
on a.device_number=b.device_number
group by user_dinner_desc;


select * from tmp_majh_0815_01




