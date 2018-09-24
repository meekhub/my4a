select t.*, t.rowid from tmp_majh_0304_yw_sjz t

update  tmp_majh_0304_yw_sjz set  device_number='0'||device_number where device_number like '3%'

update tmp_majh_0304_yw_sjz s set s.huaxiao_no=trim(s.huaxiao_no),s.device_number=trim(s.device_number);

select count(*),count(distinct device_number) from tmp_majh_0304_yw_sjz

select 510071-509663 from dual;

create table tmp_majh_0401_01 as 
select a.*,
       b.user_no,
       b.user_status,
       b.logout_date,
       b.is_onnet,
       b.is_acct,
       b.is_acct_ocs,
       b.innet_date
  from tmp_majh_0304_yw_sjz a,
       (select *
          from (select a.user_no,
                       device_number,
                       user_status,
                       logout_date,
                       is_onnet,
                       is_acct,
                       is_acct_ocs,
                       tele_type,
                       tele_type_new,
                       innet_date,
                       row_Number() over(partition by device_number order by innet_date desc) rn
                  FROM DW.DW_V_USER_BASE_INFO_USER A
                 WHERE ACCT_MONTH = '201712'
                   and tele_type = '2')
         where rn = 1) b
 where a.DEVICE_NUMBER = b.device_number;
 
 flashback table tmp_majh_0401_01 to before drop;
 
 
--总记录 317565  248824
select count(*) from tmp_majh_0401_01  where is_acct='1' or is_acct_ocs='1'

--离网 42623
 select count(*) from tmp_majh_0401_01 where logout_date is not null
 
 
 create table tmp_majh_0401_02 as 
 select b.* from tmp_majh_0401_01 a,
 (
 select a.user_no,
                       device_number,
                       user_status,
                       logout_date,
                       is_onnet,
                       is_acct,
                       is_acct_ocs,
                       tele_type,
                       tele_type_new  
                  FROM DW.DW_V_USER_BASE_INFO_USER A
                 WHERE ACCT_MONTH = '201803'
                   and tele_type = '2'
 )b
 where a.user_no=b.user_no
 
 
 --1到3月离网
  select count(*) from tmp_majh_0401_02  where to_char(logout_date,'yyyymm') in ('201801','201802','201803')
  
 --3月出账
 select count(*) from tmp_majh_0401_02  where is_acct='1' or is_acct_ocs='1'
 
 --发展人统计
 create table tmp_majh_0401_03 as 
 select 
 a.*,b.develop_no
  from tmp_majh_0401_02 a,
        (select DEVELOP_NO, user_no
          FROM DW.DW_V_USER_MOBILEUSER T
         WHERE T.ACCT_MONTH = '201803'
        union all
        select DEVELOP_NO, user_no
          FROM DW.DW_V_USER_MOBILEUSER_OCS_M T
         WHERE T.ACCT_MONTH = '201803') b
         where a.user_no=b.user_no;

create table tmp_majh_0401_03_1 as 
select area_no,channel_no,DEVELOP_NO, user_no
          FROM DW.DW_V_USER_MOBILEUSER T
         WHERE T.ACCT_MONTH = '201803'
         and to_char(innet_date,'yyyymm') between '201801' and '201803'
         and CHANNEL_KIND_FIR='100000'
        union all
        select area_no,channel_no,DEVELOP_NO, user_no
          FROM DW.DW_V_USER_MOBILEUSER_OCS_M T
         WHERE T.ACCT_MONTH = '201803'
         and to_char(innet_date,'yyyymm') between '201801' and '201803' 
         and CHANNEL_KIND_FIR='100000'        


select count(*),count(distinct DEVELOP_NO) from tmp_majh_0401_03_1 where DEVELOP_NO is  null;

--导出全省直销发展人
select 
c.area_desc,e.city_desc,a.DEVELOP_NO,b.CHANNEL_MEMBER_NAME,b.F_DEALER_ID,d.channel_no_desc
 from 
(select distinct DEVELOP_NO from tmp_majh_0401_03_1) a, rpt_hbtele.SJZX_GM_EMPLOYEE_CODE b,
dim.dim_area_no c,
dim.dim_channel_no d,
dim.dim_city_no e
where a.DEVELOP_NO=b.STAFF_ID(+)
and b.CITY_CODE=c.area_no(+)
and b.F_DEALER_ID=d.channel_no(+)
and d.city_no=e.city_no(+)


--差异用户
create table tmp_majh_0401_04 as 
select 
b.*
 from tmp_majh_0401_01 a,
 (
 select a.user_no,
                       device_number,
                       user_status_desc,
                       logout_date,
                       is_onnet,
                       is_acct,is_acct_ocs,total_fee,total_fee_ocs
                  FROM DW.DW_V_USER_BASE_INFO_USER A
                 WHERE ACCT_MONTH = '201803'
                   and tele_type = '2'
 )b where a.user_no=b.user_no;
 
 
select user_status_desc, count(*), sum(total_fee + total_fee_ocs)
  from tmp_majh_0401_04 a
 where a.is_acct <> '1'
   and a.is_acct_ocs <> '1'
 group by user_status_desc
 
 
 --导出
 select device_number 手机号,
 user_status_desc 截止3月底用户状态,
 logout_date 离网日期(针对离网用户)
  from tmp_majh_0401_04 a
 where a.is_acct <> '1'
   and a.is_acct_ocs <> '1' 
 
 
