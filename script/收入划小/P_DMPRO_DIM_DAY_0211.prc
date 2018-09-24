CREATE OR REPLACE PROCEDURE DMPRO.P_DMPRO_DIM_DAY(V_DATE    VARCHAR2,
                                            V_RETCODE OUT VARCHAR2,
                                            V_RETINFO OUT VARCHAR2) IS

  /*******************************************************************
       �� �� �� : ÿ������ײ���� ��վ��� �ƶ�����ͷ
       ����ʱ�� ��20070518
       �� д �� ���¶���
       �������� ��ÿ��ִ��
       ִ��ʱ�� :
       ʹ�ò��� ��
       �����   ��DIM.DIM_CELL_NO,DIM.DIM_USER_DINNER,DIM.DIM_MOBILE_CAP
  ----------------------------------------------------------------------
       �� �� �� ���¶���
       �޸�ʱ�� ��20070816
       �޸����� ���ײ͵��в�Ӧȫ��Ϊ'018'
       ���Ӹ����������
  **********************************************************************/
  V_PROCNAME   VARCHAR2(30);
  V_PKG        VARCHAR2(30);
  V_COUNT      NUMBER;
  V_DINNER_NUM NUMBER;
  V_OMM_NUM    NUMBER;
  V_XQ_NUM     NUMBER;
  V_XQ_NUM_2   NUMBER;
  V_LAST30_M VARCHAR2(30);
  V_LAST30_DAY  VARCHAR2(30);

  CURSOR V_TOWN_DMCODE IS
    SELECT * FROM DMCODE.DMCODE_TOWN;
  V_TOWN_DMCODE1 V_TOWN_DMCODE%ROWTYPE;

  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018'/*AREA_NO = '188' */ ORDER BY IDX_NO;
BEGIN
  V_LAST30_DAY  := TO_CHAR(TO_DATE(V_DATE, 'YYYYMMDD') -30, 'YYYYMMDD');
  V_LAST30_M:= SUBSTR(TO_CHAR(TO_DATE(V_DATE, 'YYYYMMDD') -30, 'YYYYMMDD'),1,6);

  V_PROCNAME := 'P_DMPRO_DIM_DAY';
  V_PKG      := 'DIM_CODE';

  SELECT COUNT(1)
    INTO V_COUNT
    FROM STAGE.FTP_LOAD_TABLE A
   WHERE A.ACCT_MONTH = V_DATE
     AND A.RESULT = 'SUCCESS'
     AND A.TABLE_NAMES IN ('PROD_OFFER', 'OM_AREA_T', 'CHANNEL');
  COMMIT;

  DW.P_INSERT_LOG(V_DATE, V_PKG, V_PROCNAME, '12', SYSDATE);

  IF V_COUNT >= 0 THEN

    ----------���»�վ------------------------

    INSERT INTO MID_CELL_NO NOLOGGING
      SELECT CITY_CODE,
             REGION_CODE,
             TELE_TYPE,
             TELE_TYPE || '_' || CITY_CODE || TRIM(CELL_ID),
             NAME,
             '',
             KIND,
             CELL_BUREAU,
             MSC_ID,
             SYSDATE,
             START_DATE,
             INVALID_DATE
        FROM (SELECT /*+ORDERED*/
               CITY_CODE,
               REGION_CODE,
               TELE_TYPE,
               CELL_ID,
               NAME,
               TO_CHAR(KIND) KIND,
               CELL_BUREAU,
               MSC_ID,
               START_DATE START_DATE,
               INVALID_DATE INVALID_DATE
                FROM ODS_STAGE.BS_DEF_CELL_ID_T@HBODS A, DIM.DIM_TELE_TYPE B
               WHERE A.SERVICE_KIND = B.NEUS_TELE_TYPE) T1
       WHERE NOT EXISTS
       (SELECT 1
                FROM MID_CELL_NO T2
               WHERE T2.TELE_TYPE = T1.TELE_TYPE
                 AND T2.AREA_NO = T1.CITY_CODE
                 AND SUBSTR(T2.CELL_NO,
                            (LENGTH(T2.TELE_TYPE) + LENGTH(T2.AREA_NO) + 2)) =
                     T1.CELL_ID);
    COMMIT;
    UPDATE MID_CELL_NO A
       SET CITY_NO = DECODE(A.AREA_NO,
                            '180',
                            '018' || '180' || '035',
                            '181',
                            '018' || '181' || '000',
                            '182',
                            '018' || '182' || '000',
                            '183',
                            '018' || '183' || '000',
                            '184',
                            '018' || '184' || '023',
                            '185',
                            '018' || '185' || '001',
                            '186',
                            '018' || '186' || '001',
                            '187',
                            '018' || '187' || '026',
                            '188',
                            '018' || '188' || '028',
                            '189',
                            '018' || '189' || '014',
                            '720',
                            '018' || '720' || '000')
     WHERE CITY_NO = '1';
    COMMIT;
    DELETE FROM DIM.DIM_CELL_NO;
    COMMIT;
    INSERT INTO DIM.DIM_CELL_NO
      SELECT NVL(T1.CITY_CODE, T2.AREA_NO),
             NVL(T1.REGION_CODE, T2.CITY_NO),
             T2.TELE_TYPE,
             T2.CELL_NO,
             NVL(T1.NAME, T2.CELL_DESC),
             '',
             NVL(T1.KIND, T2.KIND),
             NVL(T1.CELL_BUREAU, T2.CELL_BUREAU),
             NVL(T1.MSC_ID, T2.MSC_ID),
             SYSDATE,
             NVL(T1.START_DATE, T2.START_DATE),
             NVL(T1.INVALID_DATE, T2.INVALID_DATE)
        FROM MID_CELL_NO T2,
             (SELECT /*+ORDERED*/
               CITY_CODE,
               REGION_CODE,
               TELE_TYPE,
               CELL_ID,
               NAME,
               TO_CHAR(KIND) KIND,
               CELL_BUREAU,
               MSC_ID,
               START_DATE START_DATE,
               INVALID_DATE INVALID_DATE
                FROM ODS_STAGE.BS_DEF_CELL_ID_T@HBODS A, DIM.DIM_TELE_TYPE B
               WHERE A.SERVICE_KIND = B.NEUS_TELE_TYPE) T1
       WHERE T2.TELE_TYPE = T1.TELE_TYPE(+)
         AND T2.AREA_NO = T1.CITY_CODE(+)
         AND SUBSTR(T2.CELL_NO,
                    (LENGTH(T2.TELE_TYPE) + LENGTH(T2.AREA_NO) + 2)) =
             T1.CELL_ID(+);
    COMMIT;
    UPDATE DIM.DIM_CELL_NO A
       SET CITY_NO = DECODE(A.AREA_NO,
                            '180',
                            '018' || '180' || '035',
                            '181',
                            '018' || '181' || '000',
                            '182',
                            '018' || '182' || '000',
                            '183',
                            '018' || '183' || '000',
                            '184',
                            '018' || '184' || '023',
                            '185',
                            '018' || '185' || '001',
                            '186',
                            '018' || '186' || '001',
                            '187',
                            '018' || '187' || '026',
                            '188',
                            '018' || '188' || '028',
                            '189',
                            '018' || '189' || '014',
                            '720',
                            '018' || '720' || '000')
     WHERE CITY_NO = '1';
    COMMIT;
    ---------------------�����ײ�-----------------------------
    --�����ײ����
    DELETE FROM DIM.DIM_USER_DINNER_DAY_BAK T
     WHERE DAY_ID = TO_CHAR(TO_DATE(V_DATE, 'YYYYMMDD') - 1, 'YYYYMMDD');
    COMMIT;
     IF V_LAST30_DAY <>TO_CHAR(LAST_DAY(TO_DATE(V_LAST30_M, 'YYYYMM')),'YYYYMMDD') THEN
        DELETE FROM DIM.DIM_USER_DINNER_DAY_BAK T
     WHERE DAY_ID = V_LAST30_DAY;
    COMMIT;
     END IF;



    INSERT INTO DIM.DIM_USER_DINNER_DAY_BAK
      SELECT TO_CHAR(TO_DATE(V_DATE, 'YYYYMMDD') - 1, 'YYYYMMDD'),
             USER_DINNER,
             USER_DINNER_DESC,
             TELE_TYPE,
             AREA_NO,
             DINNER_TYPE,
             DINNER_TYPE_DESC,
             BRAND,
             BRAND_DESC,
             SUB_BRAND,
             SUB_BRAND_DESC,
             BAOYUE_TYPE,
             CREATE_DATE,
             EXPIRE_DATE,
             DINNER_GROUP_NO,
             IF_COMB_PROD,
             IF_3G,
             NEW_BRAND,
             DEMO,
             STATUS_CD,
             STATUS_DATE

        FROM DIM.DIM_USER_DINNER A;
    COMMIT;

    DELETE FROM MID_USER_DINNER;
    COMMIT;
    INSERT INTO MID_USER_DINNER
      SELECT TO_CHAR(PROD_OFFER_ID),
             PROD_OFFER_NAME,
             '' TELE_TYPE,
             SUBSTR(F_CITY_CODE, 1, 3),
             DECODE(TO_NUMBER(OFFER_TYPE), 10, 1, 11, 1, 3),
             '',
             NVL(B.BRAND_ID, '32'),
             NVL(B.BRAND_NAME, '������'),
             TO_CHAR(A.PROD_OFFER_BRAND_ID),
             B.SUB_BRAND_NAME,
             '',
             EFF_DATE,
             EXP_DATE,
             TO_CHAR(PROD_OFFER_GROUP_ID),
             '' F_IF_COMB_PROD,
             IF_3G,
             PROD_OFFER_BRAND_ID,
             SUBSTR(PROD_OFFER_DESC, 1, 2000),
             BIND_TYPE,
             STATUS_CD,
             STATUS_DATE
        FROM (SELECT T1.*,
                     ROW_NUMBER() OVER(PARTITION BY PROD_OFFER_ID ORDER BY EFF_DATE DESC, EXP_DATE DESC) RN
                FROM ODS_STAGE.PROD_OFFER@HBODS T1
               WHERE T1.OFFER_TYPE IN ('10', '11', '12') --10��11�����ײ�  12�ǿ�ѡ��  13�Ǵ���
                    --AND EFFECT_TYPE IN (4, 5, 8, 10)
                 AND NOT EXISTS
               (SELECT 1
                        FROM DIM.DIM_USER_DINNER T2
                       WHERE T2.USER_DINNER = TO_CHAR(T1.PROD_OFFER_ID))) A,
             DIM.DIM_BRAND_NEW B,
             DSG_STAGE.OM_AREA_T D
       WHERE A.PROD_OFFER_BRAND_ID = B.SUB_BRAND_ID(+)
         AND A.AREA_ID = D.F_AREA_ID(+)
         AND A.RN = 1;
    COMMIT;
    -----------���������ײ�---------
    INSERT INTO DIM.DIM_USER_DINNER
      SELECT A.USER_DINNER,
             A.USER_DINNER_DESC,
             CASE
               WHEN A.BIND_TYPE IN (1, 2) THEN
                '102'
               ELSE
                B.TELE_TYPE
             END,
             A.AREA_NO,
             A.DINNER_TYPE,
             A.DINNER_TYPE_DESC,
             A.BRAND,
             A.BRAND_DESC,
             A.SUB_BRAND,
             A.SUB_BRAND_DESC,
             A.BAOYUE_TYPE,
             A.CREATE_DATE,
             A.EXPIRE_DATE,
             A.DINNER_GROUP_NO,
             A.IF_COMB_PROD,
             A.IF_3G,
             A.NEW_BRAND,
             A.DEMO,
             A.STATUS_CD,
             A.STATUS_DATE
        FROM MID_USER_DINNER A,
             (SELECT /*+FULL(A)*/
               A.*,
               ROW_NUMBER() OVER(PARTITION BY A.USER_DINNER ORDER BY DAY_ID) RN
                FROM DIM.DIM_USER_DINNER_DAY_BAK A
               WHERE A.DAY_ID =
                     TO_CHAR(TO_DATE(V_DATE, 'YYYYMMDD') - 1, 'YYYYMMDD')) B
       WHERE A.USER_DINNER = B.USER_DINNER(+)
         AND B.RN(+) = 1;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('11');

    -----------�����ײ�״̬-------------
    ----------------------------------2013��9��11��17:44:05 ---------------------------------

    ---ɾ���ײ�״̬�м��
    DELETE FROM MID_USER_DINNER_STATUS_CD;
    COMMIT;

    --д������״̬��������Ψһ�ļ�¼
    INSERT INTO MID_USER_DINNER_STATUS_CD
      SELECT PROD_OFFER_ID,
             STATUS_CD,
             STATUS_DATE STATUS_DATE,
             PROD_OFFER_NAME,
             CASE
               WHEN BIND_TYPE IN (1, 2) THEN
                '102'
               ELSE
                TO_CHAR(BIND_TYPE)
             END BIND_TYPE,
             PROD_OFFER_BRAND_ID,
             IF_3G,
             SUBSTR(PROD_OFFER_DESC,1,2000)
        FROM (SELECT PROD_OFFER_ID,
                     STATUS_CD,
                     STATUS_DATE,
                     B.PROD_OFFER_NAME,
                     BIND_TYPE,
                     PROD_OFFER_BRAND_ID,
                     IF_3G,

                     ROW_NUMBER() OVER(PARTITION BY PROD_OFFER_ID  ORDER BY EFF_DATE DESC, EXP_DATE DESC) RN,
                     PROD_OFFER_DESC
                FROM ODS_STAGE.PROD_OFFER@HBODS B)
       WHERE RN = 1;
    COMMIT;

    ---ɾ���ײ͸��Ʊ������
    DELETE FROM MID_USER_DINNER_COPY;
    COMMIT;

    --���¸����ײͱ������
    INSERT INTO MID_USER_DINNER_COPY
      SELECT * FROM DIM.DIM_USER_DINNER;
    COMMIT;

    --ɾ���ײͱ��е�����
    DELETE FROM DIM.DIM_USER_DINNER;
    COMMIT;

    ---ͨ���ײ͸��Ʊ� ���� �ײͱ��е�STATUS_CD\STATUS_DATE �ֶ�
    INSERT INTO DIM.DIM_USER_DINNER
      SELECT USER_DINNER,
             NVL(B.PROD_OFFER_NAME, A.USER_DINNER_DESC),
             NVL(B.BIND_TYPE, A.TELE_TYPE),
             AREA_NO,
             DINNER_TYPE,
             DINNER_TYPE_DESC,
             NVL(C.BRAND_ID, A.BRAND),
             NVL(C.BRAND_NAME, A.BRAND_DESC),
             NVL(B.PROD_OFFER_BRAND_ID, SUB_BRAND),
             NVL(C.SUB_BRAND_NAME, SUB_BRAND_DESC),
             BAOYUE_TYPE,
             CREATE_DATE,
             EXPIRE_DATE,
             DINNER_GROUP_NO,
             IF_COMB_PROD,
             NVL(B.IF_3G, A.IF_3G),
             NVL(PROD_OFFER_BRAND_ID, NEW_BRAND),
             NVL(B.DEMO, A.DEMO),
             NVL(B.STATUS_CD, A.STATUS_CD) STATUS_CD,
             NVL(B.STATUS_DATE, A.STATUS_DATE) STATUS_DATE
        FROM MID_USER_DINNER_COPY      A,
             MID_USER_DINNER_STATUS_CD B,
             DIM.DIM_BRAND_NEW         C
       WHERE A.USER_DINNER = B.PROD_OFFER_ID(+)
         AND B.PROD_OFFER_BRAND_ID = C.SUB_BRAND_ID(+);
    COMMIT;

    ------------------------------------------------------------------------------------------

    SELECT COUNT(0) INTO V_DINNER_NUM FROM DIM.DIM_USER_DINNER;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(V_DINNER_NUM));
    IF V_DINNER_NUM < 2000 THEN
      DELETE FROM DIM.DIM_USER_DINNER;
      COMMIT;
      INSERT INTO DIM.DIM_USER_DINNER
        SELECT USER_DINNER,
               USER_DINNER_DESC,
               TELE_TYPE,
               AREA_NO,
               DINNER_TYPE,
               DINNER_TYPE_DESC,
               BRAND,
               BRAND_DESC,
               SUB_BRAND,
               SUB_BRAND_DESC,
               BAOYUE_TYPE,
               CREATE_DATE,
               EXPIRE_DATE,
               DINNER_GROUP_NO,
               IF_COMB_PROD,
               IF_3G,
               NEW_BRAND,
               DEMO,
               STATUS_CD,
               STATUS_DATE
          FROM (SELECT A.*,
                       ROW_NUMBER() OVER(PARTITION BY A.USER_DINNER ORDER BY DAY_ID) RN
                  FROM DIM.DIM_USER_DINNER_DAY_BAK A
                 WHERE A.DAY_ID =
                       TO_CHAR(TO_DATE(V_DATE, 'YYYYMMDD') - 1, 'YYYYMMDD'))
         WHERE RN = 1;
      COMMIT;
    END IF;
    DBMS_OUTPUT.PUT_LINE('111111');
    DELETE FROM DIM.DIM_USER_DINNER_TIANYI;
    COMMIT;
    INSERT INTO DIM.DIM_USER_DINNER_TIANYI
      (USER_DINNER,
       USER_DINNER_DESC,
       TELE_TYPE,
       AREA_NO,
       DINNER_TYPE,
       DINNER_TYPE_DESC,
       BRAND,
       BRAND_DESC,
       SUB_BRAND,
       SUB_BRAND_DESC,
       BAOYUE_TYPE,
       CREATE_DATE,
       EXPIRE_DATE,
       DINNER_GROUP_NO,
       TY_BRAND)
      SELECT USER_DINNER,
             USER_DINNER_DESC,
             TELE_TYPE,
             AREA_NO,
             DINNER_TYPE,
             DINNER_TYPE_DESC,
             BRAND,
             BRAND_DESC,
             SUB_BRAND,
             SUB_BRAND_DESC,
             BAOYUE_TYPE,
             CREATE_DATE,
             EXPIRE_DATE,
             DINNER_GROUP_NO,
             DECODE(NEW_BRAND,
                    '39',
                    '1',
                    '40',
                    '2',
                    '41',
                    '3',
                    '42',
                    '4',
                    '43',
                    '5',
                    '44',
                    '1',
                    '45',
                    '2',
                    '46',
                    '3',
                    '47',
                    '4',
                    '48',
                    '5',
                    '59',
                    '7',
                    '60',
                    '2',
                    '101',
                    '8',
                    '110',
                    '9')
        FROM DIM.DIM_USER_DINNER A
       WHERE A.NEW_BRAND IN ('44',
                             '45',
                             '46',
                             '40',
                             '39',
                             '41',
                             '42',
                             '43',
                             '47',
                             '48',
                             '59',
                             '60',
                             '101',
                             '110');
    COMMIT;

    --�����ײͣ�������������
    DELETE FROM DIM.DIM_USER_DINNER_TY;
    COMMIT;
    INSERT INTO DIM.DIM_USER_DINNER_TY
      (USER_DINNER,
       USER_DINNER_DESC,
       TELE_TYPE,
       AREA_NO,
       DINNER_TYPE,
       DINNER_TYPE_DESC,
       BRAND,
       BRAND_DESC,
       SUB_BRAND,
       SUB_BRAND_DESC,
       BAOYUE_TYPE,
       CREATE_DATE,
       EXPIRE_DATE,
       DINNER_GROUP_NO,
       TY_BRAND)
      SELECT USER_DINNER,
             USER_DINNER_DESC,
             TELE_TYPE,
             AREA_NO,
             DINNER_TYPE,
             DINNER_TYPE_DESC,
             BRAND,
             BRAND_DESC,
             SUB_BRAND,
             SUB_BRAND_DESC,
             BAOYUE_TYPE,
             CREATE_DATE,
             EXPIRE_DATE,
             DINNER_GROUP_NO,
             DECODE(NEW_BRAND,
                    '39',
                    '1',
                    '40',
                    '2',
                    '41',
                    '3',
                    '42',
                    '4',
                    '43',
                    '5',
                    '44',
                    '1',
                    '45',
                    '2',
                    '46',
                    '3',
                    '47',
                    '4',
                    '48',
                    '5',
                    '59',
                    '7',
                    '60',
                    '2',
                    '101',
                    '8',
                    '110',
                    '9')
        FROM DIM.DIM_USER_DINNER A
       WHERE A.NEW_BRAND IN ('44',
                             '45',
                             '46',
                             '40',
                             '39',
                             '41',
                             '42',
                             '43',
                             '47',
                             '48',
                             '59',
                             '60',
                             '101',
                             '110');
    COMMIT;

    ---2012��5��22��11:23:58 ���� �⹤����ָ����ϵ��Ҫ����

    --ɾ�� '34957', '34958', '36014'
    DELETE FROM DIM.DIM_USER_DINNER_TY
     WHERE USER_DINNER IN ('34957', '34958', '36014');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('22222222222');
    ---д�� '34957', '34958', '36014'
    INSERT INTO DIM.DIM_USER_DINNER_TY
      SELECT USER_DINNER,
             USER_DINNER_DESC,
             TELE_TYPE,
             AREA_NO,
             DINNER_TYPE,
             DINNER_TYPE_DESC,
             BRAND,
             BRAND_DESC,
             SUB_BRAND,
             SUB_BRAND_DESC,
             BAOYUE_TYPE,
             CREATE_DATE,
             EXPIRE_DATE,
             DINNER_GROUP_NO,
             '9' TY_BRAND,
             NULL DINNER_LEVEL
        FROM DIM.DIM_USER_DINNER A
       WHERE USER_DINNER IN ('34957', '34958', '36014');
    COMMIT;

    DELETE FROM DMCODE.DMCODE_USER_DINNER;
    COMMIT;
    INSERT INTO DMCODE.DMCODE_USER_DINNER T
      SELECT USER_DINNER,
             USER_DINNER_DESC,
             TELE_TYPE,
             AREA_NO,
             DINNER_TYPE,
             DINNER_TYPE_DESC,
             BRAND,
             BRAND_DESC,
             SUB_BRAND,
             SUB_BRAND_DESC,
             BAOYUE_TYPE,
             CREATE_DATE,
             EXPIRE_DATE,
             SUBSTR(DEMO,1,2000)
        FROM DIM.DIM_USER_DINNER A;
    COMMIT;
    DELETE FROM ALLDMCODE.DMCODE_USER_DINNER;
    COMMIT;
    INSERT INTO ALLDMCODE.DMCODE_USER_DINNER T
      SELECT USER_DINNER,
             USER_DINNER_DESC,
             TELE_TYPE,
             AREA_NO,
             DINNER_TYPE,
             DINNER_TYPE_DESC,
             (CASE
               WHEN A.SUB_BRAND IN (9, 10, 11, 12, 24, 35) THEN
                '20'
               WHEN A.SUB_BRAND IN (13, 14, 15, 22, 23) THEN
                '40'
               WHEN A.SUB_BRAND IN (16, 17, 18, 19, 25, 26, 33, 34) THEN
                '10'
               WHEN A.SUB_BRAND IN (39, 40, 41, 42, 43, 44, 45, 46, 47, 48) THEN
                '50'
               WHEN A.SUB_BRAND IN (50, 51, 49) THEN
                '70'
               WHEN A.SUB_BRAND IN (52, 53, 54) THEN
                '60'
               ELSE
                '90'
             END),
             (CASE
               WHEN A.SUB_BRAND IN (9, 10, 11, 12, 24, 35) THEN
                '�����'
               WHEN A.SUB_BRAND IN (13, 14, 15, 22, 23) THEN
                '������'
               WHEN A.SUB_BRAND IN (16, 17, 18, 19, 25, 26, 33, 34) THEN
                '����ͨ'
               WHEN A.SUB_BRAND IN (39, 40, 41, 42, 43, 44, 45, 46, 47, 48) THEN
                '����'
               WHEN A.SUB_BRAND IN (50, 51, 49) THEN
                '�ҵ�E��'
               WHEN A.SUB_BRAND IN (52, 53, 54) THEN
                '�����캽'
               ELSE
                '����'
             END),
             DECODE(SUB_BRAND,
                    '39',
                    '44',
                    '40',
                    '45',
                    '41',
                    '46',
                    '42',
                    '47',
                    '43',
                    '48',
                    SUB_BRAND),
             DECODE(SUB_BRAND,
                    '39',
                    'T1',
                    '40',
                    'T2',
                    '41',
                    'T3',
                    '42',
                    'T4',
                    '43',
                    'T5',
                    SUB_BRAND_DESC),
             BAOYUE_TYPE,
             CREATE_DATE,
             EXPIRE_DATE,
             A.SUB_BRAND,
             A.SUB_BRAND_DESC,
             B.BRAND_ID,
             B.BRAND_NAME,
             A.DEMO
        FROM DIM.DIM_USER_DINNER A, ALLDMCODE.DMCODE_BRAND_NEW B
       WHERE A.SUB_BRAND = B.SUB_BRAND_ID(+);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('3333333333');
    ----��������Ʒ--------
    INSERT INTO DMCODE.DMCODE_DINNER_MODEL
      SELECT A.USER_DINNER,
             A.USER_DINNER_DESC,
             A.AREA_NO,
             A.TELE_TYPE,
             '' RENT_FEE,
             '' FAVOR_CALL_DURATION,
             '' FAVOR_CALL_TYPE,
             '' FAVOR_POINT_SMS,
             '' FAVOR_OTHER,
             '' FAVOR_FEE,
             '' PHONE_SHOW_FEE,
             '' PHONE_SHOW_TYPE,
             '' SEC_FEE,
             '' SEC_TYPE,
             '' RING_FEE,
             '' RING_TYPE,
             '' OTHER_FEE,
             '' LOCAL_OWNER_FEE,
             '' LOCAL_CLIENT_FEE,
             '' LOCAL_OTHER_FEE,
             '' LONG_BASE_FEE,
             '' LONG_IP_FEE,
             '' LONG_OTHER_FEE,
             '' ROAM_BASE_FEE,
             '' ROAM_OTHER_FEE,
             '' INNET_OWNER_FEE,
             '' INNET_CLIENT_FEE,
             '' RELATIVE_NUMBERS,
             '' RELATIVE_LOCAL_OWNER_FEE,
             '' RELATIVE_LOCAL_CLIENT_FEE,
             '' RELATIVE_LONG_OWNER_FEE,
             '' OTHER_DESC,
             '' PTP_TYPE,
             '' NET_TYPE,
             ''

        FROM DIM.DIM_USER_DINNER A
       WHERE DINNER_TYPE IN ('1')
         AND NOT EXISTS (SELECT 1
                FROM DMCODE.DMCODE_DINNER_MODEL B
               WHERE A.USER_DINNER = B.DINNER_ID);
    COMMIT;

    --------------����SP-----------------------

    INSERT INTO DIM.DIM_SP_NO
      SELECT SP_CODE,
             SP_NAME,
             SP_KIND,
             SMG_CODE,
             PROV_CODE,
             APPROACH_CODE,
             BELONG_TYPE,
             IF_CLEAR
        FROM STAGE.BS_SM_SP_CODE_T T1
       WHERE NOT EXISTS (SELECT 1
                FROM DIM.DIM_SP_NO T2
               WHERE T1.SP_CODE = T2.SP_NO
                 AND T1.APPROACH_CODE = T2.IN_CODE);
    COMMIT;
    INSERT INTO DMCODE.DMCODE_RULE_SP_CHARGE
      SELECT SP_NO, '0', SP_DESC, '20070730'
        FROM DIM.DIM_SP_NO T1
       WHERE NOT EXISTS (SELECT 1
                FROM DMCODE.DMCODE_RULE_SP_CHARGE T2
               WHERE T1.SP_NO = T2.SP_CODE);
    COMMIT;
    INSERT INTO ALLDMCODE.DMCODE_RULE_SP_CHARGE
      SELECT DISTINCT SP_NO, '0', SP_DESC, '20070730', NULL
        FROM DIM.DIM_SP_NO T1
       WHERE NOT EXISTS (SELECT 1
                FROM ALLDMCODE.DMCODE_RULE_SP_CHARGE T2
               WHERE T1.SP_NO = T2.SP_CODE);
    COMMIT;
    -------------------����ͷ------------------------
    INSERT INTO DIM.DIM_MOBILE_CAP
      SELECT B.AREA_NO, A.HEAD, B.AREA_DESC
        FROM ODS_STAGE.BS_INDB_PHONE_HEAD_T@HBODS  A, DIM.DIM_AREA_NO B
       WHERE SUBSTR(HEAD, 1, 3) NOT IN ('133', '153', '189', '180', '181')
            --('130', '131', '132', '133', '153', '156', '155')
         AND A.CITY_CODE = B.AREA_NO
         AND HEAD NOT IN (SELECT MOBILE_CAP FROM DIM.DIM_MOBILE_CAP);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('2222222222');
    INSERT INTO DIM.DIM_UNICOME_CAP
      SELECT B.AREA_NO, A.HEAD, B.AREA_DESC
        FROM ODS_STAGE.BS_INDB_PHONE_HEAD_T@HBODS A, DIM.DIM_AREA_NO B
       WHERE SUBSTR(HEAD, 1, 3) IN ('133', '153', '189', '180', '181')
            --('130', '131', '132', '133', '153', '156', '155','189')
         AND A.CITY_CODE = B.AREA_NO
         AND HEAD NOT IN (SELECT UNICOME_CAP FROM DIM.DIM_UNICOME_CAP);
    COMMIT;
    INSERT INTO DIM.DIM_CITY_NO_TRANS
      SELECT SUBSTR(F_CITY_CODE, 1, 3),
             '018' || B.F_CITY_CODE,
             TRIM(B.F_AREA_NAME),
             '1',
             B.F_AREA_ID,
             F_AREA_NAME
        FROM (SELECT F_AREA_ID
                FROM DIM.DIM_OM_AREA_T T
               WHERE T.F_AREA_LEVEL = 4
                 AND (T.F_INACTIVE_DATE IS NULL OR
                     T.F_INACTIVE_DATE >=
                     ADD_MONTHS(TO_DATE('20101206', 'YYYYMMDD'), -6))
              MINUS
              SELECT CITY_NO_NEUSOFT FROM DIM.DIM_CITY_NO_TRANS) A,
             DIM.DIM_OM_AREA_T B
       WHERE A.F_AREA_ID = B.F_AREA_ID;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('44444444444');
    INSERT INTO DIM.DIM_OM_AREA_TRANS
      SELECT B.F_AREA_ID,
             B.F_PARENT_AREA_ID,
             B.F_AREA_NAME,
             B.F_AREA_LEVEL,
             B.F_POSTAL_CODE,
             B.F_AREA_CODE,
             B.F_ACTIVE_DATE,
             B.F_INACTIVE_DATE,
             CASE
               WHEN B.F_AREA_LEVEL IN ('1', '2', '3') THEN
                B.F_CITY_CODE
               ELSE
                '018' || B.F_CITY_CODE
             END

        FROM (SELECT F_AREA_ID
                FROM DIM.DIM_OM_AREA_T T
              MINUS
              SELECT AREA_ID FROM DIM.DIM_OM_AREA_TRANS) A,
             DIM.DIM_OM_AREA_T B
       WHERE A.F_AREA_ID = B.F_AREA_ID;
    COMMIT;

    ------------------------��������-----------------------
    INSERT INTO DMCODE.DMCODE_CITY
      SELECT '018' || B.F_CITY_CODE,
             SUBSTR(F_CITY_CODE, 1, 3),
             TRIM(B.F_AREA_NAME),
             C.DESCRIPTION,
             '018' || B.F_CITY_CODE,
             '2',
             NVL('018' || B.F_CITY_CODE, C.IDX_NO),
             '018' || B.F_CITY_CODE,
             SUBSTR(F_CITY_CODE, 1, 3)
        FROM (SELECT '018' || T.F_CITY_CODE F_AREA_ID
                FROM DIM.DIM_OM_AREA_T T
               WHERE T.F_AREA_LEVEL = 4
                 AND (T.F_INACTIVE_DATE IS NULL OR
                     T.F_INACTIVE_DATE >=
                     ADD_MONTHS(TO_DATE('20101206', 'YYYYMMDD'), -6))
              MINUS
              SELECT CITY_ID FROM DMCODE.DMCODE_CITY) A,
             DIM.DIM_OM_AREA_T B,
             DMCODE.DMCODE_AREA C
       WHERE A.F_AREA_ID = '018' || B.F_CITY_CODE
         AND SUBSTR(F_CITY_CODE, 1, 3) = C.AREA_ID;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('333333333');
    UPDATE DMCODE.DMCODE_CITY T
       SET T.DESCRIPTION =
           (SELECT A.F_AREA_NAME
              FROM DIM.DIM_OM_AREA_T A
             WHERE A.F_AREA_LEVEL = 4
               AND '018' || A.F_CITY_CODE = T.CITY_ID)
     WHERE EXISTS (SELECT 1
              FROM DIM.DIM_OM_AREA_T A
             WHERE A.F_AREA_LEVEL = 4
               AND '018' || A.F_CITY_CODE = T.CITY_ID);
    COMMIT;

    ----2012��4��27��21:46:48 ������  ɾ��  ('018189025', '018189027', '018189028', '018189029') ����
    DELETE FROM DMCODE.DMCODE_CITY X
     WHERE AREA_ID = '189'
       AND X.CITY_NO IN
           ('018189025', '018189027', '018189028', '018189029');
    COMMIT;

    DELETE FROM ALLDMCODE.DMCODE_CITY;
    COMMIT;

    INSERT INTO ALLDMCODE.DMCODE_CITY
      SELECT CITY_ID,
             AREA_ID,
             DESCRIPTION,
             AREA_DESCRIPTION,
             COMPANYNO,
             CITY_LEVEL,
             IDX_NO,
             CITY_NO,
             AREA_NO,
             DESCRIPTION,
             AREA_DESCRIPTION,
             'ȫ��'
        FROM DMCODE.DMCODE_CITY A;
    COMMIT;

    --=========================================== 20151013 ��� ===========================================
    DELETE FROM NEW_ALLDMCODE.DMCODE_CITY T WHERE T.CITY_LEVEL = '2';
    COMMIT;

    INSERT INTO NEW_ALLDMCODE.DMCODE_CITY
      SELECT CITY_ID,
             ALLDM.FUNC_GET_XIONGAN_AREA_NO(AREA_ID, CITY_ID) AREA_ID,
             DESCRIPTION,
             ALLDM.FUNC_GET_XIONGAN_AREA_DESC(AREA_DESCRIPTION, CITY_ID) AREA_DESCRIPTION,
             COMPANYNO,
             CITY_LEVEL,
             IDX_NO,
             CITY_NO,
             ALLDM.FUNC_GET_XIONGAN_AREA_NO(AREA_ID, CITY_ID) AREA_NO,
             CITY_DESC,
             ALLDM.FUNC_GET_XIONGAN_AREA_DESC(AREA_DESCRIPTION, CITY_ID) AREA_DESC,
             COUNTRY
        FROM ALLDMCODE.DMCODE_CITY T
       WHERE T.CITY_LEVEL = '2';
    COMMIT;
    -----------���³а��������ر���
