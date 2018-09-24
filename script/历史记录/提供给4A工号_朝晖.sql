select 
a.manager_loginid,
'',
a.manager_loginid,
c.user_name,
c.email,
c.mobile,
'',
'2024/12/18',
'','','','',''
  from (select a.manager_loginid, a.manager_telephone, a.manager_loginname
          from dim.dim_huaxiao_info a
         where a.manager_loginid is not null) a,
       cs_dss.oa_org_user_name_mulu@hbods b,
       new_mobile_cbzs.e_user c
 where a.manager_loginid = b.ispire_staffid(+)
   and a.manager_loginid = c.user_id(+)
   and b.ispire_staffid is null
   and c.user_id is not null
