CREATE OR REPLACE PROCEDURE P_CHEAT_USER_ALARM_D(V_DATE    VARCHAR2,
                                                     V_RETCODE OUT VARCHAR2,
                                                     V_RETINFO OUT VARCHAR2) IS
  /*****************************************************************
  *名称 --%NAME:P_CHEAT_USER_ALARM_D
  *执行周期 --%PERIOD: 日
  *创建人 --%CREATOR:MAJIANHUI
  *创建时间 --%CREATED_TIME:2017-12-3
  *******************************************************************/
  V_PKG        VARCHAR2(40);
  V_PROCNAME   VARCHAR2(40);
  V_COUNT      NUMBER;
  V_COUNT2     NUMBER;
  V_LAST_DAY   VARCHAR2(20);
  V_LAST_DAY_7 VARCHAR2(20);
  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018';
BEGIN
  V_PKG        := '每日欺诈用户预警';
  V_PROCNAME   := 'P_CHEAT_USER_ALARM_D';
  V_LAST_DAY   := TO_CHAR(TO_DATE(V_DATE, 'YYYYMMDD') - 1, 'YYYYMMDD');
  V_LAST_DAY_7 := TO_CHAR(TO_DATE(V_DATE, 'YYYYMMDD') - 7, 'YYYYMMDD');

  SELECT COUNT(1)
    INTO V_COUNT
    FROM DW.DW_EXECUTE_LOG A
   WHERE A.ACCT_MONTH = V_DATE
     AND A.PROCNAME IN ('P_DW_V_USER_CDR_CDMA_OCS',
                        'P_DW_V_USER_CDR_CDMA',
                        'P_DW_V_USER_TERMINAL_D')
     AND A.RESULT = 'SUCCESS';

  SELECT COUNT(*)
    INTO V_COUNT2
    FROM (SELECT AREA_NO, DEVICE_NUMBER
            FROM MID_RISK_USER
          MINUS
          SELECT * FROM MID_RISK_USER_LAST);

  --插入日志
  ALLDM.P_ALLDM_INSERT_LOG(V_DATE, V_PKG, V_PROCNAME, '12', SYSDATE);

  IF V_COUNT >= 3 THEN

    ------------------1、提取每日漫游至龙岩、漳州话单---------------------
    DELETE FROM dm_cheat_mid_01 WHERE DAY_ID = V_LAST_DAY_7;
    COMMIT;
    DELETE FROM dm_cheat_mid_01 WHERE DAY_ID = V_DATE;
    COMMIT;
    FOR C1 IN V_AREA LOOP
      INSERT INTO dm_cheat_mid_01
        SELECT V_DATE,
               C1.AREA_NO,
               DEVICE_NUMBER,
               ORG_TRM_ID,
               OPPOSE_NUMBER,
               CELL_NO,
               FUNC_GET_QIZHA_REGION(ROAM_AREA_CODE)
          FROM DW.DW_V_USER_CDR_CDMA_OCS
         WHERE ACCT_MONTH = SUBSTR(V_DATE, 1, 6)
           AND CALL_DATE = SUBSTR(V_DATE, 7, 2)
           AND AREA_NO = C1.AREA_NO
           AND ROAM_AREA_CODE IN ('384', '395','305','568','912','713','503','825')
        UNION ALL
        SELECT V_DATE,
               C1.AREA_NO,
               DEVICE_NUMBER,
               ORG_TRM_ID,
               OPPOSE_NUMBER,
               CELL_NO,
               FUNC_GET_QIZHA_REGION(ROAM_AREA_CODE)
          FROM DW.DW_V_USER_CDR_CDMA
         WHERE ACCT_MONTH = SUBSTR(V_DATE, 1, 6)
           AND CALL_DATE = SUBSTR(V_DATE, 7, 2)
           AND AREA_NO = C1.AREA_NO
           AND ROAM_AREA_CODE IN ('384', '395','305','568','912','713','503','825');
      COMMIT;
    END LOOP;

    ------------------更新CI库，判定涉案用户表有没有变化，如果有变化就更新---------------------
    IF V_COUNT2 <> 0 THEN
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_RISK_CELL';
      INSERT INTO MID_RISK_CELL
        SELECT CELL_NO, LEVEL_IDX
          FROM (SELECT CELL_NO,
                       LEVEL_IDX,
                       ROW_NUMBER() OVER(PARTITION BY CELL_NO ORDER BY LEVEL_IDX ASC) RN
                  FROM (SELECT A.CELL_NO, COUNT(*) LEVEL_IDX
                          FROM dm_cheat_mid_01 A, MID_RISK_USER B
                         WHERE A.DEVICE_NUMBER = B.DEVICE_NUMBER
                         GROUP BY A.CELL_NO
                        UNION ALL
                        SELECT * FROM MID_LT_RISK_CELL))
         WHERE RN = 1;

      COMMIT;

      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_LT_RISK_CELL';
      INSERT INTO MID_LT_RISK_CELL
        SELECT * FROM MID_RISK_CELL;
      COMMIT;
    END IF;

    ------------------2、根据主叫占比、被叫离散度统计输出风险用户---------------------
    EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_CHEAT_MID_02';
    INSERT INTO TMP_CHEAT_MID_02
      SELECT V_DATE,
             T.AREA_NO,
             T.DEVICE_NUMBER,
             ZHU_CALL_CDR,
             BEI_CALL_CDR,
             BEI_USER_CDR,
             T.ROAM_REGION
        FROM (SELECT T.DEVICE_NUMBER,
                     T.AREA_NO,
                     T.ROAM_REGION,
                     SUM(CASE
                           WHEN ORG_TRM_ID = '10' THEN
                            1
                           ELSE
                            0
                         END) ZHU_CALL_CDR,
                     SUM(CASE
                           WHEN ORG_TRM_ID = '11' THEN
                            1
                           ELSE
                            0
                         END) BEI_CALL_CDR,
                     COUNT(DISTINCT CASE
                             WHEN ORG_TRM_ID = '10' THEN
                              OPPOSE_NUMBER
                           END) BEI_USER_CDR
                FROM dm_cheat_mid_01 T
               GROUP BY T.DEVICE_NUMBER, T.AREA_NO,T.ROAM_REGION) T
       WHERE T.ZHU_CALL_CDR / (T.ZHU_CALL_CDR + T.BEI_CALL_CDR) > 0.83232
         AND T.BEI_USER_CDR / T.ZHU_CALL_CDR > 0.70928
         AND T.ZHU_CALL_CDR > 3;
    COMMIT;

    ------------------3、根据已涉案号码的风险CI池输出风险用户---------------------
    EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_CHEAT_MID_03';
    INSERT INTO TMP_CHEAT_MID_03
      SELECT V_DATE, B.AREA_NO, B.DEVICE_NUMBER, A.LEVEL_IDX,B.ROAM_REGION
        FROM MID_LT_RISK_CELL A, dm_cheat_mid_01 B
       WHERE A.CELL_NO = B.CELL_NO;
    COMMIT;

    ------------------4、沉淀昨日所有新注册终端信息---------------------
    EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_CHEAT_MID_04';
    INSERT INTO TMP_CHEAT_MID_04
      SELECT V_DATE,
             AREA_NO,
             DEVICE_NO DEVICE_NUMBER,
             TERMINAL_CODE,
             TERMINAL_MODEL,
             TERMINAL_CORP
        FROM DW.DW_V_USER_TERMINAL_D
       WHERE ACCT_MONTH = TO_CHAR(SYSDATE - 1, 'YYYYMM')
         AND DAY_ID = TO_CHAR(SYSDATE - 1, 'DD')
         AND TO_CHAR(REG_DATE, 'YYYYMMDD') = V_DATE
         AND LENGTH(TERMINAL_CODE) > 8 --剔除异常终端;
      ;
    COMMIT;

    ------------------更新终端库，判定涉案用户表有没有变化，如果有变化就更新---------------------
    IF V_COUNT2 <> 0 THEN
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_RISK_DEVICE';
      INSERT INTO MID_RISK_DEVICE
        SELECT TERMINAL_CODE, TERMINAL_CORP, TERMINAL_MODEL, TERMINAL_TYPE
          FROM (SELECT TERMINAL_CODE,
                       TERMINAL_CORP,
                       TERMINAL_MODEL,
                       TERMINAL_TYPE,
                       ROW_NUMBER() OVER(PARTITION BY TERMINAL_CODE ORDER BY TERMINAL_TYPE) RN
                  FROM (SELECT B.TERMINAL_CODE,
                               B.TERMINAL_CORP,
                               B.TERMINAL_MODEL,
                               '1' TERMINAL_TYPE
                          FROM MID_RISK_USER A,
                               (SELECT DEVICE_NO,
                                       TERMINAL_CODE,
                                       TERMINAL_CORP,
                                       TERMINAL_MODEL
                                  FROM DW.DW_V_USER_TERMINAL_D
                                 WHERE ACCT_MONTH = SUBSTR(V_DATE,1,6)
                                   AND DAY_ID = SUBSTR(V_DATE,7,2)
                                   AND LENGTH(TERMINAL_CODE) > 8) B
                         WHERE A.DEVICE_NUMBER = B.DEVICE_NO
                           AND A.DAY_ID = V_DATE
                        UNION
                        SELECT * FROM MID_ZQP_RISK_DEVICE))
         WHERE RN = 1;
      COMMIT;

      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_ZQP_RISK_DEVICE';
      INSERT INTO MID_ZQP_RISK_DEVICE
        SELECT * FROM MID_RISK_DEVICE;
      COMMIT;
    END IF;

    ------------------5、输出风险用户---------------------
    EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_CHEAT_RISK_USER';
    INSERT INTO MID_CHEAT_RISK_USER
      SELECT V_DATE,
             B.AREA_DESC,
             A.DEVICE_NUMBER,
             MAX(CASE
                   WHEN FLAG = '1' THEN
                    '1'
                   ELSE
                    '0'
                 END) CALL_RISK_FLAG,
             MAX(CASE
                   WHEN FLAG = '2' THEN
                    '1'
                   ELSE
                    '0'
                 END) CELL_RISK_FLAG,
             MAX(CASE
                   WHEN FLAG = '3' THEN
                    '1'
                   ELSE
                    '0'
                 END) TERMINAL_RISK_FLAG,
             NVL(A.ROAM_REGION,'龙岩'),
             FUNC_GET_QIZHA_FLAG(A.ROAM_REGION)
        FROM (SELECT AREA_NO, DEVICE_NUMBER, '1' FLAG, ROAM_REGION
                FROM TMP_CHEAT_MID_02
              UNION
              SELECT AREA_NO, DEVICE_NUMBER, '2', ROAM_REGION
                FROM TMP_CHEAT_MID_03
              UNION
              SELECT AREA_NO, DEVICE_NUMBER, '3' , '龙岩'
                FROM TMP_CHEAT_MID_04 X, MID_ZQP_RISK_DEVICE Y
               WHERE X.TERMINAL_CODE = Y.TERMINAL_CODE) A,
             DIM.DIM_AREA_NO B,
             (SELECT * FROM DM_CHEAT_RISK_USER WHERE DAY_ID <= V_LAST_DAY) C
       WHERE A.AREA_NO = B.AREA_NO
         AND A.DEVICE_NUMBER = C.DEVICE_NUMBER(+)
         AND C.DEVICE_NUMBER IS NULL
       GROUP BY B.AREA_DESC, A.DEVICE_NUMBER, B.IDX_NO, NVL(A.ROAM_REGION,'龙岩'),FUNC_GET_QIZHA_FLAG(A.ROAM_REGION)
       ORDER BY B.IDX_NO;
    COMMIT;
    
    EXECUTE IMMEDIATE 'TRUNCATE TABLE DM_CHEAT_RISK_USER';
    
    INSERT INTO DM_CHEAT_RISK_USER
      SELECT A.*
        FROM MID_CHEAT_RISK_USER A
       WHERE EXISTS (SELECT 1
                FROM DW.DW_V_USER_BASE_INFO_USER B
               WHERE B.ACCT_MONTH = TO_CHAR(SYSDATE-36,'YYYYMM')
                 AND TELE_TYPE = '2'
                 AND B.CUSTOMER_TYPE <> '3'
                 AND IS_ONNET = '1'
                 AND B.INNET_MONTH <= 12
                 AND B.IS_KD_BUNDLE = '0'
                 AND B.ALL_JF_FLUX <= 20
                 AND B.STAR_LEVEL = '0'
                 AND A.DEVICE_NUMBER = B.DEVICE_NUMBER);
    COMMIT;
    
    DELETE FROM DM_CHEAT_RISK_USER_HIS WHERE DAY_ID = V_DATE;
    COMMIT;
    insert into DM_CHEAT_RISK_USER_HIS  
    select * from DM_CHEAT_RISK_USER  WHERE DAY_ID = V_DATE;
    commit;
    --更新风险用户表
    EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_RISK_USER_LAST';
    INSERT INTO MID_RISK_USER_LAST
    SELECT AREA_NO,DEVICE_NUMBER FROM MID_RISK_USER;
    COMMIT;

    --更新日志
    V_RETCODE := 'SUCCESS';
    ALLDM.P_ALLDM_UPDATE_LOG(V_DATE,
                             V_PKG,
                             V_PROCNAME,
                             '结束',
                             'SUCCESS',
                             SYSDATE);

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
                             'FAIL',
                             SYSDATE);

END;
/
