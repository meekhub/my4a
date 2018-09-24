CREATE OR REPLACE PROCEDURE P_BWT_CNTRT_MGMT_MAIN_REL_M(V_MONTH   VARCHAR2,
                                                        V_RETCODE OUT VARCHAR2,
                                                        V_RETINFO OUT VARCHAR2) IS
  /*-----------------------------------------------------------------------
  过 程 名：P_BWT_CNTRT_MGMT_MAIN_REL_M
  生成日期：2014年6月28
  编 写 人：MAJIANHUI
  周  期  ：月
  目 标 表：BWT_CNTRT_MGMT_MAIN_REL_M
  过程说明：划小承包单元与承包单元小CEO关系（月）
  -----------------------------------------------------------------------*/
  V_PKG      VARCHAR2(40);
  V_PROCNAME VARCHAR2(40);
  V_COUNT1   NUMBER := 0;
  V_COUNT2   NUMBER := 0;
BEGIN
  V_PKG      := 'P_BWT_CNTRT';
  V_PROCNAME := 'P_BWT_CNTRT_MGMT_MAIN_REL_M';
  --日志部分
  ALLDM.P_ALLDM_INSERT_LOG(V_MONTH, V_PKG, V_PROCNAME, '12', SYSDATE);
  ---------------------------------------------------------------
  SELECT COUNT(1)
    INTO V_COUNT1
    FROM ALLDM.ALLDM_EXECUTE_LOG
   WHERE ACCT_MONTH = V_MONTH
     AND RESULT = 'SUCCESS'
     AND PROCNAME IN
         ('P_BWT_CNTRT_MGMT_CHNL_REL_M', 'P_BWT_CNTRT_MGMT_UNIT_M');
  COMMIT;
  -- 数据部分
  IF V_COUNT1 >= 2 THEN
  
    --清除数据
    DELETE FROM ALLDM.BWT_CNTRT_MGMT_MAIN_REL_M WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
  
    INSERT /*+APPEND*/
    INTO ALLDM.BWT_CNTRT_MGMT_MAIN_REL_M
      SELECT DISTINCT V_MONTH,
                      '813',
                      A.CNTRT_MGMT_UNIT_CD, --承包经营单元编码
                      B.SMALLCEONAME       CNTRT_MGMT_CEO_NM,
                      B.SMALLCEOIDCARD     CNTRT_MGMT_CEO_CD
        FROM (SELECT *
                FROM BWT_CNTRT_MGMT_UNIT_M A
               WHERE ACCT_MONTH = V_MONTH) A,
             (SELECT *
                FROM (SELECT A.*,
                             ROW_NUMBER() OVER(PARTITION BY A.SMALLCODE ORDER BY A.STATUS DESC, CONTRACTID DESC) RN
                        FROM CONTRACT_INFO A)
               WHERE RN = 1) B
       WHERE A.CNTRT_MGMT_UNIT_CD = B.SMALLCODE(+);
    COMMIT;
    SELECT COUNT(1)
      INTO V_COUNT2
      FROM (SELECT COUNT(1), T.CNTRT_MGMT_UNIT_CD
              FROM ALLDM.BWT_CNTRT_MGMT_MAIN_REL_M T
             WHERE ACCT_MONTH = V_MONTH
             GROUP BY CNTRT_MGMT_UNIT_CD
            HAVING COUNT(1) > 1);
    COMMIT;
    IF V_COUNT2 < 1 THEN
      --更新日志
      V_RETCODE := 'SUCCESS';
      ALLDM.P_ALLDM_UPDATE_LOG(V_MONTH,
                               V_PKG,
                               V_PROCNAME,
                               '结束',
                               V_RETCODE,
                               SYSDATE);
      DBMS_OUTPUT.PUT_LINE(V_RETCODE);
    ELSE
      V_RETCODE := 'FAIL';
      V_RETINFO := SQLERRM;
      ALLDM.P_ALLDM_UPDATE_LOG(V_MONTH,
                               V_PKG,
                               V_PROCNAME,
                               V_RETINFO,
                               V_RETCODE,
                               SYSDATE);
    END IF;
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