INSERT INTO MOBILE_CBZS.C_DMCODE_CITY
  SELECT A.CITY_ID,
         A.DESCRIPTION,
         A.IDX_NO,
         A.AREA_NO,
         A.AREA_ID,
         A.AREA_DESCRIPTION,
         A.COMPANYNO,
         A.CITY_LEVEL,
         '1'
    FROM (SELECT A.*
            FROM NEW_ALLDMCODE.DMCODE_CITY A
           WHERE EXISTS (SELECT 1
                    FROM MOBILE_CBZS.C_DMCODE_CHENGBAO B
                   WHERE A.CITY_ID = B.CITY_NO)) A,
         MOBILE_CBZS.C_DMCODE_CITY C
   WHERE A.CITY_ID = C.CITY_ID(+)
     AND C.CITY_ID IS NULL
     AND A.CITY_LEVEL = '2';
COMMIT;
UPDATE MOBILE_CBZS.C_DMCODE_CITY T
   SET T.DESCRIPTION =
       (SELECT DESCRIPTION
          FROM NEW_ALLDMCODE.DMCODE_CITY A
         WHERE T.CITY_ID = A.CITY_ID)
 WHERE T.CITY_LEVEL = '2'
   AND EXISTS (SELECT 1
          FROM NEW_ALLDMCODE.DMCODE_CITY A
         WHERE T.CITY_ID = A.CITY_ID);
