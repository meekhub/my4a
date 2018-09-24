select '201803' acct_month,
       c.area_desc,
       d.city_desc,
       b.huaxiao_type_name,
       b.huaxiao_no,
       b.huaxiao_name,
       b.manager_loginid,
       b.manager_loginname,
       b.manager_telephone,
       decode(b.if_valid, '1', '有效', '无效') if_valid，count(*)
  from sys_cat_log          a,
       dim.dim_huaxiao_info b,
       dim.dim_area_no      c,
       dim.dim_city_no      d
 where a.HUAXIAO_NO = b.huaxiao_no
   and a.SYS_KIND = '3'
   and b.area_no = c.area_no
   and b.city_no = d.city_no
   and a.DAY_ID like '201803%'
 group by c.area_desc,
          d.city_desc,
          b.huaxiao_type_name,
          b.huaxiao_no,
          b.huaxiao_name,
          b.manager_loginid,
          b.manager_loginname,
          b.manager_telephone,
          decode(b.if_valid, '1', '有效', '无效')
