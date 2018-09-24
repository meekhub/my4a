CREATE OR REPLACE PROCEDURE P_DM_V_CHANNEL_INFO_M(V_ACCT_MONTH VARCHAR2,
                                                   V_RETCODE    OUT VARCHAR2,
                                                   V_RETINFO    OUT VARCHAR2) IS
  /*****************************************************************
  *���� --%NAME:P_DM_V_CHANNEL_INFO_M
  *�������� --%COMMENT:
  *ִ������ --%PERIOD: ��
  *���� --%PARAM:V_ACCT_MONTH  ����,��ʽYYYYMM
  *���� --%PARAM:V_RETCODE  �������н����ɹ�����־
  *���� --%PARAM:V_RETCODE  �������н����ɹ��������
  *������ --%CREATOR:LIANGZHITAO
  *����ʱ�� --%CREATED_TIME:2017-10-19
  *��ע --%REMARK:
  *��Դ�� --%FROM:  DW.DW_V_USER_HUAXIAO_INFO_M
  *Ŀ��� --%TO:   ALLDM.DM_V_HUAXIAO_INFO_M
  *�޸ļ�¼ --%MODIFY:
  *******************************************************************/
  V_PKG      VARCHAR2(40);
  V_PROCNAME VARCHAR2(40);
  V_COUNT    NUMBER;
  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018';
