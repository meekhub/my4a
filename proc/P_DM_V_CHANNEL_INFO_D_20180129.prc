CREATE OR REPLACE PROCEDURE P_DM_V_CHANNEL_INFO_D(V_date     VARCHAR2,
                                                  V_RETCODE OUT VARCHAR2,
                                                  V_RETINFO OUT VARCHAR2) IS
  /*****************************************************************
  *���� --%NAME:P_DM_V_CHANNEL_INFO_D
  *�������� --%COMMENT:
  *ִ������ --%PERIOD: ��
  *���� --%PARAM:V_ACCT_MONTH  ����,��ʽYYYYMM
  *���� --%PARAM:V_RETCODE  �������н����ɹ�����־
  *���� --%PARAM:V_RETCODE  �������н����ɹ��������
  *������ --%CREATOR:LIANGZHITAO
  *����ʱ�� --%CREATED_TIME:2017-11-08
  *��ע --%REMARK:
  *��Դ�� --%FROM:
  *Ŀ��� --%TO:
  *�޸ļ�¼ --%MODIFY:
  *******************************************************************/
  V_PKG      VARCHAR2(40);
  V_PROCNAME VARCHAR2(40);
  V_COUNT    NUMBER;
  v_month    varchar2(50);
  v_day      varchar2(50);
  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018';
