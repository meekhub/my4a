SELECT MOBILE_NO, PHONE_NUMBER, SUGGEST_PRICE, RESOURCE_KIND
  FROM CRM_DSG.IR_MOBILE_USING_T@HBODS
 WHERE CITY_CODE = '188';

create table tmp_majh_lx_dinner as
  select user_dinner
    from rpt_hbtele.sjzx_wh_dim_user_dinner t
   where (t.user_dinner_desc like '%乐享%' and low_value >= 129)
      or (t.user_dinner_desc like '%不限量%' and low_value >= 99);
    

create table tmp_majh_lx_0302_01 as  
SELECT A.AREA_NO_DESC,
       A.CITY_NO_DESC,
       A.USER_NO,
       A.DEVICE_NUMBER,
       A.INNET_DATE,
       A.INNET_MONTH,
       CASE
         WHEN A.IS_KD_BUNDLE <> '0' THEN
          '1'
         ELSE
          '0'
       END IS_BUNDLE,
       A.USER_DINNER,
       A.USER_DINNER_DESC
  FROM DW.DW_V_USER_BASE_INFO_DAY A
 WHERE ACCT_MONTH = '201802'
   AND DAY_ID = '28'
   and a.USER_STATUS_DESC='正常服务'
   AND EXISTS (SELECT 1
          FROM TMP_MAJH_LX_DINNER B
         WHERE A.USER_DINNER = B.USER_DINNER);


--沉淀3000元以上的终端
create table tmp_majh_lx_0302_02 as 
        SELECT MOBILE_NO, PHONE_NUMBER, SUGGEST_PRICE, RESOURCE_KIND
          FROM  CRM_DSG.IR_MOBILE_USING_T@HBODS
         where SUGGEST_PRICE >= 300000;
     

create table tmp_majh_lx_0302_03 as 
SELECT A.*, B.TERMINAL_CODE, B.TERMINAL_CORP, B.TERMINAL_MODEL
  FROM TMP_MAJH_LX_0302_01 A,
       (SELECT USER_NO, TERMINAL_CODE, TERMINAL_CORP, TERMINAL_MODEL
          FROM DW.DW_V_USER_TERMINAL_USER_D A
         WHERE ACCT_MONTH = '201802'
           AND DAY_ID = '28') B,
       TMP_MAJH_LX_0302_02 C
 WHERE A.USER_NO = B.USER_NO
   AND B.TERMINAL_CODE = C.MOBILE_NO;
   

create table tmp_majh_lx_0302_04 as 
select 
a.*,
case when b.user_no is not null then '1' else '0' end is_zj,
b.BEGIN_DATE,
b.END_DATE
 from 
tmp_majh_lx_0302_03 a,
(SELECT USER_NO, 
               SALES_MODE,
               TO_CHAR(BEGIN_DATE, 'YYYYMMDD')BEGIN_DATE,
               TO_CHAR(END_DATE, 'YYYYMMDD')END_DATE,
               COST_PRICE
          FROM (SELECT T.*,
                       ROW_NUMBER() OVER(PARTITION BY USER_NO ORDER BY BEGIN_DATE DESC) RN
                  FROM ODS.O_PRD_USER_DEVICE_RENT_D@HBODS T
                 WHERE T.ACCT_MONTH = '201803'
                   AND T.DAY_ID = '01' 
                   AND END_DATE > TO_DATE('20180301', 'YYYYMMDD') + 1)
         WHERE RN = 1)b
         where a.user_no=b.user_no(+);
   
--导出
select area_no_desc 地市,
       city_no_desc 区县,
       device_number 手机号,
       to_char(innet_date, 'yyyymmdd') 入网时间,
       innet_month 入网市场,
       is_bundle 是否融合,
       user_dinner 套餐ID,
       user_dinner_desc 套餐名称,
       terminal_code 终端串码,
       terminal_corp 终端厂商,
       terminal_model 终端型号,
       is_zj 是否租机,
       begin_date 租机开始时间,
       end_date 租机结束时间
  from tmp_majh_lx_0302_04 t

