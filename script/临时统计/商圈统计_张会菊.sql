select a.area_desc 地市,
       b.city_desc 区县,
       t.huaxiao_no 划小编码,
       t.huaxiao_name 划小名称, 
       sum(cdma_num) 移动发展,
       sum(adsl_num) 宽带新发展,
       sum(iptv_num) 天翼高清新发展,
       sum(total_fee) 总出账收入,
       sum(onnet_cdma_num) 移动在网,
       sum(onnet_adsl_num) 宽带在网,
       sum(onnet_iptv_num) 天翼高清在网,
       sum(acct_cdma_num) 移动出账,
       sum(acct_adsl_num) 宽带出账,
       sum(acct_iptv_num) 天翼高清出账
  from tmp_v_huaxiao_info_m t, dim.dim_area_no a, dim.dim_city_no b
 where T.ACCT_MONTH = '201801'
   AND T.HUAXIAO_TYPE = '02'
   and t.area_no = a.area_no
   and t.city_no = b.city_no
 group by a.area_desc, b.city_desc, t.huaxiao_no, t.huaxiao_name
