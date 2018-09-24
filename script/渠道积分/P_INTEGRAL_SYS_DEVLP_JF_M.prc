CREATE OR REPLACE PROCEDURE P_INTEGRAL_SYS_DEVLP_JF_M(v_month    VARCHAR2,
                                                      V_RETCODE OUT VARCHAR2,
                                                      V_RETINFO OUT VARCHAR2) IS
  /*****************************************************************
  *���� --%NAME: P_INTEGRAL_SYS_DEVLP_JF_D
  *�������� --%COMMENT:
  *ִ������ --%PERIOD: ��
  *���� --%PARAM:v_month  ����,��ʽYYYYMMDD
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
  --V_MONTH      VARCHAR2(40);
  V_LAST_MONTH VARCHAR2(40);
  --V_DAY        VARCHAR2(40);
  --V_LAST_5     VARCHAR2(40);

  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO NOT IN ('018');

BEGIN
  V_PKG      := '����������ϵ';
  V_PROCNAME := 'P_INTEGRAL_SYS_DEVLP_JF_M';
  --V_MONTH    := SUBSTR(v_month, 1, 6);
  --V_DAY      := SUBSTR(v_month, 7, 2);
  --V_LAST_5     := TO_CHAR(TO_DATE(v_month, 'YYYYMMDD') - 10, 'YYYYMMDD');
  V_LAST_MONTH := TO_CHAR(ADD_MONTHS(TO_DATE(v_month, 'YYYYMM'), -1),
                          'YYYYMM');

  --��־����
  ALLDM.P_ALLDM_INSERT_LOG(v_month, V_PKG, V_PROCNAME, '12', SYSDATE);
  ---------------------------------------------------------------
  -- ���ݲ���

  SELECT COUNT(1)
    INTO V_COUNT
    FROM DW.DW_EXECUTE_LOG
   WHERE ACCT_MONTH = v_month
     AND RESULT = 'SUCCESS'
     AND PROCNAME IN ('P_DW_V_USER_BASE_INFO_USER');
  COMMIT;

  IF V_COUNT = 1 THEN
    /*EXECUTE IMMEDIATE 'ALTER TABLE ALLDM.INTEGRAL_SYS_DEVLP_JF_DETAIL TRUNCATE PARTITION PART_' ||
    v_month;*/

    FOR C1 IN V_AREA LOOP
      ---�ƶ�����Ʒ����+�ں�ҵ�����
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_INTEGRAL_SYS_DEVLP_JF_M';
      INSERT INTO MID_INTEGRAL_SYS_DEVLP_JF_M
        SELECT ACCT_MONTH,
               '' DAY_ID,
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
          FROM DW.DW_V_USER_BASE_INFO_user T
         WHERE ACCT_MONTH = V_MONTH
           AND AREA_NO = C1.AREA_NO
           AND CHANNEL_TYPE LIKE '11%'
           AND IS_NEW='1' --�޸�
           /*AND IS_VALID = '1'
           AND TO_CHAR(INNET_DATE, 'YYYYMM') = v_month*/
           AND ((TELE_TYPE = '2' AND
               IS_KD_BUNDLE IN
               ('0', '01', '011', '02', '021', '04', '041', '06')) OR
               (TELE_TYPE IN ('4', '26') AND INNET_METHOD in ('1', '2', '4', '5', '15')AND
               IS_KD_BUNDLE IN ('0', '01', '011', '02', '021')) OR
               (TELE_TYPE = '72' AND
               IS_KD_BUNDLE in ('0', '01', '011', '04', '041')));
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
      INSERT INTO INTEGRAL_SYS_DEVLP_JF_DETAIL_M
        SELECT ACCT_MONTH ,
               AREA_NO,
               CITY_NO,
               TELE_TYPE,
               '' AGENT_ID,
               '' AGENT_NAME,
               T.CHANNEL_NO,
               USER_NO,
               DEVICE_NUMBER,
               T.USER_DINNER,
               case
                 when t.user_dinner_desc like '%��װ%' then ---������10��
                  10
                 when A.LOW_VALUE > 1000 THEN
                  1000
                 else
                  A.LOW_VALUE
               end,
               '1'
          FROM MID_INTEGRAL_SYS_DEVLP_JF_M         T,
               RPT_HBTELE.SJZX_WH_DIM_USER_DINNER A
         WHERE T.USER_DINNER = A.USER_DINNER(+)
           AND TELE_TYPE = '2'
           and t.is_kd_bundle = '0';
      COMMIT;

      ---�ںϣ����ֻ��ģ�--�ֻ�
      INSERT INTO INTEGRAL_SYS_DEVLP_JF_DETAIL_M
        SELECT ACCT_MONTH ,
               AREA_NO,
               CITY_NO,
               TELE_TYPE,
               '' AGENT_ID,
               '' AGENT_NAME,
               T.CHANNEL_NO,
               USER_NO,
               DEVICE_NUMBER,
               T.USER_DINNER,
               case
                 when t.user_dinner_desc like '%��װ%' then ---������10��
                  10
                 when A.LOW_VALUE > 1000 THEN
                  1000
                 else
                  A.LOW_VALUE
               end,
               '2'
          FROM MID_INTEGRAL_SYS_DEVLP_JF_M          T,
               RPT_HBTELE.SJZX_WH_DIM_USER_DINNER A
         WHERE T.USER_DINNER = A.USER_DINNER(+)
           AND TELE_TYPE = '2'
           and t.is_kd_bundle <> '0';
      COMMIT;
      --��� itv
      INSERT INTO INTEGRAL_SYS_DEVLP_JF_DETAIL_M
        SELECT ACCT_MONTH ,
               AREA_NO,
               CITY_NO,
               TELE_TYPE,
               '' AGENT_ID,
               '' AGENT_NAME,
               T.CHANNEL_NO,
               USER_NO,
               DEVICE_NUMBER,
               T.USER_DINNER,
               case
                 when tele_type = '72' then
                  10
                 else
                  20
               end,
               '2'
          FROM MID_INTEGRAL_SYS_DEVLP_JF_M         T,
               RPT_HBTELE.SJZX_WH_DIM_USER_DINNER A
         WHERE T.USER_DINNER = A.USER_DINNER(+)
           AND TELE_TYPE <> '2'
           and t.is_kd_bundle <> '0';
      COMMIT;
    --����
      INSERT INTO INTEGRAL_SYS_DEVLP_JF_DETAIL_m
        SELECT ACCT_MONTH ,
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
                 when tele_type = '72' then
                  10
                 else
                  60
               END,
               '3'
          FROM MID_INTEGRAL_SYS_DEVLP_JF_M T,
               (SELECT DISTINCT AGENT_ID, AGENT_NAME, CHANNEL_NO
                  FROM RPT_HBTELE.DM_BUSI_CHANNEL_BUILD
                 WHERE ACCT_MONTH = V_LAST_MONTH
                   AND AREA_NO = C1.AREA_NO) B
         WHERE T.CHANNEL_NO = B.CHANNEL_NO(+)
           AND TELE_TYPE IN ('4', '26', '72')
           AND t.is_kd_bundle='0';
      COMMIT;

    END LOOP;
    DELETE FROM INTEGRAL_SYS_DEVLP_JF_M WHERE acct_month = v_month;
    COMMIT;


      INSERT INTO INTEGRAL_SYS_DEVLP_JF_M
        SELECT v_month,
               B.AREA_NO,
               B.CITY_NO,
               CASE
                 WHEN JF_TYPE = '1' THEN
                  '�ƶ�����Ʒ����'
                 WHEN JF_TYPE = '2' THEN
                  '�ں�ҵ�����'
                 WHEN JF_TYPE = '3' THEN
                  '����ҵ�����'
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
                  FROM INTEGRAL_SYS_DEVLP_JF_DETAIL_M
                 WHERE DAY_ID = v_month) A,
               (SELECT *
                  FROM DIM.DIM_CHANNEL_NO
                 WHERE CHANNEL_TYPE LIKE '11%'
                   AND VALID_STATUS = '1') B,
               (SELECT DISTINCT AGENT_ID,
                                AGENT_NAME,
                                CHANNEL_NO,
                                CASE
                                  WHEN T.CHANNEL_TYPE = '110101' THEN
                                   '04'
                                  WHEN BUSINESS_ZONE = '10' THEN
                                   '02'
                                  WHEN BUSINESS_ZONE_NAME LIKE '%��Ȧ%' THEN
                                   '01'
                                  ELSE
                                   '03'
                                END CHANNEL_PROP_NO,
                                CASE
                                  WHEN T.CHANNEL_TYPE = '110101' THEN
                                   '��Ӫ'
                                  WHEN BUSINESS_ZONE = '10' THEN
                                   '����'
                                  WHEN BUSINESS_ZONE_NAME LIKE '%��Ȧ%' THEN
                                   '��Ȧ'
                                  ELSE
                                   'ũ��'
                                END CHANNEL_PROP_NAME,

                                CASE
                                  WHEN T.CHANNEL_TYPE IN ('110101') THEN
                                   '01'
                                  WHEN T.CHANNEL_TYPE IN ('110201') THEN
                                   '02'
                                  WHEN T.CHANNEL_TYPE IN ('110301') THEN
                                   '03'
                                  WHEN T.CHANNEL_TYPE IN ('110302') THEN
                                   '04'
                                  WHEN (T.CHANNEL_TYPE NOT IN
                                       ('110101',
                                         '110102',
                                         '110103',
                                         '110201',
                                         '110301',
                                         '110302') OR T.CHANNEL_TYPE IS NULL) AND
                                       T.PROTOP10 IN ('1', '2') THEN
                                   '05'
                                  WHEN (T.CHANNEL_TYPE NOT IN
                                       ('110101',
                                         '110102',
                                         '110103',
                                         '110201',
                                         '110301',
                                         '110302') OR T.CHANNEL_TYPE IS NULL) AND
                                       (T.PROTOP10 NOT IN ('1', '2') OR
                                       T.PROTOP10 IS NULL) THEN
                                   '06'
                                  WHEN T.CHANNEL_TYPE IN ('110102') THEN
                                   '07'
                                  WHEN T.CHANNEL_TYPE IN ('110103') THEN
                                   '08'
                                  ELSE
                                   '09'
                                END REGION_PROP_NO,
                                CASE
                                  WHEN T.CHANNEL_TYPE IN
                                       ('110101', '110102', '110103') THEN
                                   '��Ӫ��'
                                  WHEN T.CHANNEL_TYPE IN ('110201') THEN
                                   'רӪ��'
                                  WHEN T.CHANNEL_TYPE IN ('110301') THEN
                                   '��������'
                                  WHEN T.CHANNEL_TYPE IN ('110302') THEN
                                   'ʡ������'
                                  WHEN (T.CHANNEL_TYPE NOT IN
                                       ('110101',
                                         '110102',
                                         '110103',
                                         '110201',
                                         '110301',
                                         '110302') OR T.CHANNEL_TYPE IS NULL) AND
                                       T.PROTOP10 IN ('1', '2') THEN
                                   'ʡ��TOP'
                                  WHEN (T.CHANNEL_TYPE NOT IN
                                       ('110101',
                                         '110102',
                                         '110103',
                                         '110201',
                                         '110301',
                                         '110302') OR T.CHANNEL_TYPE IS NULL) AND
                                       (T.PROTOP10 NOT IN ('1', '2') OR
                                       T.PROTOP10 IS NULL) THEN
                                   '��С��Ӫ'
                                  WHEN T.CHANNEL_TYPE IN ('110102') THEN
                                   '�����'
                                  WHEN T.CHANNEL_TYPE IN ('110103') THEN
                                   '�����'
                                  ELSE
                                   '����'
                                END REGION_PROP_NAME
                  FROM RPT_HBTELE.DM_BUSI_CHANNEL_BUILD T
                 WHERE ACCT_MONTH = V_LAST_MONTH) C
         WHERE B.CHANNEL_NO = A.CHANNEL_NO(+)
           AND B.CHANNEL_NO = C.CHANNEL_NO
           AND B.VALID_STATUS = '1'
         GROUP BY B.AREA_NO,
                  B.CITY_NO,
                  C.AGENT_ID,
                  C.AGENT_NAME,
                  B.CHANNEL_NO,
                  JF_TYPE,
                  NVL(C.CHANNEL_PROP_NO, '01'),
                  NVL(C.CHANNEL_PROP_NAME, '��Ȧ'),
                  NVL(C.REGION_PROP_NO, '07'),
                  NVL(C.REGION_PROP_NAME, '����');
      COMMIT;

    --������־
    V_RETCODE := 'SUCCESS';
    ALLDM.P_ALLDM_UPDATE_LOG(v_month,
                             V_PKG,
                             V_PROCNAME,
                             '����',
                             V_RETCODE,
                             SYSDATE);
    DBMS_OUTPUT.PUT_LINE(V_RETCODE);
    ------------------------------------- ���ݲ��ֽ��� -------------------------
  ELSE
    V_RETCODE := 'WAIT';
    ALLDM.P_ALLDM_UPDATE_LOG(v_month,
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
    ALLDM.P_ALLDM_UPDATE_LOG(v_month,
                             V_PKG,
                             V_PROCNAME,
                             V_RETINFO,
                             V_RETCODE,
                             SYSDATE);
END;
/
