CREATE OR REPLACE PROCEDURE P_BWT_CNTRT_MGMT_UNIT_M(V_MONTH   VARCHAR2,
                                                    V_RETCODE OUT VARCHAR2,
                                                    V_RETINFO OUT VARCHAR2) IS
  /*-----------------------------------------------------------------------
  过 程 名：P_BWT_CNTRT_MGMT_UNIT_M
  生成日期：2014年6月28
  编 写 人：MAJIANHUI
  周  期  ：月
  目 标 表：BWT_CNTRT_MGMT_UNIT_M
  过程说明：划小承包单元编码（月）
  修改记录：201712 李亚修改
  -----------------------------------------------------------------------*/
  V_PKG      VARCHAR2(40);
  V_PROCNAME VARCHAR2(40);
  V_COUNT1   NUMBER := 0;

BEGIN
  V_PKG      := 'P_BWT_CNTRT';
  V_PROCNAME := 'P_BWT_CNTRT_MGMT_UNIT_M';
  --日志部分
  ALLDM.P_ALLDM_INSERT_LOG(V_MONTH, V_PKG, V_PROCNAME, '12', SYSDATE);
  ---------------------------------------------------------------
  -- 数据部分
  IF V_COUNT1 >= 0 THEN
  
    --清除数据
    DELETE FROM ALLDM.BWT_CNTRT_MGMT_UNIT_M WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
    -----插入实体渠道的数据（政企现在还没有数据）
    INSERT /*+APPEND*/
    INTO ALLDM.BWT_CNTRT_MGMT_UNIT_M
      SELECT V_MONTH,
             '813',
             FUNC_GET_AREA_NO(A.AREA_NO),
             B.CITY_DESC,
             A.HUAXIAO_NO,
             A.HUAXIAO_NAME,
             '40', --划小承包单元层级
             CASE
               WHEN HUAXIAO_TYPE = '01' THEN
                '3010'
               WHEN HUAXIAO_TYPE = '02' THEN
                '3020'
               WHEN HUAXIAO_TYPE = '03' THEN
                '3030'
               WHEN HUAXIAO_TYPE = '04' THEN
                '1020'
             END CNTRT_MGMT_TYPE, -- 划小承包单元类型
             CASE
               WHEN HUAXIAO_TYPE IN ('01', '02') THEN
                '10'
               WHEN HUAXIAO_TYPE IN ('03', '04') THEN
                '20'
             END CNTRT_MGMT_CHECK_TYPE, -- 划小承包考核类型
             '' CNTRT_AGRMNT_CD -- 承包协议编码
        FROM DIM.DIM_HUAXIAO_INFO A, DIM.DIM_CITY_NO B
       WHERE A.CITY_NO = B.CITY_NO;
    COMMIT;
    SELECT COUNT(1)
      INTO V_COUNT1
      FROM ALLDM.BWT_CNTRT_MGMT_UNIT_M
     WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('111111111111');
    IF V_COUNT1 > 1500 THEN
      --更新日志
      V_RETCODE := 'SUCCESS';
      ALLDM.P_ALLDM_UPDATE_LOG(V_MONTH,
                               V_PKG,
                               V_PROCNAME,
                               '结束',
                               V_RETCODE,
                               SYSDATE);
      DBMS_OUTPUT.PUT_LINE('2222222222222222');
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
    DBMS_OUTPUT.PUT_LINE('3333333333333');
    ------------------------------------- 数据部分结束 -------------------------
  ELSE
    V_RETCODE := 'WAIT';
    ALLDM.P_ALLDM_UPDATE_LOG(V_MONTH,
                             V_PKG,
                             V_PROCNAME,
                             '等待',
                             'WAIT',
                             SYSDATE);
    DBMS_OUTPUT.PUT_LINE('44444444444444');
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
    DBMS_OUTPUT.PUT_LINE('555555555555');
END;
/
