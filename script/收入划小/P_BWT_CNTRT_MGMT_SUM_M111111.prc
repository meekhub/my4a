CREATE OR REPLACE PROCEDURE P_BWT_CNTRT_MGMT_SUM_M(V_MONTH   VARCHAR2,
                                                   V_RETCODE OUT VARCHAR2,
                                                   V_RETINFO OUT VARCHAR2) IS
  /*-----------------------------------------------------------------------
  �� �� ����P_BWT_CNTRT_MGMT_SUM_M
  �������ڣ�2014��7��28
  �� д �ˣ�MAJIANHUI
  ��  ��  ����
  Ŀ �� ��BWT_CNTRT_MGMT_SUM_M
  ����˵������С�а����ա��ɱ���Ԥ�����ָ�꣨�£�
  -----------------------------------------------------------------------*/
  V_PKG      VARCHAR2(40);
  V_PROCNAME VARCHAR2(40);
  V_COUNT1   NUMBER := 0;
  V_COUNT2   NUMBER := 0;
  V_COUNT3   NUMBER := 0;
  --LY_MON12   VARCHAR2(20);
  LY_MON01   VARCHAR2(20);
  LY_CURMON  VARCHAR2(20);
  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018' ORDER BY IDX_NO;
BEGIN
  V_PKG      := 'P_BWT_CNTRT';
  V_PROCNAME := 'P_BWT_CNTRT_MGMT_SUM_M';
  --LY_MON12   := TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH, 'YYYYMM'), -12), 'YYYY') || '12';
  LY_MON01   := TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH, 'YYYYMM'), -12), 'YYYY') || '01';
  LY_CURMON  := TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH, 'YYYYMM'), -12),
                        'YYYYMM');
  --��־����
  ALLDM.P_ALLDM_INSERT_LOG(V_MONTH, V_PKG, V_PROCNAME, '12', SYSDATE);
  ---------------------------------------------------------------
  -- ���ݲ���
  SELECT COUNT(1)
    INTO V_COUNT1
    FROM DW.DW_EXECUTE_LOG
   WHERE ACCT_MONTH = V_MONTH
     AND RESULT = 'SUCCESS'
     AND PROCNAME IN ('P_DW_F_INCO_M_CHARGE_MONTH',
                      'P_DW_F_DEV_M_USER',
                      'P_DW_F_INCO_M_CHAR_TELE_MONTH',
                      'P_DW_F_DEV_M_USER_TELE',
                      'P_DW_F_DEV_M_USER_OCS');

  SELECT COUNT(1)
    INTO V_COUNT2
    FROM ALLDM.ALLDM_EXECUTE_LOG
   WHERE ACCT_MONTH = V_MONTH
     AND RESULT = 'SUCCESS'
     AND PROCNAME IN ('P_BWT_CNTRT_MGMT_CHNL_REL_M');
  COMMIT;
  IF V_COUNT1 >= 5 AND V_COUNT2 >= 1 THEN

    --�������
    DELETE FROM ALLDM.BWT_CNTRT_MGMT_SUM_M WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
 /*   DELETE FROM ALLDM.MID_CNTRT_MGMT_ACC WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
    --д��ҵ��������
    INSERT INTO MID_CNTRT_MGMT_ACC
      SELECT V_MONTH,
             AREA_NO,
             A.CHANNEL_NO,
             '2' TELE_TYPE,
             SUM(CHARGE_USER_COUNT),
             SUM(TOTAL_FEE),
             0 DEV_USER
        FROM DW.DW_F_INCO_M_CHARGE_MONTH A
       WHERE ACCT_MONTH = V_MONTH
       GROUP BY AREA_NO, A.CHANNEL_NO
      UNION ALL
      SELECT V_MONTH,
             AREA_NO,
             A.CHANNEL_NO,
             '2' TELE_TYPE,
             0,
             0,
             SUM(MON_NEW_USERS) DEV_USER
        FROM DW.DW_F_DEV_M_USER A
       WHERE ACCT_MONTH = V_MONTH
       GROUP BY AREA_NO, A.CHANNEL_NO
      UNION ALL
      SELECT V_MONTH,
             AREA_NO,
             C.CHANNEL_NO,
             '2' TELE_TYPE,
             SUM(ACCT_USERS),
             SUM(ACCT_INCOME),
             SUM(DEV_USERS)
        FROM DW.DW_F_DEV_M_USER_OCS C
       WHERE ACCT_MONTH = V_MONTH
       GROUP BY AREA_NO, C.CHANNEL_NO;
    COMMIT;
    --д�����ȫҵ������
    INSERT INTO MID_CNTRT_MGMT_ACC
      SELECT V_MONTH,
             AREA_NO,
             CHANNEL_NO,
             TELE_TYPE,
             0,
             SUM(TOTAL_FEE),
             0 DEV_USER
        FROM DW.DW_F_INCO_M_CHARGE_TELE_MONTH A
       WHERE ACCT_MONTH = V_MONTH
         AND A.TELE_TYPE IN ('3', '6', '4', '26', '8')
       GROUP BY AREA_NO, CHANNEL_NO, TELE_TYPE
      UNION ALL
      SELECT V_MONTH,
             AREA_NO,
             CHANNEL_NO,
             TELE_TYPE,
             SUM(BILLING_USER_NUM),
             0,
             SUM(NEW_USER_NUM)
        FROM DW.DW_F_DEV_M_USER_TELE
       WHERE ACCT_MONTH = V_MONTH
         AND TELE_TYPE IN ('3', '6', '4', '26', '8')
       GROUP BY AREA_NO, CHANNEL_NO, TELE_TYPE;
    COMMIT;

    --д��Ƿ������
    EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_CNTRT_MGMT_OWE';
    FOR C1 IN V_AREA LOOP
      EXECUTE IMMEDIATE 'TRUNCATE TABLE   MID_BWT_CNTRT_MGMT_INFO';
      INSERT INTO MID_BWT_CNTRT_MGMT_INFO
        SELECT USER_NO, AREA_NO, CHANNEL_NO
          FROM DW.DW_V_USER_BASE_INFO_USER B
         WHERE B.ACCT_MONTH = V_MONTH
           AND AREA_NO = C1.AREA_NO;
      COMMIT;
      INSERT INTO MID_BWT_CNTRT_MGMT_INFO
        SELECT A.USER_NO, AREA_NO, CHANNEL_NO
          FROM (SELECT USER_NO, AREA_NO, CHANNEL_NO
                  FROM DW.DW_V_USER_BASE_INFO_USER B
                 WHERE B.ACCT_MONTH = '201502'
                   AND AREA_NO = C1.AREA_NO) A,
               (SELECT USER_NO
                  FROM DW.DW_V_USER_BASE_INFO_USER B
                 WHERE B.ACCT_MONTH = V_MONTH
                   AND AREA_NO = C1.AREA_NO) B
         WHERE A.USER_NO = B.USER_NO(+)
           AND B.USER_NO IS NULL;
      COMMIT;
      INSERT INTO MID_CNTRT_MGMT_OWE
        SELECT C1.AREA_NO, B.CHANNEL_NO, SUM(OWE_FEE) OWE_FEE
          FROM (SELECT USER_NO,
                       SUM(FEE1 + FEE2 + FEE3 + FEE4 + FEE11 + FEE12 + FEE13 +
                           FEE14) OWE_FEE
                  FROM DW.DW_V_USER_OWE_FEE_M A
                 WHERE ACCT_MONTH = V_MONTH
                   AND AREA_NO = C1.AREA_NO
                 GROUP BY USER_NO) A,
               MID_BWT_CNTRT_MGMT_INFO B
         WHERE A.USER_NO = B.USER_NO(+)
         GROUP BY B.CHANNEL_NO;
      COMMIT;
    END LOOP;*/
    --д����ʽ����
    INSERT /*+APPEND*/
    INTO ALLDM.BWT_CNTRT_MGMT_SUM_M
    --�ƶ������û������������ڣ�
      SELECT V_MONTH,
             '813',
             B.CNTRT_MGMT_UNIT_CD,
             'YF1000',
             '1',
             NVL(SUM(ACCT_USER), 0)
        FROM (SELECT CHANNEL_NO, SUM(ACCT_USER) ACCT_USER
                FROM MID_CNTRT_MGMT_ACC
               WHERE ACCT_MONTH = V_MONTH
                 AND TELE_TYPE IN ('2', '8')
               GROUP BY CHANNEL_NO) A,
             (SELECT *
                FROM BWT_CNTRT_MGMT_CHNL_REL_M B
               WHERE B.ACCT_MONTH = V_MONTH) B,
               DIM.DIM_CHANNEL_HUAXIAO C
       WHERE A.CHANNEL_NO = C.CHANNEL_NO
       AND B.CNTRT_MGMT_UNIT_CD=C.HUAXIAO_NO
       GROUP BY B.CNTRT_MGMT_UNIT_CD
      /*UNION ALL
      --�ƶ������û����꾻��
      SELECT V_MONTH,
             '813',
             B.CNTRT_MGMT_UNIT_CD,
             'YF1001',
             '1',
             NVL(SUM(ACCT_USER), 0)
        FROM (SELECT CHANNEL_NO, SUM(ACCT_USER) ACCT_USER
                FROM MID_CNTRT_MGMT_ACC
               WHERE ACCT_MONTH = V_MONTH
                 AND TELE_TYPE IN ('2', '8')
               GROUP BY CHANNEL_NO
              UNION ALL
              SELECT CHANNEL_NO, SUM(ACCT_USER) * (-1) ACCT_USER
                FROM MID_CNTRT_MGMT_ACC
               WHERE ACCT_MONTH = LY_MON12
                 AND TELE_TYPE IN ('2', '8')
               GROUP BY CHANNEL_NO) A,
             (SELECT *
                FROM BWT_CNTRT_MGMT_CH_REL_M_LOCAL B
               WHERE B.ACCT_MONTH = V_MONTH) B
       WHERE A.CHANNEL_NO = B.CHANNEL_NO
       GROUP BY B.CNTRT_MGMT_UNIT_CD*/
      UNION ALL
      --�ƶ��û���װ�������ڣ�
      SELECT V_MONTH,
             '813',
             B.CNTRT_MGMT_UNIT_CD,
             'YU5000',
             '1',
             NVL(SUM(DEV_USER), 0)
        FROM (SELECT CHANNEL_NO, SUM(DEV_USER) DEV_USER
                FROM MID_CNTRT_MGMT_ACC
               WHERE ACCT_MONTH = V_MONTH
                 AND TELE_TYPE IN ('2', '8')
               GROUP BY CHANNEL_NO) A,
             (SELECT *
                FROM BWT_CNTRT_MGMT_CHNL_REL_M B
               WHERE B.ACCT_MONTH = V_MONTH) B,
               DIM.DIM_CHANNEL_HUAXIAO C
       WHERE A.CHANNEL_NO = C.CHANNEL_NO
       AND B.CNTRT_MGMT_UNIT_CD=C.HUAXIAO_NO
       GROUP BY B.CNTRT_MGMT_UNIT_CD
      /*UNION ALL
      --�ƶ��û�������װ��
      SELECT V_MONTH,
             '813',
             B.CNTRT_MGMT_UNIT_CD,
             'YU5001',
             '1',
             NVL(SUM(DEV_USER), 0)
        FROM (SELECT CHANNEL_NO, SUM(DEV_USER) DEV_USER
                FROM MID_CNTRT_MGMT_ACC
               WHERE SUBSTR(ACCT_MONTH, 1, 4) = SUBSTR(V_MONTH, 1, 4)
                 AND TELE_TYPE IN ('2', '8')
               GROUP BY CHANNEL_NO) A,
             (SELECT *
                FROM BWT_CNTRT_MGMT_CH_REL_M_LOCAL B
               WHERE B.ACCT_MONTH = V_MONTH) B
       WHERE A.CHANNEL_NO = B.CHANNEL_NO
       GROUP BY B.CNTRT_MGMT_UNIT_CD*/;
    COMMIT;

    --���߿���û�
    INSERT INTO BWT_CNTRT_MGMT_SUM_M
    --���߿���û������������ڣ�
      SELECT V_MONTH,
             '813',
             B.CNTRT_MGMT_UNIT_CD,
             'GUJ000',
             '1',
             NVL(SUM(ACCT_USER), 0)
        FROM (SELECT CHANNEL_NO, SUM(ACCT_USER) ACCT_USER
                FROM MID_CNTRT_MGMT_ACC
               WHERE ACCT_MONTH = V_MONTH
                 AND TELE_TYPE IN ('4', '26')
               GROUP BY CHANNEL_NO) A,
             (SELECT *
                FROM BWT_CNTRT_MGMT_CHNL_REL_M B
               WHERE B.ACCT_MONTH = V_MONTH) B,
               DIM.DIM_CHANNEL_HUAXIAO C
       WHERE A.CHANNEL_NO = C.CHANNEL_NO
       AND B.CNTRT_MGMT_UNIT_CD=C.HUAXIAO_NO
       GROUP BY B.CNTRT_MGMT_UNIT_CD
      /*UNION ALL
      --���߿���û����꾻��
      SELECT V_MONTH,
             '813',
             B.CNTRT_MGMT_UNIT_CD,
             'EUJ001',
             '1',
             NVL(SUM(ACCT_USER), 0)
        FROM (SELECT CHANNEL_NO, SUM(ACCT_USER) ACCT_USER
                FROM MID_CNTRT_MGMT_ACC
               WHERE ACCT_MONTH = V_MONTH
                 AND TELE_TYPE IN ('4', '26')
               GROUP BY CHANNEL_NO
              UNION ALL
              SELECT CHANNEL_NO, SUM(ACCT_USER) * (-1) ACCT_USER
                FROM MID_CNTRT_MGMT_ACC
               WHERE ACCT_MONTH = LY_MON12
                 AND TELE_TYPE IN ('4', '26')
               GROUP BY CHANNEL_NO) A,
             (SELECT *
                FROM BWT_CNTRT_MGMT_CH_REL_M_LOCAL B
               WHERE B.ACCT_MONTH = V_MONTH) B
       WHERE A.CHANNEL_NO = B.CHANNEL_NO
       GROUP BY B.CNTRT_MGMT_UNIT_CD*/
      UNION ALL
      --���߿���û���װ�������ڣ�
      SELECT V_MONTH,
             '813',
             B.CNTRT_MGMT_UNIT_CD,
             'GUX000',
             '1',
             NVL(SUM(DEV_USER), 0)
        FROM (SELECT CHANNEL_NO, SUM(DEV_USER) DEV_USER
                FROM MID_CNTRT_MGMT_ACC
               WHERE ACCT_MONTH = V_MONTH
                 AND TELE_TYPE IN ('4', '26')
               GROUP BY CHANNEL_NO) A,
             (SELECT *
                FROM BWT_CNTRT_MGMT_CHNL_REL_M B
               WHERE B.ACCT_MONTH = V_MONTH) B,
               DIM.DIM_CHANNEL_HUAXIAO C
       WHERE A.CHANNEL_NO = C.CHANNEL_NO
       AND B.CNTRT_MGMT_UNIT_CD=C.HUAXIAO_NO
       GROUP BY B.CNTRT_MGMT_UNIT_CD
     /* UNION ALL
      --���߿���û�������װ��
      SELECT V_MONTH,
             '813',
             B.CNTRT_MGMT_UNIT_CD,
             'GUX001',
             '1',
             NVL(SUM(DEV_USER), 0)
        FROM (SELECT CHANNEL_NO, SUM(DEV_USER) DEV_USER
                FROM MID_CNTRT_MGMT_ACC
               WHERE SUBSTR(ACCT_MONTH, 1, 4) = SUBSTR(V_MONTH, 1, 4)
                 AND TELE_TYPE IN ('4', '26')
               GROUP BY CHANNEL_NO) A,
             (SELECT *
                FROM BWT_CNTRT_MGMT_CH_REL_M_LOCAL B
               WHERE B.ACCT_MONTH = V_MONTH) B
       WHERE A.CHANNEL_NO = B.CHANNEL_NO
       GROUP BY B.CNTRT_MGMT_UNIT_CD*/;
    COMMIT;

    --�̶��绰�û�
    INSERT INTO BWT_CNTRT_MGMT_SUM_M
    --�̶��绰�û��������������������ڣ�
      SELECT V_MONTH,
             '813',
             B.CNTRT_MGMT_UNIT_CD,
             'AU1000',
             '1',
             NVL(SUM(ACCT_USER), 0)
        FROM (SELECT CHANNEL_NO, SUM(ACCT_USER) ACCT_USER
                FROM MID_CNTRT_MGMT_ACC
               WHERE ACCT_MONTH = V_MONTH
                 AND TELE_TYPE IN ('3', '6')
               GROUP BY CHANNEL_NO) A,
             (SELECT *
                FROM BWT_CNTRT_MGMT_CHNL_REL_M B
               WHERE B.ACCT_MONTH = V_MONTH) B,
               DIM.DIM_CHANNEL_HUAXIAO C
       WHERE A.CHANNEL_NO = C.CHANNEL_NO
       AND B.CNTRT_MGMT_UNIT_CD=C.HUAXIAO_NO
       GROUP BY B.CNTRT_MGMT_UNIT_CD
     /* UNION ALL
      --�̶��绰�û������������꾻��
      SELECT V_MONTH,
             '813',
             B.CNTRT_MGMT_UNIT_CD,
             'AU1001',
             '1',
             NVL(SUM(ACCT_USER), 0)
        FROM (SELECT CHANNEL_NO, SUM(ACCT_USER) ACCT_USER
                FROM MID_CNTRT_MGMT_ACC
               WHERE ACCT_MONTH = V_MONTH
                 AND TELE_TYPE IN ('3', '6')
               GROUP BY CHANNEL_NO
              UNION ALL
              SELECT CHANNEL_NO, SUM(ACCT_USER) * (-1) ACCT_USER
                FROM MID_CNTRT_MGMT_ACC
               WHERE ACCT_MONTH = LY_MON12
                 AND TELE_TYPE IN ('3', '6')
               GROUP BY CHANNEL_NO) A,
             (SELECT *
                FROM BWT_CNTRT_MGMT_CH_REL_M_LOCAL B
               WHERE B.ACCT_MONTH = V_MONTH) B
       WHERE A.CHANNEL_NO = B.CHANNEL_NO
       GROUP BY B.CNTRT_MGMT_UNIT_CD*/
      UNION ALL
      --�̶��绰�û���װ�������ڣ�
      SELECT V_MONTH,
             '813',
             B.CNTRT_MGMT_UNIT_CD,
             'AU5000',
             '1',
             NVL(SUM(DEV_USER), 0)
        FROM (SELECT CHANNEL_NO, SUM(DEV_USER) DEV_USER
                FROM MID_CNTRT_MGMT_ACC
               WHERE ACCT_MONTH = V_MONTH
                 AND TELE_TYPE IN ('3', '6')
               GROUP BY CHANNEL_NO) A,
             (SELECT *
                FROM BWT_CNTRT_MGMT_CHNL_REL_M B
               WHERE B.ACCT_MONTH = V_MONTH) B,
               DIM.DIM_CHANNEL_HUAXIAO C
       WHERE A.CHANNEL_NO = C.CHANNEL_NO
       AND B.CNTRT_MGMT_UNIT_CD=C.HUAXIAO_NO
       GROUP BY B.CNTRT_MGMT_UNIT_CD
      /*UNION ALL
      --�̶��绰�û�������װ��
      SELECT V_MONTH,
             '813',
             B.CNTRT_MGMT_UNIT_CD,
             'AU5001',
             '1',
             NVL(SUM(DEV_USER), 0)
        FROM (SELECT CHANNEL_NO, SUM(DEV_USER) DEV_USER
                FROM MID_CNTRT_MGMT_ACC
               WHERE SUBSTR(ACCT_MONTH, 1, 4) = SUBSTR(V_MONTH, 1, 4)
                 AND TELE_TYPE IN ('3', '6')
               GROUP BY CHANNEL_NO) A,
             (SELECT *
                FROM BWT_CNTRT_MGMT_CH_REL_M_LOCAL B
               WHERE B.ACCT_MONTH = V_MONTH) B
       WHERE A.CHANNEL_NO = B.CHANNEL_NO
       GROUP BY B.CNTRT_MGMT_UNIT_CD*/;
    COMMIT;

    --��Ӫ����
    INSERT INTO BWT_CNTRT_MGMT_SUM_M
    --�ƶ����루���ڣ�
      SELECT V_MONTH,
             '813',
             B.CNTRT_MGMT_UNIT_CD,
             'SRY1000',
             '3',
             NVL(SUM(TOTAL_FEE), 0)
        FROM (SELECT CHANNEL_NO, SUM(TOTAL_FEE) TOTAL_FEE
                FROM MID_CNTRT_MGMT_ACC
               WHERE ACCT_MONTH = V_MONTH
                 AND TELE_TYPE IN ('2', '8')
               GROUP BY CHANNEL_NO) A,
             (SELECT *
                FROM BWT_CNTRT_MGMT_CHNL_REL_M B
               WHERE B.ACCT_MONTH = V_MONTH) B,
               DIM.DIM_CHANNEL_HUAXIAO C
       WHERE A.CHANNEL_NO = C.CHANNEL_NO
       AND B.CNTRT_MGMT_UNIT_CD=C.HUAXIAO_NO
       GROUP BY B.CNTRT_MGMT_UNIT_CD
      UNION ALL
      --�ƶ����루�����ۼƣ�
      SELECT V_MONTH,
             '813',
             B.CNTRT_MGMT_UNIT_CD,
             'SRY1001',
             '3',
             NVL(SUM(TOTAL_FEE), 0)
        FROM (SELECT CHANNEL_NO, SUM(TOTAL_FEE) TOTAL_FEE
                FROM MID_CNTRT_MGMT_ACC
               WHERE SUBSTR(ACCT_MONTH, 1, 4) = SUBSTR(V_MONTH, 1, 4)
                 AND TELE_TYPE IN ('2', '8')
               GROUP BY CHANNEL_NO) A,
             (SELECT *
                FROM BWT_CNTRT_MGMT_CHNL_REL_M B
               WHERE B.ACCT_MONTH = V_MONTH) B,
               DIM.DIM_CHANNEL_HUAXIAO C
       WHERE A.CHANNEL_NO = C.CHANNEL_NO
       AND B.CNTRT_MGMT_UNIT_CD=C.HUAXIAO_NO
       GROUP BY B.CNTRT_MGMT_UNIT_CD
      UNION ALL
      --�ƶ����루����ͬ���ۼƣ�
      SELECT V_MONTH,
             '813',
             B.CNTRT_MGMT_UNIT_CD,
             'SRY1002',
             '3',
             NVL(SUM(TOTAL_FEE), 0)
        FROM (SELECT CHANNEL_NO, SUM(TOTAL_FEE) TOTAL_FEE
                FROM MID_CNTRT_MGMT_ACC
               WHERE ACCT_MONTH BETWEEN LY_MON01 AND LY_CURMON
                 AND TELE_TYPE IN ('2', '8')
               GROUP BY CHANNEL_NO) A,
             (SELECT *
                FROM BWT_CNTRT_MGMT_CHNL_REL_M B
               WHERE B.ACCT_MONTH = V_MONTH) B,
               DIM.DIM_CHANNEL_HUAXIAO C
       WHERE A.CHANNEL_NO = C.CHANNEL_NO
       AND B.CNTRT_MGMT_UNIT_CD=C.HUAXIAO_NO
       GROUP BY B.CNTRT_MGMT_UNIT_CD;
    COMMIT;

    INSERT INTO BWT_CNTRT_MGMT_SUM_M
    --�������루���ڣ�
      SELECT V_MONTH,
             '813',
             B.CNTRT_MGMT_UNIT_CD,
             'SRG1000',
             '3',
             NVL(SUM(TOTAL_FEE), 0)
        FROM (SELECT CHANNEL_NO, SUM(TOTAL_FEE) TOTAL_FEE
                FROM MID_CNTRT_MGMT_ACC
               WHERE ACCT_MONTH = V_MONTH
                 AND TELE_TYPE IN ('3', '6')
               GROUP BY CHANNEL_NO) A,
             (SELECT *
                FROM BWT_CNTRT_MGMT_CHNL_REL_M B
               WHERE B.ACCT_MONTH = V_MONTH) B,
               DIM.DIM_CHANNEL_HUAXIAO C
       WHERE A.CHANNEL_NO = C.CHANNEL_NO
       AND B.CNTRT_MGMT_UNIT_CD=C.HUAXIAO_NO
       GROUP BY B.CNTRT_MGMT_UNIT_CD
      UNION ALL
      --�������루�����ۼƣ�
      SELECT V_MONTH,
             '813',
             B.CNTRT_MGMT_UNIT_CD,
             'SRG1001',
             '3',
             NVL(SUM(TOTAL_FEE), 0)
        FROM (SELECT CHANNEL_NO, SUM(TOTAL_FEE) TOTAL_FEE
                FROM MID_CNTRT_MGMT_ACC
               WHERE SUBSTR(ACCT_MONTH, 1, 4) = SUBSTR(V_MONTH, 1, 4)
                 AND TELE_TYPE IN ('3', '6')
               GROUP BY CHANNEL_NO) A,
             (SELECT *
                FROM BWT_CNTRT_MGMT_CHNL_REL_M B
               WHERE B.ACCT_MONTH = V_MONTH) B,
               DIM.DIM_CHANNEL_HUAXIAO C
       WHERE A.CHANNEL_NO = C.CHANNEL_NO
       AND B.CNTRT_MGMT_UNIT_CD=C.HUAXIAO_NO
       GROUP BY B.CNTRT_MGMT_UNIT_CD
      UNION ALL
      --�������루����ͬ���ۼƣ�
      SELECT V_MONTH,
             '813',
             B.CNTRT_MGMT_UNIT_CD,
             'SRG1002',
             '3',
             NVL(SUM(TOTAL_FEE), 0)
        FROM (SELECT CHANNEL_NO, SUM(TOTAL_FEE) TOTAL_FEE
                FROM MID_CNTRT_MGMT_ACC
               WHERE ACCT_MONTH BETWEEN LY_MON01 AND LY_CURMON
                 AND TELE_TYPE IN ('3', '6')
               GROUP BY CHANNEL_NO) A,
             (SELECT *
                FROM BWT_CNTRT_MGMT_CHNL_REL_M B
               WHERE B.ACCT_MONTH = V_MONTH) B,
               DIM.DIM_CHANNEL_HUAXIAO C
       WHERE A.CHANNEL_NO = C.CHANNEL_NO
       AND B.CNTRT_MGMT_UNIT_CD=C.HUAXIAO_NO
       GROUP BY B.CNTRT_MGMT_UNIT_CD;
    COMMIT;

    INSERT INTO BWT_CNTRT_MGMT_SUM_M
    --���У�������루���ڣ�
      SELECT V_MONTH,
             '813',
             B.CNTRT_MGMT_UNIT_CD,
             'SRG1100',
             '3',
             NVL(SUM(TOTAL_FEE), 0)
        FROM (SELECT CHANNEL_NO, SUM(TOTAL_FEE) TOTAL_FEE
                FROM MID_CNTRT_MGMT_ACC
               WHERE ACCT_MONTH = V_MONTH
                 AND TELE_TYPE IN ('4', '26')
               GROUP BY CHANNEL_NO) A,
             (SELECT *
                FROM BWT_CNTRT_MGMT_CHNL_REL_M B
               WHERE B.ACCT_MONTH = V_MONTH) B,
               DIM.DIM_CHANNEL_HUAXIAO C
       WHERE A.CHANNEL_NO = C.CHANNEL_NO
       AND B.CNTRT_MGMT_UNIT_CD=C.HUAXIAO_NO
       GROUP BY B.CNTRT_MGMT_UNIT_CD
      UNION ALL
      --���У�������루�����ۼƣ�
      SELECT V_MONTH,
             '813',
             B.CNTRT_MGMT_UNIT_CD,
             'SRG1101',
             '3',
             NVL(SUM(TOTAL_FEE), 0)
        FROM (SELECT CHANNEL_NO, SUM(TOTAL_FEE) TOTAL_FEE
                FROM MID_CNTRT_MGMT_ACC
               WHERE SUBSTR(ACCT_MONTH, 1, 4) = SUBSTR(V_MONTH, 1, 4)
                 AND TELE_TYPE IN ('4', '26')
               GROUP BY CHANNEL_NO) A,
             (SELECT *
                FROM BWT_CNTRT_MGMT_CHNL_REL_M B
               WHERE B.ACCT_MONTH = V_MONTH) B,
               DIM.DIM_CHANNEL_HUAXIAO C
       WHERE A.CHANNEL_NO = C.CHANNEL_NO
       AND B.CNTRT_MGMT_UNIT_CD=C.HUAXIAO_NO
       GROUP BY B.CNTRT_MGMT_UNIT_CD
      UNION ALL
      --���У�������루����ͬ���ۼƣ�
      SELECT V_MONTH,
             '813',
             B.CNTRT_MGMT_UNIT_CD,
             'SRG1102',
             '3',
             NVL(SUM(TOTAL_FEE), 0)
        FROM (SELECT CHANNEL_NO, SUM(TOTAL_FEE) TOTAL_FEE
                FROM MID_CNTRT_MGMT_ACC
               WHERE ACCT_MONTH BETWEEN LY_MON01 AND LY_CURMON
                 AND TELE_TYPE IN ('4', '26')
               GROUP BY CHANNEL_NO) A,
             (SELECT *
                FROM BWT_CNTRT_MGMT_CHNL_REL_M B
               WHERE B.ACCT_MONTH = V_MONTH) B,
               DIM.DIM_CHANNEL_HUAXIAO C
       WHERE A.CHANNEL_NO = C.CHANNEL_NO
       AND B.CNTRT_MGMT_UNIT_CD=C.HUAXIAO_NO
       GROUP BY B.CNTRT_MGMT_UNIT_CD;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('11111111111');
    --д��Ƿ������
    INSERT INTO BWT_CNTRT_MGMT_SUM_M
      SELECT V_MONTH,
             '813',
             B.CNTRT_MGMT_UNIT_CD,
             'QF1000',
             '3',
             NVL(SUM(OWE_FEE), 0)
        FROM MID_CNTRT_MGMT_OWE A,
             (SELECT *
                FROM BWT_CNTRT_MGMT_CHNL_REL_M B
               WHERE B.ACCT_MONTH = V_MONTH) B,
               DIM.DIM_CHANNEL_HUAXIAO C
       WHERE A.CHANNEL_NO = C.CHANNEL_NO
       AND B.CNTRT_MGMT_UNIT_CD=C.HUAXIAO_NO
       GROUP BY B.CNTRT_MGMT_UNIT_CD;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('2222222222222');
    --д�������������
    INSERT INTO BWT_CNTRT_MGMT_SUM_M
      SELECT V_MONTH,
             '813',
             B.CNTRT_MGMT_UNIT_CD,
             'AC7330',
             '1',
             COUNT(DISTINCT A.USER_NO)
        FROM (SELECT USER_NO, CHANNEL_NO
                FROM DW.DW_V_USER_BASE_INFO_USER
               WHERE ACCT_MONTH = V_MONTH
                 AND TELE_TYPE = '72'
                 AND IS_ONNET = '1') A,
             (SELECT *
                FROM BWT_CNTRT_MGMT_CHNL_REL_M B
               WHERE B.ACCT_MONTH = V_MONTH) B,
             DIM.DIM_CHANNEL_HUAXIAO C
       WHERE A.CHANNEL_NO = C.CHANNEL_NO
         AND B.CNTRT_MGMT_UNIT_CD = C.HUAXIAO_NO
       GROUP BY B.CNTRT_MGMT_UNIT_CD;
    COMMIT;

     --д�����������װ
    INSERT INTO BWT_CNTRT_MGMT_SUM_M
      SELECT V_MONTH,
             '813',
             B.CNTRT_MGMT_UNIT_CD,
             'AE5000',
             '1',
             COUNT(DISTINCT A.USER_NO)
        FROM (SELECT USER_NO, CHANNEL_NO
                FROM DW.DW_V_USER_BASE_INFO_USER
               WHERE ACCT_MONTH = V_MONTH
                 AND TELE_TYPE = '72'
                 AND IS_NEW = '1') A,
             (SELECT *
                FROM BWT_CNTRT_MGMT_CHNL_REL_M B
               WHERE B.ACCT_MONTH = V_MONTH) B,
             DIM.DIM_CHANNEL_HUAXIAO C
       WHERE A.CHANNEL_NO = C.CHANNEL_NO
         AND B.CNTRT_MGMT_UNIT_CD = C.HUAXIAO_NO
       GROUP BY B.CNTRT_MGMT_UNIT_CD;
    COMMIT;

     --д������������
    INSERT INTO BWT_CNTRT_MGMT_SUM_M
      SELECT V_MONTH,
             '813',
             B.CNTRT_MGMT_UNIT_CD,
             'YU8510',
             '1',
             COUNT(DISTINCT A.USER_NO)
        FROM (SELECT USER_NO, CHANNEL_NO
                FROM DW.DW_V_USER_HUAXIAO_INFO_M
               WHERE ACCT_MONTH = V_MONTH
                 AND IOT_FEE>0
                 AND IS_ONNET='1') A,
             (SELECT *
                FROM BWT_CNTRT_MGMT_CHNL_REL_M B
               WHERE B.ACCT_MONTH = V_MONTH) B,
             DIM.DIM_CHANNEL_HUAXIAO C
       WHERE A.CHANNEL_NO = C.CHANNEL_NO
         AND B.CNTRT_MGMT_UNIT_CD = C.HUAXIAO_NO
       GROUP BY B.CNTRT_MGMT_UNIT_CD;
    COMMIT;

    --д����������װ
    INSERT INTO BWT_CNTRT_MGMT_SUM_M
      SELECT V_MONTH,
             '813',
             B.CNTRT_MGMT_UNIT_CD,
             'YU8610',
             '1',
             COUNT(DISTINCT A.USER_NO)
        FROM (SELECT USER_NO, CHANNEL_NO
                FROM DW.DW_V_USER_HUAXIAO_INFO_M
               WHERE ACCT_MONTH = V_MONTH
                 AND IOT_FEE>0
                 AND IS_NEW='1') A,
             (SELECT *
                FROM BWT_CNTRT_MGMT_CHNL_REL_M B
               WHERE B.ACCT_MONTH = V_MONTH) B,
             DIM.DIM_CHANNEL_HUAXIAO C
       WHERE A.CHANNEL_NO = C.CHANNEL_NO
         AND B.CNTRT_MGMT_UNIT_CD = C.HUAXIAO_NO
       GROUP BY B.CNTRT_MGMT_UNIT_CD;
    COMMIT;
    
    SELECT COUNT(1)
      INTO V_COUNT3
      FROM BWT_CNTRT_MGMT_SUM_M A,
           (SELECT *
              FROM /*BWT_CNTRT_MGMT_CHNL_REL_M*/ BWT_CNTRT_MGMT_UNIT_M B --20150210 ����������Ҫ�󣬳а���λID�����ڱ� BWT_CNTRT_MGMT_UNIT_M ��
             WHERE B.ACCT_MONTH = V_MONTH) B
     WHERE A.CNTRT_MGMT_UNIT_CD = B.CNTRT_MGMT_UNIT_CD(+)
       AND B.CNTRT_MGMT_UNIT_CD IS NULL
       AND A.ACCT_MONTH = V_MONTH;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('33333333333');

    IF V_COUNT3 < 1 THEN
      --������־
      V_RETCODE := 'SUCCESS';
      ALLDM.P_ALLDM_UPDATE_LOG(V_MONTH,
                               V_PKG,
                               V_PROCNAME,
                               '����',
                               V_RETCODE,
                               SYSDATE);
      DBMS_OUTPUT.PUT_LINE(V_RETCODE);
      DBMS_OUTPUT.PUT_LINE('4444SUCCESS');
    ELSE
      V_RETCODE := 'FAIL';
      V_RETINFO := SQLERRM;
      ALLDM.P_ALLDM_UPDATE_LOG(V_MONTH,
                               V_PKG,
                               V_PROCNAME,
                               V_RETINFO,
                               V_RETCODE,
                               SYSDATE);
      DBMS_OUTPUT.PUT_LINE('4444FAIL');
    END IF;
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
