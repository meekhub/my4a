select 

 from
(SELECT T.AREA_NO,
       T.CITY_NO,
       T.HUAXIAO_TYPE,
       T.HUAXIAO_NO,
       T.HUAXIAO_NAME,
       SUM(A.PRICE_FEE) PRICE_FEE,
       SUM(A.TOTAL_FEE_CL) TOTAL_FEE_CL,
       SUM(ONNET_CDMA_NUM) ONNET_CDMA_NUM,
       SUM(ACCT_CDMA_NUM) ACCT_CDMA_NUM,
       SUM(ACCT_CDMA_NUM_CL) ACCT_CDMA_NUM_CL,
       SUM(CDMA_NEW) CDMA_NEW,
       SUM(CDMA_NEW_YEAR) CDMA_NEW_YEAR,
       SUM(ACCT_CDMA_NUM) JZ_CDMA_NUM,
       SUM(ONNET_ADSL_NUM) ONNET_ADSL_NUM,
       SUM(ACCT_ADSL_NUM) ACCT_ADSL_NUM,
       SUM(ACCT_ADSL_NUM_CL) ACCT_ADSL_NUM_CL,
       SUM(ADSL_NEW) ADSL_NEW,
       SUM(ADSL_NEW_YEAR) ADSL_NEW_YEAR,
       SUM(ONNET_ADSL_NUM) JZ_ADSL_NUM,
       SUM(ONNET_IPTV_NUM) ONNET_IPTV_NUM,
       SUM(ACCT_IPTV_NUM) ACCT_IPTV_NUM,
       SUM(ACCT_IPTV_NUM_CL) ACCT_IPTV_NUM_CL,
       SUM(IPTV_NEW) IPTV_NEW,
       SUM(IPTV_NEW_YEAR) IPTV_NEW_YEAR,
       SUM(ONNET_IPTV_NUM) JZ_IPTV_NUM,
       SUM(ONNET_ZXDL_NUM) ONNET_ZXDL_NUM,
       SUM(ACCT_ZXDL_NUM) ACCT_ZXDL_NUM,
       SUM(ACCT_ZXDL_NUM_CL) ACCT_ZXDL_NUM_CL,
       SUM(ZXDL_NEW) ZXDL_NEW,
       SUM(ZXDL_NEW_YEAR) ZXDL_NEW_YEAR,
       SUM(ONNET_ZXDL_NUM) JZ_ZXDL_NUM,
       SUM(ONNET_GH_NUM) ONNET_GH_NUM,
       SUM(ACCT_GH_NUM) ACCT_GH_NUM,
       SUM(ACCT_GH_NUM_CL) ACCT_GH_NUM_CL,
       SUM(GH_NEW) GH_NEW,
       SUM(GH_NEW_YEAR) GH_NEW_YEAR,
       0 JZ_GH_NUM,
       0 ONNET_XX_NUM,
       0 ACCT_XX_NUM,
       0 ACCT_XX_NUM_CL,
       0 XX_NEW,
       0 XX_NEW_YEAR,
       0 JZ_XX_NUM,
       SUM(QFCS_FEE) QFCS_FEE,
       SUM(XMFC_FEE) XMFC_FEE
  FROM (SELECT A.HUAXIAO_NO_05, 
               -- C网
               SUM(NVL(A.PRICE_FEE, 0)) + SUM(NVL(A.PRICE_FEE_OCS, 0)) AS PRICE_FEE,
               SUM(CASE
                     WHEN TO_CHAR(A.INNET_DATE, 'YYYYMM') <= '201712' THEN
                      NVL(A.PRICE_FEE, 0) + NVL(A.PRICE_FEE_OCS, 0)
                     ELSE
                      0
                   END) TOTAL_FEE_CL,
               SUM(CASE
                     WHEN A.TELE_TYPE = '2' AND A.IS_ONNET = '1' THEN
                      1
                     ELSE
                      0
                   END) ONNET_CDMA_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE = '2' AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                      1
                     ELSE
                      0
                   END) ACCT_CDMA_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE = '2' AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                          TO_CHAR(A.INNET_DATE, 'YYYYMM') <= '201712' THEN
                      1
                     ELSE
                      0
                   END) ACCT_CDMA_NUM_CL,
               SUM(CASE
                     WHEN A.TELE_TYPE = '2' AND A.IS_NEW = '1' THEN
                      1
                     ELSE
                      0
                   END) CDMA_NEW,
               SUM(CASE
                     WHEN A.TELE_TYPE = '2' AND
                          TO_CHAR(A.INNET_DATE, 'YYYY') = '2018' THEN
                      1
                     ELSE
                      0
                   END) CDMA_NEW_YEAR,
               
               --宽带
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G010' AND A.IS_ONNET = '1' THEN
                      1
                     ELSE
                      0
                   END) ONNET_ADSL_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G010' AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                      1
                     ELSE
                      0
                   END) ACCT_ADSL_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G010' AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                          TO_CHAR(A.INNET_DATE, 'YYYYMM') <= '201712' THEN
                      1
                     ELSE
                      0
                   END) ACCT_ADSL_NUM_CL,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G010' AND A.IS_NEW = '1' THEN
                      1
                     ELSE
                      0
                   END) ADSL_NEW,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G010' AND
                          TO_CHAR(A.INNET_DATE, 'YYYY') = '2018' THEN
                      1
                     ELSE
                      0
                   END) ADSL_NEW_YEAR,
               --IPTV
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G110' AND A.IS_ONNET = '1' THEN
                      1
                     ELSE
                      0
                   END) ONNET_IPTV_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G110' AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                      1
                     ELSE
                      0
                   END) ACCT_IPTV_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G110' AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                          TO_CHAR(A.INNET_DATE, 'YYYYMM') <= '201712' THEN
                      1
                     ELSE
                      0
                   END) ACCT_IPTV_NUM_CL,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G110' AND A.IS_NEW = '1' THEN
                      1
                     ELSE
                      0
                   END) IPTV_NEW,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G110' AND
                          TO_CHAR(A.INNET_DATE, 'YYYY') = '2018' THEN
                      1
                     ELSE
                      0
                   END) IPTV_NEW_YEAR,
               --专线电路
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                          A.IS_ONNET = '1' THEN
                      1
                     ELSE
                      0
                   END) ONNET_ZXDL_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                      1
                     ELSE
                      0
                   END) ACCT_ZXDL_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                          TO_CHAR(A.INNET_DATE, 'YYYYMM') <= '201712' THEN
                      1
                     ELSE
                      0
                   END) ACCT_ZXDL_NUM_CL,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND A.IS_NEW = '1' THEN
                      1
                     ELSE
                      0
                   END) ZXDL_NEW,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                          TO_CHAR(A.INNET_DATE, 'YYYY') = '2018' THEN
                      1
                     ELSE
                      0
                   END) ZXDL_NEW_YEAR,
               --固话
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                          A.IS_ONNET = '1' THEN
                      1
                     ELSE
                      0
                   END) ONNET_GH_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                      1
                     ELSE
                      0
                   END) ACCT_GH_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                          TO_CHAR(A.INNET_DATE, 'YYYYMM') <= '201712' THEN
                      1
                     ELSE
                      0
                   END) ACCT_GH_NUM_CL,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                          A.IS_NEW = '1' THEN
                      1
                     ELSE
                      0
                   END) GH_NEW,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                          TO_CHAR(A.INNET_DATE, 'YYYY') = '2018' THEN
                      1
                     ELSE
                      0
                   END) GH_NEW_YEAR,
               SUM(A.QFCS_FEE) QFCS_FEE,
               SUM(A.XMFC_FEE) XMFC_FEE
          FROM DW.DW_V_USER_HUAXIAO_INFO_ALL A
         WHERE A.ACCT_MONTH = '201803'
           AND AREA_NO = '188' 
           AND A.IS_HUAXIAO_05 = '1'
         GROUP BY A.HUAXIAO_NO_05 )A,
       (SELECT *
          FROM DIM.DIM_HUAXIAO_INFO T
         WHERE T.AREA_NO = '188'
           AND T.HUAXIAO_TYPE = '05') T
 WHERE A.HUAXIAO_NO_05 = T.HUAXIAO_NO
