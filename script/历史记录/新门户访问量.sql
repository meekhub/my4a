select to_char(t.CREATE_DATE, 'yyyymm'), user_id, count(*)
  from new_local_hb_dmn.E_OPERATION_LOG t
 where to_char(t.CREATE_DATE, 'yyyymm') in ('201801', '201802')
   and t.user_id in (select user_id
                       from newdataplatform.e_user_role@hbods a
                      where a.ROLE_CODE = '43')
 group by to_char(t.CREATE_DATE, 'yyyymm'), user_id
