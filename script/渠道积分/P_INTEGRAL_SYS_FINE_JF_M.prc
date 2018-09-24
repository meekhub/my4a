CREATE OR REPLACE PROCEDURE P_INTEGRAL_SYS_FINE_JF_M(V_MONTH   VARCHAR2,
                                                     V_RETCODE OUT VARCHAR2,
                                                     V_RETINFO OUT VARCHAR2) IS
  /*****************************************************************
  *���� --%NAME: P_INTEGRAL_SYS_DEVLP_JF_M
  *�������� --%COMMENT:
  *ִ������ --%PERIOD: ��
  *���� --%PARAM:V_MONTH  ����,��ʽYYYYMM
  *���� --%PARAM:V_RETCODE  �������н����ɹ�����־
  *���� --%PARAM:V_RETCODE  �������н����ɹ��������
  *������ --%CREATOR: LIYA
  *����ʱ�� --%CREATED_TIME:20170710
  *��ע --%REMARK:
  *��Դ�� --%FROM:
  *Ŀ��� --%TO:
  *�޸ļ�¼ --%MODIFY:
  *******************************************************************/
  V_PKG         VARCHAR2(40);
  V_PROCNAME    VARCHAR2(40);
  V_COUNT       NUMBER := 0;
  V_LAST_MONTH6 VARCHAR2(40);
  V_LAST_MONTH  VARCHAR2(40);
  --V_LAST_5     VARCHAR2(40);

  CURSOR V_AREA IS
    SELECT *
      FROM DIM.DIM_AREA_NO --WHERE AREA_NO='720';
     WHERE AREA_NO NOT IN ('018');