group by T.AREA_NO,
       T.CITY_NO,
       T.HUAXIAO_TYPE,
       T.HUAXIAO_NO,
       T.HUAXIAO_NAME
union all
--营维
SELECT T.AREA_NO,
       T.CITY_NO,
       T.HUAXIAO_TYPE,
       T.HUAXIAO_NO,
       T.HUAXIAO_NAME,
       SUM(A.PRICE_FEE) PRICE_FEE,
       SUM(A.TOTAL_FEE_CL) TOTAL_FEE_CL,
       SUM(ONNET_CDMA_NUM) ONNET_CDMA_NUM,
       SUM(ACCT_CDMA_NUM) ACCT_CDMA_NUM,
       SUM(ACCT_CDMA_NUM_CL) ACCT_CDMA_NUM_CL,
       SUM(CDMA_NEW) CDMA_NEW,
       SUM(CDMA_NEW_YEAR) CDMA_NEW_YEAR,
       SUM(ACCT_CDMA_NUM) JZ_CDMA_NUM,
       SUM(ONNET_ADSL_NUM) ONNET_ADSL_NUM,
       SUM(ACCT_ADSL_NUM) ACCT_ADSL_NUM,
       SUM(ACCT_ADSL_NUM_CL) ACCT_ADSL_NUM_CL,
       SUM(ADSL_NEW) ADSL_NEW,
       SUM(ADSL_NEW_YEAR) ADSL_NEW_YEAR,
       SUM(ONNET_ADSL_NUM) JZ_ADSL_NUM,
       SUM(ONNET_IPTV_NUM) ONNET_IPTV_NUM,
       SUM(ACCT_IPTV_NUM) ACCT_IPTV_NUM,
       SUM(ACCT_IPTV_NUM_CL) ACCT_IPTV_NUM_CL,
       SUM(IPTV_NEW) IPTV_NEW,
       SUM(IPTV_NEW_YEAR) IPTV_NEW_YEAR,
       SUM(ONNET_IPTV_NUM) JZ_IPTV_NUM,
       SUM(ONNET_ZXDL_NUM) ONNET_ZXDL_NUM,
       SUM(ACCT_ZXDL_NUM) ACCT_ZXDL_NUM,
       SUM(ACCT_ZXDL_NUM_CL) ACCT_ZXDL_NUM_CL,
       SUM(ZXDL_NEW) ZXDL_NEW,
       SUM(ZXDL_NEW_YEAR) ZXDL_NEW_YEAR,
       SUM(ONNET_ZXDL_NUM) JZ_ZXDL_NUM,
       SUM(ONNET_GH_NUM) ONNET_GH_NUM,
       SUM(ACCT_GH_NUM) ACCT_GH_NUM,
       SUM(ACCT_GH_NUM_CL) ACCT_GH_NUM_CL,
       SUM(GH_NEW) GH_NEW,
       SUM(GH_NEW_YEAR) GH_NEW_YEAR,
       0 JZ_GH_NUM,
       0 ONNET_XX_NUM,
       0 ACCT_XX_NUM,
       0 ACCT_XX_NUM_CL,
       0 XX_NEW,
       0 XX_NEW_YEAR,
       0 JZ_XX_NUM,
       SUM(QFCS_FEE) QFCS_FEE,
       SUM(XMFC_FEE) XMFC_FEE
  FROM (SELECT A.HUAXIAO_NO_06, 
               -- C网
               SUM(NVL(A.PRICE_FEE, 0)) + SUM(NVL(A.PRICE_FEE_OCS, 0)) AS PRICE_FEE,
               SUM(CASE
                     WHEN TO_CHAR(A.INNET_DATE, 'YYYYMM') <= '201712' THEN
                      NVL(A.PRICE_FEE, 0) + NVL(A.PRICE_FEE_OCS, 0)
                     ELSE
                      0
                   END) TOTAL_FEE_CL,
               SUM(CASE
                     WHEN A.TELE_TYPE = '2' AND A.IS_ONNET = '1' THEN
                      1
                     ELSE
                      0
                   END) ONNET_CDMA_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE = '2' AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                      1
                     ELSE
                      0
                   END) ACCT_CDMA_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE = '2' AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                          TO_CHAR(A.INNET_DATE, 'YYYYMM') <= '201712' THEN
                      1
                     ELSE
                      0
                   END) ACCT_CDMA_NUM_CL,
               SUM(CASE
                     WHEN A.TELE_TYPE = '2' AND A.IS_NEW = '1' THEN
                      1
                     ELSE
                      0
                   END) CDMA_NEW,
               SUM(CASE
                     WHEN A.TELE_TYPE = '2' AND
                          TO_CHAR(A.INNET_DATE, 'YYYY') = '2018' THEN
                      1
                     ELSE
                      0
                   END) CDMA_NEW_YEAR,
               
               --宽带
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G010' AND A.IS_ONNET = '1' THEN
                      1
                     ELSE
                      0
                   END) ONNET_ADSL_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G010' AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                      1
                     ELSE
                      0
                   END) ACCT_ADSL_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G010' AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                          TO_CHAR(A.INNET_DATE, 'YYYYMM') <= '201712' THEN
                      1
                     ELSE
                      0
                   END) ACCT_ADSL_NUM_CL,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G010' AND A.IS_NEW = '1' THEN
                      1
                     ELSE
                      0
                   END) ADSL_NEW,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G010' AND
                          TO_CHAR(A.INNET_DATE, 'YYYY') = '2018' THEN
                      1
                     ELSE
                      0
                   END) ADSL_NEW_YEAR,
               --IPTV
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G110' AND A.IS_ONNET = '1' THEN
                      1
                     ELSE
                      0
                   END) ONNET_IPTV_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G110' AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                      1
                     ELSE
                      0
                   END) ACCT_IPTV_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G110' AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                          TO_CHAR(A.INNET_DATE, 'YYYYMM') <= '201712' THEN
                      1
                     ELSE
                      0
                   END) ACCT_IPTV_NUM_CL,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G110' AND A.IS_NEW = '1' THEN
                      1
                     ELSE
                      0
                   END) IPTV_NEW,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G110' AND
                          TO_CHAR(A.INNET_DATE, 'YYYY') = '2018' THEN
                      1
                     ELSE
                      0
                   END) IPTV_NEW_YEAR,
               --专线电路
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                          A.IS_ONNET = '1' THEN
                      1
                     ELSE
                      0
                   END) ONNET_ZXDL_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                      1
                     ELSE
                      0
                   END) ACCT_ZXDL_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                          TO_CHAR(A.INNET_DATE, 'YYYYMM') <= '201712' THEN
                      1
                     ELSE
                      0
                   END) ACCT_ZXDL_NUM_CL,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND A.IS_NEW = '1' THEN
                      1
                     ELSE
                      0
                   END) ZXDL_NEW,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                          TO_CHAR(A.INNET_DATE, 'YYYY') = '2018' THEN
                      1
                     ELSE
                      0
                   END) ZXDL_NEW_YEAR,
               --固话
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                          A.IS_ONNET = '1' THEN
                      1
                     ELSE
                      0
                   END) ONNET_GH_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                      1
                     ELSE
                      0
                   END) ACCT_GH_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                          TO_CHAR(A.INNET_DATE, 'YYYYMM') <= '201712' THEN
                      1
                     ELSE
                      0
                   END) ACCT_GH_NUM_CL,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                          A.IS_NEW = '1' THEN
                      1
                     ELSE
                      0
                   END) GH_NEW,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                          TO_CHAR(A.INNET_DATE, 'YYYY') = '2018' THEN
                      1
                     ELSE
                      0
                   END) GH_NEW_YEAR,
               SUM(A.QFCS_FEE) QFCS_FEE,
               SUM(A.XMFC_FEE) XMFC_FEE
          FROM DW.DW_V_USER_HUAXIAO_INFO_ALL A
         WHERE A.ACCT_MONTH = '201803'
           AND AREA_NO = '188' 
           AND A.IS_HUAXIAO_06 = '1'
         GROUP BY A.HUAXIAO_NO_06 )A,
       (SELECT *
          FROM DIM.DIM_HUAXIAO_INFO T
         WHERE T.AREA_NO = '188'
           AND T.HUAXIAO_TYPE = '06') T
 WHERE A.HUAXIAO_NO_06 = T.HUAXIAO_NO
