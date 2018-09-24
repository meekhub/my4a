create table dim.dim_hx_wlw as
select * from dim.dim_huaxiao_info where 1=2;

delete from dim.dim_hx_wlw

insert into dim.dim_hx_wlw
select 
area_no,
b.city_no_old,
rpad(a.std_latn_cd||'001101',15,'0') as huaxiao_no,
a.area_desc||'物联网承包' as huaxiao_name,
'08' huaxiao_type,
'物联网' huaxiao_type_name,
'1' if_valid,
'sf_majh' update_user,
sysdate update_date,
1 idx_no,
'sf_majh' create_user,
sysdate create_date,
'2' huaxiao_type_big,
'政企类' huaxiao_type_big_name,
'' MANAGER_LOGINID,
'' MANAGER_LOGINNAME,
'' MANAGER_TELEPHONE
 from dim.dim_area_no_jt a,
 (
 select substr(f_area_id,1,5) as city_no_new,
       f_area_name as city_name,
       '018' || f_city_code as city_no_old,
       substr(f_area_id,6,2)
  from dsg_stage.om_area_t t
 where t.F_AREA_LEVEL = 4
 and t.F_AREA_NAME='市辖区'
 )b
 where a.area_desc<>'全省' 
 and a.std_latn_cd=b.city_no_new


--导出  支局信息
select 
a.area_no,b.area_desc,a.city_no,'市辖区' city_desc,a.huaxiao_no,a.huaxiao_name,a.huaxiao_type,a.huaxiao_type_name
 from dim.dim_hx_wlw a,dim.dim_area_no b,dim.dim_city_no c
where a.area_no=b.area_no(+)
and a.city_no=c.city_no(+)

