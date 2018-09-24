CREATE OR REPLACE PROCEDURE ALLDM.P_DM_BS_STATION_RRU(V_ACCT_MONTH VARCHAR2,
                                                      V_RETCODE    OUT VARCHAR2,
                                                      V_RETINFO    OUT VARCHAR2) IS
  /*****************************************************************
  *���� --%NAME:P_DM_BS_STATION_REPORT
  *�������� --%COMMENT: ��վRRU���в�æ
  *ִ������ --%PERIOD: ��
  *���� --%PARAM:V_ACCT_MONTH  ����,��ʽYYYYMM
  *���� --%PARAM:V_RETCODE  �������н����ɹ�����־
  *���� --%PARAM:V_RETCODE  �������н����ɹ��������
  *������ --%CREATOR:ZUOWENJIE
  *����ʱ�� --%CREATED_TIME:2018-08-08
  *��ע --%REMARK:
  *��Դ�� --%FROM:
  *��Դ�� --%FROM:
  *Ŀ��� --%TO:
  *�޸ļ�¼ --%MODIFY:
  *******************************************************************/
  V_PKG      VARCHAR2(40);
  V_PROCNAME VARCHAR2(40);
  V_COUNT    NUMBER;
  V_MONTH_1  VARCHAR2(6);
  V_MONTH_2  VARCHAR2(6);

