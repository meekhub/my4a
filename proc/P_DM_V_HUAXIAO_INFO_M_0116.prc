CREATE OR REPLACE PROCEDURE P_DM_V_HUAXIAO_INFO_M(V_ACCT_MONTH VARCHAR2,
                                                        V_RETCODE    OUT VARCHAR2,
                                                        V_RETINFO    OUT VARCHAR2) IS
  /*****************************************************************
  *名称 --%NAME:P_DM_V_HUAXIAO_INFO_M
  *功能描述 --%COMMENT:
  *执行周期 --%PERIOD: 月
  *参数 --%PARAM:V_ACCT_MONTH  日期,格式YYYYMM
  *参数 --%PARAM:V_RETCODE  过程运行结束成功与否标志
  *参数 --%PARAM:V_RETCODE  过程运行结束成功与否描述
  *创建人 --%CREATOR:LIANGZHITAO
  *创建时间 --%CREATED_TIME:2017-10-19
  *备注 --%REMARK:
  *来源表 --%FROM:  DW.DW_V_USER_HUAXIAO_INFO_M
  *目标表 --%TO:   ALLDM.DM_V_HUAXIAO_INFO_M
  *修改记录 --%MODIFY:
  *******************************************************************/
  V_PKG      VARCHAR2(40);
  V_PROCNAME VARCHAR2(40);
  V_COUNT    NUMBER;
  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018';
