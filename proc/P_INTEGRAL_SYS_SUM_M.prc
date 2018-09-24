CREATE OR REPLACE PROCEDURE P_INTEGRAL_SYS_DEVLP_JF_D(V_DATE    VARCHAR2,
                                                      V_RETCODE OUT VARCHAR2,
                                                      V_RETINFO OUT VARCHAR2) IS
  /*****************************************************************
  *名称 --%NAME: P_INTEGRAL_SYS_DEVLP_JF_D
  *功能描述 --%COMMENT:
  *执行周期 --%PERIOD: 日
  *参数 --%PARAM:V_DATE  日期,格式YYYYMMDD
  *参数 --%PARAM:V_RETCODE  过程运行结束成功与否标志
  *参数 --%PARAM:V_RETCODE  过程运行结束成功与否描述
  *创建人 --%CREATOR: LIYA
  *创建时间 --%CREATED_TIME:20170710
  *备注 --%REMARK:
  *来源表 --%FROM:
  *目标表 --%TO:
  *修改记录 --%MODIFY:
  *******************************************************************/
  V_PKG        VARCHAR2(40);
  V_PROCNAME   VARCHAR2(40);
  V_COUNT      NUMBER := 0;
  V_MONTH      VARCHAR2(40);
  V_LAST_MONTH VARCHAR2(40);
  V_DAY        VARCHAR2(40);
  --V_LAST_5     VARCHAR2(40);

  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO NOT IN ('018');