BEGIN
  V_PKG      := '����С������';
  V_PROCNAME := 'P_DM_V_CHANNEL_INFO_D';
  v_month     := substr(v_date,1,6);
  v_day       :=  substr(v_date,7,2);
  SELECT COUNT(1)
    INTO V_COUNT
    FROM DW.DW_EXECUTE_LOG A
   WHERE A.ACCT_MONTH = V_DATE
     AND A.PROCNAME IN ('P_DW_V_USER_HUAXIAO_INFO_D')
     AND A.RESULT = 'SUCCESS';

  --������־
  P_ALLDM_INSERT_LOG(V_DATE, V_PKG, V_PROCNAME, '12', SYSDATE);

  IF V_COUNT = 1 THEN

    --============================== ����С������ ===========================================

    --ɾ����������
    DELETE FROM ALLDM.DM_V_CHANNEL_INFO_D WHERE DAY_ID = V_DATE;
    COMMIT;
    --��ʽ����
    FOR C1 IN V_AREA LOOP
      ---��Ӫ��
      INSERT /*+APPEND*/
      INTO ALLDM.DM_V_CHANNEL_INFO_D
        SELECT v_date,
               T.AREA_NO,
               T.CITY_NO,
               T.HUAXIAO_TYPE,
               T.HUAXIAO_NO,
               T.HUAXIAO_NAME,
               T.XIAOQU_NO,
               T.XIAOQU_NAME,
               T.XIAOQU_CHANNEL,
               SUM(NEW_NUM) NEW_NUM,
               SUM(CDMA_NUM) CDMA_NUM,
               SUM(ADSL_NUM) ADSL_NUM,
               SUM(IPTV_NUM) IPTV_NUM
          FROM (SELECT T.AREA_NO,
                       T.CITY_NO,
                       T.HUAXIAO_TYPE,
                       T.HUAXIAO_NO,
                       T.HUAXIAO_NAME,
                       A.CHANNEL_NO XIAOQU_NO,
                       A.CHANNEL_NO_DESC XIAOQU_NAME,
                       '����' XIAOQU_CHANNEL,
                       A.CDMA_NUM + A.ADSL_NUM + A.IPTV_NUM NEW_NUM,
                       A.CDMA_NUM,
                       A.ADSL_NUM,
                       A.IPTV_NUM
                  FROM (SELECT SUM(CASE
                                     WHEN A.TELE_TYPE = '2' AND A.IS_NEW = '1' THEN
                                      1
                                     ELSE
                                      0
                                   END) CDMA_NUM,
                               SUM(CASE
                                     WHEN A.TELE_TYPE IN ('4', '26') AND A.IS_NEW = '1' THEN
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
                               A.HUAXIAO_NO_01,
                               A.CHANNEL_NO,
                               A.CHANNEL_NO_DESC
                          FROM DW.DW_V_USER_HUAXIAO_INFO_D A
                         WHERE A.ACCT_MONTH = V_MONTH
                           AND A.DAY_ID = V_DAY
                           AND AREA_NO = C1.AREA_NO
                           AND A.CHANNEL_NO IS NOT NULL
                           AND A.IS_HUAXIAO_01 = '1'
                         GROUP BY A.HUAXIAO_NO_01,
                                  A.CHANNEL_NO,
                                  A.CHANNEL_NO_DESC) A,
                       (SELECT *
                          FROM DIM.DIM_CHANNEL_HUAXIAO T
                         WHERE T.AREA_NO = C1.AREA_NO
                           AND T.HUAXIAO_TYPE = '01') T
                 WHERE A.HUAXIAO_NO_01 = T.HUAXIAO_NO
                UNION ALL
                ---��Ȧ
                SELECT T.AREA_NO,
                       T.CITY_NO,
                       T.HUAXIAO_TYPE,
                       T.HUAXIAO_NO,
                       T.HUAXIAO_NAME,
                       A.CHANNEL_NO XIAOQU_NO,
                       A.CHANNEL_NO_DESC XIAOQU_NAME,
                       '����' XIAOQU_CHANNEL,
                       A.CDMA_NUM + A.ADSL_NUM + A.IPTV_NUM NEW_NUM,
                       A.CDMA_NUM,
                       A.ADSL_NUM,
                       A.IPTV_NUM
                  FROM (SELECT SUM(CASE
                                     WHEN A.TELE_TYPE = '2' AND A.IS_NEW = '1' THEN
                                      1
                                     ELSE
                                      0
                                   END) CDMA_NUM,
                               SUM(CASE
                                     WHEN A.TELE_TYPE IN ('4', '26') AND A.IS_NEW = '1' THEN
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
                               A.HUAXIAO_NO_02,
                               A.CHANNEL_NO,
                               A.CHANNEL_NO_DESC
                          FROM DW.DW_V_USER_HUAXIAO_INFO_D A
                         WHERE A.ACCT_MONTH = V_MONTH
                           AND A.DAY_ID = V_DAY
                           AND AREA_NO = C1.AREA_NO
                           AND A.CHANNEL_NO IS NOT NULL
                           AND A.IS_HUAXIAO_02 = '1'
                         GROUP BY A.HUAXIAO_NO_02,
                                  A.CHANNEL_NO,
                                  A.CHANNEL_NO_DESC) A,
                       (SELECT *
                          FROM DIM.DIM_CHANNEL_HUAXIAO T
                         WHERE T.AREA_NO = C1.AREA_NO
                           AND T.HUAXIAO_TYPE = '02') T
                 WHERE A.HUAXIAO_NO_02 = T.HUAXIAO_NO
                UNION ALL
                ---����֧��
                SELECT T.AREA_NO,
                       T.CITY_NO,
                       T.HUAXIAO_TYPE,
                       T.HUAXIAO_NO,
                       T.HUAXIAO_NAME,
                       A.CHANNEL_NO XIAOQU_NO,
                       A.CHANNEL_NO_DESC XIAOQU_NAME,
                       '����' XIAOQU_CHANNEL,
                       A.CDMA_NUM + A.ADSL_NUM + A.IPTV_NUM NEW_NUM,
                       A.CDMA_NUM,
                       A.ADSL_NUM,
                       A.IPTV_NUM
                  FROM (SELECT SUM(CASE
                                     WHEN A.TELE_TYPE = '2' AND A.IS_NEW = '1' THEN
                                      1
                                     ELSE
                                      0
                                   END) CDMA_NUM,
                               SUM(CASE
                                     WHEN A.TELE_TYPE IN ('4', '26') AND A.IS_NEW = '1' THEN
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
                               A.HUAXIAO_NO_03,
                               A.CHANNEL_NO,
                               A.CHANNEL_NO_DESC
                          FROM DW.DW_V_USER_HUAXIAO_INFO_D A
                         WHERE A.ACCT_MONTH = V_MONTH
                           AND A.DAY_ID = V_DAY
                           AND AREA_NO = C1.AREA_NO
                           AND A.IS_KD_BUNDLE = '0'
                           AND A.TELE_TYPE = '2'
                           AND A.IS_HUAXIAO_03 = '1'
                         GROUP BY A.HUAXIAO_NO_03,
                                  A.CHANNEL_NO,
                                  A.CHANNEL_NO_DESC) A,
                       (SELECT *
                          FROM DIM.DIM_CHANNEL_HUAXIAO T
                         WHERE T.AREA_NO = C1.AREA_NO
                           AND T.HUAXIAO_TYPE = '03') T
                 WHERE A.HUAXIAO_NO_03 = T.HUAXIAO_NO
                UNION ALL
                SELECT T.AREA_NO,
                       T.CITY_NO,
                       T.HUAXIAO_TYPE,
                       T.HUAXIAO_NO,
                       T.HUAXIAO_NAME,
                       A.XIAOQU_NO,
                       A.XIAOQU_NAME,
                       'С��' XIAOQU_CHANNEL,
                       A.CDMA_NUM + A.ADSL_NUM + A.IPTV_NUM NEW_NUM,
                       A.CDMA_NUM,
                       A.ADSL_NUM,
                       A.IPTV_NUM
                  FROM (SELECT SUM(CASE
                                     WHEN A.TELE_TYPE = '2' AND A.IS_NEW = '1' THEN
                                      1
                                     ELSE
                                      0
                                   END) CDMA_NUM,
                               SUM(CASE
                                     WHEN A.TELE_TYPE IN ('4', '26') AND A.IS_NEW = '1' THEN
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
                               A.HUAXIAO_NO_03,
                               A.XIAOQU_NO,
                               A.XIAOQU_NAME
                          FROM DW.DW_V_USER_HUAXIAO_INFO_D A
                         WHERE A.ACCT_MONTH = V_MONTH
                           AND A.DAY_ID = V_DAY
                           AND AREA_NO = C1.AREA_NO
                           AND ((A.IS_KD_BUNDLE <> '0' AND A.TELE_TYPE = '2') OR
                               A.TELE_TYPE <> '2')
                           AND A.IS_HUAXIAO_03 = '1'
                         GROUP BY A.HUAXIAO_NO_03, A.XIAOQU_NO, A.XIAOQU_NAME) A,
                       (SELECT *
                          FROM DIM.DIM_CHANNEL_HUAXIAO T
                         WHERE T.AREA_NO = C1.AREA_NO
                           AND T.HUAXIAO_TYPE = '03') T
                 WHERE A.HUAXIAO_NO_03 = T.HUAXIAO_NO
                UNION ALL
                ---ũ��֧��
                SELECT T.AREA_NO,
                       T.CITY_NO,
                       T.HUAXIAO_TYPE,
                       T.HUAXIAO_NO,
                       T.HUAXIAO_NAME,
                       A.CHANNEL_NO XIAOQU_NO,
                       A.CHANNEL_NO_DESC XIAOQU_NAME,
                       '����' XIAOQU_CHANNEL,
                       A.CDMA_NUM + A.ADSL_NUM + A.IPTV_NUM NEW_NUM,
                       A.CDMA_NUM,
                       A.ADSL_NUM,
                       A.IPTV_NUM
                  FROM (SELECT SUM(CASE
                                     WHEN A.TELE_TYPE = '2' AND A.IS_NEW = '1' THEN
                                      1
                                     ELSE
                                      0
                                   END) CDMA_NUM,
                               SUM(CASE
                                     WHEN A.TELE_TYPE IN ('4', '26') AND A.IS_NEW = '1' THEN
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
                               A.HUAXIAO_NO_04,
                               A.CHANNEL_NO,
                               A.CHANNEL_NO_DESC
                          FROM DW.DW_V_USER_HUAXIAO_INFO_D A
                         WHERE A.ACCT_MONTH = V_MONTH
                           AND A.DAY_ID = V_DAY
                           AND AREA_NO = C1.AREA_NO
                           AND A.TELE_TYPE = '2'
                           AND A.IS_KD_BUNDLE = '0'
                           AND A.IS_HUAXIAO_04 = '1'
                         GROUP BY A.HUAXIAO_NO_04,
                                  A.CHANNEL_NO,
                                  A.CHANNEL_NO_DESC) A,
                       (SELECT *
                          FROM DIM.DIM_CHANNEL_HUAXIAO T
                         WHERE T.AREA_NO = C1.AREA_NO
                           AND T.HUAXIAO_TYPE = '04') T
                 WHERE A.HUAXIAO_NO_04 = T.HUAXIAO_NO
                UNION ALL
                SELECT T.AREA_NO,
                       T.CITY_NO,
                       T.HUAXIAO_TYPE,
                       T.HUAXIAO_NO,
                       T.HUAXIAO_NAME,
                       A.XIAOQU_NO,
                       A.XIAOQU_NAME,
                       'С��' XIAOQU_CHANNEL,
                       A.CDMA_NUM + A.ADSL_NUM + A.IPTV_NUM NEW_NUM,
                       A.CDMA_NUM,
                       A.ADSL_NUM,
                       A.IPTV_NUM
                  FROM (SELECT SUM(CASE
                                     WHEN A.TELE_TYPE = '2' AND A.IS_NEW = '1' THEN
                                      1
                                     ELSE
                                      0
                                   END) CDMA_NUM,
                               SUM(CASE
                                     WHEN A.TELE_TYPE IN ('4', '26') AND A.IS_NEW = '1' THEN
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
                               A.HUAXIAO_NO_04,
                               A.XIAOQU_NO,
                               A.XIAOQU_NAME
                          FROM DW.DW_V_USER_HUAXIAO_INFO_D A
                         WHERE A.ACCT_MONTH = V_MONTH
                           AND A.DAY_ID = V_DAY
                           AND AREA_NO = C1.AREA_NO
                           AND ((A.IS_KD_BUNDLE <> '0' AND A.TELE_TYPE = '2') OR
                               A.TELE_TYPE <> '2')
                           AND A.IS_HUAXIAO_04 = '1'
                         GROUP BY A.HUAXIAO_NO_04, A.XIAOQU_NO, A.XIAOQU_NAME) A,
                       (SELECT *
                          FROM DIM.DIM_CHANNEL_HUAXIAO T
                         WHERE T.AREA_NO = C1.AREA_NO
                           AND T.HUAXIAO_TYPE = '04') T
                 WHERE A.HUAXIAO_NO_04 = T.HUAXIAO_NO) T
         GROUP BY T.AREA_NO,
                  T.CITY_NO,
                  T.HUAXIAO_TYPE,
                  T.HUAXIAO_NO,
                  T.HUAXIAO_NAME,
                  T.XIAOQU_NO,
                  T.XIAOQU_NAME,
                  T.XIAOQU_CHANNEL;
      COMMIT;
    END LOOP;
    --������־
    V_RETCODE := 'SUCCESS';
    P_ALLDM_UPDATE_LOG(V_DATE,
                       V_PKG,
                       V_PROCNAME,
                       '����',
                       'SUCCESS',
                       SYSDATE);

  ELSE
    V_RETCODE := 'WAIT';
    P_ALLDM_UPDATE_LOG(V_DATE, V_PKG, V_PROCNAME, '�ȴ�', 'WAIT', SYSDATE);
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    V_RETCODE := 'FAIL';
    V_RETINFO := SQLERRM;
    P_ALLDM_UPDATE_LOG(V_DATE,
                       V_PKG,
                       V_PROCNAME,
                       V_RETINFO,
                       'FAIL',
                       SYSDATE);

END;
/