BEGIN
  V_PKG      := '划小单元数据';
  V_PROCNAME := 'P_DM_V_HUAXIAO_INFO_M';

  SELECT COUNT(1)
    INTO V_COUNT
    FROM DW.DW_EXECUTE_LOG A
   WHERE A.ACCT_MONTH = V_ACCT_MONTH
     AND A.PROCNAME IN ('P_DW_V_USER_HUAXIAO_INFO_M')
     AND A.RESULT = 'SUCCESS';

  --插入日志
  P_ALLDM_INSERT_LOG(V_ACCT_MONTH, V_PKG, V_PROCNAME, '12', SYSDATE);

  IF V_COUNT = 1 THEN

    --============================== 划小单元数据 ===========================================

    --删除当月数据
    DELETE FROM ALLDM.DM_V_HUAXIAO_INFO_M WHERE ACCT_MONTH = V_ACCT_MONTH;
    COMMIT;
    --正式数据
    FOR C1 IN V_AREA LOOP
      DELETE FROM ALLDM.DM_V_HUAXIAO_INFO_M
       WHERE ACCT_MONTH = V_ACCT_MONTH
         AND AREA_NO = C1.AREA_NO;
      COMMIT;
      ---自营厅
      INSERT /*+APPEND*/
      INTO ALLDM.DM_V_HUAXIAO_INFO_M
        SELECT V_ACCT_MONTH ACCT_MONTH,
               T.AREA_NO,
               T.CITY_NO,
               T.HUAXIAO_TYPE,
               T.HUAXIAO_NO,
               T.HUAXIAO_NAME,
               SUM(T.NEW_NUM),
               SUM(T.CDMA_NUM),
               SUM(T.ADSL_NUM),
               SUM(T.IPTV_NUM),
               SUM(T.PRICE_FEE),
               SUM(T.PRICE_FEE_YEAR),
               SUM(T.DEVLP_SORE),
               SUM(T.INCOME_SORE),
               SUM(T.WEIXI_SORE),
               SUM(T.FINE_SORE),
               SUM(T.GIVE_SORE),
               SUM(T.SUM_SORE),
               SUM(ONNET_CDMA_NUM) ONNET_CDMA_NUM,
               SUM(ONNET_ADSL_NUM) ONNET_ADSL_NUM,
               SUM(ONNET_IPTV_NUM) ONNET_IPTV_NUM,
               SUM(ACCT_CDMA_NUM) ACCT_CDMA_NUM,
               SUM(ACCT_ADSL_NUM) ACCT_ADSL_NUM,
               SUM(ACCT_IPTV_NUM) ACCT_IPTV_NUM,
               SUM(SCHOOL_DEVLP_SORE) SCHOOL_DEVLP_SORE,
               SUM(SCHOOL_INCOME_SORE) SCHOOL_INCOME_SORE,
               SUM(SCHOOL_WEIXI_SORE) SCHOOL_WEIXI_SORE,
               SUM(SCHOOL_FINE_SORE) SCHOOL_FINE_SORE,
               SUM(SCHOOL_GIVE_SORE) SCHOOL_GIVE_SORE,
               SUM(SCHOOL_SUM_SORE) SCHOOL_SUM_SORE
          FROM (SELECT T.AREA_NO,
                       T.CITY_NO,
                       T.HUAXIAO_TYPE,
                       T.HUAXIAO_NO,
                       T.HUAXIAO_NAME,
                       SUM(NEW_NUM) NEW_NUM,
                       SUM(CDMA_NUM) CDMA_NUM,
                       SUM(ADSL_NUM) ADSL_NUM,
                       SUM(IPTV_NUM) IPTV_NUM,
                       SUM(PRICE_FEE) PRICE_FEE,
                       SUM(PRICE_FEE_YEAR) PRICE_FEE_YEAR,
                       0 DEVLP_SORE,
                       0 INCOME_SORE,
                       0 WEIXI_SORE,
                       0 FINE_SORE,
                       0 GIVE_SORE,
                       0 SUM_SORE,
                       SUM(ONNET_CDMA_NUM) ONNET_CDMA_NUM,
                       SUM(ONNET_ADSL_NUM) ONNET_ADSL_NUM,
                       SUM(ONNET_IPTV_NUM) ONNET_IPTV_NUM,
                       SUM(ACCT_CDMA_NUM) ACCT_CDMA_NUM,
                       SUM(ACCT_ADSL_NUM) ACCT_ADSL_NUM,
                       SUM(ACCT_IPTV_NUM) ACCT_IPTV_NUM,
                       0 SCHOOL_DEVLP_SORE,
                       0 SCHOOL_INCOME_SORE,
                       0 SCHOOL_WEIXI_SORE,
                       0 SCHOOL_FINE_SORE,
                       0 SCHOOL_GIVE_SORE,
                       0 SCHOOL_SUM_SORE
                  FROM (SELECT T.AREA_NO,
                               T.CITY_NO,
                               T.HUAXIAO_TYPE,
                               T.HUAXIAO_NO,
                               T.HUAXIAO_NAME,
                               A.CDMA_NUM + A.ADSL_NUM + A.IPTV_NUM NEW_NUM,
                               A.CDMA_NUM,
                               A.ADSL_NUM,
                               A.IPTV_NUM,
                               NVL(A.PRICE_FEE, 0) PRICE_FEE,
                               NVL(A.PRICE_FEE_YEAR, 0) PRICE_FEE_YEAR,
                               NVL(A.ONNET_CDMA_NUM, 0) ONNET_CDMA_NUM,
                               NVL(A.ONNET_ADSL_NUM, 0) ONNET_ADSL_NUM,
                               NVL(A.ONNET_IPTV_NUM, 0) ONNET_IPTV_NUM,
                               NVL(A.ACCT_CDMA_NUM, 0) ACCT_CDMA_NUM,
                               NVL(A.ACCT_ADSL_NUM, 0) ACCT_ADSL_NUM,
                               NVL(A.ACCT_IPTV_NUM, 0) ACCT_IPTV_NUM
                          FROM (SELECT SUM(CASE
                                             WHEN A.TELE_TYPE = '2' AND
                                                  A.IS_NEW = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) CDMA_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE IN ('4', '26') AND A.INNET_METHOD IN ('1','2','4','5','15') AND
                                                  A.IS_NEW = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) ADSL_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '72' AND
                                                  A.IS_NEW = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) IPTV_NUM,
                                       SUM(NVL(A.PRICE_FEE, 0)) +
                                       SUM(NVL(A.PRICE_FEE_OCS, 0)) -
                                       SUM(NVL(A.IOT_FEE, 0)) PRICE_FEE,
                                       SUM(CASE
                                             WHEN TO_CHAR(A.INNET_DATE, 'YYYY') =
                                                  SUBSTR(V_ACCT_MONTH, 1, 4) THEN
                                              NVL(A.PRICE_FEE, 0) +
                                              NVL(A.PRICE_FEE_OCS, 0) -
                                              NVL(A.IOT_FEE, 0)
                                           END) PRICE_FEE_YEAR,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '2' AND A.IS_ONNET = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) ONNET_CDMA_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE IN ('4', '26') AND A.INNET_METHOD IN ('1','2','4','5','15') AND A.IS_ONNET = '1'  THEN
                                              1
                                             ELSE
                                              0
                                           END) ONNET_ADSL_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '72' AND A.IS_ONNET = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) ONNET_IPTV_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '2' AND (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                                              1
                                             ELSE
                                              0
                                           END) ACCT_CDMA_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE IN ('4', '26') AND A.INNET_METHOD IN ('1','2','4','5','15') AND
                                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                                              1
                                             ELSE
                                              0
                                           END) ACCT_ADSL_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '72' AND (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                                              1
                                             ELSE
                                              0
                                           END) ACCT_IPTV_NUM,
                                       A.HUAXIAO_NO_01
                                  FROM DW.DW_V_USER_HUAXIAO_INFO_M A
                                 WHERE A.ACCT_MONTH = V_ACCT_MONTH
                                   AND AREA_NO = C1.AREA_NO
                                      --AND A.IS_VALID = '1'
                                   AND A.IS_HUAXIAO_01 = '1'
                                 GROUP BY A.HUAXIAO_NO_01) A,
                               (SELECT *
                                  FROM DIM.DIM_HUAXIAO_INFO T
                                 WHERE T.AREA_NO = C1.AREA_NO
                                   AND T.HUAXIAO_TYPE IN
                                       ('01', '02', '03', '04')) T
                         WHERE A.HUAXIAO_NO_01 = T.HUAXIAO_NO
                        UNION ALL
                        ---商圈
                        SELECT T.AREA_NO,
                               T.CITY_NO,
                               T.HUAXIAO_TYPE,
                               T.HUAXIAO_NO,
                               T.HUAXIAO_NAME,
                               A.CDMA_NUM + A.ADSL_NUM + A.IPTV_NUM NEW_NUM,
                               A.CDMA_NUM,
                               A.ADSL_NUM,
                               A.IPTV_NUM,
                               NVL(A.PRICE_FEE, 0) PRICE_FEE,
                               NVL(A.PRICE_FEE_YEAR, 0) PRICE_FEE_YEAR,
                               NVL(A.ONNET_CDMA_NUM, 0) ONNET_CDMA_NUM,
                               NVL(A.ONNET_ADSL_NUM, 0) ONNET_ADSL_NUM,
                               NVL(A.ONNET_IPTV_NUM, 0) ONNET_IPTV_NUM,
                               NVL(A.ACCT_CDMA_NUM, 0) ACCT_CDMA_NUM,
                               NVL(A.ACCT_ADSL_NUM, 0) ACCT_ADSL_NUM,
                               NVL(A.ACCT_IPTV_NUM, 0) ACCT_IPTV_NUM
                          FROM (SELECT SUM(CASE
                                             WHEN A.TELE_TYPE = '2' AND
                                                  A.IS_NEW = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) CDMA_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE IN ('4', '26') AND A.INNET_METHOD IN ('1','2','4','5','15') AND
                                                  A.IS_NEW = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) ADSL_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '72' AND
                                                  A.IS_NEW = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) IPTV_NUM,
                                       SUM(NVL(A.PRICE_FEE, 0)) +
                                       SUM(NVL(A.PRICE_FEE_OCS, 0)) -
                                       SUM(NVL(A.IOT_FEE, 0)) PRICE_FEE,
                                       SUM(CASE
                                             WHEN TO_CHAR(A.INNET_DATE, 'YYYY') =
                                                  SUBSTR(V_ACCT_MONTH, 1, 4) THEN
                                              NVL(A.PRICE_FEE, 0) +
                                              NVL(A.PRICE_FEE_OCS, 0) -
                                              NVL(A.IOT_FEE, 0)
                                           END) PRICE_FEE_YEAR,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '2' AND A.IS_ONNET = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) ONNET_CDMA_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE IN ('4', '26') AND A.INNET_METHOD IN ('1','2','4','5','15') AND A.IS_ONNET = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) ONNET_ADSL_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '72' AND A.IS_ONNET = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) ONNET_IPTV_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '2' AND (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                                              1
                                             ELSE
                                              0
                                           END) ACCT_CDMA_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE IN ('4', '26') AND A.INNET_METHOD IN ('1','2','4','5','15') AND
                                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                                              1
                                             ELSE
                                              0
                                           END) ACCT_ADSL_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '72' AND (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                                              1
                                             ELSE
                                              0
                                           END) ACCT_IPTV_NUM,
                                       A.HUAXIAO_NO_02
                                  FROM DW.DW_V_USER_HUAXIAO_INFO_M A
                                 WHERE A.ACCT_MONTH = V_ACCT_MONTH
                                   AND AREA_NO = C1.AREA_NO
                                      --AND A.IS_VALID = '1'
                                   AND A.IS_HUAXIAO_02 = '1'
                                 GROUP BY A.HUAXIAO_NO_02) A,
                               (SELECT *
                                  FROM DIM.DIM_HUAXIAO_INFO T
                                 WHERE T.AREA_NO = C1.AREA_NO
                                   AND T.HUAXIAO_TYPE IN
                                       ('01', '02', '03', '04')) T
                         WHERE A.HUAXIAO_NO_02 = T.HUAXIAO_NO
                        UNION ALL
                        ---社区支局
                        SELECT T.AREA_NO,
                               T.CITY_NO,
                               T.HUAXIAO_TYPE,
                               T.HUAXIAO_NO,
                               T.HUAXIAO_NAME,
                               A.CDMA_NUM + A.ADSL_NUM + A.IPTV_NUM NEW_NUM,
                               A.CDMA_NUM,
                               A.ADSL_NUM,
                               A.IPTV_NUM,
                               NVL(A.PRICE_FEE, 0) PRICE_FEE,
                               NVL(A.PRICE_FEE_YEAR, 0) PRICE_FEE_YEAR,
                               NVL(A.ONNET_CDMA_NUM, 0) ONNET_CDMA_NUM,
                               NVL(A.ONNET_ADSL_NUM, 0) ONNET_ADSL_NUM,
                               NVL(A.ONNET_IPTV_NUM, 0) ONNET_IPTV_NUM,
                               NVL(A.ACCT_CDMA_NUM, 0) ACCT_CDMA_NUM,
                               NVL(A.ACCT_ADSL_NUM, 0) ACCT_ADSL_NUM,
                               NVL(A.ACCT_IPTV_NUM, 0) ACCT_IPTV_NUM
                          FROM (SELECT SUM(CASE
                                             WHEN A.TELE_TYPE = '2' AND
                                                  A.IS_NEW = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) CDMA_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE IN ('4', '26') AND A.INNET_METHOD IN ('1','2','4','5','15') AND
                                                  A.IS_NEW = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) ADSL_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '72' AND
                                                  A.IS_NEW = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) IPTV_NUM,
                                       SUM(NVL(A.PRICE_FEE, 0)) +
                                       SUM(NVL(A.PRICE_FEE_OCS, 0)) -
                                       SUM(NVL(A.IOT_FEE, 0)) PRICE_FEE,
                                       SUM(CASE
                                             WHEN TO_CHAR(A.INNET_DATE, 'YYYY') =
                                                  SUBSTR(V_ACCT_MONTH, 1, 4) THEN
                                              NVL(A.PRICE_FEE, 0) +
                                              NVL(A.PRICE_FEE_OCS, 0) -
                                              NVL(A.IOT_FEE, 0)
                                           END) PRICE_FEE_YEAR,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '2' AND A.IS_ONNET = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) ONNET_CDMA_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE IN ('4', '26') AND A.INNET_METHOD IN ('1','2','4','5','15') AND A.IS_ONNET = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) ONNET_ADSL_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '72' AND A.IS_ONNET = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) ONNET_IPTV_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '2' AND (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                                              1
                                             ELSE
                                              0
                                           END) ACCT_CDMA_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE IN ('4', '26') AND A.INNET_METHOD IN ('1','2','4','5','15') AND
                                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                                              1
                                             ELSE
                                              0
                                           END) ACCT_ADSL_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '72' AND (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                                              1
                                             ELSE
                                              0
                                           END) ACCT_IPTV_NUM,
                                       A.HUAXIAO_NO_03
                                  FROM DW.DW_V_USER_HUAXIAO_INFO_M A
                                 WHERE A.ACCT_MONTH = V_ACCT_MONTH
                                   AND AREA_NO = C1.AREA_NO
                                      --AND A.IS_VALID = '1'
                                   AND A.IS_HUAXIAO_03 = '1'
                                 GROUP BY A.HUAXIAO_NO_03) A,
                               (SELECT *
                                  FROM DIM.DIM_HUAXIAO_INFO T
                                 WHERE T.AREA_NO = C1.AREA_NO
                                   AND T.HUAXIAO_TYPE IN
                                       ('01', '02', '03', '04')) T
                         WHERE A.HUAXIAO_NO_03 = T.HUAXIAO_NO
                        UNION ALL
                        ---农村支局
                        SELECT T.AREA_NO,
                               T.CITY_NO,
                               T.HUAXIAO_TYPE,
                               T.HUAXIAO_NO,
                               T.HUAXIAO_NAME,
                               A.CDMA_NUM + A.ADSL_NUM + A.IPTV_NUM NEW_NUM,
                               A.CDMA_NUM,
                               A.ADSL_NUM,
                               A.IPTV_NUM,
                               NVL(A.PRICE_FEE, 0) PRICE_FEE,
                               NVL(A.PRICE_FEE_YEAR, 0) PRICE_FEE_YEAR,
                               NVL(A.ONNET_CDMA_NUM, 0) ONNET_CDMA_NUM,
                               NVL(A.ONNET_ADSL_NUM, 0) ONNET_ADSL_NUM,
                               NVL(A.ONNET_IPTV_NUM, 0) ONNET_IPTV_NUM,
                               NVL(A.ACCT_CDMA_NUM, 0) ACCT_CDMA_NUM,
                               NVL(A.ACCT_ADSL_NUM, 0) ACCT_ADSL_NUM,
                               NVL(A.ACCT_IPTV_NUM, 0) ACCT_IPTV_NUM
                          FROM (SELECT SUM(CASE
                                             WHEN A.TELE_TYPE = '2' AND
                                                  A.IS_NEW = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) CDMA_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE IN ('4', '26') AND A.INNET_METHOD IN ('1','2','4','5','15') AND
                                                  A.IS_NEW = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) ADSL_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '72' AND
                                                  A.IS_NEW = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) IPTV_NUM,
                                       SUM(NVL(A.PRICE_FEE, 0)) +
                                       SUM(NVL(A.PRICE_FEE_OCS, 0)) PRICE_FEE,
                                       SUM(CASE
                                             WHEN TO_CHAR(A.INNET_DATE, 'YYYY') =
                                                  SUBSTR(V_ACCT_MONTH, 1, 4) THEN
                                              NVL(A.PRICE_FEE, 0) +
                                              NVL(A.PRICE_FEE_OCS, 0)
                                           END) PRICE_FEE_YEAR,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '2' AND A.IS_ONNET = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) ONNET_CDMA_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE IN ('4', '26') AND A.INNET_METHOD IN ('1','2','4','5','15') AND A.IS_ONNET = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) ONNET_ADSL_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '72' AND A.IS_ONNET = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) ONNET_IPTV_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '2' AND (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                                              1
                                             ELSE
                                              0
                                           END) ACCT_CDMA_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE IN ('4', '26') AND A.INNET_METHOD IN ('1','2','4','5','15') AND
                                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                                              1
                                             ELSE
                                              0
                                           END) ACCT_ADSL_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '72' AND (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                                              1
                                             ELSE
                                              0
                                           END) ACCT_IPTV_NUM,
                                       A.HUAXIAO_NO_04
                                  FROM DW.DW_V_USER_HUAXIAO_INFO_M A
                                 WHERE A.ACCT_MONTH = V_ACCT_MONTH
                                   AND AREA_NO = C1.AREA_NO
                                      --AND A.IS_VALID = '1'
                                   AND A.IS_HUAXIAO_04 = '1'
                                 GROUP BY A.HUAXIAO_NO_04) A,
                               (SELECT *
                                  FROM DIM.DIM_HUAXIAO_INFO T
                                 WHERE T.AREA_NO = C1.AREA_NO
                                   AND T.HUAXIAO_TYPE IN
                                       ('01', '02', '03', '04')) T
                         WHERE A.HUAXIAO_NO_04 = T.HUAXIAO_NO) T
                 GROUP BY T.AREA_NO,
                          T.CITY_NO,
                          T.HUAXIAO_TYPE,
                          T.HUAXIAO_NO,
                          T.HUAXIAO_NAME
                UNION ALL
                SELECT T.AREA_NO,
                       T.CITY_NO,
                       T.HUAXIAO_TYPE,
                       T.HUAXIAO_NO,
                       T.HUAXIAO_NAME,
                       0,
                       0,
                       0,
                       0,
                       0,
                       0,
                       SUM(C.DEVLP_SORE),
                       SUM(C.INCOME_SORE),
                       SUM(C.WEIXI_SORE),
                       SUM(C.FINE_SORE),
                       0,
                       SUM(C.SUM_SORE),
                       0,
                       0,
                       0,
                       0,
                       0,
                       0,
                       SUM(DEV_SCORE_ALL_SCHOOL),
                       SUM(INCOME_SCORE_ALL_SCHOOL),
                       SUM(WEIXI_SCORE_ALL_SCHOOL),
                       SUM(FINE_SCORE_ALL_SCHOOL),
                       0 SCHOOL_GIVE_SORE,
                       SUM(JF_SCORE_ALL_SCHOOL)
                  FROM (SELECT C.CHANNEL_NO,
                               DEV_SCORE_ALL as DEVLP_SORE,
                               INCOME_SCORE_ALL as INCOME_SORE,
                               WEIXI_SCORE_ALL as WEIXI_SORE,
                               FINE_SCORE_ALL as FINE_SORE,
                               JF_SCORE_ALL as SUM_SORE,
                               DEV_SCORE_ALL_SCHOOL,
                               INCOME_SCORE_ALL_SCHOOL,
                               WEIXI_SCORE_ALL_SCHOOL,
                               FINE_SCORE_ALL_SCHOOL,
                               JF_SCORE_ALL_SCHOOL
                          FROM RPT_HBTELE.SJZX_WH_CHANNEL_JF_SCORE_010_M C
                         WHERE C.ACCT_MONTH = V_ACCT_MONTH
                           AND C.AREA_NO = C1.AREA_NO) C,
                       (SELECT *
                          FROM DIM.DIM_CHANNEL_HUAXIAO T
                         WHERE T.AREA_NO = C1.AREA_NO
                           AND T.HUAXIAO_TYPE IN ('01', '02', '03', '04')) T
                 WHERE C.CHANNEL_NO = T.CHANNEL_NO
                 GROUP BY T.AREA_NO,
                          T.CITY_NO,
                          T.HUAXIAO_TYPE,
                          T.HUAXIAO_NO,
                          T.HUAXIAO_NAME) T
         GROUP BY T.AREA_NO,
                  T.CITY_NO,
                  T.HUAXIAO_TYPE,
                  T.HUAXIAO_NO,
                  T.HUAXIAO_NAME;
      COMMIT;
    END LOOP;
    --更新日志
    V_RETCODE := 'SUCCESS';
    P_ALLDM_UPDATE_LOG(V_ACCT_MONTH,
                       V_PKG,
                       V_PROCNAME,
                       '结束',
                       'SUCCESS',
                       SYSDATE);

  ELSE
    V_RETCODE := 'WAIT';
    P_ALLDM_UPDATE_LOG(V_ACCT_MONTH,
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
    P_ALLDM_UPDATE_LOG(V_ACCT_MONTH,
                       V_PKG,
                       V_PROCNAME,
                       V_RETINFO,
                       'FAIL',
                       SYSDATE);

END;
/