COMMIT;
    --=========================================== ����===========================================

    INSERT INTO DMCODE.DMCODE_CITY_NO
      SELECT '018' || B.F_CITY_CODE,
             TRIM(B.F_AREA_NAME),
             SUBSTR(F_CITY_CODE, 1, 3)

        FROM (SELECT '018' || T.F_CITY_CODE F_AREA_ID
                FROM DIM.DIM_OM_AREA_T T
               WHERE T.F_AREA_LEVEL = 4
                 AND (T.F_INACTIVE_DATE IS NULL OR
                     T.F_INACTIVE_DATE >=
                     ADD_MONTHS(TO_DATE('20101206', 'YYYYMMDD'), -6))

              MINUS
              SELECT CITY_NO FROM DMCODE.DMCODE_CITY_NO) A,
             DIM.DIM_OM_AREA_T B,
             DMCODE.DMCODE_AREA C
       WHERE A.F_AREA_ID = '018' || B.F_CITY_CODE
         AND SUBSTR(F_CITY_CODE, 1, 3) = C.AREA_ID;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('444444444');
    UPDATE DMCODE.DMCODE_CITY_NO T
       SET T.CITY_NAME =
           (SELECT A.F_AREA_NAME
              FROM DIM.DIM_OM_AREA_T A
             WHERE A.F_AREA_LEVEL = 4
               AND '018' || A.F_CITY_CODE = T.CITY_NO)
     WHERE EXISTS (SELECT 1
              FROM DIM.DIM_OM_AREA_T A
             WHERE A.F_AREA_LEVEL = 4
               AND '018' || A.F_CITY_CODE = T.CITY_NO);
    COMMIT;

    ----2012��4��27��21:46:48 ������  ɾ��  ('018189025', '018189027', '018189028', '018189029') ����
    DELETE FROM DMCODE.DMCODE_CITY_NO X
     WHERE AREA_NO = '189'
       AND X.CITY_NO IN
           ('018189025', '018189027', '018189028', '018189029');
    COMMIT;

    DELETE FROM ALLDSS.CODE_CITY A WHERE A.CITY NOT IN ('000''018');
    COMMIT;

    INSERT INTO ALLDSS.CODE_CITY
      SELECT CITY_ID, DESCRIPTION, IDX_NO, AREA_ID FROM DMCODE.DMCODE_CITY;
    COMMIT;

    ------------------------��������-----------------------
    --ɾ���ڽӿڱ��� û�е�TOWN_NO
    DELETE FROM DMCODE.DMCODE_TOWN T
     WHERE T.TOWN_NO NOT IN
           (SELECT '018' || F_CITY_CODE F_AREA_ID
              FROM DIM.DIM_OM_AREA_T
             WHERE F_AREA_LEVEL = 5
               AND LENGTH(F_CITY_CODE) = 9);
    COMMIT;

    MERGE INTO DMCODE.DMCODE_TOWN A
    USING (SELECT * FROM DIM.DIM_OM_AREA_T WHERE F_AREA_LEVEL = 5) B
    ON (A.TOWN_NO = B.F_TOWN_NO)
    WHEN MATCHED THEN
      UPDATE SET A.CITY_NO = B.F_CITY_NO, A.DESCRIPTION = B.F_AREA_NAME
    WHEN NOT MATCHED THEN
      INSERT
      VALUES
        (B.F_AREA_NO,
         B.F_CITY_NO,
         B.F_TOWN_NO,
         F_AREA_NAME,
         '',
         '',
         3,
         B.F_TOWN_NO);
    COMMIT;

    UPDATE DMCODE.DMCODE_TOWN T
       SET T.AREA_DESCRIPTION =
           (SELECT A.AREA_DESC
              FROM DIM.DIM_AREA_NO A
             WHERE T.AREA_NO = A.AREA_NO);
    COMMIT;

    UPDATE DMCODE.DMCODE_TOWN T
       SET T.CITY_DESCRIPTION =
           (SELECT A.CITY_DESC
              FROM DIM.DIM_CITY_NO A
             WHERE T.CITY_NO = A.CITY_NO)
     WHERE EXISTS
     (SELECT 1 FROM DIM.DIM_CITY_NO A WHERE T.CITY_NO = A.CITY_NO);
    COMMIT;

    /*INSERT INTO DMCODE.DMCODE_TOWN
      SELECT SUBSTR(F_CITY_CODE, 1, 3),
             B.F_CITY_NO,
             '018' || F_CITY_CODE,
             MAX(TRIM(B.F_AREA_NAME)),
             MAX(C.DESCRIPTION),
             MAX(C.AREA_DESCRIPTION),
             3,
             '018' || F_CITY_CODE
        FROM (SELECT '018' || F_CITY_CODE F_AREA_ID
                FROM DIM.DIM_OM_AREA_T
               WHERE F_AREA_LEVEL = 5
                      AND LENGTH(F_CITY_CODE) = 9
              MINUS
              SELECT TOWN_NO FROM DMCODE.DMCODE_TOWN) A,
             DIM.DIM_OM_AREA_T B,
             DMCODE.DMCODE_CITY C
       WHERE A.F_AREA_ID = '018' || B.F_CITY_CODE
         AND B.F_CITY_NO = C.CITY_ID
       GROUP BY SUBSTR(F_CITY_CODE, 1, 3),
             B.F_CITY_NO,
             '018' || F_CITY_CODE;
    COMMIT;
    UPDATE DMCODE.DMCODE_TOWN T
       SET T.DESCRIPTION =
           (SELECT MAX(A.F_AREA_NAME)
              FROM DSG_STAGE.OM_AREA_T A
             WHERE F_AREA_LEVEL = 5
               AND '018' || F_CITY_CODE = T.TOWN_NO)
     WHERE EXISTS (SELECT 1
              FROM DSG_STAGE.OM_AREA_T A
             WHERE F_AREA_LEVEL = 5
               AND '018' || F_CITY_CODE = T.TOWN_NO);
    COMMIT;*/

    DBMS_OUTPUT.PUT_LINE('5555555555');
    ------����DIM�û��µ��������--------------
    /*INSERT INTO DIM.DIM_TOWN_NO
      SELECT B.AREA_NO, B.CITY_NO, B.TOWN_NO, B.DESCRIPTION
        FROM (SELECT TOWN_NO
                FROM DMCODE.DMCODE_TOWN
               WHERE CITY_LEVEL = 3
              MINUS
              SELECT TOWN_NO FROM DIM.DIM_TOWN_NO) A,
             DMCODE.DMCODE_TOWN B
       WHERE A.TOWN_NO = B.TOWN_NO;
    COMMIT;*/
    DBMS_OUTPUT.PUT_LINE('66666');
    ---------------����DIM�û��µ����ر���----------------

    INSERT INTO DIM.DIM_CITY_NO
      SELECT B.AREA_ID, B.CITY_ID, B.DESCRIPTION, '1'
        FROM (SELECT CITY_ID
                FROM DMCODE.DMCODE_CITY
               WHERE CITY_LEVEL = '2'
              MINUS
              SELECT CITY_NO FROM DIM.DIM_CITY_NO) A,
             DMCODE.DMCODE_CITY B
       WHERE A.CITY_ID = B.CITY_ID;
    COMMIT;
    UPDATE DIM.DIM_CITY_NO T
       SET T.CITY_DESC =
           (SELECT A.DESCRIPTION
              FROM DMCODE.DMCODE_CITY A
             WHERE LENGTH(CITY_ID) = 9
               AND A.CITY_ID = T.CITY_NO)
     WHERE EXISTS (SELECT 1
              FROM DMCODE.DMCODE_CITY A
             WHERE LENGTH(CITY_ID) = 9
               AND A.CITY_ID = T.CITY_NO);
    COMMIT;
    UPDATE DIM.DIM_CITY_NO T
       SET T.IF_USE = '1'
     WHERE EXISTS (SELECT 1
              FROM DIM.DIM_OM_AREA_T A
             WHERE F_AREA_LEVEL = 4
               AND '018' || A.F_CITY_CODE = T.CITY_NO);
    COMMIT;

    ----2012��4��27��21:46:48 ������  ɾ��  ('018189025', '018189027', '018189028', '018189029') ����
    DELETE FROM DIM.DIM_CITY_NO X
     WHERE AREA_NO = '189'
       AND X.CITY_NO IN
           ('018189025', '018189027', '018189028', '018189029');
    COMMIT;


    DBMS_OUTPUT.PUT_LINE('7777');
    --�������������������� ��� 20111114 ��ռ�����
    MERGE INTO DIM.DIM_CITY_C_TYPE A
    USING (SELECT CITY_ID,
                  AREA_ID,
                  DESCRIPTION,
                  AREA_DESCRIPTION,
                  COMPANYNO,
                  CITY_LEVEL,
                  IDX_NO,
                  CITY_NO,
                  AREA_NO,
                  CITY_DESC,
                  AREA_DESC,
                  COUNTRY
             FROM ALLDMCODE.DMCODE_CITY T
            WHERE T.CITY_LEVEL <> '1') B
    ON (A.CITY_NO = B.CITY_ID)
    WHEN MATCHED THEN
      UPDATE SET A.CITY_DESC = B.DESCRIPTION, A.CITY_TYPE = B.DESCRIPTION
    WHEN NOT MATCHED THEN
      INSERT
      VALUES
        (B.AREA_DESCRIPTION,
         B.AREA_NO,
         '',
         '����',
         '',
         B.DESCRIPTION,
         '',
         B.DESCRIPTION,
         '',
         B.CITY_ID,
         '',
         '');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('888888888');

    /*MERGE INTO DIM.DIM_CITY_TYPE A
    USING (SELECT CITY_ID,
                  AREA_ID,
                  DESCRIPTION,
                  AREA_DESCRIPTION,
                  COMPANYNO,
                  CITY_LEVEL,
                  IDX_NO,
                  CITY_NO,
                  AREA_NO,
                  CITY_DESC,
                  AREA_DESC,
                  COUNTRY
             FROM ALLDMCODE.DMCODE_CITY T
            WHERE T.CITY_LEVEL <> '1') B
    ON (A.CITY_NO = B.CITY_ID)
    WHEN MATCHED THEN
      UPDATE SET A.CITY_DESC = B.DESCRIPTION, A.CITY_TYPE = B.DESCRIPTION
    WHEN NOT MATCHED THEN
      INSERT
      VALUES
        (B.AREA_DESCRIPTION,
         B.AREA_NO,
         '',
         '����',
         '',
         B.DESCRIPTION,
         '',
         B.DESCRIPTION,
         '',
         B.CITY_ID);
    COMMIT;*/

      DELETE FROM DIM.DIM_CITY_TYPE T;
      COMMIT;

      INSERT INTO DIM.DIM_CITY_TYPE
        SELECT AREA_DESC,
               AREA_NO,
               AREA_NO_ID,
               AREA_TYPE,
               AREA_TYPE_ID,
               CITY_TYPE,
               CITY_TYPE_ID,
               CITY_DESC,
               CITY_NO_ID,
               CITY_NO
          FROM DIM.DIM_CITY_C_TYPE;
      COMMIT;

    DBMS_OUTPUT.PUT_LINE('9999999999');
    ---��û�е�������������Ĭ�������Լ��������������е���������
    /*INSERT INTO DIM.DIM_TOWN_NO
      SELECT A.AREA_ID, A.CITY_ID, A.CITY_ID || '999','δ����'
        FROM (SELECT '018' || A.F_CITY_CODE  CITY_ID ,SUBSTR(F_CITY_CODE,1,3) AREA_ID,
             A.F_AREA_NAME
              FROM DSG_STAGE.OM_AREA_T A
             WHERE F_AREA_LEVEL = 4)  A
       WHERE A.CITY_ID NOT IN (SELECT CITY_NO FROM DIM.DIM_TOWN_NO WHERE SUBSTR(TOWN_NO,10,3) = '999')
         AND LENGTH(A.CITY_ID) = 9;
    COMMIT;
    UPDATE DIM.DIM_TOWN_NO T
       SET T.TOWN_DESC =
           (SELECT MAX(A.F_AREA_NAME)
              FROM DSG_STAGE.OM_AREA_T A
             WHERE F_AREA_LEVEL = 5
               AND '018' || F_CITY_CODE = T.TOWN_NO)
     WHERE EXISTS (SELECT 1
              FROM DSG_STAGE.OM_AREA_T A
             WHERE F_AREA_LEVEL = 5
               AND '018' || F_CITY_CODE = T.TOWN_NO);
    COMMIT;*/

    DBMS_OUTPUT.PUT_LINE('10110101');
    /*INSERT INTO DMCODE.DMCODE_TOWN
      SELECT A.AREA_ID,
             A.CITY_ID,
             A.CITY_ID || '999',
             'δ����',
             A.DESCRIPTION,
             A.AREA_DESCRIPTION,
             '3',
             A.CITY_ID || '999'
        FROM DMCODE.DMCODE_CITY A
       WHERE A.CITY_ID NOT IN (SELECT CITY_NO FROM DMCODE.DMCODE_TOWN  WHERE SUBSTR(TOWN_NO,10,3) = '999')
         AND LENGTH(A.CITY_ID) = 9;
    COMMIT;*/

    --20130910 ��δ֪����������3λ�ĳɣ�999
    /*INSERT INTO DMCODE.DMCODE_TOWN
      SELECT A.AREA_ID,
             A.CITY_ID,
             A.CITY_ID || '999',
             'δ����',
             A.DESCRIPTION,
             A.AREA_DESCRIPTION,
             '3',
             A.CITY_ID || '999'
        FROM DMCODE.DMCODE_CITY A
       WHERE A.CITY_ID NOT IN (SELECT CITY_NO FROM DMCODE.DMCODE_TOWN  WHERE SUBSTR(TOWN_NO,10,3) = '999')
         AND LENGTH(A.CITY_ID) = 9;
    COMMIT;*/

    OPEN V_TOWN_DMCODE;
    LOOP
      FETCH V_TOWN_DMCODE
        INTO V_TOWN_DMCODE1;
      EXIT WHEN V_TOWN_DMCODE%NOTFOUND;
      UPDATE DMCODE.DMCODE_TOWN A
         SET A.CITY_DESCRIPTION =
             (SELECT MAX(B.DESCRIPTION)
                FROM DMCODE.DMCODE_CITY B
               WHERE B.CITY_ID IN
                     (SELECT C.CITY_NO
                        FROM DMCODE.DMCODE_TOWN C
                       WHERE C.TOWN_NO = V_TOWN_DMCODE1.TOWN_NO))
       WHERE A.TOWN_NO = V_TOWN_DMCODE1.TOWN_NO;
      COMMIT;
    END LOOP;
    CLOSE V_TOWN_DMCODE;

    DBMS_OUTPUT.PUT_LINE('20202012');
    DELETE FROM ALLDSS.CODE_TOWN A
     WHERE A.TOWN NOT IN ('018720',
                          '018189',
                          '018188',
                          '018187',
                          '018186',
                          '018185',
                          '018184',
                          '018183',
                          '018182',
                          '018181',
                          '018180');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('56676767');
    INSERT INTO ALLDSS.CODE_TOWN
      SELECT TOWN_NO, CITY_NO, DESCRIPTION, IDX_NO
        FROM DMCODE.DMCODE_TOWN B
       WHERE TOWN_NO NOT IN ('018720',
                             '018189',
                             '018188',
                             '018187',
                             '018186',
                             '018185',
                             '018184',
                             '018183',
                             '018182',
                             '018181',
                             '018180');
    COMMIT;
    DELETE FROM DMCODE.DMCODE_DINNER_BAK;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('31313131');
    INSERT INTO DMCODE.DMCODE_DINNER_BAK
      SELECT * FROM DMCODE.DMCODE_DINNER;
    COMMIT;
    DELETE FROM DMCODE.DMCODE_DINNER
     WHERE DINNER_ID NOT IN ('180AA',
                             '181AA',
                             '182AA',
                             '183AA',
                             '184AA',
                             '185AA',
                             '186AA',
                             '187AA',
                             '188AA',
                             '720AA',
                             '189AA',
                             '999999');
    COMMIT;

    --����ALLDMCODE �û��µ����
    DELETE FROM ALLDMCODE.DMCODE_TOWN A;
    COMMIT;
    INSERT INTO ALLDMCODE.DMCODE_TOWN
      SELECT AREA_NO,
             CITY_NO,
             TOWN_NO,
             DESCRIPTION,
             CITY_DESCRIPTION,
             AREA_DESCRIPTION,
             CITY_LEVEL,
             IDX_NO
        FROM DMCODE.DMCODE_TOWN B;
    COMMIT;

     --����NEW_ALLDMCODE �û��µ����
    DELETE FROM NEW_ALLDMCODE.DMCODE_TOWN A;
    COMMIT;
    INSERT INTO ALLDMCODE.DMCODE_TOWN
      SELECT AREA_NO,
             CITY_NO,
             TOWN_NO,
             DESCRIPTION,
             CITY_DESCRIPTION,
             AREA_DESCRIPTION,
             CITY_LEVEL,
             IDX_NO
        FROM DMCODE.DMCODE_TOWN B;
    COMMIT;




    --����DIM �û��µ����
    DELETE FROM DIM.DIM_TOWN_NO;
    COMMIT;
    INSERT INTO DIM.DIM_TOWN_NO
      SELECT AREA_NO, T.CITY_NO, T.TOWN_NO, T.DESCRIPTION
        FROM DMCODE.DMCODE_TOWN T;
    COMMIT;

    --����֧�� �������
    /*MERGE INTO DIM.DIM_TOWN_ZHIJU A
    USING (SELECT FUNC_GET_NEW_AREA_NO(AREA_NO, CITY_NO) AREA_NO,
                  CITY_NO,
                  TOWN_NO,
                  DESCRIPTION TOWN_DESC,
                  CITY_DESCRIPTION,
                  AREA_DESCRIPTION,
                  CITY_LEVEL,
                  IDX_NO

             FROM DMCODE.DMCODE_TOWN) B
    ON (A.TOWN_NO = B.TOWN_NO)
    WHEN MATCHED THEN
      UPDATE
         SET A.TOWN_DESC = B.TOWN_DESC,
             A.AREA_NO   = B.AREA_NO,
             A.CITY_NO   = B.CITY_NO,
             A.IDX_NO    = B.IDX_NO
    WHEN NOT MATCHED THEN
      INSERT
      VALUES
        (B.AREA_NO,
         B.CITY_NO,
         B.TOWN_NO,
         B.TOWN_DESC,
         '',
         '',
         '',
         '',
         0,
         B.IDX_NO);
    COMMIT;*/

    --����֧�� �������
    DELETE FROM MID_DIM_TOWN_ZHIJU;
    COMMIT;
    INSERT INTO MID_DIM_TOWN_ZHIJU
      SELECT T.AREA_NO,
             T.CITY_NO,
             T.TOWN_NO,
             T.TOWN_DESC,
             T.ZHIJU_ID,
             NVL(T2.ZHIJU_DESC, T.ZHIJU_DESC),
             T.UPDATE_USER,
             T.UPDATE_DATE,
             T.IS_UPDATE,
             T.IDX_NO
        FROM DIM.DIM_TOWN_ZHIJU T, DIM.DIM_ZHIJU_NAME T2
       WHERE T.ZHIJU_ID = T2.ZHIJU_ID(+);
    COMMIT;

    DELETE FROM DIM.DIM_TOWN_ZHIJU;
    COMMIT;
    INSERT INTO DIM.DIM_TOWN_ZHIJU
      SELECT FUNC_GET_NEW_AREA_NO(T.AREA_NO, T.CITY_NO) AREA_NO,
             T.CITY_NO,
             T.TOWN_NO,
             T.DESCRIPTION TOWN_DESC,
             T2.ZHIJU_ID,
             T2.ZHIJU_DESC,
             T2.UPDATE_USER,
             T2.UPDATE_DATE,
             T2.IS_UPDATE,
             T.IDX_NO

        FROM DMCODE.DMCODE_TOWN T, MID_DIM_TOWN_ZHIJU T2
       WHERE T.TOWN_NO = T2.TOWN_NO(+);
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('41414141');
    INSERT INTO DMCODE.DMCODE_DINNER
      SELECT USER_DINNER,
             SUB_BRAND,
             USER_DINNER_DESC,
             TO_CHAR(CREATE_DATE, 'YYYYMMDD'),
             TO_CHAR(EXPIRE_DATE, 'YYYYMMDD'),
             BAOYUE_TYPE,
             '',
             AREA_NO,
             TELE_TYPE,
             DINNER_TYPE
        FROM DIM.DIM_USER_DINNER T1
       WHERE NOT EXISTS (SELECT 1
                FROM DMCODE.DMCODE_DINNER T2
               WHERE T1.USER_DINNER = T2.DINNER_ID);
    COMMIT;

    -----------�����ײ��ʷ�----------------------------

    DELETE FROM ALLDMCODE.DMCODE_DINNER;
    COMMIT;
    INSERT INTO ALLDMCODE.DMCODE_DINNER
      SELECT * FROM DMCODE.DMCODE_DINNER;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('DFDFDFD');
    -----����Ա����Ϣ---------
    DELETE FROM DIM_OM_EMPLOYEE_BAK;
    COMMIT;
    INSERT INTO DIM_OM_EMPLOYEE_BAK
      SELECT * FROM DIM.DIM_OM_EMPLOYEE;
    COMMIT;

    DELETE FROM DIM.DIM_OM_EMPLOYEE;
    COMMIT;
    INSERT INTO DIM.DIM_OM_EMPLOYEE
      SELECT F_EMPLOYEE_ID,
             F_BUS_DUTY_ID,
             F_EMPLOYEE_NAME,
             F_DUTY_ID,
             F_AREA_ID,
             F_ORGAN_ID,
             F_PARENT_EMPLOYEE_ID,
             F_WORK_NO,
             F_INACTIVE_DATE,
             F_INACTIVE_PWD_DATE,
             F_EMPLOYEE_TYPE,
             F_EDUCATE_LEVEL,
             F_WORK_ADDRESS,
             F_WORK_TELEPHONE,
             F_EMAIL,
             F_HONE_TELEPHONE,
             F_MOBILE,
             F_FAX,
             F_HOME_ADDRESS,
             F_BIRTHDAY,
             F_GENDER,
             F_INCOME,
             F_MARRIAGE_STATUS,
             F_HIRED_DATE,
             F_CONTRACT_DATE,
             F_RESIGNED_DATE,
             F_UPDATE_DATE,
             F_LOGIN_IP,
             F_MAC,
             F_PWD_UPDATE,
             F_OWNER,
             F_ADMIN_TYPE,
             F_CITY_CODE,
             F_PERSON_LEVEL,
             F_STATUS,
             F_INNER_EMPLOYEE,
             F_DEALER_ID,
             F_LOGIN_IP2,
             F_MAC2,
             F_EMAIL2,
             F_ORDER,
             F_OPER_LEVEL,
             PARTY_ID
        FROM
        (SELECT T.*,ROW_NUMBER()OVER(PARTITION BY F_EMPLOYEE_ID
        ORDER BY F_CREATE_DATE DESC )RN
        FROM   DSG_STAGE.OM_EMPLOYEE_T T )
        WHERE RN =1 ;
    COMMIT;
    SELECT COUNT(1) INTO V_OMM_NUM FROM DIM.DIM_OM_EMPLOYEE;
    COMMIT;
    IF V_OMM_NUM < 40000 THEN
      DELETE FROM DIM.DIM_OM_EMPLOYEE;
      COMMIT;
      INSERT INTO DIM.DIM_OM_EMPLOYEE
        SELECT * FROM DIM_OM_EMPLOYEE_BAK;
      COMMIT;
    END IF;
    ------------------------------------------�����������----------------------------
    --����������� 20100823 ��ռ�� ����
    IF V_LAST30_DAY <>TO_CHAR(LAST_DAY(TO_DATE(V_LAST30_M, 'YYYYMM')),'YYYYMMDD') THEN
      DELETE FROM DIM.DIM_CHANNEL_NO_DAY_BAK T
     WHERE T.DAY_ID = V_LAST30_DAY;
    COMMIT;
    END IF;

    DELETE FROM DIM.DIM_CHANNEL_NO_DAY_BAK T
     WHERE T.DAY_ID = TO_CHAR(TO_DATE(V_DATE, 'YYYYMMDD') - 1, 'YYYYMMDD');
    COMMIT;
    INSERT INTO DIM.DIM_CHANNEL_NO_DAY_BAK
      SELECT CHANNEL_NO,
             CHANNEL_NO_DESC,
             CITY_NO,
             AREA_NO,
             CHANNEL_KIND,
             CHANNEL_TYPE,
             SELL_CENTER,
             CONTRACT_BEGIN,
             CONTRACT_END,
             DEALER_PARENT,
             INSERT_DATE,
             CHANNEL_SCOPE,
             CHANNEL_LEVEL,
             VALID_STATUS,
             TO_CHAR(TO_DATE(V_DATE, 'YYYYMMDD') - 1, 'YYYYMMDD'),
             CHANGE_DATE,
             T.PARTY_ID,
             T.TOWN_CODE
        FROM DIM.DIM_CHANNEL_NO T;
    COMMIT;

    INSERT INTO DIM.DIM_CHANNEL_NO
      SELECT T1.DEALER_ID,
             DEALER_NAME,
             '018' || SUBSTR(C.F_CITY_CODE, 1, 6),
             T1.CITY_CODE,
             D.DEALER_TYPE,

             --20140715 �޸�
             T1.STRUCT_ID, --DECODE(D.DEALER_KIND, 15, 106, D.DEALER_KIND),

             BELONGS_PART,
             TO_DATE(T1.CREATE_DATE, 'YYYY-MM-DD HH24:MI:SS'),
             '',
             DEALER_PARENT,
             SYSDATE,
             '',
             DEALER_LEVEL,
             T1.VALID_STATUS,
             '',
             T1.PARTY_ID,
             E.TOWN_CODE --20151130 ��ռ�ɸ���������Ҫ������������Ϣ
        FROM(SELECT T1.*,ROW_NUMBER()OVER(PARTITION BY DEALER_ID ORDER BY  T1.CREATE_DATE DESC)RN
        FROM
         DSG_STAGE.BD_DEALER_T T1)T1,
             (SELECT DISTINCT DEALER_ID CHANNEL_NO
                FROM DSG_STAGE.BD_DEALER_T T1
              MINUS
              SELECT CHANNEL_NO FROM DIM.DIM_CHANNEL_NO T2) T2,
             DIM.DIM_OM_AREA_T C,
            (SELECT D.* ,ROW_NUMBER()OVER(PARTITION BY STRUCT_ID ORDER BY  PARENT_STRUCT_ID DESC)RN
            FROM  DSG_STAGE.BD_DEALER_STRUCTURE_T D ) D,
           (SELECT E.*,ROW_NUMBER()OVER(PARTITION BY DEALER_ID ORDER BY  CREATE_DATE DESC)RN
        FROM   DSG_STAGE.CHANNEL E)E
       WHERE T1.DEALER_ID = T2.CHANNEL_NO
         AND T1.REGION_CODE = C.F_AREA_ID(+)
         AND T1.STRUCT_ID = D.STRUCT_ID(+)
         AND D.RN(+)=1
         AND T1.DEALER_ID = E.DEALER_ID(+)
         AND E.RN(+) =1
         AND T1.RN =1 ;
    COMMIT;

    --��־ǿ 090326�����������
    EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_DIM_CHANNEL_NO';
    INSERT INTO MID_DIM_CHANNEL_NO NOLOGGING
      SELECT CHANNEL_NO,
             NVL(B.DEALER_NAME, A.CHANNEL_NO_DESC) CHANNEL_NO_DESC,
             NVL('018' || SUBSTR(C.F_CITY_CODE, 1, 6), A.CITY_NO),
             NVL(B.CITY_CODE, A.AREA_NO),
             NVL(D.DEALER_TYPE, A.CHANNEL_KIND),
             /*NVL(DECODE(TO_CHAR(D.DEALER_KIND),
                        15,
                        106,
                        TO_CHAR(D.DEALER_KIND)),
                 A.CHANNEL_TYPE),*/
             B.STRUCT_ID, --20140715 �޸�

             NVL(B.BELONGS_PART, A.SELL_CENTER),
             NVL(A.CONTRACT_BEGIN,
                 TO_DATE(B.CREATE_DATE, 'YYYY-MM-DD HH24:MI:SS')),
             '',
             NVL(B.DEALER_PARENT, A.DEALER_PARENT),
             INSERT_DATE,
             CHANNEL_SCOPE,
             NVL(B.DEALER_LEVEL, A.CHANNEL_LEVEL),
             NVL(B.VALID_STATUS, A.VALID_STATUS),
             '',
             NVL(B.PARTY_ID, A.PARTY_ID),
             NVL(E.TOWN_CODE, A.TOWN_CODE)  --20151130 ��ռ�ɸ���������Ҫ������������Ϣ
        FROM DIM.DIM_CHANNEL_NO A,
             (SELECT T1.*,ROW_NUMBER()OVER(PARTITION BY DEALER_ID ORDER BY  T1.CREATE_DATE DESC)RN
        FROM
         DSG_STAGE.BD_DEALER_T T1) B,
             DIM.DIM_OM_AREA_T C,
             (SELECT STRUCT_ID,
                     STRUCT_NAME,
                     PARENT_STRUCT_ID,
                     LAYER,
                     LEAF_NODE,
                     DEALER_TYPE,
                     DECODE(STRUCT_ID,
                            '020105AA',
                            '310',
                            '020201AA',
                            '300',
                            DEALER_KIND) DEALER_KIND,
                     CHANNEL_TYPE_CD,
                     CHANNEL_SUBTYPE_CD,
                     PRESERVE01,
                     PRESERVE02
                FROM (SELECT D.* ,ROW_NUMBER()OVER(PARTITION BY STRUCT_ID ORDER BY  PARENT_STRUCT_ID DESC)RN
            FROM  DSG_STAGE.BD_DEALER_STRUCTURE_T D )
            WHERE RN =1) D,
              (SELECT E.*,ROW_NUMBER()OVER(PARTITION BY DEALER_ID ORDER BY  CREATE_DATE DESC)RN
        FROM   DSG_STAGE.CHANNEL E) E
       WHERE A.CHANNEL_NO = B.DEALER_ID(+)
         AND B.RN(+) =1
         AND B.REGION_CODE = C.F_AREA_ID(+)
         AND B.STRUCT_ID = D.STRUCT_ID(+)
         AND A.CHANNEL_NO = E.DEALER_ID(+)
         AND E.RN(+) =1 ;
    COMMIT;

    DELETE FROM DIM.DIM_CHANNEL_NO;
    COMMIT;
    INSERT INTO DIM.DIM_CHANNEL_NO NOLOGGING
      SELECT CHANNEL_NO,
             CHANNEL_NO_DESC,
             CITY_NO,
             AREA_NO,
             CHANNEL_KIND,
             CHANNEL_TYPE,
             SELL_CENTER,
             CONTRACT_BEGIN,
             CONTRACT_END,
             DEALER_PARENT,
             INSERT_DATE,
             CHANNEL_SCOPE,
             CHANNEL_LEVEL,
             VALID_STATUS,
             CHANGE_DATE,
             PARTY_ID,
             TOWN_CODE
        FROM MID_DIM_CHANNEL_NO;
    COMMIT;
    /*  UPDATE DIM.DIM_CHANNEL_NO A
       SET A.CHANNEL_SCOPE = (SELECT TO_CHAR(DEALER_SCOPE)
                               FROM STAGE.BD_DEALER_T T1
                              WHERE T1.DEALER_ID = A.CHANNEL_NO)
     WHERE EXISTS (SELECT 1 DEALER_ID
              FROM STAGE.BD_DEALER_T T
             WHERE T.DEALER_ID = A.CHANNEL_NO);
    COMMIT;*/

    INSERT INTO DMCODE.DMCODE_CHANNEL_NO
      SELECT T1.CHANNEL_NO, T1.CHANNEL_NO_DESC, T1.CHANNEL_TYPE
        FROM DIM.DIM_CHANNEL_NO T1,
             (SELECT CHANNEL_NO
                FROM DIM.DIM_CHANNEL_NO T1
              MINUS
              SELECT CHANNEL_NO FROM DMCODE.DMCODE_CHANNEL_NO T2) T2
       WHERE T1.CHANNEL_NO = T2.CHANNEL_NO;
    COMMIT;
    EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_DMCODE_CHANNEL_NO';
    INSERT INTO MID_DMCODE_CHANNEL_NO NOLOGGING
      SELECT A.CHANNEL_NO,
             NVL(A.CHANNEL_NO_DESC, B.CHANNEL_NO_DESC) CHANNEL_NO_DESC,
             NVL(A.CHANNEL_TYPE, B.CHANNEL_TYPE) CHANNEL_TYPE
        FROM DMCODE.DMCODE_CHANNEL_NO A, DIM.DIM_CHANNEL_NO B
       WHERE A.CHANNEL_NO = B.CHANNEL_NO(+);
    COMMIT;
    DELETE FROM DMCODE.DMCODE_CHANNEL_NO;
    COMMIT;

    INSERT INTO DMCODE.DMCODE_CHANNEL_NO
      SELECT CHANNEL_NO, CHANNEL_NO_DESC, CHANNEL_TYPE
        FROM MID_DMCODE_CHANNEL_NO;
    COMMIT;
    -----------
    INSERT INTO DMCODE.DMCODE_CHANNEL
      SELECT T1.CHANNEL_NO,
             NVL(T3.DMCODE_CHANNEL_TYPE, '010'),
             T1.CHANNEL_NO_DESC,
             T1.AREA_NO
        FROM DIM.DIM_CHANNEL_NO T1,
             (SELECT CHANNEL_NO
                FROM DIM.DIM_CHANNEL_NO T1
              MINUS
              SELECT CHANNEL_ID CHANNEL_NO FROM DMCODE.DMCODE_CHANNEL T2) T2,
             DIM.DIM_CHANNEL_TYPE T3
       WHERE T1.CHANNEL_NO = T2.CHANNEL_NO
         AND T1.CHANNEL_TYPE = T3.CHANNEL_TYPE;
    COMMIT;
    EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_DMCODE_CHANNEL';
    INSERT INTO MID_DMCODE_CHANNEL
      SELECT A.CHANNEL_ID,
             NVL(A.CHANNEL_TYPE, C.CHANNEL_TYPE) CHANNEL_TYPE,
             NVL(A.CHANNEL_DESC, B.CHANNEL_NO_DESC) CHANNEL_DESC,
             A.AREA_NO
        FROM DMCODE.DMCODE_CHANNEL A,
             DIM.DIM_CHANNEL_NO    B,
             DIM.DIM_CHANNEL_TYPE  C
       WHERE A.CHANNEL_ID = B.CHANNEL_NO(+)
         AND A.CHANNEL_TYPE = C.CHANNEL_TYPE(+);
    COMMIT;
    DELETE FROM DMCODE.DMCODE_CHANNEL;
    COMMIT;
    INSERT INTO DMCODE.DMCODE_CHANNEL
      SELECT CHANNEL_ID, CHANNEL_TYPE, CHANNEL_DESC, AREA_NO
        FROM MID_DMCODE_CHANNEL;
    COMMIT;
    DELETE FROM ALLDMCODE.DMCODE_CHANNEL;
    COMMIT;
    INSERT INTO ALLDMCODE.DMCODE_CHANNEL
      SELECT CHANNEL_ID, CHANNEL_TYPE, CHANNEL_DESC, AREA_NO, '', ''
        FROM DMCODE.DMCODE_CHANNEL;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('ABDERERE');
    /*  --�����û�����----
    INSERT INTO DIM.DIM_USER_DINNER_TELE C
      SELECT B.F_USER_TYPE_ID,
             A.TELE_TYPE,
             B.F_INNET_METHOD,
             B.F_USER_TYPE_NAME,
             B.F_DEFAULT_PRICE,
             B.F_MIN_PRICE,
             B.F_MAX_PRICE,
             B.F_REMARK,
             B.F_SERVICE_KIND,
             CASE
               WHEN B.F_USER_TYPE_NAME LIKE '%����%' THEN
                '101'
               WHEN B.F_USER_TYPE_NAME LIKE '%����%' THEN
                '102'
               WHEN B.F_USER_TYPE_NAME LIKE '%����%' THEN
                '106'
               WHEN B.F_USER_TYPE_NAME LIKE '%����%' THEN
                '106'
               ELSE
                '101'
             END,
             '',
             ''
        FROM (SELECT B.*,
                     ROW_NUMBER() OVER(PARTITION BY F_USER_TYPE_ID ORDER BY B.F_INNET_METHOD) RN
                FROM STAGE.PM_USER_TYPE_DICT_T B) B,
             DIM.DIM_TELE_TYPE A
       WHERE B.F_SERVICE_KIND = A.NEUS_TELE_TYPE
         AND B.RN = 1
         AND NOT EXISTS
       (SELECT 1
                FROM DIM.DIM_USER_DINNER_TELE C
               WHERE C.USER_TYPE_ID = B.F_USER_TYPE_ID);
    COMMIT;
    UPDATE DIM.DIM_USER_DINNER_TELE A
       SET A.USER_TYPE_NAME =
           (SELECT TRIM(B.F_USER_TYPE_NAME)
              FROM (SELECT B.*,
                           ROW_NUMBER() OVER(PARTITION BY F_USER_TYPE_ID ORDER BY B.F_INNET_METHOD) RN
                      FROM STAGE.PM_USER_TYPE_DICT_T B) B
             WHERE A.USER_TYPE_ID = B.F_USER_TYPE_ID
               AND B.RN = 1)
     WHERE EXISTS (SELECT 1
              FROM STAGE.PM_USER_TYPE_DICT_T C
             WHERE A.USER_TYPE_ID = C.F_USER_TYPE_ID);
    COMMIT;*/
    /*  UPDATE DIM.DIM_USER_DINNER_TELE A
    SET A.PROD_OFFER_FIRST_LVL = (SELECT DISTINCT B.PROD_OFFER_FIRST_LVL
     DIM.DIM_USER_DINNER_TELE B
     WHERE B.TELE_TYPE = A.TELE_TYPE
       AND B.INNET_METHOD = A.INNET_METHOD
       AND B.USER_TYPE_NAME LIKE '%'||A.USER_TYPE_NAME||'%')
       WHERE A.PROD_OFFER_FIRST_LVL IS NULL ;
       COMMIT;*/

    /*MERGE INTO DIM.DIM_USER_DINNER_PROCUCT A
    USING STAGE.PM_PRODUCT_T B
    ON (A.F_PROD_ID = B.F_PROD_ID)
    WHEN MATCHED THEN
      UPDATE
         SET A.F_PROCINST_ID            = B.F_PROCINST_ID,
             A.F_SERVICE_KIND           = B.F_SERVICE_KIND,
             A.F_LIFECYCLE_STATUS       = B.F_LIFECYCLE_STATUS,
             A.F_STATUS_CHG_TIME        = B.F_STATUS_CHG_TIME,
             A.F_PROD_VERSION           = B.F_PROD_VERSION,
             A.F_PROD_BRAND             = B.F_PROD_BRAND,
             A.F_PROD_CODE              = B.F_PROD_CODE,
             A.F_PROD_NAME              = B.F_PROD_NAME,
             A.F_PROD_DESC              = B.F_PROD_DESC,
             A.F_PROD_TYPE              = B.F_PROD_TYPE,
             A.F_PROD_GROUP_ID          = B.F_PROD_GROUP_ID,
             A.F_PROD_LEVEL             = B.F_PROD_LEVEL,
             A.F_OFFER_TYPE             = B.F_OFFER_TYPE,
             A.F_AREA_ID                = B.F_AREA_ID,
             A.F_CREATE_DATE            = B.F_CREATE_DATE,
             A.F_ACTIVE_DATE            = B.F_ACTIVE_DATE,
             A.F_INACTIVE_DATE          = B.F_INACTIVE_DATE,
             A.F_DELAY_UNIT             = B.F_DELAY_UNIT,
             A.F_DELAY_TIME             = B.F_DELAY_TIME,
             A.F_UPGRADE_TYPE           = B.F_UPGRADE_TYPE,
             A.F_PERMIT_INSTANTLY       = B.F_PERMIT_INSTANTLY,
             A.F_TEST_LIMIT             = B.F_TEST_LIMIT,
             A.F_TESTED_COUNTER         = B.F_TESTED_COUNTER,
             A.F_IF_CHANGABLE           = B.F_IF_CHANGABLE,
             A.F_EFFECT_TYPE            = B.F_EFFECT_TYPE,
             A.F_MIN_EFFECT_MONTHS      = B.F_MIN_EFFECT_MONTHS,
             A.F_MAX_EFFECT_MONTHS      = B.F_MAX_EFFECT_MONTHS,
             A.F_DEFAULT_EFFECT_MONTHS  = B.F_DEFAULT_EFFECT_MONTHS,
             A.F_SELECT_DEFAULT         = B.F_SELECT_DEFAULT,
             A.F_INTENDING_RELEASE_DATE = B.F_INTENDING_RELEASE_DATE,
             A.F_REAL_RELEASE_DATE      = B.F_REAL_RELEASE_DATE,
             A.F_CLOSE_DATE             = B.F_CLOSE_DATE,
             A.F_PLAN_ID                = B.F_PLAN_ID,
             A.F_VERSION_UPGRADE_REASON = B.F_VERSION_UPGRADE_REASON,
             A.F_SPREAD_RANGE           = B.F_SPREAD_RANGE,
             A.F_REL_PROCINST_ID        = B.F_REL_PROCINST_ID,
             A.F_IF_GRP                 = B.F_IF_GRP,
             A.F_IF_REORDER             = B.F_IF_REORDER,
             A.F_LIFECYCLE_ID           = B.F_LIFECYCLE_ID,
             A.F_IF_COMB_PROD           = B.F_IF_COMB_PROD,
             A.F_IF_3G                  = B.F_IF_3G
    WHEN NOT MATCHED THEN
      INSERT
      VALUES
        (B.F_PROCINST_ID,
         B.F_PROD_ID,
         B.F_SERVICE_KIND,
         B.F_LIFECYCLE_STATUS,
         B.F_STATUS_CHG_TIME,
         B.F_PROD_VERSION,
         B.F_PROD_BRAND,
         B.F_PROD_CODE,
         B.F_PROD_NAME,
         B.F_PROD_DESC,
         B.F_PROD_TYPE,
         B.F_PROD_GROUP_ID,
         B.F_PROD_LEVEL,
         B.F_OFFER_TYPE,
         B.F_AREA_ID,
         B.F_CREATE_DATE,
         B.F_ACTIVE_DATE,
         B.F_INACTIVE_DATE,
         B.F_DELAY_UNIT,
         B.F_DELAY_TIME,
         B.F_UPGRADE_TYPE,
         B.F_PERMIT_INSTANTLY,
         B.F_TEST_LIMIT,
         B.F_TESTED_COUNTER,
         B.F_IF_CHANGABLE,
         B.F_EFFECT_TYPE,
         B.F_MIN_EFFECT_MONTHS,
         B.F_MAX_EFFECT_MONTHS,
         B.F_DEFAULT_EFFECT_MONTHS,
         B.F_SELECT_DEFAULT,
         B.F_INTENDING_RELEASE_DATE,
         B.F_REAL_RELEASE_DATE,
         B.F_CLOSE_DATE,
         B.F_PLAN_ID,
         B.F_VERSION_UPGRADE_REASON,
         B.F_SPREAD_RANGE,
         B.F_REL_PROCINST_ID,
         B.F_IF_GRP,
         B.F_IF_REORDER,
         B.F_LIFECYCLE_ID,
         B.F_IF_COMB_PROD,
         B.F_IF_3G);
    COMMIT;

    */

      ----============== �����û�������� ================================================
      DELETE FROM MID_DIM_USER_DINNER_TELE;
      COMMIT;

      INSERT INTO MID_DIM_USER_DINNER_TELE
        SELECT F_USER_TYPE_ID,
               TELE_TYPE,
               F_INNET_METHOD,
               F_SERVICE_KIND,
               F_USER_TYPE_NAME,
               MERGE_PRODUCT_OFFER_ID,
               NAME
          FROM (SELECT A.*,
                       ROW_NUMBER() OVER(PARTITION BY F_USER_TYPE_ID ORDER BY F_INNET_METHOD) RN
                  FROM (SELECT C.F_USER_TYPE_ID,
                               F.TELE_TYPE,
                               C.F_INNET_METHOD,
                               C.F_SERVICE_KIND,
                               C.F_USER_TYPE_NAME,
                               E.MERGE_PRODUCT_OFFER_ID,
                               E.NAME
                          FROM ACCT_DSG.BRPT_SERVICE_OFFER_ID_4_T@HBODS C,
                               ACCT_DSG.BRPT_ITEM_PRODUCT_OFFER_T@HBODS D,
                               ACCT_DSG.BRPT_PRODUCT_OFFER_TM_T@HBODS   E,
                               DIM.DIM_TELE_TYPE                        F
                         WHERE C.OFFER_ID = D.OFFER_ID
                           AND D.MERGE_PRODUCT_OFFER_ID =
                               E.MERGE_PRODUCT_OFFER_ID
                           AND E.DOMAIN = 'PP0'
                           AND C.F_SERVICE_KIND = F.NEUS_TELE_TYPE) A) A
         WHERE RN = 1;
      COMMIT;

      MERGE INTO DIM.DIM_USER_DINNER_TELE A
      USING MID_DIM_USER_DINNER_TELE B
      ON (A.USER_TYPE_ID = B.F_USER_TYPE_ID)
      WHEN MATCHED THEN
        UPDATE
           SET /*A.TELE_TYPE                 = B.TELE_TYPE,
               A.INNET_METHOD              = B.F_INNET_METHOD,
               A.USER_TYPE_NAME            = B.F_USER_TYPE_NAME,
               A.NEU_SERVICE_KIND          = B.F_SERVICE_KIND,*/
               A.PROD_OFFER_FIRST_LVL      = B.MERGE_PRODUCT_OFFER_ID,
               A.PROD_OFFER_FIRST_LVL_DESC = B.NAME
      WHEN NOT MATCHED THEN
        INSERT
        VALUES
          (B.F_USER_TYPE_ID,
           B.TELE_TYPE,
           B.F_INNET_METHOD,
           B.F_USER_TYPE_NAME,
           '',
           '',
           '',
           '',
           B.F_SERVICE_KIND,
           '102',
           B.MERGE_PRODUCT_OFFER_ID,
           B.NAME);
      COMMIT;

      DELETE FROM DIM.BRPT_SERVICE_OFFER_ID_4_T;
      COMMIT;
      INSERT INTO DIM.BRPT_SERVICE_OFFER_ID_4_T
        SELECT F_SERVICE_KIND,
               F_INNET_METHOD,
               F_USER_TYPE_ID,
               F_USER_TYPE_NAME,
               OFFER_ID,
               OFFER_NAME
          FROM
          (SELECT A.*,
                       ROW_NUMBER() OVER(PARTITION BY F_USER_TYPE_ID ORDER BY F_INNET_METHOD) RN
                       FROM  ACCT_DSG.BRPT_SERVICE_OFFER_ID_4_T@HBODS A )
                       WHERE RN =1 ;
      COMMIT;

      DELETE FROM DIM.BRPT_ITEM_PRODUCT_OFFER_T;
      COMMIT;
      INSERT INTO DIM.BRPT_ITEM_PRODUCT_OFFER_T
        SELECT DISTINCT  MERGE_PRODUCT_OFFER_ID, OFFER_ID
          FROM ACCT_DSG.BRPT_ITEM_PRODUCT_OFFER_T@HBODS;
      COMMIT;

      DELETE FROM DIM.BRPT_PRODUCT_OFFER_TM_T;
      COMMIT;
      INSERT INTO DIM.BRPT_PRODUCT_OFFER_TM_T
        SELECT MERGE_PRODUCT_OFFER_ID, MERGE_KIND_ID, DOMAIN, NAME
          FROM
         (SELECT A.*,
                       ROW_NUMBER() OVER(PARTITION BY MERGE_PRODUCT_OFFER_ID ORDER BY MERGE_KIND_ID) RN
                       FROM
                        ACCT_DSG.BRPT_PRODUCT_OFFER_TM_T@HBODS A)WHERE RN =1 ;
      COMMIT;
     --==============================================================


    MERGE INTO DIM.DIM_STANDARD_REGION A
    USING STAGE.BF_STANDARD_REGION_T B
    ON (A.REGION_ID = B.REGION_ID)
    WHEN MATCHED THEN
      UPDATE
         SET A.REGION_LEVEL     = B.REGION_LEVEL,
             A.PARENT_REGION_ID = B.PARENT_REGION_ID,
             A.REGION_CODE      = B.REGION_CODE,
             A.NAME             = B.NAME,
             A.AREA_CODE        = B.AREA_CODE
    WHEN NOT MATCHED THEN
      INSERT
      VALUES
        (B.REGION_ID,
         B.REGION_LEVEL,
         B.PARENT_REGION_ID,
         B.REGION_CODE,
         B.NAME,
         B.AREA_CODE);
    COMMIT;

    MERGE INTO DIM.PRODUCT A
    USING ODS_STAGE.BB_BUS_STR_T@HBODS  B
    ON (A.PRODUCT_ID = B.PRODUCT_ID)
    WHEN MATCHED THEN
      UPDATE
         SET A.PRODUCT_NBR         = B.PRODUCT_NBR,
             A.PRODUCT_NAME        = B.PRODUCT_NAME,
             A.PRODUCT_DESC        = B.PRODUCT_DESC,
             A.PRODUCT_PROVIDER_ID = B.PRODUCT_PROVIDER_ID,
             A.STATUS_CD           = B.STATUS_CD,
             A.PROD_FUNC_TYPE      = B.PROD_FUNC_TYPE,
             A.PROD_FUNC_FLAG      = B.PROD_FUNC_FLAG,
             A.PRODUCT_TYPE_FLAG   = B.PRODUCT_TYPE_FLAG,
             A.CREATE_DATE         = B.CREATE_DATE,
             A.STATUS_DATE         = B.STATUS_DATE,
             A.EFF_DATE            = B.EFF_DATE,
             A.EXP_DATE            = B.EXP_DATE,
             A.SERVICE_KIND        = B.SERVICE_KIND
    WHEN NOT MATCHED THEN
      INSERT
      VALUES
        (B.PRODUCT_ID,
         B.PRODUCT_NBR,
         B.PRODUCT_NAME,
         B.PRODUCT_DESC,
         B.PRODUCT_PROVIDER_ID,
         B.STATUS_CD,
         B.PROD_FUNC_TYPE,
         B.PROD_FUNC_FLAG,
         B.PRODUCT_TYPE_FLAG,
         B.CREATE_DATE,
         B.STATUS_DATE,
         B.EFF_DATE,
         B.EXP_DATE,
         B.SERVICE_KIND);
    COMMIT;

    MERGE INTO DIM.DIM_FEE_KIND_T A
    USING ODS_STAGE.BF_FEE_KIND_T@HBODS  B
    ON (A.FEE_ID = B.FEE_ID)
    WHEN MATCHED THEN
      UPDATE
         SET A.FEE_NAME          = B.FEE_NAME,
             A.USE_STATUS        = B.USE_STATUS,
             A.BILL_KIND         = B.BILL_KIND,
             A.ROAM_TYPE         = B.ROAM_TYPE,
             A.TOLL_TYPE         = B.TOLL_TYPE,
             A.NET_TYPE          = B.NET_TYPE,
             A.CALL_TYPE         = B.CALL_TYPE,
             A.OTHER_FLAG        = B.OTHER_FLAG,
             A.GATHER_KIND       = B.GATHER_KIND,
             A.BILL_ORDER        = B.BILL_ORDER,
             A.ITEM_TYPE_CODE    = B.ITEM_TYPE_CODE,
             A.SOURCE_EVENT_TYPE = B.SOURCE_EVENT_TYPE,
             A.PARENT_FEE_ID     = B.PARENT_FEE_ID
    WHEN NOT MATCHED THEN
      INSERT
      VALUES
        (B.FEE_ID,
         B.FEE_NAME,
         B.USE_STATUS,
         B.BILL_KIND,
         B.ROAM_TYPE,
         B.TOLL_TYPE,
         B.NET_TYPE,
         B.CALL_TYPE,
         B.OTHER_FLAG,
         B.GATHER_KIND,
         B.BILL_ORDER,
         B.ITEM_TYPE_CODE,
         B.SOURCE_EVENT_TYPE,
         B.PARENT_FEE_ID);
    COMMIT;
    /*MERGE INTO DIM.DIM_USER_DINNER_PROCUCT_LEVEL A
    USING STAGE.PM_PRODUCT_LEVEL B
    ON (A.PROD_ID = B.PROD_ID)
    WHEN MATCHED THEN
      UPDATE
         SET A.PROD_DESC   = B.PROD_DESC,
             A.REGION_CODE = B.REGION_CODE,
             A.MONTH_RENT  = B.MONTH_RENT,
             A.FEE_KIND    = B.FEE_KIND
    WHEN NOT MATCHED THEN
      INSERT
      VALUES
        (B.PROD_ID, B.PROD_DESC, B.REGION_CODE, B.MONTH_RENT, B.FEE_KIND);
    COMMIT;*/
    DBMS_OUTPUT.PUT_LINE('999000');
    MERGE INTO DIM.DIM_STANDARD_LOCAL_HEAD A
    USING STAGE.BF_STANDARD_LOCAL_HEAD_T  B
    ON (A.HEAD = B.HEAD AND A.AREA_CODE = B.AREA_CODE)
    WHEN MATCHED THEN
      UPDATE SET A.REGION_ID = B.REGION_ID
    WHEN NOT MATCHED THEN
      INSERT VALUES (B.HEAD, B.REGION_ID, B.AREA_CODE, B.NOTE);
    COMMIT;

    MERGE INTO DIM.DIM_INDB_PHONE_HEAD A
    USING STAGE.BS_INDB_PHONE_HEAD_T B
    ON (A.HEAD = B.HEAD)
    WHEN MATCHED THEN
      UPDATE SET A.CITY_CODE = B.CITY_CODE
    WHEN NOT MATCHED THEN
      INSERT VALUES (B.HEAD, B.CITY_CODE);
    COMMIT;

    --���������������  20121011 ��ռ�� ����
    /*MERGE INTO DIM.DIM_CHANNEL_TYPE A
    USING (SELECT STRUCT_ID,
                  STRUCT_NAME,
                  PARENT_STRUCT_ID,
                  LAYER,
                  LEAF_NODE,
                  DEALER_TYPE,
                  DECODE(STRUCT_ID,
                         '020105AA',
                         '310',
                         '020201AA',
                         '300',
                         DEALER_KIND) DEALER_KIND,
                  CHANNEL_TYPE_CD,
                  CHANNEL_SUBTYPE_CD,
                  PRESERVE01,
                  PRESERVE02

             FROM DSG_STAGE.BD_DEALER_STRUCTURE_T T
            WHERE LAYER NOT IN ('1', '2')) B
    ON (A.CHANNEL_TYPE = B.DEALER_KIND)
    WHEN MATCHED THEN
      UPDATE
         SET A.CHANNEL_TYPE_DESC         = B.STRUCT_NAME,
             A.CHANNEL_TYPE_NEUSOFT      = B.DEALER_KIND,
             A.CHANNEL_TYPE_DESC_NEUSOFT = B.STRUCT_NAME,
             A.CHANNEL_KIND_NEUSOFT      = B.CHANNEL_TYPE_CD,
             A.CHANNEL_KIND_DESC_NEUSOFT = DECODE(B.CHANNEL_TYPE_CD,
                                                  '1000',
                                                  '��Ӫʵ������',
                                                  '1100',
                                                  '���ʵ������',
                                                  '1200',
                                                  '��Ӫֱ������',
                                                  '1300',
                                                  '��Ӫ��������',
                                                  '1400',
                                                  '���ֱ������',
                                                  '1500',
                                                  '����������'),
             A.MARK_CHANNEL_TYPE         = DECODE(B.CHANNEL_TYPE_CD,
                                                  '1000',
                                                  '01',
                                                  '1100',
                                                  '04',
                                                  '1200',
                                                  '02',
                                                  '1300',
                                                  '03',
                                                  '1400',
                                                  '05',
                                                  '1500',
                                                  '06'),
             A.MARK_CHANNEL_TYPE_DESC    = DECODE(B.CHANNEL_TYPE_CD,
                                                  '1000',
                                                  '����ʵ��',
                                                  '1100',
                                                  '���ʵ��',
                                                  '1200',
                                                  '����ֱ��',
                                                  '1300',
                                                  '���е���',
                                                  '1400',
                                                  '���ֱ��',
                                                  '1500',
                                                  '������')
    WHEN NOT MATCHED THEN
      INSERT
      VALUES
        (B.DEALER_KIND,
         B.STRUCT_NAME,
         '',
         '',
         '',
         '',
         DECODE(B.CHANNEL_TYPE_CD,
                '1000',
                '001',
                '1100',
                '002',
                '1200',
                '004',
                '1300',
                '003',
                '1400',
                '002',
                '1500',
                '002'), --��������
         DECODE(B.CHANNEL_TYPE_CD,
                '1000',
                '����Ӫҵ��',
                '1100',
                '�������',
                '1200',
                'ֱ������',
                '1300',
                '��������',
                '1400',
                '�������',
                '1500',
                '�������'), --������������
         '',
         '',
         '',
         '',
         '',
         '',
         DECODE(B.CHANNEL_TYPE_CD,
                '1000',
                '01',
                '1100',
                '04',
                '1200',
                '02',
                '1300',
                '03',
                '1400',
                '05',
                '1500',
                '06'),
         DECODE(B.CHANNEL_TYPE_CD,
                '1000',
                '����ʵ��',
                '1100',
                '���ʵ��',
                '1200',
                '����ֱ��',
                '1300',
                '���е���',
                '1400',
                '���ֱ��',
                '1500',
                '������'),
         B.DEALER_KIND,
         B.STRUCT_NAME,
         B.CHANNEL_TYPE_CD,
         DECODE(B.CHANNEL_TYPE_CD,
                '1000',
                '��Ӫʵ������',
                '1100',
                '���ʵ������',
                '1200',
                '��Ӫֱ������',
                '1300',
                '��Ӫ��������',
                '1400',
                '���ֱ������',
                '1500',
                '����������'));
    COMMIT;*/

    --���������������  20140716 ��ռ�� �޸�
      MERGE INTO DIM.DIM_CHANNEL_TYPE A
      USING (SELECT A.STRUCT_ID,
                    A.STRUCT_NAME,
                    A.PARENT_STRUCT_ID,
                    A.LAYER,
                    A.LEAF_NODE,
                    A.DEALER_TYPE,
                    A.DEALER_KIND,
                    A.CHANNEL_TYPE_CD,
                    A.CHANNEL_SUBTYPE_CD,
                    A.PRESERVE01,
                    A.PRESERVE02,

                    B.STRUCT_ID   STRUCT_ID_SEC,
                    B.STRUCT_NAME STRUCT_NAME_SEC,
                    C.STRUCT_ID   STRUCT_ID_FIR,
                    C.STRUCT_NAME STRUCT_NAME_FIR

               FROM (SELECT *
                       FROM  (SELECT D.* ,ROW_NUMBER()OVER(PARTITION BY STRUCT_ID ORDER BY  PARENT_STRUCT_ID DESC)RN
            FROM  DSG_STAGE.BD_DEALER_STRUCTURE_T D )D
                      WHERE LAYER IN ('3')
                      AND RN =1 ) A,

                    (SELECT *
                       FROM  (SELECT D.* ,ROW_NUMBER()OVER(PARTITION BY STRUCT_ID ORDER BY  PARENT_STRUCT_ID DESC)RN
            FROM  DSG_STAGE.BD_DEALER_STRUCTURE_T D ) T
                      WHERE LAYER IN ('2')
                      AND RN =1 ) B,

                    (SELECT *
                       FROM  (SELECT D.* ,ROW_NUMBER()OVER(PARTITION BY STRUCT_ID ORDER BY  PARENT_STRUCT_ID DESC)RN
            FROM  DSG_STAGE.BD_DEALER_STRUCTURE_T D ) T
                      WHERE LAYER IN ('1')
                      AND RN =1 ) C

              WHERE A.PARENT_STRUCT_ID = B.STRUCT_ID
                AND B.PARENT_STRUCT_ID = C.STRUCT_ID) B
      ON (A.CHANNEL_TYPE = B.STRUCT_ID)
      WHEN MATCHED THEN
        UPDATE
           SET A.CHANNEL_TYPE_DESC     = B.STRUCT_NAME,
               A.CHANNEL_TYPE_SEC      = B.STRUCT_ID_SEC,
               A.CHANNEL_TYPE_DESC_SEC = B.STRUCT_NAME_SEC,
               A.CHANNEL_TYPE_FIR      = B.STRUCT_ID_FIR,
               A.CHANNEL_TYPE_DESC_FIR = STRUCT_NAME_FIR,

               A.CHANNEL_KIND      = DECODE(B.STRUCT_ID_FIR,
                                            '100000',
                                            '004',
                                            '120000',
                                            '003',
                                            DECODE(SUBSTR(B.STRUCT_ID_SEC, 1, 4),
                                                   1101,
                                                   '001',
                                                   '002')), --��������
               A.CHANNEL_KIND_DESC = DECODE(B.STRUCT_ID_FIR,
                                            '100000',
                                            'ֱ������',
                                            '120000',
                                            '��������',
                                            DECODE(SUBSTR(B.STRUCT_ID_SEC, 1, 4),
                                                   1101,
                                                   '����Ӫҵ��',
                                                   '�������')), --������������

               A.MARK_CHANNEL_TYPE      = DECODE(B.STRUCT_ID_FIR,
                                                 '100000',
                                                 '02',
                                                 '110000',
                                                 '01',
                                                 '120000',
                                                 '03',
                                                 '140000',
                                                 '04'),
               A.MARK_CHANNEL_TYPE_DESC = DECODE(B.STRUCT_ID_FIR,
                                                 '100000',
                                                 'ֱ��',
                                                 '110000',
                                                 'ʵ��',
                                                 '120000',
                                                 '����',
                                                 '140000',
                                                 '����')
      WHEN NOT MATCHED THEN
        INSERT
        VALUES
          (B.STRUCT_ID,
           B.STRUCT_NAME,
           '',
           '',
           '',
           '',
           DECODE(B.STRUCT_ID_FIR,
                  '100000',
                  '004',
                  '120000',
                  '003',
                  DECODE(SUBSTR(B.STRUCT_ID_SEC, 1, 4), 1101, '001', '002')), --��������
           DECODE(B.STRUCT_ID_FIR,
                  '100000',
                  'ֱ������',
                  '120000',
                  '��������',
                  DECODE(SUBSTR(B.STRUCT_ID_SEC, 1, 4),
                         1101,
                         '����Ӫҵ��',
                         '�������')), --������������
           '',
           '',
           '',
           '',
           '',
           '',
           DECODE(B.STRUCT_ID_FIR, '100000', '02', '110000', '01', '120000', '03', '140000', '04'),
           DECODE(B.STRUCT_ID_FIR,
                  '100000',
                  'ֱ��',
                  '110000',
                  'ʵ��',
                  '120000',
                  '����',
                  '140000',
                  '����'),
           '',
           '',
           '',
           '',

           B.STRUCT_ID_SEC,
           B.STRUCT_NAME_SEC,
           B.STRUCT_ID_FIR,
           B.STRUCT_NAME_FIR);
      COMMIT;

      --ɾ��BSS�� �����������������
      DELETE FROM DIM.DIM_CHANNEL_TYPE T
       WHERE T.CHANNEL_TYPE NOT IN
             (SELECT T2.STRUCT_ID FROM DSG_STAGE.BD_DEALER_STRUCTURE_T T2);
      COMMIT;

      --20140731 ��ռ��  �����˱��������
      DELETE FROM DIM.DIM_ACCOUNT_FEE_KIND;
      COMMIT;
      INSERT INTO DIM.DIM_ACCOUNT_FEE_KIND
        SELECT ACCOUNT_FEE_KIND,
               FEE_NAME,
               IF_BACK,
               IF_CONTROL,
               '0' CREDIT_SOLUTION,
               NOTE,
               OPERATE_KIND,
               FEE_CONTROL,
               IF_DISPATCH,
               IF_VISUAL,
               ACCOUNT_TYPE,
               IF_NOTIFY,
               IF_POINT
          FROM ACCT_DSG.BF_ACCOUNT_FEE_KIND_T@HBODS T;
      COMMIT;

      --20140731 ��ռ��  �����˱����ʹ������
      DELETE FROM DIM.DIM_ACCOUNT_TYPE;
      COMMIT;
      INSERT INTO DIM.DIM_ACCOUNT_TYPE
        SELECT KIND, NAME
          FROM ACCT_DSG.BF_ACCOUNT_TYPE_T@HBODS T;
      COMMIT;

      --20140731 ��ռ��  ����Ӷ���������
      /*DELETE FROM DIM.DIM_COMMISION_KIND;
      COMMIT;
      INSERT INTO DIM.DIM_COMMISION_KIND
        SELECT COMMISION_KIND_CODE,
               COMMISION_KIND,
               CHARACTER,
               LEAF_FLAG,
               COMMISION_KIND_LVL,
               MANUAL_FLAG,
               FEE_NAME,
               ORD
          FROM CRM_DSG.BD_CODE_COMM_KIND_T@HBODS T;
      COMMIT;*/

      --20160115 ��ռ��  �������ӿڣ�����Ӷ���������
      MERGE INTO DIM.DIM_COMMISION_KIND A
      USING (SELECT * FROM STAGE.ACCT_ITEM_TYPE@HBODS T) B
      ON (A.COMMISION_KIND_CODE = B.ACCT_ITEM_TYPE_ID)
      WHEN MATCHED THEN
        UPDATE SET A.COMMISION_KIND = B.NAME
      WHEN NOT MATCHED THEN
        INSERT VALUES (B.ACCT_ITEM_TYPE_ID, B.NAME, '', '', '', '', '', '');
      COMMIT;



    -----�����г����� ��ΰ�� 2013��7��29��16:29:07
    INSERT INTO DIM.DIM_MAKET_ID
      SELECT DISTINCT A.MAKET_ID,
                      A.MAKET_DESC,
                      A.CITY_CODE,
                      A.REGION_CODE,
                      A.LIEU_TYPE,
                      A.IF_VALID,
                      A.PRESERVE01,
                      A.PRESERVE02,
                      CASE
                        WHEN B.CITY_NO_NEUSOFT IS NOT NULL AND
                             B.AREA_NO IS NOT NULL THEN
                         B.CITY_NO
                        WHEN LENGTH(A.REGION_CODE) = 9 AND
                             A.REGION_CODE LIKE '0%' THEN
                         A.REGION_CODE
                        ELSE
                         FUNC_GET_OTHER_CITY_NO(A.CITY_CODE)
                      END CITY_NO
        FROM (SELECT  T1.* ,ROW_NUMBER()OVER(PARTITION BY MAKET_ID ORDER BY  IF_VALID DESC)RN
                FROM CRM_DSG.BB_MAKET_T@HBODS T1
               WHERE NOT EXISTS (SELECT 1
                        FROM DIM.DIM_MAKET_ID T2
                       WHERE T2.MAKET_ID = T1.MAKET_ID)) A,
             DIM.DIM_CITY_NO_TRANS B
       WHERE A.REGION_CODE = B.CITY_NO_NEUSOFT(+)
         AND A.CITY_CODE = B.AREA_NO(+)
         AND A.RN = 1 ;
    COMMIT;

    -----�����г����Ƹ�����Ķ�Ӧ��ϵ  ��ΰ�� 2013��7��29��16:29:07
    INSERT INTO DIM.DIM_MARKET_NET
      SELECT DISTINCT MAKET_ID MARKET_ID,
                      MAKET_DESC MARKET_NAME,
                      CITY_CODE AREA_NO,
                      '1' IS_VALID,
                      NULL NET_ID,
                      NULL OPER_USER,
                      NULL OPER_DATE
        FROM DIM.DIM_MAKET_ID T1 --�г�����
       WHERE NOT EXISTS (SELECT 1
                FROM DIM.DIM_MARKET_NET T2
               WHERE T2.MARKET_ID = T1.MAKET_ID);
    COMMIT;
    -------------------����CRM2.0���������-----------------

    --�����¼��Ų�Ʒ����ҵ����Ĺ�ϵ��
    INSERT INTO DIM.DIM_GROUP_PROD_GROUP
      SELECT DISTINCT X.PRODUCT_ID, X.GROUP_ID
        FROM ODS_STAGE.BB_GROUP_PROD_GROUP_T@HBODS X, DIM.DIM_GROUP_PROD_GROUP Y
       WHERE X.PRODUCT_ID = Y.PRODUCT_ID(+)
         AND LENGTH(TRIM(X.PRODUCT_ID)) > 0
         AND Y.PRODUCT_ID IS NULL;
    COMMIT;

    ---��������ҵ�������

    INSERT INTO DIM.DIM_GROUP_PROD_GROUP_NAME
      SELECT DISTINCT X.GROUP_ID, X.GROUP_NAME
        FROM ODS_STAGE.BB_GROUP_PROD_GROUP_NAME_T@HBODS X,
             DIM.DIM_GROUP_PROD_GROUP_NAME        Y
       WHERE X.GROUP_ID = Y.GROUP_ID(+)
         AND Y.GROUP_ID IS NULL;
    COMMIT;

    --�����¼��Ų�Ʒ�뼯�Ÿ��˲�Ʒ�Ĺ�ϵ��

    INSERT INTO DIM.DIM_PRODUCT_RELATION
      SELECT DISTINCT X.PRODUCT_RELATION_ID,
                      X.RELATION_TYPE_CD,
                      X.PRODUCT_A_ID,
                      X.PRODUCT_Z_ID,
                      X.STATUS,
                      X.CHANGE_DATE,
                      X.CREATE_DATE
        FROM ODS_STAGE.PRODUCT_RELATION@HBODS X, DIM.DIM_PRODUCT_RELATION Y
       WHERE X.PRODUCT_RELATION_ID = Y.PRODUCT_RELATION_ID(+)
         AND Y.PRODUCT_RELATION_ID IS NULL;
    COMMIT;
    INSERT INTO DIM.DIM_PROD_BUS_STR
      SELECT DISTINCT X.PRODUCT_ID,
                      X.PRODUCT_NBR,
                      X.PRODUCT_NAME,
                      X.PRODUCT_DESC,
                      X.PRODUCT_PROVIDER_ID,
                      X.STATUS_CD,
                      X.PROD_FUNC_TYPE,
                      X.PROD_FUNC_FLAG,
                      X.PRODUCT_TYPE_FLAG,
                      X.CREATE_DATE,
                      X.STATUS_DATE,
                      X.EFF_DATE,
                      X.EXP_DATE,
                      X.SERVICE_KIND
        FROM ODS_STAGE.BB_BUS_STR_T@HBODS X, DIM.DIM_PROD_BUS_STR Y
       WHERE X.PRODUCT_ID = Y.PRODUCT_ID(+)
         AND Y.PRODUCT_ID IS NULL;
    COMMIT;

    UPDATE DIM.DIM_PROD_BUS_STR T
       SET T.STATUS_CD  =
           (SELECT DISTINCT STATUS_CD
              FROM ODS_STAGE.BB_BUS_STR_T@HBODS X
             WHERE X.PRODUCT_ID = T.PRODUCT_ID), ---����״̬
           T.STATUS_DATE =
           (SELECT DISTINCT STATUS_DATE
              FROM ODS_STAGE.BB_BUS_STR_T@HBODS X
             WHERE X.PRODUCT_ID = T.PRODUCT_ID), ---����״̬���ʱ��
           T.EXP_DATE   =
           (SELECT DISTINCT EXP_DATE
              FROM ODS_STAGE.BB_BUS_STR_T@HBODS X
             WHERE X.PRODUCT_ID = T.PRODUCT_ID) ---����ʧЧʱ��
     WHERE EXISTS (SELECT *
              FROM ODS_STAGE.BB_BUS_STR_T@HBODS X
             WHERE X.PRODUCT_ID = T.PRODUCT_ID
               AND X.STATUS_CD <> T.STATUS_CD);
    COMMIT;
    DELETE FROM DIM.DMCODE_INDUSTRY_CODE;
    COMMIT;
    INSERT INTO DIM.DMCODE_INDUSTRY_CODE
      SELECT * FROM DIM.DMCODE_INDUSTRY_CODE@HBODS T;
    COMMIT;

    --����������������� 20131012 ��ռ�� ����
    MERGE INTO DIM.DIM_CHANNEL_MANAGER A
    USING (SELECT CHANNEL_NO,
                  CHANNEL_NO_DESC,
                  AREA_NO,
                  CASE
                    WHEN LENGTH(T.CITY_NO) < 9 THEN
                     FUNC_GET_OTHER_CITY_NO(T.AREA_NO)
                    ELSE
                     T.CITY_NO
                  END CITY_NO

             FROM DIM.DIM_CHANNEL_NO T, DIM.DIM_CHANNEL_TYPE T2
            WHERE T.AREA_NO <> '018'
              AND T.CHANNEL_TYPE = T2.CHANNEL_TYPE
              AND T2.CHANNEL_KIND = '001') B
    ON (A.CHANNEL_NO = B.CHANNEL_NO)
    WHEN MATCHED THEN
      UPDATE
         SET A.CHANNEL_NO_DESC = B.CHANNEL_NO_DESC,
             A.AREA_NO         = B.AREA_NO,
             A.CITY_NO         = B.CITY_NO
    WHEN NOT MATCHED THEN
      INSERT
      VALUES
        (B.CHANNEL_NO,
         B.CHANNEL_NO_DESC,
         B.AREA_NO,
         B.CITY_NO,
         '',
         '',
         '',
         '',
         '');
    COMMIT;


    --------------------2014��2��14��14:53:14 ���������Ӧ����֧��----------------

    ---����������ڵ�����֧��
    DELETE FROM DIM.DIM_CHANNEL_NO_TOWN;
    COMMIT;

    INSERT INTO DIM.DIM_CHANNEL_NO_TOWN
      SELECT /*+ORDERED*/
      DISTINCT DEALER_ID   CHANNEL_NO,
               B.F_TOWN_NO TOWN_NO,
               ZHIJU_ID,
               ZHIJU_DESC
        FROM  (SELECT D.* ,ROW_NUMBER()OVER(PARTITION BY DEALER_ID ORDER BY  CREATE_DATE DESC)RN
           FROM CRM_DSG.CHANNEL@HBODS D )A,
             (SELECT T.F_AREA_ID, T.F_TOWN_NO, M.ZHIJU_ID, ZHIJU_DESC
                FROM DIM.DIM_OM_AREA_T T, DIM.DIM_TOWN_ZHIJU M
               WHERE T.F_TOWN_NO = M.TOWN_NO(+)) B
       WHERE A.TOWN_CODE = B.F_AREA_ID(+)
       AND A.RN =1 ;

    COMMIT;
    -----------------2014��2��14��15:00:41 ���� ������Ӧ��������--------------

    DELETE FROM DIM.DIM_CHANNEL_NO_ATTR;
    COMMIT;

  INSERT INTO DIM.DIM_CHANNEL_NO_ATTR
  SELECT CHANNEL_NO,
         MAX(T130) SALES_TYPE,
         MAX(T133) SELF_LEVEL,
         MAX(T135) SALES_FORMAT,
         MAX(T136) SALES_LEVEL,
         MAX(T137) CHAIN_CLASS,
         MAX(T138) TOP10,
         MAX(T139) LAYOUT_CLASS,
         MAX(T140) SALES_REGION,
         MAX(T141) BUSINESS_ZONE,
         MAX(T144) PROTOP10,
         MAX(T132) BUSINESS_EXCLUSIVE,
         MAX(ZONE_NAME) ZONE_NAME,
         -----------------2014��8��4��09:45:34 ����--------------
         MAX(T131) AREA_NATURE, --��������
         MAX(T134) SELF_OPER_TYPE, --��Ӫ����Ӫ��ʽ
         MAX(T159) CITY_LVL, --���м���
         MAX(T160) IF_CRM_JOIN, --CRM�Ƿ����
         MAX(T161) IF_LZD_JOIN, --�Ƿ����ն˽���
         MAX(A019), --���۵��ַ
         MAX(A020), --���۵��׼����
         MAX(A021), --���۵����
         MAX(A022), --��ͼ��Ϣ
         MAX(A025), --����Э��
         MAX(T156) IF_IPHONE, --�Ƿ�IPHONE��Ȩ��
         MAX(T157) TARGET_TYPE, --����ͻ�����
         MAX(T158) BRAND_COVER, --Ʒ�ƽ�פ
         MAX(T151) YW_INTEGRATION, --�Ƿ�Ӫάһ�廯
         MAX(T166) MANUFACTURER_NAME, --����������ʶ
         MAX(T152) TOP_CODE, --TOP��������ʶ
         MAX(T153) SPECIALTY_STORE_TYPE, --רӪ�ŵ����
         MAX(T154) EMPOWER_STORE_LVL, --��Ȩ�ŵ꼶��
         MAX(T155) BLD_YT, --������ҵ̬
         MAX(A43), --������������
         MAX(A44), --��������֤����Ϣ
         MAX(A45), --��ϵ�绰
         MAX(A46), --��ϵ����
         MAX(A47), --Ʒ�Ʊ�ʶ
         MAX(A49), --�����������
         MAX(A21), --����Ǽ�ʱ��
        MAX(A23), --���۵�ҵ��Χ(T)
        MAX(A24), --���۵���������(T)
        MAX(A25), --���۵㹦������(T)
        MAX(A26), --�̿�ʵ���ϸ��(T)
         MAX(A27), ----������
        MAX(A28), ---�����˵绰
        MAX(A29), --��ʼ����ʱ��
        MAX(A30), --�ٶȵ�ͼ����
        MAX(A31)  --�ٶȵ�ͼγ��

       FROM (SELECT A.DEALER_ID CHANNEL_NO,
                 CASE
                   WHEN A.ATTR_ID = '50000027' THEN
                    A.ATTR_VALUE
                 END T130, --ʵ���������۵����

                 CASE
                   WHEN A.ATTR_ID = '50000003' THEN
                    A.ATTR_VALUE
                 END T133, --��Ӫ������

                 CASE
                   WHEN A.ATTR_ID = '50000005' THEN
                    A.ATTR_VALUE
                 END T135, --�������۵�ҵ̬

                 CASE
                   WHEN A.ATTR_ID = '50000023' THEN
                    A.ATTR_VALUE
                 END T136, --�ּ���Ϣ

                 CASE
                   WHEN A.ATTR_ID = '50000006' THEN
                    A.ATTR_VALUE
                 END T137, --���������ʶ

                 CASE
                   WHEN A.ATTR_ID = '50000007' THEN
                    A.ATTR_VALUE
                 END T138, --TOP10��ʶ

                 CASE
                   WHEN A.ATTR_ID = '50000009' THEN
                    A.ATTR_VALUE
                 END T139, --���ڲ������

                 CASE
                   WHEN A.ATTR_ID = '50000010' THEN
                    A.ATTR_VALUE
                 END T140, --�۵�����

                 CASE
                   WHEN A.ATTR_ID = '50000012' THEN
                    A.ATTR_VALUE
                 END T141, --��Ȧ����

                 CASE
                   WHEN A.ATTR_ID = '50' THEN
                    A.ATTR_VALUE
                 END T144, --ʡ��TOP��ʶ
                 CASE
                   WHEN A.ATTR_ID = '50000002' THEN
                    A.ATTR_VALUE
                 END T132, --ҵ������

                 ------------------����2014��8��4��08:49:45------------
                 CASE
                   WHEN A.ATTR_ID = '50000001' THEN
                    A.ATTR_VALUE
                 END T131, --��������
                 CASE
                   WHEN A.ATTR_ID = '50000004' THEN
                    A.ATTR_VALUE
                 END T134, --��Ӫ����Ӫ��ʽ
                 CASE
                   WHEN A.ATTR_ID = '50000011' THEN
                    A.ATTR_VALUE
                 END T159, --���м���

                 CASE
                   WHEN A.ATTR_ID = '50000013' THEN
                    A.ATTR_VALUE
                 END T160, --CRM�Ƿ����
                 CASE
                   WHEN A.ATTR_ID = '50000014' THEN
                    A.ATTR_VALUE
                 END T161, --�Ƿ����ն˽���

                 CASE
                   WHEN A.ATTR_ID = '50000019' THEN
                    A.ATTR_VALUE
                 END A019, --���۵��ַ
                 CASE
                   WHEN A.ATTR_ID = '50000020' THEN
                    A.ATTR_VALUE
                 END A020, --���۵��׼����
                 CASE
                   WHEN A.ATTR_ID = '50000021' THEN
                    A.ATTR_VALUE
                 END A021, --���۵����
                 CASE
                   WHEN A.ATTR_ID = '50000022' THEN
                    A.ATTR_VALUE
                 END A022, --��ͼ��Ϣ

                 CASE
                   WHEN A.ATTR_ID = '50000025' THEN
                    A.ATTR_VALUE
                 END A025, --����Э��
                 CASE
                   WHEN A.ATTR_ID = '50000026' THEN
                    A.ATTR_VALUE
                 END T156, --�Ƿ�IPHONE��Ȩ��
                 CASE
                   WHEN A.ATTR_ID = '50000028' THEN
                    A.ATTR_VALUE
                 END T157, --����ͻ�����
                 CASE
                   WHEN A.ATTR_ID = '50000029' THEN
                    A.ATTR_VALUE
                 END T158, --Ʒ�ƽ�פ
                 CASE
                   WHEN A.ATTR_ID = '50000031' THEN
                    A.ATTR_VALUE
                 END T150, --���۵�ר������
                 CASE
                   WHEN A.ATTR_ID = '50000032' THEN
                    A.ATTR_VALUE
                 END T151, --�Ƿ�Ӫάһ�廯

                 CASE
                   WHEN A.ATTR_ID = '50000033' THEN
                    A.ATTR_VALUE
                 END T166, --����������ʶ

                 CASE
                   WHEN A.ATTR_ID = '50000034' THEN
                    A.ATTR_VALUE
                 END T152, --TOP��������ʶ

                 CASE
                   WHEN A.ATTR_ID = '50000035' THEN
                    A.ATTR_VALUE
                 END T153, --רӪ�ŵ����

                 CASE
                   WHEN A.ATTR_ID = '50000036' THEN
                    A.ATTR_VALUE
                 END T154, --��Ȩ�ŵ꼶��

                 CASE
                   WHEN A.ATTR_ID = '50000037' THEN
                    A.ATTR_VALUE
                 END T155, --������ҵ̬

                 CASE
                   WHEN A.ATTR_ID = '43' THEN
                    A.ATTR_VALUE
                 END A43, --������������
                 CASE
                   WHEN A.ATTR_ID = '44' THEN
                    A.ATTR_VALUE
                 END A44, --��������֤����Ϣ

                 CASE
                   WHEN A.ATTR_ID = '45' THEN
                    A.ATTR_VALUE
                 END A45, --��ϵ�绰

                 CASE
                   WHEN A.ATTR_ID = '46' THEN
                    A.ATTR_VALUE
                 END A46, --��ϵ����

                 CASE
                   WHEN A.ATTR_ID = '47' THEN
                    A.ATTR_VALUE
                 END A47, --Ʒ�Ʊ�ʶ

                 CASE
                   WHEN A.ATTR_ID = '49' THEN
                    A.ATTR_VALUE
                 END A49, --�����������

                 CASE
                   WHEN A.ATTR_ID = '21' THEN
                    A.ATTR_VALUE
                 END A21, --����Ǽ�ʱ��
              -------------------------------2014��9��16��17:47:48-----------
                CASE
                   WHEN A.ATTR_ID = '50000046' THEN
                    A.ATTR_VALUE
                 END A23, --���۵�ҵ��Χ(T)
                  CASE
                   WHEN A.ATTR_ID = '50000047' THEN
                    A.ATTR_VALUE
                 END A24, --���۵���������(T)
                   CASE
                   WHEN A.ATTR_ID = '50000048' THEN
                    A.ATTR_VALUE
                 END A25, --���۵㹦������(T)
                   CASE
                   WHEN A.ATTR_ID = '50000049' THEN
                    A.ATTR_VALUE
                 END A26, --�̿�ʵ���ϸ��(T)
         -----------------2015��1��22��14:47:01 ����---------
              CASE   WHEN A.ATTR_ID = '34' THEN
                    A.ATTR_VALUE
                 END A27, --������
                CASE   WHEN A.ATTR_ID = '35' THEN
                    A.ATTR_VALUE
                 END A28, --�����˵绰
                CASE   WHEN A.ATTR_ID = '50000051' THEN
                    A.ATTR_VALUE
                 END A29, --��ʼ����ʱ��
              CASE   WHEN A.ATTR_ID = '50000058' THEN
                    A.ATTR_VALUE
                 END A30, --�ٶȵ�ͼ����
               CASE   WHEN A.ATTR_ID = '50000059' THEN
                    A.ATTR_VALUE
                 END A31 --�ٶȵ�ͼγ��

            FROM CRM_DSG.CHANNEL_ATTRIBUTE@HBODS A) A,
         CRM_DSG.BD_BUSINESS_ZONE_T@HBODS B
   WHERE A.T141 = B.ZONE_CODE(+)
   GROUP BY CHANNEL_NO;