group by T.AREA_NO,
       T.CITY_NO,
       T.HUAXIAO_TYPE,
       T.HUAXIAO_NO,
       T.HUAXIAO_NAME      

--校园
SELECT T.AREA_NO,
       T.CITY_NO,
       T.HUAXIAO_TYPE,
       T.HUAXIAO_NO,
       T.HUAXIAO_NAME,
       SUM(A.PRICE_FEE) PRICE_FEE,
       SUM(A.TOTAL_FEE_CL) TOTAL_FEE_CL,
       SUM(ONNET_CDMA_NUM) ONNET_CDMA_NUM,
       SUM(ACCT_CDMA_NUM) ACCT_CDMA_NUM,
       SUM(ACCT_CDMA_NUM_CL) ACCT_CDMA_NUM_CL,
       SUM(CDMA_NEW) CDMA_NEW,
       SUM(CDMA_NEW_YEAR) CDMA_NEW_YEAR,
       SUM(ACCT_CDMA_NUM) JZ_CDMA_NUM,
       SUM(ONNET_ADSL_NUM) ONNET_ADSL_NUM,
       SUM(ACCT_ADSL_NUM) ACCT_ADSL_NUM,
       SUM(ACCT_ADSL_NUM_CL) ACCT_ADSL_NUM_CL,
       SUM(ADSL_NEW) ADSL_NEW,
       SUM(ADSL_NEW_YEAR) ADSL_NEW_YEAR,
       SUM(ONNET_ADSL_NUM) JZ_ADSL_NUM,
       SUM(ONNET_IPTV_NUM) ONNET_IPTV_NUM,
       SUM(ACCT_IPTV_NUM) ACCT_IPTV_NUM,
       SUM(ACCT_IPTV_NUM_CL) ACCT_IPTV_NUM_CL,
       SUM(IPTV_NEW) IPTV_NEW,
       SUM(IPTV_NEW_YEAR) IPTV_NEW_YEAR,
       SUM(ONNET_IPTV_NUM) JZ_IPTV_NUM,
       SUM(ONNET_ZXDL_NUM) ONNET_ZXDL_NUM,
       SUM(ACCT_ZXDL_NUM) ACCT_ZXDL_NUM,
       SUM(ACCT_ZXDL_NUM_CL) ACCT_ZXDL_NUM_CL,
       SUM(ZXDL_NEW) ZXDL_NEW,
       SUM(ZXDL_NEW_YEAR) ZXDL_NEW_YEAR,
       SUM(ONNET_ZXDL_NUM) JZ_ZXDL_NUM,
       SUM(ONNET_GH_NUM) ONNET_GH_NUM,
       SUM(ACCT_GH_NUM) ACCT_GH_NUM,
       SUM(ACCT_GH_NUM_CL) ACCT_GH_NUM_CL,
       SUM(GH_NEW) GH_NEW,
       SUM(GH_NEW_YEAR) GH_NEW_YEAR,
       0 JZ_GH_NUM,
       0 ONNET_XX_NUM,
       0 ACCT_XX_NUM,
       0 ACCT_XX_NUM_CL,
       0 XX_NEW,
       0 XX_NEW_YEAR,
       0 JZ_XX_NUM,
       SUM(QFCS_FEE) QFCS_FEE,
       SUM(XMFC_FEE) XMFC_FEE
  FROM (SELECT A.HUAXIAO_NO_07, 
               -- C网
               SUM(NVL(A.PRICE_FEE, 0)) + SUM(NVL(A.PRICE_FEE_OCS, 0)) AS PRICE_FEE,
               SUM(CASE
                     WHEN TO_CHAR(A.INNET_DATE, 'YYYYMM') <= '201712' THEN
                      NVL(A.PRICE_FEE, 0) + NVL(A.PRICE_FEE_OCS, 0)
                     ELSE
                      0
                   END) TOTAL_FEE_CL,
               SUM(CASE
                     WHEN A.TELE_TYPE = '2' AND A.IS_ONNET = '1' THEN
                      1
                     ELSE
                      0
                   END) ONNET_CDMA_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE = '2' AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                      1
                     ELSE
                      0
                   END) ACCT_CDMA_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE = '2' AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                          TO_CHAR(A.INNET_DATE, 'YYYYMM') <= '201712' THEN
                      1
                     ELSE
                      0
                   END) ACCT_CDMA_NUM_CL,
               SUM(CASE
                     WHEN A.TELE_TYPE = '2' AND A.IS_NEW = '1' THEN
                      1
                     ELSE
                      0
                   END) CDMA_NEW,
               SUM(CASE
                     WHEN A.TELE_TYPE = '2' AND
                          TO_CHAR(A.INNET_DATE, 'YYYY') = '2018' THEN
                      1
                     ELSE
                      0
                   END) CDMA_NEW_YEAR,
               
               --宽带
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G010' AND A.IS_ONNET = '1' THEN
                      1
                     ELSE
                      0
                   END) ONNET_ADSL_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G010' AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                      1
                     ELSE
                      0
                   END) ACCT_ADSL_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G010' AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                          TO_CHAR(A.INNET_DATE, 'YYYYMM') <= '201712' THEN
                      1
                     ELSE
                      0
                   END) ACCT_ADSL_NUM_CL,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G010' AND A.IS_NEW = '1' THEN
                      1
                     ELSE
                      0
                   END) ADSL_NEW,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G010' AND
                          TO_CHAR(A.INNET_DATE, 'YYYY') = '2018' THEN
                      1
                     ELSE
                      0
                   END) ADSL_NEW_YEAR,
               --IPTV
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G110' AND A.IS_ONNET = '1' THEN
                      1
                     ELSE
                      0
                   END) ONNET_IPTV_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G110' AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                      1
                     ELSE
                      0
                   END) ACCT_IPTV_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G110' AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                          TO_CHAR(A.INNET_DATE, 'YYYYMM') <= '201712' THEN
                      1
                     ELSE
                      0
                   END) ACCT_IPTV_NUM_CL,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G110' AND A.IS_NEW = '1' THEN
                      1
                     ELSE
                      0
                   END) IPTV_NEW,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G110' AND
                          TO_CHAR(A.INNET_DATE, 'YYYY') = '2018' THEN
                      1
                     ELSE
                      0
                   END) IPTV_NEW_YEAR,
               --专线电路
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                          A.IS_ONNET = '1' THEN
                      1
                     ELSE
                      0
                   END) ONNET_ZXDL_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                      1
                     ELSE
                      0
                   END) ACCT_ZXDL_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                          TO_CHAR(A.INNET_DATE, 'YYYYMM') <= '201712' THEN
                      1
                     ELSE
                      0
                   END) ACCT_ZXDL_NUM_CL,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND A.IS_NEW = '1' THEN
                      1
                     ELSE
                      0
                   END) ZXDL_NEW,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                          TO_CHAR(A.INNET_DATE, 'YYYY') = '2018' THEN
                      1
                     ELSE
                      0
                   END) ZXDL_NEW_YEAR,
               --固话
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                          A.IS_ONNET = '1' THEN
                      1
                     ELSE
                      0
                   END) ONNET_GH_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                      1
                     ELSE
                      0
                   END) ACCT_GH_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                          TO_CHAR(A.INNET_DATE, 'YYYYMM') <= '201712' THEN
                      1
                     ELSE
                      0
                   END) ACCT_GH_NUM_CL,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                          A.IS_NEW = '1' THEN
                      1
                     ELSE
                      0
                   END) GH_NEW,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                          TO_CHAR(A.INNET_DATE, 'YYYY') = '2018' THEN
                      1
                     ELSE
                      0
                   END) GH_NEW_YEAR,
               SUM(A.QFCS_FEE) QFCS_FEE,
               SUM(A.XMFC_FEE) XMFC_FEE
          FROM DW.DW_V_USER_HUAXIAO_INFO_ALL A
         WHERE A.ACCT_MONTH = '201803'
           AND AREA_NO = '188' 
           AND A.IS_HUAXIAO_07 = '1'
         GROUP BY A.HUAXIAO_NO_07 )A,
       (SELECT *
          FROM DIM.DIM_HUAXIAO_INFO T
         WHERE T.AREA_NO = '188'
           AND T.HUAXIAO_TYPE = '07') T
 WHERE A.HUAXIAO_NO_07 = T.HUAXIAO_NO
