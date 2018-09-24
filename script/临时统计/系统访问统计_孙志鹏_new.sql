--手机经分
select d.user_id,
       d.user_name,
       d.user_umou_name,
       d.mobile_phone, 
       sum(count_sums) a12
  from (select d.user_id,
               d.user_name,
               d.user_umou_name,
               d.MOBILE_PHONE,
               case
                 when acct_month = '201710' then
                  count_sums
                 else
0
               end a10,
               case
                 when acct_month = '201711' then
                  count_sums
                 else
0
               end a11,
               case
                 when acct_month = '201712' then
                  count_sums
                 else
0
               end a12,
               count_sums
          from (select to_char(t.time, 'yyyymm') acct_month, --账期
                       d.user_id,
                       d.user_name,
                       d.user_umou_name,
                       a.mobile_phone,
                       count(t.user_id) count_sums --总登录次数
                  from new_mobdss.HISTORY_LOG t,
                       (select distinct oa_uid, mobile_phone
                          from new_mobdss.sc_login_user_rel a) a,
                       cs_dss.oa_org_user_name_mulu@hbods d
                 where t.oa_uid = d.user_id --和实际OA关联，剔除了测试账号
                   and t.oa_uid = a.oa_uid
                   and t.action_type = '1'
                   and to_char(t.time, 'yyyymm') >= '201712'
                   and d.user_umou_name like '廊坊%'
                 group by to_char(t.time, 'yyyymm'),
                          d.user_id,
                          d.user_name,
                          d.user_umou_name,
                          a.mobile_phone) d) d
 group by d.user_id, d.user_name, d.user_umou_name, d.mobile_phone;


--新门户
select dept_name,
       OA_UID,
       /*user_id,*/
       user_name,
       mobile, 
       sum(count_sums)
  from (select b.memo dept_name,
               b.OA_UID,
               b.user_id,
               b.user_name,
               b.mobile,
               t.acct_month, --账期
               count(*) count_sums --总登录次数
          from (select to_char(t.login_date, 'yyyymm') acct_month, user_id
                  from local_hb_dmn.e_login_log t
                 where to_char(t.login_date, 'yyyymm') = '201712'
                 union all
                 select to_char(t.login_date, 'yyyymm') acct_month, user_id
                  from new_local_hb_dmn.e_login_log t
                 where to_char(t.login_date, 'yyyymm') = '201801') t,
               local_hb_dmn.e_user b
         where t.user_id = b.user_id
           and b.memo like '廊坊%'
         group by b.memo,
                  b.OA_UID,
                  b.user_id,
                  b.user_name,
                  b.mobile,
                  t.acct_month) b
 group by dept_name, OA_UID, user_id, user_name, mobile, acct_month;


--老经分
select CITY_DESC,
       login_id,
       login_name,
       MOBILE_PHONE,
       sum(count_sums)
  from (select t.acct_month,
               nvl(b.CITY_DESC, '全市') CITY_DESC,
               a.login_id,
               a.login_name,
               a.MOBILE_PHONE,
               count(*) count_sums --总登录次数
          from (select to_char(b.LOG_DATE, 'yyyymm') acct_month, LOGIN_ID
                  from new_jfdss.sys_log b
                 where to_char(b.LOG_DATE, 'yyyymm') >= '201712') t,
               new_jfdss.sc_login_user a,
               new_jfdss.code_city b
         where t.login_id = a.login_id
           and a.city = b.city(+)
           and a.area = '183'
         group by t.acct_month,
                  nvl(b.CITY_DESC, '全市'),
                  a.login_id,
                  a.login_name,
                  a.MOBILE_PHONE)
 group by CITY_DESC, login_id, login_name, MOBILE_PHONE;


--本地网
select CITY_DESC,
       user_id,
       user_name,
       mobile,
       sum(count_sums) 
  from (select NVL(D.CITY_DESC, '全市') CITY_DESC,
               b.login_id user_id,
               b.login_name user_name,
               b.MOBILE_PHONE mobile,
               t.acct_month, --账期
               count(*) count_sums --总登录次数
          from (select to_char(t.login_date, 'yyyymm') acct_month, user_id
                  from local_lf_dmn.e_login_log t
                 where to_char(t.login_date, 'yyyymm') = '201801') t,
               CM_LF.SC_LOGIN_USER b,
               local_lf_dmn.cmcode_city d
         where t.user_id = b.login_id
           AND b.city_no = D.CITY_no(+)
         group by acct_month,
                  b.login_id,
                  b.login_name,
                  b.MOBILE_PHONE,
                  NVL(D.CITY_DESC, '全市')) d
 group by CITY_DESC, user_id, user_name, mobile;