COMMIT;

    --2014.03.10 ���
    DELETE FROM DIM.BRPT_FEE_KIND_T T;
    COMMIT;
    INSERT INTO DIM.BRPT_FEE_KIND_T
      SELECT SERVICE_KIND,
             FEE_KIND,
             FEE_KIND_NAME,
             REPORT_G1_CODE,
             REPORT_G1_NAME,
             REPORT_G2_CODE,
             REPORT_G2_NAME,
             REPORT_G3_CODE,
             REPORT_G3_NAME,
             REPORT_G4_CODE,
             REPORT_G4_NAME,
             ADDSRV_G1_CODE,
             ADDSRV_G1_NAME,
             ADDSRV_G2_CODE,
             ADDSRV_G3_CODE,
             C1X_TYPE_CODE,
             CALL_TYPE,
             ROAM_TYPE,
             TOLL_TYPE,
             NET_TYPE,
             OTHER_FLAG,
             BILL_ORDER,
             BILL_ID,
             BILL_KIND_NAME,
             USE_STATUS,
             UPDATE_TIME,
             REPORT_SAP_CODE,
             REPORT_SAP_NAME
        FROM ACCT_DSG.BRPT_FEE_KIND_T@HBODS;
    COMMIT;


    ------------2014��4��30��17:43:35 ��������------------------
     DELETE FROM DIM.DIM_PROMOTION_SUBSIDY_AMOUNT;
    COMMIT;

    ---д����ʽ����
    INSERT INTO DIM.DIM_PROMOTION_SUBSIDY_AMOUNT
      SELECT AREA_NO,
             TO_CHAR(PROMOTION_ID) PROMOTION_ID,
             PROMOTIION_NAME,
             CREATE_DATE,
             EFF_DATE,
             EXP_DATE,
             PROMOTION_TYPE,
             MAX(NVL(PHONE_AMOUNT, 0)) PHONE_AMOUNT,
             MAX(NVL(CALL_AMOUNT, 0)) CALL_AMOUNT,
             MAX(NVL(TRANSFER_AMOUNT, 0)) TRANSFER_AMOUNT,
             MAX(NVL(FIRST_MONTH_AMOUNT, 0)) FIRST_MONTH_AMOUNT
        FROM (SELECT /*+ORDERED*/
              DISTINCT A.*,
                       B.ATTR_VALUE / 100 PHONE_AMOUNT,
                       C.ATTR_VALUE / 100 CALL_AMOUNT,
                       E.ATTR_VALUE / 100 TRANSFER_AMOUNT,
                       F.ATTR_VALUE / 100 FIRST_MONTH_AMOUNT,
                       D.PROMOTION_TYPE
                FROM (SELECT F_CITY_CODE AREA_NO,
                             PROD_OFFER_ID PROMOTION_ID,
                             PROD_OFFER_NAME PROMOTIION_NAME,
                             A.CREATE_DATE,
                             A.EFF_DATE,
                             EXP_DATE
                        FROM CRM_DSG.PROD_OFFER@HBODS A,
                             CRM_DSG.OM_AREA_T@HBODS  B
                       WHERE OFFER_TYPE = 13
                         AND A.AREA_ID = B.F_AREA_ID) A,
                     (SELECT *
                        FROM CRM_DSG.SALES_PROMOTION_ITEM@HBODS
                       WHERE ITEM_ATTR_ID = '20203') B,
                     (SELECT *
                        FROM CRM_DSG.SALES_PROMOTION_ITEM@HBODS
                       WHERE ITEM_ATTR_ID = '20204') C,
                     (SELECT DISTINCT PROMOTION_ID, PROMOTION_TYPE
                        FROM CRM_DSG.SALES_PROMOTION@HBODS) D,
                     (SELECT *
                        FROM CRM_DSG.SALES_PROMOTION_ITEM@HBODS
                       WHERE ITEM_ATTR_ID = '10504') E, --��ת�ƽ��-
                     (SELECT *
                        FROM CRM_DSG.SALES_PROMOTION_ITEM@HBODS
                       WHERE ITEM_ATTR_ID = '10505') F --���»������
               WHERE A.PROMOTION_ID = B.PROMOTION_ID(+)
                 AND A.PROMOTION_ID = C.PROMOTION_ID(+)
                 AND A.PROMOTION_ID = D.PROMOTION_ID(+)
                 AND A.PROMOTION_ID = E.PROMOTION_ID(+)
                 AND A.PROMOTION_ID = F.PROMOTION_ID(+)

              )

       GROUP BY AREA_NO,
                PROMOTION_ID,
                PROMOTIION_NAME,
                CREATE_DATE,
                EFF_DATE,
                EXP_DATE,
                PROMOTION_TYPE;
    COMMIT;

    -----�������������������DIM.DIM_CHANNEL_NO_LVL_M ÿ�µ׳���һ�� 2014��8��19��11:15:42--------------
    IF V_DATE=TO_CHAR(LAST_DAY(TO_DATE(V_DATE,'YYYYMMDD')),'YYYYMMDD') THEN

    --ɾ���ظ�����
    DELETE FROM DIM.DIM_CHANNEL_NO_LVL_M A WHERE A.ACCT_MONTH=SUBSTR(V_DATE,1,6);
    COMMIT;

    ---д���������
    INSERT INTO DIM.DIM_CHANNEL_NO_LVL_M
    SELECT DISTINCT SUBSTR(V_DATE, 1, 6) ACCT_MONTH,
       CHANNEL_NO,
       CHANNEL_NO_DESC,
       CITY_NO,
       AREA_NO,
       CHANNEL_KIND,
       CHANNEL_TYPE,
       SELL_CENTER,
       CONTRACT_BEGIN,
       CONTRACT_END,
       DEALER_PARENT,
       INSERT_DATE,
       CHANNEL_SCOPE,
       CHANNEL_LEVEL,
       VALID_STATUS,
       CHANGE_DATE,
       PARTY_ID,
       CHANNEL_TYPE_THR,
       CHANNEL_TYPE_DESC_THR,
       CHANNEL_TYPE_SEC,
       CHANNEL_TYPE_DESC_SEC,
       CHANNEL_TYPE_FIR,
       CHANNEL_TYPE_DESC_FIR,
       CHANNEL_DEPT_NO,
       CHANNEL_DEPT_DESC,
       LVL1,
       LVL1_NAME,
       LVL2,
       LVL2_NAME,
       LVL3,
       LVL3_NAME
  FROM DIM.DIM_CHANNEL_NO_LVL;
    COMMIT;

    END IF;

      --============ ����С�����ģ��ʹ�õ������ =====================
      V_XQ_NUM := 0;
      V_XQ_NUM_2 := 0;

      SELECT COUNT(1) INTO V_XQ_NUM FROM STAGE.XIAOQU_INFO@HBODS T;

      SELECT COUNT(1) INTO V_XQ_NUM_2 FROM STAGE.XIAOQU_STD_ADDR@HBODS T;

      IF V_XQ_NUM > 40000 AND V_XQ_NUM_2 > 90000 THEN
        --============================ ����С����Ϣ�� ===========================
      DELETE FROM ALLDMCODE.DMCODE_XIAOQU_INFO T;
      COMMIT;

      INSERT INTO ALLDMCODE.DMCODE_XIAOQU_INFO
        SELECT TRIM(B.AREA_NO), --
               TRIM(B.CITY_NO), --����

               TRIM(CITY_TYPE), --��������
               TRIM(TOWN_NAME), --��������

               TRIM(XIAOQU_NO), --С��ID
               TRIM(XIAOQU_NAME), --С������
               TRIM(BUILDING_TYPE), --��������
               TRIM(USER_TYPE), --��ס�û�����
               TRIM(FUGAI_USER), --�����û���
               TRIM(BEGIN_DATE), --��ͨʱ��
               TRIM(INNET_METHOD), --���뷽ʽ
               TRIM(JINXIAN_TYPE), --��������
               TRIM(SHENTOU_RATE) / 100, --С����͸��
               TRIM(COMPETITION_DESC), --������Ϣ����
               TRIM(MOBILE_ONNET_USER), --�ƶ���FTTH�������û���
               TRIM(UNION_ONNET_USER), --��ͨ�����û���
               TRIM(CK_ONNET_USER), --���������û���
               TRIM(FTTH_PORT_TYPE), --�ֹ�������
               TRIM(FTTH_PORT_NUM), --FTTHС��ĩ�˷ֹ����˿���
               TRIM(MOBILE_IF_JINXIAN),
               TRIM(GRID_ID),
               TRIM(GRID_NAME),
               TRIM(GRID_CODE),
               TRIM(CHARGE_RULE),
               TRIM(SUBTATION),
               TRIM(TOWN_CODE),
               TRIM(TOWN_NO)

          FROM (SELECT * FROM STAGE.XIAOQU_INFO@HBODS T WHERE T.AREA_NO IS NOT NULL) A,

               (SELECT * FROM ALLDMCODE.DMCODE_XIAOQU_AREA_NO T) B

         WHERE A.AREA_NO = B.AREA_NO_HY(+)
           AND A.CITY_NO = B.CITY_NO_HY(+);
      COMMIT;

      --���²���ϵͳ��BSS�����Ӧ��ϵ���У�������������Ϣ
       INSERT INTO ALLDMCODE.DMCODE_XIAOQU_AREA_NO
         SELECT DISTINCT T.AREA_NO, T.AREA_NAME, T.CITY_NO, T.CITY_NAME, '', ''

           FROM STAGE.XIAOQU_INFO@HBODS T, ALLDMCODE.DMCODE_XIAOQU_AREA_NO T2
          WHERE T.CITY_NO = T2.CITY_NO_HY(+)
            AND T2.CITY_NO IS NULL
            AND T.AREA_NO IS NOT NULL;
       COMMIT;

      --��������
      DELETE FROM ALLDMCODE.DMCODE_XIAOQU_INFO_BAK T
       WHERE T.DAY_ID = V_DATE;
      COMMIT;

      --ɾ�����15������ݣ�������ÿ���µ׵�����
      DELETE FROM ALLDMCODE.DMCODE_XIAOQU_INFO_BAK T
       WHERE T.DAY_ID = TO_CHAR(TO_DATE(V_DATE, 'YYYYMMDD') - 15, 'YYYYMMDD')
         AND DAY_ID <> TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(V_DATE, 'YYYYMMDD'), -1)), 'YYYYMMDD');
      COMMIT;

      INSERT INTO ALLDMCODE.DMCODE_XIAOQU_INFO_BAK T
        SELECT AREA_NO,
               CITY_NO,
               CITY_TYPE,
               TOWN_NAME,
               XIAOQU_NO,
               XIAOQU_NAME,
               BUILDING_TYPE,
               USER_TYPE,
               FUGAI_USER,
               BEGIN_DATE,
               INNET_METHOD,
               JINXIAN_TYPE,
               SHENTOU_RATE,
               COMPETITION_DESC,
               MOBILE_ONNET_USER,
               UNION_ONNET_USER,
               CK_ONNET_USER,
               FTTH_PORT_TYPE,
               FTTH_PORT_NUM,
               MOBILE_IF_JINXIAN,
               GRID_ID,
               GRID_NAME,
               GRID_CODE,
               CHARGE_RULE,
               SUBTATION,
               TOWN_CODE,
               TOWN_NO,
               V_DATE DAY_ID
          FROM ALLDMCODE.DMCODE_XIAOQU_INFO;
      COMMIT;

      --����С����Ӧ���������
      DELETE FROM ALLDMCODE.DMCODE_GRID_INFO;
      COMMIT;

      INSERT INTO ALLDMCODE.DMCODE_GRID_INFO
        SELECT TRIM(T.GRID_ID),
               TRIM(T2.AREA_NO),
               TRIM(T.AREA_NAME),
               TRIM(T2.CITY_NO),
               TRIM(T.CITY_NAME),
               TRIM(T.GRID_NAME),
               TRIM(T.GRID_CODE),
               TRIM(T.GRID_CODE_NAME),
               TRIM(T.CHARGE_RULE)

          FROM STAGE.GRID_INFO@HBODS T, ALLDMCODE.DMCODE_XIAOQU_AREA_NO T2
         WHERE T.AREA_NO = T2.AREA_NO_HY(+)
           AND T.CITY_NO = T2.CITY_NO_HY(+);
      COMMIT;


        --============================ ����С�����׼��ַ�Ķ�Ӧ��ϵ�� ===========================
        DELETE FROM ALLDMCODE.DMCODE_XIAOQU_STD_ADDR;
        COMMIT;

        INSERT INTO ALLDMCODE.DMCODE_XIAOQU_STD_ADDR T
          SELECT MAX(TRIM(XIAOQU_NO)),
                 MAX(TRIM(XIAOQU_NAME)),
                 MAX(TRIM(STDADDR_NO)),
                 TRIM(T.GRADE_0) || '->' || TRIM(T.GRADE_1) || '->' ||
                 TRIM(T.GRADE_2) || '->' || TRIM(T.GRADE_3) || '->' ||
                 TRIM(T.GRADE_4) STDADDR_NAME

            FROM STAGE.XIAOQU_STD_ADDR@HBODS T
           WHERE T.XIAOQU_NO IS NOT NULL
           GROUP BY TRIM(T.GRADE_0) || '->' || TRIM(T.GRADE_1) || '->' ||
                    TRIM(T.GRADE_2) || '->' || TRIM(T.GRADE_3) || '->' ||
                    TRIM(T.GRADE_4);
        COMMIT;

      END IF;


      --�����ն���� 20150902 ��ռ�� ����
      DELETE FROM DIM.DIM_TERMINAL_INFO_DAY_BAK T
       WHERE T.DAY_ID = TO_CHAR(TO_DATE(V_DATE, 'YYYYMMDD') - 1, 'YYYYMMDD');
      COMMIT;
      INSERT INTO DIM.DIM_TERMINAL_INFO_DAY_BAK
        SELECT TO_CHAR(TO_DATE(V_DATE, 'YYYYMMDD') - 1, 'YYYYMMDD'),
               TERMINAL_MODEL,
               RESOURCE_KIND,
               RESOURCE_NAME,
               TERMINAL_TYPE,
               TELE_CODE,
               SUGGEST_PRICE,
               STATUS_EVDO,
               STATUS_SMART,
               STATUS_SYSTEM,
               DATA_SOURCE,
               IS_REPORT

          FROM DIM.DIM_TERMINAL_INFO T;
      COMMIT;

      --================ 20150914 ��ռ�� ���Ӷ�ʱ����ҵ��������� ===================
      MERGE INTO DIM.DIM_TELE_TYPE A
      USING CRM_DSG.BS_SERVICE_KIND_T@HBODS B
      ON (A.NEUS_TELE_TYPE = B.SERVICE_KIND)
      WHEN MATCHED THEN
        UPDATE SET A.TELE_TYPE_DESC = B.SERVICE_NAME
      WHEN NOT MATCHED THEN
        INSERT VALUES (B.SERVICE_KIND, B.SERVICE_NAME, B.SERVICE_KIND);
      COMMIT;

      DELETE FROM DIM.DIM_TELE_TYPE T
       WHERE T.NEUS_TELE_TYPE NOT IN
             (SELECT SERVICE_KIND FROM CRM_DSG.BS_SERVICE_KIND_T@HBODS);
      COMMIT;

      --================ 20150924 ��ռ�� ���Ӷ�ʱ���� ֤��������� ===================
      MERGE INTO DIM.DIM_CERT_TYPE A
      USING(
      SELECT B.F_CERT_TYPE, B.F_CERT_TYPE_DESC
      FROM (SELECT B.*,ROW_NUMBER()OVER(PARTITION BY F_CERT_TYPE ORDER BY  F_CERT_TYPE_DESC DESC)RN
      FROM
            CRM_DSG.CM_CERT_TYPE_T@HBODS B) B
            WHERE RN =1 )  B
      ON (A.CERT_TYPE = B.F_CERT_TYPE)
      WHEN MATCHED THEN
        UPDATE SET A.CERT_TYPE_DESC = B.F_CERT_TYPE_DESC
      WHEN NOT MATCHED THEN
        INSERT VALUES (B.F_CERT_TYPE, B.F_CERT_TYPE_DESC, '');
      COMMIT;


      --================ 20170503 ��ռ�� ���Ӷ�ʱ���� ֤��������� ===================
      DELETE FROM DIM.DIM_PRODUCT_TELE_TYPE T;
      COMMIT;

      INSERT INTO DIM.DIM_PRODUCT_TELE_TYPE
        SELECT TELE_TYPE,
               PRODUCT_ID,
               PRODUCT_NAME,
               NET_TYPE,
               TELE_TYPE_DESC,
               SERVICE_CLASS,
               PRESERV01,
               PRESERV02,
               PRESERV03,
               PRESERV04
          FROM ACCT_DSG.BRPT_SERVICE_KIND_TELE@HBODS T;
      COMMIT;

       --================ 20151110 ��ռ�� ���Ӷ�ʱ���� ===================
      --�����ն˻������
      DELETE FROM DIM.DIM_IR_RESOURCE_KIND;
      COMMIT;
      INSERT INTO DIM.DIM_IR_RESOURCE_KIND
        SELECT RESOURCE_KIND,
               RESOURCEKIND_NAME,
               RESOURCE_TYPE,
               MANUFACTURER_ID,
               IS_3G
          FROM DIM.DIM_IR_RESOURCE_KIND@HBODS T;
      COMMIT;

      --�����ն˳������
      DELETE FROM DIM.DIM_IR_MOBILE_MANUFACTURER;
      COMMIT;
      INSERT INTO DIM.DIM_IR_MOBILE_MANUFACTURER
        SELECT MANUFACTURER_ID, MANUFACTURER_NAME
          FROM DIM.DIM_IR_MOBILE_MANUFACTURER@HBODS T;
      COMMIT;



      --�����ն˻������ҳ���ã�
      DELETE FROM ALLDMCODE.DMCODE_TERMINAL_INFO;
      COMMIT;
      INSERT INTO ALLDMCODE.DMCODE_TERMINAL_INFO
        SELECT A.TERMINAL_MODEL,
               A.TERMINAL_TYPE,
               A.SUGGEST_PRICE,
               B.TERMINAL_CORP,
               ''
          FROM (SELECT * FROM DIM.DIM_TERMINAL_INFO) A,
               (SELECT * FROM DIM.TERMINAL_INFO_JT T WHERE ACCT_DAY = '20151109') B

         WHERE A.TERMINAL_MODEL = B.TERMINAL_MODEL(+);
      COMMIT;

      --�����ն˳������ҳ���ã�
      DELETE FROM ALLDMCODE.DMCODE_TERMINAL_CORP;
      COMMIT;
      INSERT INTO ALLDMCODE.DMCODE_TERMINAL_CORP
        SELECT DISTINCT A.TERMINAL_CORP, ''
          FROM (SELECT *
                  FROM DIM.TERMINAL_INFO_JT T
                 WHERE ACCT_DAY = '20151109'
                 ORDER BY TERMINAL_CORP) A;
      COMMIT;

      --��ռ�� 20151228 ���½ɷ��������
      MERGE INTO DIM.DIM_PAY_KIND A
      USING (SELECT * FROM ACCT_DSG.BF_PAY_KIND_T@HBODS T WHERE T.KIND = '0') B
      ON (A.PAY_KIND = B.ID)
      WHEN MATCHED THEN
        UPDATE SET A.PAY_KIND_DESC = B.NAME
      WHEN NOT MATCHED THEN
        INSERT VALUES (B.ID, B.NAME);
      COMMIT;

      --��ռ�� 20151228 ���½ɷѷ�ʽ���
      MERGE INTO DIM.DIM_PAY_TYPE A
      USING (SELECT * FROM CRM_DSG.BS_PAY_WAY_T@HBODS T) B
      ON (A.PAY_TYPE = B.KIND)
      WHEN MATCHED THEN
        UPDATE SET A.PAY_TYPE_DESC = B.NAME
      WHEN NOT MATCHED THEN
        INSERT VALUES (B.KIND, B.NAME);
      COMMIT;


    --##############################����  DIM.DIM_CBDY_AND_CHANNEL  DIM.DIM_CBDY_DETAIL##################3333
  FOR C1 IN V_AREA LOOP
    DELETE FROM MID_MAX_CBDY_NO;
    COMMIT;
    ---��������е�ǰ�а���Ԫ�������ֵ
    INSERT INTO MID_MAX_CBDY_NO
      SELECT B.CBDY_AREA || '2' || LPAD(CBDY_NO, 5, '0')
        FROM (SELECT AREA_NO,
                     TO_CHAR(NVL(MAX(SUBSTR(CBDY_NO, 7)), 0)) CBDY_NO
                FROM DIM.DIM_CBDY_DETAIL T
               WHERE T.AREA_NO = C1.AREA_NO
                 AND ZHIJU_TYPE = '2'
               GROUP BY AREA_NO) A,
             (SELECT AREA_NO, CBDY_AREA
                FROM DIM.DIM_AREA_CBDY_NO
               WHERE AREA_NO = C1.AREA_NO) B
       WHERE A.AREA_NO = B.AREA_NO;
    COMMIT;
    ---ÿ����һ������ �а���Ԫ���ݹ���+1  ROWNUM�Զ����������ļ�¼��Ӧ��ID
    --��������
    DELETE FROM MID_CBDY_AND_CHANNEL ;
    COMMIT;
    INSERT INTO MID_CBDY_AND_CHANNEL
      SELECT AREA_NO,
             CITY_NO,
             ROWNUM + Z.MAX_CBDY_NO,
             CHANNEL_NO,
             CHANNEL_NO_DESC,
             VALID_STATUS,
             SYSDATE,
             '',
             '1' --�����ֶ� �Ƿ��¼�������ʶ
        FROM (SELECT A.CHANNEL_ID
                FROM DIM.DIM_CBDY_AND_CHANNEL A, DIM.DIM_CBDY_DETAIL B
               WHERE A.CBDY_NO = B.CBDY_NO
                 AND B.ZHIJU_TYPE = '2'
                 AND A.AREA_NO = C1.AREA_NO) X,
             (SELECT CHANNEL_NO,
                     CHANNEL_NO_DESC,
                     CITY_NO,
                     AREA_NO,
                     VALID_STATUS
                FROM DIM.DIM_CHANNEL_NO
               WHERE CHANNEL_TYPE = '110101'
                 AND VALID_STATUS = '1'
                 AND AREA_NO = C1.AREA_NO) Y,
             MID_MAX_CBDY_NO Z
       WHERE X.CHANNEL_ID(+) = Y.CHANNEL_NO
         AND X.CHANNEL_ID IS NULL;
    COMMIT;
    ---��ֹ�����ظ�����ֱ�Ӳ��룬���� DIM.DIM_CBDY_AND_CHANNEL  ������������

    INSERT INTO DIM.DIM_CBDY_AND_CHANNEL ------DIM.DIM_CBDY_AND_CHANNEL ��ʽ�ű��滻Ϊ��ʽ��
      SELECT AREA_NO,
             CITY_NO,
             CBDY_NO,
             CHANNEL_ID,
             CHANNEL_NAME,
             IF_VALID,
             UPDATE_DATE,
             UPDATE_USER
        FROM MID_CBDY_AND_CHANNEL A
       WHERE A.AREA_NO = C1.AREA_NO
         AND A.FLAG = '1'
         AND CBDY_NO NOT IN (SELECT CBDY_NO
                               FROM  DIM.DIM_CBDY_AND_CHANNEL  ---DIM.DIM_CBDY_AND_CHANNEL
                              WHERE AREA_NO = C1.AREA_NO)
      ---20170710����ά�������Խű����Ӵ�����
        AND NOT EXISTS (SELECT 1
                FROM DIM.DIM_CBDY_AND_CHANNEL B
               WHERE A.CHANNEL_ID = B.CHANNEL_ID);
    COMMIT;
    --���³а���Ԫ״̬
   UPDATE DIM.DIM_CBDY_AND_CHANNEL T
   SET T.IF_VALID =
       (SELECT X.VALID_STATUS
          FROM DIM.DIM_CHANNEL_NO X
         WHERE T.CHANNEL_ID = X.CHANNEL_NO
         AND X.CHANNEL_TYPE ='110101'
           AND X.AREA_NO = C1.AREA_NO)
 WHERE T.CBDY_NO IN (SELECT B.CBDY_NO
                       FROM  DIM.DIM_CBDY_DETAIL /* DIM.DIM_CBDY_DETAIL*/ B
                      WHERE B.ZHIJU_TYPE = '2'
                        AND B.AREA_NO = C1.AREA_NO);

