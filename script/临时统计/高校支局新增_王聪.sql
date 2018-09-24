--新增
select * from dim.dim_city_no where city_desc like '%邱县%'

select * from dsg_stage.om_area_t where f_city_code='180035'

select * from dim_hx_gx a where a.city_no='018180045'

delete from  dim_hx_gx t where t.huaxiao_no='813090010810000'

select * from dim.dim_zq_huaxiao_info where huaxiao_no='813090510540000'

select * from dim.dim_huaxiao_info where huaxiao_no='813090510540000'


insert into  dim.dim_hx_gx 
select 
area_no, 
city_no, 
'813090510540000' huaxiao_no, 
'沧州水专支局' huaxiao_name, 
huaxiao_type, 
huaxiao_type_name, 
if_valid, 
update_user, 
update_date, 
idx_no, 
create_user, 
sysdate create_date, 
huaxiao_type_big, 
huaxiao_type_name_big, 
manager_loginid, 
manager_loginname, 
manager_telephone
 from dim.dim_zq_huaxiao_info t where  t.HUAXIAO_TYPE='07' and huaxiao_no='813090510530000'
 

--添加集团
select * from dim.dim_zq_huaxiao_info where huaxiao_no='813090510540000'

select * from dim.dim_zq_group_huaxiao  where channel_no='813090510530000'


insert into dim.dim_zq_group_huaxiao 
select area_no,
       city_no,
       '03174000723' channel_no,
       '运西-沧州市水利高等专科学校教师集团-文化卫生' channel_no_desc,
       huaxiao_no,
       huaxiao_name,
       huaxiao_type,
       huaxiao_type_name,
       if_valid,
       update_user,
       sysdate update_date,
       idx_no,
       huaxiao_type_big,
       huaxiao_type_name_big
  from dim.dim_zq_group_huaxiao
 where huaxiao_no = '813090510540000'
   and rownum < 2; 
 
 
 select count(*),count(distinct channel_no) from dim.dim_zq_group_huaxiao where area_no='181'
 
 
 select * from 
 (select * from dim.dim_zq_group_huaxiao where area_no='181')a,
 xxhb_mjh.tmp_majh_gr_0516 b
 where a.channel_no=b.group_no(+)
 and b.group_no is null;
 
 
 update dim.dim_zq_group_huaxiao set channel_no=trim(channel_no)
 
 
 
 
 
