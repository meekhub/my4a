CREATE OR REPLACE PROCEDURE P_BWT_CNTRT_MGMT_UNIT_M(V_MONTH   VARCHAR2,
                                                    V_RETCODE OUT VARCHAR2,
                                                    V_RETINFO OUT VARCHAR2) IS
  /*-----------------------------------------------------------------------
  �� �� ����P_BWT_CNTRT_MGMT_UNIT_M
  �������ڣ�2014��6��28
  �� д �ˣ�MAJIANHUI
  ��  ��  ����
  Ŀ �� ��BWT_CNTRT_MGMT_UNIT_M
  ����˵������С�а���Ԫ���루�£�
  �޸ļ�¼��201712 �����޸�
  -----------------------------------------------------------------------*/
  V_PKG      VARCHAR2(40);
  V_PROCNAME VARCHAR2(40);
  V_COUNT1   NUMBER := 0;

BEGIN
  V_PKG      := 'P_BWT_CNTRT';
  V_PROCNAME := 'P_BWT_CNTRT_MGMT_UNIT_M';
  --��־����
  ALLDM.P_ALLDM_INSERT_LOG(V_MONTH, V_PKG, V_PROCNAME, '12', SYSDATE);
  ---------------------------------------------------------------
  -- ���ݲ���
  IF V_COUNT1 >= 0 THEN
  
    --�������
    DELETE FROM ALLDM.BWT_CNTRT_MGMT_UNIT_M WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
    -----����ʵ�����������ݣ��������ڻ�û�����ݣ�
    INSERT /*+APPEND*/
    INTO ALLDM.BWT_CNTRT_MGMT_UNIT_M
      SELECT V_MONTH,
             '813',
             FUNC_GET_AREA_NO(A.AREA_NO),
             B.CITY_DESC,
             A.HUAXIAO_NO,
             A.HUAXIAO_NAME,
             '40', --��С�а���Ԫ�㼶
             CASE
               WHEN HUAXIAO_TYPE = '01' THEN
                '3010'
               WHEN HUAXIAO_TYPE = '02' THEN
                '3020'
               WHEN HUAXIAO_TYPE = '03' THEN
                '3030'
               WHEN HUAXIAO_TYPE = '04' THEN
                '1020'
             END CNTRT_MGMT_TYPE, -- ��С�а���Ԫ����
             CASE
               WHEN HUAXIAO_TYPE IN ('01', '02') THEN
                '10'
               WHEN HUAXIAO_TYPE IN ('03', '04') THEN
                '20'
             END CNTRT_MGMT_CHECK_TYPE, -- ��С�а���������
             '' CNTRT_AGRMNT_CD -- �а�Э�����
        FROM DIM.DIM_HUAXIAO_INFO A, DIM.DIM_CITY_NO B
       WHERE A.CITY_NO = B.CITY_NO;
    COMMIT;
    SELECT COUNT(1)
      INTO V_COUNT1
      FROM ALLDM.BWT_CNTRT_MGMT_UNIT_M
     WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('111111111111');
    IF V_COUNT1 > 1500 THEN
      --������־
      V_RETCODE := 'SUCCESS';
      ALLDM.P_ALLDM_UPDATE_LOG(V_MONTH,
                               V_PKG,
                               V_PROCNAME,
                               '����',
                               V_RETCODE,
                               SYSDATE);
      DBMS_OUTPUT.PUT_LINE('2222222222222222');
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
    DBMS_OUTPUT.PUT_LINE('3333333333333');
    ------------------------------------- ���ݲ��ֽ��� -------------------------
  ELSE
    V_RETCODE := 'WAIT';
    ALLDM.P_ALLDM_UPDATE_LOG(V_MONTH,
                             V_PKG,
                             V_PROCNAME,
                             '�ȴ�',
                             'WAIT',
                             SYSDATE);
    DBMS_OUTPUT.PUT_LINE('44444444444444');
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
    DBMS_OUTPUT.PUT_LINE('555555555555');
END;
/
