select * from new_mobile_cbzs.e_user_role t

insert into new_mobile_cbzs.e_user_role
select 
'cbzs_xinhuaxiao' role_code,
a.user_id,
sysdate,
'sf_majh'
from xxhb_mjh.tmp_majh_m_0504_01 a,new_mobile_cbzs.e_user_role  b
where a.user_id=b.user_id(+)
and b.user_id is null
and a.user_name in ('','','','','')

select * from xxhb_mjh.tmp_majh_m_0504_01 where user_name in ('王继军','梁博文','杨文涛','韩家驷','李东洋')

select * from new_mobile_cbzs.e_user where user_id in
(select b.user_id from xxhb_mjh.tmp_majh_m_0504_01 a,new_mobile_cbzs.e_user b
where a.user_id=b.user_id) for update


