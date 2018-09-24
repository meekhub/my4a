insert into dim.dim_channel_huaxiao
select
'183' area_no, 
'018183001' city_no, 
b.channel_no, 
b.channel_no_desc, 
'813100030190000' huaxiao_no, 
'九州支局' huaxiao_name, 
'04' huaxiao_type, 
'农村支局' huaxiao_type_name, 
'1' if_valid, 
'sf_majh' update_user, 
sysdate update_date, 
1 idx_no, 
'1' huaxiao_type_big, 
'渠道类' huaxiao_type_name_big
from xxhb_mjh.tmp_majh_chnr t,dim.dim_channel_no b
where t.channel_no=b.channel_no
