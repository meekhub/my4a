CREATE OR REPLACE PROCEDURE P_TMP_CHEAT_SMS_ALARM_D(V_DATE    VARCHAR2,
                                                    V_RETCODE OUT VARCHAR2,
                                                    V_RETINFO OUT VARCHAR2) IS
  /*****************************************************************
  *名称 --%NAME:P_TMP_CHEAT_SMS_ALARM_D
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
BEGIN
  V_PKG        := '每日垃圾短信用户预警';
  V_PROCNAME   := 'P_TMP_CHEAT_SMS_ALARM_D';
  V_LAST_DAY   := TO_CHAR(TO_DATE(V_DATE, 'YYYYMMDD') - 1, 'YYYYMMDD');
  V_LAST_DAY_7 := TO_CHAR(TO_DATE(V_DATE, 'YYYYMMDD') - 7, 'YYYYMMDD');

  SELECT COUNT(1)
    INTO V_COUNT
    FROM DW.DW_EXECUTE_LOG A
   WHERE A.ACCT_MONTH = V_DATE
     AND A.PROCNAME IN ( 
                        'P_DW_V_USER_TERMINAL_D')
     AND A.RESULT = 'SUCCESS';

  SELECT COUNT(*)
    INTO V_COUNT2
    FROM (SELECT AREA_NO, DEVICE_NUMBER
            FROM TMP_RISK_USER
          MINUS
          SELECT * FROM TMP_RISK_USER_LAST);

  --插入日志
  ALLDM.P_ALLDM_INSERT_LOG(V_DATE, V_PKG, V_PROCNAME, '12', SYSDATE);

  IF V_COUNT >= 1 THEN
    -----------------沉淀昨日所有新注册终端信息---------------------
    EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_CHEAT_SMS_MID_01';
    INSERT INTO TMP_CHEAT_SMS_MID_01
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
  
    DELETE FROM TMP_CHEAT_SMS_HZ WHERE DAY_ID = V_DATE;
    COMMIT;
  
    INSERT INTO TMP_CHEAT_SMS_HZ
      SELECT V_DATE,
             C.AREA_NO,
             C.AREA_DESC,
             B.DEVICE_NUMBER,
             A.TERMINAL_CODE,
             A.TERMINAL_CORP,
             A.TERMINAL_MODEL
        FROM TMP_CHEAT_SMS_DEVICE A,
             TMP_CHEAT_SMS_MID_01 B,
             DIM.DIM_AREA_NO      C
       WHERE A.TERMINAL_CODE = B.TERMINAL_CODE
         AND B.AREA_NO = C.AREA_NO;
    COMMIT;
    --更新风险用户表
    EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_RISK_USER_LAST';
    INSERT INTO TMP_RISK_USER_LAST
      SELECT AREA_NO, DEVICE_NUMBER FROM TMP_RISK_USER;
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
