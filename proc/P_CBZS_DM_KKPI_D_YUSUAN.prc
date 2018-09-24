CREATE OR REPLACE PROCEDURE P_CBZS_DM_KKPI_D_YUSUAN(V_MONTH   VARCHAR2,
                                                    V_RETCODE OUT VARCHAR2,
                                                    V_RETINFO OUT VARCHAR2) IS
  /*-----------------------------------------------------------------------
  �� �� ����P_CBZS_DM_KKPI_D_YUSUAN
  �������ڣ�201804
  �� д �ˣ�LIYA
  ��  ��  ����
  Ŀ �� ��CBZS_DM_KKPI_D_YUSUAN
  ����˵�����»�С�ҵ�Ԥ��(ADMIN,CEO)
  -----------------------------------------------------------------------*/
  V_PKG        VARCHAR2(40);
  V_PROCNAME   VARCHAR2(40);
  V_COUNT1     NUMBER := 0;
  V_COUNT2     NUMBER := 0;
  V_LAST_MONTH VARCHAR2(20);
  V_FEE_CDMA   NUMBER := 0;
  V_FEE_GW     NUMBER := 0;

  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018';

BEGIN
  V_PKG        := '�»�С-�ҵ�Ԥ��';
  V_PROCNAME   := 'P_CBZS_DM_KKPI_D_YUSUAN';
  V_LAST_MONTH := TO_CHAR(ADD_MONTHS(TO_CHAR(TO_DATE(V_MONTH, 'YYYYMM')),
                                     -1),
                          'YYYYMM');

  --��־����
  ALLDM.P_ALLDM_INSERT_LOG(V_MONTH, V_PKG, V_PROCNAME, '12', SYSDATE);
  ---------------------------------------------------------------
  -- ���ݲ���

  /*SELECT COUNT(1)
   INTO V_COUNT1
   FROM ALLDM.ALLDM_EXECUTE_LOG
  WHERE ACCT_MONTH = V_MONTH
    AND RESULT = 'SUCCESS'
    AND PROCNAME IN ('P_ALLDM_MAOLI_MODEL_M');*/

  IF V_COUNT1 >= 0 AND V_COUNT2 >= 0 THEN
  
    DELETE FROM MSS_BMS_ZHIJU_YUSUAN WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
    INSERT INTO MSS_BMS_ZHIJU_YUSUAN
      SELECT V_MONTH ACCT_MONTH, C.ZHIJI_NAME_EDA, B.CODE, A.*
        FROM (SELECT A.ORG_ID, --֧��ID
                     C.NAME, --֧������
                     CASE
                       WHEN A.ITEM_ID IN (35721, 35722) THEN
                        '���������'
                       WHEN A.ITEM_ID IN (35751, 35743) THEN
                        '�ͻ������'
                       WHEN A.ITEM_ID IN (35820) THEN
                        'ҵ���д���'
                       WHEN A.ITEM_ID IN (35824) THEN
                        '����ʹ�ü����޷�'
                       WHEN A.ITEM_ID IN (35773) THEN
                        'ҵ����Ʒ��'
                     END FEE_NAME, --������
                     SUM(CASE
                           WHEN A.PERIOD = V_MONTH THEN
                            ANALYZE_AMOUNT
                           ELSE
                            0
                         END) YUE_YUSUAN, --�¶�Ԥ��
                     SUM(CASE
                           WHEN A.PERIOD = V_MONTH THEN
                            PREOCCUPIED_AMOUNT
                           ELSE
                            0
                         END) YUE_ZHANBI, --�¶�Ԥռ
                     SUM(CASE
                           WHEN A.PERIOD = V_MONTH THEN
                            OCCUPIED_AMOUNT
                           ELSE
                            0
                         END) YUE_SHIZHAN, --�¶�ʵռ
                     SUM(CASE
                           WHEN A.PERIOD = V_MONTH THEN
                            EXECUTED_AMOUNT
                           ELSE
                            0
                         END) YUE_ZHIXING, --�¶�ִ��
                     SUM(CASE
                           WHEN A.PERIOD = V_MONTH THEN
                            UNEXECUTED_AMOUNT
                           ELSE
                            0
                         END) YUE_SHENGYU, --�¶�ʣ��
                     SUM(CASE
                           WHEN A.PERIOD = SUBSTR(V_MONTH, 1, 4) || '00' THEN
                            ANALYZE_AMOUNT
                           ELSE
                            0
                         END) YEAR_YUSUAN, --���Ԥ��
                     SUM(CASE
                           WHEN A.PERIOD = SUBSTR(V_MONTH, 1, 4) || '00' THEN
                            PREOCCUPIED_AMOUNT
                           ELSE
                            0
                         END) YEAR_ZHANBI, --���Ԥռ
                     SUM(CASE
                           WHEN A.PERIOD = SUBSTR(V_MONTH, 1, 4) || '00' THEN
                            OCCUPIED_AMOUNT
                           ELSE
                            0
                         END) YEAR_SHIZHAN, --���ʵռ
                     SUM(CASE
                           WHEN A.PERIOD = SUBSTR(V_MONTH, 1, 4) || '00' THEN
                            EXECUTED_AMOUNT
                           ELSE
                            0
                         END) YEAR_ZHIXING, --���ִ��
                     SUM(CASE
                           WHEN A.PERIOD = SUBSTR(V_MONTH, 1, 4) || '00' THEN
                            UNEXECUTED_AMOUNT
                           ELSE
                            0
                         END) YEAR_SHENGYU --���ʣ��
                FROM MSS_DS.BMS_ALLOCATE_POOL@HANA  A,
                     MSS_DS.BMS_ITEM@HANA           B,
                     MSS_DS.SOUPE_ORGANIZATION@HANA C
               WHERE A.ITEM_ID = B.ID
                 AND A.ORG_ID = C.ID
                    --AND ORG_ID = 652934
                 AND PERIOD IN (V_MONTH, SUBSTR(V_MONTH, 1, 4) || '00')
                 AND ANALYZE_AMOUNT > 0
                 AND B.LEAF = 1
                 AND C.LEAF = 1
                 AND C.ORGANIZATION_TYPE = '2'
                 AND A.ITEM_ID IN ('35722',
                                   '35743',
                                   '35820',
                                   '35824',
                                   '35773',
                                   '35721',
                                   '35751')
               GROUP BY A.ORG_ID,
                        C.NAME,
                        CASE
                          WHEN A.ITEM_ID IN (35721, 35722) THEN
                           '���������'
                          WHEN A.ITEM_ID IN (35751, 35743) THEN
                           '�ͻ������'
                          WHEN A.ITEM_ID IN (35820) THEN
                           'ҵ���д���'
                          WHEN A.ITEM_ID IN (35824) THEN
                           '����ʹ�ü����޷�'
                          WHEN A.ITEM_ID IN (35773) THEN
                           'ҵ����Ʒ��'
                        END
               ORDER BY A.ORG_ID) A,
             (SELECT ID, CODE, NAME
                FROM MSS_DS.SOUPE_ORGANIZATION@HANA
               WHERE LEAF = 1) B,
             DIM.DIM_ZHIJU_TRANS C
       WHERE A.ORG_ID = B.ID
         AND B.CODE = C.ZHIJU_NO;
    COMMIT;
  
    DELETE FROM CBZS_DM_KKPI_D_YUSUAN WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
    INSERT INTO CBZS_DM_KKPI_D_YUSUAN
      SELECT ACCT_MONTH,
             AREA_NO,
             CITY_NO,
             '1',
             B.HUAXIAO_TYPE,
             B.HUAXIAO_NO,
             '01',
             '01',
             SUM(CASE
                   WHEN FEE_NAME = '���������' THEN
                    YUE_YUSUAN
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = '�ͻ������' THEN
                    YUE_YUSUAN
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = 'ҵ���д���' THEN
                    YUE_YUSUAN
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = '����ʹ�ü����޷�' THEN
                    YUE_YUSUAN
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = 'ҵ����Ʒ��' THEN
                    YUE_YUSUAN
                   ELSE
                    0
                 END)
        FROM MSS_BMS_ZHIJU_YUSUAN A, DIM.DIM_HUAXIAO_INFO B
       WHERE A.ACCT_MONTH = V_MONTH
         AND A.ZHIJI_NAME_EDA = B.HUAXIAO_NAME
       GROUP BY ACCT_MONTH, AREA_NO, CITY_NO, B.HUAXIAO_TYPE, B.HUAXIAO_NO;
    COMMIT;
    INSERT INTO CBZS_DM_KKPI_D_YUSUAN
      SELECT ACCT_MONTH,
             AREA_NO,
             CITY_NO,
             '1',
             B.HUAXIAO_TYPE,
             B.HUAXIAO_NO,
             '01',
             '02',
             SUM(CASE
                   WHEN FEE_NAME = '���������' THEN
                    YUE_ZHANBI
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = '�ͻ������' THEN
                    YUE_ZHANBI
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = 'ҵ���д���' THEN
                    YUE_ZHANBI
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = '����ʹ�ü����޷�' THEN
                    YUE_ZHANBI
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = 'ҵ����Ʒ��' THEN
                    YUE_ZHANBI
                   ELSE
                    0
                 END)
        FROM MSS_BMS_ZHIJU_YUSUAN A, DIM.DIM_HUAXIAO_INFO B
       WHERE A.ACCT_MONTH = V_MONTH
         AND A.ZHIJI_NAME_EDA = B.HUAXIAO_NAME
       GROUP BY ACCT_MONTH,
                AREA_NO,
                CITY_NO,
                '1',
                B.HUAXIAO_TYPE,
                B.HUAXIAO_NO;
    COMMIT;
  
    INSERT INTO CBZS_DM_KKPI_D_YUSUAN
      SELECT ACCT_MONTH,
             AREA_NO,
             CITY_NO,
             '1',
             B.HUAXIAO_TYPE,
             B.HUAXIAO_NO,
             '01',
             '03',
             SUM(CASE
                   WHEN FEE_NAME = '���������' THEN
                    YUE_SHIZHAN
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = '�ͻ������' THEN
                    YUE_SHIZHAN
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = 'ҵ���д���' THEN
                    YUE_SHIZHAN
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = '����ʹ�ü����޷�' THEN
                    YUE_SHIZHAN
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = 'ҵ����Ʒ��' THEN
                    YUE_SHIZHAN
                   ELSE
                    0
                 END)
        FROM MSS_BMS_ZHIJU_YUSUAN A, DIM.DIM_HUAXIAO_INFO B
       WHERE A.ACCT_MONTH = V_MONTH
         AND A.ZHIJI_NAME_EDA = B.HUAXIAO_NAME
       GROUP BY ACCT_MONTH,
                AREA_NO,
                CITY_NO,
                '1',
                B.HUAXIAO_TYPE,
                B.HUAXIAO_NO;
    COMMIT;
    INSERT INTO CBZS_DM_KKPI_D_YUSUAN
      SELECT ACCT_MONTH,
             AREA_NO,
             CITY_NO,
             '1',
             B.HUAXIAO_TYPE,
             B.HUAXIAO_NO,
             '01',
             '04',
             SUM(CASE
                   WHEN FEE_NAME = '���������' THEN
                    YUE_ZHIXING
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = '�ͻ������' THEN
                    YUE_ZHIXING
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = 'ҵ���д���' THEN
                    YUE_ZHIXING
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = '����ʹ�ü����޷�' THEN
                    YUE_ZHIXING
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = 'ҵ����Ʒ��' THEN
                    YUE_ZHIXING
                   ELSE
                    0
                 END)
        FROM MSS_BMS_ZHIJU_YUSUAN A, DIM.DIM_HUAXIAO_INFO B
       WHERE A.ACCT_MONTH = V_MONTH
         AND A.ZHIJI_NAME_EDA = B.HUAXIAO_NAME
       GROUP BY ACCT_MONTH,
                AREA_NO,
                CITY_NO,
                '1',
                B.HUAXIAO_TYPE,
                B.HUAXIAO_NO;
    COMMIT;
  
    INSERT INTO CBZS_DM_KKPI_D_YUSUAN
      SELECT ACCT_MONTH,
             AREA_NO,
             CITY_NO,
             '1',
             B.HUAXIAO_TYPE,
             B.HUAXIAO_NO,
             '01',
             '05',
             SUM(CASE
                   WHEN FEE_NAME = '���������' THEN
                    YUE_SHENGYU
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = '�ͻ������' THEN
                    YUE_SHENGYU
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = 'ҵ���д���' THEN
                    YUE_SHENGYU
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = '����ʹ�ü����޷�' THEN
                    YUE_SHENGYU
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = 'ҵ����Ʒ��' THEN
                    YUE_SHENGYU
                   ELSE
                    0
                 END)
        FROM MSS_BMS_ZHIJU_YUSUAN A, DIM.DIM_HUAXIAO_INFO B
       WHERE A.ACCT_MONTH = V_MONTH
         AND A.ZHIJI_NAME_EDA = B.HUAXIAO_NAME
       GROUP BY ACCT_MONTH,
                AREA_NO,
                CITY_NO,
                '1',
                B.HUAXIAO_TYPE,
                B.HUAXIAO_NO;
    COMMIT;
  
    INSERT INTO CBZS_DM_KKPI_D_YUSUAN
      SELECT ACCT_MONTH,
             AREA_NO,
             CITY_NO,
             '1',
             B.HUAXIAO_TYPE,
             B.HUAXIAO_NO,
             '02',
             '01',
             SUM(CASE
                   WHEN FEE_NAME = '���������' THEN
                    YEAR_YUSUAN
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = '�ͻ������' THEN
                    YEAR_YUSUAN
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = 'ҵ���д���' THEN
                    YEAR_YUSUAN
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = '����ʹ�ü����޷�' THEN
                    YEAR_YUSUAN
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = 'ҵ����Ʒ��' THEN
                    YEAR_YUSUAN
                   ELSE
                    0
                 END)
        FROM MSS_BMS_ZHIJU_YUSUAN A, DIM.DIM_HUAXIAO_INFO B
       WHERE A.ACCT_MONTH = V_MONTH
         AND A.ZHIJI_NAME_EDA = B.HUAXIAO_NAME
       GROUP BY ACCT_MONTH,
                AREA_NO,
                CITY_NO,
                '1',
                B.HUAXIAO_TYPE,
                B.HUAXIAO_NO;
    COMMIT;
    INSERT INTO CBZS_DM_KKPI_D_YUSUAN
      SELECT ACCT_MONTH,
             AREA_NO,
             CITY_NO,
             '1',
             B.HUAXIAO_TYPE,
             B.HUAXIAO_NO,
             '02',
             '02',
             SUM(CASE
                   WHEN FEE_NAME = '���������' THEN
                    YEAR_ZHANBI
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = '�ͻ������' THEN
                    YEAR_ZHANBI
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = 'ҵ���д���' THEN
                    YEAR_ZHANBI
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = '����ʹ�ü����޷�' THEN
                    YEAR_ZHANBI
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = 'ҵ����Ʒ��' THEN
                    YEAR_ZHANBI
                   ELSE
                    0
                 END)
        FROM MSS_BMS_ZHIJU_YUSUAN A, DIM.DIM_HUAXIAO_INFO B
       WHERE A.ACCT_MONTH = V_MONTH
         AND A.ZHIJI_NAME_EDA = B.HUAXIAO_NAME
       GROUP BY ACCT_MONTH,
                AREA_NO,
                CITY_NO,
                '1',
                B.HUAXIAO_TYPE,
                B.HUAXIAO_NO;
    COMMIT;
    INSERT INTO CBZS_DM_KKPI_D_YUSUAN
      SELECT ACCT_MONTH,
             AREA_NO,
             CITY_NO,
             '1',
             B.HUAXIAO_TYPE,
             B.HUAXIAO_NO,
             '02',
             '03',
             SUM(CASE
                   WHEN FEE_NAME = '���������' THEN
                    YEAR_SHIZHAN
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = '�ͻ������' THEN
                    YEAR_SHIZHAN
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = 'ҵ���д���' THEN
                    YEAR_SHIZHAN
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = '����ʹ�ü����޷�' THEN
                    YEAR_SHIZHAN
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = 'ҵ����Ʒ��' THEN
                    YEAR_SHIZHAN
                   ELSE
                    0
                 END)
        FROM MSS_BMS_ZHIJU_YUSUAN A, DIM.DIM_HUAXIAO_INFO B
       WHERE A.ACCT_MONTH = V_MONTH
         AND A.ZHIJI_NAME_EDA = B.HUAXIAO_NAME
       GROUP BY ACCT_MONTH,
                AREA_NO,
                CITY_NO,
                '1',
                B.HUAXIAO_TYPE,
                B.HUAXIAO_NO;
    COMMIT;
    INSERT INTO CBZS_DM_KKPI_D_YUSUAN
      SELECT ACCT_MONTH,
             AREA_NO,
             CITY_NO,
             '1',
             B.HUAXIAO_TYPE,
             B.HUAXIAO_NO,
             '02',
             '04',
             SUM(CASE
                   WHEN FEE_NAME = '���������' THEN
                    YEAR_ZHIXING
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = '�ͻ������' THEN
                    YEAR_ZHIXING
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = 'ҵ���д���' THEN
                    YEAR_ZHIXING
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = '����ʹ�ü����޷�' THEN
                    YEAR_ZHIXING
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = 'ҵ����Ʒ��' THEN
                    YEAR_ZHIXING
                   ELSE
                    0
                 END)
        FROM MSS_BMS_ZHIJU_YUSUAN A, DIM.DIM_HUAXIAO_INFO B
       WHERE A.ACCT_MONTH = V_MONTH
         AND A.ZHIJI_NAME_EDA = B.HUAXIAO_NAME
       GROUP BY ACCT_MONTH,
                AREA_NO,
                CITY_NO,
                '1',
                B.HUAXIAO_TYPE,
                B.HUAXIAO_NO;
    COMMIT;
  
    INSERT INTO CBZS_DM_KKPI_D_YUSUAN
      SELECT ACCT_MONTH,
             AREA_NO,
             CITY_NO,
             '1',
             B.HUAXIAO_TYPE,
             B.HUAXIAO_NO,
             '02',
             '05',
             SUM(CASE
                   WHEN FEE_NAME = '���������' THEN
                    YEAR_SHENGYU
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = '�ͻ������' THEN
                    YEAR_SHENGYU
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = 'ҵ���д���' THEN
                    YEAR_SHENGYU
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = '����ʹ�ü����޷�' THEN
                    YEAR_SHENGYU
                   ELSE
                    0
                 END),
             SUM(CASE
                   WHEN FEE_NAME = 'ҵ����Ʒ��' THEN
                    YEAR_SHENGYU
                   ELSE
                    0
                 END)
        FROM MSS_BMS_ZHIJU_YUSUAN A, DIM.DIM_HUAXIAO_INFO B
       WHERE A.ACCT_MONTH = V_MONTH
         AND A.ZHIJI_NAME_EDA = B.HUAXIAO_NAME
       GROUP BY ACCT_MONTH,
                AREA_NO,
                CITY_NO,
                '1',
                B.HUAXIAO_TYPE,
                B.HUAXIAO_NO;
    COMMIT;
  
    DELETE FROM CBZS_DM_KKPI_D_YUSUAN_ADMIN WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
    INSERT INTO CBZS_DM_KKPI_D_YUSUAN_ADMIN
      SELECT ACCT_MONTH,
             AREA_NO,
             CITY_NO,
             HUAXIAO_TYPE_BIG,
             HUAXIAO_TYPE,
             TYPE_ONE,
             TYPE_TWO,
             SUM(FEE_1),
             SUM(FEE_2),
             SUM(FEE_3),
             SUM(FEE_4),
             SUM(FEE_5)
        FROM CBZS_DM_KKPI_D_YUSUAN
       WHERE ACCT_MONTH = V_MONTH
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
