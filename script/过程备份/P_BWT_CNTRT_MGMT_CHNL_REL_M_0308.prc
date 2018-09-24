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

  -- ���ݲ���
  IF V_COUNT1 >= 1 THEN

    --�������
    DELETE FROM ALLDM.BWT_CNTRT_MGMT_CHNL_REL_M WHERE ACCT_MONTH = V_MONTH;
    COMMIT;

    ----ʡ�����������뼯�����������Ӧ��ϵ
    EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_CHANNEL_CBDY';
    INSERT INTO MID_CHANNEL_CBDY
      SELECT DISTINCT DEALER_ID CHANNEL_NO_HB, CHANNEL_NBR
        FROM CRM_DSG.CHANNEL@HBODS;
    COMMIT;

    INSERT INTO BWT_CNTRT_MGMT_CHNL_REL_M
      SELECT V_MONTH, '813', B.HUAXIAO_NO, A.CHANNEL_NBR
        FROM MID_CHANNEL_CBDY A,
             DIM.DIM_CHANNEL_HUAXIAO B,
             (SELECT *
                FROM BWT_CNTRT_MGMT_UNIT_M C
               WHERE ACCT_MONTH = V_MONTH) C
       WHERE A.CHANNEL_NO_HB = B.CHANNEL_NO
         AND B.HUAXIAO_NO = C.CNTRT_MGMT_UNIT_CD;
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
