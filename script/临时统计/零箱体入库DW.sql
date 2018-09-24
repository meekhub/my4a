insert into DW_V_BOX_INFO_M
select 
'201807' acct_month, 
area_desc, 
city_desc, 
fgq_name, 
fgq_id, 
project_id, 
project_desc, 
fgq_date, 
standard_name, 
standard_id, 
box_name, 
box_id, 
dk_number, 
dk_use_number
 from stage.ziyuan_linbox_m@hbods
