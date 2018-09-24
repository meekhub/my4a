create table tmp_majh_jl_01
(
device_number varchar2(20),
idx_no number,
flag varchar2(4)
)


insert into tmp_majh_jl_01
select * from temp_user.tmp_majh_jl_01@oldhbdw;

create table tmp_majh_jl_02 as 
select 
a.*,b.user_dinner
 from tmp_majh_jl_01 a,
(select device_number,user_dinner from dw.dw_v_user_base_info_day
where acct_month='201801'
and day_id='29'
and tele_type='2'
and is_onnet='1'
and user_dinner in ('1415650','1415651'))b
where a.device_number=b.device_number(+)



select user_dinner,count(*) from tmp_majh_jl_02 group by user_dinner;


select 
device_number,
flag,
case when user_dinner is not null then '1' else '0' end dinner_flag
from tmp_majh_jl_02
