CREATE OR REPLACE PROCEDURE P_DM_V_CHANNEL_INFO_M(V_ACCT_MONTH VARCHAR2,
                                                  V_RETCODE    OUT VARCHAR2,
                                                  V_RETINFO    OUT VARCHAR2) IS
  /*****************************************************************
  *名称 --%NAME:P_DM_V_CHANNEL_INFO_M
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
  V_PKG      := '渠道小区数据';
  V_PROCNAME := 'P_DM_V_CHANNEL_INFO_M';

  SELECT COUNT(1)
    INTO V_COUNT
    FROM DW.DW_EXECUTE_LOG A
   WHERE A.ACCT_MONTH = V_ACCT_MONTH
     AND A.PROCNAME IN ('P_DW_V_USER_HUAXIAO_INFO_M')
     AND A.RESULT = 'SUCCESS';

  --插入日志
  P_ALLDM_INSERT_LOG(V_ACCT_MONTH, V_PKG, V_PROCNAME, '12', SYSDATE);

  IF V_COUNT = 1 THEN
  
    --============================== 渠道小区数据 ===========================================
  
    --删除当月数据
    DELETE FROM ALLDM.DM_V_CHANNEL_INFO_M WHERE ACCT_MONTH = V_ACCT_MONTH;
    COMMIT;
    --正式数据
    FOR C1 IN V_AREA LOOP
      ---自营厅
      INSERT /*+APPEND*/
      INTO ALLDM.DM_V_CHANNEL_INFO_M
        SELECT V_ACCT_MONTH ACCT_MONTH,
               T.AREA_NO,
               T.CITY_NO,
               T.HUAXIAO_TYPE,
               T.HUAXIAO_NO,
               T.HUAXIAO_NAME,
               T.XIAOQU_NO,
               T.XIAOQU_NAME,
               t.xiaoqu_channel,
               --T.CHANNEL_NO,
               --T.CHANNEL_NO_DESC,
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
               SUM(T.SUM_SORE)
          FROM (SELECT T.AREA_NO,
                       T.CITY_NO,
                       T.HUAXIAO_TYPE,
                       T.HUAXIAO_NO,
                       T.HUAXIAO_NAME,
                       T.XIAOQU_NO,
                       T.XIAOQU_NAME,
                       t.xiaoqu_channel,
                       --T.CHANNEL_NO,
                       --T.CHANNEL_NO_DESC,
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
                       0 SUM_SORE
                  FROM (SELECT T.AREA_NO,
                               T.CITY_NO,
                               T.HUAXIAO_TYPE,
                               T.HUAXIAO_NO,
                               T.HUAXIAO_NAME,
                               --A.XIAOQU_NO,
                               --A.XIAOQU_NAME,
                               A.CHANNEL_NO XIAOQU_NO,
                               A.CHANNEL_NO_DESC XIAOQU_NAME,
                               '渠道' xiaoqu_channel,
                               A.CDMA_NUM + A.ADSL_NUM + A.IPTV_NUM NEW_NUM,
                               A.CDMA_NUM,
                               A.ADSL_NUM,
                               A.IPTV_NUM,
                               NVL(A.PRICE_FEE, 0) PRICE_FEE,
                               NVL(A.PRICE_FEE_YEAR, 0) PRICE_FEE_YEAR
                          FROM (SELECT SUM(CASE
                                             WHEN A.TELE_TYPE = '2' AND a.is_new = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) CDMA_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE IN ('4', '26') AND
                                                  a.is_new = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) ADSL_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '72' AND
                                                  a.is_new = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) IPTV_NUM,
                                       SUM(NVL(A.PRICE_FEE, 0)) +
                                       SUM(NVL(A.PRICE_FEE_OCS, 0)) -
                                       SUM(NVL(A.IOT_FEE, 0)) PRICE_FEE,
                                       SUM(CASE
                                             WHEN TO_CHAR(A.INNET_DATE, 'YYYY') = SUBSTR(V_ACCT_MONTH, 1, 4) THEN
                                              NVL(A.PRICE_FEE, 0) + NVL(A.PRICE_FEE_OCS, 0) - NVL(A.IOT_FEE, 0)
                                           END) PRICE_FEE_YEAR,
                                       A.HUAXIAO_NO_01,
                                       --A.XIAOQU_NO,
                                       --A.XIAOQU_NAME,
                                       A.CHANNEL_NO,
                                       A.CHANNEL_NO_DESC
                                  FROM DW.DW_V_USER_HUAXIAO_INFO_M A
                                 WHERE A.ACCT_MONTH = V_ACCT_MONTH
                                   AND AREA_NO = C1.AREA_NO
                                  -- AND A.IS_VALID = '1'
                                   and a.channel_no is not null
                                   AND A.IS_HUAXIAO_01 = '1'
                                 GROUP BY A.HUAXIAO_NO_01,
                                          --A.XIAOQU_NO,
                                          --A.XIAOQU_NAME,
                                          A.CHANNEL_NO,
                                          A.CHANNEL_NO_DESC) A,
                               (SELECT *
                                  FROM DIM.DIM_HUAXIAO_INFO T
                                 WHERE T.AREA_NO = C1.AREA_NO
                                   AND T.HUAXIAO_TYPE IN
                                       ('01', '02', '03', '04')) T
                         WHERE A.HUAXIAO_NO_01 = T.HUAXIAO_NO
                         /*union all
                        SELECT T.AREA_NO,
                               T.CITY_NO,
                               T.HUAXIAO_TYPE,
                               T.HUAXIAO_NO,
                               T.HUAXIAO_NAME,
                               A.XIAOQU_NO,
                               A.XIAOQU_NAME,
                               '小区' xiaoqu_channel,
                               --A.CHANNEL_NO,
                               --A.CHANNEL_NO_DESC,
                               A.CDMA_NUM + A.ADSL_NUM + A.IPTV_NUM NEW_NUM,
                               A.CDMA_NUM,
                               A.ADSL_NUM,
                               A.IPTV_NUM,
                               NVL(A.PRICE_FEE, 0) PRICE_FEE,
                               NVL(A.PRICE_FEE_YEAR, 0) PRICE_FEE_YEAR
                          FROM (SELECT SUM(CASE
                                             WHEN A.TELE_TYPE = '2' AND a.is_new = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) CDMA_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE IN ('4', '26') AND
                                                  a.is_new = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) ADSL_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '72' AND
                                                  a.is_new = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) IPTV_NUM,
                                       SUM(NVL(A.PRICE_FEE, 0)) +
                                       SUM(NVL(A.PRICE_FEE_OCS, 0)) -
                                       SUM(NVL(A.IOT_FEE, 0)) PRICE_FEE,
                                       SUM(CASE
                                             WHEN TO_CHAR(A.INNET_DATE, 'YYYY') = SUBSTR(V_ACCT_MONTH, 1, 4) THEN
                                              NVL(A.PRICE_FEE, 0) + NVL(A.PRICE_FEE_OCS, 0) - NVL(A.IOT_FEE, 0)
                                           END) PRICE_FEE_YEAR,
                                       A.HUAXIAO_NO_01,
                                       a.XIAOQU_NO,
                                       A.XIAOQU_NAME
                                       --A.CHANNEL_NO,
                                       --A.CHANNEL_NO_DESC
                                  FROM DW.DW_V_USER_HUAXIAO_INFO_M A
                                 WHERE A.ACCT_MONTH = V_ACCT_MONTH
                                   AND AREA_NO = C1.AREA_NO
                                  -- AND A.IS_VALID = '1'
                                   and a.xiaoqu_no is not null
                                   AND A.IS_HUAXIAO_01 = '1'
                                 GROUP BY A.HUAXIAO_NO_01,
                                          A.XIAOQU_NO,
                                          A.XIAOQU_NAME
                                          \*A.CHANNEL_NO,
                                          A.CHANNEL_NO_DESC*\) A,
                               (SELECT *
                                  FROM DIM.DIM_HUAXIAO_INFO T
                                 WHERE T.AREA_NO = C1.AREA_NO
                                   AND T.HUAXIAO_TYPE IN
                                       ('01', '02', '03', '04')) T
                         WHERE A.HUAXIAO_NO_01 = T.HUAXIAO_NO*/
                        UNION ALL
                        ---商圈
                        SELECT T.AREA_NO,
                               T.CITY_NO,
                               T.HUAXIAO_TYPE,
                               T.HUAXIAO_NO,
                               T.HUAXIAO_NAME,
                               --A.XIAOQU_NO,
                               --A.XIAOQU_NAME,
                               A.CHANNEL_NO XIAOQU_NO,
                               A.CHANNEL_NO_DESC XIAOQU_NAME,
                               '渠道' xiaoqu_channel,
                               A.CDMA_NUM + A.ADSL_NUM + A.IPTV_NUM NEW_NUM,
                               A.CDMA_NUM,
                               A.ADSL_NUM,
                               A.IPTV_NUM,
                               NVL(A.PRICE_FEE, 0) PRICE_FEE,
                               NVL(A.PRICE_FEE_YEAR, 0) PRICE_FEE_YEAR
                          FROM (SELECT SUM(CASE
                                             WHEN A.TELE_TYPE = '2' AND a.is_new = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) CDMA_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE IN ('4', '26') AND
                                                  a.is_new = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) ADSL_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '72' AND
                                                  a.is_new = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) IPTV_NUM,
                                       SUM(NVL(A.PRICE_FEE, 0)) +
                                       SUM(NVL(A.PRICE_FEE_OCS, 0)) -
                                       SUM(NVL(A.IOT_FEE, 0)) PRICE_FEE,
                                       SUM(CASE
                                             WHEN TO_CHAR(A.INNET_DATE, 'YYYY') = SUBSTR(V_ACCT_MONTH, 1, 4) THEN
                                              NVL(A.PRICE_FEE, 0) + NVL(A.PRICE_FEE_OCS, 0) - NVL(A.IOT_FEE, 0)
                                           END) PRICE_FEE_YEAR,
                                       A.HUAXIAO_NO_02,
                                      -- A.XIAOQU_NO,
                                       --A.XIAOQU_NAME,
                                       A.CHANNEL_NO,
                                       A.CHANNEL_NO_DESC
                                  FROM DW.DW_V_USER_HUAXIAO_INFO_M A
                                 WHERE A.ACCT_MONTH = V_ACCT_MONTH
                                   AND AREA_NO = C1.AREA_NO
                                   --AND A.IS_VALID = '1'
                                   and a.channel_no is not null
                                   AND A.IS_HUAXIAO_02 = '1'
                                 GROUP BY A.HUAXIAO_NO_02,
                                          --A.XIAOQU_NO,
                                          --A.XIAOQU_NAME,
                                          A.CHANNEL_NO,
                                          A.CHANNEL_NO_DESC) A,
                               (SELECT *
                                  FROM DIM.DIM_HUAXIAO_INFO T
                                 WHERE T.AREA_NO = C1.AREA_NO
                                   AND T.HUAXIAO_TYPE IN
                                       ('01', '02', '03', '04')) T
                         WHERE A.HUAXIAO_NO_02 = T.HUAXIAO_NO
                         /*union all
                        SELECT T.AREA_NO,
                               T.CITY_NO,
                               T.HUAXIAO_TYPE,
                               T.HUAXIAO_NO,
                               T.HUAXIAO_NAME,
                               A.XIAOQU_NO,
                               A.XIAOQU_NAME,
                               '小区' xiaoqu_channel,
                               --A.CHANNEL_NO,
                               --A.CHANNEL_NO_DESC,
                               A.CDMA_NUM + A.ADSL_NUM + A.IPTV_NUM NEW_NUM,
                               A.CDMA_NUM,
                               A.ADSL_NUM,
                               A.IPTV_NUM,
                               NVL(A.PRICE_FEE, 0) PRICE_FEE,
                               NVL(A.PRICE_FEE_YEAR, 0) PRICE_FEE_YEAR
                          FROM (SELECT SUM(CASE
                                             WHEN A.TELE_TYPE = '2' AND a.is_new = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) CDMA_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE IN ('4', '26') AND
                                                  a.is_new = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) ADSL_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '72' AND
                                                  a.is_new = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) IPTV_NUM,
                                       SUM(NVL(A.PRICE_FEE, 0)) +
                                       SUM(NVL(A.PRICE_FEE_OCS, 0)) -
                                       SUM(NVL(A.IOT_FEE, 0)) PRICE_FEE,
                                       SUM(CASE
                                             WHEN TO_CHAR(A.INNET_DATE, 'YYYY') = SUBSTR(V_ACCT_MONTH, 1, 4) THEN
                                              NVL(A.PRICE_FEE, 0) + NVL(A.PRICE_FEE_OCS, 0) - NVL(A.IOT_FEE, 0)
                                           END) PRICE_FEE_YEAR,
                                       A.HUAXIAO_NO_02,
                                       A.XIAOQU_NO,
                                       A.XIAOQU_NAME
                                       --A.CHANNEL_NO,
                                       --A.CHANNEL_NO_DESC
                                  FROM DW.DW_V_USER_HUAXIAO_INFO_M A
                                 WHERE A.ACCT_MONTH = V_ACCT_MONTH
                                   AND AREA_NO = C1.AREA_NO
                                   --AND A.IS_VALID = '1'
                                   and a.xiaoqu_no is not null
                                   AND A.IS_HUAXIAO_02 = '1'
                                 GROUP BY A.HUAXIAO_NO_02,
                                          A.XIAOQU_NO,
                                          A.XIAOQU_NAME
                                          --A.CHANNEL_NO,
                                          \*A.CHANNEL_NO_DESC*\) A,
                               (SELECT *
                                  FROM DIM.DIM_HUAXIAO_INFO T
                                 WHERE T.AREA_NO = C1.AREA_NO
                                   AND T.HUAXIAO_TYPE IN
                                       ('01', '02', '03', '04')) T
                         WHERE A.HUAXIAO_NO_02 = T.HUAXIAO_NO*/
                        UNION ALL
                        ---社区支局
                        SELECT T.AREA_NO,
                               T.CITY_NO,
                               T.HUAXIAO_TYPE,
                               T.HUAXIAO_NO,
                               T.HUAXIAO_NAME,
                               --A.XIAOQU_NO,
                               --A.XIAOQU_NAME,
                               A.CHANNEL_NO XIAOQU_NO,
                               A.CHANNEL_NO_DESC XIAOQU_NAME,
                               '渠道' xiaoqu_channel,
                               A.CDMA_NUM + A.ADSL_NUM + A.IPTV_NUM NEW_NUM,
                               A.CDMA_NUM,
                               A.ADSL_NUM,
                               A.IPTV_NUM,
                               NVL(A.PRICE_FEE, 0) PRICE_FEE,
                               NVL(A.PRICE_FEE_YEAR, 0) PRICE_FEE_YEAR
                          FROM (SELECT SUM(CASE
                                             WHEN A.TELE_TYPE = '2' AND a.is_new = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) CDMA_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE IN ('4', '26') AND
                                                  a.is_new = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) ADSL_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '72' AND
                                                  a.is_new = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) IPTV_NUM,
                                       SUM(NVL(A.PRICE_FEE, 0)) +
                                       SUM(NVL(A.PRICE_FEE_OCS, 0)) -
                                       SUM(NVL(A.IOT_FEE, 0)) PRICE_FEE,
                                       SUM(CASE
                                             WHEN TO_CHAR(A.INNET_DATE, 'YYYY') = SUBSTR(V_ACCT_MONTH, 1, 4) THEN
                                              NVL(A.PRICE_FEE, 0) + NVL(A.PRICE_FEE_OCS, 0) - NVL(A.IOT_FEE, 0)
                                           END) PRICE_FEE_YEAR,
                                       A.HUAXIAO_NO_03,
                                       --A.XIAOQU_NO,
                                       --A.XIAOQU_NAME,
                                       A.CHANNEL_NO,
                                       A.CHANNEL_NO_DESC
                                  FROM DW.DW_V_USER_HUAXIAO_INFO_M A
                                 WHERE A.ACCT_MONTH = V_ACCT_MONTH
                                   AND AREA_NO = C1.AREA_NO
                                  -- AND A.IS_VALID = '1'
                                   and a.is_kd_bundle = '0'
                                   and a.tele_type = '2'
                                   AND A.IS_HUAXIAO_03 = '1'
                                 GROUP BY A.HUAXIAO_NO_03,
                                          --A.XIAOQU_NO,
                                          --A.XIAOQU_NAME,
                                          A.CHANNEL_NO,
                                          A.CHANNEL_NO_DESC) A,
                               (SELECT *
                                  FROM DIM.DIM_HUAXIAO_INFO T
                                 WHERE T.AREA_NO = C1.AREA_NO
                                   AND T.HUAXIAO_TYPE IN
                                       ('01', '02', '03', '04')) T
                         WHERE A.HUAXIAO_NO_03 = T.HUAXIAO_NO
                         union all
                        SELECT T.AREA_NO,
                               T.CITY_NO,
                               T.HUAXIAO_TYPE,
                               T.HUAXIAO_NO,
                               T.HUAXIAO_NAME,
                               A.XIAOQU_NO,
                               A.XIAOQU_NAME,
                               '小区' xiaoqu_channel,
                               --A.CHANNEL_NO,
                               --A.CHANNEL_NO_DESC,
                               A.CDMA_NUM + A.ADSL_NUM + A.IPTV_NUM NEW_NUM,
                               A.CDMA_NUM,
                               A.ADSL_NUM,
                               A.IPTV_NUM,
                               NVL(A.PRICE_FEE, 0) PRICE_FEE,
                               NVL(A.PRICE_FEE_YEAR, 0) PRICE_FEE_YEAR
                          FROM (SELECT SUM(CASE
                                             WHEN A.TELE_TYPE = '2' AND a.is_new = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) CDMA_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE IN ('4', '26') AND
                                                  a.is_new = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) ADSL_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '72' AND
                                                  a.is_new = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) IPTV_NUM,
                                       SUM(NVL(A.PRICE_FEE, 0)) +
                                       SUM(NVL(A.PRICE_FEE_OCS, 0)) -
                                       SUM(NVL(A.IOT_FEE, 0)) PRICE_FEE,
                                       SUM(CASE
                                             WHEN TO_CHAR(A.INNET_DATE, 'YYYY') = SUBSTR(V_ACCT_MONTH, 1, 4) THEN
                                              NVL(A.PRICE_FEE, 0) + NVL(A.PRICE_FEE_OCS, 0) - NVL(A.IOT_FEE, 0)
                                           END) PRICE_FEE_YEAR,
                                       A.HUAXIAO_NO_03,
                                       A.XIAOQU_NO,
                                       A.XIAOQU_NAME
                                       --A.CHANNEL_NO,
                                       --A.CHANNEL_NO_DESC
                                  FROM DW.DW_V_USER_HUAXIAO_INFO_M A
                                 WHERE A.ACCT_MONTH = V_ACCT_MONTH
                                   AND AREA_NO = C1.AREA_NO
                                  -- AND A.IS_VALID = '1'
                                   and ((a.is_kd_bundle <> '0' and a.tele_type = '2') or a.tele_type <> '2')
                                   AND A.IS_HUAXIAO_03 = '1'
                                 GROUP BY A.HUAXIAO_NO_03,
                                          A.XIAOQU_NO,
                                          A.XIAOQU_NAME
                                          /*A.CHANNEL_NO,
                                          A.CHANNEL_NO_DESC*/) A,
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
                               --A.XIAOQU_NO,
                              -- A.XIAOQU_NAME,
                               A.CHANNEL_NO XIAOQU_NO,
                               A.CHANNEL_NO_DESC XIAOQU_NAME,
                               '渠道' xiaoqu_channel,
                               A.CDMA_NUM + A.ADSL_NUM + A.IPTV_NUM NEW_NUM,
                               A.CDMA_NUM,
                               A.ADSL_NUM,
                               A.IPTV_NUM,
                               NVL(A.PRICE_FEE, 0) PRICE_FEE,
                               NVL(A.PRICE_FEE_YEAR, 0) PRICE_FEE_YEAR
                          FROM (SELECT SUM(CASE
                                             WHEN A.TELE_TYPE = '2' AND a.is_new = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) CDMA_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE IN ('4', '26') AND
                                                  a.is_new = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) ADSL_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '72' AND
                                                  a.is_new = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) IPTV_NUM,
                                       SUM(NVL(A.PRICE_FEE, 0)) +
                                       SUM(NVL(A.PRICE_FEE_OCS, 0)) PRICE_FEE,
                                       SUM(CASE
                                             WHEN TO_CHAR(A.INNET_DATE, 'YYYY') = SUBSTR(V_ACCT_MONTH, 1, 4) THEN
                                              NVL(A.PRICE_FEE, 0) + NVL(A.PRICE_FEE_OCS, 0)
                                           END) PRICE_FEE_YEAR,
                                       A.HUAXIAO_NO_04,
                                       --A.XIAOQU_NO,
                                       --A.XIAOQU_NAME,
                                       A.CHANNEL_NO,
                                       A.CHANNEL_NO_DESC
                                  FROM DW.DW_V_USER_HUAXIAO_INFO_M A
                                 WHERE A.ACCT_MONTH = V_ACCT_MONTH
                                   AND AREA_NO = C1.AREA_NO
                                  -- AND A.IS_VALID = '1'
                                   and a.tele_type = '2'
                                   and a.is_kd_bundle = '0'
                                   AND A.IS_HUAXIAO_04 = '1'
                                 GROUP BY A.HUAXIAO_NO_04,
                                          --A.XIAOQU_NO,
                                         -- A.XIAOQU_NAME,
                                          A.CHANNEL_NO,
                                          A.CHANNEL_NO_DESC) A,
                               (SELECT *
                                  FROM DIM.DIM_HUAXIAO_INFO T
                                 WHERE T.AREA_NO = C1.AREA_NO
                                   AND T.HUAXIAO_TYPE IN
                                       ('01', '02', '03', '04')) T
                         WHERE A.HUAXIAO_NO_04 = T.HUAXIAO_NO
                         union all
                         SELECT T.AREA_NO,
                               T.CITY_NO,
                               T.HUAXIAO_TYPE,
                               T.HUAXIAO_NO,
                               T.HUAXIAO_NAME,
                               A.XIAOQU_NO,
                               A.XIAOQU_NAME,
                               '小区' xiaoqu_channel,
                               --A.CHANNEL_NO,
                               --A.CHANNEL_NO_DESC,
                               A.CDMA_NUM + A.ADSL_NUM + A.IPTV_NUM NEW_NUM,
                               A.CDMA_NUM,
                               A.ADSL_NUM,
                               A.IPTV_NUM,
                               NVL(A.PRICE_FEE, 0) PRICE_FEE,
                               NVL(A.PRICE_FEE_YEAR, 0) PRICE_FEE_YEAR
                          FROM (SELECT SUM(CASE
                                             WHEN A.TELE_TYPE = '2' AND a.is_new = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) CDMA_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE IN ('4', '26') AND
                                                  a.is_new = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) ADSL_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '72' AND
                                                  a.is_new = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) IPTV_NUM,
                                       SUM(NVL(A.PRICE_FEE, 0)) +
                                       SUM(NVL(A.PRICE_FEE_OCS, 0)) PRICE_FEE,
                                       SUM(CASE
                                             WHEN TO_CHAR(A.INNET_DATE, 'YYYY') = SUBSTR(V_ACCT_MONTH, 1, 4) THEN
                                              NVL(A.PRICE_FEE, 0) + NVL(A.PRICE_FEE_OCS, 0)
                                           END) PRICE_FEE_YEAR,
                                       A.HUAXIAO_NO_04,
                                       A.XIAOQU_NO,
                                       A.XIAOQU_NAME
                                       --A.CHANNEL_NO,
                                      -- A.CHANNEL_NO_DESC
                                  FROM DW.DW_V_USER_HUAXIAO_INFO_M A
                                 WHERE A.ACCT_MONTH = V_ACCT_MONTH
                                   AND AREA_NO = C1.AREA_NO
                                  -- AND A.IS_VALID = '1'
                                   and ((a.is_kd_bundle <> '0' and a.tele_type = '2') or a.tele_type <> '2')
                                   AND A.IS_HUAXIAO_04 = '1'
                                 GROUP BY A.HUAXIAO_NO_04,
                                          A.XIAOQU_NO,
                                          A.XIAOQU_NAME
                                          /*A.CHANNEL_NO,
                                          A.CHANNEL_NO_DESC*/) A,
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
                          T.HUAXIAO_NAME,
                          T.XIAOQU_NO,
                          T.XIAOQU_NAME,
                          t.xiaoqu_channel
                          --T.CHANNEL_NO,
                          --T.CHANNEL_NO_DESC
                UNION ALL
                SELECT T.AREA_NO,
                       T.CITY_NO,
                       T.HUAXIAO_TYPE,
                       T.HUAXIAO_NO,
                       T.HUAXIAO_NAME,
                       --NULL,
                       --NULL,
                       T.CHANNEL_NO xiaoqu_no,
                       T.CHANNEL_NO_DESC xiaoqu_name,
                       '渠道' xiaoqu_channel,
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
                       SUM(C.SUM_SORE)
                  FROM (SELECT C.CHANNEL_NO,
                               C.DEVLP_SORE,
                               C.INCOME_SORE,
                               C.WEIXI_SORE,
                               C.FINE_SORE,
                               C.SUM_SORE
                          FROM ALLDM.INTEGRAL_SYS_SUM_M C
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
                          T.HUAXIAO_NAME,
                          T.CHANNEL_NO,
                          T.CHANNEL_NO_DESC) T
         GROUP BY T.AREA_NO,
                  T.CITY_NO,
                  T.HUAXIAO_TYPE,
                  T.HUAXIAO_NO,
                  T.HUAXIAO_NAME,
                  T.XIAOQU_NO,
                  T.XIAOQU_NAME,
                  t.xiaoqu_channel
                  /*T.CHANNEL_NO,
                  T.CHANNEL_NO_DESC*/;
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
