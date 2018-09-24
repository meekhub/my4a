--小CEO
select b.area_desc, --账期
       count(*) count_sums, --总登录次数
       count(distinct t.user_id) user_sums --总访问人数
  from (select to_char(t.login_date, 'yyyymm') acct_month, user_id
          from new_mobile_cbzs.e_login_log t
         where to_char(t.login_date, 'yyyymm') >= '201801') t,
       new_mobile_cbzs.e_user_attribute a,
       new_dim.dim_area_no b,
       dim.dim_huaxiao_info c
 where t.user_id = a.user_id
   and a.attr_code = 'AREA_NO'
   and a.ATTR_VALUE=b.area_no(+)
   and t.user_id=a.user_id
   --and a.attr_value = '183'
   and t.user_id=c.manager_loginid
 group by b.area_desc,b.idx_no
 order by b.idx_no;
 
 
 
 select 
 c.area_desc,count(*)
  from dim.dim_huaxiao_info a,new_mobile_cbzs.e_user b,new_dim.dim_area_no c
 where a.manager_loginid=b.user_id
 and a.area_no=c.area_no
 group by c.area_desc,c.idx_no
 order by c.idx_no
 
 
 
 --小CEO+管理员
select b.area_desc, --账期
       count(*) count_sums, --总登录次数
       count(distinct t.user_id) user_sums --总访问人数
  from (select to_char(t.login_date, 'yyyymm') acct_month, user_id
          from new_mobile_cbzs.e_login_log t
         where to_char(t.login_date, 'yyyymm') >= '201801') t,
       new_mobile_cbzs.e_user_attribute a,
       new_dim.dim_area_no b,
       dim.dim_huaxiao_info c
 where t.user_id = a.user_id
   and a.attr_code = 'AREA_NO'
   and a.ATTR_VALUE=b.area_no(+)
   and t.user_id=a.user_id
   --and a.attr_value = '183'
   and t.user_id=c.manager_loginid
 group by b.area_desc,b.idx_no
 order by b.idx_no;
 
 
 