group by T.AREA_NO,
       T.CITY_NO,
       T.HUAXIAO_TYPE,
       T.HUAXIAO_NO,
       T.HUAXIAO_NAME       

--物联网
SELECT T.AREA_NO,
       T.CITY_NO,
       T.HUAXIAO_TYPE,
       T.HUAXIAO_NO,
       T.HUAXIAO_NAME,
       SUM(A.PRICE_FEE) PRICE_FEE,
       SUM(A.TOTAL_FEE_CL) TOTAL_FEE_CL,
       SUM(ONNET_CDMA_NUM) ONNET_CDMA_NUM,
       SUM(ACCT_CDMA_NUM) ACCT_CDMA_NUM,
       SUM(ACCT_CDMA_NUM_CL) ACCT_CDMA_NUM_CL,
       SUM(CDMA_NEW) CDMA_NEW,
       SUM(CDMA_NEW_YEAR) CDMA_NEW_YEAR,
       SUM(ACCT_CDMA_NUM) JZ_CDMA_NUM,
       SUM(ONNET_ADSL_NUM) ONNET_ADSL_NUM,
       SUM(ACCT_ADSL_NUM) ACCT_ADSL_NUM,
       SUM(ACCT_ADSL_NUM_CL) ACCT_ADSL_NUM_CL,
       SUM(ADSL_NEW) ADSL_NEW,
       SUM(ADSL_NEW_YEAR) ADSL_NEW_YEAR,
       SUM(ONNET_ADSL_NUM) JZ_ADSL_NUM,
       SUM(ONNET_IPTV_NUM) ONNET_IPTV_NUM,
       SUM(ACCT_IPTV_NUM) ACCT_IPTV_NUM,
       SUM(ACCT_IPTV_NUM_CL) ACCT_IPTV_NUM_CL,
       SUM(IPTV_NEW) IPTV_NEW,
       SUM(IPTV_NEW_YEAR) IPTV_NEW_YEAR,
       SUM(ONNET_IPTV_NUM) JZ_IPTV_NUM,
       SUM(ONNET_ZXDL_NUM) ONNET_ZXDL_NUM,
       SUM(ACCT_ZXDL_NUM) ACCT_ZXDL_NUM,
       SUM(ACCT_ZXDL_NUM_CL) ACCT_ZXDL_NUM_CL,
       SUM(ZXDL_NEW) ZXDL_NEW,
       SUM(ZXDL_NEW_YEAR) ZXDL_NEW_YEAR,
       SUM(ONNET_ZXDL_NUM) JZ_ZXDL_NUM,
       SUM(ONNET_GH_NUM) ONNET_GH_NUM,
       SUM(ACCT_GH_NUM) ACCT_GH_NUM,
       SUM(ACCT_GH_NUM_CL) ACCT_GH_NUM_CL,
       SUM(GH_NEW) GH_NEW,
       SUM(GH_NEW_YEAR) GH_NEW_YEAR,
       0 JZ_GH_NUM,
       0 ONNET_XX_NUM,
       0 ACCT_XX_NUM,
       0 ACCT_XX_NUM_CL,
       0 XX_NEW,
       0 XX_NEW_YEAR,
       0 JZ_XX_NUM,
       SUM(QFCS_FEE) QFCS_FEE,
       SUM(XMFC_FEE) XMFC_FEE
  FROM (SELECT A.HUAXIAO_NO_08, 
               -- C网
               SUM(NVL(A.PRICE_FEE, 0)) + SUM(NVL(A.PRICE_FEE_OCS, 0)) AS PRICE_FEE,
               SUM(CASE
                     WHEN TO_CHAR(A.INNET_DATE, 'YYYYMM') <= '201712' THEN
                      NVL(A.PRICE_FEE, 0) + NVL(A.PRICE_FEE_OCS, 0)
                     ELSE
                      0
                   END) TOTAL_FEE_CL,
               SUM(CASE
                     WHEN A.TELE_TYPE = '2' AND A.IS_ONNET = '1' THEN
                      1
                     ELSE
                      0
                   END) ONNET_CDMA_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE = '2' AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                      1
                     ELSE
                      0
                   END) ACCT_CDMA_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE = '2' AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                          TO_CHAR(A.INNET_DATE, 'YYYYMM') <= '201712' THEN
                      1
                     ELSE
                      0
                   END) ACCT_CDMA_NUM_CL,
               SUM(CASE
                     WHEN A.TELE_TYPE = '2' AND A.IS_NEW = '1' THEN
                      1
                     ELSE
                      0
                   END) CDMA_NEW,
               SUM(CASE
                     WHEN A.TELE_TYPE = '2' AND
                          TO_CHAR(A.INNET_DATE, 'YYYY') = '2018' THEN
                      1
                     ELSE
                      0
                   END) CDMA_NEW_YEAR,
               
               --宽带
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G010' AND A.IS_ONNET = '1' THEN
                      1
                     ELSE
                      0
                   END) ONNET_ADSL_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G010' AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                      1
                     ELSE
                      0
                   END) ACCT_ADSL_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G010' AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                          TO_CHAR(A.INNET_DATE, 'YYYYMM') <= '201712' THEN
                      1
                     ELSE
                      0
                   END) ACCT_ADSL_NUM_CL,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G010' AND A.IS_NEW = '1' THEN
                      1
                     ELSE
                      0
                   END) ADSL_NEW,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G010' AND
                          TO_CHAR(A.INNET_DATE, 'YYYY') = '2018' THEN
                      1
                     ELSE
                      0
                   END) ADSL_NEW_YEAR,
               --IPTV
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G110' AND A.IS_ONNET = '1' THEN
                      1
                     ELSE
                      0
                   END) ONNET_IPTV_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G110' AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                      1
                     ELSE
                      0
                   END) ACCT_IPTV_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G110' AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                          TO_CHAR(A.INNET_DATE, 'YYYYMM') <= '201712' THEN
                      1
                     ELSE
                      0
                   END) ACCT_IPTV_NUM_CL,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G110' AND A.IS_NEW = '1' THEN
                      1
                     ELSE
                      0
                   END) IPTV_NEW,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW = 'G110' AND
                          TO_CHAR(A.INNET_DATE, 'YYYY') = '2018' THEN
                      1
                     ELSE
                      0
                   END) IPTV_NEW_YEAR,
               --专线电路
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                          A.IS_ONNET = '1' THEN
                      1
                     ELSE
                      0
                   END) ONNET_ZXDL_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                      1
                     ELSE
                      0
                   END) ACCT_ZXDL_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                          TO_CHAR(A.INNET_DATE, 'YYYYMM') <= '201712' THEN
                      1
                     ELSE
                      0
                   END) ACCT_ZXDL_NUM_CL,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND A.IS_NEW = '1' THEN
                      1
                     ELSE
                      0
                   END) ZXDL_NEW,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                          TO_CHAR(A.INNET_DATE, 'YYYY') = '2018' THEN
                      1
                     ELSE
                      0
                   END) ZXDL_NEW_YEAR,
               --固话
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                          A.IS_ONNET = '1' THEN
                      1
                     ELSE
                      0
                   END) ONNET_GH_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                      1
                     ELSE
                      0
                   END) ACCT_GH_NUM,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                          (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                          TO_CHAR(A.INNET_DATE, 'YYYYMM') <= '201712' THEN
                      1
                     ELSE
                      0
                   END) ACCT_GH_NUM_CL,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                          A.IS_NEW = '1' THEN
                      1
                     ELSE
                      0
                   END) GH_NEW,
               SUM(CASE
                     WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                          TO_CHAR(A.INNET_DATE, 'YYYY') = '2018' THEN
                      1
                     ELSE
                      0
                   END) GH_NEW_YEAR,
               SUM(A.QFCS_FEE) QFCS_FEE,
               SUM(A.XMFC_FEE) XMFC_FEE
          FROM DW.DW_V_USER_HUAXIAO_INFO_ALL A
         WHERE A.ACCT_MONTH = '201803'
           AND AREA_NO = '188' 
           AND A.IS_HUAXIAO_08 = '1'
         GROUP BY A.HUAXIAO_NO_08 )A,
       (SELECT *
          FROM DIM.DIM_HUAXIAO_INFO T
         WHERE T.AREA_NO = '188'
           AND T.HUAXIAO_TYPE = '08') T
 WHERE A.HUAXIAO_NO_08 = T.HUAXIAO_NO
