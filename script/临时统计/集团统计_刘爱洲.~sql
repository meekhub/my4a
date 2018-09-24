select * from mobdss.dmcode_school_name;

create table xxhb_mjh.tmp_majh_group_0801_01 as 
select area_no,CITY_NO,group_no,group_name from dw.dw_v_user_group a where acct_month='201806' group by area_no,CITY_NO,group_no,group_name;



select 
b.area_desc,a.group_no,a.group_name
 from  xxhb_mjh.tmp_majh_group_0801_01 a,dim.dim_area_no_new b
where func_get_xiongan_area_no(a.area_no,a.city_no)=b.area_no;


select * from dw.dw_v_user_group;



CREATE TABLE TMP_MAJH_JT_0803_01 AS 
SELECT A.AREA_NO, A.USER_NO, B.*
  FROM DW.DW_V_USER_PRODUCT_INFO_DAY A, TMP_MAJH_OFF_JT B
 WHERE ACCT_MONTH = '201808'
   AND DAY_ID = '02'
   AND (END_DATE IS NULL OR END_DATE > SYSDATE)
   AND A.USER_DINNER = B.OFFER_ID;
   
集团成员订购集团成员产品表， 字段：地市、 集团ID 、集团名称 、用户ID、 用户号码 、订购成员产品ID、集团成员产品名称； （在自助取数上提供表的模板，由地市自行调取）
;
  

CREATE TABLE TMP_MAJH_JT_0803_02 AS 
SELECT A.AREA_NO_DESC,
       func_get_xiongan_area_desc(a.area_no_desc,a.city_no)area_name,
       B.GROUP_NO,
       B.GROUP_NAME,
       A.USER_NO,
       A.DEVICE_NUMBER,
       C.OFFER_ID,
       C.OFFER_NAME
  FROM (SELECT USER_NO, DEVICE_NUMBER, GROUP_NO, AREA_NO_DESC,area_no_desc  
          FROM DW.DW_V_USER_BASE_INFO_USER A
         WHERE ACCT_MONTH = '201807'
           AND TELE_TYPE = '2'
           AND IS_ONNET = '1') A,
       XXHB_MJH.TMP_MAJH_GROUP_0801_01 B,
       TMP_MAJH_JT_0803_01 C
 WHERE A.GROUP_NO = B.GROUP_NO
   AND A.USER_NO = C.USER_NO;
   
   
SELECT AREA_NO_DESC 地市,
       GROUP_NO 集团ID,
       GROUP_NAME 集团名称,
       USER_NO 用户编码,
       DEVICE_NUMBER 手机号,
       OFFER_ID 集团销售品ID,
       OFFER_NAME 集团销售品编码
  FROM TMP_MAJH_JT_0803_02
   
 
--集团成员明细【以石家庄为例】
SELECT AREA_NO_DESC 地市,
       CITY_NO_DESC 区县,
       GROUP_NO 集团ID,
       GROUP_NAME 集团名称,
       TELE_TYPE_DESC 业务类型,
       DEVICE_NUMBER 接入号,
       USER_TYPE_BIG_DESC 固网用户类型大类,
       DEVELOPER 发展人,
       CHANNEL_NO 渠道编码,
       CHANNEL_NO_DESC 渠道名称,
       CHANNEL_TYPE_DESC 发展渠道类型描述 
  FROM DW.DW_V_USER_BASE_INFO_USER A
 WHERE ACCT_MONTH = '201807'
   AND AREA_NO = '188'
   AND IS_ONNET = '1'
   AND GROUP_NO IS NOT NULL;
   

--省级清单
select 
B.AREA_DESC,A.GROUP_ID,A.GROUP_NAME
 from crm_dsg.bb_group_info_t@hbods A,DIM.DIM_AREA_NO B where group_kind<>'A'
AND A.CITY_CODE=B.AREA_NO;

 
   
   
   
   
