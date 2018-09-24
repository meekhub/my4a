CREATE OR REPLACE PROCEDURE P_CBZS_DM_KKPI_M_DEV_ADMIN(V_ACCT_MONTH VARCHAR2,
                                                       V_RETCODE    OUT VARCHAR2,
                                                       V_RETINFO    OUT VARCHAR2) IS
  /*-----------------------------------------------------------------------
  过 程 名：P_CBZS_DM_KKPI_M_DEV_ADMIN
  生成日期：2017年11月28
  编 写 人：liangzhitao
  周  期  ：月
  目 标 表：CBZS_DM_KKPI_M_DEV_ADMIN
  过程说明：(新划小)发展月报(ADMIN)
  -----------------------------------------------------------------------*/
  V_PKG        VARCHAR2(40);
  V_PROCNAME   VARCHAR2(40);
  V_COUNT1     NUMBER := 0;
  V_LAST_MONTH VARCHAR2(20);
  /*CURSOR V_AREA IS
  SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018';*/
BEGIN
  V_PKG        := '(新划小)发展月报(ADMIN)';
  V_PROCNAME   := 'P_CBZS_DM_KKPI_M_DEV_ADMIN';
  V_LAST_MONTH := TO_CHAR(ADD_MONTHS(TO_DATE(V_ACCT_MONTH, 'YYYYMM'), -1),
                          'YYYYMM');
  /*  V_LAST_YEAR  := TO_CHAR(ADD_MONTHS(TO_CHAR(TO_DATE(V_MONTH, 'YYYYMM')),
             -12),
  'YYYYMM');*/
  --日志部分
  ALLDM.P_ALLDM_INSERT_LOG(V_ACCT_MONTH, V_PKG, V_PROCNAME, '12', SYSDATE);
  ---------------------------------------------------------------
  -- 数据部分

  SELECT COUNT(1)
    INTO V_COUNT1
    FROM ALLDM.ALLDM_EXECUTE_LOG
   WHERE ACCT_MONTH = V_ACCT_MONTH
     AND RESULT = 'SUCCESS'
     AND PROCNAME IN ('P_DM_V_HUAXIAO_INFO_M');

  IF V_COUNT1 >= 1 THEN

    DELETE FROM MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_ADMIN T
     WHERE T.ACCT_MONTH = V_ACCT_MONTH;
    COMMIT;
    --移动发展
    INSERT INTO MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_ADMIN
      SELECT MAX(T.ACCT_MONTH) ACCT_MONTH,
             T.AREA_NO,
             T.CITY_NO,
             T.HUAXIAO_TYPE_BIG,
             T.HUAXIAO_TYPE,
             T.TYPE_ONE,
             T.TYPE_TWO,
             SUM(T.CDMA_NUM),
             SUM(T.LAST_MONTH_VALUE),
             SUM(T.YEAR_VALUE)
        FROM (SELECT T.ACCT_MONTH,
                     T.AREA_NO,
                     T.CITY_NO,
                     '1' HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     '01' TYPE_ONE,
                     '01' TYPE_TWO,
                     SUM(T.CDMA_NUM) CDMA_NUM,
                     0 LAST_MONTH_VALUE,
                     SUM(T.CDMA_NUM) YEAR_VALUE
                FROM ALLDM.TMP_V_HUAXIAO_INFO_M T
               WHERE T.ACCT_MONTH = V_ACCT_MONTH
               GROUP BY T.ACCT_MONTH, T.AREA_NO, T.CITY_NO, T.HUAXIAO_TYPE
              UNION ALL
              SELECT T.ACCT_MONTH,
                     T.AREA_NO,
                     T.CITY_NO,
                     T.HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.TYPE_ONE,
                     T.TYPE_TWO,
                     0,
                     T.MONTH_VALUE,
                     T.YEAR_VALUE
                FROM MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_ADMIN T
               WHERE ACCT_MONTH = V_LAST_MONTH
                 AND T.TYPE_ONE = '01'
                 AND T.TYPE_TWO = '01') T
       GROUP BY T.AREA_NO,
                T.CITY_NO,
                T.HUAXIAO_TYPE_BIG,
                T.HUAXIAO_TYPE,
                T.TYPE_ONE,
                T.TYPE_TWO;
    COMMIT;

    --宽带发展
    INSERT INTO MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_ADMIN
      SELECT MAX(T.ACCT_MONTH) ACCT_MONTH,
             T.AREA_NO,
             T.CITY_NO,
             T.HUAXIAO_TYPE_BIG,
             T.HUAXIAO_TYPE,
             T.TYPE_ONE,
             T.TYPE_TWO,
             SUM(T.ADSL_NUM),
             SUM(T.LAST_MONTH_VALUE),
             SUM(T.YEAR_VALUE)
        FROM (SELECT T.ACCT_MONTH,
                     T.AREA_NO,
                     T.CITY_NO,
                     '1' HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     '02' TYPE_ONE,
                     '01' TYPE_TWO,
                     SUM(T.ADSL_NUM) ADSL_NUM,
                     0 LAST_MONTH_VALUE,
                     SUM(T.ADSL_NUM) YEAR_VALUE
                FROM ALLDM.TMP_V_HUAXIAO_INFO_M T
               WHERE T.ACCT_MONTH = V_ACCT_MONTH
               GROUP BY T.ACCT_MONTH, T.AREA_NO, T.CITY_NO, T.HUAXIAO_TYPE
              UNION ALL
              SELECT T.ACCT_MONTH,
                     T.AREA_NO,
                     T.CITY_NO,
                     T.HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.TYPE_ONE,
                     T.TYPE_TWO,
                     0,
                     T.MONTH_VALUE,
                     T.YEAR_VALUE
                FROM MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_ADMIN T
               WHERE ACCT_MONTH = V_LAST_MONTH
                 AND T.TYPE_ONE = '02'
                 AND T.TYPE_TWO = '01') T
       GROUP BY T.AREA_NO,
                T.CITY_NO,
                T.HUAXIAO_TYPE_BIG,
                T.HUAXIAO_TYPE,
                T.TYPE_ONE,
                T.TYPE_TWO;
    COMMIT;

    --天翼高清发展
    INSERT INTO MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_ADMIN
      SELECT MAX(T.ACCT_MONTH) ACCT_MONTH,
             T.AREA_NO,
             T.CITY_NO,
             T.HUAXIAO_TYPE_BIG,
             T.HUAXIAO_TYPE,
             T.TYPE_ONE,
             T.TYPE_TWO,
             SUM(T.IPTV_NUM),
             SUM(T.LAST_MONTH_VALUE),
             SUM(T.YEAR_VALUE)
        FROM (SELECT T.ACCT_MONTH,
                     T.AREA_NO,
                     T.CITY_NO,
                     '1' HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     '03' TYPE_ONE,
                     '01' TYPE_TWO,
                     SUM(T.IPTV_NUM) IPTV_NUM,
                     0 LAST_MONTH_VALUE,
                     SUM(T.IPTV_NUM) YEAR_VALUE
                FROM ALLDM.TMP_V_HUAXIAO_INFO_M T
               WHERE T.ACCT_MONTH = V_ACCT_MONTH
               GROUP BY T.ACCT_MONTH, T.AREA_NO, T.CITY_NO, T.HUAXIAO_TYPE
              UNION ALL
              SELECT T.ACCT_MONTH,
                     T.AREA_NO,
                     T.CITY_NO,
                     T.HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.TYPE_ONE,
                     T.TYPE_TWO,
                     0,
                     T.MONTH_VALUE,
                     T.YEAR_VALUE
                FROM MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_ADMIN T
               WHERE ACCT_MONTH = V_LAST_MONTH
                 AND T.TYPE_ONE = '03'
                 AND T.TYPE_TWO = '01') T
       GROUP BY T.AREA_NO,
                T.CITY_NO,
                T.HUAXIAO_TYPE_BIG,
                T.HUAXIAO_TYPE,
                T.TYPE_ONE,
                T.TYPE_TWO;
    COMMIT;

    --移动网上
    INSERT INTO MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_ADMIN
      SELECT MAX(T.ACCT_MONTH) ACCT_MONTH,
             T.AREA_NO,
             T.CITY_NO,
             T.HUAXIAO_TYPE_BIG,
             T.HUAXIAO_TYPE,
             T.TYPE_ONE,
             T.TYPE_TWO,
             SUM(T.ONNET_CDMA_NUM),
             SUM(T.LAST_MONTH_VALUE),
             SUM(T.YEAR_VALUE)
        FROM (SELECT T.ACCT_MONTH,
                     T.AREA_NO,
                     T.CITY_NO,
                     '1' HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     '04' TYPE_ONE,
                     '01' TYPE_TWO,
                     SUM(T.ONNET_CDMA_NUM) ONNET_CDMA_NUM,
                     0 LAST_MONTH_VALUE,
                     SUM(T.ONNET_CDMA_NUM) YEAR_VALUE
                FROM ALLDM.TMP_V_HUAXIAO_INFO_M T
               WHERE T.ACCT_MONTH = V_ACCT_MONTH
               GROUP BY T.ACCT_MONTH, T.AREA_NO, T.CITY_NO, T.HUAXIAO_TYPE
              UNION ALL
              SELECT T.ACCT_MONTH,
                     T.AREA_NO,
                     T.CITY_NO,
                     T.HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.TYPE_ONE,
                     T.TYPE_TWO,
                     0,
                     T.MONTH_VALUE,
                     0 YEAR_VALUE
                FROM MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_ADMIN T
               WHERE ACCT_MONTH = V_LAST_MONTH
                 AND T.TYPE_ONE = '04'
                 AND T.TYPE_TWO = '01') T
       GROUP BY T.AREA_NO,
                T.CITY_NO,
                T.HUAXIAO_TYPE_BIG,
                T.HUAXIAO_TYPE,
                T.TYPE_ONE,
                T.TYPE_TWO;
    COMMIT;

    --宽带网上
    INSERT INTO MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_ADMIN
      SELECT MAX(T.ACCT_MONTH) ACCT_MONTH,
             T.AREA_NO,
             T.CITY_NO,
             T.HUAXIAO_TYPE_BIG,
             T.HUAXIAO_TYPE,
             T.TYPE_ONE,
             T.TYPE_TWO,
             SUM(T.Onnet_Adsl_Num),
             SUM(T.LAST_MONTH_VALUE),
             SUM(T.YEAR_VALUE)
        FROM (SELECT T.ACCT_MONTH,
                     T.AREA_NO,
                     T.CITY_NO,
                     '1' HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     '05' TYPE_ONE,
                     '01' TYPE_TWO,
                     SUM(T.Onnet_Adsl_Num) Onnet_Adsl_Num,
                     0 LAST_MONTH_VALUE,
                     SUM(T.Onnet_Adsl_Num) YEAR_VALUE
                FROM ALLDM.TMP_V_HUAXIAO_INFO_M T
               WHERE T.ACCT_MONTH = V_ACCT_MONTH
               GROUP BY T.ACCT_MONTH, T.AREA_NO, T.CITY_NO, T.HUAXIAO_TYPE
              UNION ALL
              SELECT T.ACCT_MONTH,
                     T.AREA_NO,
                     T.CITY_NO,
                     T.HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.TYPE_ONE,
                     T.TYPE_TWO,
                     0,
                     T.MONTH_VALUE,
                     0 YEAR_VALUE
                FROM MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_ADMIN T
               WHERE ACCT_MONTH = V_LAST_MONTH
                 AND T.TYPE_ONE = '05'
                 AND T.TYPE_TWO = '01') T
       GROUP BY T.AREA_NO,
                T.CITY_NO,
                T.HUAXIAO_TYPE_BIG,
                T.HUAXIAO_TYPE,
                T.TYPE_ONE,
                T.TYPE_TWO;
    COMMIT;

    --天翼高清网上
    INSERT INTO MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_ADMIN
      SELECT MAX(T.ACCT_MONTH) ACCT_MONTH,
             T.AREA_NO,
             T.CITY_NO,
             T.HUAXIAO_TYPE_BIG,
             T.HUAXIAO_TYPE,
             T.TYPE_ONE,
             T.TYPE_TWO,
             SUM(T.Onnet_Iptv_Num),
             SUM(T.LAST_MONTH_VALUE),
             SUM(T.YEAR_VALUE)
        FROM (SELECT T.ACCT_MONTH,
                     T.AREA_NO,
                     T.CITY_NO,
                     '1' HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     '06' TYPE_ONE,
                     '01' TYPE_TWO,
                     SUM(T.Onnet_Iptv_Num) Onnet_Iptv_Num,
                     0 LAST_MONTH_VALUE,
                     SUM(T.Onnet_Iptv_Num) YEAR_VALUE
                FROM ALLDM.TMP_V_HUAXIAO_INFO_M T
               WHERE T.ACCT_MONTH = V_ACCT_MONTH
               GROUP BY T.ACCT_MONTH, T.AREA_NO, T.CITY_NO, T.HUAXIAO_TYPE
              UNION ALL
              SELECT T.ACCT_MONTH,
                     T.AREA_NO,
                     T.CITY_NO,
                     T.HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.TYPE_ONE,
                     T.TYPE_TWO,
                     0,
                     T.MONTH_VALUE,
                     0 YEAR_VALUE
                FROM MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_ADMIN T
               WHERE ACCT_MONTH = V_LAST_MONTH
                 AND T.TYPE_ONE = '06'
                 AND T.TYPE_TWO = '01') T
       GROUP BY T.AREA_NO,
                T.CITY_NO,
                T.HUAXIAO_TYPE_BIG,
                T.HUAXIAO_TYPE,
                T.TYPE_ONE,
                T.TYPE_TWO;
    COMMIT;

    --移动出账
    INSERT INTO MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_ADMIN
      SELECT MAX(T.ACCT_MONTH) ACCT_MONTH,
             T.AREA_NO,
             T.CITY_NO,
             T.HUAXIAO_TYPE_BIG,
             T.HUAXIAO_TYPE,
             T.TYPE_ONE,
             T.TYPE_TWO,
             SUM(T.Acct_Cdma_Num),
             SUM(T.LAST_MONTH_VALUE),
             SUM(T.YEAR_VALUE)
        FROM (SELECT T.ACCT_MONTH,
                     T.AREA_NO,
                     T.CITY_NO,
                     '1' HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     '07' TYPE_ONE,
                     '01' TYPE_TWO,
                     SUM(T.Acct_Cdma_Num) Acct_Cdma_Num,
                     0 LAST_MONTH_VALUE,
                     SUM(T.Acct_Cdma_Num) YEAR_VALUE
                FROM ALLDM.TMP_V_HUAXIAO_INFO_M T
               WHERE T.ACCT_MONTH = V_ACCT_MONTH
               GROUP BY T.ACCT_MONTH, T.AREA_NO, T.CITY_NO, T.HUAXIAO_TYPE
              UNION ALL
              SELECT T.ACCT_MONTH,
                     T.AREA_NO,
                     T.CITY_NO,
                     T.HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.TYPE_ONE,
                     T.TYPE_TWO,
                     0,
                     T.MONTH_VALUE,
                     0 YEAR_VALUE
                FROM MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_ADMIN T
               WHERE ACCT_MONTH = V_LAST_MONTH
                 AND T.TYPE_ONE = '07'
                 AND T.TYPE_TWO = '01') T
       GROUP BY T.AREA_NO,
                T.CITY_NO,
                T.HUAXIAO_TYPE_BIG,
                T.HUAXIAO_TYPE,
                T.TYPE_ONE,
                T.TYPE_TWO;
    COMMIT;

    --宽带出账
    INSERT INTO MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_ADMIN
      SELECT MAX(T.ACCT_MONTH) ACCT_MONTH,
             T.AREA_NO,
             T.CITY_NO,
             T.HUAXIAO_TYPE_BIG,
             T.HUAXIAO_TYPE,
             T.TYPE_ONE,
             T.TYPE_TWO,
             SUM(T.Acct_Adsl_Num),
             SUM(T.LAST_MONTH_VALUE),
             SUM(T.YEAR_VALUE)
        FROM (SELECT T.ACCT_MONTH,
                     T.AREA_NO,
                     T.CITY_NO,
                     '1' HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     '08' TYPE_ONE,
                     '01' TYPE_TWO,
                     SUM(T.Acct_Adsl_Num) Acct_Adsl_Num,
                     0 LAST_MONTH_VALUE,
                     SUM(T.Acct_Adsl_Num) YEAR_VALUE
                FROM ALLDM.TMP_V_HUAXIAO_INFO_M T
               WHERE T.ACCT_MONTH = V_ACCT_MONTH
               GROUP BY T.ACCT_MONTH, T.AREA_NO, T.CITY_NO, T.HUAXIAO_TYPE
              UNION ALL
              SELECT T.ACCT_MONTH,
                     T.AREA_NO,
                     T.CITY_NO,
                     T.HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.TYPE_ONE,
                     T.TYPE_TWO,
                     0,
                     T.MONTH_VALUE,
                     0 YEAR_VALUE
                FROM MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_ADMIN T
               WHERE ACCT_MONTH = V_LAST_MONTH
                 AND T.TYPE_ONE = '08'
                 AND T.TYPE_TWO = '01') T
       GROUP BY T.AREA_NO,
                T.CITY_NO,
                T.HUAXIAO_TYPE_BIG,
                T.HUAXIAO_TYPE,
                T.TYPE_ONE,
                T.TYPE_TWO;
    COMMIT;

    --天翼高清出账
    INSERT INTO MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_ADMIN
      SELECT MAX(T.ACCT_MONTH) ACCT_MONTH,
             T.AREA_NO,
             T.CITY_NO,
             T.HUAXIAO_TYPE_BIG,
             T.HUAXIAO_TYPE,
             T.TYPE_ONE,
             T.TYPE_TWO,
             SUM(T.Acct_Iptv_Num),
             SUM(T.LAST_MONTH_VALUE),
             SUM(T.YEAR_VALUE)
        FROM (SELECT T.ACCT_MONTH,
                     T.AREA_NO,
                     T.CITY_NO,
                     '1' HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     '09' TYPE_ONE,
                     '01' TYPE_TWO,
                     SUM(T.Acct_Iptv_Num) Acct_Iptv_Num,
                     0 LAST_MONTH_VALUE,
                     SUM(T.Acct_Iptv_Num) YEAR_VALUE
                FROM ALLDM.TMP_V_HUAXIAO_INFO_M T
               WHERE T.ACCT_MONTH = V_ACCT_MONTH
               GROUP BY T.ACCT_MONTH, T.AREA_NO, T.CITY_NO, T.HUAXIAO_TYPE
              UNION ALL
              SELECT T.ACCT_MONTH,
                     T.AREA_NO,
                     T.CITY_NO,
                     T.HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.TYPE_ONE,
                     T.TYPE_TWO,
                     0,
                     T.MONTH_VALUE,
                     0 YEAR_VALUE
                FROM MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_ADMIN T
               WHERE ACCT_MONTH = V_LAST_MONTH
                 AND T.TYPE_ONE = '09'
                 AND T.TYPE_TWO = '01') T
       GROUP BY T.AREA_NO,
                T.CITY_NO,
                T.HUAXIAO_TYPE_BIG,
                T.HUAXIAO_TYPE,
                T.TYPE_ONE,
                T.TYPE_TWO;
    COMMIT;
    --更新日志
    V_RETCODE := 'SUCCESS';
    ALLDM.P_ALLDM_UPDATE_LOG(V_ACCT_MONTH,
                             V_PKG,
                             V_PROCNAME,
                             '结束',
                             V_RETCODE,
                             SYSDATE);
    DBMS_OUTPUT.PUT_LINE(V_RETCODE);
    ------------------------------------- 数据部分结束 -------------------------
  ELSE
    V_RETCODE := 'WAIT';
    ALLDM.P_ALLDM_UPDATE_LOG(V_ACCT_MONTH,
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
    ALLDM.P_ALLDM_UPDATE_LOG(V_ACCT_MONTH,
                             V_PKG,
                             V_PROCNAME,
                             V_RETINFO,
                             V_RETCODE,
                             SYSDATE);
END;
/
