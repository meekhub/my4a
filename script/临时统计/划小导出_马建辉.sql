select
b.area_desc,
c.city_desc,
a.huaxiao_no,
a.huaxiao_name,
a.huaxiao_type_name,
a.manager_loginid,
a.manager_loginname,
a.manager_telephone
 from dim.dim_huaxiao_info a,dim.dim_area_no b,dim.dim_city_no c
where a.area_no=b.area_no
and a.city_no=c.city_no 
and a.huaxiao_type in ('05','06','07','08')
