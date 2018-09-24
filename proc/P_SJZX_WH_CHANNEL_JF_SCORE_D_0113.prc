CREATE OR REPLACE PROCEDURE RPT_HBTELE.P_SJZX_WH_CHANNEL_JF_SCORE_D(V_DATE    VARCHAR2,
                                                V_CESHI   VARCHAR2 := '1',
                                                V_RETCODE OUT VARCHAR2,
                                                V_RETINFO OUT VARCHAR2) IS

  /*-----------------------------------------------------------------------
  �������� P_SJZX_WH_CHANNEL_JF_SCORE_D
  �������ڣ�2018��1��2��
  ��д�ˣ�����
  ���ڣ���
  Ŀ���SJZX_WH_CHANNEL_JF_SCORE_D
  ����˵��������������ϵ��
  -----------------------------------------------------------------------*/

  ----------------------------1�������������-------------------------------

  V_PKG      VARCHAR2(40); --��־������������_��д�ˣ�
  V_PROCNAME VARCHAR2(40); --��־��������д��������
  V_FLAG     VARCHAR2(5); --�Ƿ��������
  /*CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018'; --�α�*/
  V_COUNT NUMBER; --�����ж�ǰ�ù����Ƿ��Ѿ�ִ��
  V_COUNT_2 NUMBER; --�����ж�ǰ�ù����Ƿ��Ѿ�ִ��

  ----------------------------1������������ֽ���----------------------------

  -----------------------------------�ָ���----------------------------------
BEGIN
  -----------------------------------�ָ���----------------------------------

  -------------------------------2��������ֵ---------------------------------

  V_PKG      := 'P_SJZX_WH'; --��־������ֵ
  V_PROCNAME := 'P_SJZX_WH_CHANNEL_JF_SCORE_D'; --��־������ֵ
  IF V_CESHI IS NULL THEN
    V_FLAG := 1; --���Ա�ʶ��ֵ
  ELSE
    V_FLAG := V_CESHI;
  END IF;

  -----------------------------2��������ֵ����-------------------------------

  -----------------------------3��д�뿪ʼ��־-------------------------------

  RPT_HBTELE.P_RPT_HBTELE_INSERT_LOG(V_DATE,
                                     V_PKG,
                                     V_PROCNAME,
                                     V_FLAG,
                                     SYSDATE,
                                     '����������ϵ');

  ---------------------------3��д�뿪ʼ��־����-----------------------------

  -------------------------4���ж�ǰ�ù����Ƿ�ִ��---------------------------

    SELECT COUNT(1)
      INTO V_COUNT
      FROM ALLDM.ALLDM_EXECUTE_LOG
     WHERE ACCT_MONTH = V_DATE
       AND PROCNAME IN ('P_INTEGRAL_SYS_DEVLP_JF_D')
       AND RESULT = 'SUCCESS';

    SELECT COUNT(1)
      INTO V_COUNT_2
      FROM DW.DW_EXECUTE_LOG
     WHERE ACCT_MONTH = V_DATE
       AND PROCNAME IN ('P_DW_V_USER_SCHOOL_HX_USER_D')
       AND RESULT = 'SUCCESS';

     IF V_COUNT >= 1 AND V_COUNT_2 >= 1 THEN

  -------------------------4���ж�ǰ�ù����Ƿ�ִ�н���------------------------

  ---------------------------------5����������--------------------------------

  -----------------------------------�������---------------------------------

  DELETE FROM RPT_HBTELE.SJZX_WH_CHANNEL_JF_SCORE_010_D A
   WHERE A.DAY_ID=V_DATE;

  COMMIT;



  ----------------------------------��ʽ���ݲ���------------------------------
