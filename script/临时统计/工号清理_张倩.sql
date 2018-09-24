
/*系统名称、系统工号、姓名、手机号码、OA账号、
单位（如为厂家请出具具体厂家名称、如为公司员工请出具OA所在公司）、
OA所在部门、OA职务、本季度是否使用过*/

select '决策系统' sys_name,
       a.user_Id,
       a.user_name,
       a.mobile,
       a.oa_uid,
       nvl(b.user_umo_name, '其他'),
       nvl(b.user_umou_name, '其他'),
       nvl(b.user_title, '其他'),
       case when b.user_id is not null then '是' else '否' end
  from (select user_Id, user_name, mobile, oa_uid, memo
          from newdataplatform.e_user@hbods) a,
       cs_dss.oa_org_user_name_mulu@hbods b,
       (select distinct USER_ID from DSS_FRAME.E_OPERATION_LOG@HBODS t where SUBSTR(T.CREATE_DATE, 1, 8) >= '20180101')c
 where a.oa_uid = b.user_id(+)
 and a.user_Id=c.user_id(+)
 
 --手机经分
select '手机经分',
       a.oa_uid,
       a.login_name,
       a.mobile_phone,
       a.oa_uid,
       nvl(b.user_umo_name, '其他'),
       nvl(b.user_umou_name, '其他'),
       nvl(b.user_title, '其他'),
       case when c.oa_uid is not null then '是' else '否' end
  from 
  (select 
  distinct oa_uid,login_name,mobile_phone
   from  new_mobdss.sc_login_user_rel) a, cs_dss.oa_org_user_name_mulu@hbods b,
   (select distinct oa_uid from NEW_MOBDSS.HISTORY_LOG t where TO_CHAR(T.TIME, 'YYYYMMDD') >= '20180101')c
 where a.oa_uid = b.user_id(+)
 and a.oa_uid=c.oa_uid(+)

 
 
 
 
 
