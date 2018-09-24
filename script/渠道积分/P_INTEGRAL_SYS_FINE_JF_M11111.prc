CREATE OR REPLACE PROCEDURE P_INTEGRAL_SYS_FINE_JF_M(V_MONTH   VARCHAR2,
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
  V_PKG         VARCHAR2(40);
  V_PROCNAME    VARCHAR2(40);
  V_COUNT       NUMBER := 0;
  V_COUNT1      NUMBER := 0;
  V_LAST_MONTH6 VARCHAR2(40);
  V_LAST_MONTH  VARCHAR2(40);
  --V_LAST_5     VARCHAR2(40);

  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO --WHERE area_no='720';
    where AREA_NO NOT IN ('018');

BEGIN
  V_PKG      := '渠道积分体系';
  V_PROCNAME := 'P_INTEGRAL_SYS_FINE_JF_M';
  --V_LAST_5     := TO_CHAR(TO_DATE(V_MONTH, 'YYYYMMDD') - 10, 'YYYYMMDD');
  V_LAST_MONTH := TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH, 'YYYYMM'), -1),
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
     AND PROCNAME IN ('P_DW_V_USER_BASE_INFO_USER');
  COMMIT;

  SELECT COUNT(1)
    INTO V_COUNT1
    FROM ALLDM_EXECUTE_LOG
   WHERE ACCT_MONTH = V_MONTH
     AND RESULT = 'SUCCESS'
     AND PROCNAME IN
         (/*'P_INTEGRAL_SYS_INCOME_JF_M',*/ 'P_INTEGRAL_SYS_WEIXI_JF_M');
  COMMIT;

  IF V_COUNT = 1 AND V_COUNT1 = 1 THEN
    /*EXECUTE IMMEDIATE 'ALTER TABLE ALLDM.INTEGRAL_SYS_INCOME_JF_DETAIL TRUNCATE PARTITION PART_' ||
    V_MONTH;*/
  
    EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_INTEGRAL_SYS_FINE_JF_FZ';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_INTEGRAL_SYS_FINE_JF_WX';
    DELETE FROM INTEGRAL_SYS_FINE_JF_FZ_HIS WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
    DELETE FROM INTEGRAL_SYS_FINE_JF_WX_HIS WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
    FOR C1 IN V_AREA LOOP
      ---离网/连续两个月欠费/停机保号/三无等异
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_INTEGRAL_SYS_FINE_JF_1';
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_INTEGRAL_SYS_FINE_JF_2';
    
      INSERT INTO MID_INTEGRAL_SYS_FINE_JF_1
        SELECT ACCT_MONTH,
               AREA_NO,
               CITY_NO,
               USER_NO,
               DEVICE_NUMBER,
               USER_STATUS,
               IS_3NO_ADJUST,
               LOGOUT_DATE
          FROM DW.DW_V_USER_BASE_INFO_USER T
         WHERE ACCT_MONTH = V_MONTH
           AND AREA_NO = C1.AREA_NO
           AND TO_CHAR(ADD_MONTHS(INNET_DATE, 6), 'YYYYMM') >= V_MONTH
           AND (LOGOUT_DATE IS NOT NULL
           or user_status='4')/*(USER_STATUS IN ('4', '18') OR IS_3NO_ADJUST = '1' OR
               LOGOUT_DATE IS NOT NULL)*/;---删掉 停机保号、三无 20171108
      COMMIT;
    
      INSERT INTO MID_INTEGRAL_SYS_FINE_JF_2
        SELECT A.ACCT_MONTH,
               A.AREA_NO,
               A.CITY_NO,
               A.USER_NO,
               A.DEVICE_NUMBER
          FROM (SELECT *
                  FROM MID_INTEGRAL_SYS_FINE_JF_1
                 WHERE USER_STATUS = '4') A,
               
               (SELECT USER_NO
                  FROM DW.DW_V_USER_BASE_INFO_USER T
                 WHERE ACCT_MONTH = V_LAST_MONTH
                   AND AREA_NO = C1.AREA_NO
                   AND USER_STATUS IN ('4')) B
         WHERE A.USER_NO = B.USER_NO;
      COMMIT;
    
      INSERT INTO MID_INTEGRAL_SYS_FINE_JF_FZ
        SELECT A.CHANNEL_NO, A.USER_NO, LOW_VALUE * (-1) LOW_VALUE,C1.AREA_NO
          FROM (SELECT CHANNEL_NO, USER_NO, LOW_VALUE
                  FROM INTEGRAL_SYS_DEVLP_JF_DETAIL_M
                 WHERE SUBSTR(DAY_ID, 1, 6) >= V_LAST_MONTH6
                   AND SUBSTR(DAY_ID, 1, 6) <= V_MONTH
                   AND AREA_NO = C1.AREA_NO) A,
               (SELECT ACCT_MONTH, AREA_NO, CITY_NO, USER_NO, DEVICE_NUMBER
                  FROM MID_INTEGRAL_SYS_FINE_JF_1
                 WHERE USER_STATUS <> '4'
                UNION ALL
                SELECT * FROM MID_INTEGRAL_SYS_FINE_JF_2) B
         WHERE A.USER_NO = B.USER_NO;
      COMMIT;
    
      INSERT INTO INTEGRAL_SYS_FINE_JF_FZ_HIS
        SELECT DISTINCT V_MONTH, C1.AREA_NO, USER_NO,CHANNEL_NO,LOW_VALUE
          FROM MID_INTEGRAL_SYS_FINE_JF_FZ
          where area_no=C1.AREA_NO;
      COMMIT;
    
      /*INSERT INTO MID_INTEGRAL_SYS_FINE_JF_WX
        SELECT A.CHANNEL_NO, A.USER_NO, LOW_VALUE * (-1) LOW_VALUE
          FROM (SELECT CHANNEL_NO, USER_NO, LOW_VALUE
                  FROM INTEGRAL_SYS_WEIXI_JF_DETAIL
                 WHERE ACCT_MONTH >= V_LAST_MONTH6
                   AND ACCT_MONTH <= V_MONTH
                   AND AREA_NO = C1.AREA_NO) A,
               (SELECT ACCT_MONTH, AREA_NO, CITY_NO, USER_NO, DEVICE_NUMBER
                  FROM MID_INTEGRAL_SYS_FINE_JF_1
                 WHERE LOGOUT_DATE IS NOT NULL
                UNION ALL
                SELECT * FROM MID_INTEGRAL_SYS_FINE_JF_2) B
         WHERE A.USER_NO = B.USER_NO;
      COMMIT;*/
      
      ----只考虑降档情况
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_INTEGRAL_SYS_fin_wx_1';
      INSERT INTO MID_INTEGRAL_SYS_fin_wx_1
        SELECT A.*, B.LOW_VALUE
          FROM (SELECT ACCT_MONTH,
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
                       USER_DINNER_DESC
                  FROM DW.DW_V_USER_BASE_INFO_USER T
                 WHERE ACCT_MONTH = V_MONTH
                      --AND DAY_ID = V_DAY
                   AND AREA_NO = C1.AREA_NO
                   AND CHANNEL_TYPE LIKE '11%'
                   AND IS_VALID = '1'
                   AND TELE_TYPE = '2'
                   AND TO_CHAR(SERVICE_START_DATE, 'YYYYMM') = V_MONTH) A,
               (SELECT *
                  FROM RPT_HBTELE.SJZX_WH_DIM_USER_DINNER T
                 WHERE T.LOW_VALUE >= 59) B
         WHERE A.USER_DINNER = B.USER_DINNER;
      COMMIT;
    
      INSERT INTO MID_INTEGRAL_SYS_fin_wx_2
        SELECT ACCT_MONTH,
               AREA_NO,
               CITY_NO,
               A.CHANNEL_NO,
               A.USER_NO,
               DEVICE_NUMBER,
               A.USER_DINNER
          FROM MID_INTEGRAL_SYS_fin_wx_1 A,
               (SELECT USER_NO, USER_DINNER
                  FROM DW.DW_V_USER_BASE_INFO_USER T
                 WHERE ACCT_MONTH = V_LAST_MONTH
                   AND AREA_NO = C1.AREA_NO
                   AND TELE_TYPE = '2') B,
               RPT_HBTELE.SJZX_WH_DIM_USER_DINNER C
         WHERE A.USER_NO = B.USER_NO
           AND B.USER_DINNER = C.USER_DINNER
           AND A.LOW_VALUE - C.LOW_VALUE < 0;
      COMMIT;
      
      INSERT INTO MID_INTEGRAL_SYS_FINE_JF_WX
        SELECT A.CHANNEL_NO, A.USER_NO, LOW_VALUE * (-1) LOW_VALUE,C1.AREA_NO
          FROM (SELECT CHANNEL_NO, USER_NO, LOW_VALUE
                  FROM INTEGRAL_SYS_WEIXI_JF_DETAIL
                 WHERE ACCT_MONTH >= V_LAST_MONTH6
                   AND ACCT_MONTH <= V_MONTH
                   AND AREA_NO = C1.AREA_NO) A,
               (SELECT ACCT_MONTH, AREA_NO, CITY_NO, USER_NO, DEVICE_NUMBER
                  FROM MID_INTEGRAL_SYS_fin_wx_2) B
         WHERE A.USER_NO = B.USER_NO;
      COMMIT;
      
      INSERT INTO INTEGRAL_SYS_FINE_JF_WX_HIS
        SELECT DISTINCT V_MONTH, C1.AREA_NO, USER_NO,CHANNEL_NO,LOW_VALUE
          FROM MID_INTEGRAL_SYS_FINE_JF_WX
          where area_no=C1.AREA_NO;
      COMMIT;
    
    END LOOP;
  
    DELETE FROM INTEGRAL_SYS_FINE_JF_M WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
    INSERT INTO INTEGRAL_SYS_FINE_JF_M
      SELECT V_MONTH,
             B.AREA_NO,
             B.CITY_NO,
             '发展类积分扣罚' JF_TYPE,
             C.AGENT_ID,
             C.AGENT_NAME,
             B.CHANNEL_NO,
             CEIL(NVL(LOW_VALUE, 0))
        FROM (SELECT '' AREA_NO,
                     '' CITY_NO,
                     '' JF_TYPE,
                     '' AGENT_ID,
                     '' AGENT_NAME,
                     CHANNEL_NO,
                     SUM(NVL(LOW_VALUE, 0)) LOW_VALUE
                FROM MID_INTEGRAL_SYS_FINE_JF_FZ A,
                     (SELECT DISTINCT USER_NO
                        FROM INTEGRAL_SYS_FINE_JF_FZ_HIS
                        where acct_month<v_month) B
               WHERE A.USER_NO = B.USER_NO(+)
                 AND B.USER_NO IS NULL
               GROUP BY CHANNEL_NO) A,
             (SELECT *
                FROM DIM.DIM_CHANNEL_NO
               WHERE CHANNEL_TYPE LIKE '11%'
                 AND VALID_STATUS = '1') B,
             (SELECT DISTINCT AGENT_ID, AGENT_NAME, CHANNEL_NO
                FROM RPT_HBTELE.DM_BUSI_CHANNEL_BUILD
               WHERE ACCT_MONTH = V_MONTH) C
       WHERE B.CHANNEL_NO = A.CHANNEL_NO(+)
         AND B.CHANNEL_NO = C.CHANNEL_NO(+)
         AND B.VALID_STATUS = '1';
    COMMIT;
  
    INSERT INTO INTEGRAL_SYS_FINE_JF_M
      SELECT V_MONTH,
             B.AREA_NO,
             B.CITY_NO,
             '维系类积分扣罚' JF_TYPE,
             C.AGENT_ID,
             C.AGENT_NAME,
             B.CHANNEL_NO,
             NVL(LOW_VALUE, 0)
        FROM (SELECT '' AREA_NO,
                     '' CITY_NO,
                     '' JF_TYPE,
                     '' AGENT_ID,
                     '' AGENT_NAME,
                     CHANNEL_NO,
                     SUM(NVL(LOW_VALUE, 0)) LOW_VALUE
                FROM MID_INTEGRAL_SYS_FINE_JF_WX A,
                     (SELECT DISTINCT USER_NO
                        FROM INTEGRAL_SYS_FINE_JF_WX_HIS
                        where acct_month<v_month) B
               WHERE A.USER_NO = B.USER_NO(+)
                 AND B.USER_NO IS NULL
               GROUP BY CHANNEL_NO) A,
             (SELECT * FROM DIM.DIM_CHANNEL_NO WHERE CHANNEL_TYPE LIKE '11%') B,
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
