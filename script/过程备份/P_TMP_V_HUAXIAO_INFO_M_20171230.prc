CREATE OR REPLACE PROCEDURE P_BWT_CNTRT_MGMT_CHNL_REL_M(V_MONTH   VARCHAR2,
                                                        V_RETCODE OUT VARCHAR2,
                                                        V_RETINFO OUT VARCHAR2) IS
  /*-----------------------------------------------------------------------
  �� �� ����P_BWT_CNTRT_MGMT_CHNL_REL_M
  �������ڣ�2014��6��28
  �� д �ˣ�MAJIANHUI
  ��  ��  ����
  Ŀ �� ��BWT_CNTRT_MGMT_CHNL_REL_M
  ����˵������С�а���Ԫ��������ϵ���£�
  -----------------------------------------------------------------------*/
  V_PKG      VARCHAR2(40);
  V_PROCNAME VARCHAR2(40);
  V_COUNT1   NUMBER := 0;
  V_COUNT2   NUMBER := 0;
  V_COUNT3   NUMBER := 0;
  V_COUNT4   NUMBER := 0;
  V_COUNT5   NUMBER := 0;

BEGIN
  V_PKG      := 'P_BWT_CNTRT';
  V_PROCNAME := 'P_BWT_CNTRT_MGMT_CHNL_REL_M';

  --��־����
  ALLDM.P_ALLDM_INSERT_LOG(V_MONTH, V_PKG, V_PROCNAME, '12', SYSDATE);
  ---------------------------------------------------------------
  SELECT COUNT(1)
    INTO V_COUNT1
    FROM ALLDM.ALLDM_EXECUTE_LOG
   WHERE ACCT_MONTH = V_MONTH
     AND RESULT = 'SUCCESS'
     AND PROCNAME IN ('P_BWT_CNTRT_MGMT_UNIT_M');
  COMMIT;

  --�жϼ����·���� ��Ч��������������20000
  SELECT COUNT(1)
    INTO V_COUNT5
    FROM ALLDM.BWT_DOWN_SALE_OUTLETS_D
   WHERE DAY_ID = TO_CHAR(LAST_DAY(TO_DATE(V_MONTH, 'YYYYMM')), 'YYYYMMDD') --ȡ�µ�����һ�������
     AND STATUS = '00A'; --ֻȡ�����·����� ��Ч������

  -- ���ݲ���
  IF V_COUNT1 >= 1 AND V_COUNT5 > 20000 THEN

    --�������
    DELETE FROM ALLDM.BWT_CNTRT_MGMT_CHNL_REL_M WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
    DELETE FROM ALLDM.BWT_CNTRT_MGMT_CHNL_REL_M_DEA
     WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
    DELETE FROM ALLDM.BWT_CNTRT_MGMT_CH_REL_M_LOCAL
     WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
    ----ʡ�����������뼯�����������Ӧ��ϵ
    EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_CHANNEL_CBDY';
    INSERT INTO MID_CHANNEL_CBDY
      SELECT DISTINCT DEALER_ID CHANNEL_NO_HB, CHANNEL_NBR
        FROM CRM_DSG.CHANNEL@HBODS;
    COMMIT;

    ----������С
    INSERT /*+APPEND*/
    INTO ALLDM.BWT_CNTRT_MGMT_CHNL_REL_M_DEA
      SELECT V_MONTH, '813', HUAXIAO_NO, CHANNEL_NBR, A.CHANNEL_NO
        FROM (SELECT AREA_NO, CHANNEL_NO, HUAXIAO_NO, B.CHANNEL_NBR
                FROM DIM.DIM_CHANNEL_HUAXIAO A, MID_CHANNEL_CBDY B
               WHERE A.CHANNEL_NO = B.CHANNEL_NO_HB) A
      /*WHERE EXISTS (SELECT 1
       FROM BWT_CNTRT_MGMT_UNIT_M B
      WHERE B.ACCT_MONTH = V_MONTH
        AND A.HUAXIAO_NO = B.CNTRT_MGMT_UNIT_CD)*/
      ; --2014��8��10���޶���Ч  ������ȷ��
    COMMIT;

    --20150210 �޸ģ� �����ϴ����Ŷ�Ӧ��ϵ��ֻ�ϴ��ڼ����·����� ��Ч������
    INSERT INTO ALLDM.BWT_CNTRT_MGMT_CHNL_REL_M
      SELECT A.ACCT_MONTH,
             A.PRVNCE_ID,
             A.CNTRT_MGMT_UNIT_CD,
             A.SALE_OUTLETS_CD
        FROM ALLDM.BWT_CNTRT_MGMT_CHNL_REL_M_DEA A /*,
                   (SELECT DISTINCT SALE_OUTLETS_CD
                      FROM ALLDM.BWT_DOWN_SALE_OUTLETS_D
                     WHERE DAY_ID = TO_CHAR(LAST_DAY(TO_DATE(V_MONTH, 'YYYYMM')),
                                            'YYYYMMDD') --ȡ�µ�����һ�������
                       AND STATUS = '00A' --ֻȡ�����·����� ��Ч������
                    ) C*/
       WHERE ACCT_MONTH = V_MONTH
      /*AND A.SALE_OUTLETS_CD = C.SALE_OUTLETS_CD*/
      ;
    COMMIT;
    --DBMS_OUTPUT.PUT_LINE('33333333333');
    --20150210 �޸ģ������ض�Ӧ��ϵ��,�а���Ԫ���ձ� �õ��������������ʧЧ�ˣ������ڸóа���Ԫ�µĸ��������û� ���������ϴ�����
    INSERT INTO ALLDM.BWT_CNTRT_MGMT_CH_REL_M_LOCAL
      SELECT ACCT_MONTH,
             PRVNCE_ID,
             CNTRT_MGMT_UNIT_CD,
             SALE_OUTLETS_CD,
             DEALER_ID
        FROM ALLDM.BWT_CNTRT_MGMT_CHNL_REL_M_DEA
       WHERE ACCT_MONTH = V_MONTH;
    COMMIT;

    SELECT COUNT(1)
      INTO V_COUNT2
      FROM ALLDM.BWT_CNTRT_MGMT_CHNL_REL_M
     WHERE ACCT_MONTH = V_MONTH;
    SELECT COUNT(1)
      INTO V_COUNT3
      FROM ALLDM.BWT_CNTRT_MGMT_CH_REL_M_LOCAL
     WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
    SELECT COUNT(1)
      INTO V_COUNT4
      FROM (SELECT COUNT(1), T.SALE_OUTLETS_CD
              FROM ALLDM.BWT_CNTRT_MGMT_CHNL_REL_M T
             WHERE ACCT_MONTH = V_MONTH
             GROUP BY SALE_OUTLETS_CD
            HAVING COUNT(1) > 1
            UNION ALL
            SELECT COUNT(1), T.SALE_OUTLETS_CD
              FROM ALLDM.BWT_CNTRT_MGMT_CH_REL_M_LOCAL T
             WHERE ACCT_MONTH = V_MONTH
             GROUP BY SALE_OUTLETS_CD
            HAVING COUNT(1) > 1);
    COMMIT;
    IF NVL(V_COUNT2, 0) > 7000 AND NVL(V_COUNT3, 0) > 7000 AND
       NVL(V_COUNT4, 0) < 1 THEN
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
      V_RETCODE := 'FAIL';
      V_RETINFO := SQLERRM;
      ALLDM.P_ALLDM_UPDATE_LOG(V_MONTH,
                               V_PKG,
                               V_PROCNAME,
                               V_RETINFO,
                               V_RETCODE,
                               SYSDATE);
    END IF;
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
