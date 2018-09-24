create table tmp_majh_0307_01 as
select 
a.city_desc，
a.user_no,
a.device_number,
a.low_value,
a.channel_no
nvl(y.huaxiao_type_name,'其他') 划小类型 from 
(select 
c.city_desc,a.user_no,a.device_number,a.low_value,a.jf_type,a.channel_no
 from alldm.INTEGRAL_SYS_FINE_JF_DETAIL a,dim.dim_area_no b,dim.dim_city_no c where a.acct_month='201802' 
and a.area_no='183' 
and  a.area_no=b.area_no
and a.city_no=c.city_no
and low_value<0)x,
dim.dim_channel_huaxiao y
where x.channel_no=y.channel_no(+)
