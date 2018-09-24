CREATE OR REPLACE PROCEDURE P_DW_V_USER_SCHOOL_HX_USER_M(V_ACCT_MONTH VARCHAR2,
                                                         V_RETCODE    OUT VARCHAR2,
                                                         V_RETINFO    OUT VARCHAR2) IS
  /*-------------------------------------------------------------------------------------------
     过 程 名 : 校园用户月表（划小）
     生成时间 ：2017.12.13
     编 写 人 ：LIANGZHITAO
     生成周期 ：每月执行
     执行时间 :
     使用参数 ：月份
     修改记录 ：
  -----------------------------------------------------------------------------------------------*/
  V_PROCNAME VARCHAR2(40);
  V_PKG      VARCHAR2(40);
  V_CNT      NUMBER;

  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018';

BEGIN

  V_PKG      := '校园用户月表(划小)';
  V_PROCNAME := 'P_DW_V_USER_SCHOOL_HX_USER_M';

  --日志部分
  P_INSERT_LOG(V_ACCT_MONTH, V_PKG, V_PROCNAME, '12', SYSDATE);

  SELECT COUNT(1)
    INTO V_CNT
    FROM DW_EXECUTE_LOG
   WHERE ACCT_MONTH = V_ACCT_MONTH
     AND PROCNAME IN ('P_DW_V_USER_BASE_INFO_USER','P_DW_V_USER_PRODUCT_INFO')
     AND RESULT = 'SUCCESS';

  IF V_CNT = 2 THEN

    --数据部分
    FOR C1 IN V_AREA LOOP

      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_BASE_USER_INFO_M';
      --BASE中间表
      INSERT INTO MID_BASE_USER_INFO_M
        SELECT A.ACCT_MONTH,
               A.AREA_NO,
               A.CITY_NO,
               A.TELE_TYPE,
               A.USER_NO,
               A.CUSTOMER_NO,
               A.ACCOUNT_NO,
               A.DEVICE_NUMBER,
               A.INNET_DATE,
               A.USER_DINNER,
               A.CHANNEL_NO,
               A.CHANNEL_NO_DESC,
               A.GROUP_NO,
               A.IS_ONNET,
               A.IS_NEW,
               A.IS_ACTIVE,
               A.IS_CALL,
               A.USER_STATUS,
               A.LOGOUT_DATE,
               A.IS_LOGOUT,
               A.IS_OUTNET,
               A.IS_VALID,
               A.RECENT_STOP_DATE,
               A.IS_OCS,
               A.IS_ACCT,
               A.IS_ACCT_OCS,
               A.INNET_MONTH,
               A.INNET_METHOD,
               NVL(BUNDLE_ID_ALLOWANCE, BUNDLE_ID) BUNDLE_ID,
               A.IS_KD_BUNDLE,
               A.TOTAL_FEE,
               A.TOTAL_FEE_OCS,
               A.PRICE_FEE,
               A.PRICE_FEE_OCS,
               A.BUNDLE_ID_ALLOWANCE,
               A.ALL_JF_FLUX,
               A.WIFI_JF_FLUX,
               A.JF_TIMES,
               A.TERMINAL_TYPE,
               A.TERMINAL_CORP,
               A.TELE_TYPE_NEW,
               A.IS_3NO_ADJUST
          FROM DW_V_USER_BASE_INFO_USER A
         WHERE A.ACCT_MONTH = V_ACCT_MONTH
           AND A.AREA_NO = C1.AREA_NO;
      COMMIT;

      --取本月固网用户
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_DW_V_USER_SCHOOL_HX_RH_M';
      INSERT INTO MID_DW_V_USER_SCHOOL_HX_RH_M
        SELECT /*+ORDERED*/
         V_ACCT_MONTH ACCT_MONTH,
         A.AREA_NO,
         A.USER_NO,
         A.DEVICE_NUMBER,
         A.TELE_TYPE,
         A.IS_ONNET,
         A.BUNDLE_ID
          FROM (SELECT AREA_NO,
                       CITY_NO,
                       USER_NO,
                       DEVICE_NUMBER,
                       CHANNEL_NO,
                       CHANNEL_NO_DESC,
                       IS_KD_BUNDLE,
                       TELE_TYPE,
                       NVL(BUNDLE_ID_ALLOWANCE, BUNDLE_ID) AS BUNDLE_ID,
                       IS_ONNET
                  FROM MID_BASE_USER_INFO_M T
                 WHERE TELE_TYPE <> '2') A,

               (SELECT USER_NO,
                       T.GRADE_0 || '/' || T.GRADE_1 || '/' || T.GRADE_2 || '/' ||
                       T.GRADE_3 || '/' || T.GRADE_4 STDADDR_NAME
                  FROM DW.DW_V_USER_ADSL_EIGHT_M T
                 WHERE ACCT_MONTH = V_ACCT_MONTH
                   AND T.AREA_NO = C1.AREA_NO
                   AND USER_NO IS NOT NULL) B,

               (SELECT *
                  FROM ALLDMCODE.DMCODE_XIAOQU_STD_ADDR_NEW
                 WHERE SCHOOL_FLAG = '01') C --小区和划小支局对应关系表
         WHERE A.USER_NO = B.USER_NO
           AND B.STDADDR_NAME = C.STDADDR_NAME;
      COMMIT;

      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_SCHOOL_HX_USER_M';
      --单C 可选包的用户
      INSERT INTO MID_SCHOOL_HX_USER_M
        SELECT A.USER_NO, '1'
          FROM (SELECT USER_NO
                  FROM MID_BASE_USER_INFO_M
                 WHERE TELE_TYPE = '2'
                   AND NVL(IS_KD_BUNDLE, 0) = '0') T, --单C
               (SELECT T.USER_NO, T.USER_DINNER
                  FROM DW_V_USER_PRODUCT_INFO T
                 WHERE T.ACCT_MONTH = V_ACCT_MONTH
                   AND T.AREA_NO = C1.AREA_NO
                   AND T.TELE_TYPE = '2'
                   AND (TO_CHAR(T.END_DATE, 'YYYYMM') >= V_ACCT_MONTH OR
                       T.END_DATE IS NULL)) A,
               (SELECT * FROM DIM.DIM_SCHOOL_DINNER T WHERE T.FLAG = '2') B --可选包
         WHERE T.USER_NO = A.USER_NO
           AND A.USER_DINNER = B.USER_DINNER;
      COMMIT;
      --单C 特定套餐用户
      INSERT INTO MID_SCHOOL_HX_USER_M
        SELECT A.USER_NO, '2'
          FROM (SELECT A.USER_NO, A.USER_DINNER
                  FROM MID_BASE_USER_INFO_M A
                 WHERE A.TELE_TYPE = '2'
                   AND NVL(A.IS_KD_BUNDLE, 0) = '0') A,
               (SELECT * FROM DIM.DIM_SCHOOL_DINNER T WHERE T.FLAG = '1') B
         WHERE A.USER_DINNER = B.USER_DINNER;
      COMMIT;
      --固网用户
      INSERT INTO MID_SCHOOL_HX_USER_M
        SELECT T.USER_NO, '3' FROM MID_DW_V_USER_SCHOOL_HX_RH_M T;
      COMMIT;

      --融合C用户
      INSERT INTO MID_SCHOOL_HX_USER_M
        SELECT A.USER_NO, '4'
          FROM (SELECT A.USER_NO,
                       NVL(BUNDLE_ID_ALLOWANCE, BUNDLE_ID) BUNDLE_ID
                  FROM MID_BASE_USER_INFO_M A
                 WHERE (A.TELE_TYPE = '2' AND NVL(A.IS_KD_BUNDLE, 0) <> '0')) A,
               (SELECT *
                  FROM (SELECT B.*,
                               ROW_NUMBER() OVER(PARTITION BY B.BUNDLE_ID ORDER BY 1) RN
                          FROM MID_DW_V_USER_SCHOOL_HX_RH_M B)
                 WHERE RN = 1) B
         WHERE A.BUNDLE_ID = B.BUNDLE_ID;
      COMMIT;

      ---------------------------- 向正式表写入数据 -------------------------------------
      EXECUTE IMMEDIATE 'ALTER TABLE DW_V_USER_SCHOOL_HX_USER_M TRUNCATE SUBPARTITION PART' ||
                        SUBSTR(V_ACCT_MONTH, 1, 6) || '_SUBPART_' ||
                        C1.AREA_NO;

      INSERT INTO DW_V_USER_SCHOOL_HX_USER_M
        SELECT A.ACCT_MONTH,
               A.AREA_NO,
               A.CITY_NO,
               A.TELE_TYPE,
               A.USER_NO,
               A.CUSTOMER_NO,
               A.ACCOUNT_NO,
               A.DEVICE_NUMBER,
               A.INNET_DATE,
               A.USER_DINNER,
               A.CHANNEL_NO,
               A.CHANNEL_NO_DESC,
               A.GROUP_NO,
               A.IS_ONNET,
               A.IS_NEW,
               A.IS_ACTIVE,
               A.IS_CALL,
               A.USER_STATUS,
               A.LOGOUT_DATE,
               A.IS_LOGOUT,
               A.IS_OUTNET,
               A.IS_VALID,
               A.RECENT_STOP_DATE,
               A.IS_OCS,
               A.IS_ACCT,
               A.IS_ACCT_OCS,
               A.INNET_MONTH,
               A.INNET_METHOD,
               A.BUNDLE_ID,
               A.IS_KD_BUNDLE,
               A.TOTAL_FEE,
               A.TOTAL_FEE_OCS,
               A.PRICE_FEE,
               A.PRICE_FEE_OCS,
               A.BUNDLE_ID_ALLOWANCE,
               A.ALL_JF_FLUX,
               A.WIFI_JF_FLUX,
               A.JF_TIMES,
               A.TERMINAL_TYPE,
               A.TERMINAL_CORP,
               A.TELE_TYPE_NEW,
               A.IS_3NO_ADJUST
          FROM MID_BASE_USER_INFO_M A,
               (SELECT *
                  FROM (SELECT B.*,
                               ROW_NUMBER() OVER(PARTITION BY USER_NO ORDER BY FLAG) RN
                          FROM MID_SCHOOL_HX_USER_M B)
                 WHERE RN = 1) B
         WHERE A.USER_NO = B.USER_NO;
      COMMIT;

    END LOOP;

    --更新日志
    V_RETCODE := 'SUCCESS';
    P_UPDATE_LOG(V_ACCT_MONTH,
                 V_PKG,
                 V_PROCNAME,
                 '结束',
                 'SUCCESS',
                 SYSDATE);
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
                 'FAIL',
                 SYSDATE);
END;
/
