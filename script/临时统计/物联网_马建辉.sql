select c.area_desc, b.huaxiao_no,b.huaxiao_name,sum(iot_fee)
  from dw.MID_DW_V_USER_HUAXIAO_IOT a,
       (select * from dim.dim_huaxiao_info a where a.huaxiao_type = '08') b,
       dim.dim_area_no c
 where a.acct_month = '201802'
   and a.area_no = b.area_no
   and a.area_no=c.area_no
 group by c.area_desc, b.huaxiao_no,b.huaxiao_name,c.idx_no
 order by c.idx_no


--与商客双记
select c.area_desc, b.huaxiao_no,b.huaxiao_name,sum(iot_fee)
  from DW.MID_DW_V_USER_HUAXIAO_IOT a,
       (select * from dim.dim_huaxiao_info a where a.huaxiao_type = '08') b,
       dim.dim_area_no c,
       tmp_majh_sk_01 d
 where a.acct_month = '201803'
   and a.area_no = b.area_no
   and a.area_no=c.area_no
   and a.user_no=d.user_no
 group by c.area_desc, b.huaxiao_no,b.huaxiao_name,c.idx_no
 order by c.idx_no


--匹配手机号
create table tmp_V_USER_HUAXIAO_IOT as
select 
a.*,b.device_number
 from DW.MID_DW_V_USER_HUAXIAO_IOT a,
（select user_no,device_number from dw.dw_v_user_base_info_user b
  where acct_month='201803'
  and tele_type='2')b
  where a.user_no=b.user_no


--与营维双记
select c.area_desc, b.huaxiao_no,b.huaxiao_name,sum(iot_fee)
  from tmp_V_USER_HUAXIAO_IOT a, 
       (select * from dim.dim_huaxiao_info a where a.huaxiao_type = '08') b,
       dim.dim_area_no c,
       tmp_majh_yw d
 where a.acct_month = '201803'
   and a.area_no = b.area_no
   and a.area_no=c.area_no 
   and a.device_number=d.device_number
 group by c.area_desc, b.huaxiao_no,b.huaxiao_name,c.idx_no
 order by c.idx_no
 
 
 --与高校双记
 select c.area_desc, b.huaxiao_no,b.huaxiao_name,sum(iot_fee)
  from DW.MID_DW_V_USER_HUAXIAO_IOT a,
       (select * from dim.dim_huaxiao_info a where a.huaxiao_type = '08') b,
       dim.dim_area_no c,
       tmp_majh_0304_gx_01 d
 where a.acct_month = '201803'
   and a.area_no = b.area_no
   and a.area_no=c.area_no 
   and a.user_no=d.user_no
 group by c.area_desc, b.huaxiao_no,b.huaxiao_name,c.idx_no
 order by c.idx_no

 
 

 
 
 
 
 
