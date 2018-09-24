create table tmp_majh_risk_0803 
(
device_number varchar(20)
)

insert into tmp_majh_risk_0803
{
select * from temp_user.tmp_majh_risk_0803
}@hbdw

create table tmp_majh_risk_0803_2
(
user_no varchar(20),
device_number  varchar(20),
user_dinner_desc  varchar(200),
channel_no varchar(20),
innet_date  varchar(20),
rn integer
)

insert into tmp_majh_risk_0803_2
select 
b.*
 from tmp_majh_risk_0803 a 
left join
(select * from (
select user_no,device_number,user_dinner_desc,channel_no,innet_date,
row_number()over(partition by device_number order by innet_date desc)rn from dw_v_user_base_info_user x where acct_month='201706'
and tele_type='2'
) where rn=1)b
on a.device_number=b.device_number

