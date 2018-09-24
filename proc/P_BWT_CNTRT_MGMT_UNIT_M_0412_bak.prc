CREATE OR REPLACE PROCEDURE P_BWT_CNTRT_MGMT_UNIT_M(V_MONTH   VARCHAR2,
                                                    V_RETCODE OUT VARCHAR2,
                                                    V_RETINFO OUT VARCHAR2) IS
  /*-----------------------------------------------------------------------
  过 程 名：P_BWT_CNTRT_MGMT_UNIT_M
  生成日期：2014年6月28
  编 写 人：MAJIANHUI
  周  期  ：月
  目 标 表：BWT_CNTRT_MGMT_UNIT_M
  过程说明：承包经营单元编码（月）
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
             CASE
               WHEN A.HUAXIAO_NO = '813090030000000' THEN
                '沧州高新区'
               WHEN A.HUAXIAO_NO = '813060011010000' THEN
                '市辖区'
               ELSE
                B.CITY_DESC
             END,
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
               WHEN HUAXIAO_TYPE = '05' THEN
                '2020'
               WHEN HUAXIAO_TYPE = '06' THEN
                '2010'
               WHEN HUAXIAO_TYPE = '07' THEN
                '2030'
               WHEN HUAXIAO_TYPE = '08' THEN
                '5010'
               WHEN HUAXIAO_TYPE = '09' AND A.HUAXIAO_NAME LIKE '%电费承包' THEN
                '6040'
               WHEN HUAXIAO_TYPE = '09' AND A.HUAXIAO_NAME LIKE '%综合维护承包' THEN
                '6050'
               WHEN HUAXIAO_TYPE = '09' AND A.HUAXIAO_NAME LIKE '%政企支撑承包' THEN
                '6020'
               WHEN HUAXIAO_TYPE = '09' AND A.HUAXIAO_NAME LIKE '%维护产品承包' THEN
                '6030'
             END CNTRT_MGMT_TYPE, -- 划小承包单元类型
             CASE
               WHEN HUAXIAO_TYPE IN
                    ('01', '02', '03', '04', '05', '06', '07', '08') THEN
                '20'
               WHEN HUAXIAO_TYPE IN ('09') THEN
                '40'
             END CNTRT_MGMT_CHECK_TYPE, -- 划小承包考核类型
             C.CONTRACTCODE CNTRT_AGRMNT_CD -- 承包协议编码
        FROM DIM.DIM_HUAXIAO_INFO A,
             DIM.DIM_CITY_NO B,
             (SELECT *
                FROM (SELECT A.*,
                             ROW_NUMBER() OVER(PARTITION BY A.SMALLCODE ORDER BY A.STATUS DESC, CONTRACTID DESC) RN
                        FROM CONTRACT_INFO A)
               WHERE RN = 1) C
       WHERE A.CITY_NO = B.CITY_NO
         AND A.HUAXIAO_TYPE IN
             ('01', '02', '03', '04', '05', '06', '07', '08', '09')
         AND A.HUAXIAO_NO = C.SMALLCODE(+);
    COMMIT;
  
    --三级承包
    /*    INSERT \*+APPEND*\
    INTO ALLDM.BWT_CNTRT_MGMT_UNIT_M
      SELECT V_MONTH,
             '813',
             FUNC_GET_AREA_NO(A.AREA_NO),
             B.AREA_DESC,
             A.HUAXIAO_NO,
             A.HUAXIAO_NAME,
             '30', --划小承包单元层级
             '2010',
             '20' CNTRT_MGMT_CHECK_TYPE, -- 划小承包考核类型
             '' CNTRT_AGRMNT_CD -- 承包协议编码
        FROM DIM.DIM_HUAXIAO_INFO A, DIM.DIM_AREA_NO B
       WHERE A.AREA_NO = B.AREA_NO
         AND A.HUAXIAO_TYPE IN ('06')
         AND SUBSTR(HUAXIAO_NO, -7) = '0000000';
    COMMIT;*/
  
    --二级承包
    /*    INSERT \*+APPEND*\
    INTO ALLDM.BWT_CNTRT_MGMT_UNIT_M
      SELECT V_MONTH,
             '813',
             FUNC_GET_AREA_NO(A.AREA_NO),
             '河北省',
             A.HUAXIAO_NO,
             A.HUAXIAO_NAME,
             '20', --划小承包单元层级
             '5010',
             '40' CNTRT_MGMT_CHECK_TYPE, -- 划小承包考核类型
             '' CNTRT_AGRMNT_CD -- 承包协议编码
        FROM DIM.DIM_HUAXIAO_INFO A, DIM.DIM_AREA_NO B
       WHERE A.AREA_NO = B.AREA_NO
         AND A.HUAXIAO_TYPE IN ('08');
    COMMIT;*/
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
