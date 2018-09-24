CREATE OR REPLACE PROCEDURE P_INTEGRAL_SYS_WEIXI_JF_D(V_DATE    VARCHAR2,
                                                      V_RETCODE OUT VARCHAR2,
                                                      V_RETINFO OUT VARCHAR2) IS
  /*****************************************************************
  *���� --%NAME: P_INTEGRAL_SYS_DEVLP_JF_D
  *�������� --%COMMENT:
  *ִ������ --%PERIOD: ��
  *���� --%PARAM:V_DATE  ����,��ʽYYYYMMDD
  *���� --%PARAM:V_RETCODE  �������н����ɹ�����־
  *���� --%PARAM:V_RETCODE  �������н����ɹ��������
  *������ --%CREATOR: LIYA
  *����ʱ�� --%CREATED_TIME:20170710
  *��ע --%REMARK:
  *��Դ�� --%FROM:
  *Ŀ��� --%TO:
  *�޸ļ�¼ --%MODIFY:
  *******************************************************************/
  V_PKG        VARCHAR2(40);
  V_PROCNAME   VARCHAR2(40);
  V_COUNT      NUMBER := 0;
  V_MONTH      VARCHAR2(40);
  V_LAST_MONTH VARCHAR2(40);
  V_DAY        VARCHAR2(40);
  V_LAST_DAY   VARCHAR2(40);

  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO NOT IN ('018');

