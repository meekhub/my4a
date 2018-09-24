CREATE OR REPLACE PROCEDURE P_BWT_CNTRT_MGMT_UNIT_M(V_MONTH   VARCHAR2,
                                                    V_RETCODE OUT VARCHAR2,
                                                    V_RETINFO OUT VARCHAR2) IS
  /*-----------------------------------------------------------------------
  �� �� ����P_BWT_CNTRT_MGMT_UNIT_M
  �������ڣ�2014��6��28
  �� д �ˣ�MAJIANHUI
  ��  ��  ����
  Ŀ �� ��BWT_CNTRT_MGMT_UNIT_M
  ����˵�����а���Ӫ��Ԫ���루�£�
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
             CASE
               WHEN A.HUAXIAO_NO = '813090030000000' THEN
                '���ݸ�����'
               WHEN A.HUAXIAO_NO = '813060011010000' THEN
                '��Ͻ��'
               ELSE
                B.CITY_DESC
             END,
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
               WHEN HUAXIAO_TYPE = '05' THEN
                '2020'
               WHEN HUAXIAO_TYPE = '06' THEN
                '2010'
               WHEN HUAXIAO_TYPE = '07' THEN
                '2030'
               WHEN HUAXIAO_TYPE = '08' THEN
                '5010'
               WHEN HUAXIAO_TYPE = '09' AND A.HUAXIAO_NAME LIKE '%��ѳа�' THEN
                '6040'
               WHEN HUAXIAO_TYPE = '09' AND A.HUAXIAO_NAME LIKE '%�ۺ�ά���а�' THEN
                '6050'
               WHEN HUAXIAO_TYPE = '09' AND A.HUAXIAO_NAME LIKE '%����֧�ųа�' THEN
                '6020'
               WHEN HUAXIAO_TYPE = '09' AND A.HUAXIAO_NAME LIKE '%ά����Ʒ�а�' THEN
                '6030'
             END CNTRT_MGMT_TYPE, -- ��С�а���Ԫ����
             CASE
               WHEN HUAXIAO_TYPE IN
                    ('01', '02', '03', '04', '05', '06', '07', '08') THEN
                '20'
               WHEN HUAXIAO_TYPE IN ('09') THEN
                '40'
             END CNTRT_MGMT_CHECK_TYPE, -- ��С�а���������
             C.CONTRACTCODE CNTRT_AGRMNT_CD -- �а�Э�����
        FROM DIM.DIM_HUAXIAO_INFO A,
             DIM.DIM_CITY_NO B,
             (SELECT *
                FROM (SELECT A.*,
                             ROW_NUMBER() OVER(PARTITION BY A.SMALLCODE ORDER BY A.STATUS DESC, CONTRACTID DESC) RN
                        FROM CONTRACT_INFO A)
               WHERE RN = 1) C
       WHERE A.CITY_NO = B.CITY_NO
         AND A.HUAXIAO_TYPE IN
             ('01', '02', '03', '04', '05', '06', '07', '08', '09')
         AND A.HUAXIAO_NO = C.SMALLCODE(+);
    COMMIT;
  
    --�����а�
    /*    INSERT \*+APPEND*\
    INTO ALLDM.BWT_CNTRT_MGMT_UNIT_M
      SELECT V_MONTH,
             '813',
             FUNC_GET_AREA_NO(A.AREA_NO),
             B.AREA_DESC,
             A.HUAXIAO_NO,
             A.HUAXIAO_NAME,
             '30', --��С�а���Ԫ�㼶
             '2010',
             '20' CNTRT_MGMT_CHECK_TYPE, -- ��С�а���������
             '' CNTRT_AGRMNT_CD -- �а�Э�����
        FROM DIM.DIM_HUAXIAO_INFO A, DIM.DIM_AREA_NO B
       WHERE A.AREA_NO = B.AREA_NO
         AND A.HUAXIAO_TYPE IN ('06')
         AND SUBSTR(HUAXIAO_NO, -7) = '0000000';
    COMMIT;*/
  
    --�����а�
    /*    INSERT \*+APPEND*\
    INTO ALLDM.BWT_CNTRT_MGMT_UNIT_M
      SELECT V_MONTH,
             '813',
             FUNC_GET_AREA_NO(A.AREA_NO),
             '�ӱ�ʡ',
             A.HUAXIAO_NO,
             A.HUAXIAO_NAME,
             '20', --��С�а���Ԫ�㼶
             '5010',
             '40' CNTRT_MGMT_CHECK_TYPE, -- ��С�а���������
             '' CNTRT_AGRMNT_CD -- �а�Э�����
        FROM DIM.DIM_HUAXIAO_INFO A, DIM.DIM_AREA_NO B
       WHERE A.AREA_NO = B.AREA_NO
         AND A.HUAXIAO_TYPE IN ('08');
    COMMIT;*/
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
