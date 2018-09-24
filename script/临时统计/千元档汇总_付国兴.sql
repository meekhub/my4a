CREATE TABLE TMP_MAJH_TRM_0514_02 AS 
SELECT A.*,
       B.AREA_NO,
       B.CITY_NO,
       B.TERMINAL_CORP,
       B.TERMINAL_MODEL,
       TO_CHAR(B.REG_DATE, 'YYYYMMDDHH24MISS') REG_DATE,
       B.USER_NO,
       B.DEVICE_NO
  FROM tmp_majh_trm_0530_01 A,
       (SELECT *
          FROM DW.DW_V_USER_TERMINAL_DEVICE_D B
         WHERE ACCT_MONTH = '201808'
         AND DAY_ID='26'
         --AND TO_CHAR(REG_DATE,'YYYYMMDD') BETWEEN '20180402' AND '20180630'
         ) B
 WHERE A.TERMINAL_CODE = B.TERMINAL_CODE(+);



CREATE TABLE TMP_MAJH_TRM_0514_03 AS
SELECT    
a.terminal_code, 
c.area_no, 
a.city_no, 
a.terminal_corp, 
a.terminal_model, 
a.reg_date, 
a.user_no, 
a.device_no,
CASE WHEN C.IS_3NO_ADJUST='1' THEN '是' ELSE '否' END IS_3NO，
CASE WHEN C.USER_DINNER_DESC LIKE '%加装%' THEN '否' ELSE '是' END IS_ZHU 
 FROM TMP_MAJH_TRM_0514_02 A, 
(
SELECT area_no,USER_NO，USER_DINNER_DESC,IS_3NO_ADJUST  FROM DW.DW_V_USER_BASE_INFO_USER C
WHERE ACCT_MONTH='201807' 
AND TELE_TYPE='2'
)C
WHERE A.USER_NO=C.USER_NO(+);


SELECT 
        
       A.TERMINAL_CODE 串码, 
       A.REG_DATE 首次注册时间,
       A.DEVICE_NO 首次注册号码,
       A.TERMINAL_CORP 品牌,
       A.TERMINAL_MODEL 型号2, 
       case when a.device_no is not null then A.IS_3NO end 是否三无,
       case when a.device_no is not null then A.IS_ZHU end 是否主卡,
       b.idx_no
  FROM TMP_MAJH_TRM_0514_03 A,tmp_majh_trm_0530_01 b
  where a.terminal_code=b.terminal_code
  order by b.idx_no














