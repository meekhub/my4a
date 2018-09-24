CREATE OR REPLACE PROCEDURE ALLDM.P_DM_ZQ_CHANNEL_HUAXIAO_M(V_ACCT_MONTH VARCHAR2,
                                                   V_RETCODE    OUT VARCHAR2,
                                                   V_RETINFO    OUT VARCHAR2) IS
  /*****************************************************************
  *名称 --%NAME:P_DM_ZQ_CHANNEL_HUAXIAO_M
  *功能描述 --%COMMENT:
  *执行周期 --%PERIOD: 月
  *参数 --%PARAM:V_ACCT_MONTH  日期,格式YYYYMM
  *参数 --%PARAM:V_RETCODE  过程运行结束成功与否标志
  *参数 --%PARAM:V_RETCODE  过程运行结束成功与否描述
  *创建人 --%CREATOR:MAJIANHUI
  *创建时间 --%CREATED_TIME:2018-4-20
  *备注 --%REMARK:
  *来源表 --%FROM:  DW.DW_V_USER_HUAXIAO_INFO_M
  *目标表 --%TO:   ALLDM.DM_ZQ_CHANNEL_HUAXIAO_M
  *修改记录 --%MODIFY:
  *******************************************************************/
  V_PKG      VARCHAR2(40);
  V_PROCNAME VARCHAR2(40);
  V_COUNT    NUMBER;
  V_LAST_MONTH VARCHAR2(40);
  V_CURR_YEAR VARCHAR2(40);
  V_LAST_YEAR VARCHAR2(40);
  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018';
