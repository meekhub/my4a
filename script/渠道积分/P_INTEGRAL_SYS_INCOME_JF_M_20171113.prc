CREATE OR REPLACE PROCEDURE P_INTEGRAL_SYS_INCOME_JF_M(V_MONTH   VARCHAR2,
                                                       V_RETCODE OUT VARCHAR2,
                                                       V_RETINFO OUT VARCHAR2) IS
  /*****************************************************************
  *名称 --%NAME: P_INTEGRAL_SYS_DEVLP_JF_M
  *功能描述 --%COMMENT:
  *执行周期 --%PERIOD: 月
  *参数 --%PARAM:V_MONTH  日期,格式YYYYMM
  *参数 --%PARAM:V_RETCODE  过程运行结束成功与否标志
  *参数 --%PARAM:V_RETCODE  过程运行结束成功与否描述
  *创建人 --%CREATOR: LIYA
  *创建时间 --%CREATED_TIME:20170710
  *备注 --%REMARK:
  *来源表 --%FROM:
  *目标表 --%TO:
  *修改记录 --%MODIFY:
  *******************************************************************/
  V_PKG      VARCHAR2(40);
  V_PROCNAME VARCHAR2(40);
  V_COUNT    NUMBER := 0;

  V_LAST_MONTH6 VARCHAR2(40);
  V_LAST_2      VARCHAR2(40);

  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO NOT IN ('018');

