select * from dim.dim_huaxiao_info a where city_no in
(select city_No from dim.dim_city_no where city_desc like '%深州%')


select * from dim.dim_city_no where city_desc like '%乐亭%'

select * from dim.dim_huaxiao_info where huaxiao_type='06' and city_no='018181009'


select * from dim.dim_huaxiao_info where huaxiao_no='813050027010000'

select * from dim.dim_zq_huaxiao_info t where  huaxiao_no='813020070760000'

select * from dim.dim_huaxiao_info t where  huaxiao_no='813020090750000'


--新增
select * from dim.dim_city_no where area_no='185' and city_desc like '%威县%'

select * from dsg_stage.om_area_t where f_city_code='186021'

select * from dim.dim_zq_huaxiao_info where city_no='018185016'



--insert into  dim.dim_hx_yw 
insert into  dim.dim_zq_huaxiao_info 
select 
area_no, 
city_no, 
'813050330730000' huaxiao_no, 
'威县营维3' huaxiao_name, 
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
'xt_liubh' manager_loginid, 
'刘宾焕' manager_loginname, 
'18903197597' manager_telephone
 from dim.dim_zq_huaxiao_info t where  huaxiao_no='813050330720000'


--增加发展人
insert into dim.dim_zq_channel_huaxiao
select
area_no, 
city_no, 
'S10232280' channel_no, 
'高玲' channel_no_desc, 
huaxiao_no, 
huaxiao_name, 
huaxiao_type, 
huaxiao_type_name, 
if_valid, 
update_user, 
update_date, 
idx_no, 
huaxiao_type_big, 
huaxiao_type_name_big, 
is_developer
 from dim.dim_zq_channel_huaxiao where huaxiao_no='813020400750000' and rownum<2;




