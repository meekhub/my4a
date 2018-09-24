CREATE OR REPLACE PROCEDURE DW.P_DW_V_USER_HUAXIAO_INFO_M(V_ACCT_MONTH VARCHAR2,
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
  V_PROCNAME := 'P_DW_V_USER_HUAXIAO_INFO_M';

  V_LAST_MONTH := TO_CHAR(ADD_MONTHS(TO_DATE(V_ACCT_MONTH, 'YYYYMM'), -1),
                          'YYYYMM');

  --��־����
  P_INSERT_LOG(V_ACCT_MONTH, V_PKG, V_PROCNAME, '12', SYSDATE);

  SELECT COUNT(1)
    INTO V_CNT
    FROM DW_EXECUTE_LOG
   WHERE ACCT_MONTH = V_ACCT_MONTH
     AND PROCNAME IN ('P_DW_V_USER_BASE_INFO_USER')
     AND RESULT = 'SUCCESS';

  IF V_CNT = 1 THEN
  
    --���ݲ���
    FOR C1 IN V_AREA LOOP
    
      --ȡ���¹����ں��û�
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_DW_V_USER_HUAXIAO_M';
      INSERT INTO MID_DW_V_USER_HUAXIAO_M
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
         E.HUAXIAO_TYPE_NAME
        
          FROM (SELECT AREA_NO,
                       CITY_NO,
                       USER_NO,
                       DEVICE_NUMBER,
                       CHANNEL_NO,
                       CHANNEL_NO_DESC,
                       IS_KD_BUNDLE,
                       TELE_TYPE,
                       NVL(BUNDLE_ID_ALLOWANCE, BUNDLE_ID) AS BUNDLE_ID,
                       IS_ONNET
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
               
               DIM.DIM_XIAOQU_HUAXIAO E
        
         WHERE A.USER_NO = B.USER_NO(+)
           AND B.STDADDR_NAME = C.STDADDR_NAME(+)
           AND C.XIAOQU_NO = E.XIAOQU_NO(+);
    
      --�������û�
      --EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_DW_V_USER_HUAXIAO_IOT';
      DELETE FROM MID_DW_V_USER_HUAXIAO_IOT T
       WHERE T.ACCT_MONTH = V_ACCT_MONTH
         AND AREA_NO = C1.AREA_NO;
      COMMIT;
      INSERT INTO MID_DW_V_USER_HUAXIAO_IOT
        SELECT A.AREA_NO, A.USER_NO, SUM(A.PRICE_FEE), V_ACCT_MONTH
          FROM (SELECT *
                  FROM DW.DW_V_USER_CHARGE_MONTH T
                 WHERE ACCT_MONTH = V_ACCT_MONTH
                   AND AREA_NO = C1.AREA_NO) A,
               
               (SELECT * FROM ACCT_DSG.BF_DDOS_ITEM_RELA_T@HBODS T) B
        
         WHERE A.CHARGE_CODE = B.FEE_ID
         GROUP BY A.AREA_NO, A.USER_NO;
      COMMIT;
    
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_DW_V_USER_HUAXIAO_M_PLUS';
      INSERT INTO MID_DW_V_USER_HUAXIAO_M_PLUS
        SELECT *
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
                       END)) RN
                  FROM MID_DW_V_USER_HUAXIAO_M A)
         WHERE RN = 1;
      COMMIT;
    
      ---------------------------- ����ʽ��д������ -------------------------------------
      EXECUTE IMMEDIATE 'ALTER TABLE DW_V_USER_HUAXIAO_INFO_M TRUNCATE SUBPARTITION PART' ||
                        SUBSTR(V_ACCT_MONTH, 1, 6) || '_SUBPART_' ||
                        C1.AREA_NO;
    
      INSERT INTO DW_V_USER_HUAXIAO_INFO_M
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
            NVL(E.XIAOQU_NO, F.XIAOQU_NO)
         END, --20171030 ��ռ���޸ģ��������ںϵ�C���û���¼��С������
         CASE
           WHEN A.TELE_TYPE = '2' AND A.IS_KD_BUNDLE = '0' AND
                G.XIAOQU_NO IS NOT NULL THEN
            G.XIAOQU_NAME
           ELSE
            NVL(E.XIAOQU_NAME, F.XIAOQU_NAME)
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
           WHEN B2.USER_NO IS NULL AND A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
                A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
                G.XIAOQU_NO IS NOT NULL AND G1.HUAXIAO_TYPE = '03' THEN
            '1' --�����ںϽ����û��������ǰ����ں�ʱ����װ����ַ   20171120 ��ռ���޸ģ�����ȡ�����û�
         
           WHEN B2.USER_NO IS NULL AND A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
                A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
                D3.HUAXIAO_TYPE = '03' AND D1.HUAXIAO_TYPE IS NULL AND
                D2.HUAXIAO_TYPE IS NULL AND G.XIAOQU_NO IS NULL THEN
            '1' --��C
           WHEN B2.USER_NO IS NULL AND A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
                A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2' AND
                E1.HUAXIAO_TYPE = '03' THEN
            '1' --����
           WHEN B2.USER_NO IS NULL AND A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
                F.HUAXIAO_TYPE = '03' THEN
            '1' --�ں�
           ELSE
            '0'
         END IS_HUAXIAO_03, --�Ƿ�����֧��-������(������������ר�ߵ�·)
         
         CASE
           WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
                G.XIAOQU_NO IS NOT NULL AND G2.HUAXIAO_TYPE = '04' THEN
            '1' --�����ںϽ����û��������ǰ����ں�ʱ����װ����ַ   20171120 ��ռ���޸ģ�����ȡ�����û�
         
           WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
                D4.HUAXIAO_TYPE = '04' AND D1.HUAXIAO_TYPE IS NULL AND
                D2.HUAXIAO_TYPE IS NULL AND G.XIAOQU_NO IS NULL THEN
            '1' --��C
           WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2' AND
                E2.HUAXIAO_TYPE = '04' THEN
            '1' --����
           WHEN F.HUAXIAO_TYPE = '04' THEN
            '1' --�ں�
           ELSE
            '0'
         END IS_HUAXIAO_04, --�Ƿ�ũ��֧��-������(������������ר�ߵ�·)
         
         '' IS_HUAXIAO_05, --�Ƿ��̿�����-������
         '' IS_HUAXIAO_06, --�Ƿ��嵥�ͻ�-������
         '' IS_HUAXIAO_07, --�Ƿ�У԰�а�-������
         '' IS_HUAXIAO_08, --�Ƿ�����ҵ��������ר����-������
         
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
           WHEN B2.USER_NO IS NULL AND A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
                A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
                G.XIAOQU_NO IS NOT NULL AND G1.HUAXIAO_TYPE = '03' THEN
            G1.HUAXIAO_NO --�����ںϽ����û��������ǰ����ں�ʱ����װ����ַ   20171120 ��ռ���޸ģ�����ȡ�����û�
         
           WHEN B2.USER_NO IS NULL AND A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
                A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
                D3.HUAXIAO_TYPE = '03' AND D1.HUAXIAO_TYPE IS NULL AND
                D2.HUAXIAO_TYPE IS NULL AND G.XIAOQU_NO IS NULL THEN
            D3.HUAXIAO_NO --��C
           WHEN B2.USER_NO IS NULL AND A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
                A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2' AND
                E1.HUAXIAO_TYPE = '03' THEN
            E1.HUAXIAO_NO --����
           WHEN B2.USER_NO IS NULL AND A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
                F.HUAXIAO_TYPE = '03' THEN
            F.HUAXIAO_NO --�ں�
         END HUAXIAO_NO_03, --����֧�ֻ�СID
         
         CASE
           WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
                G.XIAOQU_NO IS NOT NULL AND G2.HUAXIAO_TYPE = '04' THEN
            G2.HUAXIAO_NO --�����ںϽ����û��������ǰ����ں�ʱ����װ����ַ   20171120 ��ռ���޸ģ�����ȡ�����û�
         
           WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
                D4.HUAXIAO_TYPE = '04' AND D1.HUAXIAO_TYPE IS NULL AND
                D2.HUAXIAO_TYPE IS NULL AND G.XIAOQU_NO IS NULL THEN
            D4.HUAXIAO_NO --��C
           WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2' AND
                E2.HUAXIAO_TYPE = '04' THEN
            E2.HUAXIAO_NO --����
           WHEN F.HUAXIAO_TYPE = '04' THEN
            F.HUAXIAO_NO --�ں�
         END HUAXIAO_NO_04, --ũ��֧�ֻ�СID
         
         '' HUAXIAO_NO_05, --�̿�����СID
         '' HUAXIAO_NO_06, --�嵥�ͻ���СID
         '' HUAXIAO_NO_07, --У԰�а���СID
         '' HUAXIAO_NO_08, --����ҵ��������ר������СID
         
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
           WHEN B2.USER_NO IS NULL AND A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
                A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
                G.XIAOQU_NO IS NOT NULL AND G1.HUAXIAO_TYPE = '03' THEN
            G1.HUAXIAO_NAME --�����ںϽ����û��������ǰ����ں�ʱ����װ����ַ   20171120 ��ռ���޸ģ�����ȡ�����û�
         
           WHEN B2.USER_NO IS NULL AND A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
                A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
                D3.HUAXIAO_TYPE = '03' AND D1.HUAXIAO_TYPE IS NULL AND
                D2.HUAXIAO_TYPE IS NULL AND G.XIAOQU_NO IS NULL THEN
            D3.HUAXIAO_NAME --��C
           WHEN B2.USER_NO IS NULL AND A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
                A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2' AND
                E1.HUAXIAO_TYPE = '03' THEN
            E1.HUAXIAO_NAME --����
           WHEN B2.USER_NO IS NULL AND A.TELE_TYPE_NAME IN ('�ƶ�', '���', '����', '�̻�') AND
                F.HUAXIAO_TYPE = '03' THEN
            F.HUAXIAO_NAME --�ں�
         END HUAXIAO_NAME_03, --����֧�ֻ�СID
         
         CASE
           WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
                G.XIAOQU_NO IS NOT NULL AND G2.HUAXIAO_TYPE = '04' THEN
            G2.HUAXIAO_NAME --�����ںϽ����û��������ǰ����ں�ʱ����װ����ַ  20171120 ��ռ���޸ģ�����ȡ�����û�
         
           WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
                D4.HUAXIAO_TYPE = '04' AND D1.HUAXIAO_TYPE IS NULL AND
                D2.HUAXIAO_TYPE IS NULL AND G.XIAOQU_NO IS NULL THEN
            D4.HUAXIAO_NAME --��C
           WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2' AND
                E2.HUAXIAO_TYPE = '04' THEN
            E2.HUAXIAO_NAME --����
           WHEN F.HUAXIAO_TYPE = '04' THEN
            F.HUAXIAO_NAME --�ں�
         END HUAXIAO_NAME_04, --ũ��֧�ֻ�СID
         
         '' HUAXIAO_NAME_05, --�̿�����СID
         '' HUAXIAO_NAME_06, --�嵥�ͻ���СID
         '' HUAXIAO_NAME_07, --У԰�а���СID
         '' HUAXIAO_NAME_08, --����ҵ��������ר������СID
         A.BUNDLE_ID_ALLOWANCE,
         A.ALL_JF_FLUX,
         A.WIFI_JF_FLUX,
         A.JF_TIMES,
         A.TERMINAL_TYPE,
         A.TERMINAL_CORP,
         A.TELE_TYPE_NEW,
         A.IS_3NO_ADJUST,
         NVL(G3.IOT_FEE, 0)
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
                       CASE
                         WHEN TELE_TYPE = '2' THEN
                          '�ƶ�'
                         WHEN TELE_TYPE IN ('4', '26') AND
                              INNET_METHOD IN ('1', '2', '4', '5', '15') THEN
                          '���'
                         WHEN TELE_TYPE = '72' THEN
                          '����'
                         WHEN TELE_TYPE_NEW IN ('G020', 'G040') THEN
                          'ר�ߵ�·'
                         WHEN TELE_TYPE_NEW IN ('G000', 'G001', 'G002') THEN
                          '�̻�'
                       END TELE_TYPE_NAME
                  FROM DW.DW_V_USER_BASE_INFO_USER A
                 WHERE ACCT_MONTH = V_ACCT_MONTH
                   AND AREA_NO = C1.AREA_NO
                   AND (TELE_TYPE IN ('2', '72') OR
                       (TELE_TYPE IN ('4', '26') AND
                       INNET_METHOD IN ('1', '2', '4', '5', '15')) OR
                       TELE_TYPE_NEW IN
                       ('G020', 'G040', 'G000', 'G001', 'G002'))) A,
               
               (SELECT USER_NO,
                       T.GRADE_0 || '/' || T.GRADE_1 || '/' || T.GRADE_2 || '/' ||
                       T.GRADE_3 || '/' || T.GRADE_4 STDADDR_NAME
                  FROM DW.DW_V_USER_ADSL_EIGHT_M T
                 WHERE ACCT_MONTH = V_ACCT_MONTH
                   AND T.AREA_NO = C1.AREA_NO
                   AND USER_NO IS NOT NULL) B,
                   
               (SELECT USER_NO
                  FROM DW.DW_V_USER_SCHOOL_HX_USER_M T
                 WHERE ACCT_MONTH = V_ACCT_MONTH
                   AND T.AREA_NO = C1.AREA_NO) B2,    
               
               (SELECT * FROM ALLDMCODE.DMCODE_XIAOQU_STD_ADDR_NEW) C, 
               
               (SELECT *
                  FROM DIM.DIM_CHANNEL_HUAXIAO
                 WHERE HUAXIAO_TYPE = '01') D1, --��Ӫ��
               (SELECT *
                  FROM DIM.DIM_CHANNEL_HUAXIAO
                 WHERE HUAXIAO_TYPE = '02') D2, --��Ȧ֧��
               (SELECT *
                  FROM DIM.DIM_CHANNEL_HUAXIAO
                 WHERE HUAXIAO_TYPE = '03') D3, --����֧��
               (SELECT *
                  FROM DIM.DIM_CHANNEL_HUAXIAO
                 WHERE HUAXIAO_TYPE = '04') D4, --ũ��֧��
               
               (SELECT * FROM DIM.DIM_XIAOQU_HUAXIAO) E, --С���뻮С��Ӧ��ϵ��
               
               (SELECT *
                  FROM DIM.DIM_XIAOQU_HUAXIAO
                 WHERE HUAXIAO_TYPE = '03') E1, --����֧��
               (SELECT *
                  FROM DIM.DIM_XIAOQU_HUAXIAO
                 WHERE HUAXIAO_TYPE = '04') E2, --ũ��֧��
               
               (SELECT * FROM MID_DW_V_USER_HUAXIAO_M_PLUS) F, --�ںϿ���û�
               
               (SELECT USER_NO, XIAOQU_NO, XIAOQU_NAME
                  FROM DW_V_USER_HUAXIAO_INFO_M G
                 WHERE ACCT_MONTH = V_LAST_MONTH
                   AND AREA_NO = C1.AREA_NO) G, --���³���Ļ�����
               
               (SELECT *
                  FROM DIM.DIM_XIAOQU_HUAXIAO
                 WHERE HUAXIAO_TYPE = '03') G1, --����֧��
               (SELECT *
                  FROM DIM.DIM_XIAOQU_HUAXIAO
                 WHERE HUAXIAO_TYPE = '04') G2, --ũ��֧��
               
               (SELECT T.USER_NO, T.IOT_FEE
                  FROM MID_DW_V_USER_HUAXIAO_IOT T
                 WHERE T.ACCT_MONTH = V_ACCT_MONTH
                   AND T.AREA_NO = C1.AREA_NO) G3 --�������û�
        
         WHERE A.USER_NO = B.USER_NO(+)
           AND B.STDADDR_NAME = C.STDADDR_NAME(+)
           AND A.USER_NO = B2.USER_NO(+)
           AND A.CHANNEL_NO = D1.CHANNEL_NO(+)
           AND A.CHANNEL_NO = D2.CHANNEL_NO(+)
           AND A.CHANNEL_NO = D3.CHANNEL_NO(+)
           AND A.CHANNEL_NO = D4.CHANNEL_NO(+)
           AND C.XIAOQU_NO = E.XIAOQU_NO(+)
           AND C.XIAOQU_NO = E1.XIAOQU_NO(+)
           AND C.XIAOQU_NO = E2.XIAOQU_NO(+)
           AND A.BUNDLE_ID = F.BUNDLE_ID(+)
           AND A.USER_NO = G.USER_NO(+)
           AND G.XIAOQU_NO = G1.XIAOQU_NO(+)
           AND G.XIAOQU_NO = G2.XIAOQU_NO(+)
           AND A.USER_NO = G3.USER_NO(+);
    
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