BEGIN
  V_PKG      := '划小单元数据';
  V_PROCNAME := 'P_DM_ZQ_CHANNEL_HUAXIAO_M';
  V_LAST_MONTH      := TO_CHAR(ADD_MONTHS(TO_DATE(V_ACCT_MONTH, 'YYYYMM'), -1),
                           'YYYYMM');
  V_LAST_YEAR      := SUBSTR(TO_CHAR(ADD_MONTHS(TO_DATE(V_ACCT_MONTH, 'YYYYMM'), -12),
                           'YYYYMM'),1,4)||'12';
  V_CURR_YEAR      := SUBSTR(V_ACCT_MONTH,1,4);

  SELECT COUNT(1)
    INTO V_COUNT
    FROM DW.DW_EXECUTE_LOG A
   WHERE A.ACCT_MONTH = V_ACCT_MONTH
     AND A.PROCNAME IN ('P_DW_V_USER_HUAXIAO_INFO_M')
     AND A.RESULT = 'SUCCESS';

  --插入日志
  P_ALLDM_INSERT_LOG(V_ACCT_MONTH, V_PKG, V_PROCNAME, '12', SYSDATE);

  IF V_COUNT >= 1 THEN

    --============================== 划小单元数据 ===========================================

    --删除当月数据
    DELETE FROM ALLDM.DM_ZQ_CHANNEL_HUAXIAO_M WHERE ACCT_MONTH = V_ACCT_MONTH;
    COMMIT;
    --正式数据
    FOR C1 IN V_AREA LOOP
      DELETE FROM ALLDM.DM_ZQ_CHANNEL_HUAXIAO_M
       WHERE ACCT_MONTH = V_ACCT_MONTH
         AND AREA_NO = C1.AREA_NO;
      COMMIT;

      ---自营厅
      INSERT /*+APPEND*/
      INTO ALLDM.DM_ZQ_CHANNEL_HUAXIAO_M
    SELECT 
       V_ACCT_MONTH,
       AREA_NO,
       CITY_NO,
       HUAXIAO_TYPE,
       HUAXIAO_NO,
       HUAXIAO_NAME,
       CHANNEL_NO,
       CHANNEL_NO_DESC,
       SUM(TOTAL_FEE) TOTAL_FEE,
       SUM(TOTAL_FEE_CL) TOTAL_FEE_CL,
       SUM(ONNET_CDMA_NUM) ONNET_CDMA_NUM,
       SUM(ACCT_CDMA_NUM) ACCT_CDMA_NUM,
       SUM(ACCT_CDMA_NUM_CL) ACCT_CDMA_NUM_CL,
       SUM(CDMA_NEW) CDMA_NEW,
       SUM(CDMA_NEW_YEAR) CDMA_NEW_YEAR,
       SUM(JZ_CDMA_NUM) JZ_CDMA_NUM,
       SUM(ONNET_ADSL_NUM) ONNET_ADSL_NUM,
       SUM(ACCT_ADSL_NUM) ACCT_ADSL_NUM,
       SUM(ACCT_ADSL_NUM_CL) ACCT_ADSL_NUM_CL,
       SUM(ADSL_NEW) ADSL_NEW,
       SUM(ADSL_NEW_YEAR) ADSL_NEW_YEAR,
       SUM(JZ_ADSL_NUM) JZ_ADSL_NUM,
       SUM(ONNET_IPTV_NUM) ONNET_IPTV_NUM,
       SUM(ACCT_IPTV_NUM) ACCT_IPTV_NUM,
       SUM(ACCT_IPTV_NUM_CL) ACCT_IPTV_NUM_CL,
       SUM(IPTV_NEW) IPTV_NEW,
       SUM(IPTV_NEW_YEAR) IPTV_NEW_YEAR,
       SUM(JZ_IPTV_NUM) JZ_IPTV_NUM,
       SUM(ONNET_ZXDL_NUM) ONNET_ZXDL_NUM,
       SUM(ACCT_ZXDL_NUM) ACCT_ZXDL_NUM,
       SUM(ACCT_ZXDL_NUM_CL) ACCT_ZXDL_NUM_CL,
       SUM(ZXDL_NEW) ZXDL_NEW,
       SUM(ZXDL_NEW_YEAR) ZXDL_NEW_YEAR,
       SUM(JZ_ZXDL_NUM) JZ_ZXDL_NUM,
       SUM(ONNET_GH_NUM) ONNET_GH_NUM,
       SUM(ACCT_GH_NUM) ACCT_GH_NUM,
       SUM(ACCT_GH_NUM_CL) ACCT_GH_NUM_CL,
       SUM(GH_NEW) GH_NEW,
       SUM(GH_NEW_YEAR) GH_NEW_YEAR,
       SUM(JZ_GH_NUM) JZ_GH_NUM,
       SUM(ONNET_XX_NUM) ONNET_XX_NUM,
       SUM(ACCT_XX_NUM) ACCT_XX_NUM,
       SUM(ACCT_XX_NUM_CL) ACCT_XX_NUM_CL,
       SUM(XX_NEW) XX_NEW,
       SUM(XX_NEW_YEAR) XX_NEW_YEAR,
       SUM(JZ_XX_NUM) JZ_XX_NUM,
       NVL(SUM(QFCS_FEE),0) QFCS_FEE,
       NVL(SUM(XMFC_FEE),0) XMFC_FEE,
       XIAOQU_CHANNEL
  FROM (
       SELECT T.AREA_NO,
               T.CITY_NO,
               T.HUAXIAO_TYPE,
               T.HUAXIAO_NO,
               T.HUAXIAO_NAME,
               T.CHANNEL_NO,
               T.CHANNEL_NO_DESC,
               SUM(A.PRICE_FEE) TOTAL_FEE,
               SUM(A.TOTAL_FEE_CL) TOTAL_FEE_CL,
               SUM(ONNET_CDMA_NUM) ONNET_CDMA_NUM,
               SUM(ACCT_CDMA_NUM) ACCT_CDMA_NUM,
               SUM(ACCT_CDMA_NUM_CL) ACCT_CDMA_NUM_CL,
               SUM(CDMA_NEW) CDMA_NEW,
               SUM(CDMA_NEW_YEAR) CDMA_NEW_YEAR,
               SUM(ACCT_CDMA_NUM) JZ_CDMA_NUM,
               SUM(ONNET_ADSL_NUM) ONNET_ADSL_NUM,
               SUM(ACCT_ADSL_NUM) ACCT_ADSL_NUM,
               SUM(ACCT_ADSL_NUM_CL) ACCT_ADSL_NUM_CL,
               SUM(ADSL_NEW) ADSL_NEW,
               SUM(ADSL_NEW_YEAR) ADSL_NEW_YEAR,
               SUM(ONNET_ADSL_NUM) JZ_ADSL_NUM,
               SUM(ONNET_IPTV_NUM) ONNET_IPTV_NUM,
               SUM(ACCT_IPTV_NUM) ACCT_IPTV_NUM,
               SUM(ACCT_IPTV_NUM_CL) ACCT_IPTV_NUM_CL,
               SUM(IPTV_NEW) IPTV_NEW,
               SUM(IPTV_NEW_YEAR) IPTV_NEW_YEAR,
               SUM(ONNET_IPTV_NUM) JZ_IPTV_NUM,
               SUM(ONNET_ZXDL_NUM) ONNET_ZXDL_NUM,
               SUM(ACCT_ZXDL_NUM) ACCT_ZXDL_NUM,
               SUM(ACCT_ZXDL_NUM_CL) ACCT_ZXDL_NUM_CL,
               SUM(ZXDL_NEW) ZXDL_NEW,
               SUM(ZXDL_NEW_YEAR) ZXDL_NEW_YEAR,
               SUM(ONNET_ZXDL_NUM) JZ_ZXDL_NUM,
               SUM(ONNET_GH_NUM) ONNET_GH_NUM,
               SUM(ACCT_GH_NUM) ACCT_GH_NUM,
               SUM(ACCT_GH_NUM_CL) ACCT_GH_NUM_CL,
               SUM(GH_NEW) GH_NEW,
               SUM(GH_NEW_YEAR) GH_NEW_YEAR,
               0 JZ_GH_NUM,
               0 ONNET_XX_NUM,
               0 ACCT_XX_NUM,
               0 ACCT_XX_NUM_CL,
               0 XX_NEW,
               0 XX_NEW_YEAR,
               0 JZ_XX_NUM,
               SUM(QFCS_FEE) QFCS_FEE,
               SUM(XMFC_FEE) XMFC_FEE,
               '渠道' XIAOQU_CHANNEL
          FROM (SELECT A.HUAXIAO_NO_05,
                       A.CHANNEL_NO, 
                       -- C网
                       SUM(NVL(A.PRICE_FEE, 0)) +
                       SUM(NVL(A.PRICE_FEE_OCS, 0)) AS PRICE_FEE,
                       SUM(CASE
                             WHEN TO_CHAR(A.INNET_DATE, 'YYYYMM') <= V_LAST_YEAR THEN
                              NVL(A.PRICE_FEE, 0) + NVL(A.PRICE_FEE_OCS, 0)
                             ELSE
                              0
                           END) TOTAL_FEE_CL,
                       SUM(CASE
                             WHEN A.TELE_TYPE = '2' AND A.IS_ONNET = '1' THEN
                              1
                             ELSE
                              0
                           END) ONNET_CDMA_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE = '2' AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                              1
                             ELSE
                              0
                           END) ACCT_CDMA_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE = '2' AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                                  TO_CHAR(A.INNET_DATE, 'YYYYMM') <= V_LAST_YEAR THEN
                              1
                             ELSE
                              0
                           END) ACCT_CDMA_NUM_CL,
                       SUM(CASE
                             WHEN A.TELE_TYPE = '2' AND A.IS_NEW = '1' THEN
                              1
                             ELSE
                              0
                           END) CDMA_NEW,
                       SUM(CASE
                             WHEN A.TELE_TYPE = '2' AND
                                  TO_CHAR(A.INNET_DATE, 'YYYY') = V_CURR_YEAR THEN
                              1
                             ELSE
                              0
                           END) CDMA_NEW_YEAR,

                       --宽带
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G010' AND A.IS_ONNET = '1' THEN
                              1
                             ELSE
                              0
                           END) ONNET_ADSL_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G010' AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                              1
                             ELSE
                              0
                           END) ACCT_ADSL_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G010' AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                                  TO_CHAR(A.INNET_DATE, 'YYYYMM') <= V_LAST_YEAR THEN
                              1
                             ELSE
                              0
                           END) ACCT_ADSL_NUM_CL,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G010' AND A.IS_NEW = '1' THEN
                              1
                             ELSE
                              0
                           END) ADSL_NEW,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G010' AND
                                  TO_CHAR(A.INNET_DATE, 'YYYY') = V_CURR_YEAR THEN
                              1
                             ELSE
                              0
                           END) ADSL_NEW_YEAR,
                       --IPTV
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G110' AND A.IS_ONNET = '1' THEN
                              1
                             ELSE
                              0
                           END) ONNET_IPTV_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G110' AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                              1
                             ELSE
                              0
                           END) ACCT_IPTV_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G110' AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                                  TO_CHAR(A.INNET_DATE, 'YYYYMM') <= V_LAST_YEAR THEN
                              1
                             ELSE
                              0
                           END) ACCT_IPTV_NUM_CL,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G110' AND A.IS_NEW = '1' THEN
                              1
                             ELSE
                              0
                           END) IPTV_NEW,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G110' AND
                                  TO_CHAR(A.INNET_DATE, 'YYYY') = V_CURR_YEAR THEN
                              1
                             ELSE
                              0
                           END) IPTV_NEW_YEAR,
                       --专线电路
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                                  A.IS_ONNET = '1' THEN
                              1
                             ELSE
                              0
                           END) ONNET_ZXDL_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                              1
                             ELSE
                              0
                           END) ACCT_ZXDL_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                                  TO_CHAR(A.INNET_DATE, 'YYYYMM') <= V_LAST_YEAR THEN
                              1
                             ELSE
                              0
                           END) ACCT_ZXDL_NUM_CL,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                                  A.IS_NEW = '1' THEN
                              1
                             ELSE
                              0
                           END) ZXDL_NEW,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                                  TO_CHAR(A.INNET_DATE, 'YYYY') = V_CURR_YEAR THEN
                              1
                             ELSE
                              0
                           END) ZXDL_NEW_YEAR,
                       --固话
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                                  A.IS_ONNET = '1' THEN
                              1
                             ELSE
                              0
                           END) ONNET_GH_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                              1
                             ELSE
                              0
                           END) ACCT_GH_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                                  TO_CHAR(A.INNET_DATE, 'YYYYMM') <= V_LAST_YEAR THEN
                              1
                             ELSE
                              0
                           END) ACCT_GH_NUM_CL,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                                  A.IS_NEW = '1' THEN
                              1
                             ELSE
                              0
                           END) GH_NEW,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                                  TO_CHAR(A.INNET_DATE, 'YYYY') = V_CURR_YEAR THEN
                              1
                             ELSE
                              0
                           END) GH_NEW_YEAR,
                       SUM(A.QFCS_FEE) QFCS_FEE,
                       SUM(A.XMFC_FEE) XMFC_FEE 
                  FROM DW.DW_V_USER_HUAXIAO_INFO_ALL A
                 WHERE A.ACCT_MONTH = V_ACCT_MONTH
                   AND AREA_NO = C1.AREA_NO
                   AND A.TELE_TYPE = '2'
                   AND A.XIAOQU_NO IS NULL
                   AND A.IS_HUAXIAO_05 = '1'
                 GROUP BY A.HUAXIAO_NO_05,A.CHANNEL_NO) A,
               (SELECT *
                  FROM DIM.DIM_ZQ_CHANNEL_HUAXIAO T
                 WHERE T.AREA_NO = C1.AREA_NO
                   AND T.HUAXIAO_TYPE = '05') T
         WHERE A.HUAXIAO_NO_05 = T.HUAXIAO_NO
         AND A.CHANNEL_NO=T.CHANNEL_NO
         GROUP BY T.AREA_NO,
                  T.CITY_NO,
                  T.HUAXIAO_TYPE,
                  T.HUAXIAO_NO,
                  T.HUAXIAO_NAME,
                  T.CHANNEL_NO,
                  T.CHANNEL_NO_DESC
                  
                  UNION ALL 
       SELECT T.AREA_NO,
               T.CITY_NO,
               T.HUAXIAO_TYPE,
               T.HUAXIAO_NO,
               T.HUAXIAO_NAME,
               T.xiaoqu_no,
               T.xiaoqu_name,
               SUM(A.PRICE_FEE) TOTAL_FEE,
               SUM(A.TOTAL_FEE_CL) TOTAL_FEE_CL,
               SUM(ONNET_CDMA_NUM) ONNET_CDMA_NUM,
               SUM(ACCT_CDMA_NUM) ACCT_CDMA_NUM,
               SUM(ACCT_CDMA_NUM_CL) ACCT_CDMA_NUM_CL,
               SUM(CDMA_NEW) CDMA_NEW,
               SUM(CDMA_NEW_YEAR) CDMA_NEW_YEAR,
               SUM(ACCT_CDMA_NUM) JZ_CDMA_NUM,
               SUM(ONNET_ADSL_NUM) ONNET_ADSL_NUM,
               SUM(ACCT_ADSL_NUM) ACCT_ADSL_NUM,
               SUM(ACCT_ADSL_NUM_CL) ACCT_ADSL_NUM_CL,
               SUM(ADSL_NEW) ADSL_NEW,
               SUM(ADSL_NEW_YEAR) ADSL_NEW_YEAR,
               SUM(ONNET_ADSL_NUM) JZ_ADSL_NUM,
               SUM(ONNET_IPTV_NUM) ONNET_IPTV_NUM,
               SUM(ACCT_IPTV_NUM) ACCT_IPTV_NUM,
               SUM(ACCT_IPTV_NUM_CL) ACCT_IPTV_NUM_CL,
               SUM(IPTV_NEW) IPTV_NEW,
               SUM(IPTV_NEW_YEAR) IPTV_NEW_YEAR,
               SUM(ONNET_IPTV_NUM) JZ_IPTV_NUM,
               SUM(ONNET_ZXDL_NUM) ONNET_ZXDL_NUM,
               SUM(ACCT_ZXDL_NUM) ACCT_ZXDL_NUM,
               SUM(ACCT_ZXDL_NUM_CL) ACCT_ZXDL_NUM_CL,
               SUM(ZXDL_NEW) ZXDL_NEW,
               SUM(ZXDL_NEW_YEAR) ZXDL_NEW_YEAR,
               SUM(ONNET_ZXDL_NUM) JZ_ZXDL_NUM,
               SUM(ONNET_GH_NUM) ONNET_GH_NUM,
               SUM(ACCT_GH_NUM) ACCT_GH_NUM,
               SUM(ACCT_GH_NUM_CL) ACCT_GH_NUM_CL,
               SUM(GH_NEW) GH_NEW,
               SUM(GH_NEW_YEAR) GH_NEW_YEAR,
               0 JZ_GH_NUM,
               0 ONNET_XX_NUM,
               0 ACCT_XX_NUM,
               0 ACCT_XX_NUM_CL,
               0 XX_NEW,
               0 XX_NEW_YEAR,
               0 JZ_XX_NUM,
               SUM(QFCS_FEE) QFCS_FEE,
               SUM(XMFC_FEE) XMFC_FEE,
               '小区' XIAOQU_CHANNEL
          FROM (SELECT A.HUAXIAO_NO_05,
                       A.xiaoqu_no, 
                       -- C网
                       SUM(NVL(A.PRICE_FEE, 0)) +
                       SUM(NVL(A.PRICE_FEE_OCS, 0)) AS PRICE_FEE,
                       SUM(CASE
                             WHEN TO_CHAR(A.INNET_DATE, 'YYYYMM') <= V_LAST_YEAR THEN
                              NVL(A.PRICE_FEE, 0) + NVL(A.PRICE_FEE_OCS, 0)
                             ELSE
                              0
                           END) TOTAL_FEE_CL,
                       SUM(CASE
                             WHEN A.TELE_TYPE = '2' AND A.IS_ONNET = '1' THEN
                              1
                             ELSE
                              0
                           END) ONNET_CDMA_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE = '2' AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                              1
                             ELSE
                              0
                           END) ACCT_CDMA_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE = '2' AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                                  TO_CHAR(A.INNET_DATE, 'YYYYMM') <= V_LAST_YEAR THEN
                              1
                             ELSE
                              0
                           END) ACCT_CDMA_NUM_CL,
                       SUM(CASE
                             WHEN A.TELE_TYPE = '2' AND A.IS_NEW = '1' THEN
                              1
                             ELSE
                              0
                           END) CDMA_NEW,
                       SUM(CASE
                             WHEN A.TELE_TYPE = '2' AND
                                  TO_CHAR(A.INNET_DATE, 'YYYY') = V_CURR_YEAR THEN
                              1
                             ELSE
                              0
                           END) CDMA_NEW_YEAR,

                       --宽带
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G010' AND A.IS_ONNET = '1' THEN
                              1
                             ELSE
                              0
                           END) ONNET_ADSL_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G010' AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                              1
                             ELSE
                              0
                           END) ACCT_ADSL_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G010' AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                                  TO_CHAR(A.INNET_DATE, 'YYYYMM') <= V_LAST_YEAR THEN
                              1
                             ELSE
                              0
                           END) ACCT_ADSL_NUM_CL,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G010' AND A.IS_NEW = '1' THEN
                              1
                             ELSE
                              0
                           END) ADSL_NEW,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G010' AND
                                  TO_CHAR(A.INNET_DATE, 'YYYY') = V_CURR_YEAR THEN
                              1
                             ELSE
                              0
                           END) ADSL_NEW_YEAR,
                       --IPTV
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G110' AND A.IS_ONNET = '1' THEN
                              1
                             ELSE
                              0
                           END) ONNET_IPTV_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G110' AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                              1
                             ELSE
                              0
                           END) ACCT_IPTV_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G110' AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                                  TO_CHAR(A.INNET_DATE, 'YYYYMM') <= V_LAST_YEAR THEN
                              1
                             ELSE
                              0
                           END) ACCT_IPTV_NUM_CL,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G110' AND A.IS_NEW = '1' THEN
                              1
                             ELSE
                              0
                           END) IPTV_NEW,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G110' AND
                                  TO_CHAR(A.INNET_DATE, 'YYYY') = V_CURR_YEAR THEN
                              1
                             ELSE
                              0
                           END) IPTV_NEW_YEAR,
                       --专线电路
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                                  A.IS_ONNET = '1' THEN
                              1
                             ELSE
                              0
                           END) ONNET_ZXDL_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                              1
                             ELSE
                              0
                           END) ACCT_ZXDL_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                                  TO_CHAR(A.INNET_DATE, 'YYYYMM') <= V_LAST_YEAR THEN
                              1
                             ELSE
                              0
                           END) ACCT_ZXDL_NUM_CL,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                                  A.IS_NEW = '1' THEN
                              1
                             ELSE
                              0
                           END) ZXDL_NEW,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                                  TO_CHAR(A.INNET_DATE, 'YYYY') = V_CURR_YEAR THEN
                              1
                             ELSE
                              0
                           END) ZXDL_NEW_YEAR,
                       --固话
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                                  A.IS_ONNET = '1' THEN
                              1
                             ELSE
                              0
                           END) ONNET_GH_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                              1
                             ELSE
                              0
                           END) ACCT_GH_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                                  TO_CHAR(A.INNET_DATE, 'YYYYMM') <= V_LAST_YEAR THEN
                              1
                             ELSE
                              0
                           END) ACCT_GH_NUM_CL,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                                  A.IS_NEW = '1' THEN
                              1
                             ELSE
                              0
                           END) GH_NEW,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                                  TO_CHAR(A.INNET_DATE, 'YYYY') = V_CURR_YEAR THEN
                              1
                             ELSE
                              0
                           END) GH_NEW_YEAR,
                       SUM(A.QFCS_FEE) QFCS_FEE,
                       SUM(A.XMFC_FEE) XMFC_FEE 
                  FROM DW.DW_V_USER_HUAXIAO_INFO_ALL A
                 WHERE A.ACCT_MONTH = V_ACCT_MONTH
                   AND AREA_NO = C1.AREA_NO
                   AND ((A.XIAOQU_NO IS NOT NULL AND
                         A.TELE_TYPE = '2') OR
                         A.TELE_TYPE <> '2')
                   AND A.IS_HUAXIAO_05 = '1'
                 GROUP BY A.HUAXIAO_NO_05,A.xiaoqu_no) A,
               (SELECT *
                  FROM DIM.Dim_Zq_Xiaoqu_Huaxiao T
                 WHERE T.AREA_NO = C1.AREA_NO
                   AND T.HUAXIAO_TYPE = '05') T
         WHERE A.HUAXIAO_NO_05 = T.HUAXIAO_NO
         AND A.Xiaoqu_No=T.Xiaoqu_No
         GROUP BY T.AREA_NO,
                  T.CITY_NO,
                  T.HUAXIAO_TYPE,
                  T.HUAXIAO_NO,
                  T.HUAXIAO_NAME,
                  T.xiaoqu_no,
                  T.xiaoqu_name
                  
        UNION ALL
        --营维
        SELECT T.AREA_NO,
               T.CITY_NO,
               T.HUAXIAO_TYPE,
               T.HUAXIAO_NO,
               T.HUAXIAO_NAME,
               T.CHANNEL_NO,
               T.CHANNEL_NO_DESC,
               SUM(A.PRICE_FEE) PRICE_FEE,
               SUM(A.TOTAL_FEE_CL) TOTAL_FEE_CL,
               SUM(ONNET_CDMA_NUM) ONNET_CDMA_NUM,
               SUM(ACCT_CDMA_NUM) ACCT_CDMA_NUM,
               SUM(ACCT_CDMA_NUM_CL) ACCT_CDMA_NUM_CL,
               SUM(CDMA_NEW) CDMA_NEW,
               SUM(CDMA_NEW_YEAR) CDMA_NEW_YEAR,
               SUM(ACCT_CDMA_NUM) JZ_CDMA_NUM,
               SUM(ONNET_ADSL_NUM) ONNET_ADSL_NUM,
               SUM(ACCT_ADSL_NUM) ACCT_ADSL_NUM,
               SUM(ACCT_ADSL_NUM_CL) ACCT_ADSL_NUM_CL,
               SUM(ADSL_NEW) ADSL_NEW,
               SUM(ADSL_NEW_YEAR) ADSL_NEW_YEAR,
               SUM(ONNET_ADSL_NUM) JZ_ADSL_NUM,
               SUM(ONNET_IPTV_NUM) ONNET_IPTV_NUM,
               SUM(ACCT_IPTV_NUM) ACCT_IPTV_NUM,
               SUM(ACCT_IPTV_NUM_CL) ACCT_IPTV_NUM_CL,
               SUM(IPTV_NEW) IPTV_NEW,
               SUM(IPTV_NEW_YEAR) IPTV_NEW_YEAR,
               SUM(ONNET_IPTV_NUM) JZ_IPTV_NUM,
               SUM(ONNET_ZXDL_NUM) ONNET_ZXDL_NUM,
               SUM(ACCT_ZXDL_NUM) ACCT_ZXDL_NUM,
               SUM(ACCT_ZXDL_NUM_CL) ACCT_ZXDL_NUM_CL,
               SUM(ZXDL_NEW) ZXDL_NEW,
               SUM(ZXDL_NEW_YEAR) ZXDL_NEW_YEAR,
               SUM(ONNET_ZXDL_NUM) JZ_ZXDL_NUM,
               SUM(ONNET_GH_NUM) ONNET_GH_NUM,
               SUM(ACCT_GH_NUM) ACCT_GH_NUM,
               SUM(ACCT_GH_NUM_CL) ACCT_GH_NUM_CL,
               SUM(GH_NEW) GH_NEW,
               SUM(GH_NEW_YEAR) GH_NEW_YEAR,
               0 JZ_GH_NUM,
               0 ONNET_XX_NUM,
               0 ACCT_XX_NUM,
               0 ACCT_XX_NUM_CL,
               0 XX_NEW,
               0 XX_NEW_YEAR,
               0 JZ_XX_NUM,
               SUM(QFCS_FEE) QFCS_FEE,
               SUM(XMFC_FEE) XMFC_FEE,
               '发展人' XIAOQU_CHANNEL
          FROM (SELECT A.HUAXIAO_NO_06,
                       A.CHANNEL_NO, 
                       -- C网
                       SUM(NVL(A.PRICE_FEE, 0)) +
                       SUM(NVL(A.PRICE_FEE_OCS, 0)) AS PRICE_FEE,
                       SUM(CASE
                             WHEN TO_CHAR(A.INNET_DATE, 'YYYYMM') <= V_LAST_YEAR THEN
                              NVL(A.PRICE_FEE, 0) + NVL(A.PRICE_FEE_OCS, 0)
                             ELSE
                              0
                           END) TOTAL_FEE_CL,
                       SUM(CASE
                             WHEN A.TELE_TYPE = '2' AND A.IS_ONNET = '1' THEN
                              1
                             ELSE
                              0
                           END) ONNET_CDMA_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE = '2' AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                              1
                             ELSE
                              0
                           END) ACCT_CDMA_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE = '2' AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                                  TO_CHAR(A.INNET_DATE, 'YYYYMM') <= V_LAST_YEAR THEN
                              1
                             ELSE
                              0
                           END) ACCT_CDMA_NUM_CL,
                       SUM(CASE
                             WHEN A.TELE_TYPE = '2' AND A.IS_NEW = '1' THEN
                              1
                             ELSE
                              0
                           END) CDMA_NEW,
                       SUM(CASE
                             WHEN A.TELE_TYPE = '2' AND
                                  TO_CHAR(A.INNET_DATE, 'YYYY') = V_CURR_YEAR THEN
                              1
                             ELSE
                              0
                           END) CDMA_NEW_YEAR,

                       --宽带
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G010' AND A.IS_ONNET = '1' THEN
                              1
                             ELSE
                              0
                           END) ONNET_ADSL_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G010' AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                              1
                             ELSE
                              0
                           END) ACCT_ADSL_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G010' AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                                  TO_CHAR(A.INNET_DATE, 'YYYYMM') <= V_LAST_YEAR THEN
                              1
                             ELSE
                              0
                           END) ACCT_ADSL_NUM_CL,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G010' AND A.IS_NEW = '1' THEN
                              1
                             ELSE
                              0
                           END) ADSL_NEW,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G010' AND
                                  TO_CHAR(A.INNET_DATE, 'YYYY') = V_CURR_YEAR THEN
                              1
                             ELSE
                              0
                           END) ADSL_NEW_YEAR,
                       --IPTV
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G110' AND A.IS_ONNET = '1' THEN
                              1
                             ELSE
                              0
                           END) ONNET_IPTV_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G110' AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                              1
                             ELSE
                              0
                           END) ACCT_IPTV_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G110' AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                                  TO_CHAR(A.INNET_DATE, 'YYYYMM') <= V_LAST_YEAR THEN
                              1
                             ELSE
                              0
                           END) ACCT_IPTV_NUM_CL,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G110' AND A.IS_NEW = '1' THEN
                              1
                             ELSE
                              0
                           END) IPTV_NEW,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G110' AND
                                  TO_CHAR(A.INNET_DATE, 'YYYY') = V_CURR_YEAR THEN
                              1
                             ELSE
                              0
                           END) IPTV_NEW_YEAR,
                       --专线电路
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                                  A.IS_ONNET = '1' THEN
                              1
                             ELSE
                              0
                           END) ONNET_ZXDL_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                              1
                             ELSE
                              0
                           END) ACCT_ZXDL_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                                  TO_CHAR(A.INNET_DATE, 'YYYYMM') <= V_LAST_YEAR THEN
                              1
                             ELSE
                              0
                           END) ACCT_ZXDL_NUM_CL,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                                  A.IS_NEW = '1' THEN
                              1
                             ELSE
                              0
                           END) ZXDL_NEW,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                                  TO_CHAR(A.INNET_DATE, 'YYYY') = V_CURR_YEAR THEN
                              1
                             ELSE
                              0
                           END) ZXDL_NEW_YEAR,
                       --固话
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                                  A.IS_ONNET = '1' THEN
                              1
                             ELSE
                              0
                           END) ONNET_GH_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                              1
                             ELSE
                              0
                           END) ACCT_GH_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                                  TO_CHAR(A.INNET_DATE, 'YYYYMM') <= V_LAST_YEAR THEN
                              1
                             ELSE
                              0
                           END) ACCT_GH_NUM_CL,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                                  A.IS_NEW = '1' THEN
                              1
                             ELSE
                              0
                           END) GH_NEW,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                                  TO_CHAR(A.INNET_DATE, 'YYYY') = V_CURR_YEAR THEN
                              1
                             ELSE
                              0
                           END) GH_NEW_YEAR,
                       SUM(A.QFCS_FEE) QFCS_FEE,
                       SUM(A.XMFC_FEE) XMFC_FEE
                  FROM DW.DW_V_USER_HUAXIAO_INFO_ALL A
                 WHERE A.ACCT_MONTH = V_ACCT_MONTH
                   AND AREA_NO = C1.AREA_NO
                   AND A.IS_HUAXIAO_06 = '1'
                 GROUP BY A.HUAXIAO_NO_06,A.CHANNEL_NO) A,
               (SELECT *
                  FROM DIM.Dim_Zq_Channel_Huaxiao T
                 WHERE T.AREA_NO = C1.AREA_NO
                   AND T.HUAXIAO_TYPE = '06') T
         WHERE A.HUAXIAO_NO_06 = T.HUAXIAO_NO
         AND A.CHANNEL_NO=T.CHANNEL_NO
         GROUP BY T.AREA_NO,
                  T.CITY_NO,
                  T.HUAXIAO_TYPE,
                  T.HUAXIAO_NO,
                  T.HUAXIAO_NAME,
                  T.CHANNEL_NO,
                  T.CHANNEL_NO_DESC
        UNION ALL
        --校园
        SELECT T.AREA_NO,
               T.CITY_NO,
               T.HUAXIAO_TYPE,
               T.HUAXIAO_NO,
               T.HUAXIAO_NAME,
               T.CHANNEL_NO,
               T.CHANNEL_NO_DESC,
               SUM(A.PRICE_FEE) PRICE_FEE,
               SUM(A.TOTAL_FEE_CL) TOTAL_FEE_CL,
               SUM(ONNET_CDMA_NUM) ONNET_CDMA_NUM,
               SUM(ACCT_CDMA_NUM) ACCT_CDMA_NUM,
               SUM(ACCT_CDMA_NUM_CL) ACCT_CDMA_NUM_CL,
               SUM(CDMA_NEW) CDMA_NEW,
               SUM(CDMA_NEW_YEAR) CDMA_NEW_YEAR,
               SUM(ACCT_CDMA_NUM) JZ_CDMA_NUM,
               SUM(ONNET_ADSL_NUM) ONNET_ADSL_NUM,
               SUM(ACCT_ADSL_NUM) ACCT_ADSL_NUM,
               SUM(ACCT_ADSL_NUM_CL) ACCT_ADSL_NUM_CL,
               SUM(ADSL_NEW) ADSL_NEW,
               SUM(ADSL_NEW_YEAR) ADSL_NEW_YEAR,
               SUM(ONNET_ADSL_NUM) JZ_ADSL_NUM,
               SUM(ONNET_IPTV_NUM) ONNET_IPTV_NUM,
               SUM(ACCT_IPTV_NUM) ACCT_IPTV_NUM,
               SUM(ACCT_IPTV_NUM_CL) ACCT_IPTV_NUM_CL,
               SUM(IPTV_NEW) IPTV_NEW,
               SUM(IPTV_NEW_YEAR) IPTV_NEW_YEAR,
               SUM(ONNET_IPTV_NUM) JZ_IPTV_NUM,
               SUM(ONNET_ZXDL_NUM) ONNET_ZXDL_NUM,
               SUM(ACCT_ZXDL_NUM) ACCT_ZXDL_NUM,
               SUM(ACCT_ZXDL_NUM_CL) ACCT_ZXDL_NUM_CL,
               SUM(ZXDL_NEW) ZXDL_NEW,
               SUM(ZXDL_NEW_YEAR) ZXDL_NEW_YEAR,
               SUM(ONNET_ZXDL_NUM) JZ_ZXDL_NUM,
               SUM(ONNET_GH_NUM) ONNET_GH_NUM,
               SUM(ACCT_GH_NUM) ACCT_GH_NUM,
               SUM(ACCT_GH_NUM_CL) ACCT_GH_NUM_CL,
               SUM(GH_NEW) GH_NEW,
               SUM(GH_NEW_YEAR) GH_NEW_YEAR,
               0 JZ_GH_NUM,
               0 ONNET_XX_NUM,
               0 ACCT_XX_NUM,
               0 ACCT_XX_NUM_CL,
               0 XX_NEW,
               0 XX_NEW_YEAR,
               0 JZ_XX_NUM,
               SUM(QFCS_FEE) QFCS_FEE,
               SUM(XMFC_FEE) XMFC_FEE，
               '集团' XIAOQU_CHANNEL
          FROM (SELECT A.HUAXIAO_NO_07,
                       A.CHANNEL_NO, 
                       -- C网
                       SUM(NVL(A.PRICE_FEE, 0)) +
                       SUM(NVL(A.PRICE_FEE_OCS, 0)) AS PRICE_FEE,
                       SUM(CASE
                             WHEN TO_CHAR(A.INNET_DATE, 'YYYYMM') <= V_LAST_YEAR THEN
                              NVL(A.PRICE_FEE, 0) + NVL(A.PRICE_FEE_OCS, 0)
                             ELSE
                              0
                           END) TOTAL_FEE_CL,
                       SUM(CASE
                             WHEN A.TELE_TYPE = '2' AND A.IS_ONNET = '1' THEN
                              1
                             ELSE
                              0
                           END) ONNET_CDMA_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE = '2' AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                              1
                             ELSE
                              0
                           END) ACCT_CDMA_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE = '2' AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                                  TO_CHAR(A.INNET_DATE, 'YYYYMM') <= V_LAST_YEAR THEN
                              1
                             ELSE
                              0
                           END) ACCT_CDMA_NUM_CL,
                       SUM(CASE
                             WHEN A.TELE_TYPE = '2' AND A.IS_NEW = '1' THEN
                              1
                             ELSE
                              0
                           END) CDMA_NEW,
                       SUM(CASE
                             WHEN A.TELE_TYPE = '2' AND
                                  TO_CHAR(A.INNET_DATE, 'YYYY') = V_CURR_YEAR THEN
                              1
                             ELSE
                              0
                           END) CDMA_NEW_YEAR,

                       --宽带
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G010' AND A.IS_ONNET = '1' THEN
                              1
                             ELSE
                              0
                           END) ONNET_ADSL_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G010' AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                              1
                             ELSE
                              0
                           END) ACCT_ADSL_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G010' AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                                  TO_CHAR(A.INNET_DATE, 'YYYYMM') <= V_LAST_YEAR THEN
                              1
                             ELSE
                              0
                           END) ACCT_ADSL_NUM_CL,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G010' AND A.IS_NEW = '1' THEN
                              1
                             ELSE
                              0
                           END) ADSL_NEW,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G010' AND
                                  TO_CHAR(A.INNET_DATE, 'YYYY') = V_CURR_YEAR THEN
                              1
                             ELSE
                              0
                           END) ADSL_NEW_YEAR,
                       --IPTV
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G110' AND A.IS_ONNET = '1' THEN
                              1
                             ELSE
                              0
                           END) ONNET_IPTV_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G110' AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                              1
                             ELSE
                              0
                           END) ACCT_IPTV_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G110' AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                                  TO_CHAR(A.INNET_DATE, 'YYYYMM') <= V_LAST_YEAR THEN
                              1
                             ELSE
                              0
                           END) ACCT_IPTV_NUM_CL,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G110' AND A.IS_NEW = '1' THEN
                              1
                             ELSE
                              0
                           END) IPTV_NEW,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW = 'G110' AND
                                  TO_CHAR(A.INNET_DATE, 'YYYY') = V_CURR_YEAR THEN
                              1
                             ELSE
                              0
                           END) IPTV_NEW_YEAR,
                       --专线电路
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                                  A.IS_ONNET = '1' THEN
                              1
                             ELSE
                              0
                           END) ONNET_ZXDL_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                              1
                             ELSE
                              0
                           END) ACCT_ZXDL_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                                  TO_CHAR(A.INNET_DATE, 'YYYYMM') <= V_LAST_YEAR THEN
                              1
                             ELSE
                              0
                           END) ACCT_ZXDL_NUM_CL,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                                  A.IS_NEW = '1' THEN
                              1
                             ELSE
                              0
                           END) ZXDL_NEW,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                                  TO_CHAR(A.INNET_DATE, 'YYYY') = V_CURR_YEAR THEN
                              1
                             ELSE
                              0
                           END) ZXDL_NEW_YEAR,
                       --固话
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                                  A.IS_ONNET = '1' THEN
                              1
                             ELSE
                              0
                           END) ONNET_GH_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') THEN
                              1
                             ELSE
                              0
                           END) ACCT_GH_NUM,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                                  (A.IS_ACCT = '1' OR A.IS_ACCT_OCS = '1') AND
                                  TO_CHAR(A.INNET_DATE, 'YYYYMM') <= V_LAST_YEAR THEN
                              1
                             ELSE
                              0
                           END) ACCT_GH_NUM_CL,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                                  A.IS_NEW = '1' THEN
                              1
                             ELSE
                              0
                           END) GH_NEW,
                       SUM(CASE
                             WHEN A.TELE_TYPE_NEW IN ('G000', 'G001', 'G002') AND
                                  TO_CHAR(A.INNET_DATE, 'YYYY') = V_CURR_YEAR THEN
                              1
                             ELSE
                              0
                           END) GH_NEW_YEAR,
                       SUM(A.QFCS_FEE) QFCS_FEE,
                       SUM(A.XMFC_FEE) XMFC_FEE
                  FROM DW.DW_V_USER_HUAXIAO_INFO_ALL A
                 WHERE A.ACCT_MONTH = V_ACCT_MONTH
                   AND AREA_NO = C1.AREA_NO
                   AND A.IS_HUAXIAO_07 = '1'
                 GROUP BY A.HUAXIAO_NO_07,A.CHANNEL_NO) A,
               (SELECT *
                  FROM DIM.DIM_ZQ_GROUP_HUAXIAO T
                 WHERE T.AREA_NO = C1.AREA_NO
                   AND T.HUAXIAO_TYPE = '07') T
         WHERE A.HUAXIAO_NO_07 = T.HUAXIAO_NO
         AND A.CHANNEL_NO=T.CHANNEL_NO
         GROUP BY T.AREA_NO,
                  T.CITY_NO,
                  T.HUAXIAO_TYPE,
                  T.HUAXIAO_NO,
                  T.HUAXIAO_NAME,
                  T.CHANNEL_NO,
                  T.CHANNEL_NO_DESC
                  UNION ALL
                  --物联网
                    SELECT T.AREA_NO,
                           T.CITY_NO,
                           T.HUAXIAO_TYPE,
                           T.HUAXIAO_NO,
                           T.HUAXIAO_NAME,
                           T.CHANNEL_NO,
                           T.CHANNEL_NO_DESC,
                           SUM(A.PRICE_FEE) PRICE_FEE,
                           SUM(A.TOTAL_FEE_CL) TOTAL_FEE_CL,
                           SUM(ONNET_CDMA_NUM) ONNET_CDMA_NUM,
                           SUM(ACCT_CDMA_NUM) ACCT_CDMA_NUM,
                           SUM(ACCT_CDMA_NUM_CL) ACCT_CDMA_NUM_CL,
                           SUM(CDMA_NEW) CDMA_NEW,
                           SUM(CDMA_NEW_YEAR) CDMA_NEW_YEAR,
                           SUM(ACCT_CDMA_NUM) JZ_CDMA_NUM,
                           SUM(ONNET_ADSL_NUM) ONNET_ADSL_NUM,
                           SUM(ACCT_ADSL_NUM) ACCT_ADSL_NUM,
                           SUM(ACCT_ADSL_NUM_CL) ACCT_ADSL_NUM_CL,
                           SUM(ADSL_NEW) ADSL_NEW,
                           SUM(ADSL_NEW_YEAR) ADSL_NEW_YEAR,
                           SUM(ONNET_ADSL_NUM) JZ_ADSL_NUM,
                           SUM(ONNET_IPTV_NUM) ONNET_IPTV_NUM,
                           SUM(ACCT_IPTV_NUM) ACCT_IPTV_NUM,
                           SUM(ACCT_IPTV_NUM_CL) ACCT_IPTV_NUM_CL,
                           SUM(IPTV_NEW) IPTV_NEW,
                           SUM(IPTV_NEW_YEAR) IPTV_NEW_YEAR,
                           SUM(ONNET_IPTV_NUM) JZ_IPTV_NUM,
                           SUM(ONNET_ZXDL_NUM) ONNET_ZXDL_NUM,
                           SUM(ACCT_ZXDL_NUM) ACCT_ZXDL_NUM,
                           SUM(ACCT_ZXDL_NUM_CL) ACCT_ZXDL_NUM_CL,
                           SUM(ZXDL_NEW) ZXDL_NEW,
                           SUM(ZXDL_NEW_YEAR) ZXDL_NEW_YEAR,
                           SUM(ONNET_ZXDL_NUM) JZ_ZXDL_NUM,
                           SUM(ONNET_GH_NUM) ONNET_GH_NUM,
                           SUM(ACCT_GH_NUM) ACCT_GH_NUM,
                           SUM(ACCT_GH_NUM_CL) ACCT_GH_NUM_CL,
                           SUM(GH_NEW) GH_NEW,
                           SUM(GH_NEW_YEAR) GH_NEW_YEAR,
                           0 JZ_GH_NUM,
                           0 ONNET_XX_NUM,
                           0 ACCT_XX_NUM,
                           0 ACCT_XX_NUM_CL,
                           0 XX_NEW,
                           0 XX_NEW_YEAR,
                           0 JZ_XX_NUM,
                           SUM(QFCS_FEE) QFCS_FEE,
                           SUM(XMFC_FEE) XMFC_FEE,
                           '分公司' XIAOQU_CHANNEL
                      FROM (SELECT A.HUAXIAO_NO_08,
                                   A.CHANNEL_NO, 
                                   -- C网
                                   SUM(NVL(A.PRICE_FEE, 0)) +
                                   SUM(NVL(A.PRICE_FEE_OCS, 0)) AS PRICE_FEE,
                                   SUM(CASE
                                         WHEN TO_CHAR(A.INNET_DATE, 'YYYYMM') <=
                                              V_LAST_YEAR THEN
                                          NVL(A.PRICE_FEE, 0) +
                                          NVL(A.PRICE_FEE_OCS, 0)
                                         ELSE
                                          0
                                       END) TOTAL_FEE_CL,
                                   SUM(CASE
                                         WHEN A.TELE_TYPE = '2' AND
                                              A.IS_ONNET = '1' THEN
                                          1
                                         ELSE
                                          0
                                       END) ONNET_CDMA_NUM,
                                   SUM(CASE
                                         WHEN A.TELE_TYPE = '2' AND
                                              (A.IS_ACCT = '1' OR
                                              A.IS_ACCT_OCS = '1') THEN
                                          1
                                         ELSE
                                          0
                                       END) ACCT_CDMA_NUM,
                                   SUM(CASE
                                         WHEN A.TELE_TYPE = '2' AND
                                              (A.IS_ACCT = '1' OR
                                              A.IS_ACCT_OCS = '1') AND
                                              TO_CHAR(A.INNET_DATE, 'YYYYMM') <=
                                              V_LAST_YEAR THEN
                                          1
                                         ELSE
                                          0
                                       END) ACCT_CDMA_NUM_CL,
                                   SUM(CASE
                                         WHEN A.TELE_TYPE = '2' AND A.IS_NEW = '1' THEN
                                          1
                                         ELSE
                                          0
                                       END) CDMA_NEW,
                                   SUM(CASE
                                         WHEN A.TELE_TYPE = '2' AND
                                              TO_CHAR(A.INNET_DATE, 'YYYY') =
                                              V_CURR_YEAR THEN
                                          1
                                         ELSE
                                          0
                                       END) CDMA_NEW_YEAR,

                                   --宽带
                                   SUM(CASE
                                         WHEN A.TELE_TYPE_NEW = 'G010' AND
                                              A.IS_ONNET = '1' THEN
                                          1
                                         ELSE
                                          0
                                       END) ONNET_ADSL_NUM,
                                   SUM(CASE
                                         WHEN A.TELE_TYPE_NEW = 'G010' AND
                                              (A.IS_ACCT = '1' OR
                                              A.IS_ACCT_OCS = '1') THEN
                                          1
                                         ELSE
                                          0
                                       END) ACCT_ADSL_NUM,
                                   SUM(CASE
                                         WHEN A.TELE_TYPE_NEW = 'G010' AND
                                              (A.IS_ACCT = '1' OR
                                              A.IS_ACCT_OCS = '1') AND
                                              TO_CHAR(A.INNET_DATE, 'YYYYMM') <=
                                              V_LAST_YEAR THEN
                                          1
                                         ELSE
                                          0
                                       END) ACCT_ADSL_NUM_CL,
                                   SUM(CASE
                                         WHEN A.TELE_TYPE_NEW = 'G010' AND
                                              A.IS_NEW = '1' THEN
                                          1
                                         ELSE
                                          0
                                       END) ADSL_NEW,
                                   SUM(CASE
                                         WHEN A.TELE_TYPE_NEW = 'G010' AND
                                              TO_CHAR(A.INNET_DATE, 'YYYY') =
                                              V_CURR_YEAR THEN
                                          1
                                         ELSE
                                          0
                                       END) ADSL_NEW_YEAR,
                                   --IPTV
                                   SUM(CASE
                                         WHEN A.TELE_TYPE_NEW = 'G110' AND
                                              A.IS_ONNET = '1' THEN
                                          1
                                         ELSE
                                          0
                                       END) ONNET_IPTV_NUM,
                                   SUM(CASE
                                         WHEN A.TELE_TYPE_NEW = 'G110' AND
                                              (A.IS_ACCT = '1' OR
                                              A.IS_ACCT_OCS = '1') THEN
                                          1
                                         ELSE
                                          0
                                       END) ACCT_IPTV_NUM,
                                   SUM(CASE
                                         WHEN A.TELE_TYPE_NEW = 'G110' AND
                                              (A.IS_ACCT = '1' OR
                                              A.IS_ACCT_OCS = '1') AND
                                              TO_CHAR(A.INNET_DATE, 'YYYYMM') <=
                                              V_LAST_YEAR THEN
                                          1
                                         ELSE
                                          0
                                       END) ACCT_IPTV_NUM_CL,
                                   SUM(CASE
                                         WHEN A.TELE_TYPE_NEW = 'G110' AND
                                              A.IS_NEW = '1' THEN
                                          1
                                         ELSE
                                          0
                                       END) IPTV_NEW,
                                   SUM(CASE
                                         WHEN A.TELE_TYPE_NEW = 'G110' AND
                                              TO_CHAR(A.INNET_DATE, 'YYYY') =
                                              V_CURR_YEAR THEN
                                          1
                                         ELSE
                                          0
                                       END) IPTV_NEW_YEAR,
                                   --专线电路
                                   SUM(CASE
                                         WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                                              A.IS_ONNET = '1' THEN
                                          1
                                         ELSE
                                          0
                                       END) ONNET_ZXDL_NUM,
                                   SUM(CASE
                                         WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                                              (A.IS_ACCT = '1' OR
                                              A.IS_ACCT_OCS = '1') THEN
                                          1
                                         ELSE
                                          0
                                       END) ACCT_ZXDL_NUM,
                                   SUM(CASE
                                         WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                                              (A.IS_ACCT = '1' OR
                                              A.IS_ACCT_OCS = '1') AND
                                              TO_CHAR(A.INNET_DATE, 'YYYYMM') <=
                                              V_LAST_YEAR THEN
                                          1
                                         ELSE
                                          0
                                       END) ACCT_ZXDL_NUM_CL,
                                   SUM(CASE
                                         WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                                              A.IS_NEW = '1' THEN
                                          1
                                         ELSE
                                          0
                                       END) ZXDL_NEW,
                                   SUM(CASE
                                         WHEN A.TELE_TYPE_NEW IN ('G020', 'G040') AND
                                              TO_CHAR(A.INNET_DATE, 'YYYY') =
                                              V_CURR_YEAR THEN
                                          1
                                         ELSE
                                          0
                                       END) ZXDL_NEW_YEAR,
                                   --固话
                                   SUM(CASE
                                         WHEN A.TELE_TYPE_NEW IN
                                              ('G000', 'G001', 'G002') AND
                                              A.IS_ONNET = '1' THEN
                                          1
                                         ELSE
                                          0
                                       END) ONNET_GH_NUM,
                                   SUM(CASE
                                         WHEN A.TELE_TYPE_NEW IN
                                              ('G000', 'G001', 'G002') AND
                                              (A.IS_ACCT = '1' OR
                                              A.IS_ACCT_OCS = '1') THEN
                                          1
                                         ELSE
                                          0
                                       END) ACCT_GH_NUM,
                                   SUM(CASE
                                         WHEN A.TELE_TYPE_NEW IN
                                              ('G000', 'G001', 'G002') AND
                                              (A.IS_ACCT = '1' OR
                                              A.IS_ACCT_OCS = '1') AND
                                              TO_CHAR(A.INNET_DATE, 'YYYYMM') <=
                                              V_LAST_YEAR THEN
                                          1
                                         ELSE
                                          0
                                       END) ACCT_GH_NUM_CL,
                                   SUM(CASE
                                         WHEN A.TELE_TYPE_NEW IN
                                              ('G000', 'G001', 'G002') AND
                                              A.IS_NEW = '1' THEN
                                          1
                                         ELSE
                                          0
                                       END) GH_NEW,
                                   SUM(CASE
                                         WHEN A.TELE_TYPE_NEW IN
                                              ('G000', 'G001', 'G002') AND
                                              TO_CHAR(A.INNET_DATE, 'YYYY') =
                                              V_CURR_YEAR THEN
                                          1
                                         ELSE
                                          0
                                       END) GH_NEW_YEAR,
                                   SUM(A.QFCS_FEE) QFCS_FEE,
                                   SUM(A.XMFC_FEE) XMFC_FEE
                              FROM DW.DW_V_USER_HUAXIAO_INFO_ALL A
                             WHERE A.ACCT_MONTH = V_ACCT_MONTH
                               AND AREA_NO = C1.AREA_NO
                               AND A.IS_HUAXIAO_08 = '1'
                             GROUP BY A.HUAXIAO_NO_08,A.CHANNEL_NO) A,
                           (SELECT *
                              FROM DIM.DIM_CHANNEL_HUAXIAO T
                             WHERE T.AREA_NO = C1.AREA_NO
                               AND T.HUAXIAO_TYPE = '08') T
                     WHERE A.HUAXIAO_NO_08 = T.HUAXIAO_NO
                     GROUP BY T.AREA_NO,
                              T.CITY_NO,
                              T.HUAXIAO_TYPE,
                              T.HUAXIAO_NO,
                              T.HUAXIAO_NAME,
                              T.CHANNEL_NO,
                              T.CHANNEL_NO_DESC
                              --净增
                              UNION ALL
                                SELECT AREA_NO,
                                       CITY_NO,
                                       HUAXIAO_TYPE,
                                       HUAXIAO_NO,
                                       HUAXIAO_NAME,
                                       CHANNEL_NO,
                                       CHANNEL_NO_DESC,
                                       0 TOTAL_FEE,
                                       0 TOTAL_FEE_CL,
                                       0 ONNET_CDMA_NUM,
                                       0 ACCT_CDMA_NUM,
                                       0 ACCT_CDMA_NUM_CL,
                                       0 CDMA_NEW,
                                       0 CDMA_NEW_YEAR,
                                       ACCT_CDMA_NUM * (-1) JZ_CDMA_NUM,
                                       0 ONNET_ADSL_NUM,
                                       0 ACCT_ADSL_NUM,
                                       0 ACCT_ADSL_NUM_CL,
                                       0 ADSL_NEW,
                                       0 ADSL_NEW_YEAR,
                                       ONNET_ADSL_NUM * (-1) JZ_ADSL_NUM,
                                       0 ONNET_IPTV_NUM,
                                       0 ACCT_IPTV_NUM,
                                       0 ACCT_IPTV_NUM_CL,
                                       0 IPTV_NEW,
                                       0 IPTV_NEW_YEAR,
                                       ONNET_IPTV_NUM * (-1) JZ_IPTV_NUM,
                                       0 ONNET_ZXDL_NUM,
                                       0 ACCT_ZXDL_NUM,
                                       0 ACCT_ZXDL_NUM_CL,
                                       0 ZXDL_NEW,
                                       0 ZXDL_NEW_YEAR,
                                       ONNET_ZXDL_NUM * (-1) JZ_ZXDL_NUM,
                                       0 ONNET_GH_NUM,
                                       0 ACCT_GH_NUM,
                                       0 ACCT_GH_NUM_CL,
                                       0 GH_NEW,
                                       0 GH_NEW_YEAR,
                                       ONNET_GH_NUM * (-1) JZ_GH_NUM,
                                       0 ONNET_XX_NUM,
                                       0 ACCT_XX_NUM,
                                       0 ACCT_XX_NUM_CL,
                                       0 XX_NEW,
                                       0 XX_NEW_YEAR,
                                       ONNET_XX_NUM * (-1) JZ_XX_NUM,
                                       0 QFCS_FEE,
                                       0 XMFC_FEE,
                                       XIAOQU_CHANNEL
                                  FROM DM_ZQ_CHANNEL_HUAXIAO_M
                                 WHERE ACCT_MONTH = V_LAST_MONTH
                                   AND AREA_NO = C1.AREA_NO

        )
 GROUP BY AREA_NO, CITY_NO, HUAXIAO_TYPE, HUAXIAO_NO, HUAXIAO_NAME,CHANNEL_NO,CHANNEL_NO_DESC,XIAOQU_CHANNEL;
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
