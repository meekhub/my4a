select user_dinner,user_dinner_desc,count(*) from 
DW_V_USER_BASE_INFO_USER b where 
acct_month='201706' and is_onnet='是' and tele_type='2' 
and b.user_dinner_desc like '%犇犇%'
group by user_dinner,user_dinner_desc
order by count(*) desc;


select area_no_desc,city_no_desc,channel_no,channel_no_desc,sum(b.low_value) from 
dw_v_user_base_info_day a,dim_user_dinner_value b where  acct_day='20170701'
and is_onnet='是'
and tele_type='2'
and a.user_dinner=b.user_dinner
and is_new='是'
and substr(channel_type,1,2)='11'
group by area_no_desc,city_no_desc,channel_no,channel_no_desc




select * from dw_v_user_base_info_day where acct_day='20170701'
and is_onnet='是'
and tele_type in ('4','26') 
and is_new='是'


select * from dw_v_user_base_info_day where acct_day='20170701'
and is_onnet='是'
and area_no='188'
--and device_number='18931172233'
and customer_no='77628112'


select billing_flag from dw_v_user_base_info_user where acct_month='201705'
and area_no='188'
and is_onnet='是'
and tele_type in ('4','26') 
and billing_flag is not null



create table dim_user_dinner_value
(
user_dinner varchar(20),
user_dinner_desc varchar(200),
low_value integer
)

insert into dim_user_dinner_value
{
select * from rpt_hbtele.sjzx_wh_dim_user_dinner
}@hbdw