BEGIN
  V_PKG      := '����������ϵ';
  V_PROCNAME := 'P_INTEGRAL_SYS_FINE_JF_M';
  --V_LAST_5     := TO_CHAR(TO_DATE(V_MONTH, 'YYYYMMDD') - 10, 'YYYYMMDD');
  V_LAST_MONTH  := TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH, 'YYYYMM'), -1),
                           'YYYYMM');
  V_LAST_MONTH6 := TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH, 'YYYYMM'), -6),
                           'YYYYMM');

  --��־����
  ALLDM.P_ALLDM_INSERT_LOG(V_MONTH, V_PKG, V_PROCNAME, '12', SYSDATE);
  ---------------------------------------------------------------
  -- ���ݲ���

  SELECT COUNT(1)
    INTO V_COUNT
    FROM DW.DW_EXECUTE_LOG
   WHERE ACCT_MONTH = V_MONTH
     AND RESULT = 'SUCCESS'
     AND PROCNAME IN ('P_DW_V_USER_BASE_INFO_USER');
  COMMIT;

  IF V_COUNT = 1 THEN
    EXECUTE IMMEDIATE 'ALTER TABLE ALLDM.INTEGRAL_SYS_INCOME_JF_DETAIL TRUNCATE PARTITION PART_' ||
                      V_MONTH;
    FOR C1 IN V_AREA LOOP
      --------------------------��չ���ֿ۷�
      INSERT INTO INTEGRAL_SYS_INCOME_JF_DETAIL
        SELECT V_MONTH,
               C1.AREA_NO,
               A.CITY_NO,
               A.TELE_TYPE,
               '' AGENT_ID,
               '' AGENT_NAME,
               A.CHANNEL_NO,
               A.USER_NO,
               A.DEVICE_NUMBER,
               A.USER_DINNER,
               CASE
                 WHEN A.TELE_TYPE = '2' AND A.IS_KD_BUNDLE = '0' AND
                      A.USER_DINNER_DESC NOT LIKE '%��װ%' THEN
                  -1 * NVL(C.LOW_VALUE, 0)
                 WHEN A.TELE_TYPE = '2' AND A.IS_KD_BUNDLE = '0' AND
                      A.USER_DINNER_DESC LIKE '%��װ%' THEN
                  -1 * 10
                 WHEN A.TELE_TYPE = '2' AND A.IS_KD_BUNDLE <> '0' AND
                      A.USER_DINNER_DESC NOT LIKE '%��װ%' THEN
                  -1 * NVL(C.LOW_VALUE, 0)
                 WHEN A.TELE_TYPE IN ('4', '26') AND
                      A.IS_KD_BUNDLE IN ('0', '03', '031', '05', '051') THEN
                  -1 * 60
                 WHEN A.TELE_TYPE = '72' AND A.IS_KD_BUNDLE IN ('0', '03', '031') THEN
                  -1 * 10
                 ELSE
                  0
               END, --�۷�����
               B.INNET_MONTH,
               '��չ����ֿ۷�' JF_TYPE
          FROM (SELECT *
                  FROM DW.DW_V_USER_BASE_INFO_USER A
                 WHERE ACCT_MONTH =
                       TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH, 'YYYYMM'), -6),
                               'YYYYMM')
                   AND AREA_NO = C1.AREA_NO
                   AND CHANNEL_TYPE LIKE '11%'
                   AND IS_NEW = '1'
                   AND (TELE_TYPE = '2' OR TELE_TYPE = '72' OR
                       TELE_TYPE IN ('4', '26') AND
                       INNET_METHOD IN ('1', '2', '4', '5', '15'))) A,
               
               (SELECT *
                  FROM DW.DW_V_USER_BASE_INFO_USER B
                 WHERE B.ACCT_MONTH = V_MONTH
                   AND B.AREA_NO = C1.AREA_NO
                   AND (B.LOGOUT_DATE IS NOT NULL OR
                       B.USER_STATUS = '4' AND
                       LAST_DAY(TO_DATE(V_MONTH, 'YYYYMM')) -
                       TO_DATE(TO_CHAR(B.RECENT_STOP_DATE, 'YYYYMMDD'),
                                'YYYYMMDD') >= 60)) B, --��7�����Ѿ�������Ƿͣ����60����û�
               RPT_HBTELE.SJZX_WH_DIM_USER_DINNER C
         WHERE A.USER_NO = B.USER_NO
           AND A.USER_DINNER = C.USER_DINNER(+);
      COMMIT;
    
      -----------------------------�ײ��������ֿ۷�
      INSERT INTO INTEGRAL_SYS_INCOME_JF_DETAIL
        SELECT A.ACCT_MONTH,
               C1.AREA_NO,
               A.CITY_NO,
               A.TELE_TYPE,
               '' AGENT_ID,
               '' AGENT_NAME,
               A.CHANNEL_NO,
               A.USER_NO,
               A.DEVICE_NUMBER,
               B.USER_DINNER,
               CASE
                 WHEN NVL(D.LOW_VALUE, 0) - NVL(C.LOW_VALUE, 0) < 0 THEN
                  -1 * A.LOW_VALUE
                 ELSE
                  0
               END LOW_VALUE,
               B.INNET_MONTH,
               'άϵ����ֿ۷�' JF_TYPE
          FROM (SELECT *
                  FROM INTEGRAL_SYS_WEIXI_JF_DETAIL A
                 WHERE A.ACCT_MONTH =
                       TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH, 'YYYYMM'), -6),
                               'YYYYMM')
                   AND A.AREA_NO = C1.AREA_NO
                   AND A.TELE_TYPE = '1') A, ---�ײ�����������ϸ��
               (SELECT *
                  FROM DW.DW_V_USER_BASE_INFO_USER B
                 WHERE B.ACCT_MONTH = V_MONTH
                   AND B.AREA_NO = C1.AREA_NO
                   AND B.TELE_TYPE = '2') B, --��7�����ײ����
               RPT_HBTELE.SJZX_WH_DIM_USER_DINNER C,
               RPT_HBTELE.SJZX_WH_DIM_USER_DINNER D
         WHERE A.USER_NO = B.USER_NO
           AND A.USER_DINNER = C.USER_DINNER(+)
           AND B.USER_DINNER = D.USER_DINNER(+);
    END LOOP;
  
    DELETE FROM INTEGRAL_SYS_FINE_JF_M WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
    INSERT INTO INTEGRAL_SYS_FINE_JF_M
      SELECT V_MONTH,
             A.AREA_NO,
             A.CITY_NO,
             A.JF_TYPE,
             B.AGENT_ID,
             B.AGENT_NAME,
             A.CHANNEL_NO,
             NVL(A.LOW_VALUE, 0)
        FROM (SELECT *
                FROM INTEGRAL_SYS_INCOME_JF_DETAIL
               WHERE ACCT_MONTH = V_MONTH) A,
             (SELECT DISTINCT AGENT_ID, AGENT_NAME, CHANNEL_NO
                FROM RPT_HBTELE.DM_BUSI_CHANNEL_BUILD
               WHERE ACCT_MONTH = V_MONTH) B
       WHERE A.CHANNEL_NO = B.CHANNEL_NO(+);
    COMMIT;
    --������־
    V_RETCODE := 'SUCCESS';
    ALLDM.P_ALLDM_UPDATE_LOG(V_MONTH,
                             V_PKG,
                             V_PROCNAME,
                             '����',
                             V_RETCODE,
                             SYSDATE);
    DBMS_OUTPUT.PUT_LINE(V_RETCODE);
    ------------------------------------- ���ݲ��ֽ��� -------------------------
  ELSE
    V_RETCODE := 'WAIT';
    ALLDM.P_ALLDM_UPDATE_LOG(V_MONTH,
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
    ALLDM.P_ALLDM_UPDATE_LOG(V_MONTH,
                             V_PKG,
                             V_PROCNAME,
                             V_RETINFO,
                             V_RETCODE,
                             SYSDATE);
END;
/
