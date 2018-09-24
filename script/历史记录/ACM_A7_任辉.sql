DECLARE
  V_MONTH VARCHAR2(100);
  V_DATE  VARCHAR2(100);
  V_DAY   VARCHAR2(100);
  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018' ORDER BY IDX_NO;
BEGIN
  FOR V_NUM IN 1 .. 1 LOOP
    V_MONTH := TO_CHAR(SYSDATE - 1, 'YYYYMM');
    V_DATE  := TO_CHAR(SYSDATE - 1, 'YYYYMMDD');
    V_DAY   := TO_CHAR(SYSDATE - 1, 'DD');
    DELETE FROM TMP_MAJH_ACM_USER WHERE DAY_ID = V_DATE;
    COMMIT;
    FOR C1 IN V_AREA LOOP
      EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_MAJH_RENT';
      INSERT /*+ APPEND */
      INTO TMP_MAJH_RENT NOLOGGING
        SELECT 
               to_char(SALESINST_CREATE_DATE,'yyyymmdd'),
               USER_NO,
               C1.AREA_NO,
               SALES_MODE,
               TO_CHAR(BEGIN_DATE, 'YYYYMMDD'),
               DEVICE_NO,
               DEVICE_TYPE
          FROM (SELECT T.*,
                       ROW_NUMBER() OVER(PARTITION BY USER_NO ORDER BY BEGIN_DATE DESC) RN
                  FROM ODS.O_PRD_USER_DEVICE_RENT_D@HBODS T
                 WHERE T.ACCT_MONTH = V_MONTH
                   AND T.DAY_ID = V_DAY
                   AND AREA_NO = C1.AREA_NO
                   AND to_char(SALESINST_CREATE_DATE,'yyyymmdd') in ('20171231','20180101','20180102','20180103')
                   AND (END_DATE >= TO_DATE(V_DATE, 'YYYYMMDD') + 1 OR
                       END_DATE IS NULL))
         WHERE RN = 1;
      COMMIT;
/*    
      EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_MAJH_TERM';
      INSERT INTO TMP_MAJH_TERM
        SELECT USER_NO, TERMINAL_CODE, TERMINAL_MODEL
          FROM (SELECT USER_NO,
                       TERMINAL_CODE,
                       TERMINAL_MODEL,
                       ROW_NUMBER() OVER(PARTITION BY USER_NO ORDER BY REG_DATE DESC) RN
                  FROM DW.DW_V_USER_TERMINAL_DEVICE_D A
                 WHERE ACCT_MONTH = V_MONTH
                   AND DAY_ID = V_DAY
                   AND AREA_NO = C1.AREA_NO
                   AND UPPER(TERMINAL_CORP) = 'APPLE'
                   AND UPPER(TERMINAL_MODEL) IN ('ACM-A7', 'ACM-A7PLUS'))
         WHERE RN = 1;
      COMMIT;*/
    
      --促销政策中间表
      EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_MAJH_SALES_MODE'; --不替换
      INSERT INTO TMP_MAJH_SALES_MODE
        SELECT *
          FROM (SELECT X.KIND SALES_MODE,
                       X.NAME SALES_MODE_DESC,
                       X.FAVOUR_GROUP,
                       GROUP_NAME FAVOUR_GROUP_DESC,
                       Y.FAVOUR_TYPE,
                       ROW_NUMBER() OVER(PARTITION BY X.KIND ORDER BY ROWNUM) RN
                  FROM DIM.DIM_SALE_MODE_NEW@HBODS    X,
                       DIM.DIM_BUS_FAVOUR_GROUP@HBODS Y
                 WHERE X.CITY_CODE = C1.AREA_NO
                   AND X.CITY_CODE = Y.CITY_CODE(+)
                   AND X.FAVOUR_GROUP = Y.FAVOUR_GROUP(+))
         WHERE RN = 1;
      COMMIT;
      INSERT INTO TMP_MAJH_ACM_USER
        SELECT x.accetp_date,
               C1.AREA_DESC,
               X.BEGIN_DATE,
               A.INNET_DATE,
               A.DEVICE_NUMBER,
               A.USER_DINNER,
               A.USER_DINNER_DESC,
               C.FAVOUR_GROUP_DESC,
               C.SALES_MODE,
               C.SALES_MODE_DESC,
               D.RESOURCE_KIND_NAME,
               x.terminal_code
          FROM TMP_MAJH_RENT X,
               (SELECT USER_NO,
                       TO_CHAR(INNET_DATE, 'YYYYMMDD') INNET_DATE,
                       USER_DINNER,
                       USER_DINNER_DESC,
                       DEVICE_NUMBER,
                       SALES_MODE,
                       SALES_MODE_DESC
                  FROM DW.DW_V_USER_BASE_INFO_DAY
                 WHERE ACCT_MONTH = V_MONTH
                   AND DAY_ID = V_DAY
                   AND AREA_NO = C1.AREA_NO
                   AND TELE_TYPE = '2'
                   AND IS_ONNET = '1'
                   AND EXISTS (SELECT 1
                          FROM RPT_HBTELE.SJZX_WH_DIM_USER_DINNER
                         WHERE LOW_VALUE >= 59)) A, 
               TMP_MAJH_SALES_MODE C,
               (SELECT *
                  FROM (SELECT TRIM(RESOURCE_MANUFACTURER) RESOURCE_MANUFACTURER,
                               TRIM(RESOURCE_KIND_ID) RESOURCE_KIND_ID,
                               TRIM(RESOURCE_KIND_NO) RESOURCE_KIND_NO,
                               TRIM(RESOURCE_KIND_NAME) RESOURCE_KIND_NAME,
                               ROW_NUMBER() OVER(PARTITION BY RESOURCE_KIND_NO ORDER BY RESOURCE_KIND_ID DESC) RN
                          FROM DSG_STAGE.IR_GET_RESOURCE_KIND_T F
                          where f.RESOURCE_MANUFACTURER='苹果') F
                 WHERE RN = 1) D               
         WHERE X.USER_NO = A.USER_NO 
           AND X.SALES_MODE = C.SALES_MODE
           and x.resource_kind=d.RESOURCE_KIND_NO;
      COMMIT;
    END LOOP;
  END LOOP;
END;
