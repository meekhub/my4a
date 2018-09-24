select b.area_desc 地市,
       c.city_desc 区县, 
       a.huaxiao_no 划小单元编码,
       a.huaxiao_name 划小名称,
       a.huaxiao_type_name 划小类型
  from dim.dim_huaxiao_info a, dim.dim_area_no b, dim.dim_city_no c
 where a.area_no = b.area_no
   and a.city_no = c.city_no
   and a.area_no='188' 
   and a.if_valid='1'
