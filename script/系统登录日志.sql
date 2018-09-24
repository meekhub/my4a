--决策系统日志  在55.3上的dss_frame用户下执行
select coun VISIT_NUMS,
       menu_id MENU_ID,
       substr(MENU_PATH, 7, length(MENU_PATH)) MENU_PATH
  from (select count(t.menu_id) coun, t.menu_id, MENU_PATH
          from E_OPERATION_LOG t,
               (SELECT T.RESOURCES_ID,
                       SYS_CONNECT_BY_PATH(T.RESOURCES_NAME,'>>' ) MENU_PATH,
                       T.ORD
                  FROM E_MENU T
                 START WITH T.RESOURCES_ID = '0'
                CONNECT BY PRIOR T.RESOURCES_ID = T.PARENT_ID) m
         where t.menu_id = m.resources_id
          
          AND t.CREATE_DATE >= '20180101' 
         group by t.menu_id, MENU_PATH
         order by coun desc) b
         ORDER BY visit_nums DESC 
--新门户日志  在55.1的new_local_hb_dmn
--本月
create table tmp_menu_sas_01 as
select coun VISIT_NUMS,
       menu_id MENU_ID,
       substr(MENU_PATH, 7, length(MENU_PATH)) MENU_PATH
  from (select count(t.menu_id) coun, t.menu_id, MENU_PATH
          from E_OPERATION_LOG t,
               (SELECT T.RESOURCES_ID,
                       SYS_CONNECT_BY_PATH(T.RESOURCES_NAME,'>>' ) MENU_PATH,
                       T.ORD
                  FROM E_MENU T
                 START WITH T.RESOURCES_ID = '0'
                CONNECT BY PRIOR T.RESOURCES_ID = T.PARENT_ID) m
         where t.menu_id = m.resources_id 
          AND to_char(t.CREATE_DATE,'yyyymm') = '201801'  
         group by t.menu_id, MENU_PATH
         order by coun desc) b
         ORDER BY visit_nums DESC;
         
         
--上月
create table tmp_menu_sas_02 as
select coun VISIT_NUMS,
       menu_id MENU_ID,
       substr(MENU_PATH, 7, length(MENU_PATH)) MENU_PATH
  from (select count(t.menu_id) coun, t.menu_id, MENU_PATH
          from E_OPERATION_LOG t,
               (SELECT T.RESOURCES_ID,
                       SYS_CONNECT_BY_PATH(T.RESOURCES_NAME,'>>' ) MENU_PATH,
                       T.ORD
                  FROM E_MENU T
                 START WITH T.RESOURCES_ID = '0'
                CONNECT BY PRIOR T.RESOURCES_ID = T.PARENT_ID) m
         where t.menu_id = m.resources_id 
          AND to_char(t.CREATE_DATE,'yyyymm') = '201712'  
         group by t.menu_id, MENU_PATH
         order by coun desc) b
         ORDER BY visit_nums DESC;
         
         
select 
a.*
 from tmp_menu_sas_02 a, tmp_menu_sas_01 b
where a.menu_id=b.menu_id(+)
and b.menu_id is null

                      
         
--手机经分(new_mobdss@hbdw)
select * from new_mobdss.sc_login_user_rel t;
select * from new_mobdss.history_log    t       ;  --系统访问日志表
select * from new_mobdss.dmcode_city_ord   t;
select * from new_mobdss.dmcode_area_ord   t;

select c.area_desc,
       count(case
               when b.action = '登录' then
                a.oa_uid
             end),
       count(distinct a.oa_uid),
       count(distinct b.user_id)
  from (select * from new_mobdss.sc_login_user_rel where state = '1') a,
       (select *
          from new_mobdss.history_log
         where to_char(time, 'yyyymm') = '201801') b,
       dim.dim_area_no c
 where a.login_id = b.user_id(+)
   and a.area_no = c.area_no(+)
 group by c.idx_no, c.area_desc
 order by c.idx_no


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

    



旧门户（isp_dss@hbods）
isp_dss.SC_LOG_USER_LOGIN
isp_dss.sc_login_user
ISP_DSS.CODE_CITY 
ISP_DSS.CODE_AREA;

商业智能BI（bi_market@hbdw）
bi_market.pure_user --用户表
bi_market.pure_log_enter --登陆日志表
bi_market.DIM_CITY_NO --地域表

/*select memo,count(distinct a.MOBILE),count(distinct b.USER_ID)
  from bi_market.pure_user a,
       (select *
          from bi_market.pure_log_enter b
         where to_char(LOGIN_DATE, 'yyyymm') = '201712') b
 where a.user_id = b.user_id(+)
 group by memo*/
