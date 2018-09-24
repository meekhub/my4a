truncate table tmp_majh_1127_2

insert into tmp_majh_1127_2
select 
area_no_desc,city_no_desc,b.device_number,user_dinner,user_dinner_desc,a.pkg_fee*0.1
from tmp_majh_1127 a,
(select area_no,user_dinner,user_dinner_desc,area_no_desc,city_no_desc,user_no,
SALES_MODE,
trans_id,
device_number
 from dw_v_user_base_info_user 
where acct_month='201710')b
where a.user_id=b.user_no