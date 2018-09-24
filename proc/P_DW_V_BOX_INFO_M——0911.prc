CREATE OR REPLACE PROCEDURE DW.P_DW_V_BOX_INFO_M(V_ACCT_MONTH VARCHAR2,
                                                 V_RETCODE    OUT VARCHAR2,
                                                 V_RETINFO    OUT VARCHAR2) IS
  /*****************************************************************
  *���� --%NAME:P_DW_V_BOX_INFO_M_M
  *�������� --%COMMENT: ��Դ��������ϸ��
  *ִ������ --%PERIOD: ��
  *���� --%PARAM:V_ACCT_MONTH  ����,��ʽYYYYMM
  *���� --%PARAM:V_RETCODE  �������н����ɹ�����־
  *���� --%PARAM:V_RETCODE  �������н����ɹ��������
  *������ --%CREATOR:MAJIANHUI
  *����ʱ�� --%CREATED_TIME:2018-08-05
  *��ע --%REMARK:
  *��Դ�� --%FROM:
  *Ŀ��� --%TO:   DW.DW_V_USER_BUTIE_M
  *�޸ļ�¼ --%MODIFY: NULL
  *******************************************************************/
  V_PKG      VARCHAR2(40);
  V_PROCNAME VARCHAR2(40);
  V_COUNT    NUMBER;

BEGIN
  V_PKG      := '��Դ��������ϸ��';
  V_PROCNAME := 'P_DW_V_BOX_INFO_M';

  --��־����
  P_INSERT_LOG(V_ACCT_MONTH, V_PKG, V_PROCNAME, '12', SYSDATE);
  --------------------------------------------------------------
  -- ���ݲ���
  SELECT COUNT(1)
    INTO V_COUNT
    FROM DW.DW_EXECUTE_LOG
   WHERE ACCT_MONTH = V_ACCT_MONTH
     AND RESULT = 'SUCCESS'
     AND PROCNAME IN ('');

  IF V_COUNT >= 0 THEN
  
    EXECUTE IMMEDIATE 'ALTER TABLE DW.DW_V_BOX_INFO_M TRUNCATE PARTITION PART' ||
                      V_ACCT_MONTH;
  
    INSERT /*+APPEND*/
    INTO DW_V_BOX_INFO_M NOLOGGING
      SELECT V_ACCT_MONTH,
             B.AREA_NO,
             A.CITY_DESC,
             A.FGQ_NAME,
             A.FGQ_ID,
             A.PROJECT_ID,
             A.PROJECT_DESC,
             A.FGQ_DATE,
             A.STANDARD_NAME,
             A.STANDARD_ID,
             A.BOX_NAME,
             A.BOX_ID,
             A.DK_NUMBER,
             A.DK_USE_NUMBER
        FROM STAGE.ZIYUAN_LINBOX_M@HBODS A, DIM.DIM_AREA_NO B
       WHERE '0' || A.AREA_DESC = B.AREA_CODE;
    COMMIT;
  
    --������־
    V_RETCODE := 'SUCCESS';
    P_UPDATE_LOG(V_ACCT_MONTH,
                 V_PKG,
                 V_PROCNAME,
                 '����',
                 V_RETCODE,
                 SYSDATE);
    DBMS_OUTPUT.PUT_LINE(V_RETCODE);
    ------------------------------------- ���ݲ��ֽ��� -----------------------------------------------------
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
                 V_RETCODE,
                 SYSDATE);
END;
/
