--新增
select * from dim.dim_city_no where area_no='185' and city_desc like '%桥西%'

select * from dsg_stage.om_area_t where f_city_code='186021'

select * from dim.dim_hd_huaxiao_info where city_no='018185001'


--insert into  dim.dim_hx_yw 
insert into  dim.dim_hd_huaxiao_info 
select 
area_no, 
city_no, 
'813050030640000' huaxiao_no, 
'桥西区生产电费承包' huaxiao_name, 
huaxiao_type, 
huaxiao_type_name, 
'1' if_valid, 
update_user, 
update_date, 
idx_no, 
create_user, 
sysdate create_date, 
huaxiao_type_big, 
huaxiao_type_name_big, 
'' manager_loginid, 
'' manager_loginname, 
'' manager_telephone
 from dim.dim_hd_huaxiao_info t where  huaxiao_no='813050030620000'

 
 
 
 