BEGIN
  V_PKG      := '渠道积分体系';
  V_PROCNAME := 'P_INTEGRAL_SYS_DEVLP_JF_D';
  V_MONTH    := SUBSTR(V_DATE, 1, 6);
  V_DAY      := SUBSTR(V_DATE, 7, 2);
  --V_LAST_5     := TO_CHAR(TO_DATE(V_DATE, 'YYYYMMDD') - 10, 'YYYYMMDD');
  V_LAST_MONTH := TO_CHAR(ADD_MONTHS(TO_DATE(V_DATE, 'YYYYMMDD'), -1),
                          'YYYYMM');

  --日志部分
  ALLDM.P_ALLDM_INSERT_LOG(V_DATE, V_PKG, V_PROCNAME, '12', SYSDATE);
  ---------------------------------------------------------------
  -- 数据部分

  SELECT COUNT(1)
    INTO V_COUNT
    FROM DW.DW_EXECUTE_LOG
   WHERE ACCT_MONTH = V_DATE
     AND RESULT = 'SUCCESS'
     AND PROCNAME IN ('P_DW_V_USER_BASE_INFO_DAY');
  COMMIT;

  IF V_COUNT = 1 THEN
    EXECUTE IMMEDIATE 'ALTER TABLE ALLDM.INTEGRAL_SYS_DEVLP_JF_DETAIL TRUNCATE PARTITION PART_' ||
                      V_DATE;
  
    FOR C1 IN V_AREA LOOP
      ---移动单产品积分+融合业务积分
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_INTEGRAL_SYS_DEVLP_JF';
      INSERT INTO MID_INTEGRAL_SYS_DEVLP_JF
        SELECT ACCT_MONTH,
               DAY_ID,
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
               MONTH_FEE,
               BILLING_FLAG,
               IS_KD_BUNDLE
          FROM DW.DW_V_USER_BASE_INFO_DAY T
         WHERE ACCT_MONTH = V_MONTH
           AND DAY_ID = V_DAY
           AND AREA_NO = C1.AREA_NO
           AND CHANNEL_TYPE LIKE '11%'
           AND IS_VALID = '1'
           AND TO_CHAR(INNET_DATE, 'YYYYMMDD') = V_DATE
           AND ((TELE_TYPE = '2' AND
               IS_KD_BUNDLE IN
               ('0', '01', '011', '02', '021', '04', '041', '06')) OR
               (TELE_TYPE IN ('4', '26') AND
               IS_KD_BUNDLE IN ('0', '03', '031', '05')) OR
               (TELE_TYPE = '72' AND IS_KD_BUNDLE = '0'));
      COMMIT;
    
      INSERT INTO INTEGRAL_SYS_DEVLP_JF_DETAIL
        SELECT ACCT_MONTH || DAY_ID DAY_ID,
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
                 WHEN A.LOW_VALUE > 1000 THEN
                  1000
                 ELSE
                  A.LOW_VALUE
               END,
               CASE
                 WHEN IS_KD_BUNDLE = '0' THEN
                  '1'
                 ELSE
                  '2'
               END
          FROM MID_INTEGRAL_SYS_DEVLP_JF          T,
               RPT_HBTELE.SJZX_WH_DIM_USER_DINNER A
         WHERE T.USER_DINNER = A.USER_DINNER(+)
           AND TELE_TYPE = '2';
      COMMIT;
    
      INSERT INTO INTEGRAL_SYS_DEVLP_JF_DETAIL
        SELECT ACCT_MONTH || DAY_ID DAY_ID,
               AREA_NO,
               CITY_NO,
               TELE_TYPE,
               AGENT_ID,
               AGENT_NAME,
               T.CHANNEL_NO,
               USER_NO,
               DEVICE_NUMBER,
               T.USER_DINNER,
               CASE
                 WHEN T.BILLING_FLAG = '3' AND
                      TO_NUMBER(MONTH_FEE) * 12 * 0.1 > 1200 THEN
                  1200
                 WHEN T.BILLING_FLAG = '3' AND
                      TO_NUMBER(MONTH_FEE) * 12 * 0.1 < 1200 THEN
                  TO_NUMBER(MONTH_FEE) * 12 * 0.1
                 WHEN TO_NUMBER(MONTH_FEE) < 1200 THEN
                  TO_NUMBER(MONTH_FEE)
                 ELSE
                  1200
               END,
               '3'
          FROM MID_INTEGRAL_SYS_DEVLP_JF T,
               (SELECT DISTINCT AGENT_ID, AGENT_NAME, CHANNEL_NO
                  FROM RPT_HBTELE.DM_BUSI_CHANNEL_BUILD
                 WHERE ACCT_MONTH = V_LAST_MONTH
                   AND AREA_NO = C1.AREA_NO) B
         WHERE T.CHANNEL_NO = B.CHANNEL_NO(+)
           AND TELE_TYPE IN ('4', '26', '72')
           AND MONTH_FEE IS NOT NULL;
      COMMIT;
    
    END LOOP;
    DELETE FROM INTEGRAL_SYS_DEVLP_JF_D WHERE DAY_ID = V_DATE;
    COMMIT;
  
    IF SUBSTR(V_DATE, 7, 2) <> '01' THEN
      INSERT INTO INTEGRAL_SYS_DEVLP_JF_D
        SELECT V_DATE,
               B.AREA_NO,
               B.CITY_NO,
               CASE
                 WHEN JF_TYPE = '1' THEN
                  '移动单产品积分'
                 WHEN JF_TYPE = '2' THEN
                  '融合业务积分'
                 WHEN JF_TYPE = '3' THEN
                  '固网业务积分'
               END JF_TYPE,
               --'' jf_type,
               C.AGENT_ID,
               C.AGENT_NAME,
               B.CHANNEL_NO,
               ceil(SUM(NVL(LOW_VALUE, 0))),
               ceil(SUM(NVL(VALUE_MON, 0))),
               NVL(C.CHANNEL_PROP_NO, '01'),
               NVL(C.CHANNEL_PROP_NAME, '商圈'),
               NVL(C.REGION_PROP_NO, '07'),
               NVL(C.REGION_PROP_NAME, '其他')
          FROM (SELECT AREA_NO,
                       CITY_NO,
                       AGENT_ID,
                       AGENT_NAME,
                       CHANNEL_NO,
                       JF_TYPE,
                       SUM(NVL(LOW_VALUE, 0)) LOW_VALUE,
                       SUM(NVL(LOW_VALUE, 0)) VALUE_MON
                  FROM INTEGRAL_SYS_DEVLP_JF_DETAIL A
                 WHERE DAY_ID = V_DATE
                 GROUP BY AREA_NO,
                          CITY_NO,
                          JF_TYPE,
                          AGENT_ID,
                          AGENT_NAME,
                          CHANNEL_NO
                UNION ALL
                SELECT AREA_NO,
                       CITY_NO,
                       AGENT_ID,
                       AGENT_NAME,
                       CHANNEL_NO,
                       TELE_TYPE,
                       0,
                       VALUE_MON
                  FROM INTEGRAL_SYS_DEVLP_JF_D
                 WHERE DAY_ID =
                       TO_CHAR(TO_DATE(V_DATE, 'YYYYMMDD') - 1, 'YYYYMMDD')) A,                    
               (SELECT *
                  FROM DIM.DIM_CHANNEL_NO
                 WHERE CHANNEL_TYPE LIKE '11%' and valid_status='1') B,
               (SELECT DISTINCT AGENT_ID,
                                AGENT_NAME,
                                CHANNEL_NO,
                                CASE
                                  WHEN BUSINESS_ZONE = '10' THEN
                                   '02'
                                  WHEN BUSINESS_ZONE_NAME LIKE '%商圈%' THEN
                                   '01'
                                  ELSE
                                   '03'
                                END CHANNEL_PROP_NO,
                                CASE
                                  WHEN BUSINESS_ZONE = '10' THEN
                                   '社区'
                                  WHEN BUSINESS_ZONE_NAME LIKE '%商圈%' THEN
                                   '商圈'
                                  ELSE
                                   '农村'
                                END CHANNEL_PROP_NAME,
                                
                                CASE
                                  WHEN T.CHANNEL_TYPE IN ('110101', '110102', '110103') THEN
                                   '01'
                                  WHEN T.CHANNEL_TYPE IN ('110201') THEN
                                   '02'
                                  WHEN T.CHANNEL_TYPE IN ('110301') THEN
                                   '03'
                                  WHEN T.CHANNEL_TYPE IN ('110302') THEN
                                   '04'
                                  WHEN (T.CHANNEL_TYPE NOT IN
                                       ('110101', '110102', '110103', '110201', '110301', '110302') OR
                                       T.CHANNEL_TYPE IS NULL) AND T.PROTOP10 IN ('1', '2') THEN
                                   '05'
                                  WHEN (T.CHANNEL_TYPE NOT IN
                                       ('110101', '110102', '110103', '110201', '110301', '110302') OR
                                       T.CHANNEL_TYPE IS NULL) AND
                                       (T.PROTOP10 NOT IN ('1', '2') OR T.PROTOP10 IS NULL) THEN
                                   '06'
                                  ELSE
                                   '07'
                                END REGION_PROP_NO,
                                CASE
                                  WHEN T.CHANNEL_TYPE IN ('110101', '110102', '110103') THEN
                                   '自营厅'
                                  WHEN T.CHANNEL_TYPE IN ('110201') THEN
                                   '专营店'
                                  WHEN T.CHANNEL_TYPE IN ('110301') THEN
                                   '国家连锁'
                                  WHEN T.CHANNEL_TYPE IN ('110302') THEN
                                   '省级连锁'
                                  WHEN (T.CHANNEL_TYPE NOT IN
                                       ('110101', '110102', '110103', '110201', '110301', '110302') OR
                                       T.CHANNEL_TYPE IS NULL) AND T.PROTOP10 IN ('1', '2') THEN
                                   '省市TOP'
                                  WHEN (T.CHANNEL_TYPE NOT IN
                                       ('110101', '110102', '110103', '110201', '110301', '110302') OR
                                       T.CHANNEL_TYPE IS NULL) AND
                                       (T.PROTOP10 NOT IN ('1', '2') OR T.PROTOP10 IS NULL) THEN
                                   '中小混营'
                                  ELSE
                                   '其他'
                                END REGION_PROP_NAME
                  FROM RPT_HBTELE.DM_BUSI_CHANNEL_BUILD T
                 WHERE ACCT_MONTH = V_LAST_MONTH) C
         WHERE B.CHANNEL_NO = A.CHANNEL_NO(+)
           AND B.CHANNEL_NO = C.CHANNEL_NO(+)
           AND B.VALID_STATUS = '1'
         GROUP BY B.AREA_NO,
                  B.CITY_NO,
                  C.AGENT_ID,
                  JF_TYPE,
                  C.AGENT_NAME,
                  B.CHANNEL_NO,
                  NVL(C.CHANNEL_PROP_NO, '01'),
                  NVL(C.CHANNEL_PROP_NAME, '商圈'),
                  NVL(C.REGION_PROP_NO, '07'),
                  NVL(C.REGION_PROP_NAME, '其他');
      COMMIT;
    
    ELSE
      INSERT INTO INTEGRAL_SYS_DEVLP_JF_D
        SELECT V_DATE,
               B.AREA_NO,
               B.CITY_NO,
               CASE
                 WHEN JF_TYPE = '1' THEN
                  '移动单产品积分'
                 WHEN JF_TYPE = '2' THEN
                  '融合业务积分'
                 WHEN JF_TYPE = '3' THEN
                  '固网业务积分'
               END JF_TYPE,
               --'' jf_type,
               C.AGENT_ID,
               C.AGENT_NAME,
               B.CHANNEL_NO,
               ceil(SUM(LOW_VALUE)) LOW_VALUE,
               ceil(SUM(LOW_VALUE)) VALUE_MON,
               NVL(C.CHANNEL_PROP_NO, '01'),
               NVL(C.CHANNEL_PROP_NAME, '商圈'),
               NVL(C.REGION_PROP_NO, '07'),
               NVL(C.REGION_PROP_NAME, '其他')
          FROM (SELECT *
                  FROM INTEGRAL_SYS_DEVLP_JF_DETAIL
                 WHERE DAY_ID = V_DATE) A,
               (SELECT *
                  FROM DIM.DIM_CHANNEL_NO
                 WHERE CHANNEL_TYPE LIKE '11%' and valid_status='1') B,
               (SELECT DISTINCT AGENT_ID,
                                AGENT_NAME,
                                CHANNEL_NO,
                                CASE
                                  WHEN BUSINESS_ZONE = '10' THEN
                                   '02'
                                  WHEN BUSINESS_ZONE_NAME LIKE '%商圈%' THEN
                                   '01'
                                  ELSE
                                   '03'
                                END CHANNEL_PROP_NO,
                                CASE
                                  WHEN BUSINESS_ZONE = '10' THEN
                                   '社区'
                                  WHEN BUSINESS_ZONE_NAME LIKE '%商圈%' THEN
                                   '商圈'
                                  ELSE
                                   '农村'
                                END CHANNEL_PROP_NAME,
                                
                                CASE
                                  WHEN T.CHANNEL_TYPE IN
                                       ('110101', '110102', '110103') THEN
                                   '01'
                                  WHEN T.CHANNEL_TYPE IN ('110201') THEN
                                   '02'
                                  WHEN T.CHANNEL_TYPE IN ('110301') THEN
                                   '03'
                                  WHEN T.CHANNEL_TYPE IN ('110302') THEN
                                   '04'
                                  WHEN (T.CHANNEL_TYPE NOT IN
                                       ('110101',
                                         '110102',
                                         '110103',
                                         '110201',
                                         '110301',
                                         '110302') OR T.CHANNEL_TYPE IS NULL) AND
                                       T.PROTOP10 IN ('1', '2') THEN
                                   '05'
                                  WHEN (T.CHANNEL_TYPE NOT IN
                                       ('110101',
                                         '110102',
                                         '110103',
                                         '110201',
                                         '110301',
                                         '110302') OR T.CHANNEL_TYPE IS NULL) AND
                                       (T.PROTOP10 NOT IN ('1', '2') OR
                                       T.PROTOP10 IS NULL) THEN
                                   '06'
                                  ELSE
                                   '07'
                                END REGION_PROP_NO,
                                CASE
                                  WHEN T.CHANNEL_TYPE IN
                                       ('110101', '110102', '110103') THEN
                                   '自营厅'
                                  WHEN T.CHANNEL_TYPE IN ('110201') THEN
                                   '专营店'
                                  WHEN T.CHANNEL_TYPE IN ('110301') THEN
                                   '国家连锁'
                                  WHEN T.CHANNEL_TYPE IN ('110302') THEN
                                   '省级连锁'
                                  WHEN (T.CHANNEL_TYPE NOT IN
                                       ('110101',
                                         '110102',
                                         '110103',
                                         '110201',
                                         '110301',
                                         '110302') OR T.CHANNEL_TYPE IS NULL) AND
                                       T.PROTOP10 IN ('1', '2') THEN
                                   '省市TOP'
                                  WHEN (T.CHANNEL_TYPE NOT IN
                                       ('110101',
                                         '110102',
                                         '110103',
                                         '110201',
                                         '110301',
                                         '110302') OR T.CHANNEL_TYPE IS NULL) AND
                                       (T.PROTOP10 NOT IN ('1', '2') OR
                                       T.PROTOP10 IS NULL) THEN
                                   '中小混营'
                                  ELSE
                                   '其他'
                                END REGION_PROP_NAME
                  FROM RPT_HBTELE.DM_BUSI_CHANNEL_BUILD T
                 WHERE ACCT_MONTH = V_LAST_MONTH) C
         WHERE B.CHANNEL_NO = A.CHANNEL_NO(+)
           AND B.CHANNEL_NO = C.CHANNEL_NO
           AND B.VALID_STATUS = '1'
         GROUP BY B.AREA_NO,
                  B.CITY_NO,
                  C.AGENT_ID,
                  C.AGENT_NAME,
                  B.CHANNEL_NO,
                  JF_TYPE,
                  NVL(C.CHANNEL_PROP_NO, '01'),
                  NVL(C.CHANNEL_PROP_NAME, '商圈'),
                  NVL(C.REGION_PROP_NO, '07'),
                  NVL(C.REGION_PROP_NAME, '其他');
      COMMIT;
    END IF;
  
    --更新日志
    V_RETCODE := 'SUCCESS';
    ALLDM.P_ALLDM_UPDATE_LOG(V_DATE,
                             V_PKG,
                             V_PROCNAME,
                             '结束',
                             V_RETCODE,
                             SYSDATE);
    DBMS_OUTPUT.PUT_LINE(V_RETCODE);
    ------------------------------------- 数据部分结束 -------------------------
  ELSE
    V_RETCODE := 'WAIT';
    ALLDM.P_ALLDM_UPDATE_LOG(V_DATE,
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
    ALLDM.P_ALLDM_UPDATE_LOG(V_DATE,
                             V_PKG,
                             V_PROCNAME,
                             V_RETINFO,
                             V_RETCODE,
                             SYSDATE);
END;
/
