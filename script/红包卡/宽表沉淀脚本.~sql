DECLARE
  V_MONTH VARCHAR2(100);
  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018' ORDER BY IDX_NO;
BEGIN
  FOR V_NUM IN 201806 .. 201806 LOOP
    V_MONTH := TO_CHAR(V_NUM);
    EXECUTE IMMEDIATE 'ALTER TABLE ALLDM.YZF_REDBAG_USER_INFO_M TRUNCATE PARTITION PART_' ||
    V_MONTH;
    FOR C1 IN V_AREA LOOP
      INSERT INTO YZF_REDBAG_USER_INFO_M
        SELECT
              v_month,
               b.user_no,
               A.MSISDN AS DEVICE_NUMBER,
               C1.AREA_NO,
               B.CITY_NO,
               B.IS_ONNET,
               B.IS_LOGOUT,
               B.INNET_DATE,
               B.LOGOUT_DATE,
               (B.TOTAL_FEE+B.TOTAL_FEE_OCS) AS TOTAL_FEE,
               b.owe_fee,
               B.INNET_MONTH AS INNET_MONTH_USER,
               MONTHS_BETWEEN(TO_DATE(V_MONTH, 'YYYYMM'),
                              TO_DATE(A.MIX_DATE_ID, 'YYYYMM')) AS INNET_MONTH_REDBAG,
               B.USER_DINNER,
               B.CHANNEL_NO,
               B.SALES_MODE,
               B.TRANS_ID,
               A.CARRIER_NAME,
               A.JT_PROV_CODE,
               A.JT_CITY_CODE,
               A.IS_REDBAG,
               NVL(C.VALUE,D.VALUE)*100 GEBATE_AMT,
               A.REBATE_AMT,
               A.IS_REDBAG_USER_AMT, 
               A.REDBAG_USER_AMT,
               A.MIX_DATE_ID,
               A.IS_ACTIVE,
               A.CNSM_AMT,
               A.CNSM_CNT,
               A.USER_REBATE_AMT,
               A.USER_MINUS_AMT,
               A.USER_VOU_AMT,
               A.USER_ORD_REBATE_AMT,
               A.USER_ORD_MINUS_AMT,
               A.USER_ORD_VOU_AMT,
               A.USER_REBATE_CNT,
               A.USER_MINUS_CNT,
               A.USER_VOU_CNT,
               A.CMNCTN_CNSM_AMT,
               A.CMNCTN_CNSM_CNT,
               '' USER_OFFLINE_CNSM_AMT,
               '' USER_OFFLINE_CNSM_CNT,
               A.ECM_CNSM_AMT,
               A.ECM_CNSM_CNT,
               A.PACCT_CNSM_AMT,
               A.PACCT_CNSM_ORD_CNT,
               A.PACCT_TRNSCT_AMT,
               A.PACCT_TRNSCT_ORD_CNT,
               A.PACCT_TTL_AMT,
               A.PACCT_TTL_ORD_CNT,
               A.FINANC_AMT,
               A.FINANC_ORD_AMT,
               A.EPAY_AMT,
               A.EPAY_ORD_CNT,
               '' ETL_TIME
          FROM (SELECT *
                  FROM STAGE.BWT_DOWN_YZF_YPAY_REDBAG_M@hbods
                 WHERE ACCT_MONTH = V_MONTH
                   AND JT_CITY_CODE = ALLDM.FUNC_GET_AREA_NO(C1.AREA_NO)) A,
               (SELECT *
                  FROM (SELECT USER_NO,CITY_NO,AREA_NO,
                               DEVICE_NUMBER,
                               INNET_MONTH, 
                               IS_ONNET,
                               TOTAL_FEE,
                               INNET_DATE,
                               TOTAL_FEE_OCS,
                               owe_fee,
                               IS_LOGOUT,USER_DINNER,CHANNEL_NO,SALES_MODE,TRANS_ID,logout_date,
                               ROW_NUMBER() OVER(PARTITION BY DEVICE_NUMBER ORDER BY INNET_DATE DESC) RN
                          FROM DW.DW_V_USER_BASE_INFO_USER
                         WHERE ACCT_MONTH = V_MONTH
                           AND AREA_NO = C1.AREA_NO
                           AND TELE_TYPE = '2')
                 WHERE RN = 1) B,
                 dim.dim_redbag_dinner c,
                 dim.dim_redbag_dinner d
         WHERE A.MSISDN = B.DEVICE_NUMBER(+)
         and b.SALES_MODE=c.kind(+)
         and b.trans_id = d.kind(+);
      COMMIT;
    END LOOP;
  END LOOP;
END;
