select * from dim.dim_transfer_solution a where a.TRANS_NAME like '%卡槽%';

select * from dim.dim_sale_mode_new a where a.name like '%卡槽%' and city_code='188'


/*DECLARE
  V_MONTH VARCHAR2(100);
  V_DATE  VARCHAR2(100);
  V_DAY   VARCHAR2(100);
  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO ='188' ORDER BY IDX_NO;
BEGIN
  FOR V_NUM IN 1 .. 1 LOOP
    V_MONTH := TO_CHAR(SYSDATE - 1, 'YYYYMM');
    V_DATE  := TO_CHAR(SYSDATE - 1, 'YYYYMMDD');
    V_DAY   := TO_CHAR(SYSDATE - 1, 'DD'); 
    FOR C1 IN V_AREA LOOP
      --使用实例表
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_JF_WEIXI_ZZ_04';
      INSERT INTO MID_JF_WEIXI_ZZ_04
        SELECT A.USER_ID,
               A.BELONGS_AREA,
               d.PROMOTION_INST_ID,
               0 PAY_FEE,
               TO_CHAR(D.EFF_DATE, 'YYYYMMDD') EFF_DATE,
               TO_CHAR(D.EXP_DATE, 'YYYYMMDD') EXP_DATE
          FROM (SELECT *
                  FROM ACCT_DSG.BF_TRANSFER_ACCEPT_T@HBODS
                 WHERE CITY_CODE = C1.AREA_NO) A,
               (SELECT *
                  FROM CRM_DSG.SALES_PROMOTION_INST@HBODS
                 WHERE CITY_CODE = C1.AREA_NO
                   AND EFF_DATE >= TO_DATE('201701', 'YYYYMM')
                   AND PROMOTION_ID IN ('42818', '40508')) D
         WHERE A.PROMOTION_INST_ID = D.PROMOTION_INST_ID;
      COMMIT;
    END LOOP;
  END LOOP;
END;*/


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
    FOR C1 IN V_AREA LOOP
      EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_MAJH_DQ_RENT';
      INSERT /*+ APPEND */
      INTO TMP_MAJH_DQ_RENT NOLOGGING
        SELECT USER_NO,
               C1.AREA_NO,
               SALES_MODE,
               TO_CHAR(BEGIN_DATE, 'YYYYMMDD'),
               TO_CHAR(END_DATE, 'YYYYMMDD'),
               COST_PRICE,
               DEVICE_NO,
               USER_DINNER
          FROM (SELECT T.*,
                       ROW_NUMBER() OVER(PARTITION BY USER_NO ORDER BY BEGIN_DATE DESC) RN
                  FROM ODS.O_PRD_USER_DEVICE_RENT_D@HBODS T
                 WHERE T.ACCT_MONTH = V_MONTH
                   AND T.DAY_ID = V_DAY
                   AND AREA_NO = C1.AREA_NO
                   AND BEGIN_DATE > TO_DATE('20170101', 'YYYYMMDD') + 1
                   AND T.SALES_MODE IN ('1421351', '1412747'))
         WHERE RN = 1;
      COMMIT;
    END LOOP;
  END LOOP;
END;