COMMIT;


    INSERT INTO DIM.DIM_CBDY_DETAIL ---DIM.DIM_CBDY_DETAIL ��ʽ�ű��滻Ϊ��ʽ��
      SELECT A.CBDY_NO,
             A.AREA_NO,
             A.CITY_NO,
             '' ZHIJU_LEVEL, ---����-��������ά��
             '2' ZHIJU_TYPE, ---����-ROLETYPE
             '' ZHIJU_MANAGER, ---�а���ID
             '' ZHIJU_USERNAME, ---�а���NAME
             A.CHANNEL_NAME CBJY_COMP_NAME, ---�а���Ӫ��λ����
             '3010' CBJY_COMP_TYPE, ---�а���Ӫ���Ͷ���  3010  �곤�а���Ӫ
             '30' CBJY_COMP_BIGTYPE, ---�а���Ӫ����һ��  30  ʵ�������а���Ӫ
             '10' CBJY_COMP_KHTYPE, --�а���Ӫ��������  10 ҵ�����а�
             '' CBDY_XIEYI_CODE, ---�а�Э�����
             '1' IF_VALID, ---�Ƿ���Ч
             '' CREATE_USER,
             SYSDATE CREATE_DATE,
             '' UPDATE_USER,
             '' UPDATE_DATE,
             '813' PROVINCE_NO
        FROM MID_CBDY_AND_CHANNEL A
       WHERE A.AREA_NO = C1.AREA_NO
         AND A.FLAG = '1'
         AND CBDY_NO NOT IN (SELECT T.CBDY_NO
                               FROM   DIM.DIM_CBDY_DETAIL  T ---DIM.DIM_CBDY_DETAIL T
                              WHERE T.ZHIJU_TYPE = '2'
                                AND AREA_NO = C1.AREA_NO);
    COMMIT;



 UPDATE DIM.DIM_CBDY_DETAIL T
    SET T.IF_VALID =
        (SELECT IF_VALID
           FROM (SELECT NVL(A.IF_VALID, '0') IF_VALID, T.CBDY_NO
                   FROM DIM.DIM_CBDY_DETAIL T,
                        (SELECT DECODE(A.IF_VALID, '1', '1', '0') IF_VALID,
                                CBDY_NO
                           FROM DIM.DIM_CBDY_AND_CHANNEL A) A
                  WHERE T.ZHIJU_TYPE = '2'
                    AND T.AREA_NO = C1.AREA_NO
                    AND T.CBDY_NO = A.CBDY_NO(+)) A /*DIM.DIM_CBDY_AND_CHANNEL*/
          WHERE T.CBDY_NO = A.CBDY_NO)
      WHERE T.ZHIJU_TYPE = '2'
      AND T.AREA_NO =C1.AREA_NO;

 COMMIT;

  END LOOP;
   DELETE FROM DIM.DIM_USER_DINNER_FAVOUR_ID ;
   COMMIT;
   INSERT INTO DIM.DIM_USER_DINNER_FAVOUR_ID
    SELECT "USER_DINNER","USER_DINNER_DESC","DINNER_TYPE",
