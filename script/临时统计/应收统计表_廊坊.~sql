SELECT B.DESCRIPTION, b.IDX_NO, A.*
  FROM (SELECT A.AREA_NO,
               C.AREA_DESCRIPTION,
               C.CITY_NO,
               C.DESCRIPTION CITY_NAME,
               A.MERGE_PRODUCT_OFFER_ID,
               NAME,
               SUM(KPI_VALUE) KPI_VALUE
          FROM (SELECT MERGE_PRODUCT_OFFER_ID,
                       NAME,
                       KPI_VALUE,
                       AREA_NO,
                       CITY_NO
                  FROM (SELECT C.MERGE_PRODUCT_OFFER_ID,
                               C.NAME,
                               A.KPI_VALUE,
                               A.AREA_NO,
                               CITY_NO
                          FROM (SELECT *
                                  FROM NEW_DM.DM_RPT_M_INCOME_SUM_AREA_2 T
                                 WHERE 1 = 1
                                   AND T.ACCT_MONTH = '201802'
                                      --AND T.CITY_NO=#CITY_NO#
                                   AND T.AREA_NO = 183
                                      --AND NVL(T.CUSTOMER_TYPE, '4') =#CUSTOMER_TYPE#
                                   AND T.ACCT_MONTH >= '200904') A,
                               NEW_DIM.DIM_PROD_OFFER_FIRST_LVL_PSTN C
                         WHERE A.OPER_TYPE = C.MERGE_PRODUCT_OFFER_ID
                        UNION ALL
                        SELECT C.MERGE_PRODUCT_OFFER_ID,
                               C.NAME,
                               D.KPI_VALUE,
                               D.AREA_NO,
                               CITY_NO
                          FROM (SELECT *
                                  FROM NEW_DM.DM_RPT_M_INCOME_SUM_AREA_1 T
                                 WHERE 1 = 1
                                   AND T.ACCT_MONTH = '201802'
                                      --AND T.CITY_NO =#CITY_NO#
                                   AND T.AREA_NO = 183
                                      --AND NVL(T.CUSTOMER_TYPE, '4')=#CUSTOMER_TYPE#
                                   AND T.ACCT_MONTH < '200904') D,
                               NEW_DIM.DIM_PROD_FIRST_LVL_PSTN_1 C
                         WHERE D.OPER_TYPE = C.MERGE_PRODUCT_OFFER_ID)) A,
               (SELECT * FROM NEW_DMCODE.DMCODE_CITY) C
        
         WHERE A.CITY_NO = C.CITY_NO
         GROUP BY A.AREA_NO,
                  C.CITY_NO,
                  C.DESCRIPTION,
                  C.AREA_DESCRIPTION,
                  A.MERGE_PRODUCT_OFFER_ID,
                  NAME) A,
       (SELECT * FROM NEW_DMCODE.DMCODE_AREA) B
 WHERE A.AREA_NO = B.AREA_NO
 ORDER BY B.IDX_NO
