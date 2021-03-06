
SELECT B.F_AREA_NAME, SUM(NVL(ARREAR_FEE, 0))
  FROM RPT_USER.BRPT_THREE_ARREAR_USER_2_T A, BRPT_CITY_ID_T B
 WHERE STAT_MONTH = '201412'
   AND SERVICE_KIND = '8'
   AND FEE_DATE > = '200810'
   AND A.CITY_CODE = B.F_CITY_CODE
 GROUP BY B.F_AREA_NAME, B.F_ORDER_BY
 ORDER BY B.F_ORDER_BY;
 
 
 
 SELECT CITY_CODE, SUM(NVL(ARREAR_FEE, 0))
   FROM acct_dsg.BRPT_THREE_ARREAR_USER_1_T A 
 WHERE STAT_MONTH = '201801'
   AND SERVICE_KIND = '8'
   AND FEE_DATE > = '200810'
   group by CITY_CODE

SELECT SERVICE_KIND,sum(NVL(ARREAR_FEE, 0))
   FROM acct_dsg.BRPT_THREE_ARREAR_USER_1_T A 
 WHERE STAT_MONTH = '201802' 
   AND FEE_DATE > = '200810' 
   group by SERVICE_KIND   


select * from dim.dim_tele_type   


--专属套餐
dim.dim_zs_school_dinner

--欠费又开账  
SELECT USER_ID, SUM(ARREAR_FEE) ARREAR_FEE
  FROM (SELECT CITY_CODE, USER_ID, NVL(ARREAR_FEE, 0)
          FROM ACCT_DSG.BRPT_THREE_ARREAR_USER_1_T A
         WHERE STAT_MONTH = '201802'
           AND FEE_DATE > = '200810'
           AND CITY_CODE = C1.AREA_NO
        UNION ALL
        SELECT CITY_CODE, USER_ID, NVL(ARREAR_FEE, 0) * (-1)
          FROM ACCT_DSG.BRPT_THREE_ARREAR_USER_1_T A
         WHERE STAT_MONTH = '201801'
           AND CITY_CODE = C1.AREA_NO
           AND FEE_DATE > = '200810')
 GROUP BY USER_ID
   
--项目分成
SELECT ACCT_MONTH,
       AREA_NO,
       OFFICE_ID CHANNEL_NO,
       NVL(SUM(CASE
                 WHEN NET_TYPE = '2' THEN
                  B.CHARGE
               END),
           0) C_XMFC,
       NVL(SUM(CASE
                 WHEN NET_TYPE <> '2' AND
                      UPPER(DEVICE_NUMBER) NOT LIKE '%TV%' THEN
                  B.CHARGE
               END),
           0) KD_XMFC,
       NVL(SUM(CASE
                 WHEN NET_TYPE <> '2' AND UPPER(DEVICE_NUMBER) LIKE '%TV%' THEN
                  B.CHARGE
               END),
           0) TV_XMFC
  FROM DW.DW_V_USER_COMMISION_XMFC B
 WHERE ACCT_MONTH = V_ACCT_MONTH
   AND IF_PROJECT = '1'
   AND AREA_NO = C1.AREA_NO
GROUP BY ACCT_MONTH, AREA_NO, OFFICE_ID;

   
SELECT ACCT_MONTH,
       AREA_NO,
       USER_NO,
       NVL(SUM(CASE
                 WHEN NET_TYPE = '2' THEN
                  B.CHARGE
               END),
           0) C_XMFC,
       NVL(SUM(CASE
                 WHEN NET_TYPE <> '2' AND
                      UPPER(DEVICE_NUMBER) NOT LIKE '%TV%' THEN
                  B.CHARGE
               END),
           0) KD_XMFC,
       NVL(SUM(CASE
                 WHEN NET_TYPE <> '2' AND UPPER(DEVICE_NUMBER) LIKE '%TV%' THEN
                  B.CHARGE
               END),
           0) TV_XMFC
  FROM DW.DW_V_USER_COMMISION_XMFC B
 WHERE ACCT_MONTH = V_ACCT_MONTH
   AND IF_PROJECT = '1'
   AND AREA_NO = C1.AREA_NO
GROUP BY AREA_NO,USER_NO

   
