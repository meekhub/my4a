CREATE OR REPLACE PROCEDURE P_CBZS_DM_KKPI_M_DEV_CHANNEL(V_ACCT_MONTH VARCHAR2,
                                                                     V_RETCODE    OUT VARCHAR2,
                                                                     V_RETINFO    OUT VARCHAR2) IS
  /*-----------------------------------------------------------------------
  �� �� ����P_CBZS_DM_KKPI_M_DEV_CHANNEL
  �������ڣ�2017��11��28
  �� д �ˣ�LIANGZHITAO
  ��  ��  ����
  Ŀ �� ��CBZS_DM_KKPI_M_DEV_CHANNEL
  ����˵����(�»�С)��չ�±�
  -----------------------------------------------------------------------*/
  V_PKG        VARCHAR2(40);
  V_PROCNAME   VARCHAR2(40);
  V_COUNT1     NUMBER := 0;
  V_LAST_MONTH VARCHAR2(20);
  /*CURSOR V_AREA IS
  SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018';*/
BEGIN
  V_PKG        := '(�»�С)��չ�±�';
  V_PROCNAME   := 'P_CBZS_DM_KKPI_M_DEV_CHANNEL';
  V_LAST_MONTH := TO_CHAR(ADD_MONTHS(TO_DATE(V_ACCT_MONTH, 'YYYYMM'), -1),
                          'YYYYMM');
  IF SUBSTR(V_LAST_MONTH, 1, 4) < SUBSTR(V_ACCT_MONTH, 1, 4) THEN
    V_LAST_MONTH := V_ACCT_MONTH;
  END IF;
  /*  V_LAST_YEAR  := TO_CHAR(ADD_MONTHS(TO_CHAR(TO_DATE(V_MONTH, 'YYYYMM')),
             -12),
  'YYYYMM');*/
  --��־����
  ALLDM.P_ALLDM_INSERT_LOG(V_ACCT_MONTH, V_PKG, V_PROCNAME, '12', SYSDATE);
  ---------------------------------------------------------------
  -- ���ݲ���

  SELECT COUNT(1)
    INTO V_COUNT1
    FROM ALLDM.ALLDM_EXECUTE_LOG
   WHERE ACCT_MONTH = V_ACCT_MONTH
     AND RESULT = 'SUCCESS'
     AND PROCNAME IN ('P_DM_V_CHANNEL_INFO_M');

  IF V_COUNT1 >= 1 THEN

    DELETE FROM MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_CHANNEL T
     WHERE T.ACCT_MONTH = V_ACCT_MONTH;
    COMMIT;
    --�ƶ���չ
    INSERT INTO MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_CHANNEL
      SELECT V_ACCT_MONTH,
             T.AREA_NO,
             T.CITY_NO,
             T.HUAXIAO_TYPE_BIG,
             T.HUAXIAO_TYPE,
             T.HUAXIAO_NO,
             T.CHANNEL_TYPE,
             T.CHANNEL_NO,
             T.CHANNEL_NAME,
             T.TYPE_ONE,
             T.TYPE_TWO,
             SUM(T.CDMA_NUM),
             SUM(T.LAST_MONTH_VALUE),
             SUM(T.YEAR_VALUE)
        FROM (SELECT T.AREA_NO,
                     T.CITY_NO,
                     '1' HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.HUAXIAO_NO,
                     '' CHANNEL_TYPE,
                     T.XIAOQU_NO CHANNEL_NO,
                     T.XIAOQU_CHANNEL || '_' || T.XIAOQU_NAME CHANNEL_NAME,
                     '01' TYPE_ONE,
                     '01' TYPE_TWO,
                     SUM(T.CDMA_NUM) CDMA_NUM,
                     0 LAST_MONTH_VALUE,
                     SUM(T.CDMA_NUM) YEAR_VALUE
                FROM ALLDM.DM_V_CHANNEL_INFO_M T
               WHERE T.ACCT_MONTH = V_ACCT_MONTH
              --AND T.XIAOQU_CHANNEL = '����'
               GROUP BY T.AREA_NO,
                        T.CITY_NO,
                        T.HUAXIAO_TYPE,
                        T.HUAXIAO_NO,
                        T.XIAOQU_NO,
                        T.XIAOQU_CHANNEL || '_' || T.XIAOQU_NAME
              UNION ALL
              SELECT T.AREA_NO,
                     T.CITY_NO,
                     T.HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.HUAXIAO_NO,
                     T.CHANNEL_TYPE,
                     T.CHANNEL_NO,
                     T.CHANNEL_NAME,
                     T.TYPE_ONE,
                     T.TYPE_TWO,
                     0,
                     T.MONTH_VALUE,
                     CASE WHEN SUBSTR(V_ACCT_MONTH,-2)='01' THEN 0 ELSE T.YEAR_VALUE END
                FROM MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_CHANNEL T
               WHERE ACCT_MONTH = V_LAST_MONTH
                 AND T.TYPE_ONE = '01'
                 AND T.TYPE_TWO = '01') T
       GROUP BY T.AREA_NO,
                T.CITY_NO,
                T.HUAXIAO_TYPE_BIG,
                T.HUAXIAO_TYPE,
                T.HUAXIAO_NO,
                T.CHANNEL_TYPE,
                T.CHANNEL_NO,
                T.CHANNEL_NAME,
                T.TYPE_ONE,
                T.TYPE_TWO;
    COMMIT;

    --�����չ
    INSERT INTO MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_CHANNEL
      SELECT V_ACCT_MONTH,
             T.AREA_NO,
             T.CITY_NO,
             T.HUAXIAO_TYPE_BIG,
             T.HUAXIAO_TYPE,
             T.HUAXIAO_NO,
             T.CHANNEL_TYPE,
             T.CHANNEL_NO,
             T.CHANNEL_NAME,
             T.TYPE_ONE,
             T.TYPE_TWO,
             SUM(T.ADSL_NUM),
             SUM(T.LAST_MONTH_VALUE),
             SUM(T.YEAR_VALUE)
        FROM (SELECT T.AREA_NO,
                     T.CITY_NO,
                     '1' HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.HUAXIAO_NO,
                     '' CHANNEL_TYPE,
                     T.XIAOQU_NO CHANNEL_NO,
                     T.XIAOQU_CHANNEL || '_' || T.XIAOQU_NAME CHANNEL_NAME,
                     '02' TYPE_ONE,
                     '01' TYPE_TWO,
                     SUM(T.ADSL_NUM) ADSL_NUM,
                     0 LAST_MONTH_VALUE,
                     SUM(T.ADSL_NUM) YEAR_VALUE
                FROM ALLDM.DM_V_CHANNEL_INFO_M T
               WHERE T.ACCT_MONTH = V_ACCT_MONTH
              --AND T.XIAOQU_CHANNEL = '����'
               GROUP BY T.AREA_NO,
                        T.CITY_NO,
                        T.HUAXIAO_TYPE,
                        T.HUAXIAO_NO,
                        T.XIAOQU_NO,
                        T.XIAOQU_CHANNEL || '_' || T.XIAOQU_NAME
              UNION ALL
              SELECT T.AREA_NO,
                     T.CITY_NO,
                     T.HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.HUAXIAO_NO,
                     T.CHANNEL_TYPE,
                     T.CHANNEL_NO,
                     T.CHANNEL_NAME,
                     T.TYPE_ONE,
                     T.TYPE_TWO,
                     0,
                     T.MONTH_VALUE,
                     CASE WHEN SUBSTR(V_ACCT_MONTH,-2)='01' THEN 0 ELSE T.YEAR_VALUE END
                FROM MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_CHANNEL T
               WHERE ACCT_MONTH = V_LAST_MONTH
                 AND T.TYPE_ONE = '02'
                 AND T.TYPE_TWO = '01') T
       GROUP BY T.AREA_NO,
                T.CITY_NO,
                T.HUAXIAO_TYPE_BIG,
                T.HUAXIAO_TYPE,
                T.HUAXIAO_NO,
                T.CHANNEL_TYPE,
                T.CHANNEL_NO,
                T.CHANNEL_NAME,
                T.TYPE_ONE,
                T.TYPE_TWO;
    COMMIT;

    --������巢չ
    INSERT INTO MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_CHANNEL
      SELECT V_ACCT_MONTH,
             T.AREA_NO,
             T.CITY_NO,
             T.HUAXIAO_TYPE_BIG,
             T.HUAXIAO_TYPE,
             T.HUAXIAO_NO,
             T.CHANNEL_TYPE,
             T.CHANNEL_NO,
             T.CHANNEL_NAME,
             T.TYPE_ONE,
             T.TYPE_TWO,
             SUM(T.IPTV_NUM),
             SUM(T.LAST_MONTH_VALUE),
             SUM(T.YEAR_VALUE)
        FROM (SELECT T.AREA_NO,
                     T.CITY_NO,
                     '1' HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.HUAXIAO_NO,
                     '' CHANNEL_TYPE,
                     T.XIAOQU_NO CHANNEL_NO,
                     T.XIAOQU_CHANNEL || '_' || T.XIAOQU_NAME CHANNEL_NAME,
                     '03' TYPE_ONE,
                     '01' TYPE_TWO,
                     SUM(T.IPTV_NUM) IPTV_NUM,
                     0 LAST_MONTH_VALUE,
                     SUM(T.IPTV_NUM) YEAR_VALUE
                FROM ALLDM.DM_V_CHANNEL_INFO_M T
               WHERE T.ACCT_MONTH = V_ACCT_MONTH
              --AND T.XIAOQU_CHANNEL = '����'
               GROUP BY T.AREA_NO,
                        T.CITY_NO,
                        T.HUAXIAO_TYPE,
                        T.HUAXIAO_NO,
                        T.XIAOQU_NO,
                        T.XIAOQU_CHANNEL || '_' || T.XIAOQU_NAME
              UNION ALL
              SELECT T.AREA_NO,
                     T.CITY_NO,
                     T.HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.HUAXIAO_NO,
                     T.CHANNEL_TYPE,
                     T.CHANNEL_NO,
                     T.CHANNEL_NAME,
                     T.TYPE_ONE,
                     T.TYPE_TWO,
                     0,
                     T.MONTH_VALUE,
                     CASE WHEN SUBSTR(V_ACCT_MONTH,-2)='01' THEN 0 ELSE T.YEAR_VALUE END
                FROM MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_CHANNEL T
               WHERE ACCT_MONTH = V_LAST_MONTH
                 AND T.TYPE_ONE = '03'
                 AND T.TYPE_TWO = '01') T
       GROUP BY T.AREA_NO,
                T.CITY_NO,
                T.HUAXIAO_TYPE_BIG,
                T.HUAXIAO_TYPE,
                T.HUAXIAO_NO,
                T.CHANNEL_TYPE,
                T.CHANNEL_NO,
                T.CHANNEL_NAME,
                T.TYPE_ONE,
                T.TYPE_TWO;
    COMMIT;

    --�ƶ�����
    INSERT INTO MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_CHANNEL
      SELECT V_ACCT_MONTH,
             T.AREA_NO,
             T.CITY_NO,
             T.HUAXIAO_TYPE_BIG,
             T.HUAXIAO_TYPE,
             T.HUAXIAO_NO,
             T.CHANNEL_TYPE,
             T.CHANNEL_NO,
             T.CHANNEL_NAME,
             T.TYPE_ONE,
             T.TYPE_TWO,
             SUM(T.ONNET_CDMA_NUM),
             SUM(T.LAST_MONTH_VALUE),
             SUM(T.YEAR_VALUE)
        FROM (SELECT T.AREA_NO,
                     T.CITY_NO,
                     '1' HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.HUAXIAO_NO,
                     '' CHANNEL_TYPE,
                     T.XIAOQU_NO CHANNEL_NO,
                     T.XIAOQU_CHANNEL || '_' || T.XIAOQU_NAME CHANNEL_NAME,
                     '04' TYPE_ONE,
                     '01' TYPE_TWO,
                     SUM(T.ONNET_CDMA_NUM) ONNET_CDMA_NUM,
                     0 LAST_MONTH_VALUE,
                     SUM(T.ONNET_CDMA_NUM) YEAR_VALUE
                FROM ALLDM.DM_V_CHANNEL_INFO_M T
               WHERE T.ACCT_MONTH = V_ACCT_MONTH
              --AND T.XIAOQU_CHANNEL = '����'
               GROUP BY T.AREA_NO,
                        T.CITY_NO,
                        T.HUAXIAO_TYPE,
                        T.HUAXIAO_NO,
                        T.XIAOQU_NO,
                        T.XIAOQU_CHANNEL || '_' || T.XIAOQU_NAME
              UNION ALL
              SELECT T.AREA_NO,
                     T.CITY_NO,
                     T.HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.HUAXIAO_NO,
                     T.CHANNEL_TYPE,
                     T.CHANNEL_NO,
                     T.CHANNEL_NAME,
                     T.TYPE_ONE,
                     T.TYPE_TWO,
                     0,
                     T.MONTH_VALUE,
                     0 YEAR_VALUE
                FROM MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_CHANNEL T
               WHERE ACCT_MONTH = V_LAST_MONTH
                 AND T.TYPE_ONE = '04'
                 AND T.TYPE_TWO = '01') T
       GROUP BY T.AREA_NO,
                T.CITY_NO,
                T.HUAXIAO_TYPE_BIG,
                T.HUAXIAO_TYPE,
                T.HUAXIAO_NO,
                T.CHANNEL_TYPE,
                T.CHANNEL_NO,
                T.CHANNEL_NAME,
                T.TYPE_ONE,
                T.TYPE_TWO;
    COMMIT;

    --�������
    INSERT INTO MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_CHANNEL
      SELECT V_ACCT_MONTH,
             T.AREA_NO,
             T.CITY_NO,
             T.HUAXIAO_TYPE_BIG,
             T.HUAXIAO_TYPE,
             T.HUAXIAO_NO,
             T.CHANNEL_TYPE,
             T.CHANNEL_NO,
             T.CHANNEL_NAME,
             T.TYPE_ONE,
             T.TYPE_TWO,
             SUM(T.ONNET_ADSL_NUM),
             SUM(T.LAST_MONTH_VALUE),
             SUM(T.YEAR_VALUE)
        FROM (SELECT T.AREA_NO,
                     T.CITY_NO,
                     '1' HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.HUAXIAO_NO,
                     '' CHANNEL_TYPE,
                     T.XIAOQU_NO CHANNEL_NO,
                     T.XIAOQU_CHANNEL || '_' || T.XIAOQU_NAME CHANNEL_NAME,
                     '05' TYPE_ONE,
                     '01' TYPE_TWO,
                     SUM(T.ONNET_ADSL_NUM) ONNET_ADSL_NUM,
                     0 LAST_MONTH_VALUE,
                     SUM(T.ONNET_ADSL_NUM) YEAR_VALUE
                FROM ALLDM.DM_V_CHANNEL_INFO_M T
               WHERE T.ACCT_MONTH = V_ACCT_MONTH
              --AND T.XIAOQU_CHANNEL = '����'
               GROUP BY T.AREA_NO,
                        T.CITY_NO,
                        T.HUAXIAO_TYPE,
                        T.HUAXIAO_NO,
                        T.XIAOQU_NO,
                        T.XIAOQU_CHANNEL || '_' || T.XIAOQU_NAME
              UNION ALL
              SELECT T.AREA_NO,
                     T.CITY_NO,
                     T.HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.HUAXIAO_NO,
                     T.CHANNEL_TYPE,
                     T.CHANNEL_NO,
                     T.CHANNEL_NAME,
                     T.TYPE_ONE,
                     T.TYPE_TWO,
                     0,
                     T.MONTH_VALUE,
                     0 YEAR_VALUE
                FROM MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_CHANNEL T
               WHERE ACCT_MONTH = V_LAST_MONTH
                 AND T.TYPE_ONE = '05'
                 AND T.TYPE_TWO = '01') T
       GROUP BY T.AREA_NO,
                T.CITY_NO,
                T.HUAXIAO_TYPE_BIG,
                T.HUAXIAO_TYPE,
                T.HUAXIAO_NO,
                T.CHANNEL_TYPE,
                T.CHANNEL_NO,
                T.CHANNEL_NAME,
                T.TYPE_ONE,
                T.TYPE_TWO;
    COMMIT;

    --�����������
    INSERT INTO MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_CHANNEL
      SELECT V_ACCT_MONTH,
             T.AREA_NO,
             T.CITY_NO,
             T.HUAXIAO_TYPE_BIG,
             T.HUAXIAO_TYPE,
             T.HUAXIAO_NO,
             T.CHANNEL_TYPE,
             T.CHANNEL_NO,
             T.CHANNEL_NAME,
             T.TYPE_ONE,
             T.TYPE_TWO,
             SUM(T.ONNET_IPTV_NUM),
             SUM(T.LAST_MONTH_VALUE),
             SUM(T.YEAR_VALUE)
        FROM (SELECT T.AREA_NO,
                     T.CITY_NO,
                     '1' HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.HUAXIAO_NO,
                     '' CHANNEL_TYPE,
                     T.XIAOQU_NO CHANNEL_NO,
                     T.XIAOQU_CHANNEL || '_' || T.XIAOQU_NAME CHANNEL_NAME,
                     '06' TYPE_ONE,
                     '01' TYPE_TWO,
                     SUM(T.ONNET_IPTV_NUM) ONNET_IPTV_NUM,
                     0 LAST_MONTH_VALUE,
                     SUM(T.ONNET_IPTV_NUM) YEAR_VALUE
                FROM ALLDM.DM_V_CHANNEL_INFO_M T
               WHERE T.ACCT_MONTH = V_ACCT_MONTH
              --AND T.XIAOQU_CHANNEL = '����'
               GROUP BY T.AREA_NO,
                        T.CITY_NO,
                        T.HUAXIAO_TYPE,
                        T.HUAXIAO_NO,
                        T.XIAOQU_NO,
                        T.XIAOQU_CHANNEL || '_' || T.XIAOQU_NAME
              UNION ALL
              SELECT T.AREA_NO,
                     T.CITY_NO,
                     T.HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.HUAXIAO_NO,
                     T.CHANNEL_TYPE,
                     T.CHANNEL_NO,
                     T.CHANNEL_NAME,
                     T.TYPE_ONE,
                     T.TYPE_TWO,
                     0,
                     T.MONTH_VALUE,
                     0 YEAR_VALUE
                FROM MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_CHANNEL T
               WHERE ACCT_MONTH = V_LAST_MONTH
                 AND T.TYPE_ONE = '06'
                 AND T.TYPE_TWO = '01') T
       GROUP BY T.AREA_NO,
                T.CITY_NO,
                T.HUAXIAO_TYPE_BIG,
                T.HUAXIAO_TYPE,
                T.HUAXIAO_NO,
                T.CHANNEL_TYPE,
                T.CHANNEL_NO,
                T.CHANNEL_NAME,
                T.TYPE_ONE,
                T.TYPE_TWO;
    COMMIT;

    --�ƶ�����
    INSERT INTO MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_CHANNEL
      SELECT V_ACCT_MONTH,
             T.AREA_NO,
             T.CITY_NO,
             T.HUAXIAO_TYPE_BIG,
             T.HUAXIAO_TYPE,
             T.HUAXIAO_NO,
             T.CHANNEL_TYPE,
             T.CHANNEL_NO,
             T.CHANNEL_NAME,
             T.TYPE_ONE,
             T.TYPE_TWO,
             SUM(T.ACCT_CDMA_NUM),
             SUM(T.LAST_MONTH_VALUE),
             SUM(T.YEAR_VALUE)
        FROM (SELECT T.AREA_NO,
                     T.CITY_NO,
                     '1' HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.HUAXIAO_NO,
                     '' CHANNEL_TYPE,
                     T.XIAOQU_NO CHANNEL_NO,
                     T.XIAOQU_CHANNEL || '_' || T.XIAOQU_NAME CHANNEL_NAME,
                     '07' TYPE_ONE,
                     '01' TYPE_TWO,
                     SUM(T.ACCT_CDMA_NUM) ACCT_CDMA_NUM,
                     0 LAST_MONTH_VALUE,
                     SUM(T.ACCT_CDMA_NUM) YEAR_VALUE
                FROM ALLDM.DM_V_CHANNEL_INFO_M T
               WHERE T.ACCT_MONTH = V_ACCT_MONTH
              --AND T.XIAOQU_CHANNEL = '����'
               GROUP BY T.AREA_NO,
                        T.CITY_NO,
                        T.HUAXIAO_TYPE,
                        T.HUAXIAO_NO,
                        T.XIAOQU_NO,
                        T.XIAOQU_CHANNEL || '_' || T.XIAOQU_NAME
              UNION ALL
              SELECT T.AREA_NO,
                     T.CITY_NO,
                     T.HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.HUAXIAO_NO,
                     T.CHANNEL_TYPE,
                     T.CHANNEL_NO,
                     T.CHANNEL_NAME,
                     T.TYPE_ONE,
                     T.TYPE_TWO,
                     0,
                     T.MONTH_VALUE,
                     0 YEAR_VALUE
                FROM MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_CHANNEL T
               WHERE ACCT_MONTH = V_LAST_MONTH
                 AND T.TYPE_ONE = '07'
                 AND T.TYPE_TWO = '01') T
       GROUP BY T.AREA_NO,
                T.CITY_NO,
                T.HUAXIAO_TYPE_BIG,
                T.HUAXIAO_TYPE,
                T.HUAXIAO_NO,
                T.CHANNEL_TYPE,
                T.CHANNEL_NO,
                T.CHANNEL_NAME,
                T.TYPE_ONE,
                T.TYPE_TWO;
    COMMIT;

    --�������
    INSERT INTO MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_CHANNEL
      SELECT V_ACCT_MONTH,
             T.AREA_NO,
             T.CITY_NO,
             T.HUAXIAO_TYPE_BIG,
             T.HUAXIAO_TYPE,
             T.HUAXIAO_NO,
             T.CHANNEL_TYPE,
             T.CHANNEL_NO,
             T.CHANNEL_NAME,
             T.TYPE_ONE,
             T.TYPE_TWO,
             SUM(T.ACCT_ADSL_NUM),
             SUM(T.LAST_MONTH_VALUE),
             SUM(T.YEAR_VALUE)
        FROM (SELECT T.AREA_NO,
                     T.CITY_NO,
                     '1' HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.HUAXIAO_NO,
                     '' CHANNEL_TYPE,
                     T.XIAOQU_NO CHANNEL_NO,
                     T.XIAOQU_CHANNEL || '_' || T.XIAOQU_NAME CHANNEL_NAME,
                     '08' TYPE_ONE,
                     '01' TYPE_TWO,
                     SUM(T.ACCT_ADSL_NUM) ACCT_ADSL_NUM,
                     0 LAST_MONTH_VALUE,
                     SUM(T.ACCT_ADSL_NUM) YEAR_VALUE
                FROM ALLDM.DM_V_CHANNEL_INFO_M T
               WHERE T.ACCT_MONTH = V_ACCT_MONTH
              --AND T.XIAOQU_CHANNEL = '����'
               GROUP BY T.AREA_NO,
                        T.CITY_NO,
                        T.HUAXIAO_TYPE,
                        T.HUAXIAO_NO,
                        T.XIAOQU_NO,
                        T.XIAOQU_CHANNEL || '_' || T.XIAOQU_NAME
              UNION ALL
              SELECT T.AREA_NO,
                     T.CITY_NO,
                     T.HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.HUAXIAO_NO,
                     T.CHANNEL_TYPE,
                     T.CHANNEL_NO,
                     T.CHANNEL_NAME,
                     T.TYPE_ONE,
                     T.TYPE_TWO,
                     0,
                     T.MONTH_VALUE,
                     0 YEAR_VALUE
                FROM MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_CHANNEL T
               WHERE ACCT_MONTH = V_LAST_MONTH
                 AND T.TYPE_ONE = '08'
                 AND T.TYPE_TWO = '01') T
       GROUP BY T.AREA_NO,
                T.CITY_NO,
                T.HUAXIAO_TYPE_BIG,
                T.HUAXIAO_TYPE,
                T.HUAXIAO_NO,
                T.CHANNEL_TYPE,
                T.CHANNEL_NO,
                T.CHANNEL_NAME,
                T.TYPE_ONE,
                T.TYPE_TWO;
    COMMIT;

    --����������
    INSERT INTO MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_CHANNEL
      SELECT V_ACCT_MONTH,
             T.AREA_NO,
             T.CITY_NO,
             T.HUAXIAO_TYPE_BIG,
             T.HUAXIAO_TYPE,
             T.HUAXIAO_NO,
             T.CHANNEL_TYPE,
             T.CHANNEL_NO,
             T.CHANNEL_NAME,
             T.TYPE_ONE,
             T.TYPE_TWO,
             SUM(T.ACCT_IPTV_NUM),
             SUM(T.LAST_MONTH_VALUE),
             SUM(T.YEAR_VALUE)
        FROM (SELECT T.AREA_NO,
                     T.CITY_NO,
                     '1' HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.HUAXIAO_NO,
                     '' CHANNEL_TYPE,
                     T.XIAOQU_NO CHANNEL_NO,
                     T.XIAOQU_CHANNEL || '_' || T.XIAOQU_NAME CHANNEL_NAME,
                     '09' TYPE_ONE,
                     '01' TYPE_TWO,
                     SUM(T.ACCT_IPTV_NUM) ACCT_IPTV_NUM,
                     0 LAST_MONTH_VALUE,
                     SUM(T.ACCT_IPTV_NUM) YEAR_VALUE
                FROM ALLDM.DM_V_CHANNEL_INFO_M T
               WHERE T.ACCT_MONTH = V_ACCT_MONTH
              --AND T.XIAOQU_CHANNEL = '����'
               GROUP BY T.AREA_NO,
                        T.CITY_NO,
                        T.HUAXIAO_TYPE,
                        T.HUAXIAO_NO,
                        T.XIAOQU_NO,
                        T.XIAOQU_CHANNEL || '_' || T.XIAOQU_NAME
              UNION ALL
              SELECT T.AREA_NO,
                     T.CITY_NO,
                     T.HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.HUAXIAO_NO,
                     T.CHANNEL_TYPE,
                     T.CHANNEL_NO,
                     T.CHANNEL_NAME,
                     T.TYPE_ONE,
                     T.TYPE_TWO,
                     0,
                     T.MONTH_VALUE,
                     0 YEAR_VALUE
                FROM MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_CHANNEL T
               WHERE ACCT_MONTH = V_LAST_MONTH
                 AND T.TYPE_ONE = '09'
                 AND T.TYPE_TWO = '01') T
       GROUP BY T.AREA_NO,
                T.CITY_NO,
                T.HUAXIAO_TYPE_BIG,
                T.HUAXIAO_TYPE,
                T.HUAXIAO_NO,
                T.CHANNEL_TYPE,
                T.CHANNEL_NO,
                T.CHANNEL_NAME,
                T.TYPE_ONE,
                T.TYPE_TWO;
    COMMIT;

    --�ƶ� ����
    INSERT INTO MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_CHANNEL
      SELECT V_ACCT_MONTH,
             T.AREA_NO,
             T.CITY_NO,
             T.HUAXIAO_TYPE_BIG,
             T.HUAXIAO_TYPE,
             T.HUAXIAO_NO,
             T.CHANNEL_TYPE,
             T.CHANNEL_NO,
             T.CHANNEL_NAME,
             T.TYPE_ONE,
             T.TYPE_TWO,
             SUM(T.JZ_CDMA_NUM),
             SUM(T.LAST_MONTH_VALUE),
             SUM(T.YEAR_VALUE)
        FROM (SELECT T.AREA_NO,
                     T.CITY_NO,
                     '1' HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.HUAXIAO_NO,
                     '' CHANNEL_TYPE,
                     T.XIAOQU_NO CHANNEL_NO,
                     T.XIAOQU_CHANNEL || '_' || T.XIAOQU_NAME CHANNEL_NAME,
                     '10' TYPE_ONE,
                     '01' TYPE_TWO,
                     SUM(T.JZ_CDMA_NUM) JZ_CDMA_NUM,
                     0 LAST_MONTH_VALUE,
                     SUM(T.JZ_CDMA_NUM) YEAR_VALUE
                FROM ALLDM.DM_V_CHANNEL_INFO_M T
               WHERE T.ACCT_MONTH = V_ACCT_MONTH
              --AND T.XIAOQU_CHANNEL = '����'
               GROUP BY T.AREA_NO,
                        T.CITY_NO,
                        T.HUAXIAO_TYPE,
                        T.HUAXIAO_NO,
                        T.XIAOQU_NO,
                        T.XIAOQU_CHANNEL || '_' || T.XIAOQU_NAME
              UNION ALL
              SELECT T.AREA_NO,
                     T.CITY_NO,
                     T.HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.HUAXIAO_NO,
                     T.CHANNEL_TYPE,
                     T.CHANNEL_NO,
                     T.CHANNEL_NAME,
                     T.TYPE_ONE,
                     T.TYPE_TWO,
                     0,
                     T.MONTH_VALUE,
                     CASE WHEN SUBSTR(V_ACCT_MONTH,-2)='01' THEN 0 ELSE T.YEAR_VALUE END
                FROM MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_CHANNEL T
               WHERE ACCT_MONTH = V_LAST_MONTH
                 AND T.TYPE_ONE = '10'
                 AND T.TYPE_TWO = '01') T
       GROUP BY T.AREA_NO,
                T.CITY_NO,
                T.HUAXIAO_TYPE_BIG,
                T.HUAXIAO_TYPE,
                T.HUAXIAO_NO,
                T.CHANNEL_TYPE,
                T.CHANNEL_NO,
                T.CHANNEL_NAME,
                T.TYPE_ONE,
                T.TYPE_TWO;
    COMMIT;

    --��� ����
    INSERT INTO MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_CHANNEL
      SELECT V_ACCT_MONTH,
             T.AREA_NO,
             T.CITY_NO,
             T.HUAXIAO_TYPE_BIG,
             T.HUAXIAO_TYPE,
             T.HUAXIAO_NO,
             T.CHANNEL_TYPE,
             T.CHANNEL_NO,
             T.CHANNEL_NAME,
             T.TYPE_ONE,
             T.TYPE_TWO,
             SUM(T.JZ_ADSL_NUM),
             SUM(T.LAST_MONTH_VALUE),
             SUM(T.YEAR_VALUE)
        FROM (SELECT T.AREA_NO,
                     T.CITY_NO,
                     '1' HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.HUAXIAO_NO,
                     '' CHANNEL_TYPE,
                     T.XIAOQU_NO CHANNEL_NO,
                     T.XIAOQU_CHANNEL || '_' || T.XIAOQU_NAME CHANNEL_NAME,
                     '11' TYPE_ONE,
                     '01' TYPE_TWO,
                     SUM(T.JZ_ADSL_NUM) JZ_ADSL_NUM,
                     0 LAST_MONTH_VALUE,
                     SUM(T.JZ_ADSL_NUM) YEAR_VALUE
                FROM ALLDM.DM_V_CHANNEL_INFO_M T
               WHERE T.ACCT_MONTH = V_ACCT_MONTH
              --AND T.XIAOQU_CHANNEL = '����'
               GROUP BY T.AREA_NO,
                        T.CITY_NO,
                        T.HUAXIAO_TYPE,
                        T.HUAXIAO_NO,
                        T.XIAOQU_NO,
                        T.XIAOQU_CHANNEL || '_' || T.XIAOQU_NAME
              UNION ALL
              SELECT T.AREA_NO,
                     T.CITY_NO,
                     T.HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.HUAXIAO_NO,
                     T.CHANNEL_TYPE,
                     T.CHANNEL_NO,
                     T.CHANNEL_NAME,
                     T.TYPE_ONE,
                     T.TYPE_TWO,
                     0,
                     T.MONTH_VALUE,
                     CASE WHEN SUBSTR(V_ACCT_MONTH,-2)='01' THEN 0 ELSE T.YEAR_VALUE END
                FROM MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_CHANNEL T
               WHERE ACCT_MONTH = V_LAST_MONTH
                 AND T.TYPE_ONE = '11'
                 AND T.TYPE_TWO = '01') T
       GROUP BY T.AREA_NO,
                T.CITY_NO,
                T.HUAXIAO_TYPE_BIG,
                T.HUAXIAO_TYPE,
                T.HUAXIAO_NO,
                T.CHANNEL_TYPE,
                T.CHANNEL_NO,
                T.CHANNEL_NAME,
                T.TYPE_ONE,
                T.TYPE_TWO;
    COMMIT;

    --IPTV ����
    INSERT INTO MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_CHANNEL
      SELECT V_ACCT_MONTH,
             T.AREA_NO,
             T.CITY_NO,
             T.HUAXIAO_TYPE_BIG,
             T.HUAXIAO_TYPE,
             T.HUAXIAO_NO,
             T.CHANNEL_TYPE,
             T.CHANNEL_NO,
             T.CHANNEL_NAME,
             T.TYPE_ONE,
             T.TYPE_TWO,
             SUM(T.JZ_IPTV_NUM),
             SUM(T.LAST_MONTH_VALUE),
             SUM(T.YEAR_VALUE)
        FROM (SELECT T.AREA_NO,
                     T.CITY_NO,
                     '1' HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.HUAXIAO_NO,
                     '' CHANNEL_TYPE,
                     T.XIAOQU_NO CHANNEL_NO,
                     T.XIAOQU_CHANNEL || '_' || T.XIAOQU_NAME CHANNEL_NAME,
                     '12' TYPE_ONE,
                     '01' TYPE_TWO,
                     SUM(T.JZ_IPTV_NUM) JZ_IPTV_NUM,
                     0 LAST_MONTH_VALUE,
                     SUM(T.JZ_IPTV_NUM) YEAR_VALUE
                FROM ALLDM.DM_V_CHANNEL_INFO_M T
               WHERE T.ACCT_MONTH = V_ACCT_MONTH
              --AND T.XIAOQU_CHANNEL = '����'
               GROUP BY T.AREA_NO,
                        T.CITY_NO,
                        T.HUAXIAO_TYPE,
                        T.HUAXIAO_NO,
                        T.XIAOQU_NO,
                        T.XIAOQU_CHANNEL || '_' || T.XIAOQU_NAME
              UNION ALL
              SELECT T.AREA_NO,
                     T.CITY_NO,
                     T.HUAXIAO_TYPE_BIG,
                     T.HUAXIAO_TYPE,
                     T.HUAXIAO_NO,
                     T.CHANNEL_TYPE,
                     T.CHANNEL_NO,
                     T.CHANNEL_NAME,
                     T.TYPE_ONE,
                     T.TYPE_TWO,
                     0,
                     T.MONTH_VALUE,
                     CASE WHEN SUBSTR(V_ACCT_MONTH,-2)='01' THEN 0 ELSE T.YEAR_VALUE END
                FROM MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_CHANNEL T
               WHERE ACCT_MONTH = V_LAST_MONTH
                 AND T.TYPE_ONE = '12'
                 AND T.TYPE_TWO = '01') T
       GROUP BY T.AREA_NO,
                T.CITY_NO,
                T.HUAXIAO_TYPE_BIG,
                T.HUAXIAO_TYPE,
                T.HUAXIAO_NO,
                T.CHANNEL_TYPE,
                T.CHANNEL_NO,
                T.CHANNEL_NAME,
                T.TYPE_ONE,
                T.TYPE_TWO;
    COMMIT;

    ------����һ����������
    delete from MOBILE_CBZS.CBZS_DM_KKPI_M_DEV
    where acct_month=v_acct_month;
    commit;
    INSERT INTO MOBILE_CBZS.CBZS_DM_KKPI_M_DEV
      SELECT ACCT_MONTH,
             AREA_NO,
             CITY_NO,
             HUAXIAO_TYPE_BIG,
             HUAXIAO_TYPE,
             HUAXIAO_NO,
             TYPE_ONE,
             TYPE_TWO,
             SUM(MONTH_VALUE),
             SUM(LAST_MONTH_VALUE),
             SUM(YEAR_VALUE)
        FROM MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_CHANNEL
       WHERE ACCT_MONTH = V_ACCT_MONTH
       GROUP BY ACCT_MONTH,
                AREA_NO,
                CITY_NO,
                HUAXIAO_TYPE_BIG,
                HUAXIAO_TYPE,
                HUAXIAO_NO,
                TYPE_ONE,
                TYPE_TWO;
    COMMIT;


    ------���������������
    delete from MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_ADMIN
    where acct_month=v_acct_month;
    commit;
    INSERT INTO MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_ADMIN
      SELECT ACCT_MONTH,
             AREA_NO,
             CITY_NO,
             HUAXIAO_TYPE_BIG,
             HUAXIAO_TYPE,
             TYPE_ONE,
             TYPE_TWO,
             SUM(MONTH_VALUE),
             SUM(LAST_MONTH_VALUE),
             SUM(YEAR_VALUE)
        FROM MOBILE_CBZS.CBZS_DM_KKPI_M_DEV_CHANNEL
       WHERE ACCT_MONTH = V_ACCT_MONTH
       GROUP BY ACCT_MONTH,
                AREA_NO,
                CITY_NO,
                HUAXIAO_TYPE_BIG,
                HUAXIAO_TYPE,
                TYPE_ONE,
                TYPE_TWO;
    COMMIT;


    --������־
    V_RETCODE := 'SUCCESS';
    ALLDM.P_ALLDM_UPDATE_LOG(V_ACCT_MONTH,
                             V_PKG,
                             V_PROCNAME,
                             '����',
                             V_RETCODE,
                             SYSDATE);
    DBMS_OUTPUT.PUT_LINE(V_RETCODE);
    ------------------------------------- ���ݲ��ֽ��� -------------------------
  ELSE
    V_RETCODE := 'WAIT';
    ALLDM.P_ALLDM_UPDATE_LOG(V_ACCT_MONTH,
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
    ALLDM.P_ALLDM_UPDATE_LOG(V_ACCT_MONTH,
                             V_PKG,
                             V_PROCNAME,
                             V_RETINFO,
                             V_RETCODE,
                             SYSDATE);
END;
/
