CREATE OR REPLACE PROCEDURE P_INTEGRAL_SYS_SUM_M(V_MONTH   VARCHAR2,
                                                 V_RETCODE OUT VARCHAR2,
                                                 V_RETINFO OUT VARCHAR2) IS
  /*****************************************************************
  *���� --%NAME: P_INTEGRAL_SYS_SUM_M
  *�������� --%COMMENT:
  *ִ������ --%PERIOD: ��
  *���� --%PARAM:V_MONTH  ����,��ʽYYYYMM
  *���� --%PARAM:V_RETCODE  �������н����ɹ�����־
  *���� --%PARAM:V_RETCODE  �������н����ɹ��������
  *������ --%CREATOR: LIYA
  *����ʱ�� --%CREATED_TIME:20170710
  *��ע --%REMARK:
  *��Դ�� --%FROM:
  *Ŀ��� --%TO:
  *�޸ļ�¼ --%MODIFY:
  *******************************************************************/
  V_PKG      VARCHAR2(40);
  V_PROCNAME VARCHAR2(40);
  V_COUNT    NUMBER := 0;

  V_LAST_MONTH VARCHAR2(40);
  V_LAST_DAY   VARCHAR2(40);

  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO NOT IN ('018');

BEGIN
  V_PKG        := '����������ϵ';
  V_PROCNAME   := 'P_INTEGRAL_SYS_SUM_M';
  V_LAST_DAY   := TO_CHAR(LAST_DAY(TO_DATE(V_MONTH, 'YYYYMM')), 'YYYYMMDD');
  V_LAST_MONTH := TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH, 'YYYYMM'), -1),
                          'YYYYMM');

  --��־����
  ALLDM.P_ALLDM_INSERT_LOG(V_MONTH, V_PKG, V_PROCNAME, '12', SYSDATE);
  ---------------------------------------------------------------
  -- ���ݲ���

  SELECT COUNT(1)
    INTO V_COUNT
    FROM ALLDM_EXECUTE_LOG
   WHERE ACCT_MONTH = V_MONTH
     AND RESULT = 'SUCCESS'
     AND PROCNAME IN ('P_INTEGRAL_SYS_INCOME_JF_M',
                      'P_INTEGRAL_SYS_WEIXI_JF_M',
                      'P_INTEGRAL_SYS_FINE_JF_M');

  IF V_COUNT = 3 THEN
    DELETE FROM INTEGRAL_SYS_SUM_M WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
    INSERT INTO INTEGRAL_SYS_SUM_M
      SELECT V_MONTH,
             A.AREA_NO,
             A.CITY_NO,
             B.AGENT_ID,
             B.AGENT_NAME,
             A.CHANNEL_NO,
             CEIL(NVL(C.VALUE_MON, 0)),
             CEIL(NVL(D.LOW_VALUE, 0)),
             CEIL(NVL(E.VALUE_MON, 0)),
             CEIL(NVL(F.LOW_VALUE, 0)),
             CEIL(NVL(C.VALUE_MON, 0) + NVL(D.LOW_VALUE, 0) +
                  NVL(E.VALUE_MON, 0) + NVL(F.LOW_VALUE, 0)),
             CEIL(NVL(C_SINGLE_DP, 0)),
             CEIL(NVL(BUNDLE_DP, 0)),
             CEIL(NVL(GW_DP, 0)),
             CEIL(NVL(C_SINGLE_INCO, 0)),
             CEIL(NVL(BUNDLE_INCO, 0)),
             CEIL(NVL(GW_INCO, 0)),
             CEIL(NVL(ZZH_INCO, 0)),
             CEIL(NVL(C_UP_WX, 0)),
             CEIL(NVL(G_CONT_WX, 0)),
             CEIL(NVL(C_CONT_WX, 0)),
             CEIL(NVL(GIVE_WX, 0)),
             CEIL(NVL(DP_FINE, 0)),
             CEIL(NVL(WX_FINE, 0)),
             NVL(B.CHANNEL_PROP_NO, '01'),
             NVL(B.CHANNEL_PROP_NAME, '��Ȧ'),
             NVL(B.REGION_PROP_NO, '07'),
             NVL(B.REGION_PROP_NAME, '����')
      
        FROM (SELECT *
                FROM DIM.DIM_CHANNEL_NO
               WHERE CHANNEL_TYPE LIKE '11%'
                 AND VALID_STATUS = '1') A,
             (SELECT DISTINCT AGENT_ID,
                              AGENT_NAME,
                              CHANNEL_NO,
                              CASE
                                WHEN T.CHANNEL_TYPE = '110101' THEN
                                 '04'
                                WHEN BUSINESS_ZONE = '10' THEN
                                 '02'
                                WHEN BUSINESS_ZONE_NAME LIKE '%��Ȧ%' THEN
                                 '01'
                                ELSE
                                 '03'
                              END CHANNEL_PROP_NO,
                              CASE
                                WHEN T.CHANNEL_TYPE = '110101' THEN
                                 '��Ӫ'
                                WHEN BUSINESS_ZONE = '10' THEN
                                 '����'
                                WHEN BUSINESS_ZONE_NAME LIKE '%��Ȧ%' THEN
                                 '��Ȧ'
                                ELSE
                                 'ũ��'
                              END CHANNEL_PROP_NAME,
                              
                              CASE
                                WHEN T.CHANNEL_TYPE IN ('110101') THEN
                                 '01'
                                WHEN T.CHANNEL_TYPE IN ('110201') THEN
                                 '02'
                                WHEN T.CHANNEL_TYPE IN ('110301') THEN
                                 '03'
                                WHEN T.CHANNEL_TYPE IN ('110302') THEN
                                 '04'
                                WHEN (T.CHANNEL_TYPE NOT IN
                                     ('110101',
                                       '110102',
                                       '110103',
                                       '110201',
                                       '110301',
                                       '110302') OR T.CHANNEL_TYPE IS NULL) AND
                                     T.PROTOP10 IN ('1', '2') THEN
                                 '05'
                                WHEN (T.CHANNEL_TYPE NOT IN
                                     ('110101',
                                       '110102',
                                       '110103',
                                       '110201',
                                       '110301',
                                       '110302') OR T.CHANNEL_TYPE IS NULL) AND
                                     (T.PROTOP10 NOT IN ('1', '2') OR
                                     T.PROTOP10 IS NULL) THEN
                                 '06'
                                WHEN T.CHANNEL_TYPE IN ('110102') THEN
                                 '07'
                                WHEN T.CHANNEL_TYPE IN ('110103') THEN
                                 '08'
                                ELSE
                                 '09'
                              END REGION_PROP_NO,
                              CASE
                                WHEN T.CHANNEL_TYPE IN
                                     ('110101' /*, '110102', '110103'*/) THEN
                                 '��Ӫ��'
                                WHEN T.CHANNEL_TYPE IN ('110201') THEN
                                 'רӪ��'
                                WHEN T.CHANNEL_TYPE IN ('110301') THEN
                                 '��������'
                                WHEN T.CHANNEL_TYPE IN ('110302') THEN
                                 'ʡ������'
                                WHEN (T.CHANNEL_TYPE NOT IN
                                     ('110101',
                                       '110102',
                                       '110103',
                                       '110201',
                                       '110301',
                                       '110302') OR T.CHANNEL_TYPE IS NULL) AND
                                     T.PROTOP10 IN ('1', '2') THEN
                                 'ʡ��TOP'
                                WHEN (T.CHANNEL_TYPE NOT IN
                                     ('110101',
                                       '110102',
                                       '110103',
                                       '110201',
                                       '110301',
                                       '110302') OR T.CHANNEL_TYPE IS NULL) AND
                                     (T.PROTOP10 NOT IN ('1', '2') OR
                                     T.PROTOP10 IS NULL) THEN
                                 '��С��Ӫ'
                                WHEN T.CHANNEL_TYPE IN ('110102') THEN
                                 '�����'
                                WHEN T.CHANNEL_TYPE IN ('110103') THEN
                                 '�����'
                                ELSE
                                 '����'
                              END REGION_PROP_NAME
                FROM RPT_HBTELE.DM_BUSI_CHANNEL_BUILD T
               WHERE ACCT_MONTH = V_MONTH) B,
             (SELECT CHANNEL_NO,
                     SUM(VALUE_MON) VALUE_MON,
                     SUM(CASE
                           WHEN TELE_TYPE = '�ƶ�����Ʒ����' THEN
                            VALUE_MON
                           ELSE
                            0
                         END) C_SINGLE_DP,
                     SUM(CASE
                           WHEN TELE_TYPE = '�ں�ҵ�����' THEN
                            VALUE_MON
                           ELSE
                            0
                         END) BUNDLE_DP,
                     SUM(CASE
                           WHEN TELE_TYPE = '����ҵ�����' THEN
                            VALUE_MON
                           ELSE
                            0
                         END) GW_DP
                FROM INTEGRAL_SYS_DEVLP_JF_D
               WHERE DAY_ID = V_LAST_DAY
               GROUP BY CHANNEL_NO) C,
             (SELECT CHANNEL_NO,
                     SUM(LOW_VALUE) LOW_VALUE,
                     SUM(CASE
                           WHEN JF_TYPE = '�ƶ�����Ʒ����' THEN
                            LOW_VALUE
                           ELSE
                            0
                         END) C_SINGLE_INCO,
                     SUM(CASE
                           WHEN JF_TYPE = '�ں�ҵ�����' THEN
                            LOW_VALUE
                           ELSE
                            0
                         END) BUNDLE_INCO,
                     SUM(CASE
                           WHEN JF_TYPE = '����ҵ�����' THEN
                            LOW_VALUE
                           ELSE
                            0
                         END) GW_INCO,
                     SUM(CASE
                           WHEN JF_TYPE = '��ֵҵ�����' THEN
                            LOW_VALUE
                           ELSE
                            0
                         END) ZZH_INCO
                FROM INTEGRAL_SYS_INCOME_JF_M
               WHERE ACCT_MONTH = V_MONTH
               GROUP BY CHANNEL_NO) D,
             (SELECT CHANNEL_NO,
                     SUM(LOW_VALUE) VALUE_MON,
                     SUM(CASE
                           WHEN TELE_TYPE = '�ƶ��ײ���������' THEN
                            LOW_VALUE
                           ELSE
                            0
                         END) C_UP_WX,
                     SUM(CASE
                           WHEN TELE_TYPE = '������Լ����' THEN
                            LOW_VALUE
                           ELSE
                            0
                         END) G_CONT_WX,
                     SUM(CASE
                           WHEN TELE_TYPE = '�ƶ��û���Լ����' THEN
                            LOW_VALUE
                           ELSE
                            0
                         END) C_CONT_WX,
                     SUM(CASE
                           WHEN TELE_TYPE = '����ҵ�����' THEN
                            LOW_VALUE
                           ELSE
                            0
                         END) GIVE_WX
                FROM INTEGRAL_SYS_WEIXI_JF_M
               WHERE ACCT_MONTH = V_MONTH
               GROUP BY CHANNEL_NO) E,
             (SELECT CHANNEL_NO,
                     SUM(LOW_VALUE) LOW_VALUE,
                     SUM(CASE
                           WHEN JF_TYPE = '��չ����ֿ۷�' THEN
                            LOW_VALUE
                           ELSE
                            0
                         END) DP_FINE,
                     SUM(CASE
                           WHEN JF_TYPE = 'άϵ����ֿ۷�' THEN
                            LOW_VALUE
                           ELSE
                            0
                         END) WX_FINE
                FROM INTEGRAL_SYS_FINE_JF_M
               WHERE ACCT_MONTH = V_MONTH
               GROUP BY CHANNEL_NO) F
       WHERE A.CHANNEL_NO = B.CHANNEL_NO(+)
         AND A.CHANNEL_NO = C.CHANNEL_NO(+)
         AND A.CHANNEL_NO = D.CHANNEL_NO(+)
         AND A.CHANNEL_NO = E.CHANNEL_NO(+)
         AND A.CHANNEL_NO = F.CHANNEL_NO(+);
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