INSERT INTO SJZX_WH_CHANNEL_JF_SCORE_010_D
  SELECT V_DATE,
         T2.AREA_NO,
         T2.CITY_NO,
         T2.ZHIJU_ID,
         T2.TOWN_NO,
         T2.BIZ_ZONE_ID,
         T2.BIZ_ZONE_NAME,
         T2.REGION_PROP_NO,
         T2.REGION_PROP_NAME,
         T2.REPORT_CHANNEL_KIND_NEW,
         T2.REPORT_CHANNEL_NAME_NEW,
         T2.AGENT_ID,
         T2.AGENT_NAME,
         T2.CHANNEL_NO,
         T2.CHANNEL_NAME,
         CASE
           WHEN T2.IF_VALID = '1' THEN
            '��Ч'
           ELSE
            '��Ч'
         END,
         SUM(CASE
               WHEN T1.JF_TYPE = '��չ����' THEN
                T1.JF_SCORE
               ELSE
                0
             END),
         SUM(CASE
               WHEN T1.JF_TYPE = '��չ����' AND T1.JF_CLASS = '�ƶ�����Ʒ' THEN
                T1.JF_SCORE
               ELSE
                0
             END),
         SUM(CASE
               WHEN T1.JF_TYPE = '��չ����' AND T1.JF_CLASS = '�ں�' THEN
                T1.JF_SCORE
               ELSE
                0
             END),
         SUM(CASE
               WHEN T1.JF_TYPE = '��չ����' AND T1.JF_CLASS = '������' THEN
                T1.JF_SCORE
               ELSE
                0
             END),
         SUM(CASE
               WHEN T1.JF_TYPE = '��չ����' THEN
                T1.JF_SCORE_SCHOOL
               ELSE
                0
             END),
         SUM(CASE
               WHEN T1.JF_TYPE = '��չ����' AND T1.JF_CLASS = '�ƶ�����Ʒ' THEN
                T1.JF_SCORE_SCHOOL
               ELSE
                0
             END),
         SUM(CASE
               WHEN T1.JF_TYPE = '��չ����' AND T1.JF_CLASS = '�ں�' THEN
                T1.JF_SCORE_SCHOOL
               ELSE
                0
             END),
         SUM(CASE
               WHEN T1.JF_TYPE = '��չ����' AND T1.JF_CLASS = '������' THEN
                T1.JF_SCORE_SCHOOL
               ELSE
                0
             END),
         T2.BEGIN_DATE
    FROM (SELECT A.CHANNEL_NO,
                 CASE
                   WHEN A.JF_TYPE = '1' THEN
                    '�ƶ�����Ʒ'
                   WHEN A.JF_TYPE = '2' THEN
                    '�ں�'
                   WHEN A.JF_TYPE = '3' THEN
                    '������'
                 END JF_CLASS,
                 '��չ����' JF_TYPE,
                 SUM(A.LOW_VALUE) JF_SCORE,
                 SUM(CASE
                       WHEN BB.USER_NO IS NOT NULL THEN
                        A.LOW_VALUE
                       ELSE
                        0
                     END) JF_SCORE_SCHOOL
            FROM ALLDM.INTEGRAL_SYS_DEVLP_JF_DETAIL A,
                 (SELECT BB.USER_NO
                    FROM DW.DW_V_USER_SCHOOL_HX_USER_D BB
                   WHERE BB.ACCT_MONTH = SUBSTR(V_DATE, 1, 6)
                     AND BB.DAY_ID = SUBSTR(V_DATE, 7, 2)) BB
           WHERE A.DAY_ID = V_DATE
             AND A.USER_NO = BB.USER_NO(+)
           GROUP BY A.CHANNEL_NO,
                    CASE
                      WHEN A.JF_TYPE = '1' THEN
                       '�ƶ�����Ʒ'
                      WHEN A.JF_TYPE = '2' THEN
                       '�ں�'
                      WHEN A.JF_TYPE = '3' THEN
                       '������'
                    END) T1,
         (SELECT T.*,
                 (CASE
                   WHEN T.CHANNEL_TYPE IN ('110101', '110102', '110103') THEN
                    '01'
                   WHEN SUBSTR(T.ZHIJU_ID, -4) <> '9999' AND
                        T.CHANNEL_TYPE NOT IN ('110101', '110102', '110103') THEN
                    '02'
                   WHEN (T.BUSI_ZONE_CHANGE IS NULL AND
                        T.BUSINESS_ZONE LIKE '20%') OR
                        (T.BUSI_ZONE_CHANGE IS NOT NULL AND
                        T.BIZ_ZONE_LEVEL IN ('10', '20', '30')) AND
                        T.CHANNEL_TYPE NOT IN ('110101', '110102', '110103') THEN
                    '03'
                   ELSE
                    '04'
                 END) REGION_PROP_NO,
                 (CASE
                   WHEN T.CHANNEL_TYPE IN ('110101', '110102', '110103') THEN
                    '��Ӫ��'
                   WHEN SUBSTR(T.ZHIJU_ID, -4) <> '9999' AND
                        T.CHANNEL_TYPE NOT IN ('110101', '110102', '110103') THEN
                    'ũ��'
                   WHEN (T.BUSI_ZONE_CHANGE IS NULL AND
                        T.BUSINESS_ZONE LIKE '20%') OR
                        (T.BUSI_ZONE_CHANGE IS NOT NULL AND
                        T.BIZ_ZONE_LEVEL IN ('10', '20', '30')) AND
                        T.CHANNEL_TYPE NOT IN ('110101', '110102', '110103') THEN
                    '��Ȧ'
                   ELSE
                    '����'
                 END) REGION_PROP_NAME,
                 CASE
                   WHEN T.CHANNEL_TYPE IN ('110101', '110102', '110103') AND
                        SUBSTR(T.CHANNEL_TYPE, 1, 2) = '11' THEN
                    '005'
                   WHEN T.CHANNEL_TYPE IN ('110201') AND
                        SUBSTR(T.CHANNEL_TYPE, 1, 2) = '11' THEN
                    '1100'
                   WHEN T.CHANNEL_TYPE IN ('110301') AND
                        SUBSTR(T.CHANNEL_TYPE, 1, 2) = '11' THEN
                    '001'
                   WHEN T.CHANNEL_TYPE IN ('110302') AND
                        SUBSTR(T.CHANNEL_TYPE, 1, 2) = '11' THEN
                    '002'
                   WHEN (T.CHANNEL_TYPE NOT IN
                        ('110101',
                          '110102',
                          '110103',
                          '110201',
                          '110301',
                          '110302') OR T.CHANNEL_TYPE IS NULL) AND
                        SUBSTR(T.CHANNEL_TYPE, 1, 2) = '11' AND
                        T.PROTOP10 IN ('1', '2') THEN
                    '003'
                   WHEN (T.CHANNEL_TYPE NOT IN
                        ('110101',
                          '110102',
                          '110103',
                          '110201',
                          '110301',
                          '110302') OR T.CHANNEL_TYPE IS NULL) AND
                        SUBSTR(T.CHANNEL_TYPE, 1, 2) = '11' AND
                        (T.PROTOP10 NOT IN ('1', '2') OR T.PROTOP10 IS NULL) THEN
                    '004'
                   ELSE
                    ''
                 END REPORT_CHANNEL_KIND_NEW,
                 CASE
                   WHEN T.CHANNEL_TYPE IN ('110101', '110102', '110103') AND
                        SUBSTR(T.CHANNEL_TYPE, 1, 2) = '11' THEN
                    '��Ӫ��'
                   WHEN T.CHANNEL_TYPE IN ('110201') AND
                        SUBSTR(T.CHANNEL_TYPE, 1, 2) = '11' THEN
                    'רӪ��'
                   WHEN T.CHANNEL_TYPE IN ('110301') AND
                        SUBSTR(T.CHANNEL_TYPE, 1, 2) = '11' THEN
                    '��������'
                   WHEN T.CHANNEL_TYPE IN ('110302') AND
                        SUBSTR(T.CHANNEL_TYPE, 1, 2) = '11' THEN
                    'ʡ������'
                   WHEN (T.CHANNEL_TYPE NOT IN
                        ('110101',
                          '110102',
                          '110103',
                          '110201',
                          '110301',
                          '110302') OR T.CHANNEL_TYPE IS NULL) AND
                        SUBSTR(T.CHANNEL_TYPE, 1, 2) = '11' AND
                        T.PROTOP10 IN ('1', '2') THEN
                    'ʡ��TOP'
                   WHEN (T.CHANNEL_TYPE NOT IN
                        ('110101',
                          '110102',
                          '110103',
                          '110201',
                          '110301',
                          '110302') OR T.CHANNEL_TYPE IS NULL) AND
                        SUBSTR(T.CHANNEL_TYPE, 1, 2) = '11' AND
                        (T.PROTOP10 NOT IN ('1', '2') OR T.PROTOP10 IS NULL) THEN
                    '��С��Ӫ'
                   ELSE
                    ''
                 END REPORT_CHANNEL_NAME_NEW
            FROM RPT_HBTELE.DM_BUSI_CHANNEL_BUILD_D T
           WHERE ACCT_MONTH = SUBSTR(V_DATE, 1, 6)
             AND DAY_ID = SUBSTR(V_DATE, 7, 2)
             AND SUBSTR(T.CHANNEL_TYPE, 1, 2) = '11') T2
   WHERE T1.CHANNEL_NO = T2.CHANNEL_NO
   GROUP BY V_DATE,
            T2.AREA_NO,
            T2.CITY_NO,
            T2.ZHIJU_ID,
            T2.TOWN_NO,
            T2.BIZ_ZONE_ID,
            T2.BIZ_ZONE_NAME,
            T2.REGION_PROP_NO,
            T2.REGION_PROP_NAME,
            T2.REPORT_CHANNEL_KIND_NEW,
            T2.REPORT_CHANNEL_NAME_NEW,
            T2.AGENT_ID,
            T2.AGENT_NAME,
            T2.CHANNEL_NO,
            T2.CHANNEL_NAME,
            CASE
              WHEN T2.IF_VALID = '1' THEN
               '��Ч'
              ELSE
               '��Ч'
            END,
            T2.BEGIN_DATE;
