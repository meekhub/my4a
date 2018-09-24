select  
       t.mobile,g.description||'-'||t.user_name  as demo
  from mobile_cbzs.e_user           t,
       mobile_cbzs.E_USER_ATTRIBUTE a,
       mobile_cbzs.E_USER_ATTRIBUTE b,
       mobile_cbzs.c_dmcode_area    g,
       MOBILE_CBZS.c_dmcode_city    h
 where t.login_id = a.user_id
   and t.login_id = b.user_id
   and a.attr_value = g.area_id(+)
   and b.attr_value = h.city_id(+)
   and a.attr_code = 'AREA_NO'
   and b.attr_code = 'CITY_NO'
   and t.mobile='15303127137'
   and t.login_id in
       (select distinct user_id
          from mobile_cbzs.e_user_role
         where update_date>sysdate-57);
         
         
         
select  
       t.mobile,g.description||'-'||t.user_name  as demo
  from new_mobile_cbzs.e_user           t,
       new_mobile_cbzs.E_USER_ATTRIBUTE a, 
       new_mobile_cbzs.c_dmcode_area    g
 where t.login_id = a.user_id 
   and a.attr_value = g.area_id(+) 
   and a.attr_code = 'AREA_NO' 
   and t.reg_date>sysdate-10         