"FAVOUR_TYPE","IF_UP","ZLYX_JI","FAVOUR_ID","FAVOUR_NAME","FAVOUR_START","FAVOUR_END",
"DLYX_JI","LJL_ID","LJL_NAME","LEIJI_FEE","GU_DING","JF_UNIT","FULX_TYPE"
FROM DIM.DIM_USER_DINNER_FAVOUR_ID@HBODS /*DIM.DIM_USER_DINNER_FAVOUR_DEL*/;
COMMIT;


INSERT INTO DIM.DIM_SALE_MODE_NEW
SELECT * FROM DIM.DIM_SALE_MODE_NEW@HBODS  B
WHERE NOT EXISTS (SELECT 1 FROM DIM.DIM_SALE_MODE_NEW A
WHERE A.KIND = B.KIND);
COMMIT;


DELETE FROM DIM.DIM_PROJECT_INFO_T;
COMMIT;
INSERT INTO DIM.DIM_PROJECT_INFO_T
  SELECT PROJECT_ID,
         PROJECT_NAME,
         CITY_CODE,
         PROJECT_KIND,
         PROJECT_BUILD_KIND,
         STATUS,
         DEPARTMENT,
         BUILD_DATE,
         START_DATE,
         IF_PROPERTY,
         PROPERTY_ID,
         WORK_TEAM_ID,
         PARTNER,
         ACCEPT_PERSON,
         ACCEPT_DATE,
         NOTE,
         IF_VALID,
         IF_BELONG_DEALER,
         ACCESS_MAX_NUM,
         SHORT_NAME,
         BASIP_ADDRESS,
         BASIP_PORT_ID,
         ORDER_TYPE_ID,
         EFF_DATE,
         EXP_DATE,
         SETTLE_BEGIN_METHOD,
         DEVELOPER_DEALER,
         DEVELOPER,
         USER_PROP,
         CON_PROJECT_ID,
         PARTNER_ID,
         CONTRACT_ID,
         OPERATOR,
         OPERATE_DATE,
         REMARK
    FROM CRM_DSG.BB_PROJECT_INFO_T@HBODS T;