group by T.AREA_NO,
       T.CITY_NO,
       T.HUAXIAO_TYPE,
       T.HUAXIAO_NO,
       T.HUAXIAO_NAME

--净增
select 
area_no, 
city_no, 
huaxiao_type, 
huaxiao_no, 
huaxiao_name, 
0 total_fee, 
0 total_fee_cl, 
0 onnet_cdma_num, 
0 acct_cdma_num, 
0 acct_cdma_num_cl, 
0 cdma_new, 
0 cdma_new_year, 
acct_cdma_num*(-1) jz_cdma_num, 
0 onnet_adsl_num, 
0 acct_adsl_num, 
0 acct_adsl_num_cl, 
0 adsl_new, 
0 adsl_new_year, 
onnet_adsl_num*(-1) jz_adsl_num, 
0 onnet_iptv_num, 
0 acct_iptv_num, 
0 acct_iptv_num_cl, 
0 iptv_new, 
0 iptv_new_year, 
onnet_iptv_num*(-1) jz_iptv_num, 
0 onnet_zxdl_num, 
0 acct_zxdl_num, 
0 acct_zxdl_num_cl, 
0 zxdl_new, 
0 zxdl_new_year, 
onnet_zxdl_num*(-1) jz_zxdl_num, 
0 onnet_gh_num, 
0 acct_gh_num, 
0 acct_gh_num_cl, 
0 gh_new, 
0 gh_new_year, 
onnet_gh_num*(-1) jz_gh_num, 
0 onnet_xx_num, 
0 acct_xx_num, 
0 acct_xx_num_cl, 
0 xx_new, 
0 xx_new_year, 
onnet_xx_num*(-1) jz_xx_num, 
0 qfcs_fee, 
0 xmfc_fee
 from 
DM_ZQ_HUAXIAO_INFO_M where acct_month=v_last_month
and area_no=c1.area_no       
       )         
