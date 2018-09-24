CREATE OR REPLACE PROCEDURE P_INTEGRAL_SYS_DEVLP_JF_M(V_MONTH   VARCHAR2,
                                                      V_RETCODE OUT VARCHAR2,
                                                      V_RETINFO OUT VARCHAR2) IS
  /*****************************************************************
  *名称 --%NAME: P_INTEGRAL_SYS_DEVLP_JF_D
  *功能描述 --%COMMENT:
  *执行周期 --%PERIOD: 日
  *参数 --%PARAM:V_MONTH  日期,格式YYYYMMDD
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
  --V_MONTH      VARCHAR2(40);
  V_LAST_MONTH VARCHAR2(40);
  --V_DAY        VARCHAR2(40);
  --V_LAST_5     VARCHAR2(40);

  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO NOT IN ('018');

BEGIN
  V_PKG      := '渠道积分体系';
  V_PROCNAME := 'P_INTEGRAL_SYS_DEVLP_JF_M';
  --V_MONTH    := SUBSTR(V_MONTH, 1, 6);
  --V_DAY      := SUBSTR(V_MONTH, 7, 2);
  --V_LAST_5     := TO_CHAR(TO_DATE(V_MONTH, 'YYYYMMDD') - 10, 'YYYYMMDD');
  V_LAST_MONTH := TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH, 'YYYYMM'), -1),
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
     AND PROCNAME IN ('P_DW_V_USER_BASE_INFO_USER');
  COMMIT;

  IF V_COUNT = 1 THEN
    EXECUTE IMMEDIATE 'ALTER TABLE ALLDM.INTEGRAL_SYS_DEVLP_JF_DETAIL_M TRUNCATE PARTITION PART_' ||
                      V_MONTH;
  
    FOR C1 IN V_AREA LOOP
      ---移动单产品积分+融合业务积分
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_INTEGRAL_SYS_DEVLP_JF_M';
      INSERT INTO MID_INTEGRAL_SYS_DEVLP_JF_M
        SELECT ACCT_MONTH,
               '' DAY_ID,
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
          FROM DW.DW_V_USER_BASE_INFO_USER T
         WHERE ACCT_MONTH = V_MONTH
           AND AREA_NO = C1.AREA_NO
           AND CHANNEL_TYPE LIKE '11%'
           AND IS_NEW = '1' --修改
              /*AND IS_VALID = '1'
              AND TO_CHAR(INNET_DATE, 'YYYYMM') = V_MONTH*/
           AND (TELE_TYPE = '2' OR
               (TELE_TYPE IN ('4', '26') AND
               INNET_METHOD IN ('1', '2', '4', '5', '15')) OR
               TELE_TYPE = '72');
      COMMIT;
    
      /*INSERT INTO INTEGRAL_SYS_DEVLP_JF_DETAIL
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
      COMMIT;*/
    
      ------单C积分
      INSERT INTO INTEGRAL_SYS_DEVLP_JF_DETAIL_M
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
                 WHEN T.USER_DINNER_DESC LIKE '%加装%' THEN ---副卡积10分
                  10
                 WHEN A.LOW_VALUE > 1000 THEN
                  1000
                 WHEN C.USER_DINNER IS NOT NULL THEN
                  C.LOW_VALUE * 30 + C.MON_VALUE
                 ELSE
                  A.LOW_VALUE
               END,
               '1'
          FROM MID_INTEGRAL_SYS_DEVLP_JF_M        T,
               RPT_HBTELE.SJZX_WH_DIM_USER_DINNER A,
               DIM.DIM_DAY_DINNER                 C
         WHERE T.USER_DINNER = A.USER_DINNER(+)
           AND T.USER_DINNER = C.USER_DINNER(+)
           AND TELE_TYPE = '2'
           AND T.IS_KD_BUNDLE = '0';
      COMMIT;
    
      ---融合（有手机的）--手机
      INSERT INTO INTEGRAL_SYS_DEVLP_JF_DETAIL_M
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
                 WHEN T.USER_DINNER_DESC LIKE '%加装%' THEN ---副卡积10分
                  10
                 WHEN A.LOW_VALUE > 1000 THEN
                  1000
                 ELSE
                  A.LOW_VALUE
               END,
               '2'
          FROM MID_INTEGRAL_SYS_DEVLP_JF_M        T,
               RPT_HBTELE.SJZX_WH_DIM_USER_DINNER A
         WHERE T.USER_DINNER = A.USER_DINNER(+)
           AND TELE_TYPE = '2'
           AND T.IS_KD_BUNDLE <> '0';
      COMMIT;
      --宽带 ITV
      INSERT INTO INTEGRAL_SYS_DEVLP_JF_DETAIL_M
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
                 WHEN TELE_TYPE = '72' THEN
                  10
                 ELSE
                  20
               END,
               '2'
          FROM MID_INTEGRAL_SYS_DEVLP_JF_M        T,
               RPT_HBTELE.SJZX_WH_DIM_USER_DINNER A
         WHERE T.USER_DINNER = A.USER_DINNER(+)
           AND TELE_TYPE <> '2'
           AND T.IS_KD_BUNDLE IN ('01', '011', '02', '021', '04', '041');
      COMMIT;
      --单固
      INSERT INTO INTEGRAL_SYS_DEVLP_JF_DETAIL_M
        SELECT ACCT_MONTH,
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
                 WHEN TELE_TYPE = '72' THEN
                  10
                 ELSE
                  60
               END,
               '3'
          FROM MID_INTEGRAL_SYS_DEVLP_JF_M T,
               (SELECT DISTINCT AGENT_ID, AGENT_NAME, CHANNEL_NO
                  FROM RPT_HBTELE.DM_BUSI_CHANNEL_BUILD
                 WHERE ACCT_MONTH = V_MONTH
                   AND AREA_NO = C1.AREA_NO) B
         WHERE T.CHANNEL_NO = B.CHANNEL_NO(+)
           AND TELE_TYPE IN ('4', '26', '72')
           AND T.IS_KD_BUNDLE IN ('0', '03', '031', '05', '051');
      COMMIT;
    
      ---奖励积分
      INSERT INTO INTEGRAL_SYS_DEVLP_JF_DETAIL_M
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
                 WHEN A.USER_DINNER_DESC LIKE '%不限量%' AND A.LOW_VALUE = 299 THEN
                  60
                 WHEN A.USER_DINNER_DESC LIKE '%不限量%' AND A.LOW_VALUE = 199 THEN
                  50
                 WHEN A.USER_DINNER_DESC LIKE '%不限量%' AND A.LOW_VALUE = 129 THEN
                  30
                 WHEN A.USER_DINNER_DESC LIKE '%不限量%' AND A.LOW_VALUE = 109 THEN
                  30
                 WHEN A.USER_DINNER_DESC LIKE '%农村大流量%' AND A.LOW_VALUE = 69 THEN
                  20
                 WHEN A.USER_DINNER_DESC LIKE '%简单卡%' AND A.LOW_VALUE = 50 THEN
                  20
                 WHEN A.USER_DINNER_DESC LIKE '%简单卡%' AND A.LOW_VALUE = 30 THEN
                  10
                 WHEN A.USER_DINNER_DESC LIKE '%美乡卡%' AND A.LOW_VALUE = 6 THEN
                  4
                 WHEN A.USER_DINNER_DESC LIKE '%阿福卡%' AND A.LOW_VALUE = 0 THEN
                  10
                 ELSE
                  0
               END,
               '4'
          FROM MID_INTEGRAL_SYS_DEVLP_JF_M        T,
               RPT_HBTELE.SJZX_WH_DIM_USER_DINNER A
         WHERE T.USER_DINNER = A.USER_DINNER
           AND TELE_TYPE = '2';
      COMMIT;
    
    END LOOP;
    DELETE FROM INTEGRAL_SYS_DEVLP_JF_M WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
  
    INSERT INTO INTEGRAL_SYS_DEVLP_JF_M
      SELECT V_MONTH,
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
                '发展奖励积分'
             END JF_TYPE,
             --'' JF_TYPE,
             C.AGENT_ID,
             C.AGENT_NAME,
             B.CHANNEL_NO,
             CEIL(SUM(LOW_VALUE)) LOW_VALUE,
             CEIL(SUM(LOW_VALUE)) VALUE_MON,
             NVL(C.CHANNEL_PROP_NO, '01'),
             NVL(C.CHANNEL_PROP_NAME, '商圈'),
             NVL(C.REGION_PROP_NO, '07'),
             NVL(C.REGION_PROP_NAME, '其他')
        FROM (SELECT *
                FROM INTEGRAL_SYS_DEVLP_JF_DETAIL_M
               WHERE ACCT_MONTH = V_MONTH) A,
             (SELECT * FROM DIM.DIM_CHANNEL_NO WHERE CHANNEL_TYPE LIKE '11%') B,
             /*(SELECT DISTINCT AGENT_ID,
                            AGENT_NAME,
                            CHANNEL_NO,
                            CASE
                              WHEN T.CHANNEL_TYPE = '110101' THEN
                               '04'
                              WHEN BUSINESS_ZONE = '10' THEN
                               '02'
                              WHEN BUSINESS_ZONE_NAME LIKE '%商圈%' THEN
                               '01'
                              ELSE
                               '03'
                            END CHANNEL_PROP_NO,
                            CASE
                              WHEN T.CHANNEL_TYPE = '110101' THEN
                               '自营'
                              WHEN BUSINESS_ZONE = '10' THEN
                               '社区'
                              WHEN BUSINESS_ZONE_NAME LIKE '%商圈%' THEN
                               '商圈'
                              ELSE
                               '农村'
                            END CHANNEL_PROP_NAME,
             
                            CASE
                              WHEN T.CHANNEL_TYPE IN ('110101') THEN
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
                              WHEN T.CHANNEL_TYPE IN ('110102') THEN
                               '07'
                              WHEN T.CHANNEL_TYPE IN ('110103') THEN
                               '08'
                              ELSE
                               '09'
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
                               'C'
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
                              WHEN T.CHANNEL_TYPE IN ('110102') THEN
                               '外包厅'
                              WHEN T.CHANNEL_TYPE IN ('110103') THEN
                               '贵宾厅'
                              ELSE
                               '其他'
                            END REGION_PROP_NAME
              FROM RPT_HBTELE.DM_BUSI_CHANNEL_BUILD T
             WHERE ACCT_MONTH = V_LAST_MONTH) C*/
             (SELECT *
                FROM DM_BUSI_CHANNEL_BUILD_ST T
               WHERE T.ACCT_MONTH = V_MONTH) C
       WHERE B.CHANNEL_NO = A.CHANNEL_NO(+)
         AND B.CHANNEL_NO = C.CHANNEL_NO
      --AND B.VALID_STATUS = '1'
       GROUP BY B.AREA_NO,
                B.CITY_NO,
                C.AGENT_ID,
                C.AGENT_NAME,
                B.CHANNEL_NO,
                CASE
                  WHEN JF_TYPE = '1' THEN
                   '移动单产品积分'
                  WHEN JF_TYPE = '2' THEN
                   '融合业务积分'
                  WHEN JF_TYPE = '3' THEN
                   '固网业务积分'
                  WHEN JF_TYPE = '4' THEN
                   '发展奖励积分'
                END,
                NVL(C.CHANNEL_PROP_NO, '01'),
                NVL(C.CHANNEL_PROP_NAME, '商圈'),
                NVL(C.REGION_PROP_NO, '07'),
                NVL(C.REGION_PROP_NAME, '其他');
    COMMIT;
  
    DELETE FROM INTEGRAL_SYS_DEVLP_JF_DETAIL_M T
     WHERE T.ACCT_MONTH = V_MONTH
       AND T.LOW_VALUE IS NULL;
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
