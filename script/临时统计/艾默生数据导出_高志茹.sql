select 
acct_month �·�, 
day_id ��, 
area_name ����, 
group_name ����,  
room_name վַ����, 
elec_amount �ܺĵ���, 
device_amount ���豸�ĵ���, 
pue PUEֵ, 
replace(RELATION_ID,chr(13),'') ���ܺĹ�ϵID
 from elec_station_d t where t.acct_month='201806';
 
 
 --�쳣��ϵID
 select distinct area_name ����, ROOM_NAME վַ����,replace(RELATION_ID,chr(13),'') ���ܺĹ�ϵID
   from elec_station_d
  where acct_month = '201806'
    and (relation_id like '13%' or relation_id like 'AA%')