BEGIN
  V_PKG      := '渠道积分体系';
  V_PROCNAME := 'P_INTEGRAL_SYS_INCOME_JF_M';
  --V_LAST_5     := TO_CHAR(TO_DATE(V_MONTH, 'YYYYMMDD') - 10, 'YYYYMMDD');
  V_LAST_2      := TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH, 'YYYYMM'), -2),
                           'YYYYMM');
  V_LAST_MONTH6 := TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH, 'YYYYMM'), -6),
                           'YYYYMM');

  --日志部分
  ALLDM.P_ALLDM_INSERT_LOG(V_MONTH, V_PKG, V_PROCNAME, '12', SYSDATE);
  ---------------------------------------------------------------
  -- 数据部分

  SELECT COUNT(1)
    INTO V_COUNT
    FROM DW.DW_EXECUTE_LOG
   WHERE ACCT_MONTH = V_MONTH
     AND RESULT = 'SUCCESS'
     AND PROCNAME IN
         ('P_DW_V_USER_BASE_INFO_USER', 'P_DW_V_USER_PRODUCT_INFO');
  COMMIT;

  IF V_COUNT = 2 THEN
    /*EXECUTE IMMEDIATE 'ALTER TABLE ALLDM.INTEGRAL_SYS_INCOME_JF_DETAIL TRUNCATE PARTITION PART_' ||
    V_MONTH;*/
    DELETE FROM MID_INCOME_JF_ZZH WHERE ACCT_MONTH = V_LAST_MONTH6;
    COMMIT;
  
    FOR C1 IN V_AREA LOOP
      ---沉淀增值积分
    
      INSERT INTO MID_INCOME_JF_ZZH
        SELECT V_MONTH, A.*, B.SORE
          FROM (SELECT AREA_NO, USER_NO, USER_DINNER
                  FROM DW.DW_V_USER_PRODUCT_INFO
                 WHERE ACCT_MONTH = V_MONTH
                   AND AREA_NO = C1.AREA_NO
                      --AND USER_DINNER = '1418719'
                   AND TO_CHAR(BEGIN_DATE, 'YYYYMM') = V_LAST_2
                   AND STATUS_CD = '1000') A,
               DIM_DINNER_ZZH_SORE B
         WHERE A.USER_DINNER = B.DINNER_NO;
      COMMIT;
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_INCOME_JF_ZZH_HZ';
      INSERT INTO MID_INCOME_JF_ZZH_HZ
        SELECT A.AREA_NO, A.USER_NO, SUM(SORE)
          FROM MID_INCOME_JF_ZZH A,
               (SELECT DISTINCT USER_NO, USER_DINNER
                  FROM MID_INCOME_JF_ZZH
                 WHERE ACCT_MONTH < V_MONTH
                   AND ACCT_MONTH >= V_LAST_MONTH6
                   AND AREA_NO = C1.AREA_NO) B
         WHERE A.USER_NO = B.USER_NO(+)
           AND B.USER_NO IS NULL
         GROUP BY A.AREA_NO, A.USER_NO;
      COMMIT;
    
      ---移动单产品积分+融合业务积分
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_INTEGRAL_SYS_INCOME_JF';
      INSERT INTO MID_INTEGRAL_SYS_INCOME_JF
        SELECT ACCT_MONTH,
               AREA_NO,
               CITY_NO,
               TELE_TYPE,
               CHANNEL_NO,
               CHANNEL_TYPE,
               CHANNEL_KIND,
               USER_NO,
               DEVICE_NUMBER,
               IS_VALID,
               INNET_DATE,
               USER_DINNER,
               USER_DINNER_DESC,
               INNET_MONTH,
               BILLING_FLAG,
               MONTH_FEE,
               IS_KD_BUNDLE,
               SERVICE_START_DATE
          FROM DW.DW_V_USER_BASE_INFO_USER T
         WHERE ACCT_MONTH = V_MONTH
           AND AREA_NO = C1.AREA_NO
           AND IS_VALID = '1'
           AND TOTAL_FEE + TOTAL_FEE_OCS > 0
           AND CHANNEL_TYPE LIKE '11%';
      COMMIT;
    
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_INTEGRAL_SYS_INCOME_JF_1';
      INSERT INTO MID_INTEGRAL_SYS_INCOME_JF_1
        SELECT ACCT_MONTH,
               AREA_NO,
               CITY_NO,
               TELE_TYPE,
               CHANNEL_NO,
               CHANNEL_TYPE,
               CHANNEL_KIND,
               USER_NO,
               DEVICE_NUMBER,
               IS_VALID,
               INNET_DATE,
               USER_DINNER,
               USER_DINNER_DESC,
               INNET_MONTH,
               BILLING_FLAG,
               MONTH_FEE,
               IS_KD_BUNDLE
          FROM MID_INTEGRAL_SYS_INCOME_JF T
         WHERE (TELE_TYPE = '2' AND TO_NUMBER(INNET_MONTH) <= 13 AND
               (SERVICE_START_DATE <> INNET_DATE OR
               TO_CHAR(NVL(SERVICE_START_DATE, SYSDATE), 'YYYYMM') >
               V_MONTH) AND
               IS_KD_BUNDLE IN
               ('0', '01', '011', '02', '021', '04', '041', '06'))
            OR (TELE_TYPE IN ('4', '26') AND
               IS_KD_BUNDLE IN ('0', '03', '031', '05') AND
               TO_NUMBER(INNET_MONTH) <= 13)
            OR (TELE_TYPE = '72' AND IS_KD_BUNDLE in ('0', '03', '031') AND
               TO_NUMBER(INNET_MONTH) <= 13);
      COMMIT;
    
      INSERT INTO INTEGRAL_SYS_INCOME_JF_DETAIL
        SELECT ACCT_MONTH,
               AREA_NO,
               CITY_NO,
               TELE_TYPE,
               '' AGENT_ID,
               '' AGENT_NAME,
               T.CHANNEL_NO,
               USER_NO,
               DEVICE_NUMBER,
               T.USER_DINNER,
               CASE
                 WHEN TELE_TYPE = '2' AND A.LOW_VALUE * 0.1 > 1200 THEN
                  1200
                 WHEN TELE_TYPE = '2' AND A.LOW_VALUE * 0.1 <= 1200 THEN
                  A.LOW_VALUE * 0.1
                 WHEN TELE_TYPE in ('4', '26') THEN
                  60 * 0.1
                 WHEN TELE_TYPE = '72' THEN
                  11 * 0.1
               END,
               TO_NUMBER(INNET_MONTH) INNET_MONTH,
               CASE
                 WHEN TELE_TYPE = '2' AND IS_KD_BUNDLE = '0' THEN
                  '1'
                 WHEN TELE_TYPE = '2' AND IS_KD_BUNDLE <> '0' THEN
                  '2'
                 ELSE
                  '3'
               END
          FROM MID_INTEGRAL_SYS_INCOME_JF_1       T,
               RPT_HBTELE.SJZX_WH_DIM_USER_DINNER A
         WHERE T.USER_DINNER = A.USER_DINNER(+);
      COMMIT;
      ---插入增值积分
      INSERT INTO INTEGRAL_SYS_INCOME_JF_DETAIL
        SELECT ACCT_MONTH,
               A.AREA_NO,
               CITY_NO,
               TELE_TYPE,
               '' AGENT_ID,
               '' AGENT_NAME,
               T.CHANNEL_NO,
               A.USER_NO,
               DEVICE_NUMBER,
               T.USER_DINNER,
               A.SORE,
               TO_NUMBER(INNET_MONTH) INNET_MONTH,
               '4'
          FROM MID_INTEGRAL_SYS_INCOME_JF_1 T, MID_INCOME_JF_ZZH_HZ A
         WHERE T.USER_NO = A.USER_NO;
      COMMIT;
    
    END LOOP;
    DELETE FROM INTEGRAL_SYS_INCOME_JF_M WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
    INSERT INTO INTEGRAL_SYS_INCOME_JF_M
      SELECT v_month,
             B.AREA_NO,
             B.CITY_NO,
             CASE
               WHEN JF_TYPE = '1' THEN
                '移动单产品积分'
               WHEN JF_TYPE = '2' THEN
                '融合业务积分'
               WHEN JF_TYPE = '3' THEN
                '固网业务积分'
               WHEN JF_TYPE = '4' THEN
                '增值业务积分'
             END JF_TYPE,
             C.AGENT_ID,
             C.AGENT_NAME,
             B.CHANNEL_NO,
             CEIL(NVL(LOW_VALUE, 0))
        FROM (SELECT ACCT_MONTH,
                     AREA_NO,
                     CITY_NO,
                     JF_TYPE,
                     AGENT_ID,
                     AGENT_NAME,
                     CHANNEL_NO,
                     SUM(NVL(LOW_VALUE, 0)) LOW_VALUE
                FROM INTEGRAL_SYS_INCOME_JF_DETAIL
               WHERE ACCT_MONTH = v_month
                 and area_no <> '018'
               GROUP BY AREA_NO,
                        CITY_NO,
                        JF_TYPE,
                        AGENT_ID,
                        AGENT_NAME,
                        CHANNEL_NO,
                        ACCT_MONTH) A,
             (SELECT *
                FROM DIM.DIM_CHANNEL_NO
               WHERE CHANNEL_TYPE LIKE '11%'
                 AND VALID_STATUS = '1'
                 and area_no <> '018') B,
             (SELECT DISTINCT AGENT_ID, AGENT_NAME, CHANNEL_NO
                FROM RPT_HBTELE.DM_BUSI_CHANNEL_BUILD
               WHERE ACCT_MONTH = V_MONTH) C
       WHERE B.CHANNEL_NO = A.CHANNEL_NO(+)
         AND B.CHANNEL_NO = C.CHANNEL_NO(+)
         AND B.VALID_STATUS = '1';
    COMMIT;
    --更新日志
    V_RETCODE := 'SUCCESS';
    ALLDM.P_ALLDM_UPDATE_LOG(V_MONTH,
                             V_PKG,
                             V_PROCNAME,
                             '结束',
                             V_RETCODE,
                             SYSDATE);
    DBMS_OUTPUT.PUT_LINE(V_RETCODE);
    ------------------------------------- 数据部分结束 -------------------------
  ELSE
    V_RETCODE := 'WAIT';
    ALLDM.P_ALLDM_UPDATE_LOG(V_MONTH,
                             V_PKG,
                             V_PROCNAME,
                             '等待',
                             'WAIT',
                             SYSDATE);
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    V_RETCODE := 'FAIL';
    V_RETINFO := SQLERRM;
    ALLDM.P_ALLDM_UPDATE_LOG(V_MONTH,
                             V_PKG,
                             V_PROCNAME,
                             V_RETINFO,
                             V_RETCODE,
                             SYSDATE);
END;
/
