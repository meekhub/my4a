CREATE OR REPLACE PROCEDURE P_TMP_CNTRT_MGMT_MAIN_REL_M(V_MONTH   VARCHAR2,
                                                        V_RETCODE OUT VARCHAR2,
                                                        V_RETINFO OUT VARCHAR2) IS
  /*-----------------------------------------------------------------------
  �� �� ����P_BWT_CNTRT_MGMT_MAIN_REL_M
  �������ڣ�2014��6��28
  �� д �ˣ�MAJIANHUI
  ��  ��  ����
  Ŀ �� ��BWT_CNTRT_MGMT_MAIN_REL_M
  ����˵������С�а���Ԫ��а���ԪСCEO��ϵ���£�
  -----------------------------------------------------------------------*/
  V_PKG      VARCHAR2(40);
  V_PROCNAME VARCHAR2(40);
  V_COUNT1   NUMBER := 0;
  V_COUNT2   NUMBER := 0;
BEGIN
  V_PKG      := 'P_BWT_CNTRT';
  V_PROCNAME := 'P_BWT_CNTRT_MGMT_MAIN_REL_M';
  --��־����
  ALLDM.P_ALLDM_INSERT_LOG(V_MONTH, V_PKG, V_PROCNAME, '12', SYSDATE);
  ---------------------------------------------------------------
  SELECT COUNT(1)
    INTO V_COUNT1
    FROM ALLDM.ALLDM_EXECUTE_LOG
   WHERE ACCT_MONTH = V_MONTH
     AND RESULT = 'SUCCESS'
     AND PROCNAME IN ('P_BWT_CNTRT_MGMT_CHNL_REL_M', 
                      'P_BWT_CNTRT_MGMT_UNIT_M');
  COMMIT;
  -- ���ݲ���
  IF V_COUNT1 >= 2 THEN

    --�������
    DELETE FROM ALLDM.BWT_CNTRT_MGMT_MAIN_REL_M WHERE ACCT_MONTH = V_MONTH;
    COMMIT;

    INSERT /*+APPEND*/
    INTO ALLDM.BWT_CNTRT_MGMT_MAIN_REL_M
      SELECT DISTINCT V_MONTH,
                      '813',
                      A.CBDY_NO, --�а���Ӫ��Ԫ����
                      '' CNTRT_MGMT_CEO_NM,
                      '' CNTRT_MGMT_CEO_CD
        FROM (SELECT A.CBDY_NO, A.ZHIJU_MANAGER
                FROM DIM.DIM_CBDY_DETAIL A
               WHERE A.ZHIJU_MANAGER IS NOT NULL
                 AND EXISTS (SELECT 1
                        FROM BWT_CNTRT_MGMT_UNIT_M B
                       WHERE B.ACCT_MONTH = V_MONTH
                         AND A.CBDY_NO = B.CNTRT_MGMT_UNIT_CD)
                 AND NVL(ZHIJU_TYPE, '2') NOT IN ('1')
                 AND NOT EXISTS (SELECT 1
                        FROM BWT_CBDY_ZHIJU T
                       WHERE T.ZHIJU_ID IS NOT NULL
                         AND A.CBDY_NO = T.CBDY_NO)
              UNION ALL
              SELECT CBDY_NO, ZHIJU_MANAGER
                FROM BWT_CBDY_ZHIJU A
               WHERE EXISTS (SELECT 1
                        FROM BWT_CNTRT_MGMT_UNIT_M B
                       WHERE B.ACCT_MONTH = V_MONTH
                         AND A.CBDY_NO = B.CNTRT_MGMT_UNIT_CD)
                 AND ZHIJU_ID IS NOT NULL
                 AND A.ZHIJU_MANAGER IS NOT NULL) A
       WHERE EXISTS (SELECT 1
                FROM BWT_CNTRT_MAIN_INFO_M B
               WHERE B.ACCT_MONTH = V_MONTH
                 AND A.ZHIJU_MANAGER = B.CNTRT_MGMT_MAIN_CD);
    COMMIT;
    SELECT COUNT(1)
      INTO V_COUNT2
      FROM (SELECT COUNT(1), T.CNTRT_MGMT_UNIT_CD
              FROM ALLDM.BWT_CNTRT_MGMT_MAIN_REL_M T
             WHERE ACCT_MONTH = V_MONTH
             GROUP BY CNTRT_MGMT_UNIT_CD
            HAVING COUNT(1) > 1);
    COMMIT;
    IF V_COUNT2 < 1 THEN
      --������־
      V_RETCODE := 'SUCCESS';
      ALLDM.P_ALLDM_UPDATE_LOG(V_MONTH,
                               V_PKG,
                               V_PROCNAME,
                               '����',
                               V_RETCODE,
                               SYSDATE);
      DBMS_OUTPUT.PUT_LINE(V_RETCODE);
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
