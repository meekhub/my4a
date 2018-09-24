select 
area_desc,
city_desc,
huaxiao_no,
huaxiao_name,
huaxiao_type_name,
manager_loginid,
case when b.user_id is not null then 'ÕýÈ·' else '´íÎó' end,
manager_loginname,
manager_telephone
from 
(select b.area_desc,
       c.city_desc,
       a.huaxiao_no,
       a.huaxiao_name,
       a.huaxiao_type_name,
       a.manager_loginid,
       a.manager_loginname,
       a.manager_telephone
  from dim.dim_huaxiao_info a, dim.dim_area_no b, dim.dim_city_no c
 where a.if_valid = 1
   and a.area_no = b.area_no
   and a.city_no = c.city_no
   and a.huaxiao_type in ('01','02','03','04'))a,
   (select * from new_mobile_cbzs.e_user where STATE=1) b
   where a.manager_loginid=b.user_id(+)
