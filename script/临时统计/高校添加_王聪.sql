select * from dim_group_hx_gx t

update dim_group_hx_gx t set t.huaxiao_name='开发区高校支局' where huaxiao_no='813100350510000';


select * from dim_group_hx_gx t where t.channel_no in
(
'1711JTSTS0192168',
'1711JTSTS0192169',
'1711JTSTS0192172',
'1711JTSTS0192173',
'1711JTSTS0192174',
'1711JTSTS0192175',
'1711JTSTS0192176',
'1710JTSTS0189025',
'1802JTSTS016979'
);

create table tmp_majh_gx_0324
(
area_no varchar2(20),
city_no varchar2(20),
city_desc varchar2(40),
huaxiao_no varchar2(20),
huaxiao_name varchar2(60),
channel_no  varchar2(20),
channel_no_desc varchar2(80)
)

select * from dim.dim_zq_group_huaxiao where city_no='018720004'

select * from dim.dim_zq_huaxiao_info b where b.huaxiao_type='07' and city_no='018720004'

018720004
018720018


select * from dim.dim_city_no where CITY_DESC like '%桃城%'



--tianjia
insert Into dim.dim_zq_group_huaxiao
select 
area_no, 
city_no, 
'1709JQHDQHD0783596' channel_no, 
'建材学院教师集团网' channel_no_desc, 
huaxiao_no, 
huaxiao_name, 
'07' huaxiao_type, 
'高校支局' huaxiao_type_name, 
'1' if_valid, 
'sf_majh' update_user, 
sysdate update_date, 
1 idx_no, 
2 huxxiao_type_big, 
'政企类' huaxiao_type_name_big
from dim.dim_zq_group_huaxiao where huaxiao_no='813030310510000' and rownum<2 


INSERT INTO DIM.DIM_ZQ_HUAXIAO_INFO
  SELECT AREA_NO,
         CITY_NO,
         '813110310520000' HUAXIAO_NO,
         '桃城区高校支局' HUAXIAO_NAME,
         HUAXIAO_TYPE,
         HUAXIAO_TYPE_NAME,
         IF_VALID,
         UPDATE_USER,
         UPDATE_DATE,
         IDX_NO,
         CREATE_USER,
         sysdate CREATE_DATE,
         HUAXIAO_TYPE_BIG,
         HUAXIAO_TYPE_NAME_BIG,
         'wangyiwei' MANAGER_LOGINID,
         '王艺崴' MANAGER_LOGINNAME,
         '18903187528' MANAGER_TELEPHONE
    FROM DIM.DIM_ZQ_HUAXIAO_INFO
   WHERE HUAXIAO_NO = '813110310510000'