BEGIN
  V_PKG        := '����������ϵ';
  V_PROCNAME   := 'P_INTEGRAL_SYS_WEIXI_JF_D';
  V_MONTH      := SUBSTR(V_DATE, 1, 6);
  V_DAY        := SUBSTR(V_DATE, 7, 2);
  V_LAST_DAY   := TO_CHAR(TO_DATE(V_DATE, 'YYYYMMDD') - 1, 'DD');
  V_LAST_MONTH := TO_CHAR(ADD_MONTHS(TO_DATE(V_DATE, 'YYYYMMDD'), -1),
                          'YYYYMM');

  --��־����
  ALLDM.P_ALLDM_INSERT_LOG(V_DATE, V_PKG, V_PROCNAME, '12', SYSDATE);
  ---------------------------------------------------------------
  -- ���ݲ���

  SELECT COUNT(1)
    INTO V_COUNT
    FROM DW.DW_EXECUTE_LOG
   WHERE ACCT_MONTH = V_DATE
     AND RESULT = 'SUCCESS'
     AND PROCNAME IN ('P_DW_V_USER_BASE_INFO_DAY');
  COMMIT;

  IF V_COUNT = 1 THEN
    EXECUTE IMMEDIATE 'ALTER TABLE ALLDM.INTEGRAL_SYS_WEIXI_JF_DETAIL TRUNCATE PARTITION PART_' ||
                      V_DATE;
  
    FOR C1 IN V_AREA LOOP
      ---�ƶ��ײ���������
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_INTEGRAL_SYS_WEIXI_JF_1';
      INSERT INTO MID_INTEGRAL_SYS_WEIXI_JF_1
        SELECT A.*, B.LOW_VALUE
          FROM (SELECT ACCT_MONTH,
                       DAY_ID,
                       AREA_NO,
                       CITY_NO,
                       TELE_TYPE,
                       CHANNEL_NO,
                       CHANNEL_TYPE,
                       CHANNEL_KIND,
                       USER_NO,
                       DEVICE_NUMBER,
                       IS_VALID,
                       INNET_DATE,
                       USER_DINNER,
                       USER_DINNER_DESC
                  FROM DW.DW_V_USER_BASE_INFO_DAY T
                 WHERE ACCT_MONTH = V_MONTH
                   AND DAY_ID = V_DAY
                   AND AREA_NO = C1.AREA_NO
                   AND CHANNEL_TYPE LIKE '11%'
                   AND IS_VALID = '1'
                   AND TELE_TYPE = '2'
                   AND TO_CHAR(SERVICE_START_DATE, 'YYYYMMDD') = V_DATE) A,
               (SELECT *
                  FROM RPT_HBTELE.SJZX_WH_DIM_USER_DINNER T
                 WHERE T.LOW_VALUE >= 59) B
         WHERE A.USER_DINNER = B.USER_DINNER;
      COMMIT;
    
      INSERT INTO INTEGRAL_SYS_WEIXI_JF_DETAIL
        SELECT ACCT_MONTH || DAY_ID DAY_ID,
               AREA_NO,
               CITY_NO,
               '1' TELE_TYPE,
               '' AGENT_ID,
               '' AGENT_NAME,
               A.CHANNEL_NO,
               A.USER_NO,
               DEVICE_NUMBER,
               A.USER_DINNER,
               A.LOW_VALUE - C.LOW_VALUE
          FROM MID_INTEGRAL_SYS_WEIXI_JF_1 A,
               (SELECT USER_NO, USER_DINNER
                  FROM DW.DW_V_USER_BASE_INFO_DAY T
                 WHERE ACCT_MONTH = V_MONTH
                   AND DAY_ID = V_LAST_DAY
                   AND AREA_NO = C1.AREA_NO
                   AND TELE_TYPE = '2') B,
               RPT_HBTELE.SJZX_WH_DIM_USER_DINNER  C
         WHERE A.USER_NO = B.USER_NO
           AND B.USER_DINNER = C.USER_DINNER
           and A.LOW_VALUE - C.LOW_VALUE>0;
      COMMIT;
    
      -------������Լ����
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_INTEGRAL_SYS_WEIXI_KD';
      INSERT INTO MID_INTEGRAL_SYS_WEIXI_KD
        SELECT ACCT_MONTH,
               DAY_ID,
               AREA_NO,
               CITY_NO,
               TELE_TYPE,
               CHANNEL_NO,
               CHANNEL_TYPE,
               CHANNEL_KIND,
               USER_NO,
               DEVICE_NUMBER
          FROM DW.DW_V_USER_BASE_INFO_DAY T
         WHERE ACCT_MONTH = V_MONTH
           AND DAY_ID = V_DAY
           AND AREA_NO = C1.AREA_NO
           AND CHANNEL_TYPE LIKE '11%'
           AND IS_VALID = '1'
           AND TELE_TYPE IN ('4', '26')
           AND IS_KD_BUNDLE = '0'
           AND BILLING_FLAG = '3';
      COMMIT;
      INSERT INTO INTEGRAL_SYS_WEIXI_JF_DETAIL
        SELECT ACCT_MONTH || DAY_ID DAY_ID,
               AREA_NO,
               CITY_NO,
               '2' TELE_TYPE,
               '' AGENT_ID,
               '' AGENT_NAME,
               A.CHANNEL_NO,
               A.USER_NO,
               DEVICE_NUMBER,
               '' USER_DINNER,
               PAY_CHARGE * 0.12
          FROM MID_INTEGRAL_SYS_WEIXI_KD A,
               (SELECT USER_NO, SUM(PAY_CHARGE) PAY_CHARGE
                  FROM DW.DW_V_USER_PAY_LOG_DAY
                 WHERE ACCT_MONTH = V_MONTH
                   AND DAY_ID = V_DAY
                   AND AREA_NO = C1.AREA_NO
                   AND TELE_TYPE IN ('4', '26')
                   AND TO_CHAR(OPER_DATE, 'YYYYMMDD') = V_DATE
                   AND PAY_CHARGE > 0
                 GROUP BY USER_NO) B
         WHERE A.USER_NO = B.USER_NO;
      COMMIT;
    
      ------�ƶ��û���Լ����
    
      INSERT INTO INTEGRAL_SYS_WEIXI_JF_DETAIL
        SELECT V_DATE DAY_ID,
               AREA_NO,
               CITY_NO,
               '3' TELE_TYPE,
               MOBILE_AGENT,
               '' AGENT_NAME,
               A.CHANNEL_NO,
               A.USER_NO,
               '' DEVICE_NUMBER,
               A.USER_DINNER,
               LOW_VALUE * 0.1
          FROM (SELECT AREA_NO,
                       CITY_NO,
                       USER_NO,
                       USER_DINNER,
                       CHANNEL_NO,
                       MOBILE_AGENT
                  FROM ODS.O_PRD_USER_DEVICE_RENT_D@HBODS
                 WHERE ACCT_MONTH = V_MONTH
                   AND DAY_ID = V_DAY
                   AND AREA_NO = C1.AREA_NO
                   AND TO_CHAR(BEGIN_DATE, 'YYYYMMDD') = V_DATE) A,
               RPT_HBTELE.SJZX_WH_DIM_USER_DINNER B
         WHERE A.USER_DINNER = B.USER_DINNER;
      COMMIT;
    END LOOP;
  
    DELETE FROM INTEGRAL_SYS_WEIXI_JF_D WHERE DAY_ID = V_DATE;
    COMMIT;
  
    IF SUBSTR(V_DATE, 7, 2) <> '01' THEN
      INSERT INTO INTEGRAL_SYS_WEIXI_JF_D
        SELECT V_DATE,
               B.AREA_NO,
               B.CITY_NO,
               CASE
                 WHEN TELE_TYPE = '1' THEN
                  '�ƶ��ײ���������'
                 WHEN TELE_TYPE = '2' THEN
                  '������Լ����'
                 WHEN TELE_TYPE = '3' THEN
                  '�ƶ��û���Լ����'
                 ELSE
                  TELE_TYPE
               END TELE_TYPE,
               C.AGENT_ID,
               C.AGENT_NAME,
               B.CHANNEL_NO,
               SUM(NVL(LOW_VALUE, 0)),
               SUM(NVL(VALUE_MON, 0))
          FROM (SELECT AREA_NO,
                       CITY_NO,
                       AGENT_ID,
                       AGENT_NAME,
                       TELE_TYPE,
                       CHANNEL_NO,
                       SUM(NVL(LOW_VALUE, 0)) LOW_VALUE,
                       SUM(NVL(LOW_VALUE, 0)) VALUE_MON
                  FROM INTEGRAL_SYS_WEIXI_JF_DETAIL A
                 WHERE acct_month = V_DATE
                 GROUP BY AREA_NO,
                          CITY_NO,
                          AGENT_ID,
                          AGENT_NAME,
                          CHANNEL_NO,
                          TELE_TYPE
                UNION ALL
                SELECT AREA_NO,
                       CITY_NO,
                       AGENT_ID,
                       AGENT_NAME,
                       CASE
                         WHEN TELE_TYPE = '�ƶ��ײ���������' THEN
                          '1'
                         WHEN TELE_TYPE = '������Լ����' THEN
                          '2'
                         WHEN TELE_TYPE = '�ƶ��û���Լ����' THEN
                          '3'
                         ELSE
                          TELE_TYPE
                       END TELE_TYPE,
                       CHANNEL_NO,
                       0,
                       VALUE_MON
                  FROM INTEGRAL_SYS_DEVLP_JF_D
                 WHERE DAY_ID =
                       TO_CHAR(TO_DATE(V_DATE, 'YYYYMMDD') - 1, 'YYYYMMDD')) A,
               (SELECT *
                  FROM DIM.DIM_CHANNEL_NO
                 WHERE CHANNEL_TYPE LIKE '11%') B,
               (SELECT DISTINCT AGENT_ID, AGENT_NAME, CHANNEL_NO
                  FROM RPT_HBTELE.DM_BUSI_CHANNEL_BUILD
                 WHERE ACCT_MONTH = V_LAST_MONTH) C
         WHERE B.CHANNEL_NO = A.CHANNEL_NO(+)
           AND B.CHANNEL_NO = C.CHANNEL_NO(+)
           AND B.VALID_STATUS = '1'
         GROUP BY B.AREA_NO,
                  B.CITY_NO,
                  C.AGENT_ID,
                  C.AGENT_NAME,
                  B.CHANNEL_NO,
                  A.TELE_TYPE;
      COMMIT;
    
    ELSE
      INSERT INTO INTEGRAL_SYS_WEIXI_JF_D
        SELECT V_DATE,
               B.AREA_NO,
               B.CITY_NO,
               CASE
                 WHEN TELE_TYPE = '1' THEN
                  '�ƶ��ײ���������'
                 WHEN TELE_TYPE = '2' THEN
                  '������Լ����'
                 WHEN TELE_TYPE = '3' THEN
                  '�ƶ��û���Լ����'
                 ELSE
                  TELE_TYPE
               END TELE_TYPE,
               C.AGENT_ID,
               C.AGENT_NAME,
               B.CHANNEL_NO,
               SUM(LOW_VALUE) LOW_VALUE,
               SUM(LOW_VALUE) VALUE_MON
          FROM (SELECT *
                  FROM INTEGRAL_SYS_WEIXI_JF_DETAIL
                 WHERE acct_month = V_DATE) A,
               (SELECT *
                  FROM DIM.DIM_CHANNEL_NO
                 WHERE CHANNEL_TYPE LIKE '11%') B,
               (SELECT DISTINCT AGENT_ID, AGENT_NAME, CHANNEL_NO
                  FROM RPT_HBTELE.DM_BUSI_CHANNEL_BUILD
                 WHERE ACCT_MONTH = V_LAST_MONTH) C
         WHERE B.CHANNEL_NO = A.CHANNEL_NO(+)
           AND B.CHANNEL_NO = C.CHANNEL_NO
           AND B.VALID_STATUS = '1'
         GROUP BY B.AREA_NO,
                  B.CITY_NO,
                  C.AGENT_ID,
                  C.AGENT_NAME,
                  B.CHANNEL_NO,
                  A.TELE_TYPE;
      COMMIT;
    END IF;
  
    --������־
    V_RETCODE := 'SUCCESS';
    ALLDM.P_ALLDM_UPDATE_LOG(V_DATE,
                             V_PKG,
                             V_PROCNAME,
                             '����',
                             V_RETCODE,
                             SYSDATE);
    DBMS_OUTPUT.PUT_LINE(V_RETCODE);
    ------------------------------------- ���ݲ��ֽ��� -------------------------
  ELSE
    V_RETCODE := 'WAIT';
    ALLDM.P_ALLDM_UPDATE_LOG(V_DATE,
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
    ALLDM.P_ALLDM_UPDATE_LOG(V_DATE,
                             V_PKG,
                             V_PROCNAME,
                             V_RETINFO,
                             V_RETCODE,
                             SYSDATE);
END;
/
