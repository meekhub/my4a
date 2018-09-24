select 
x.area_desc,
y.city_desc,
a.huaxiao_no,
a.huaxiao_name,
a.huaxiao_type_name,
a.manager_loginid,
a.manager_loginname,
a.manager_telephone,
b.user_id
from 
(select a.area_no,
       a.city_no,
       a.huaxiao_no,
       a.huaxiao_name,
       a.huaxiao_type_name,
       a.manager_loginid,
       a.manager_loginname,
       a.manager_telephone
  from (select * from dim.dim_huaxiao_info where huaxiao_type <> '09') a,
       new_mobile_cbzs.e_user b
 where a.manager_loginid = b.user_id(+)
   and b.user_id is null)a,
   new_mobile_cbzs.e_user b,
   dim.dim_area_no x,
   dim.dim_city_no y
   where a.manager_loginname=b.user_name(+)
   and a.manager_telephone=b.mobile(+)
   and a.area_no=x.area_no(+)
   and a.city_no=y.city_no(+)