create table temp_user.tmp_total_log as
select LOGIN_ID,  USER_NAME,MEMO,count(*) cnt
  from (SELECT C.LOGIN_ID  LOGIN_ID,
               C.USER_NAME USER_NAME,
               C.MEMO MEMO,
               substr(B.MENU_PATH, 2, length(B.MENU_PATH)) MENU_ID,
               D.OPERATE_TYPE_DESC OPERATE_TYPE_CODE,
               DECODE(NVL(A.OPERATE_RESULT, 0), '1', '成功', '失败') OPERATE_RESULT,
               b.MENU_PATH,
               A.CONTENT,
               A.CLIENT_IP,
               TO_CHAR(A.CREATE_DATE, 'YYYY-MM-DD HH24:MI:SS') CREATE_DATE
          FROM (SELECT *
                  FROM local_hb_dmn.E_OPERATION_LOG TT
                 WHERE TT.OPERATE_TYPE_CODE = '1'
                   and tt.menu_id = '11041'
                   AND TO_CHAR(TT.CREATE_DATE, 'YYYYMM') = '201712') A,
               (select a.*
                  from (sELECT T.RESOURCES_ID,
                               SYS_CONNECT_BY_PATH(T.RESOURCES_NAME, '>') MENU_PATH,
                               T.ORD
                          FROM local_hb_dmn.E_MENU T
                         START WITH T.RESOURCES_ID = '0'
                        CONNECT BY PRIOR T.RESOURCES_ID = T.PARENT_ID) a/*,
                       (sELECT T.RESOURCES_ID, t.resources_name
                          FROM local_hb_dmn.E_MENU T
                         where t.resources_name like '%渠道%') b
                 where a.RESOURCES_ID = b.RESOURCES_ID*/) B,
               local_hb_dmn.E_USER C,
               local_hb_dmn.E_OPERATE_TYPE D
         WHERE A.MENU_ID = B.RESOURCES_ID(+)
           AND A.USER_ID = C.USER_ID(+)
           AND A.OPERATE_TYPE_CODE = D.OPERATE_TYPE_CODE(+)
         ORDER BY A.CREATE_DATE DESC)
         group by MEMO,LOGIN_ID,USER_NAME 


select user_umou_name,count(distinct a.user_name),count(distinct b.user_name)
from
(select distinct aaa.user_name, aaa.user_umou_name
  from (select tt.user_name, tt.user_id login_id, tt.user_umou_name
          from local_hb_dmn.e_user_role_bi        t,
               local_hb_dmn.oa_org_user_name_mulu tt
         where t.user_id = tt.user_id
        union all 
        select tt.user_name, tt.ispire_staffid login_id, tt.user_umou_name
          from local_hb_dmn.e_user_role_bi t, local_hb_dmn.oa_org_user_name_mulu tt
         where t.user_id = tt.ispire_staffid) aaa)a,
         temp_user.tmp_total_log  b
         where a.user_umou_name=b.memo(+)
         group by user_umou_name

--承包助手
--承包助手用户明细
select CITY_DESC, 
       sum(case
             when acct_month = '201710' then
              count_sums
             else
0
           end) a10,
       sum(case
             when acct_month = '201711' then
              count_sums
             else
0
           end) a11,
       sum(case
             when acct_month = '201712' then
              count_sums
             else
0
           end) a12,
       sum(case
             when acct_month = '201712' then
              count_sums
             else
0
           end) a1           

  from (select NVL(D.DESCRIPTION, '全市') CITY_DESC,
               b.user_id,
               b.user_name,
               b.mobile,
               t.acct_month, --账期
               count(*) count_sums --总登录次数
          from (select to_char(t.login_date, 'yyyymm') acct_month, user_id
                  from new_mobile_cbzs.e_login_log t
                 where to_char(t.login_date, 'yyyymm') >= '201710') t,
               new_mobile_cbzs.e_user_attribute a,
               new_mobile_cbzs.e_user b,
               new_mobile_cbzs.e_user_attribute c,
               new_mobile_cbzs.c_dmcode_city d
         where t.user_id = a.user_id
           and t.user_id = b.user_id
           and t.user_id = c.user_id
           AND C.attr_value = D.CITY_ID(+)
           and c.attr_code = 'CITY_NO'
           and a.attr_code = 'AREA_NO'
           --and a.attr_value = '183'
         group by acct_month,
                  b.user_id,
                  b.user_name,
                  b.mobile,
                  NVL(D.DESCRIPTION, '全市')) d
 group by CITY_DESC 


-- 老门户
select t.acct_month, --账期
       count(*) count_sums, --总登录次数
       count(distinct t.LOGIN_ID) user_sums --总访问人数
  from (select to_char(b.login_date, 'yyyymm') acct_month, LOGIN_ID
          from isp_dss.SC_LOG_USER_LOGIN b
         where to_char(b.login_date, 'yyyymm') = '201801') t
 group by t.acct_month;


--老经分
select t.acct_month, --账期
       count(*) count_sums, --总登录次数
       count(distinct t.LOGIN_ID) user_sums --总访问人数
  from (select to_char(b.LOG_DATE, 'yyyymm') acct_month, LOGIN_ID
          from new_jfdss.sys_log b
         where to_char(b.LOG_DATE, 'yyyymm') = '201801') t
 group by t.acct_month;














