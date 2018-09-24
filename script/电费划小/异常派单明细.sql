select 
b.area_name, 
b.group_name, 
b.room_id, 
b.room_name, 
b.elec_amount, 
b.device_amount, 
round(b.pue,4)PUE,
a.USER_NAME,
a.device_number,
a.mail
 from 
(select distinct b.room_id,
                b.room_name,
                a.USER_NAME,
                b.device_number,
                b.mail
  from e_user a, dim_sms_user b
 where a.USER_NAME = b.user_name
   and a.MOBILE = b.device_number)a,
   alldm.tmp_pue_risk@link_hbjf b
   where a.room_id=b.room_id
