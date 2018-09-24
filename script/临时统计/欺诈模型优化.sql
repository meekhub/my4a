select * from DM_CHEAT_RISK_USER a where exists 
(select 1 from dw.dw_v_user_base_info_user b
where a.device_number=b.DEVICE_NUMBER and b.ACCT_MONTH='20180')



SELECT INNET_MONTH,count(*)
  FROM DM_CHEAT_RISK_USER A,
       (SELECT DEVICE_NUMBER, USER_NO, INNET_MONTH
          FROM DW.DW_V_USER_BASE_INFO_USER B
         WHERE B.ACCT_MONTH = '201805'
           AND TELE_TYPE = '2'
           and is_onnet='1') B
 WHERE A.DEVICE_NUMBER = B.DEVICE_NUMBER
 group by INNET_MONTH;
 
 
SELECT COUNT(*)
  FROM DM_CHEAT_RISK_USER A,
       (SELECT DEVICE_NUMBER, USER_NO, INNET_MONTH
          FROM DW.DW_V_USER_BASE_INFO_USER B
         WHERE B.ACCT_MONTH = '201805'
           AND TELE_TYPE = '2'
           AND B.CUSTOMER_TYPE <> '3'
           AND IS_ONNET = '1'
           AND B.INNET_MONTH <= 12
           AND B.IS_KD_BUNDLE = '0'
           AND B.ALL_JF_FLUX <= 20) B
 WHERE A.DEVICE_NUMBER = B.DEVICE_NUMBER