BEGIN
  V_PKG      := '����С������';
  V_PROCNAME := 'P_DM_V_CHANNEL_INFO_M';

  SELECT COUNT(1)
    INTO V_COUNT
    FROM DW.DW_EXECUTE_LOG A
   WHERE A.ACCT_MONTH = V_ACCT_MONTH
     AND A.PROCNAME IN ('P_DW_V_USER_HUAXIAO_INFO_M')
     AND A.RESULT = 'SUCCESS';

  --������־
  P_ALLDM_INSERT_LOG(V_ACCT_MONTH, V_PKG, V_PROCNAME, '12', SYSDATE);

  IF V_COUNT = 1 THEN

    --============================== ����С������ ===========================================

    --ɾ����������
    DELETE FROM ALLDM.DM_V_CHANNEL_INFO_M WHERE ACCT_MONTH = V_ACCT_MONTH;
    COMMIT;
    --��ʽ����
    FOR C1 IN V_AREA LOOP
      ---��Ӫ��
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
               T.XIAOQU_CHANNEL,
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
                       T.XIAOQU_NO,
                       T.XIAOQU_NAME,
                       T.XIAOQU_CHANNEL,
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
                               --A.XIAOQU_NO,
                               --A.XIAOQU_NAME,
                               T.CHANNEL_NO XIAOQU_NO,
                               T.CHANNEL_NO_DESC XIAOQU_NAME,
                               '����' XIAOQU_CHANNEL,
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
                                             WHEN A.TELE_TYPE = '2' AND A.IS_NEW = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) CDMA_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE IN ('4', '26') AND A.INNET_METHOD IN ('1','2','4','5','15') AND A.IS_NEW = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) ADSL_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '72' AND A.IS_NEW = '1' THEN
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
                                       A.HUAXIAO_NO_01,
                                       --A.XIAOQU_NO,
                                       --A.XIAOQU_NAME,
                                       A.CHANNEL_NO,
                                       A.CHANNEL_NO_DESC
                                  FROM DW.DW_V_USER_HUAXIAO_INFO_M A
                                 WHERE A.ACCT_MONTH = V_ACCT_MONTH
                                   AND AREA_NO = C1.AREA_NO
                                      -- AND A.IS_VALID = '1'
                                   AND A.CHANNEL_NO IS NOT NULL
                                   AND A.IS_HUAXIAO_01 = '1'
                                 GROUP BY A.HUAXIAO_NO_01,
                                          --A.XIAOQU_NO,
                                          --A.XIAOQU_NAME,
                                          A.CHANNEL_NO,
                                          A.CHANNEL_NO_DESC) A,
                               (SELECT *
                                  FROM DIM.DIM_CHANNEL_HUAXIAO T
                                 WHERE T.AREA_NO = C1.AREA_NO
                                   AND T.HUAXIAO_TYPE = '01') T
                         WHERE A.HUAXIAO_NO_01 = T.HUAXIAO_NO
                           AND A.CHANNEL_NO = T.CHANNEL_NO
                        /*UNION ALL
                        SELECT T.AREA_NO,
                               T.CITY_NO,
                               T.HUAXIAO_TYPE,
                               T.HUAXIAO_NO,
                               T.HUAXIAO_NAME,
                               A.XIAOQU_NO,
                               A.XIAOQU_NAME,
                               'С��' XIAOQU_CHANNEL,
                               --A.CHANNEL_NO,
                               --A.CHANNEL_NO_DESC,
                               A.CDMA_NUM + A.ADSL_NUM + A.IPTV_NUM NEW_NUM,
                               A.CDMA_NUM,
                               A.ADSL_NUM,
                               A.IPTV_NUM,
                               NVL(A.PRICE_FEE, 0) PRICE_FEE,
                               NVL(A.PRICE_FEE_YEAR, 0) PRICE_FEE_YEAR
                          FROM (SELECT SUM(CASE
                                             WHEN A.TELE_TYPE = '2' AND A.IS_NEW = '1' THEN
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
                                             WHEN TO_CHAR(A.INNET_DATE, 'YYYY') = SUBSTR(V_ACCT_MONTH, 1, 4) THEN
                                              NVL(A.PRICE_FEE, 0) + NVL(A.PRICE_FEE_OCS, 0) - NVL(A.IOT_FEE, 0)
                                           END) PRICE_FEE_YEAR,
                                       A.HUAXIAO_NO_01,
                                       A.XIAOQU_NO,
                                       A.XIAOQU_NAME
                                       --A.CHANNEL_NO,
                                       --A.CHANNEL_NO_DESC
                                  FROM DW.DW_V_USER_HUAXIAO_INFO_M A
                                 WHERE A.ACCT_MONTH = V_ACCT_MONTH
                                   AND AREA_NO = C1.AREA_NO
                                  -- AND A.IS_VALID = '1'
                                   AND A.XIAOQU_NO IS NOT NULL
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
                        ---��Ȧ
                        SELECT T.AREA_NO,
                               T.CITY_NO,
                               T.HUAXIAO_TYPE,
                               T.HUAXIAO_NO,
                               T.HUAXIAO_NAME,
                               --A.XIAOQU_NO,
                               --A.XIAOQU_NAME,
                               T.CHANNEL_NO XIAOQU_NO,
                               T.CHANNEL_NO_DESC XIAOQU_NAME,
                               '����' XIAOQU_CHANNEL,
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
                                             WHEN A.TELE_TYPE = '2' AND A.IS_NEW = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) CDMA_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE IN ('4', '26') AND A.INNET_METHOD IN ('1','2','4','5','15') AND A.IS_NEW = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) ADSL_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '72' AND A.IS_NEW = '1' THEN
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
                                       A.HUAXIAO_NO_02,
                                       -- A.XIAOQU_NO,
                                       --A.XIAOQU_NAME,
                                       A.CHANNEL_NO,
                                       A.CHANNEL_NO_DESC
                                  FROM DW.DW_V_USER_HUAXIAO_INFO_M A
                                 WHERE A.ACCT_MONTH = V_ACCT_MONTH
                                   AND AREA_NO = C1.AREA_NO
                                      --AND A.IS_VALID = '1'
                                   AND A.CHANNEL_NO IS NOT NULL
                                   AND A.IS_HUAXIAO_02 = '1'
                                 GROUP BY A.HUAXIAO_NO_02,
                                          --A.XIAOQU_NO,
                                          --A.XIAOQU_NAME,
                                          A.CHANNEL_NO,
                                          A.CHANNEL_NO_DESC) A,
                               (SELECT *
                                  FROM DIM.DIM_CHANNEL_HUAXIAO T
                                 WHERE T.AREA_NO = C1.AREA_NO
                                   AND T.HUAXIAO_TYPE = '02') T
                         WHERE A.HUAXIAO_NO_02 = T.HUAXIAO_NO
                           AND A.CHANNEL_NO = T.CHANNEL_NO
                        /*UNION ALL
                        SELECT T.AREA_NO,
                               T.CITY_NO,
                               T.HUAXIAO_TYPE,
                               T.HUAXIAO_NO,
                               T.HUAXIAO_NAME,
                               A.XIAOQU_NO,
                               A.XIAOQU_NAME,
                               'С��' XIAOQU_CHANNEL,
                               --A.CHANNEL_NO,
                               --A.CHANNEL_NO_DESC,
                               A.CDMA_NUM + A.ADSL_NUM + A.IPTV_NUM NEW_NUM,
                               A.CDMA_NUM,
                               A.ADSL_NUM,
                               A.IPTV_NUM,
                               NVL(A.PRICE_FEE, 0) PRICE_FEE,
                               NVL(A.PRICE_FEE_YEAR, 0) PRICE_FEE_YEAR
                          FROM (SELECT SUM(CASE
                                             WHEN A.TELE_TYPE = '2' AND A.IS_NEW = '1' THEN
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
                                   AND A.XIAOQU_NO IS NOT NULL
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
                        ---����֧��
                        SELECT T.AREA_NO,
                               T.CITY_NO,
                               T.HUAXIAO_TYPE,
                               T.HUAXIAO_NO,
                               T.HUAXIAO_NAME,
                               --A.XIAOQU_NO,
                               --A.XIAOQU_NAME,
                               T.CHANNEL_NO XIAOQU_NO,
                               T.CHANNEL_NO_DESC XIAOQU_NAME,
                               '����' XIAOQU_CHANNEL,
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
                                             WHEN A.TELE_TYPE = '2' AND A.IS_NEW = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) CDMA_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE IN ('4', '26') AND A.INNET_METHOD IN ('1','2','4','5','15') AND A.IS_NEW = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) ADSL_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '72' AND A.IS_NEW = '1' THEN
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
                                       A.HUAXIAO_NO_03,
                                       --A.XIAOQU_NO,
                                       --A.XIAOQU_NAME,
                                       A.CHANNEL_NO,
                                       A.CHANNEL_NO_DESC
                                  FROM DW.DW_V_USER_HUAXIAO_INFO_M A
                                 WHERE A.ACCT_MONTH = V_ACCT_MONTH
                                   AND AREA_NO = C1.AREA_NO
                                      -- AND A.IS_VALID = '1'
                                      --AND A.IS_KD_BUNDLE = '0'
                                   AND A.XIAOQU_NO IS NULL
                                   AND A.TELE_TYPE = '2'
                                   AND A.IS_HUAXIAO_03 = '1'
                                 GROUP BY A.HUAXIAO_NO_03,
                                          --A.XIAOQU_NO,
                                          --A.XIAOQU_NAME,
                                          A.CHANNEL_NO,
                                          A.CHANNEL_NO_DESC) A,
                               (SELECT *
                                  FROM DIM.DIM_CHANNEL_HUAXIAO T
                                 WHERE T.AREA_NO = C1.AREA_NO
                                   AND T.HUAXIAO_TYPE = '03') T
                         WHERE A.HUAXIAO_NO_03 = T.HUAXIAO_NO
                           AND A.CHANNEL_NO = T.CHANNEL_NO
                        UNION ALL
                        SELECT T.AREA_NO,
                               T.CITY_NO,
                               T.HUAXIAO_TYPE,
                               T.HUAXIAO_NO,
                               T.HUAXIAO_NAME,
                               T.XIAOQU_NO,
                               T.XIAOQU_NAME,
                               'С��' XIAOQU_CHANNEL,
                               --A.CHANNEL_NO,
                               --A.CHANNEL_NO_DESC,
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
                                             WHEN A.TELE_TYPE = '2' AND A.IS_NEW = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) CDMA_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE IN ('4', '26') AND A.INNET_METHOD IN ('1','2','4','5','15') AND A.IS_NEW = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) ADSL_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '72' AND A.IS_NEW = '1' THEN
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
                                       A.HUAXIAO_NO_03,
                                       A.XIAOQU_NO,
                                       A.XIAOQU_NAME
                                --A.CHANNEL_NO,
                                --A.CHANNEL_NO_DESC
                                  FROM DW.DW_V_USER_HUAXIAO_INFO_M A
                                 WHERE A.ACCT_MONTH = V_ACCT_MONTH
                                   AND AREA_NO = C1.AREA_NO
                                      -- AND A.IS_VALID = '1'
                                   AND ((A.XIAOQU_NO IS NOT NULL AND
                                       A.TELE_TYPE = '2') OR
                                       A.TELE_TYPE <> '2')
                                   AND A.IS_HUAXIAO_03 = '1'
                                 GROUP BY A.HUAXIAO_NO_03,
                                          A.XIAOQU_NO,
                                          A.XIAOQU_NAME
                                /*A.CHANNEL_NO,
                                A.CHANNEL_NO_DESC*/
                                ) A,
                               (SELECT *
                                  FROM DIM.DIM_XIAOQU_HUAXIAO T
                                 WHERE T.AREA_NO = C1.AREA_NO
                                   AND T.HUAXIAO_TYPE = '03') T
                         WHERE A.HUAXIAO_NO_03 = T.HUAXIAO_NO
                           AND A.XIAOQU_NO = T.XIAOQU_NO
                        UNION ALL
                        ---ũ��֧��
                        SELECT T.AREA_NO,
                               T.CITY_NO,
                               T.HUAXIAO_TYPE,
                               T.HUAXIAO_NO,
                               T.HUAXIAO_NAME,
                               --A.XIAOQU_NO,
                               -- A.XIAOQU_NAME,
                               T.CHANNEL_NO XIAOQU_NO,
                               T.CHANNEL_NO_DESC XIAOQU_NAME,
                               '����' XIAOQU_CHANNEL,
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
                                             WHEN A.TELE_TYPE = '2' AND A.IS_NEW = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) CDMA_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE IN ('4', '26') AND A.INNET_METHOD IN ('1','2','4','5','15') AND A.IS_NEW = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) ADSL_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '72' AND A.IS_NEW = '1' THEN
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
                                       A.HUAXIAO_NO_04,
                                       --A.XIAOQU_NO,
                                       --A.XIAOQU_NAME,
                                       A.CHANNEL_NO,
                                       A.CHANNEL_NO_DESC
                                  FROM DW.DW_V_USER_HUAXIAO_INFO_M A
                                 WHERE A.ACCT_MONTH = V_ACCT_MONTH
                                   AND AREA_NO = C1.AREA_NO
                                      -- AND A.IS_VALID = '1'
                                   AND A.TELE_TYPE = '2'
                                      --AND A.IS_KD_BUNDLE = '0'
                                   AND A.XIAOQU_NO IS NULL
                                   AND A.IS_HUAXIAO_04 = '1'
                                 GROUP BY A.HUAXIAO_NO_04,
                                          --A.XIAOQU_NO,
                                          -- A.XIAOQU_NAME,
                                          A.CHANNEL_NO,
                                          A.CHANNEL_NO_DESC) A,
                               (SELECT *
                                  FROM DIM.DIM_CHANNEL_HUAXIAO T
                                 WHERE T.AREA_NO = C1.AREA_NO
                                   AND T.HUAXIAO_TYPE = '04') T
                         WHERE A.HUAXIAO_NO_04 = T.HUAXIAO_NO
                           AND A.CHANNEL_NO = T.CHANNEL_NO
                        UNION ALL
                        SELECT T.AREA_NO,
                               T.CITY_NO,
                               T.HUAXIAO_TYPE,
                               T.HUAXIAO_NO,
                               T.HUAXIAO_NAME,
                               T.XIAOQU_NO,
                               T.XIAOQU_NAME,
                               'С��' XIAOQU_CHANNEL,
                               --A.CHANNEL_NO,
                               --A.CHANNEL_NO_DESC,
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
                                             WHEN A.TELE_TYPE = '2' AND A.IS_NEW = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) CDMA_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE IN ('4', '26') AND A.INNET_METHOD IN ('1','2','4','5','15') AND A.IS_NEW = '1' THEN
                                              1
                                             ELSE
                                              0
                                           END) ADSL_NUM,
                                       SUM(CASE
                                             WHEN A.TELE_TYPE = '72' AND A.IS_NEW = '1' THEN
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
                                       A.HUAXIAO_NO_04,
                                       A.XIAOQU_NO,
                                       A.XIAOQU_NAME
                                --A.CHANNEL_NO,
                                -- A.CHANNEL_NO_DESC
                                  FROM DW.DW_V_USER_HUAXIAO_INFO_M A
                                 WHERE A.ACCT_MONTH = V_ACCT_MONTH
                                   AND AREA_NO = C1.AREA_NO
                                      -- AND A.IS_VALID = '1'
                                   AND ((A.XIAOQU_NO IS NOT NULL AND
                                       A.TELE_TYPE = '2') OR
                                       A.TELE_TYPE <> '2')
                                   AND A.IS_HUAXIAO_04 = '1'
                                 GROUP BY A.HUAXIAO_NO_04,
                                          A.XIAOQU_NO,
                                          A.XIAOQU_NAME
                                /*A.CHANNEL_NO,
                                A.CHANNEL_NO_DESC*/
                                ) A,
                               (SELECT *
                                  FROM DIM.DIM_XIAOQU_HUAXIAO T
                                 WHERE T.AREA_NO = C1.AREA_NO
                                   AND T.HUAXIAO_TYPE = '04') T
                         WHERE A.HUAXIAO_NO_04 = T.HUAXIAO_NO
                           AND A.XIAOQU_NO = T.XIAOQU_NO) T
                 GROUP BY T.AREA_NO,
                          T.CITY_NO,
                          T.HUAXIAO_TYPE,
                          T.HUAXIAO_NO,
                          T.HUAXIAO_NAME,
                          T.XIAOQU_NO,
                          T.XIAOQU_NAME,
                          T.XIAOQU_CHANNEL
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
                       T.CHANNEL_NO XIAOQU_NO,
                       T.CHANNEL_NO_DESC XIAOQU_NAME,
                       '����' XIAOQU_CHANNEL,
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
                               DEV_SCORE_ALL           AS DEVLP_SORE,
                               INCOME_SCORE_ALL        AS INCOME_SORE,
                               WEIXI_SCORE_ALL         AS WEIXI_SORE,
                               FINE_SCORE_ALL          AS FINE_SORE,
                               JF_SCORE_ALL            AS SUM_SORE,
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
                  T.XIAOQU_CHANNEL
        /*T.CHANNEL_NO,
        T.CHANNEL_NO_DESC*/
        ;
      COMMIT;
    END LOOP;
    --������־
    V_RETCODE := 'SUCCESS';
    P_ALLDM_UPDATE_LOG(V_ACCT_MONTH,
                       V_PKG,
                       V_PROCNAME,
                       '����',
                       'SUCCESS',
                       SYSDATE);

  ELSE
    V_RETCODE := 'WAIT';
    P_ALLDM_UPDATE_LOG(V_ACCT_MONTH,
                       V_PKG,
                       V_PROCNAME,
                       '�ȴ�',
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
