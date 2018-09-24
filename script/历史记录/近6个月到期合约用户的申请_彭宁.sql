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
          EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_MAJH_DQ_HZ';
    FOR C1 IN V_AREA LOOP
      EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_MAJH_DQ_RENT';
      INSERT /*+ APPEND */
      INTO TMP_MAJH_DQ_RENT NOLOGGING
        SELECT USER_NO,
               C1.AREA_NO,
               SALES_MODE,
               TO_CHAR(BEGIN_DATE, 'YYYYMMDD'),
               TO_CHAR(END_DATE, 'YYYYMMDD'),
               COST_PRICE
          FROM (SELECT T.*,
                       ROW_NUMBER() OVER(PARTITION BY USER_NO ORDER BY BEGIN_DATE DESC) RN
                  FROM ODS.O_PRD_USER_DEVICE_RENT_D@HBODS T
                 WHERE T.ACCT_MONTH = V_MONTH
                   AND T.DAY_ID = V_DAY
                   AND AREA_NO = C1.AREA_NO
                   AND END_DATE > TO_DATE('20171231', 'YYYYMMDD') + 1
                   AND END_DATE < TO_DATE('20180630', 'YYYYMMDD') + 1)
         WHERE RN = 1;
      COMMIT;
      /*    
      EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_MAJH_DQ_TERM';
      INSERT INTO TMP_MAJH_DQ_TERM
        SELECT USER_NO, TERMINAL_CODE, TERMINAL_MODEL, TERMINAL_CORP
          FROM (SELECT USER_NO,
                       TERMINAL_CODE,
                       TERMINAL_MODEL,
                       TERMINAL_CORP,
                       ROW_NUMBER() OVER(PARTITION BY USER_NO ORDER BY REG_DATE DESC) RN
                  FROM DW.DW_V_USER_TERMINAL_DEVICE_D A
                 WHERE ACCT_MONTH = V_MONTH
                   AND DAY_ID = V_DAY
                   AND AREA_NO = C1.AREA_NO)
         WHERE RN = 1;
      COMMIT;*/
    
      EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_MAJH_PRICE_INFO';
      INSERT INTO TMP_MAJH_PRICE_INFO
        SELECT MOBILE_NO, PHONE_NUMBER, SUGGEST_PRICE, RESOURCE_KIND
          FROM (SELECT MOBILE_NO,
                       PHONE_NUMBER,
                       SUGGEST_PRICE,
                       RESOURCE_KIND,
                       ROW_NUMBER() OVER(PARTITION BY PHONE_NUMBER ORDER BY OPERATE_DATE DESC) RN
                  FROM CRM_DSG.IR_MOBILE_USING_T@HBODS
                 WHERE CITY_CODE = C1.AREA_NO)
         WHERE RN = 1;
    
      INSERT INTO TMP_MAJH_DQ_HZ
        SELECT C1.AREA_DESC,
               A.DEVICE_NUMBER,
               D.RESOURCE_MANUFACTURER,
               D.RESOURCE_KIND_NAME,
               C.SUGGEST_PRICE/100,
               SUBSTR(X.END_DATE, 1, 6),
               A.USER_DINNER,
               A.USER_DINNER_DESC
          FROM TMP_MAJH_DQ_RENT X,
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
                   AND IS_ONNET = '1') A,
               (SELECT * FROM TMP_MAJH_PRICE_INFO WHERE SUGGEST_PRICE > 150000) C,
               (SELECT *
                  FROM (SELECT TRIM(RESOURCE_MANUFACTURER) RESOURCE_MANUFACTURER,
                               TRIM(RESOURCE_KIND_ID) RESOURCE_KIND_ID,
                               TRIM(RESOURCE_KIND_NO) RESOURCE_KIND_NO,
                               TRIM(RESOURCE_KIND_NAME) RESOURCE_KIND_NAME,
                               ROW_NUMBER() OVER(PARTITION BY RESOURCE_KIND_NO ORDER BY RESOURCE_KIND_ID DESC) RN
                          FROM DSG_STAGE.IR_GET_RESOURCE_KIND_T F) F
                 WHERE RN = 1) D
         WHERE X.USER_NO = A.USER_NO
           AND A.DEVICE_NUMBER = C.PHONE_NUMBER
           AND C.RESOURCE_KIND = D.RESOURCE_KIND_NO;
      COMMIT;
    END LOOP;
  END LOOP;
END;



--导出
SELECT AREA_DESC        地市,
       DEVICE_NUMBER    业务号码,
       TERMINAL_CORP    终端品牌,
       TERMINAL_MODEL   终端机型,
       COST_PRICE       零售价,
       END_DATE         合约到期月份,
       USER_DINNER      套餐ID,
       USER_DINNER_DESC 套餐名称
  FROM TMP_MAJH_DQ_HZ T
