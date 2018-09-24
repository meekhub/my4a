select distinct t.user_id, x.user_name, x.mobile
  from new_mobile_cbzs.e_user_role t, new_mobile_cbzs.e_user x
 where t.user_id = x.user_id
   and t.user_id like 'lf_%'
union 
select distinct t.user_id, x.user_name, x.mobile
  from new_mobile_cbzs.e_user_role t, 
 (select * from newdataplatform.e_user@hbods where ext1='183') x
 where t.user_id = x.user_id 