COMMIT;

---------------��������������չ���Ժ������ 2017��6��29��11:23:46 GUOJING ������Ǩ�� �������ݿ����һ�ݹ�ҵ֧ʹ��
DELETE FROM DIM.DIM_SALES_PROMOTION;
 COMMIT;

INSERT INTO DIM.DIM_SALES_PROMOTION
  SELECT T.PROMOTION_ID,
            A.PROMOTION_NAME,
            A.PROMOTION_TYPE,
            CASE WHEN A.PROMOTION_TYPE = '1' THEN '���'
                 WHEN A.PROMOTION_TYPE = '4' THEN  '����ȯ'
                 WHEN A.PROMOTION_TYPE = '5' THEN '����ת��'
            ELSE  NULL
            END, --1Ϊ���4Ϊ����ȯ5Ϊ����ת��
            A.EFF_DATE,
            A.EXP_DATE,

            MAX(CASE WHEN ITEM_ATTR_ID = 10011 THEN ATTR_VALUE / 100 ELSE 0 END)   RNETT_YJ_FEE, -- ���Ԥ����
            MAX(CASE WHEN ITEM_ATTR_ID = 10012 THEN ATTR_VALUE / 100 ELSE 0 END)   DEPOSIT_FEE, -- ���Ѻ��
            MAX(CASE WHEN ITEM_ATTR_ID = 10013 THEN ATTR_VALUE ELSE NULL END)      CONSUME_KIND, --������ѷ�ʽ
            MAX(CASE WHEN ITEM_ATTR_ID = 10501 THEN ATTR_VALUE / 100 ELSE 0 END)   PRESENT_FEE, --���ͽ��
            MAX(CASE WHEN ITEM_ATTR_ID = 10504 THEN ATTR_VALUE / 100 ELSE 0 END)   UNIT_FEE, --��ת�ƽ��
            MAX(CASE WHEN ITEM_ATTR_ID = 10505 THEN ATTR_VALUE / 100 ELSE 0 END)   FIRST_TRANS_FEE, --���»������,
            MAX(CASE WHEN ITEM_ATTR_ID = 10506 THEN ATTR_VALUE / 100 ELSE 0 END)   CN_XF_FEE, --�³�ŵ����,
            TO_NUMBER(MAX(CASE WHEN ITEM_ATTR_ID = 10508 THEN ATTR_VALUE  END))   CONSUM_NUM, --Э��������   ??
            MAX(CASE WHEN ITEM_ATTR_ID = 10509 THEN ATTR_VALUE / 100 ELSE 0 END)   CONSUME_FEE, --Э�����Ѷ��,
            MAX(CASE WHEN ITEM_ATTR_ID = 10510 THEN ATTR_VALUE / 100 ELSE 0 END)   CONSUME_AMOUNT, --Э�������ܶ�,
            MAX(CASE WHEN ITEM_ATTR_ID = 10511 THEN ATTR_VALUE / 100 ELSE 0 END)   BALANCE_FEE, --�������,
            MAX(CASE WHEN ITEM_ATTR_ID = 10512 THEN ATTR_VALUE ELSE NULL END)      TRANS_TYPE, --��������,
            MAX(CASE WHEN ITEM_ATTR_ID = 10513 THEN ATTR_VALUE ELSE NULL END)      RETURN_RATE, -- �·�������,
            MAX(CASE WHEN ITEM_ATTR_ID = 10514 THEN ATTR_VALUE ELSE NULL END)      ED_XZ, --���Ͷ������,
            MAX(CASE WHEN ITEM_ATTR_ID = 10515 THEN ATTR_VALUE / 100 ELSE 0 END)   DJ_FEE, --������,
            TO_NUMBER(MAX(CASE WHEN ITEM_ATTR_ID = 10516 THEN ATTR_VALUE END))      DJ_VALID_NUM, --������Ч��,
            MAX(CASE WHEN ITEM_ATTR_ID = 10517 THEN ATTR_VALUE ELSE NULL END)      TRANS_DX_FA, ---������������,
            MAX(CASE WHEN ITEM_ATTR_ID = 10600 THEN ATTR_VALUE ELSE NULL END)      PLAN_A_FLAG, --A�ƻ��ն˱�ʶ,
            MAX(CASE WHEN ITEM_ATTR_ID = 10602 THEN ATTR_VALUE ELSE NULL END)      IF_JF_FIRST, -- �����Ƿ��,
            MAX(CASE WHEN ITEM_ATTR_ID = 10603 THEN ATTR_VALUE ELSE NULL END)      FEE_DIVIDE, --���ѷֳɱ�ʶ,
            MAX(CASE WHEN ITEM_ATTR_ID = 10604 THEN ATTR_VALUE / 100 ELSE 0 END)   CREDIT_FEE, --�������ÿ��ƽ��,
            MAX(CASE WHEN ITEM_ATTR_ID = 10605 THEN ATTR_VALUE / 100 ELSE 0 END)   WRITE_OFF, --�����ʽ��,
            MAX(CASE WHEN ITEM_ATTR_ID = 10606 THEN ATTR_VALUE / 100 ELSE 0 END)   CURR_WRITE_OFF, --�����������˽��,
            MAX(CASE WHEN ITEM_ATTR_ID = 10607 THEN ATTR_VALUE ELSE NULL END)      PAY_RATE, -- ���˱���,
            MAX(CASE WHEN ITEM_ATTR_ID = 10608 THEN ATTR_VALUE ELSE NULL END)      PAY_RATE_BASE, ---��������,
            MAX(CASE WHEN ITEM_ATTR_ID = 10609 THEN ATTR_VALUE ELSE NULL END)      VARI_ID, --���ͷѳ�ַ�����ϱ��,
            MAX(CASE WHEN ITEM_ATTR_ID = 10610 THEN ATTR_VALUE ELSE NULL END)      SALE_TYPE, --��������,
            MAX(CASE WHEN ITEM_ATTR_ID = 20053 THEN ATTR_VALUE ELSE NULL END)      ZF_IF_JZ, --�����Ƿ��ת,
            MAX(CASE WHEN ITEM_ATTR_ID = 10611 THEN ATTR_VALUE ELSE NULL END)      ACCOUNT_TYPE_BJ, --�����˱�����,
            MAX(CASE WHEN ITEM_ATTR_ID = 10612 THEN ATTR_VALUE ELSE NULL END)      ZENGFEE_TYPE, --�����˱�����,
            MAX(CASE WHEN ITEM_ATTR_ID = 20060 THEN ATTR_VALUE ELSE NULL END)      ZUJJ_SHIYONG, --�������,
            MAX(CASE WHEN ITEM_ATTR_ID = 10613 THEN ATTR_VALUE / 100 ELSE 0 END)   TRANS_FEE_LAST, --ĩ�»������,
            MAX(CASE WHEN ITEM_ATTR_ID = 10614 THEN ATTR_VALUE ELSE NULL END)      IF_DIEJIA, --�������ӱ�ʶ,
            MAX(CASE WHEN ITEM_ATTR_ID = 20062 THEN ATTR_VALUE ELSE NULL END)      ART_ACCT_GROUP, --����ת���˵������,
            MAX(CASE WHEN ITEM_ATTR_ID = 20203 THEN ATTR_VALUE / 100 ELSE 0 END)   TERMINAL_FEE, --�ն˲������,
            MAX(CASE WHEN ITEM_ATTR_ID = 20204 THEN ATTR_VALUE / 100 ELSE 0 END)   SUBSIDY_FEE, --���Ѳ������,
            MAX(CASE WHEN ITEM_ATTR_ID = 20205 THEN ATTR_VALUE ELSE NULL END)      COST_SUBSIDY_RAT, --  �ɱ���������,
            MAX(CASE WHEN ITEM_ATTR_ID = 20206 THEN ATTR_VALUE ELSE NULL END)      CUST_TYPE, --�ͻ����
            MAX(CASE WHEN ITEM_ATTR_ID = 10500 THEN ATTR_VALUE / 100 ELSE 0 END)   YC_FISRT_FEE, ---һ����Ԥ������
            MAX(CASE WHEN ITEM_ATTR_ID = 20056 THEN ATTR_VALUE / 100 ELSE 0 END)   BT_JE, -- ��������
            MAX(CASE WHEN ITEM_ATTR_ID = 20000 THEN ATTR_VALUE ELSE NULL END)      JF_MODEL, -- �ɷѽ�����ģʽ
            MAX(CASE WHEN ITEM_ATTR_ID = 20004 THEN ATTR_VALUE ELSE NULL END)      XF_TYPE, -- ���洦����
            MAX(CASE WHEN ITEM_ATTR_ID = 20005 THEN ATTR_VALUE / 100 ELSE 0 END)   BJ_FEE, --�����ܶ�
            MAX(CASE WHEN ITEM_ATTR_ID = 20006 THEN ATTR_VALUE ELSE NULL END)      ACCOUNT_TYPE, -- �˱�����
            MAX(CASE WHEN ITEM_ATTR_ID = 20007 THEN ATTR_VALUE ELSE NULL END)      STAR_MONTH, -- ��������ʱ��
            TO_NUMBER(MAX(CASE WHEN ITEM_ATTR_ID = 20008 THEN ATTR_VALUE END))      YC_MONTH , --�ӳ�����
            MAX(CASE WHEN ITEM_ATTR_ID = 20009 THEN ATTR_VALUE ELSE NULL END)      IF_ZD , -- ����Ʒ������Ƿ����ת��
            MAX(CASE WHEN ITEM_ATTR_ID = 20010 THEN ATTR_VALUE ELSE NULL END)      NO_ZD_STATE , --��ת�ҵķ���״̬��
            MAX(CASE WHEN ITEM_ATTR_ID = 20011 THEN ATTR_VALUE ELSE NULL END)      ZJ_SJ , -- ��ת��ʱ��
            MAX(CASE WHEN ITEM_ATTR_ID = 20012 THEN ATTR_VALUE ELSE NULL END)      IF_XZ , --�Ƿ񴥷�����
            MAX(CASE WHEN ITEM_ATTR_ID = 20013 THEN ATTR_VALUE ELSE NULL END)      ED_JS_TYPE , -- ת�Ҷ�ȼ��㷽ʽ
            MAX(CASE WHEN ITEM_ATTR_ID = 20014 THEN ATTR_VALUE / 100 ELSE 0 END)   TRANS_FEE , -- ��ת�ҽ��
            MAX(CASE WHEN ITEM_ATTR_ID = 20015 THEN ATTR_VALUE / 100 ELSE 0 END)   LS_ZD_FEE_LIMIT , -- ��ʱת�Ҷ��
            MAX(CASE WHEN ITEM_ATTR_ID = 20016 THEN ATTR_VALUE ELSE NULL END)      ZD_RATE , --ת�ұ���
            MAX(CASE WHEN ITEM_ATTR_ID = 20017 THEN ATTR_VALUE ELSE NULL END)      RATE_ZD_GROUP , --  �����ʵ������
            MAX(CASE WHEN ITEM_ATTR_ID = 20018 THEN ATTR_VALUE ELSE NULL END)      IF_XF_ZD_GROUP , -- �Ƿ�ȡ�෴�ʵ������
            TO_NUMBER(MAX(CASE WHEN ITEM_ATTR_ID = 20019 THEN ATTR_VALUE  END))      BJ_MONTHS , -- ��������
            MAX(CASE WHEN ITEM_ATTR_ID = 20020 THEN ATTR_VALUE ELSE NULL END)      DQ_YE_CLFS , -- ��������ʽ
            MAX(CASE WHEN ITEM_ATTR_ID = 20025 THEN ATTR_VALUE ELSE NULL END)      AF_IF_ZD , ---Ƿ���Ƿ�ת��
            MAX(CASE WHEN ITEM_ATTR_ID = 20026 THEN ATTR_VALUE ELSE NULL END)      JQ_IF_BZ , -- ������Ƿ�ת
            MAX(CASE WHEN ITEM_ATTR_ID = 20029 THEN ATTR_VALUE ELSE NULL END)      FYZD_LEV , ---����ת�Ҽ���
            MAX(CASE WHEN ITEM_ATTR_ID = 20032 THEN ATTR_VALUE ELSE NULL END)      ZS_ALL_TYPE , -- �����ܶ���㷽��
            MAX(CASE WHEN ITEM_ATTR_ID = 20033 THEN ATTR_VALUE / 100 ELSE 0 END)   ZS_FEE_ALL , -- �����ͽ��
            MAX(CASE WHEN ITEM_ATTR_ID = 20034 THEN ATTR_VALUE ELSE NULL END)      ZF_START_MON , -- ��������ʱ��(Ԥ��)
            MAX(CASE WHEN ITEM_ATTR_ID = 20035 THEN ATTR_VALUE ELSE NULL END)      ZS_ZD_MON , -- ����ת��ʱ��
            MAX(CASE WHEN ITEM_ATTR_ID = 20036 THEN ATTR_VALUE ELSE NULL END)      ZS_ZD_ED , --����ת�Ҷ�ȼ��㷽ʽ
            MAX(CASE WHEN ITEM_ATTR_ID = 20037 THEN ATTR_VALUE / 100 ELSE 0 END)   GD_ZD_FEE , --�̶�ת�ҽ��
            MAX(CASE WHEN ITEM_ATTR_ID = 20038 THEN ATTR_VALUE / 100 ELSE 0 END)   LS_ZD_FEE , ---������ʱת�Ҷ��
            MAX(CASE WHEN ITEM_ATTR_ID = 20039 THEN ATTR_VALUE ELSE NULL END)      ZS_ZD_RATE , --����ת�ұ���
            MAX(CASE WHEN ITEM_ATTR_ID = 20040 THEN ATTR_VALUE ELSE NULL END)      ZS_ZD_GROUP , -- ���ͱ����ʵ������
            MAX(CASE WHEN ITEM_ATTR_ID = 20041 THEN ATTR_VALUE ELSE NULL END)      IF_NOSAME_ZDFZ , -- �Ƿ�ȡ�෴���ʵ������
            TO_NUMBER(MAX(CASE WHEN ITEM_ATTR_ID = 20043 THEN ATTR_VALUE  END))      ZS_MONTHS , -- ��������(Ԥ��)
            MAX(CASE WHEN ITEM_ATTR_ID = 20044 THEN ATTR_VALUE ELSE NULL END)      ZSYE_CLFS , -- �������ڴ���ʽ
            MAX(CASE WHEN ITEM_ATTR_ID = 20045 THEN ATTR_VALUE ELSE NULL END)      ZSQF_IF_ZD , -- ����Ƿ��ʱ�Ƿ�ת��
            MAX(CASE WHEN ITEM_ATTR_ID = 20046 THEN ATTR_VALUE ELSE NULL END)      ZSJQ_IF_BZ , --���ͽ�����Ƿ�ת
            MAX(CASE WHEN ITEM_ATTR_ID = 20047 THEN ATTR_VALUE ELSE NULL END)      ZS_EFF_DATE , -- �����˱�ǿ��ʧЧ����
            MAX(CASE WHEN ITEM_ATTR_ID = 20021 THEN ATTR_VALUE / 100 ELSE 0 END)   XY_FEE , --Э����
            TO_NUMBER(MAX(CASE WHEN ITEM_ATTR_ID = 20022 THEN ATTR_VALUE END))     XY_MONTH , -- Э������
            MAX(CASE WHEN ITEM_ATTR_ID = 20024 THEN ATTR_VALUE / 100 ELSE 0 END)   XYF_ZH , --Э��������
            MAX(CASE WHEN ITEM_ATTR_ID = 20031 THEN ATTR_VALUE ELSE NULL END)      ZS_ACCOUNT_TYPE  -- ����Ԥ���˱�����
          FROM CRM_DSG.SALES_PROMOTION_ITEM@HBODS T,
            CRM_DSG.SALES_PROMOTION@HBODS      A
      WHERE T.PROMOTION_ID = A.PROMOTION_ID
      GROUP BY T.PROMOTION_ID,
               A.PROMOTION_NAME,
               A.PROMOTION_TYPE,
               CASE WHEN A.PROMOTION_TYPE = '1' THEN '���'
                 WHEN A.PROMOTION_TYPE = '4' THEN
                  '����ȯ'
                 WHEN A.PROMOTION_TYPE = '5' THEN
                  '����ת��'
                 ELSE
                  NULL
               END, --1Ϊ���4Ϊ����ȯ5Ϊ����ת��
               A.EFF_DATE,
               A.EXP_DATE;
               COMMIT;


        --=============================== ����С���������ȡ��ɳ��ϵͳ�� ==========================  
      V_XQ_NUM := 0;
      V_XQ_NUM_2 := 0;
      
      SELECT COUNT(1)
        INTO V_XQ_NUM
        FROM STAGE.ITF_OTHER_HUAXIAO_XIAOQU@HBODS T
       WHERE T.DAY_ID = V_DATE
         AND T.SUBDISTRICT_ID IS NOT NULL;
      
      SELECT COUNT(1)
        INTO V_XQ_NUM_2
        FROM STAGE.ITF_OTHER_HUAXIAO_INFO@HBODS T
       WHERE T.DAY_ID = V_DATE;
      
      IF V_XQ_NUM > 80000 AND V_XQ_NUM_2 > 2000 THEN   
      --�����弶��ַ��С����Ӧ��ϵ�� 
      DELETE FROM ALLDMCODE.DMCODE_XIAOQU_STD_ADDR_NEW;
      COMMIT;
      
      INSERT INTO ALLDMCODE.DMCODE_XIAOQU_STD_ADDR_NEW
        SELECT DISTINCT T.SUBDISTRICT_ID,
                        T.SUBDISTRICT_NAME,
                        '',
                        T.ADDR1_NAME || '/' || T.ADDR2_NAME || '/' ||
                        T.ADDR3_NAME || '/' || T.ADDR4_NAME || '/' ||
                        T.ADDR5_NAME STDADDR_NAME,
                        T.SCHOOL_FLAG
          FROM STAGE.ITF_OTHER_HUAXIAO_XIAOQU@HBODS T
         WHERE T.DAY_ID = V_DATE
           AND T.SUBDISTRICT_ID IS NOT NULL;
      COMMIT;
      
      --���»�С��С����Ӧ��ϵ��
      DELETE FROM DIM.DIM_XIAOQU_HUAXIAO T;
      COMMIT;
      
      INSERT INTO DIM.DIM_XIAOQU_HUAXIAO
        SELECT DISTINCT AREA_NO,
                        CITY_NO,
                        T.SUBDISTRICT_ID,
                        T.SUBDISTRICT_NAME,
                        HUAXIAO_NO,
                        HUAXIAO_NAME,
                        HUAXIAO_TYPE,
                        HUAXIAO_TYPE_NAME,
                        IF_VALID,
                        UPDATE_USER,
                        TO_DATE(UPDATE_DATE, 'YYYYMMDDHH24MISS'),
                        IDX_NO,
                        HUAXIAO_TYPE_BIG,
                        HUAXIAO_TYPE_NAME_BIG
          FROM STAGE.ITF_OTHER_HUAXIAO_XIAOQU@HBODS T
         WHERE T.DAY_ID = V_DATE
           AND HUAXIAO_NO IS NOT NULL
           AND HUAXIAO_TYPE IN ('01','02','03','04');
      COMMIT;
      
      ---20180209 ����������������
    INSERT INTO DIM.DIM_XIAOQU_HUAXIAO
      SELECT *
        FROM DIM.DIM_ZQ_XIAOQU_HUAXIAO A
       WHERE NOT EXISTS (SELECT 1
                FROM DIM.DIM_XIAOQU_HUAXIAO B
               WHERE A.XIAOQU_NO = B.XIAOQU_NO);
           commit;

      
      --���»�С��Ϣ��
      DELETE FROM DIM.DIM_HUAXIAO_INFO T;
      COMMIT;
      
      INSERT INTO DIM.DIM_HUAXIAO_INFO
        SELECT distinct AREA_NO,
               CITY_NO,
               HUAXIAO_NO,
               HUAXIAO_NAME,
               HUAXIAO_TYPE,
               HUAXIAO_TYPE_NAME,
               IF_VALID,
               UPDATE_USER,
               TO_DATE(UPDATE_DATE, 'YYYYMMDDHH24MISS'),
               IDX_NO,
               CREATE_USER,
               TO_DATE(CREATE_DATE, 'YYYYMMDDHH24MISS'),
               HUAXIAO_TYPE_BIG,
               HUAXIAO_TYPE_NAME_BIG,
               MANAGER_LOGINID,
               MANAGER_LOGINNAME,
               MANAGER_TELEPHONE
          FROM STAGE.ITF_OTHER_HUAXIAO_INFO@HBODS T
         WHERE T.DAY_ID = V_DATE;
      COMMIT;
      
     --20180109 ���Ӻ�˻�С����
     INSERT INTO DIM.DIM_HUAXIAO_INFO
       SELECT AREA_NO,
              CITY_NO,
              HUAXIAO_NO,
              HUAXIAO_NAME,
              HUAXIAO_TYPE,
              HUAXIAO_TYPE_NAME,
              IF_VALID,
              UPDATE_USER,
              UPDATE_DATE,
              IDX_NO,
              CREATE_USER,
              CREATE_DATE,
              HUAXIAO_TYPE_BIG,
              HUAXIAO_TYPE_NAME_BIG,
              MANAGER_LOGINID,
              MANAGER_LOGINNAME,
              MANAGER_TELEPHONE
         FROM DIM.DIM_HD_HUAXIAO_INFO;
     COMMIT;
     
     ---20180209 ����������������
     INSERT INTO DIM.DIM_HUAXIAO_INFO
     SELECT AREA_NO,
            CITY_NO,
            HUAXIAO_NO,
            HUAXIAO_NAME,
            HUAXIAO_TYPE,
            HUAXIAO_TYPE_NAME,
            IF_VALID,
            UPDATE_USER,
            UPDATE_DATE,
            IDX_NO,
            CREATE_USER,
            CREATE_DATE,
            HUAXIAO_TYPE_BIG,
            HUAXIAO_TYPE_NAME_BIG,
            MANAGER_LOGINID,
            MANAGER_LOGINNAME,
            MANAGER_TELEPHONE
         FROM DIM.DIM_ZQ_HUAXIAO_INFO;
     COMMIT;
      
     --�뻮С��Ϣ�еĵ��С����ص���Ϣ����һ��
   UPDATE DIM.DIM_CHANNEL_HUAXIAO T
      SET T.AREA_NO     =
          (SELECT T2.AREA_NO
             FROM DIM.DIM_HUAXIAO_INFO T2
            WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO),
          T.CITY_NO     =
          (SELECT T2.CITY_NO
             FROM DIM.DIM_HUAXIAO_INFO T2
            WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO),
          T.HUAXIAO_NAME =
          (SELECT T2.HUAXIAO_NAME
             FROM DIM.DIM_HUAXIAO_INFO T2
            WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO),
          T.HUAXIAO_TYPE =
          (SELECT T2.HUAXIAO_TYPE
             FROM DIM.DIM_HUAXIAO_INFO T2
            WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO),
          
          T.HUAXIAO_TYPE_NAME =
          (SELECT T2.HUAXIAO_TYPE_NAME
             FROM DIM.DIM_HUAXIAO_INFO T2
            WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO),
          
          T.HUAXIAO_TYPE_BIG =
          (SELECT T2.HUAXIAO_TYPE_BIG
             FROM DIM.DIM_HUAXIAO_INFO T2
            WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO),
          
          T.HUAXIAO_TYPE_NAME_BIG =
          (SELECT T2.HUAXIAO_TYPE_NAME_BIG
             FROM DIM.DIM_HUAXIAO_INFO T2
            WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO),
          
          T.IF_VALID =
          (SELECT T2.IF_VALID
             FROM DIM.DIM_HUAXIAO_INFO T2
            WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO)
       WHERE EXISTS (SELECT 1
          FROM DIM.DIM_HUAXIAO_INFO T2
         WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO);
   COMMIT;
   
   --�뻮С��Ϣ�еĵ��С����ص���Ϣ����һ��
   UPDATE DIM.DIM_XIAOQU_HUAXIAO T
   
      SET T.AREA_NO =
          (SELECT T2.AREA_NO
             FROM DIM.DIM_HUAXIAO_INFO T2
            WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO),
          T.CITY_NO =
          (SELECT T2.CITY_NO
             FROM DIM.DIM_HUAXIAO_INFO T2
            WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO),
          
          T.HUAXIAO_NAME =
          (SELECT T2.HUAXIAO_NAME
             FROM DIM.DIM_HUAXIAO_INFO T2
            WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO),
          T.HUAXIAO_TYPE =
          (SELECT T2.HUAXIAO_TYPE
             FROM DIM.DIM_HUAXIAO_INFO T2
            WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO),
          
          T.HUAXIAO_TYPE_NAME =
          (SELECT T2.HUAXIAO_TYPE_NAME
             FROM DIM.DIM_HUAXIAO_INFO T2
            WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO),
          
          T.HUAXIAO_TYPE_BIG =
          (SELECT T2.HUAXIAO_TYPE_BIG
             FROM DIM.DIM_HUAXIAO_INFO T2
            WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO),
          
          T.HUAXIAO_TYPE_NAME_BIG =
          (SELECT T2.HUAXIAO_TYPE_NAME_BIG
             FROM DIM.DIM_HUAXIAO_INFO T2
            WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO),
          
          T.IF_VALID =
          (SELECT T2.IF_VALID
             FROM DIM.DIM_HUAXIAO_INFO T2
            WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO)
       WHERE EXISTS (SELECT 1
          FROM DIM.DIM_HUAXIAO_INFO T2
         WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO);
   COMMIT;
   
   --========================= ���ݱ� ==========================================
    --��С��Ϣ���ݱ�
    DELETE FROM DIM.DIM_HUAXIAO_INFO_DAY_BAK T WHERE DAY_ID = V_DATE;
    COMMIT;

    INSERT INTO DIM.DIM_HUAXIAO_INFO_DAY_BAK
      SELECT AREA_NO,
             CITY_NO,
             HUAXIAO_NO,
             HUAXIAO_NAME,
             HUAXIAO_TYPE,
             HUAXIAO_TYPE_NAME,
             IF_VALID,
             UPDATE_USER,
             UPDATE_DATE,
             IDX_NO,
             CREATE_USER,
             CREATE_DATE,
             HUAXIAO_TYPE_BIG,
             HUAXIAO_TYPE_NAME_BIG,
             MANAGER_LOGINID,
             MANAGER_LOGINNAME,
             MANAGER_TELEPHONE,
             V_DATE
        FROM DIM.DIM_HUAXIAO_INFO T;
    COMMIT;

    --�����뻮С��Ӧ��ϵ ���ݱ�
    DELETE FROM DIM.DIM_CHANNEL_HUAXIAO_DAY_BAK T WHERE DAY_ID = V_DATE;
    COMMIT;

    INSERT INTO DIM.DIM_CHANNEL_HUAXIAO_DAY_BAK
      SELECT AREA_NO,
             CITY_NO,
             CHANNEL_NO,
             CHANNEL_NO_DESC,
             HUAXIAO_NO,
             HUAXIAO_NAME,
             HUAXIAO_TYPE,
             HUAXIAO_TYPE_NAME,
             IF_VALID,
             UPDATE_USER,
             UPDATE_DATE,
             IDX_NO,
             HUAXIAO_TYPE_BIG,
             HUAXIAO_TYPE_NAME_BIG,
             V_DATE
        FROM DIM.DIM_CHANNEL_HUAXIAO T;
    COMMIT;

    --С���뻮С��Ӧ��ϵ ���ݱ�
    DELETE FROM DIM.DIM_XIAOQU_HUAXIAO_DAY_BAK T WHERE DAY_ID = V_DATE;
    COMMIT;

    INSERT INTO DIM.DIM_XIAOQU_HUAXIAO_DAY_BAK
      SELECT AREA_NO,
             CITY_NO,
             XIAOQU_NO,
             XIAOQU_NAME,
             HUAXIAO_NO,
             HUAXIAO_NAME,
             HUAXIAO_TYPE,
             HUAXIAO_TYPE_NAME,
             IF_VALID,
             UPDATE_USER,
             UPDATE_DATE,
             IDX_NO,
             HUAXIAO_TYPE_BIG,
             HUAXIAO_TYPE_NAME_BIG,
             V_DATE
        FROM DIM.DIM_XIAOQU_HUAXIAO T;
    COMMIT;
    
    --��׼��ַ��С����Ӧ��ϵ ���ݱ�
    DELETE FROM ALLDMCODE.DMCODE_XIAOQU_STD_ADDR_DAY_BAK T
     WHERE DAY_ID = V_DATE;
    COMMIT;

    INSERT INTO ALLDMCODE.DMCODE_XIAOQU_STD_ADDR_DAY_BAK
      SELECT XIAOQU_NO,
             XIAOQU_NAME,
             STDADDR_NO,
             STDADDR_NAME,
             SCHOOL_FLAG,
             V_DATE
        FROM ALLDMCODE.DMCODE_XIAOQU_STD_ADDR_NEW T;
    COMMIT;


  END IF;




----------##########################################################################################333

    --������־
    V_RETCODE := 'SUCCESS';
    DW.P_UPDATE_LOG(V_DATE, V_PKG, V_PROCNAME, '����', 'SUCCESS', SYSDATE);
  ELSE
    V_RETCODE := 'WAIT';
    DW.P_UPDATE_LOG(V_DATE, V_PKG, V_PROCNAME, '�ȴ�', 'WAIT', SYSDATE);
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    V_RETCODE := 'FAIL';
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
    V_RETINFO := SQLERRM;
    DW.P_UPDATE_LOG(V_DATE, V_PKG, V_PROCNAME, V_RETINFO, 'FAIL', SYSDATE);
END;
/