BEGIN
  V_PKG      := '��վRRU���в�æ';
  V_PROCNAME := 'P_DM_BS_STATION_RRU';
  V_MONTH_1  := TO_CHAR(ADD_MONTHS(TO_DATE(V_ACCT_MONTH, 'YYYYMM'), -1),
                        'YYYYMM');
  V_MONTH_2  := TO_CHAR(ADD_MONTHS(TO_DATE(V_ACCT_MONTH, 'YYYYMM'), -2),
                        'YYYYMM');

  SELECT COUNT(1)
    INTO V_COUNT
    FROM ODS.ODS_EXECUTE_LOG@HBODS A
   WHERE A.ACCT_MONTH = V_ACCT_MONTH
     AND A.PROCNAME = 'P_O_RES_STATION_INFO_M'
     AND A.RESULT = 'SUCCESS';

  --������־
  P_ALLDM_INSERT_LOG(V_ACCT_MONTH, V_PKG, V_PROCNAME, '12', SYSDATE);

  IF V_COUNT >= 1 THEN

    --RRU�����嵥
    DELETE FROM ALLDM.DM_BS_STATION_RRU_FREE
     WHERE ACCT_MONTH = V_ACCT_MONTH;
    COMMIT;

        --����С���������ֶΡ�С����������޳����ҷָ��ǡ������ݡ�Ƶ�α�ʶ���޳�3��5
        --�������߻������ֶΡ����ǵ�·���͡��޳����������������١�
    EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_STATION_DEL_INFO_R';
     INSERT INTO MID_STATION_DEL_INFO_R
       SELECT DISTINCT A.XIAOQU_NO
         FROM ODS.O_RES_BS_STATION_XIAOQU@HBODS A,
              ODS.O_RES_BS_STATION_TX@HBODS     B
        WHERE A.TIANXIAN_NO = B.TIANXIAN_NO
          AND B.FG_DAOLU_TYPE IN ('����', '����')
          AND A.ACCT_MONTH = V_ACCT_MONTH
          AND B.ACCT_MONTH = V_ACCT_MONTH
       UNION
       SELECT distinct XIAOQU_NO
       FROM ODS.O_RES_BS_STATION_XIAOQU@HBODS where ACCT_MONTH = V_ACCT_MONTH
       AND (XIAOQU_NAME LIKE '%S-%' OR XIAOQU_NAME LIKE '%L800%'
          OR XIAOQU_NAME LIKE '%L1800%' OR FG_TYPE = '�ҷָ���' OR PINDUAN NOT IN ('1','4')
          OR XIAOQU_NAME LIKE '%Ӧ��%' OR XIAOQU_NAME LIKE '%-S%');
     COMMIT;

    INSERT /*+APPEND*/
    INTO ALLDM.DM_BS_STATION_RRU_FREE NOLOGGING
      SELECT V_ACCT_MONTH,
             AREA_NO,
             AREA_NAME,
             CITY_NAME,
             ENB_NO,
             ENB_NAME,
             XIAOQU_NO,
             XIAOQU_NAME,
             ECI,
             RRU_NO,
             RRU_ELECT_NO,
             FLUX,
             USER_NUM,
             ASSET_NO,
             ASSET_PRICE,
             CASE
               WHEN T.FLUX / 1024 / RRU_NUM < 25 THEN
                '������δ�ﵽ25G'
               ELSE
                ''
             END,
             INNET_DATE
        FROM (SELECT AREA_NO,
                     AREA_NAME,
                     CITY_NAME,
                     A.ENB_NO,
                     A.ENB_NAME,
                     A.XIAOQU_NO,
                     B.XIAOQU_NAME,
                     B.ECI,
                     A.RRU_NO,
                     A.RRU_ELECT_NO,
                     C.FLUX,
                     '' USER_NUM,
                     '' ASSET_NO,
                     '' ASSET_PRICE,
                     NVL(RRU_NUM, 1) RRU_NUM,
                     TO_DATE(INNET_DATE, 'YYYY-MM-DD HH24:MI:SS') INNET_DATE
                FROM ODS.O_RES_BS_STATION_RRU@HBODS A,
                     (SELECT DISTINCT XIAOQU_NO, XIAOQU_NAME, ECI
                        FROM ODS.O_RES_BS_STATION_XIAOQU@HBODS
                       WHERE ACCT_MONTH = V_ACCT_MONTH) B,
                     (SELECT A.XIAOQU_NO, A.UP_FLUX + A.DOWN_FLUX FLUX
                        FROM ODS.O_RES_BS_STATION_FLUX@HBODS A
                       WHERE A.ACCT_MONTH = V_ACCT_MONTH) C,
                     (SELECT XIAOQU_NO, COUNT(1) RRU_NUM
                        FROM ODS.O_RES_BS_STATION_RRU@HBODS
                       WHERE ACCT_MONTH = V_ACCT_MONTH
                       GROUP BY XIAOQU_NO) D
               WHERE A.ACCT_MONTH = V_ACCT_MONTH
                 AND A.XIAOQU_NO = B.XIAOQU_NO(+)
                 AND A.XIAOQU_NO = C.XIAOQU_NO(+)
                 AND A.XIAOQU_NO = D.XIAOQU_NO(+) 
                 and to_date(a.innet_date,'yyyy/mm/dd HH24:MI') < add_months(to_date(V_ACCT_MONTH,'yyyymm'),-1)
                 AND NOT EXISTS
                       (SELECT 1
                                FROM MID_STATION_DEL_INFO_R X
                               where A.XIAOQU_NO = X.XIAOQU_NO)) T;
    /*WHERE T.FLUX / 1024 / RRU_NUM < 25;*/



    --RRU��æ��������嵥
    DELETE FROM ALLDM.DM_BS_STATION_RRU_BUSY
     WHERE ACCT_MONTH = V_ACCT_MONTH;
    COMMIT;

    INSERT /*+APPEND*/
    INTO ALLDM.DM_BS_STATION_RRU_BUSY NOLOGGING
      SELECT V_ACCT_MONTH,
             T.AREA_NO,
             T.AREA_NAME,
             T.CITY_NAME,
             T.ASSET_NO,
             T.ASSET_PRICE,
             T.RRU_ELECT_NO,
             T.XIAOQU_NO,
             T.XIAOQU_NAME,
             T.XIAOQU_NO_NEW,
             T.XIAOQU_NAME_NEW,
             T.INNET_DATE,
             T.RRU_NUM,
             T.RRU_NUM_NEW,
             CASE
               WHEN RRU_NUM_NEW - RRU_NUM >= 1 THEN
                '��Ч'
               ELSE
                '��Ч'
             END
        FROM (SELECT A.AREA_NO,
                     A.AREA_NAME,
                     A.CITY_NAME,
                     A.ASSET_NO,
                     A.ASSET_PRICE,
                     A.RRU_ELECT_NO,
                     A.XIAOQU_NO,
                     A.XIAOQU_NAME,
                     B.XIAOQU_NO    XIAOQU_NO_NEW,
                     B.XIAOQU_NAME  XIAOQU_NAME_NEW,
                     B.INNET_DATE,
                     A.RRU_NUM,
                     B.RRU_NUM      RRU_NUM_NEW
                FROM (SELECT /*+FULL(A)*/
                       AREA_NO,
                       AREA_NAME,
                       CITY_NAME,
                       ASSET_NO,
                       ASSET_PRICE,
                       RRU_ELECT_NO,
                       A.XIAOQU_NO,
                       A.XIAOQU_NAME,
                       B.RRU_NUM
                        FROM DM_BS_STATION_RRU_FREE A,
                             (SELECT /*+FULL(B)*/
                               XIAOQU_NO, COUNT(DISTINCT RRU_ELECT_NO) RRU_NUM
                                FROM DM_BS_STATION_RRU_FREE B
                               WHERE ACCT_MONTH = V_MONTH_1
                               GROUP BY XIAOQU_NO) B
                       WHERE A.ACCT_MONTH = V_MONTH_1
                         AND A.ASSESS_RESULT = '������δ�ﵽ25G'
                         AND A.XIAOQU_NO = B.XIAOQU_NO) A,
                     (SELECT /*+FULL(A)*/
                       RRU_ELECT_NO,
                       A.XIAOQU_NO,
                       A.XIAOQU_NAME,
                       A.INNET_DATE,
                       B.RRU_NUM
                        FROM DM_BS_STATION_RRU_FREE A,
                             (SELECT /*+FULL(B)*/
                               XIAOQU_NO, COUNT(DISTINCT RRU_ELECT_NO) RRU_NUM
                                FROM DM_BS_STATION_RRU_FREE B
                               WHERE ACCT_MONTH = V_ACCT_MONTH
                               GROUP BY XIAOQU_NO) B
                       WHERE A.ACCT_MONTH = V_ACCT_MONTH
                         AND A.XIAOQU_NO = B.XIAOQU_NO) B
               WHERE A.RRU_ELECT_NO = B.RRU_ELECT_NO(+)) T
       WHERE T.XIAOQU_NO <> T.XIAOQU_NO_NEW
         AND T.XIAOQU_NO_NEW IS NOT NULL;



    --RRU��æ�������
    DELETE FROM ALLDM.DM_BS_STATION_RRU_RATE
     WHERE ACCT_MONTH = V_ACCT_MONTH;
    COMMIT;

    INSERT /*+APPEND*/
    INTO ALLDM.DM_BS_STATION_RRU_RATE NOLOGGING
      SELECT V_ACCT_MONTH,
             T.AREA_NO,
             T.AREA_NAME,
             COUNT(DISTINCT RRU_ELECT_NO) RRU_NUM,
             COUNT(DISTINCT DECODE(RRU_RESULT, '��Ч', RRU_ELECT_NO, NULL)),
             COUNT(DISTINCT DECODE(RRU_RESULT, '��Ч', RRU_ELECT_NO, NULL)) /
             COUNT(DISTINCT RRU_ELECT_NO)
        FROM ALLDM.DM_BS_STATION_RRU_BUSY T
       WHERE T.ACCT_MONTH = V_ACCT_MONTH
       GROUP BY T.AREA_NO, T.AREA_NAME;




    --������־
    V_RETCODE := 'SUCCESS';
    P_ALLDM_UPDATE_LOG(V_ACCT_MONTH,
                       V_PKG,
                       V_PROCNAME,
                       '����',
                       'SUCCESS',
                       SYSDATE);

  ELSE
    V_RETCODE := 'WAIT';
    P_ALLDM_UPDATE_LOG(V_ACCT_MONTH,
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
    P_ALLDM_UPDATE_LOG(V_ACCT_MONTH,
                       V_PKG,
                       V_PROCNAME,
                       V_RETINFO,
                       'FAIL',
                       SYSDATE);

END;
/
