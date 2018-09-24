CREATE OR REPLACE PROCEDURE DW.P_DW_V_BOX_INFO_M(V_ACCT_MONTH VARCHAR2,
                                                 V_RETCODE    OUT VARCHAR2,
                                                 V_RETINFO    OUT VARCHAR2) IS
  /*****************************************************************
  *名称 --%NAME:P_DW_V_BOX_INFO_M_M
  *功能描述 --%COMMENT: 资源侧箱体明细表
  *执行周期 --%PERIOD: 月
  *参数 --%PARAM:V_ACCT_MONTH  日期,格式YYYYMM
  *参数 --%PARAM:V_RETCODE  过程运行结束成功与否标志
  *参数 --%PARAM:V_RETCODE  过程运行结束成功与否描述
  *创建人 --%CREATOR:MAJIANHUI
  *创建时间 --%CREATED_TIME:2018-08-05
  *备注 --%REMARK:
  *来源表 --%FROM:
  *目标表 --%TO:   DW.DW_V_USER_BUTIE_M
  *修改记录 --%MODIFY: NULL
  *******************************************************************/
  V_PKG      VARCHAR2(40);
  V_PROCNAME VARCHAR2(40);
  V_COUNT    NUMBER;

BEGIN
  V_PKG      := '资源侧箱体明细表';
  V_PROCNAME := 'P_DW_V_BOX_INFO_M';

  --日志部分
  P_INSERT_LOG(V_ACCT_MONTH, V_PKG, V_PROCNAME, '12', SYSDATE);
  --------------------------------------------------------------
  -- 数据部分
  SELECT COUNT(1)
    INTO V_COUNT
    FROM DW.DW_EXECUTE_LOG
   WHERE ACCT_MONTH = V_ACCT_MONTH
     AND RESULT = 'SUCCESS'
     AND PROCNAME IN ('');

  IF V_COUNT >= 0 THEN
  
    EXECUTE IMMEDIATE 'ALTER TABLE DW.DW_V_BOX_INFO_M TRUNCATE PARTITION PART' ||
                      V_ACCT_MONTH;
  
    INSERT /*+APPEND*/
    INTO DW_V_BOX_INFO_M NOLOGGING
      SELECT V_ACCT_MONTH,
             B.AREA_NO,
             A.CITY_DESC,
             A.FGQ_NAME,
             A.FGQ_ID,
             A.PROJECT_ID,
             A.PROJECT_DESC,
             A.FGQ_DATE,
             A.STANDARD_NAME,
             A.STANDARD_ID,
             A.BOX_NAME,
             A.BOX_ID,
             A.DK_NUMBER,
             A.DK_USE_NUMBER
        FROM STAGE.ZIYUAN_LINBOX_M@HBODS A, DIM.DIM_AREA_NO B
       WHERE '0' || A.AREA_DESC = B.AREA_CODE;
    COMMIT;
  
    --更新日志
    V_RETCODE := 'SUCCESS';
    P_UPDATE_LOG(V_ACCT_MONTH,
                 V_PKG,
                 V_PROCNAME,
                 '结束',
                 V_RETCODE,
                 SYSDATE);
    DBMS_OUTPUT.PUT_LINE(V_RETCODE);
    ------------------------------------- 数据部分结束 -----------------------------------------------------
  ELSE
    V_RETCODE := 'WAIT';
    P_UPDATE_LOG(V_ACCT_MONTH, V_PKG, V_PROCNAME, '等待', 'WAIT', SYSDATE);
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    V_RETCODE := 'FAIL';
    V_RETINFO := SQLERRM;
    P_UPDATE_LOG(V_ACCT_MONTH,
                 V_PKG,
                 V_PROCNAME,
                 V_RETINFO,
                 V_RETCODE,
                 SYSDATE);
END;
/
