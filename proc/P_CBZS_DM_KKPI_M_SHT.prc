CREATE OR REPLACE PROCEDURE MOBILE_CBZS.P_CBZS_DM_KKPI_M_SHT(V_MONTH   VARCHAR2,
                                                 V_RETCODE OUT VARCHAR2,
                                                 V_RETINFO OUT VARCHAR2) IS
  /*-----------------------------------------------------------------------
  �� �� ����P_CBZS_DM_KKPI_M_SHT
  �������ڣ�201803
  �� д �ˣ�LIYA
  ��  ��  ����
  Ŀ �� ��CBZS_DM_KKPI_M_SHT
  ����˵����(�»�С)��͸���±�
  -----------------------------------------------------------------------*/
  V_PKG        VARCHAR2(40);
  V_PROCNAME   VARCHAR2(40);
  V_COUNT1     NUMBER := 0;
  V_LAST_MONTH VARCHAR2(20);
  /*CURSOR V_AREA IS
  SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018';*/
BEGIN
  V_PKG        := '(�»�С)��͸���±�';
  V_PROCNAME   := 'P_CBZS_DM_KKPI_M_SHT';
  V_LAST_MONTH := TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH, 'YYYYMM'), -1),
                          'YYYYMM');
  /*  IF SUBSTR(V_LAST_MONTH,1,4) <  SUBSTR(V_MONTH,1,4) THEN
    V_LAST_MONTH := V_MONTH;
  END IF;*/
  /*  V_LAST_YEAR  := TO_CHAR(ADD_MONTHS(TO_CHAR(TO_DATE(V_MONTH, 'YYYYMM')),
             -12),
  'YYYYMM');*/
  --��־����
  ALLDM.P_ALLDM_INSERT_LOG(V_MONTH, V_PKG, V_PROCNAME, '12', SYSDATE);
  ---------------------------------------------------------------
  -- ���ݲ���

  SELECT COUNT(1)
    INTO V_COUNT1
    FROM ALLDM.ALLDM_EXECUTE_LOG
   WHERE ACCT_MONTH = V_MONTH
     AND RESULT = 'SUCCESS'
     AND PROCNAME IN ('P_DM_V_CHANNEL_INFO_M');

  IF V_COUNT1 >= 0 THEN
  
    /*DELETE FROM MOBILE_CBZS.CBZS_DM_KKPI_M_SHT_CHANNEL T
     WHERE T.ACCT_MONTH = V_MONTH;
    COMMIT;
    INSERT INTO MOBILE_CBZS.CBZS_DM_KKPI_M_SHT_CHANNEL */
  
    ----��͸����ײ㵽��С��Ԫ����ֻ���������ݼ��ɣ���������
    ----20180426 �޸ĵ���ײ㵽С��
    DELETE FROM MOBILE_CBZS.CBZS_DM_KKPI_M_SHT_CHANNEL
     WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
    ---�����͸��
    INSERT INTO MOBILE_CBZS.CBZS_DM_KKPI_M_SHT_CHANNEL
      SELECT V_MONTH,
             T.AREA_NO,
             T.CITY_NO,
             '1',
             T.HUAXIAO_TYPE,
             T.HUAXIAO_NO,
             '',
             T.XIAOQU_NO,
             T.XIAOQU_NAME,
             '01',
             '01',
             SUM(KD_USER) KD_USER,
             SUM(RUZHU_USER) RUZHU_USER
        FROM DIM.DIM_XIAOQU_HUAXIAO T, DIM.DIM_XIAOQU_SHENTOU A
       WHERE T.XIAOQU_NO = A.XIAOQU_NO
         AND T.HUAXIAO_TYPE IN ('01', '02', '03', '04')
       GROUP BY HUAXIAO_NO,
                T.AREA_NO,
                T.CITY_NO,
                T.HUAXIAO_TYPE,
                T.XIAOQU_NO,
                T.XIAOQU_NAME;
    COMMIT;
  
    ----������͸��
    INSERT INTO MOBILE_CBZS.CBZS_DM_KKPI_M_SHT_CHANNEL
      SELECT V_MONTH,
             T.AREA_NO,
             T.CITY_NO,
             '1',
             T.HUAXIAO_TYPE,
             T.HUAXIAO_NO,
             '',
             T.XIAOQU_NO,
             T.XIAOQU_NAME,
             '02',
             '01',
             SUM(A.ITV_USER) KD_USER,
             SUM(RUZHU_USER) RUZHU_USER
        FROM DIM.DIM_XIAOQU_HUAXIAO T, DIM.DIM_XIAOQU_SHENTOU A
       WHERE T.XIAOQU_NO = A.XIAOQU_NO
         AND T.HUAXIAO_TYPE IN ('01', '02', '03', '04')
       GROUP BY HUAXIAO_NO,
                T.AREA_NO,
                T.CITY_NO,
                T.HUAXIAO_TYPE,
                T.XIAOQU_NO,
                T.XIAOQU_NAME;
    COMMIT;
  
    ------����һ����������
    DELETE FROM MOBILE_CBZS.CBZS_DM_KKPI_M_SHT
     WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
    INSERT INTO MOBILE_CBZS.CBZS_DM_KKPI_M_SHT
      SELECT ACCT_MONTH,
             AREA_NO,
             CITY_NO,
             HUAXIAO_TYPE_BIG,
             HUAXIAO_TYPE,
             HUAXIAO_NO,
             TYPE_ONE,
             TYPE_TWO,
             SUM(USER_NUM),
             SUM(ZHUHU_NUM)
        FROM MOBILE_CBZS.CBZS_DM_KKPI_M_SHT_CHANNEL
       WHERE ACCT_MONTH = V_MONTH
       GROUP BY ACCT_MONTH,
                AREA_NO,
                CITY_NO,
                HUAXIAO_TYPE_BIG,
                HUAXIAO_TYPE,
                HUAXIAO_NO,
                TYPE_ONE,
                TYPE_TWO;
    COMMIT;
  
    ------���������������
    DELETE FROM MOBILE_CBZS.CBZS_DM_KKPI_M_SHT_ADMIN
     WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
    INSERT INTO MOBILE_CBZS.CBZS_DM_KKPI_M_SHT_ADMIN
      SELECT ACCT_MONTH,
             AREA_NO,
             CITY_NO,
             HUAXIAO_TYPE_BIG,
             HUAXIAO_TYPE,
             TYPE_ONE,
             TYPE_TWO,
             SUM(USER_NUM),
             SUM(ZHUHU_NUM)
        FROM MOBILE_CBZS.CBZS_DM_KKPI_M_SHT
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
