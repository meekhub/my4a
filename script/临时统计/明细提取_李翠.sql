create table tmp_majh_0326_02 as
SELECT CITY_NO_DESC,
       DEVICE_NUMBER, 
       INNET_DATE， 
       USER_DINNER_DESC， 
       A.CHANNEL_NO， 
       A.CHANNEL_NO_DESC,
       B.AGENT_ID,
       B.AGENT_NAME,
       USER_STATUS_DESC,
       LOGOUT_DATE
  FROM (SELECT CITY_NO_DESC,
               DEVICE_NUMBER,
               CHANNEL_NO_DESC, 
               CUSTOMER_NAME,
               TO_CHAR(INNET_DATE, 'YYYYMMDD') INNET_DATE,
               USER_DINNER_DESC,
               CHANNEL_NO,
               USER_STATUS_DESC,
               TO_CHAR(LOGOUT_DATE, 'YYYYMMDD') LOGOUT_DATE
          FROM DW.DW_V_USER_BASE_INFO_USER B
         WHERE ACCT_MONTH = '201802' 
           AND AREA_NO = '184'
           and tele_type='2') A,
       (SELECT CHANNEL_NO, AGENT_ID, AGENT_NAME
          FROM RPT_HBTELE.DM_BUSI_CHANNEL_BUILD
         WHERE ACCT_MONTH = '201802') B
 WHERE A.CHANNEL_NO = B.CHANNEL_NO(+);



select city_no_desc 区县,
       device_number 手机号,
       innet_date 入网时间,
       user_dinner_desc 套餐,
       channel_no 渠道ID,
       channel_no_desc 渠道名称,
       agent_id 代理商ID,
       agent_name 代理商名称,
       user_status_desc 用户状态,
       logout_date 入网日期
  from tmp_majh_0326_02 t
