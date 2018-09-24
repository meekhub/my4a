select * from  temp_user.tmp_city_no t;

select * from dsg_crm.om_area_t@hbods


select * from temp_user.tmp_city_no a,temp_user.tmp_majh_new_area b
where a.city_no=b.city_no(+)
and b.city_no is null

create table temp_user.tmp_hd_huaxiao as
select b.area_no,b.city_no,b.city_desc,
substr(region_id,1,5)||'0'||substr(region_id,6,2) as hx_code
 from temp_user.tmp_city_no a,dim.dim_city_no b,
 (SELECT A.CITY_NO, A.CITY_NO_NEUSOFT AS REGION_ID, B.AREA_TYPE, A.CITY_DESC
  FROM DIM.DIM_CITY_NO_TRANS A, MID_CITY_C_TYPE B
 WHERE A.CITY_NO = B.CITY_NO)c
where a.city_no=b.city_no 
and a.city_no=c.city_no
union all
select '182','018182014','市辖区','813030010000000' from dual
union all
select '183','018183021','市辖区','813100010000000' from dual
union all
select '186','018186021','市辖区','813040010000000' from dual
union all
select '187','018187057','市辖区','813060010000000' from dual
union all
select '720','018720019','市辖区','813110010000000' from dual
union all
select '182','018182015','北戴河新区','813030980000000' from dual


select * from temp_user.tmp_hd_huaxiao


--后端数据导入
create table temp_user.tmp_hd_huaxiao_info
(
area_desc varchar2(20),
city_desc varchar2(60),
hx_name  varchar2(200),
hx_type varchar2(200)
)

select * from temp_user.tmp_hd_huaxiao_info;



SELECT 
'河北',
c.area_desc,
a.city_desc,
substr(a.hx_code,1,8)||d.sub_code||'0000',
a.city_desc||d.sub_name,
'40',
'四级单元',
'',
b.hx_type,
'',
'收入承包'
  FROM temp_user.tmp_hd_huaxiao A,
       (SELECT B.*,
                       ROW_NUMBER() OVER(PARTITION BY AREA_DESC, CITY_DESC ORDER BY HX_TYPE) RN
                  FROM TEMP_USER.TMP_HD_HUAXIAO_INFO B) B,
       DIM.DIM_AREA_NO C,
       temp_user.tmp_hx_type d
 WHERE A.AREA_NO = C.AREA_NO
   AND C.AREA_DESC = B.AREA_DESC
   AND A.CITY_DESC = B.CITY_DESC
   and b.hx_type=d.hx_type


--形成码表
--dim.dim_huaxiao_info
delete from dim.dim_hx_huaxiao
insert into  dim.dim_hx_huaxiao
SELECT  
c.area_no,
c.area_desc,
a.city_no,
a.city_desc,
substr(a.hx_code,1,8)||d.sub_code||'0000' as huaxiao_no,
a.city_desc||d.sub_name as huaxiao_name 
  FROM temp_user.tmp_hd_huaxiao A,
       (SELECT B.*,
                       ROW_NUMBER() OVER(PARTITION BY AREA_DESC, CITY_DESC ORDER BY HX_TYPE) RN
                  FROM TEMP_USER.TMP_HD_HUAXIAO_INFO B) B,
       DIM.DIM_AREA_NO C,
       temp_user.tmp_hx_type d
 WHERE A.AREA_NO = C.AREA_NO
   AND C.AREA_DESC = B.AREA_DESC
   AND A.CITY_DESC = B.CITY_DESC
   and b.hx_type=d.hx_type;


select a.* from TEMP_USER.TMP_HD_HUAXIAO_INFO a,
dim.dim_hx_huaxiao b
where a.area_desc=b.area_desc(+)
and a.city_desc=b.city_desc(+)
and b.city_desc is null

select * from temp_user.tmp_hd_huaxiao where city_desc like '%南港%';

select * from dim.dim_city_no where city_desc like '%南港%'



--插入最终表
insert into dim.dim_hd_huaxiao_info
select 
a.area_no,
a.city_no,
a.huaxiao_no,
a.huaxiao_name,
'09' huaxiao_type, 
'网运支局' huaxiao_type_name, 
'1' if_valid, 
'sf_majh' update_user, 
sysdate update_date, 
'' idx_no, 
'sf_majh' create_user, 
sysdate create_date, 
'3' huaxiao_type_big, 
'网运类' huaxiao_type_name_big, 
'' manager_loginid, 
'' manager_loginname, 
'' manager_telephone
 from dim.dim_hx_huaxiao a




