CREATE OR REPLACE PROCEDURE P_INTEGRAL_SYS_DEVLP_JF_D(V_DATE    VARCHAR2,
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
  --V_LAST_5     VARCHAR2(40);

  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO NOT IN ('018');

BEGIN
  V_PKG      := '����������ϵ';
  V_PROCNAME := 'P_INTEGRAL_SYS_DEVLP_JF_D';
  V_MONTH    := SUBSTR(V_DATE, 1, 6);
  V_DAY      := SUBSTR(V_DATE, 7, 2);
  --V_LAST_5     := TO_CHAR(TO_DATE(V_DATE, 'YYYYMMDD') - 10, 'YYYYMMDD');
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
    /*EXECUTE IMMEDIATE 'ALTER TABLE ALLDM.INTEGRAL_SYS_DEVLP_JF_DETAIL TRUNCATE PARTITION PART_' ||
    V_DATE;*/
  
    FOR C1 IN V_AREA LOOP
      ---�ƶ�����Ʒ����+�ں�ҵ�����
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_INTEGRAL_SYS_DEVLP_JF';
      INSERT INTO MID_INTEGRAL_SYS_DEVLP_JF
        SELECT ACCT_MONTH,
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
               USER_DINNER_DESC,
               MONTH_FEE,
               BILLING_FLAG,
               IS_KD_BUNDLE
          FROM DW.DW_V_USER_BASE_INFO_DAY T
         WHERE ACCT_MONTH = V_MONTH
           AND DAY_ID = V_DAY
           AND AREA_NO = C1.AREA_NO
           AND CHANNEL_TYPE LIKE '11%'
           AND IS_NEW = '1' --�޸�
              /*AND IS_VALID = '1'
              AND TO_CHAR(INNET_DATE, 'YYYYMMDD') = V_DATE*/
           AND (TELE_TYPE = '2' OR
               (TELE_TYPE IN ('4', '26') AND
               INNET_METHOD IN ('1', '2', '4', '5', '15')) OR
               TELE_TYPE = '72')
        /*AND ((TELE_TYPE = '2' AND
        IS_KD_BUNDLE IN
        ('0', '01', '011', '02', '021', '04', '041', '06')) OR
        (TELE_TYPE IN ('4', '26') AND
        IS_KD_BUNDLE IN ('0', '01', '011', '02', '021')) OR
        (TELE_TYPE = '72' AND
        IS_KD_BUNDLE IN ('0', '01', '011', '04', '041')))*/
        ;
      COMMIT;
    
      /*INSERT INTO INTEGRAL_SYS_DEVLP_JF_DETAIL
        SELECT ACCT_MONTH || DAY_ID DAY_ID,
               AREA_NO,
               CITY_NO,
               TELE_TYPE,
               '' AGENT_ID,
               '' AGENT_NAME,
               T.CHANNEL_NO,
               USER_NO,
               DEVICE_NUMBER,
               T.USER_DINNER,
               CASE
                 WHEN A.LOW_VALUE > 1000 THEN
                  1000
                 ELSE
                  A.LOW_VALUE
               END,
               CASE
                 WHEN IS_KD_BUNDLE = '0' THEN
                  '1'
                 ELSE
                  '2'
               END
          FROM MID_INTEGRAL_SYS_DEVLP_JF          T,
               RPT_HBTELE.SJZX_WH_DIM_USER_DINNER A
         WHERE T.USER_DINNER = A.USER_DINNER(+)
           AND TELE_TYPE = '2';
      COMMIT;*/
    
      ------��C����
      INSERT INTO INTEGRAL_SYS_DEVLP_JF_DETAIL
        SELECT ACCT_MONTH || DAY_ID DAY_ID,
               AREA_NO,
               CITY_NO,
               TELE_TYPE,
               '' AGENT_ID,
               '' AGENT_NAME,
               T.CHANNEL_NO,
               USER_NO,
               DEVICE_NUMBER,
               T.USER_DINNER,
               CASE
                 WHEN T.USER_DINNER_DESC LIKE '%��װ%' THEN ---������10��
                  10
                 WHEN A.LOW_VALUE > 1000 THEN
                  1000
                 WHEN C.USER_DINNER IS NOT NULL THEN
                  C.LOW_VALUE * 30
                 ELSE
                  A.LOW_VALUE
               END,
               '1'
          FROM MID_INTEGRAL_SYS_DEVLP_JF          T,
               RPT_HBTELE.SJZX_WH_DIM_USER_DINNER A,
               DIM.DIM_DAY_DINNER                 C
         WHERE T.USER_DINNER = A.USER_DINNER(+)
           AND T.USER_DINNER = C.USER_DINNER(+)
           AND TELE_TYPE = '2'
           AND T.IS_KD_BUNDLE = '0';
      COMMIT;
    
      ---�ںϣ����ֻ��ģ�--�ֻ�
      INSERT INTO INTEGRAL_SYS_DEVLP_JF_DETAIL
        SELECT ACCT_MONTH || DAY_ID DAY_ID,
               AREA_NO,
               CITY_NO,
               TELE_TYPE,
               '' AGENT_ID,
               '' AGENT_NAME,
               T.CHANNEL_NO,
               USER_NO,
               DEVICE_NUMBER,
               T.USER_DINNER,
               CASE
                 WHEN T.USER_DINNER_DESC LIKE '%��װ%' THEN ---������10��
                  10
                 WHEN A.LOW_VALUE > 1000 THEN
                  1000
                 ELSE
                  A.LOW_VALUE
               END,
               '2'
          FROM MID_INTEGRAL_SYS_DEVLP_JF          T,
               RPT_HBTELE.SJZX_WH_DIM_USER_DINNER A
         WHERE T.USER_DINNER = A.USER_DINNER(+)
           AND TELE_TYPE = '2'
           AND T.IS_KD_BUNDLE <> '0';
      COMMIT;
      --��� ITV
      INSERT INTO INTEGRAL_SYS_DEVLP_JF_DETAIL
        SELECT ACCT_MONTH || DAY_ID DAY_ID,
               AREA_NO,
               CITY_NO,
               TELE_TYPE,
               '' AGENT_ID,
               '' AGENT_NAME,
               T.CHANNEL_NO,
               USER_NO,
               DEVICE_NUMBER,
               T.USER_DINNER,
               CASE
                 WHEN TELE_TYPE = '72' THEN
                  10
                 ELSE
                  20
               END,
               '2'
          FROM MID_INTEGRAL_SYS_DEVLP_JF          T,
               RPT_HBTELE.SJZX_WH_DIM_USER_DINNER A
         WHERE T.USER_DINNER = A.USER_DINNER(+)
           AND TELE_TYPE <> '2'
           AND T.IS_KD_BUNDLE IN ('01', '011', '02', '021', '04', '041');
      COMMIT;
      --���� 
      INSERT INTO INTEGRAL_SYS_DEVLP_JF_DETAIL
        SELECT ACCT_MONTH || DAY_ID DAY_ID,
               AREA_NO,
               CITY_NO,
               TELE_TYPE,
               AGENT_ID,
               AGENT_NAME,
               T.CHANNEL_NO,
               USER_NO,
               DEVICE_NUMBER,
               T.USER_DINNER,
               CASE
                 WHEN TELE_TYPE = '72' THEN
                  10
                 ELSE
                  60
               END,
               '3'
          FROM MID_INTEGRAL_SYS_DEVLP_JF T,
               (SELECT DISTINCT AGENT_ID, AGENT_NAME, CHANNEL_NO
                  FROM RPT_HBTELE.DM_BUSI_CHANNEL_BUILD
                 WHERE ACCT_MONTH = V_LAST_MONTH
                   AND AREA_NO = C1.AREA_NO) B
         WHERE T.CHANNEL_NO = B.CHANNEL_NO(+)
           AND TELE_TYPE IN ('4', '26', '72')
           AND T.IS_KD_BUNDLE IN ('0', '03', '031', '05', '051');
      COMMIT;

      ---��������
      INSERT INTO INTEGRAL_SYS_DEVLP_JF_DETAIL
        SELECT V_DATE,
               AREA_NO,
               CITY_NO,
               TELE_TYPE,
               '' AGENT_ID,
               '' AGENT_NAME,
               T.CHANNEL_NO,
               USER_NO,
               DEVICE_NUMBER,
               T.USER_DINNER,
               CASE
                 WHEN A.USER_DINNER_DESC LIKE '%������%' AND A.LOW_VALUE = 299 THEN
                  60
                 WHEN A.USER_DINNER_DESC LIKE '%������%' AND A.LOW_VALUE = 199 THEN
                  50
                 WHEN A.USER_DINNER_DESC LIKE '%������%' AND A.LOW_VALUE = 129 THEN
                  30
                 WHEN A.USER_DINNER_DESC LIKE '%������%' AND A.LOW_VALUE = 109 THEN
                  30
                 WHEN A.USER_DINNER_DESC LIKE '%ũ�������%' AND A.LOW_VALUE = 69 THEN
                  20
                 WHEN A.USER_DINNER_DESC LIKE '%�򵥿�%' AND A.LOW_VALUE = 50 THEN
                  20
                 WHEN A.USER_DINNER_DESC LIKE '%�򵥿�%' AND A.LOW_VALUE = 30 THEN
                  10
                 WHEN A.USER_DINNER_DESC LIKE '%���翨%' AND A.LOW_VALUE = 6 THEN
                  4
                 WHEN A.USER_DINNER_DESC LIKE '%������%' AND A.LOW_VALUE = 0 THEN
                  10
                 ELSE
                  0
               END,
               '4'
          FROM MID_INTEGRAL_SYS_DEVLP_JF        T,
               RPT_HBTELE.SJZX_WH_DIM_USER_DINNER A
         WHERE T.USER_DINNER = A.USER_DINNER
           AND TELE_TYPE = '2';
      COMMIT;
          
    END LOOP;
    DELETE FROM INTEGRAL_SYS_DEVLP_JF_D WHERE DAY_ID = V_DATE;
    COMMIT;
    delete from INTEGRAL_SYS_DEVLP_JF_DETAIL where DAY_ID = V_DATE and (LOW_VALUE = 0 or LOW_VALUE is null);
    commit;
  
    IF SUBSTR(V_DATE, 7, 2) <> '01' THEN
      INSERT INTO INTEGRAL_SYS_DEVLP_JF_D
        SELECT V_DATE,
               B.AREA_NO,
               B.CITY_NO,
               CASE
                 WHEN JF_TYPE = '1' THEN
                  '�ƶ�����Ʒ����'
                 WHEN JF_TYPE = '2' THEN
                  '�ں�ҵ�����'
                 WHEN JF_TYPE = '3' THEN
                  '����ҵ�����'
                 when jf_type='4' then 
                   '��չ��������'
               END JF_TYPE,
               --'' JF_TYPE,
               C.AGENT_ID,
               C.AGENT_NAME,
               B.CHANNEL_NO,
               CEIL(SUM(NVL(LOW_VALUE, 0))),
               CEIL(SUM(NVL(VALUE_MON, 0))),
               NVL(C.CHANNEL_PROP_NO, '01'),
               NVL(C.CHANNEL_PROP_NAME, '��Ȧ'),
               NVL(C.REGION_PROP_NO, '07'),
               NVL(C.REGION_PROP_NAME, '����')
          FROM (SELECT AREA_NO,
                       CITY_NO,
                       AGENT_ID,
                       AGENT_NAME,
                       CHANNEL_NO,
                       JF_TYPE,
                       SUM(NVL(LOW_VALUE, 0)) LOW_VALUE,
                       SUM(NVL(LOW_VALUE, 0)) VALUE_MON
                  FROM INTEGRAL_SYS_DEVLP_JF_DETAIL A
                 WHERE DAY_ID = V_DATE
                 GROUP BY AREA_NO,
                          CITY_NO,
                          JF_TYPE,
                          AGENT_ID,
                          AGENT_NAME,
                          CHANNEL_NO
                UNION ALL
                SELECT AREA_NO,
                       CITY_NO,
                       AGENT_ID,
                       AGENT_NAME,
                       CHANNEL_NO,
                       CASE
                         WHEN TELE_TYPE = '�ƶ�����Ʒ����' THEN
                          '1'
                         WHEN TELE_TYPE = '�ں�ҵ�����' THEN
                          '2'
                         WHEN TELE_TYPE = '����ҵ�����' THEN
                          '3'
                         WHEN TELE_TYPE = '��չ��������' THEN
                          '4'
                       END TELE_TYPE,
                       0,
                       VALUE_MON
                  FROM INTEGRAL_SYS_DEVLP_JF_D
                 WHERE DAY_ID =
                       TO_CHAR(TO_DATE(V_DATE, 'YYYYMMDD') - 1, 'YYYYMMDD')) A,
               (SELECT *
                  FROM DIM.DIM_CHANNEL_NO
                 WHERE CHANNEL_TYPE LIKE '11%'
                   AND VALID_STATUS = '1'
                   AND AREA_NO <> '018') B,
               (SELECT *
                  FROM DM_BUSI_CHANNEL_BUILD_ST T
                 WHERE ACCT_MONTH = V_LAST_MONTH) C
         WHERE B.CHANNEL_NO = A.CHANNEL_NO(+)
           AND B.CHANNEL_NO = C.CHANNEL_NO(+)
           AND B.VALID_STATUS = '1'
         GROUP BY B.AREA_NO,
                  B.CITY_NO,
                  C.AGENT_ID,
                  CASE
                 WHEN JF_TYPE = '1' THEN
                  '�ƶ�����Ʒ����'
                 WHEN JF_TYPE = '2' THEN
                  '�ں�ҵ�����'
                 WHEN JF_TYPE = '3' THEN
                  '����ҵ�����'
                 when jf_type='4' then 
                   '��չ��������'
               END,
                  C.AGENT_NAME,
                  B.CHANNEL_NO,
                  NVL(C.CHANNEL_PROP_NO, '01'),
                  NVL(C.CHANNEL_PROP_NAME, '��Ȧ'),
                  NVL(C.REGION_PROP_NO, '07'),
                  NVL(C.REGION_PROP_NAME, '����');
      COMMIT;
    
    ELSE
      INSERT INTO INTEGRAL_SYS_DEVLP_JF_D
        SELECT V_DATE,
               B.AREA_NO,
               B.CITY_NO,
               CASE
                 WHEN JF_TYPE = '1' THEN
                  '�ƶ�����Ʒ����'
                 WHEN JF_TYPE = '2' THEN
                  '�ں�ҵ�����'
                 WHEN JF_TYPE = '3' THEN
                  '����ҵ�����'
                 when jf_type='4' then 
                   '��չ��������'
               END JF_TYPE,
               --'' JF_TYPE,
               C.AGENT_ID,
               C.AGENT_NAME,
               B.CHANNEL_NO,
               CEIL(SUM(LOW_VALUE)) LOW_VALUE,
               CEIL(SUM(LOW_VALUE)) VALUE_MON,
               NVL(C.CHANNEL_PROP_NO, '01'),
               NVL(C.CHANNEL_PROP_NAME, '��Ȧ'),
               NVL(C.REGION_PROP_NO, '07'),
               NVL(C.REGION_PROP_NAME, '����')
          FROM (SELECT *
                  FROM INTEGRAL_SYS_DEVLP_JF_DETAIL
                 WHERE DAY_ID = V_DATE) A,
               (SELECT *
                  FROM DIM.DIM_CHANNEL_NO
                 WHERE CHANNEL_TYPE LIKE '11%'
                   AND VALID_STATUS = '1'
                   AND AREA_NO <> '018') B,
               (SELECT *
                  FROM DM_BUSI_CHANNEL_BUILD_ST T
                 WHERE ACCT_MONTH = V_LAST_MONTH) C
         WHERE B.CHANNEL_NO = A.CHANNEL_NO(+)
           AND B.CHANNEL_NO = C.CHANNEL_NO
           AND B.VALID_STATUS = '1'
         GROUP BY B.AREA_NO,
                  B.CITY_NO,
                  C.AGENT_ID,
                  C.AGENT_NAME,
                  B.CHANNEL_NO,
                                 CASE
                 WHEN JF_TYPE = '1' THEN
                  '�ƶ�����Ʒ����'
                 WHEN JF_TYPE = '2' THEN
                  '�ں�ҵ�����'
                 WHEN JF_TYPE = '3' THEN
                  '����ҵ�����'
                 when jf_type='4' then 
                   '��չ��������'
               END,
                  NVL(C.CHANNEL_PROP_NO, '01'),
                  NVL(C.CHANNEL_PROP_NAME, '��Ȧ'),
                  NVL(C.REGION_PROP_NO, '07'),
                  NVL(C.REGION_PROP_NAME, '����');
      COMMIT;
    END IF;
  
    -----�а��������ݲ���(ADMIN)
    DELETE FROM MOBILE_CBZS.C_DM_KKPI_D_JIFEN_ADMIN_BK
     WHERE DAY_ID = V_DAY;
    COMMIT;
    INSERT INTO MOBILE_CBZS.C_DM_KKPI_D_JIFEN_ADMIN_BK
      SELECT DAY_ID,
             AREA_NO,
             CITY_NO,
             '2',
             '02',
             CASE
               WHEN TELE_TYPE = '�ƶ�����Ʒ����' THEN
                '01'
               WHEN TELE_TYPE = '�ں�ҵ�����' THEN
                '02'
               WHEN TELE_TYPE = '����ҵ�����' THEN
                '03'
               WHEN TELE_TYPE = '��չ��������' THEN
                '04'                
             END,
             SUM(LOW_VALUE),
             SUM(VALUE_MON)
        FROM ALLDM.INTEGRAL_SYS_DEVLP_JF_D
       WHERE DAY_ID = V_DAY
         AND TELE_TYPE IS NOT NULL
       GROUP BY DAY_ID,
                AREA_NO,
                CITY_NO,
             CASE
               WHEN TELE_TYPE = '�ƶ�����Ʒ����' THEN
                '01'
               WHEN TELE_TYPE = '�ں�ҵ�����' THEN
                '02'
               WHEN TELE_TYPE = '����ҵ�����' THEN
                '03'
               WHEN TELE_TYPE = '��չ��������' THEN
                '04'                
             END
      UNION ALL
      SELECT DAY_ID,
             AREA_NO,
             CITY_NO,
             '2',
             '02',
             '00',
             SUM(LOW_VALUE),
             SUM(VALUE_MON)
        FROM ALLDM.INTEGRAL_SYS_DEVLP_JF_D
       WHERE DAY_ID = V_DAY
       GROUP BY DAY_ID, AREA_NO, CITY_NO;
    COMMIT;
    -----�а��������ݲ���(CEO)
  
    DELETE FROM MOBILE_CBZS.C_DM_KKPI_D_JIFEN_BK WHERE DAY_ID = V_DAY;
    COMMIT;
    INSERT INTO MOBILE_CBZS.C_DM_KKPI_D_JIFEN_BK
      SELECT A.DAY_ID,
             A.AREA_NO,
             A.CITY_NO,
             B.CBDY_NO,
             '2',
             '02',
             CASE
               WHEN TELE_TYPE = '�ƶ�����Ʒ����' THEN
                '01'
               WHEN TELE_TYPE = '�ں�ҵ�����' THEN
                '02'
               WHEN TELE_TYPE = '����ҵ�����' THEN
                '03'
               WHEN TELE_TYPE = '��չ��������' THEN
                '04'                
             END,
             SUM(LOW_VALUE),
             SUM(VALUE_MON)
        FROM ALLDM.INTEGRAL_SYS_DEVLP_JF_D A, DIM.DIM_CBDY_AND_CHANNEL B
       WHERE DAY_ID = V_DAY
         AND A.CHANNEL_NO = B.CHANNEL_ID
         AND TELE_TYPE IS NOT NULL
       GROUP BY A.DAY_ID,
                A.AREA_NO,
                A.CITY_NO,
                B.CBDY_NO,
             CASE
               WHEN TELE_TYPE = '�ƶ�����Ʒ����' THEN
                '01'
               WHEN TELE_TYPE = '�ں�ҵ�����' THEN
                '02'
               WHEN TELE_TYPE = '����ҵ�����' THEN
                '03'
               WHEN TELE_TYPE = '��չ��������' THEN
                '04'                
             END
      UNION ALL
      SELECT A.DAY_ID,
             A.AREA_NO,
             A.CITY_NO,
             B.CBDY_NO,
             '2',
             '02',
             '00',
             SUM(LOW_VALUE),
             SUM(VALUE_MON)
        FROM ALLDM.INTEGRAL_SYS_DEVLP_JF_D A, DIM.DIM_CBDY_AND_CHANNEL B
       WHERE DAY_ID = V_DAY
         AND A.CHANNEL_NO = B.CHANNEL_ID
       GROUP BY A.DAY_ID, A.AREA_NO, A.CITY_NO, B.CBDY_NO;
    COMMIT;
  
    DELETE FROM MOBILE_CBZS.C_DM_KKPI_D_JIFEN_CHANNEL WHERE DAY_ID = V_DAY;
    COMMIT;
    INSERT INTO MOBILE_CBZS.C_DM_KKPI_D_JIFEN_CHANNEL
      SELECT A.DAY_ID,
             A.AREA_NO,
             A.CITY_NO,
             B.CBDY_NO,
             '2',
             A.CHANNEL_NO,
             B.CHANNEL_NAME,
             '',
             '02',
             CASE
               WHEN TELE_TYPE = '�ƶ�����Ʒ����' THEN
                '01'
               WHEN TELE_TYPE = '�ں�ҵ�����' THEN
                '02'
               WHEN TELE_TYPE = '����ҵ�����' THEN
                '03'
               WHEN TELE_TYPE = '��չ��������' THEN
                '04'                
             END,
             SUM(LOW_VALUE),
             SUM(VALUE_MON)
        FROM ALLDM.INTEGRAL_SYS_DEVLP_JF_D A, DIM.DIM_CBDY_AND_CHANNEL B
       WHERE DAY_ID = V_DAY
         AND A.CHANNEL_NO = B.CHANNEL_ID
         AND TELE_TYPE IS NOT NULL
       GROUP BY A.DAY_ID,
                A.AREA_NO,
                A.CITY_NO,
                B.CBDY_NO,
                A.CHANNEL_NO,
                B.CHANNEL_NAME,
             CASE
               WHEN TELE_TYPE = '�ƶ�����Ʒ����' THEN
                '01'
               WHEN TELE_TYPE = '�ں�ҵ�����' THEN
                '02'
               WHEN TELE_TYPE = '����ҵ�����' THEN
                '03'
               WHEN TELE_TYPE = '��չ��������' THEN
                '04'                
             END
      UNION ALL
      SELECT A.DAY_ID,
             A.AREA_NO,
             A.CITY_NO,
             B.CBDY_NO,
             '2',
             A.CHANNEL_NO,
             B.CHANNEL_NAME,
             '',
             '02',
             '00',
             SUM(LOW_VALUE),
             SUM(VALUE_MON)
        FROM ALLDM.INTEGRAL_SYS_DEVLP_JF_D A, DIM.DIM_CBDY_AND_CHANNEL B
       WHERE DAY_ID = V_DAY
         AND A.CHANNEL_NO = B.CHANNEL_ID
       GROUP BY A.DAY_ID,
                A.AREA_NO,
                A.CITY_NO,
                B.CBDY_NO,
                A.CHANNEL_NO,
                B.CHANNEL_NAME;
    COMMIT;
  
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