COMMIT;

  -------------------------------5���������Ľ���------------------------------

  ---------------------------6���������Ľ���������־--------------------------

  V_RETCODE := 'SUCCESS';
  RPT_HBTELE.P_RPT_HBTELE_UPDATE_LOG(V_DATE,
                                     V_PKG,
                                     V_PROCNAME,
                                     '����',
                                     V_RETCODE,
                                     SYSDATE);

  -------------------------6���������Ľ���������־����-------------------------

  -----------------------7��ǰ�ù���δִ��д����־����Ҫ��---------------------

   ELSE
     V_RETCODE := 'WAIT';
     RPT_HBTELE.P_RPT_HBTELE_UPDATE_LOG
     (V_DATE, V_PKG, V_PROCNAME, '�ȴ�', 'WAIT', SYSDATE);
   END IF;

  -----------------=---7��ǰ�ù���δִ��д����־����Ҫ������--------------------

  ------------------------------8�����̱��������־-----------------------------
EXCEPTION
  WHEN OTHERS THEN
    V_RETCODE := 'FAIL';
    V_RETINFO := SQLERRM;
    RPT_HBTELE.P_RPT_HBTELE_UPDATE_LOG(V_DATE,
                                       V_PKG,
                                       V_PROCNAME,
                                       V_RETINFO,
                                       V_RETCODE,
                                       SYSDATE);

  ----------------------------8�����̱��������־����---------------------------

END;
---------------------------------���̽���-------------------------------------
/
