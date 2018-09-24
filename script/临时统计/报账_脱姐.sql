select 
b.area_name,b.SHITI_NO,b.SHITI_name,a.DEVICE_AMOUNT,a.ELEC_AMOUNT
 from 
(SELECT *
  FROM (SELECT B.JZ_CODE, SUM(A.BAOZHANG_FEE)/0.8 DEVICE_AMOUNM
          FROM XXHB_MJH.TMP_MAJH_DB A,
               (SELECT DISTINCT DB_CODE, JZ_CODE,price
                  FROM XXHB_MJH.TMP_MAJH_DF_0504_01 A) B
         WHERE A.DB_CODE = B.DB_CODE
         GROUP BY B.JZ_CODE) A,
       (SELECT B.STATION_ID_B, SUM(A.ELEC_AMOUNT)ELEC_AMOUNT, SUM(A.DEVICE_AMOUNT)DEVICE_AMOUNT
          FROM (SELECT A.AREA_NAME,
                       REPLACE(A.RELATION_ID, CHR(13), '') RELATION_ID,
                       SUM(ELEC_AMOUNT) ELEC_AMOUNT,
                       SUM(DEVICE_AMOUNT) DEVICE_AMOUNT
                  FROM ALLDM.ELEC_STATION_D@OLDHBDW A
                 WHERE ACCT_MONTH = '201803'
                 GROUP BY A.AREA_NAME, A.RELATION_ID
                HAVING SUM(ELEC_AMOUNT) > 0) A,
               (SELECT STATION_ID_A, STATION_ID_B
                  FROM (SELECT STATION_ID_A,
                               STATION_ID_B,
                               ROW_NUMBER() OVER(PARTITION BY STATION_ID_A ORDER BY 1) RN
                          FROM DIM.DIM_STATION_REL
                         WHERE STATION_ID_B IS NOT NULL
                           AND STATION_ID_B <> '#N/A')
                 WHERE RN = 1) B
         WHERE A.RELATION_ID = B.STATION_ID_A
         GROUP BY B.STATION_ID_B) B
 WHERE A.JZ_CODE = B.STATION_ID_B)a,
 (select distinct area_name,SHITI_NO,SHITI_name from DF_STATION_INFO)b
 where a.JZ_CODE=b.SHITI_NO
 and (a.DEVICE_AMOUNT-a.ELEC_AMOUNT)/a.ELEC_AMOUNT>0.1
