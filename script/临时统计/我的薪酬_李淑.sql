select b.area_desc ����,
       c.city_desc ����, 
       a.huaxiao_no ��С��Ԫ����,
       a.huaxiao_name ��С����,
       a.huaxiao_type_name ��С����
  from dim.dim_huaxiao_info a, dim.dim_area_no b, dim.dim_city_no c
 where a.area_no = b.area_no
   and a.city_no = c.city_no
   and a.area_no='188' 
   and a.if_valid='1'
