select 
acct_month 月份, 
day_id 日, 
area_name 地市, 
group_name 区县,  
room_name 站址名称, 
elec_amount 总耗电量, 
device_amount 主设备耗电量, 
pue PUE值, 
replace(RELATION_ID,chr(13),'') 与能耗关系ID
 from elec_station_d t where t.acct_month='201806';
 
 
 --异常关系ID
 select distinct area_name 地市, ROOM_NAME 站址名称,replace(RELATION_ID,chr(13),'') 与能耗关系ID
   from elec_station_d
  where acct_month = '201806'
    and (relation_id like '13%' or relation_id like 'AA%')
