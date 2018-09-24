CREATE OR REPLACE PROCEDURE DW.P_TMP_V_USER_HUAXIAO_INFO_ALL(V_ACCT_MONTH VARCHAR2,
                                                       V_RETCODE    OUT VARCHAR2,
                                                       V_RETINFO    OUT VARCHAR2) IS
  /*-------------------------------------------------------------------------------------------
     �� �� �� : �û���С��Ϣ�±�
     ����ʱ�� ��2017.10.30
     �� д �� ����ռ��
     �������� ��ÿ��ִ��
     ִ��ʱ�� :
     ʹ�ò��� ���·�
     �޸ļ�¼ ��
  -----------------------------------------------------------------------------------------------*/
  V_PROCNAME   VARCHAR2(40);
  V_PKG        VARCHAR2(40);
  V_CNT        NUMBER;
  ROWLINE      NUMBER := 0;
  V_LAST_MONTH VARCHAR2(40);

  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018';

BEGIN

  V_PKG      := '�û���С��Ϣ�±�';
  V_PROCNAME := 'P_DW_V_USER_HUAXIAO_INFO_ALL';

  V_LAST_MONTH := TO_CHAR(ADD_MONTHS(TO_DATE(V_ACCT_MONTH, 'YYYYMM'), -1),
                          'YYYYMM');

  --��־����
  P_INSERT_LOG(V_ACCT_MONTH, V_PKG, V_PROCNAME, '12', SYSDATE);

  SELECT COUNT(1)
    INTO V_CNT
    FROM DW_EXECUTE_LOG
   WHERE ACCT_MONTH = V_ACCT_MONTH
     AND PROCNAME IN ('P_DW_V_USER_BASE_INFO_USER','P_DW_V_USER_COMMISION_LIST','P_DW_V_USER_THREE_ARREAR')
     AND RESULT = 'SUCCESS';

  IF V_CNT = 3 THEN

    --���ݲ���
    FOR C1 IN V_AREA LOOP

      --�����ں��û���ʵ�塿
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_ST_V_USER_HUAXIAO_M';
      INSERT INTO MID_ST_V_USER_HUAXIAO_M
        SELECT /*+ORDERED*/
         V_ACCT_MONTH ACCT_MONTH,
         A.AREA_NO,
         A.USER_NO,
         A.DEVICE_NUMBER,
         A.TELE_TYPE,
         A.IS_ONNET,
         A.BUNDLE_ID,
         E.XIAOQU_NO,
         E.XIAOQU_NAME,
         E.HUAXIAO_NO,
         E.HUAXIAO_NAME,
         E.HUAXIAO_TYPE,
         E.HUAXIAO_TYPE_NAME,
         BUNDLE_DINNER_BEG_DATE 
          FROM (SELECT AREA_NO,
                       CITY_NO,
                       USER_NO,
                       DEVICE_NUMBER,
                       CHANNEL_NO,
                       CHANNEL_NO_DESC,
                       IS_KD_BUNDLE,
                       TELE_TYPE,
                       NVL(BUNDLE_ID_ALLOWANCE, BUNDLE_ID) AS BUNDLE_ID,
                       IS_ONNET,
                       BUNDLE_DINNER_BEG_DATE
                  FROM DW.DW_V_USER_BASE_INFO_USER T
                 WHERE ACCT_MONTH = V_ACCT_MONTH
                   AND AREA_NO = C1.AREA_NO
                   AND TELE_TYPE <> '2'
                   AND NVL(IS_KD_BUNDLE, '0') <> '0') A,

               (SELECT USER_NO,
                       T.GRADE_0 || '/' || T.GRADE_1 || '/' || T.GRADE_2 || '/' ||
                       T.GRADE_3 || '/' || T.GRADE_4 STDADDR_NAME
                  FROM DW.DW_V_USER_ADSL_EIGHT_M T
                 WHERE ACCT_MONTH = V_ACCT_MONTH
                   AND T.AREA_NO = C1.AREA_NO
                   AND USER_NO IS NOT NULL) B,

               (SELECT * FROM ALLDMCODE.DMCODE_XIAOQU_STD_ADDR_NEW) C,

               ��SELECT * FROM  DIM.DIM_XIAOQU_HUAXIAO WHERE HUAXIAO_TYPE IN ('01','02','03','04')) E  --ʵ�� 
         WHERE A.USER_NO = B.USER_NO(+)
           AND B.STDADDR_NAME = C.STDADDR_NAME(+)
           AND C.XIAOQU_NO = E.XIAOQU_NO(+);


      --�����ں��û�������
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_ZQ_V_USER_HUAXIAO_M';
      INSERT INTO MID_ZQ_V_USER_HUAXIAO_M
        SELECT /*+ORDERED*/
         V_ACCT_MONTH ACCT_MONTH,
         A.AREA_NO,
         A.USER_NO,
         A.DEVICE_NUMBER,
         A.TELE_TYPE,
         A.IS_ONNET,
         A.BUNDLE_ID,
         E.XIAOQU_NO,
         E.XIAOQU_NAME,
         E.HUAXIAO_NO,
         E.HUAXIAO_NAME,
         E.HUAXIAO_TYPE,
         E.HUAXIAO_TYPE_NAME,
         BUNDLE_DINNER_BEG_DATE 
          FROM (SELECT AREA_NO,
                       CITY_NO,
                       USER_NO,
                       DEVICE_NUMBER,
                       CHANNEL_NO,
                       CHANNEL_NO_DESC,
                       IS_KD_BUNDLE,
                       TELE_TYPE,
                       NVL(BUNDLE_ID_ALLOWANCE, BUNDLE_ID) AS BUNDLE_ID,
                       IS_ONNET,
                       BUNDLE_DINNER_BEG_DATE
                  FROM DW.DW_V_USER_BASE_INFO_USER T
                 WHERE ACCT_MONTH = V_ACCT_MONTH
                   AND AREA_NO = C1.AREA_NO
                   AND TELE_TYPE <> '2'
                   AND NVL(IS_KD_BUNDLE, '0') <> '0') A,

               (SELECT USER_NO,
                       T.GRADE_0 || '/' || T.GRADE_1 || '/' || T.GRADE_2 || '/' ||
                       T.GRADE_3 || '/' || T.GRADE_4 STDADDR_NAME
                  FROM DW.DW_V_USER_ADSL_EIGHT_M T
                 WHERE ACCT_MONTH = V_ACCT_MONTH
                   AND T.AREA_NO = C1.AREA_NO
                   AND USER_NO IS NOT NULL) B,

               (SELECT * FROM ALLDMCODE.DMCODE_XIAOQU_STD_ADDR_NEW) C,

               DIM.DIM_ZQ_XIAOQU_HUAXIAO E  --ʵ�� 
         WHERE A.USER_NO = B.USER_NO(+)
           AND B.STDADDR_NAME = C.STDADDR_NAME(+)
           AND C.XIAOQU_NO = E.XIAOQU_NO(+);

      --�������û�
      --EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_ZQ_V_USER_HUAXIAO_IOT';
      DELETE FROM MID_ZQ_V_USER_HUAXIAO_IOT T
       WHERE T.ACCT_MONTH = V_ACCT_MONTH
         AND AREA_NO = C1.AREA_NO;
      COMMIT;
      INSERT INTO MID_ZQ_V_USER_HUAXIAO_IOT
        SELECT A.AREA_NO, A.USER_NO, SUM(A.PRICE_FEE), V_ACCT_MONTH
          FROM (SELECT *
                  FROM DW.DW_V_USER_CHARGE_MONTH T
                 WHERE ACCT_MONTH = V_ACCT_MONTH
                   AND AREA_NO = C1.AREA_NO) A,

               (SELECT * FROM ACCT_DSG.BF_DDOS_ITEM_RELA_T@HBODS T) B

         WHERE A.CHARGE_CODE = B.FEE_ID
         GROUP BY A.AREA_NO, A.USER_NO;
      COMMIT;
      
      --ʵ��
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_ST_V_USER_HUAXIAO_M_PLUS';
      INSERT INTO MID_ST_V_USER_HUAXIAO_M_PLUS
        SELECT ACCT_MONTH,
               AREA_NO,
               USER_NO,
               DEVICE_NUMBER,
               TELE_TYPE,
               IS_ONNET,
               BUNDLE_ID,
               XIAOQU_NO,
               XIAOQU_NAME,
               HUAXIAO_NO,
               HUAXIAO_NAME,
               HUAXIAO_TYPE,
               HUAXIAO_TYPE_NAME,
               RN
          FROM (SELECT A.*,
                       ROW_NUMBER() OVER(PARTITION BY BUNDLE_ID ORDER BY(CASE
                         WHEN TELE_TYPE IN
                              ('4',
                               '26') THEN
                          1
                         WHEN TELE_TYPE = '72' THEN
                          2
                         ELSE
                          3
                       END), BUNDLE_DINNER_BEG_DATE DESC) RN
                  FROM MID_ST_V_USER_HUAXIAO_M A)
         WHERE RN = 1;
      COMMIT;
      
      --����
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_ZQ_V_USER_HUAXIAO_M_PLUS';
      INSERT INTO MID_ZQ_V_USER_HUAXIAO_M_PLUS
        SELECT ACCT_MONTH,
               AREA_NO,
               USER_NO,
               DEVICE_NUMBER,
               TELE_TYPE,
               IS_ONNET,
               BUNDLE_ID,
               XIAOQU_NO,
               XIAOQU_NAME,
               HUAXIAO_NO,
               HUAXIAO_NAME,
               HUAXIAO_TYPE,
               HUAXIAO_TYPE_NAME,
               RN
          FROM (SELECT A.*,
                       ROW_NUMBER() OVER(PARTITION BY BUNDLE_ID ORDER BY(CASE
                         WHEN TELE_TYPE IN
                              ('4',
                               '26') THEN
                          1
                         WHEN TELE_TYPE = '72' THEN
                          2
                         ELSE
                          3
                       END), BUNDLE_DINNER_BEG_DATE DESC) RN
                  FROM MID_ZQ_V_USER_HUAXIAO_M A)
         WHERE RN = 1;
      COMMIT;
      
      --�����׼��ַ��ϸ��
       EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_HUAXIAO_KD_ADDR';
      INSERT INTO MID_HUAXIAO_KD_ADDR
        SELECT USER_NO,
         T.GRADE_0 || '/' || T.GRADE_1 || '/' || T.GRADE_2 || '/' ||
         T.GRADE_3 || '/' || T.GRADE_4 STDADDR_NAME
        FROM DW.DW_V_USER_ADSL_EIGHT_M T
       WHERE ACCT_MONTH = V_ACCT_MONTH
         AND T.AREA_NO = C1.AREA_NO
         AND USER_NO IS NOT NULL;
         COMMIT;
         
      --���»�С������Ϣ��
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_HUAXIAO_INFO_LM';
      insert into MID_HUAXIAO_INFO_LM
      SELECT USER_NO, XIAOQU_NO, XIAOQU_NAME
              FROM DW_V_USER_HUAXIAO_INFO_ALL G
             WHERE ACCT_MONTH = V_LAST_MONTH
               AND AREA_NO = C1.AREA_NO;
               COMMIT;

      --У԰��
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_HUAXIAO_SCHOOL_USER';
      INSERT INTO MID_HUAXIAO_SCHOOL_USER
      SELECT USER_NO
              FROM DW.DW_V_USER_SCHOOL_HX_USER_M T
             WHERE ACCT_MONTH = V_ACCT_MONTH
               AND T.AREA_NO = C1.AREA_NO;
               COMMIT;
               
    --Ƿ���ֿ���
    EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_ZQ_V_USER_HUAXIAO_QFKZ';
    INSERT INTO MID_ZQ_V_USER_HUAXIAO_QFKZ
    SELECT USER_ID, SUM(ARREAR_FEE) ARREAR_FEE
      FROM (SELECT AREA_NO, USER_ID, NVL(ARREAR_FEE, 0)ARREAR_FEE
              FROM DW.DW_V_USER_THREE_ARREAR A
             WHERE ACCT_MONTH = V_ACCT_MONTH
               AND FEE_DATE > = '200810'
               AND AREA_NO = C1.AREA_NO
            UNION ALL
            SELECT AREA_NO, USER_ID, NVL(ARREAR_FEE, 0) * (-1)
              FROM DW.DW_V_USER_THREE_ARREAR A
             WHERE ACCT_MONTH = V_LAST_MONTH
               AND AREA_NO = C1.AREA_NO
               AND FEE_DATE > = '200810')
     GROUP BY USER_ID;
    COMMIT;

    --��Ŀ�ֳ�
    EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_ZQ_V_USER_HUAXIAO_XMFC';
    INSERT INTO MID_ZQ_V_USER_HUAXIAO_XMFC
      SELECT USER_NO, SUM(NVL(B.CHARGE, 0))
        FROM DW.DW_V_USER_COMMISION_XMFC B
       WHERE ACCT_MONTH = V_ACCT_MONTH
         AND IF_PROJECT = '1'
         AND AREA_NO = C1.AREA_NO
       GROUP BY USER_NO;
    COMMIT;

    --�����̿���ϸ������18��1��3��������
    EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_ZQ_HUAXIAO_SK';
    INSERT INTO  MID_ZQ_HUAXIAO_SK
      SELECT B.AREA_NO, A.HUAXIAO_NO, A.DEVICE_NUMBER, A.USER_NO,B.HUAXIAO_NAME
        FROM (SELECT A.*, ROW_NUMBER() OVER(PARTITION BY A.USER_NO ORDER BY 1) RN
                FROM V_ZQ_HUAXIAO_SK_MX A
                WHERE AREA_NO = C1.AREA_NO)A,
                DIM.DIM_HUAXIAO_INFO B
       WHERE RN = 1
       AND A.HUAXIAO_NO = B.HUAXIAO_NO;
       COMMIT;

    --����Ӫά��Ԫ��ϸ������18��1��3��������
    EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_ZQ_HUAXIAO_YW';
   INSERT INTO MID_ZQ_HUAXIAO_YW
     SELECT B.AREA_NO, A.HUAXIAO_NO, A.USER_NO, B.HUAXIAO_NAME
       FROM (SELECT A.*,
                    ROW_NUMBER() OVER(PARTITION BY A.USER_NO ORDER BY 1) RN
               FROM V_ZQ_HUAXIAO_YW_MX A
              WHERE AREA_NO = C1.AREA_NO) A,
            DIM.DIM_HUAXIAO_INFO B
      WHERE RN = 1
        AND A.HUAXIAO_NO = B.HUAXIAO_NO;
         COMMIT;

     
     --��չ��ͳ��
     EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_ZQ_HUAXIAO_DEVELOP';
     INSERT INTO MID_ZQ_HUAXIAO_DEVELOP
      SELECT A.USER_NO,
             A.DEVELOP_NO,
             B.HUAXIAO_NO,
             B.HUAXIAO_NAME,
             B.HUAXIAO_TYPE
        FROM (SELECT USER_NO, DEVELOP_NO
                FROM DW.DW_V_USER_MOBILEUSER A
               WHERE ACCT_MONTH = V_ACCT_MONTH
                 AND AREA_NO = C1.AREA_NO
              UNION ALL
              SELECT USER_NO, DEVELOP_NO
                FROM DW.DW_V_USER_MOBILEUSER_OCS_M A
               WHERE ACCT_MONTH = V_ACCT_MONTH
                 AND AREA_NO = C1.AREA_NO) A,
             (SELECT CHANNEL_NO, HUAXIAO_NO, HUAXIAO_NAME, HUAXIAO_TYPE
                FROM DIM.DIM_ZQ_CHANNEL_HUAXIAO where  IS_DEVELOPER='1') B
       WHERE A.DEVELOP_NO = B.CHANNEL_NO;
       commit;
   
      ---------------------------- ����ʽ��д������ -------------------------------------
      EXECUTE IMMEDIATE 'ALTER TABLE DW_V_USER_HUAXIAO_INFO_ALL TRUNCATE SUBPARTITION PART' ||
                        SUBSTR(V_ACCT_MONTH, 1, 6) || '_SUBPART_' ||
                        C1.AREA_NO;

  INSERT /*+APPEND*/
  INTO DW_V_USER_HUAXIAO_INFO_ALL
    SELECT /*+ORDERED*/
     V_ACCT_MONTH,
     A.AREA_NO,
     A.CITY_NO,
     A.TELE_TYPE,
     A.USER_NO,
     A.CUSTOMER_NO,
     A.ACCOUNT_NO,
     A.DEVICE_NUMBER,
     A.INNET_DATE,
     A.USER_DINNER,
     A.CHANNEL_NO,
     A.CHANNEL_NO_DESC,
     A.GROUP_NO,
     A.IS_ONNET,
     A.IS_NEW,
     A.IS_ACTIVE,
     A.IS_CALL,
     A.USER_STATUS,
     A.LOGOUT_DATE,
     A.IS_LOGOUT,
     A.IS_OUTNET,
     A.IS_VALID,
     A.RECENT_STOP_DATE,
     A.IS_OCS,
     A.IS_ACCT,
     A.IS_ACCT_OCS,
     A.INNET_MONTH,
     A.INNET_METHOD,
     A.BUNDLE_ID,
     A.IS_KD_BUNDLE,
     CASE
       WHEN A.TELE_TYPE = '2' AND A.IS_KD_BUNDLE = '0' AND
            G.XIAOQU_NO IS NOT NULL THEN
        G.XIAOQU_NO
       ELSE
        coalesce(E.XIAOQU_NO, F.XIAOQU_NO,E3.XIAOQU_NO,F1.XIAOQU_NO)
     END, --20171030 ��ռ���޸ģ��������ںϵ�C���û���¼��С������
     CASE
       WHEN A.TELE_TYPE = '2' AND A.IS_KD_BUNDLE = '0' AND
            G.XIAOQU_NO IS NOT NULL THEN
        G.XIAOQU_NAME
       ELSE
        coalesce(E.XIAOQU_NAME, F.XIAOQU_NAME,E3.XIAOQU_NAME,F1.XIAOQU_NAME)
     END, --20171030 ��ռ���޸ģ��������ںϵ�C���û���¼��С������
     A.TOTAL_FEE,
     A.TOTAL_FEE_OCS,
     A.PRICE_FEE,
     A.PRICE_FEE_OCS,
     CASE
       WHEN A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
            D1.HUAXIAO_TYPE = '01' THEN
        '1'
       ELSE
        '0'
     END IS_HUAXIAO_01, --��Ӫ��ȫ��������������(������������ר�ߵ�·)
     
     CASE
       WHEN A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
            D2.HUAXIAO_TYPE = '02' THEN
        '1'
       ELSE
        '0'
     END IS_HUAXIAO_02, --��Ȧ֧��ȫ��������������(������������ר�ߵ�·)
     
     CASE
       WHEN B2.USER_NO IS NULL AND
            A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
            A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
            G.XIAOQU_NO IS NOT NULL AND G1.HUAXIAO_TYPE = '03' THEN
        '1' --�����ںϽ����û��������ǰ����ں�ʱ����װ����ַ   20171120 ��ռ���޸ģ�����ȡ�����û�
     
       WHEN B2.USER_NO IS NULL AND
            A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
            A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
            D3.HUAXIAO_TYPE = '03' AND D1.HUAXIAO_TYPE IS NULL AND
            D2.HUAXIAO_TYPE IS NULL AND G.XIAOQU_NO IS NULL THEN
        '1' --��C
       WHEN B2.USER_NO IS NULL AND
            A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
            A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2' AND
            E1.HUAXIAO_TYPE = '03' THEN
        '1' --����
       WHEN B2.USER_NO IS NULL AND
            A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
            F.HUAXIAO_TYPE = '03' THEN
        '1' --�ں�
       ELSE
        '0'
     END IS_HUAXIAO_03, --�Ƿ�����֧��-������(������������ר�ߵ�·)
     
     CASE
       WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
            G.XIAOQU_NO IS NOT NULL AND G2.HUAXIAO_TYPE = '04' AND
            A.TELE_TYPE_NAME IN
            ('�ƶ�', '���', '����', '�̻�', 'ר��', '��·') THEN
        '1' --�����ںϽ����û��������ǰ����ں�ʱ����װ����ַ   20171120 ��ռ���޸ģ�����ȡ�����û�
     
       WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
            D4.HUAXIAO_TYPE = '04' AND D1.HUAXIAO_TYPE IS NULL AND
            D2.HUAXIAO_TYPE IS NULL AND G.XIAOQU_NO IS NULL AND
            A.TELE_TYPE_NAME IN
            ('�ƶ�', '���', '����', '�̻�', 'ר��', '��·') THEN
        '1' --��C
       WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2' AND
            E2.HUAXIAO_TYPE = '04' AND
            A.TELE_TYPE_NAME IN
            ('�ƶ�', '���', '����', '�̻�', 'ר��', '��·') THEN
        '1' --����
       WHEN F.HUAXIAO_TYPE = '04' AND
            A.TELE_TYPE_NAME IN
            ('�ƶ�', '���', '����', '�̻�', 'ר��', '��·') THEN
        '1' --�ں�
       ELSE
        '0'
     END IS_HUAXIAO_04, --�Ƿ�ũ��֧��-������(������������ר�ߵ�·)
     
     CASE
       WHEN J1.USER_NO IS NOT NULL THEN
        '1'  --����
       WHEN A.IS_XINXING='1' AND D5.HUAXIAO_TYPE='05' THEN 
        '1' --�̿�֧�ֵ�����ҵ��Ӧ�ð���������չ�˴��
       WHEN A.IS_XINXING<>'1' AND A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND G.XIAOQU_NO IS NOT NULL AND G4.HUAXIAO_TYPE = '05' THEN
        '1' --�����ںϽ����û��������ǰ����ں�ʱ����װ����ַ
       when A.IS_XINXING<>'1' AND ((A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND D5.HUAXIAO_TYPE = '05' AND G.XIAOQU_NO IS NULL) or 
         (A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND J3.HUAXIAO_TYPE = '05' AND G.XIAOQU_NO IS NULL)) THEN
        '1' --��C
       when A.IS_XINXING<>'1' AND A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2'  AND E3.HUAXIAO_TYPE = '05' THEN
        '1'  --����
       when A.IS_XINXING<>'1' AND F1.HUAXIAO_TYPE = '05' THEN
        '1' --�ں�
       ELSE
        '0'
     END IS_HUAXIAO_05, --�Ƿ��̿�����-������
     CASE
       WHEN J2.USER_NO IS NOT NULL THEN
        '1' --����
        WHEN J3.USER_NO IS NOT NULL and j3.huaxiao_type='06' THEN
        '1' --����
       ELSE
        '0'
     END IS_HUAXIAO_06, --�Ƿ��嵥�ͻ�-������
     CASE
       WHEN D7.CHANNEL_NO IS NOT NULL THEN
        '1'
       ELSE
        '0'
     END IS_HUAXIAO_07, --�Ƿ�У԰�а�-������
     CASE
       WHEN D8.HUAXIAO_NO IS NOT NULL THEN
        '1'
       ELSE
        '0'
     END IS_HUAXIAO_08, --�Ƿ�����ҵ��������ר����-������
     CASE
       WHEN A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
            D1.HUAXIAO_TYPE = '01' THEN
        D1.HUAXIAO_NO
     END HUAXIAO_NO_01, --��������СID
     
     CASE
       WHEN A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
            D2.HUAXIAO_TYPE = '02' THEN
        D2.HUAXIAO_NO
     END HUAXIAO_NO_02, --��Ȧ֧�ֻ�СID
     
     CASE
       WHEN B2.USER_NO IS NULL AND
            A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
            A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
            G.XIAOQU_NO IS NOT NULL AND G1.HUAXIAO_TYPE = '03' THEN
        G1.HUAXIAO_NO --�����ںϽ����û��������ǰ����ں�ʱ����װ����ַ   20171120 ��ռ���޸ģ�����ȡ�����û�
     
       WHEN B2.USER_NO IS NULL AND
            A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
            A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
            D3.HUAXIAO_TYPE = '03' AND D1.HUAXIAO_TYPE IS NULL AND
            D2.HUAXIAO_TYPE IS NULL AND G.XIAOQU_NO IS NULL THEN
        D3.HUAXIAO_NO --��C
       WHEN B2.USER_NO IS NULL AND
            A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
            A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2' AND
            E1.HUAXIAO_TYPE = '03' THEN
        E1.HUAXIAO_NO --����
       WHEN B2.USER_NO IS NULL AND
            A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
            F.HUAXIAO_TYPE = '03' THEN
        F.HUAXIAO_NO --�ں�
     END HUAXIAO_NO_03, --����֧�ֻ�СID
     
     CASE
       WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
            G.XIAOQU_NO IS NOT NULL AND G2.HUAXIAO_TYPE = '04' AND
            A.TELE_TYPE_NAME IN
            ('�ƶ�', '���', '����', '�̻�', 'ר��', '��·') THEN
        G2.HUAXIAO_NO --�����ںϽ����û��������ǰ����ں�ʱ����װ����ַ   20171120 ��ռ���޸ģ�����ȡ�����û�
     
       WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
            D4.HUAXIAO_TYPE = '04' AND D1.HUAXIAO_TYPE IS NULL AND
            D2.HUAXIAO_TYPE IS NULL AND G.XIAOQU_NO IS NULL AND
            A.TELE_TYPE_NAME IN
            ('�ƶ�', '���', '����', '�̻�', 'ר��', '��·') THEN
        D4.HUAXIAO_NO --��C
       WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2' AND
            E2.HUAXIAO_TYPE = '04' AND
            A.TELE_TYPE_NAME IN
            ('�ƶ�', '���', '����', '�̻�', 'ר��', '��·') THEN
        E2.HUAXIAO_NO --����
       WHEN F.HUAXIAO_TYPE = '04' AND
            A.TELE_TYPE_NAME IN
            ('�ƶ�', '���', '����', '�̻�', 'ר��', '��·') THEN
        F.HUAXIAO_NO --�ں�
     END HUAXIAO_NO_04, --ũ��֧�ֻ�СID

     CASE
       WHEN J1.USER_NO IS NOT NULL THEN
        J1.HUAXIAO_NO  --����
       WHEN A.IS_XINXING='1' AND D5.HUAXIAO_TYPE='05' THEN 
        D5.HUAXIAO_NO --�̿�֧�ֵ�����ҵ��Ӧ�ð���������չ�˴��
       WHEN A.IS_XINXING<>'1' AND A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND G.XIAOQU_NO IS NOT NULL AND G4.HUAXIAO_TYPE = '05' THEN
        G4.HUAXIAO_NO --�����ںϽ����û��������ǰ����ں�ʱ����װ����ַ
       when A.IS_XINXING<>'1' AND ((A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND D5.HUAXIAO_TYPE = '05' AND G.XIAOQU_NO IS NULL) or 
         (A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND J3.HUAXIAO_TYPE = '05' AND G.XIAOQU_NO IS NULL)) THEN
        D5.HUAXIAO_NO --��C
       when A.IS_XINXING<>'1' AND A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2'  AND E3.HUAXIAO_TYPE = '05' THEN
        E3.HUAXIAO_NO  --����
       when A.IS_XINXING<>'1' AND F1.HUAXIAO_TYPE = '05' THEN
        F1.Huaxiao_No--�ں� 
        END HUAXIAO_NO_05, --�̿�����СID 
        
      CASE WHEN J2.HUAXIAO_NO IS NOT NULL THEN 
        J2.HUAXIAO_NO
        WHEN j3.Huaxiao_Type='06' THEN 
        j3.Huaxiao_no
        end HUAXIAO_NO_06�� --�嵥�ͻ���СID 
        
     D7.HUAXIAO_NO AS HUAXIAO_NO_07, --У԰�а���СID
     D8.HUAXIAO_NO AS HUAXIAO_NO_08, --����ҵ��������ר������СID
     
     CASE
       WHEN A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
            D1.HUAXIAO_TYPE = '01' THEN
        D1.HUAXIAO_NAME
     END HUAXIAO_NAME_01, --��������СID
     
     CASE
       WHEN A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
            D2.HUAXIAO_TYPE = '02' THEN
        D2.HUAXIAO_NAME
     END HUAXIAO_NAME_02, --��Ȧ֧�ֻ�СID
     
     CASE
       WHEN B2.USER_NO IS NULL AND
            A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
            A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
            G.XIAOQU_NO IS NOT NULL AND G1.HUAXIAO_TYPE = '03' THEN
        G1.HUAXIAO_NAME --�����ںϽ����û��������ǰ����ں�ʱ����װ����ַ   20171120 ��ռ���޸ģ�����ȡ�����û�
     
       WHEN B2.USER_NO IS NULL AND
            A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
            A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
            D3.HUAXIAO_TYPE = '03' AND D1.HUAXIAO_TYPE IS NULL AND
            D2.HUAXIAO_TYPE IS NULL AND G.XIAOQU_NO IS NULL THEN
        D3.HUAXIAO_NAME --��C
       WHEN B2.USER_NO IS NULL AND
            A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
            A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2' AND
            E1.HUAXIAO_TYPE = '03' THEN
        E1.HUAXIAO_NAME --����
       WHEN B2.USER_NO IS NULL AND
            A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
            F.HUAXIAO_TYPE = '03' THEN
        F.HUAXIAO_NAME --�ں�
     END HUAXIAO_NAME_03, --����֧�ֻ�СID
     
     CASE
       WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
            G.XIAOQU_NO IS NOT NULL AND G2.HUAXIAO_TYPE = '04' AND
            A.TELE_TYPE_NAME IN
            ('�ƶ�', '���', '����', '�̻�', 'ר��', '��·') THEN
        G2.HUAXIAO_NAME --�����ںϽ����û��������ǰ����ں�ʱ����װ����ַ  20171120 ��ռ���޸ģ�����ȡ�����û�
     
       WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
            D4.HUAXIAO_TYPE = '04' AND D1.HUAXIAO_TYPE IS NULL AND
            D2.HUAXIAO_TYPE IS NULL AND G.XIAOQU_NO IS NULL AND
            A.TELE_TYPE_NAME IN
            ('�ƶ�', '���', '����', '�̻�', 'ר��', '��·') THEN
        D4.HUAXIAO_NAME --��C
       WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2' AND
            E2.HUAXIAO_TYPE = '04' AND
            A.TELE_TYPE_NAME IN
            ('�ƶ�', '���', '����', '�̻�', 'ר��', '��·') THEN
        E2.HUAXIAO_NAME --����
       WHEN F.HUAXIAO_TYPE = '04' AND
            A.TELE_TYPE_NAME IN
            ('�ƶ�', '���', '����', '�̻�', 'ר��', '��·') THEN
        F.HUAXIAO_NAME --�ں�
     END HUAXIAO_NAME_04, --ũ��֧�ֻ�СID

     CASE
       WHEN J1.USER_NO IS NOT NULL THEN
        J1.HUAXIAO_NAME  --����
       WHEN A.IS_XINXING='1' AND D5.HUAXIAO_TYPE='05' THEN 
        D5.HUAXIAO_NAME --�̿�֧�ֵ�����ҵ��Ӧ�ð���������չ�˴��
       WHEN A.IS_XINXING='1' AND A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND G.XIAOQU_NO IS NOT NULL AND G4.HUAXIAO_TYPE = '05' THEN
        G4.HUAXIAO_NAME --�����ںϽ����û��������ǰ����ں�ʱ����װ����ַ
       when A.IS_XINXING='1' AND ((A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND D5.HUAXIAO_TYPE = '05' AND G.XIAOQU_NO IS NULL) or 
         (A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND J3.HUAXIAO_TYPE = '05' AND G.XIAOQU_NO IS NULL)) THEN
        D5.HUAXIAO_NAME --��C
       when A.IS_XINXING='1' AND A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2'  AND E3.HUAXIAO_TYPE = '05' THEN
        E3.HUAXIAO_NAME  --����
       when A.IS_XINXING='1' AND F1.HUAXIAO_TYPE = '05' THEN
        F1.HUAXIAO_NAME--�ں� 
        END HUAXIAO_NAME_05, --�̿�����С����
        
      CASE WHEN J2.HUAXIAO_NAME IS NOT NULL THEN 
        J2.HUAXIAO_NAME
        WHEN j3.Huaxiao_Type='06' THEN 
        j3.HUAXIAO_NAME
        end HUAXIAO_NAME_06�� --�嵥�ͻ���С����  
        
     D7.HUAXIAO_NAME AS HUAXIAO_NAME_07, --У԰�а���СID
     D8.HUAXIAO_NAME AS HUAXIAO_NAME_08, --����ҵ��������ר������СID
     A.BUNDLE_ID_ALLOWANCE,
     A.ALL_JF_FLUX,
     A.WIFI_JF_FLUX,
     A.JF_TIMES,
     A.TERMINAL_TYPE,
     A.TERMINAL_CORP,
     A.TELE_TYPE_NEW,
     A.IS_3NO_ADJUST,
     NVL(G3.IOT_FEE, 0),
     CASE
       WHEN B2.USER_NO IS NOT NULL THEN
        '1'
       ELSE
        '0'
     END IS_SCHOOL_USER, --�Ƿ�У԰�û�
     CASE
       WHEN A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
            D1.HUAXIAO_TYPE = '01' THEN
        '1'
       ELSE
        '0'
     END IS_SCHOOL_01, --�Ƿ���Ӫ��У԰
     
     CASE
       WHEN A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
            D2.HUAXIAO_TYPE = '02' THEN
        '1'
       ELSE
        '0'
     END IS_SCHOOL_02, --�Ƿ���ȦУ԰
     
     CASE
       WHEN B2.USER_NO IS NULL AND
            A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
            A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
            G.XIAOQU_NO IS NOT NULL AND G1.HUAXIAO_TYPE = '03' THEN
        '1'
     
       WHEN B2.USER_NO IS NULL AND
            A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
            A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
            D3.HUAXIAO_TYPE = '03' AND D1.HUAXIAO_TYPE IS NULL AND
            D2.HUAXIAO_TYPE IS NULL AND G.XIAOQU_NO IS NULL THEN
        '1' --��C
       WHEN B2.USER_NO IS NOT NULL AND
            A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
            A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2' AND
            E1.HUAXIAO_TYPE = '03' THEN
        '1' --����
       WHEN B2.USER_NO IS NOT NULL AND
            A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
            F.HUAXIAO_TYPE = '03' THEN
        '1' --�ں�
       ELSE
        '0'
     END IS_SCHOOL_03, --�Ƿ�����У԰
     case
       when A.TELE_TYPE_NAME = '�ƶ�' then
        H1.ARREAR_FEE * (1 - 0.0764)
       else
        H1.ARREAR_FEE * (1 - 0.0681)
     end as ARREAR_FEE,
     case
       when A.TELE_TYPE_NAME = '�ƶ�' then
        H2.XMFC * (1 - 0.0764)
       else
        H2.XMFC * (1 - 0.0681)
     end as XMFC,
     A.IS_KD_BUNDLE_NEW,
     A.PRODUCT_ID,
     A.SERVICE_START_DATE,
     A.BUNDLE_USER_DINNER,
     A.BUNDLE_USER_DINNER_DESC,
     A.USER_DINNER_DESC,
     A.TELE_TYPE_NAME, --ҵ������
     A.IS_ICT, --�Ƿ�ICT
     A.IS_XINXING --�Ƿ�����ҵ�񣨲�����������
      FROM (SELECT A.AREA_NO,
                   A.CITY_NO,
                   A.TELE_TYPE,
                   A.USER_NO,
                   A.CUSTOMER_NO,
                   A.ACCOUNT_NO,
                   A.DEVICE_NUMBER,
                   A.INNET_DATE,
                   A.USER_DINNER,
                   A.CHANNEL_NO,
                   A.CHANNEL_NO_DESC,
                   A.GROUP_NO,
                   A.IS_ONNET,
                   A.IS_NEW,
                   A.IS_ACTIVE,
                   A.IS_CALL,
                   A.USER_STATUS,
                   A.LOGOUT_DATE,
                   A.IS_LOGOUT,
                   A.IS_OUTNET,
                   A.IS_VALID,
                   A.RECENT_STOP_DATE,
                   A.IS_OCS,
                   A.IS_ACCT,
                   A.IS_ACCT_OCS,
                   A.INNET_MONTH,
                   A.INNET_METHOD,
                   NVL(BUNDLE_ID_ALLOWANCE, BUNDLE_ID) BUNDLE_ID,
                   A.IS_KD_BUNDLE,
                   A.TOTAL_FEE,
                   A.TOTAL_FEE_OCS,
                   A.PRICE_FEE,
                   A.PRICE_FEE_OCS,
                   A.BUNDLE_ID_ALLOWANCE,
                   A.ALL_JF_FLUX,
                   A.WIFI_JF_FLUX,
                   A.JF_TIMES,
                   A.TERMINAL_TYPE,
                   A.TERMINAL_CORP,
                   A.TELE_TYPE_NEW,
                   A.IS_3NO_ADJUST,
                   A.IS_KD_BUNDLE_NEW,
                   A.PRODUCT_ID,
                   A.SERVICE_START_DATE,
                   A.BUNDLE_USER_DINNER,
                   A.BUNDLE_USER_DINNER_DESC,
                   A.USER_DINNER_DESC,
                   TELE_TYPE_NAME, --ҵ������
                   IS_ICT, --�Ƿ�ICT
                   CASE
                     WHEN TELE_TYPE_NAME = '��Ӧ��' OR IS_ICT = '1'  THEN
                      '1'
                     ELSE
                      '0'
                   END IS_XINXING --�Ƿ�����ҵ�񣨲�����������
              FROM (SELECT A.AREA_NO,
                           A.CITY_NO,
                           A.TELE_TYPE,
                           A.USER_NO,
                           A.CUSTOMER_NO,
                           A.ACCOUNT_NO,
                           A.DEVICE_NUMBER,
                           A.INNET_DATE,
                           A.USER_DINNER,
                           A.CHANNEL_NO,
                           A.CHANNEL_NO_DESC,
                           A.GROUP_NO,
                           A.IS_ONNET,
                           A.IS_NEW,
                           A.IS_ACTIVE,
                           A.IS_CALL,
                           A.USER_STATUS,
                           A.LOGOUT_DATE,
                           A.IS_LOGOUT,
                           A.IS_OUTNET,
                           A.IS_VALID,
                           A.RECENT_STOP_DATE,
                           A.IS_OCS,
                           A.IS_ACCT,
                           A.IS_ACCT_OCS,
                           A.INNET_MONTH,
                           A.INNET_METHOD,
                           A.BUNDLE_ID,
                           A.IS_KD_BUNDLE,
                           --A.XIAOQU_NO,
                           --A.XIAOQU_NAME,
                           A.TOTAL_FEE,
                           A.TOTAL_FEE_OCS,
                           A.PRICE_FEE,
                           A.PRICE_FEE_OCS,
                           A.BUNDLE_ID_ALLOWANCE,
                           A.ALL_JF_FLUX,
                           A.WIFI_JF_FLUX,
                           A.JF_TIMES,
                           A.TERMINAL_TYPE,
                           A.TERMINAL_CORP,
                           A.TELE_TYPE_NEW,
                           A.IS_3NO_ADJUST,
                           A.IS_KD_BUNDLE_NEW,
                           A.PRODUCT_ID,
                           A.SERVICE_START_DATE,
                           A.BUNDLE_USER_DINNER,
                           A.BUNDLE_USER_DINNER_DESC,
                           A.USER_DINNER_DESC,
                           CASE
                             WHEN A.TELE_TYPE = '2' THEN
                              '�ƶ�'
                             WHEN B.SERVICE_CLASS IN ('���') THEN
                              '���'
                             WHEN B.SERVICE_CLASS IN ('���ŵ���') THEN
                              '����'
                             WHEN B.SERVICE_CLASS IN ('�̻�') THEN
                              '�̻�'
                             WHEN B.SERVICE_CLASS IN ('ר��') THEN
                              'ר��'
                             WHEN B.SERVICE_CLASS IN ('��·') THEN
                              '��·'
                             WHEN B.SERVICE_CLASS IN ('��Ӧ��') THEN
                              '��Ӧ��'
                             WHEN B.SERVICE_CLASS IN ('IDC') THEN
                              'IDC'
                             WHEN B.SERVICE_CLASS IN ('�豸����') THEN
                              '�豸����'
                             ELSE
                              '����'
                           END TELE_TYPE_NAME,
                           CASE
                             WHEN C.PRODUCT_ID IS NOT NULL THEN
                              '1'
                             ELSE
                              '0'
                           END IS_ICT
                      FROM DW.DW_V_USER_BASE_INFO_USER           A,
                           ACCT_DSG.BRPT_SERVICE_KIND_TELE@HBODS B,
                           RPT_HBTELE.SJZX_WH_ICT_PRODUCT_ID     C
                     WHERE A.ACCT_MONTH = V_ACCT_MONTH
                       AND A.AREA_NO = C1.AREA_NO
                       AND A.PRODUCT_ID = B.PRODUCT_ID(+)
                       AND A.PRODUCT_ID = C.PRODUCT_ID(+)) A) A,
           
            MID_HUAXIAO_KD_ADDR B,
           
           MID_HUAXIAO_SCHOOL_USER B2,
           
           (SELECT * FROM ALLDMCODE.DMCODE_XIAOQU_STD_ADDR_NEW) C,
           
           (SELECT * FROM DIM.DIM_CHANNEL_HUAXIAO WHERE HUAXIAO_TYPE = '01') D1, --��Ӫ��
           (SELECT * FROM DIM.DIM_CHANNEL_HUAXIAO WHERE HUAXIAO_TYPE = '02') D2, --��Ȧ֧��
           (SELECT * FROM DIM.DIM_CHANNEL_HUAXIAO WHERE HUAXIAO_TYPE = '03') D3, --����֧��
           (SELECT * FROM DIM.DIM_CHANNEL_HUAXIAO WHERE HUAXIAO_TYPE = '04') D4, --ũ��֧�� 
           (SELECT * FROM DIM.DIM_ZQ_CHANNEL_HUAXIAO WHERE HUAXIAO_TYPE = '05') D5, --����֧��
            DIM.DIM_ZQ_GROUP_HUAXIAO D7, --����У԰
            (SELECT * FROM DIM.DIM_HUAXIAO_INFO A WHERE A.HUAXIAO_TYPE = '08') D8, --����������
           
           (SELECT * FROM DIM.DIM_XIAOQU_HUAXIAO) E, --С���뻮С��Ӧ��ϵ��
           
           (SELECT * FROM DIM.DIM_XIAOQU_HUAXIAO WHERE HUAXIAO_TYPE = '03') E1, --����֧��
           (SELECT * FROM DIM.DIM_XIAOQU_HUAXIAO WHERE HUAXIAO_TYPE = '04') E2, --ũ��֧��
           DIM.DIM_ZQ_XIAOQU_HUAXIAO E3, --�����̿�
           
           MID_ST_V_USER_HUAXIAO_M_PLUS F, --�ںϿ���û���ʵ��������
           MID_ST_V_USER_HUAXIAO_M_PLUS F1, --�ںϿ���û�������������
           
           MID_HUAXIAO_INFO_LM G, --���³���Ļ�����
           
           (SELECT * FROM DIM.DIM_XIAOQU_HUAXIAO WHERE HUAXIAO_TYPE = '03') G1, --����֧��
           (SELECT * FROM DIM.DIM_XIAOQU_HUAXIAO WHERE HUAXIAO_TYPE = '04') G2, --ũ��֧��
           DIM.DIM_ZQ_XIAOQU_HUAXIAO G4, --�����̿�
           
           (SELECT T.USER_NO, T.IOT_FEE, AREA_NO
              FROM MID_ZQ_V_USER_HUAXIAO_IOT T
             WHERE T.ACCT_MONTH = V_ACCT_MONTH
               AND T.AREA_NO = C1.AREA_NO) G3, --�������û�
           MID_ZQ_V_USER_HUAXIAO_QFKZ H1, --Ƿ�ѿ���
           MID_ZQ_V_USER_HUAXIAO_XMFC H2, --��Ŀ�ֳ�
           MID_ZQ_HUAXIAO_SK J1, --�̿͡�������
           MID_ZQ_HUAXIAO_YW J2, --Ӫά��������
           MID_ZQ_HUAXIAO_DEVELOP J3 --�̿ͷ�չ��/Ӫά��������
     WHERE A.USER_NO = B.USER_NO(+)
       AND B.STDADDR_NAME = C.STDADDR_NAME(+)
       AND A.USER_NO = B2.USER_NO(+)
       AND A.CHANNEL_NO = D1.CHANNEL_NO(+)
       AND A.CHANNEL_NO = D2.CHANNEL_NO(+)
       AND A.CHANNEL_NO = D3.CHANNEL_NO(+)
       AND A.CHANNEL_NO = D4.CHANNEL_NO(+)
       AND A.CHANNEL_NO = D5.CHANNEL_NO(+)
       AND C.XIAOQU_NO = E.XIAOQU_NO(+)
       AND C.XIAOQU_NO = E1.XIAOQU_NO(+)
       AND C.XIAOQU_NO = E2.XIAOQU_NO(+)
       AND C.XIAOQU_NO = E3.XIAOQU_NO(+)
       AND A.BUNDLE_ID = F.BUNDLE_ID(+)
       AND A.BUNDLE_ID = F1.BUNDLE_ID(+)
       AND A.USER_NO = G.USER_NO(+)
       AND G.XIAOQU_NO = G1.XIAOQU_NO(+)
       AND G.XIAOQU_NO = G2.XIAOQU_NO(+)
       AND G.XIAOQU_NO = G4.XIAOQU_NO(+)
       AND A.USER_NO = G3.USER_NO(+)
       AND A.USER_NO = H1.USER_ID(+)
       AND A.USER_NO = H2.USER_ID(+)
       AND A.USER_NO = J1.USER_NO(+)
       AND A.USER_NO = J2.USER_NO(+)
       AND A.USER_NO = J3.USER_NO(+)
       AND A.GROUP_NO = D7.CHANNEL_NO(+)
       AND G3.AREA_NO = D8.AREA_NO(+);
  ROWLINE := SQL%ROWCOUNT;
  COMMIT;

      --д�������¼��
      DELETE FROM DW_EXECUTE_LST T
       WHERE T.ACCT_MONTH = V_ACCT_MONTH
         AND T.AREA = C1.AREA_NO
         AND T.PROCNAME = V_PROCNAME;
      COMMIT;
      INSERT INTO DW_EXECUTE_LST
        (ACCT_MONTH,
         PROCNAME,
         SERVICE_CODE,
         TARGETTABLE,
         AREA,
         DESCRIBE,
         ENDTIME,
         RESULT,
         ROW_NUM)
      VALUES
        (V_ACCT_MONTH,
         V_PROCNAME,
         '2',
         SUBSTR(V_PROCNAME, 3),
         C1.AREA_NO,
         'INSERT',
         SYSDATE,
         'SUCCESS',
         ROWLINE);
      COMMIT;

    END LOOP;

    --������־
    V_RETCODE := 'SUCCESS';
    P_UPDATE_LOG(V_ACCT_MONTH,
                 V_PKG,
                 V_PROCNAME,
                 '����',
                 'SUCCESS',
                 SYSDATE);
  ELSE
    V_RETCODE := 'WAIT';
    P_UPDATE_LOG(V_ACCT_MONTH, V_PKG, V_PROCNAME, '�ȴ�', 'WAIT', SYSDATE);
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    V_RETCODE := 'FAIL';
    V_RETINFO := SQLERRM;
    P_UPDATE_LOG(V_ACCT_MONTH,
                 V_PKG,
                 V_PROCNAME,
                 V_RETINFO,
                 'FAIL',
                 SYSDATE);
END;
/
