
--�����ж�ǰ������������û��ִ����ϣ����ִ����ϣ���ִ����������Ĺ���
SELECT *
  FROM ALLDM.ALLDM_EXECUTE_LOG
 WHERE ACCT_MONTH = TO_CHAR(SYSDATE - 1, 'YYYYMMDD')
   AND PROCNAME IN
       ('P_DM_TER_DEVICE_FIRST_D', 'P_DM_TERMINAL_FIRST_D')


==========================================================================================================================================

--���ֿ� TEMP_USER�û���ִ����������
--ͳ�ƽű���VIVO X9sPlus���ʱ�䣺7��8��-7��14�գ����Դ�9��-15��ÿ��ִ�У���

--ִ��Լ20-30����
DECLARE
            
BEGIN
  --�����м��ͽ����

  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP170608_ZQP_BKZD_USER_MID';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP170608_ZQP_USER_TER_MID';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP170608_ZQP_USER_FIRST_D';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP170608_ZQP_TERMINAL_FIRST_D';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP170608_ZQP_BKZD_BASE_USER_D';

  --����Ŀ���û�����ڼ��ۼ��û���
INSERT INTO TMP170608_ZQP_BKZD_USER_MID
  SELECT ACCT_MONTH,
         DAY_ID,
         AREA_NO,
         AREA_NO_DESC,
         DEVICE_NUMBER,
         USER_NO,
         INNET_DATE,
         IS_OCS,
         IS_VALID,
         USER_STATUS_DESC,
         USER_DINNER,
         USER_DINNER_DESC
    FROM DW.DW_V_USER_BASE_INFO_DAY
   WHERE ACCT_MONTH = TO_CHAR(SYSDATE - 1, 'YYYYMM')
     AND DAY_ID = TO_CHAR(SYSDATE - 1, 'DD')
     AND USER_DINNER IN ('1394904',
                         '1394929',
                         '1394917',
                         '1394919',
                         '1394922',
                         '1419678',
                         '1419645',
                         '1419961',
                         '1413302',
                         '1416516',
                         '1413294',
                         '1411908',
                         '1416471',
                         '1415649',
                         '1421729',
                         '1420514',
                         '1420520',
                         '1420295')
     AND TO_CHAR(INNET_DATE, 'YYYYMMDD') >= '20170930' --VIVO X9SPLUS��7��8��-7��14��
     AND TO_CHAR(INNET_DATE, 'YYYYMMDD') <= '20171008';

  COMMIT;

  --���û��������ע����Ϣ��ȡ�������޳����ο�����ʷע����Ϣ
  INSERT INTO TMP170608_ZQP_USER_TER_MID
    SELECT B.*
      FROM (SELECT DEVICE_NUMBER, INNET_DATE
              FROM TMP170608_ZQP_BKZD_USER_MID) A,
           (SELECT TERMINAL_CODE, DEVICE_NO, TERMINAL_MODEL, REG_DATE
              FROM DW.DW_V_USER_TERMINAL_D T
             WHERE ACCT_MONTH = TO_CHAR(SYSDATE - 1, 'YYYYMM')
               AND DAY_ID = TO_CHAR(SYSDATE - 1, 'DD')) B
     WHERE A.DEVICE_NUMBER = B.DEVICE_NO
       AND TO_CHAR(A.INNET_DATE, 'YYYYMMDD') <=
           TO_CHAR(B.REG_DATE, 'YYYYMMDD');
  COMMIT;

  --ȡ�û��״�ע�᣺��ע����Ϣ�����û���������ȡ��һ����¼����Ϊ�û��״�ע��
  INSERT INTO TMP170608_ZQP_USER_FIRST_D
    SELECT DEVICE_NO, TERMINAL_CODE, TERMINAL_MODEL, REG_DATE
      FROM (SELECT DEVICE_NO,
                   TERMINAL_CODE,
                   TERMINAL_MODEL,
                   REG_DATE,
                   ROW_NUMBER() OVER(PARTITION BY DEVICE_NO ORDER BY REG_DATE ASC) RN
              FROM TMP170608_ZQP_USER_TER_MID T) A
     WHERE RN = 1
       AND TERMINAL_MODEL = 'VIV-vivo X20A' --VIV-vivo X20A��7��20��-7��26�� 
       AND TO_CHAR(REG_DATE, 'YYYYMMDD') >= '20170930' --VIVO X9sPlus��7��8��-7��14��
       AND TO_CHAR(REG_DATE, 'YYYYMMDD') <= '20171008';--�û��״�ע��ʱ��Ϊ�����
     COMMIT;

  --ȡ�ն��״�ע��
  INSERT INTO TMP170608_ZQP_TERMINAL_FIRST_D
    SELECT /*+FULL(C)*/
     DEVICE_NO, TERMINAL_CODE, TERMINAL_MODEL, REG_DATE
      FROM ALLDM.DM_TERMINAL_FIRST_D C --�ն��״�ע��
     WHERE ACCT_MONTH = TO_CHAR(SYSDATE - 1, 'YYYYMM')
       AND DAY_ID = TO_CHAR(SYSDATE - 1, 'DD') --����ȫ������
       AND TERMINAL_MODEL = 'VIV-vivo X20A' --VIV-vivo X20A��7��20��-7��26�� 
       AND TO_CHAR(REG_DATE, 'YYYYMMDD') >= '20170930' --VIVO X9sPlus��7��8��-7��14��
       AND TO_CHAR(REG_DATE, 'YYYYMMDD') <= '20171008';--�û��״�ע��ʱ��Ϊ�����
  COMMIT;

  --Ŀ������
  INSERT INTO TMP170608_ZQP_BKZD_BASE_USER_D
    SELECT A.*, B.*
      FROM TMP170608_ZQP_BKZD_USER_MID    A, --��ڼ��ۼ������û�
           TMP170608_ZQP_USER_FIRST_D     B,
           TMP170608_ZQP_TERMINAL_FIRST_D C
     WHERE A.DEVICE_NUMBER = B.DEVICE_NO
       AND B.TERMINAL_CODE = C.TERMINAL_CODE --�û��״�ע���ն�Ϊ�����ն�
       AND A.DEVICE_NUMBER = C.DEVICE_NO; --�ն��״�ע�����ΪĿ�����
    
  COMMIT;

  --��������û���ϸ��Ϊ�˰������ⳡ����ǰ����������ע�ᣬ���������أ�
  INSERT INTO TMP170720_ZQP_BKZD_BASE_AIM_U
    SELECT TO_CHAR(SYSDATE - 1, 'YYYYMMDD') OPER_DAY, A.*
      FROM TMP170608_ZQP_BKZD_BASE_USER_D A,
           TMP170720_ZQP_BKZD_BASE_AIM_U  B
     WHERE A.DEVICE_NUMBER = B.DEVICE_NUMBER(+) --�޳��Ѿ�������ĺ��룬��ֹ�ظ����Ӱ�
       AND B.DEVICE_NUMBER IS NULL;

  COMMIT;

END;



==========================================================================================================================================

--��������ִ����Ϻ�ִ��������䣬�������ݵ�������
--�������Ľ��������Լ�飺����<15343118065@189.cn>,  ʱѩ��<18031866773@189.cn>�����͸������������˷�ٻٻ��18931177153@189.cn���ɼ�Լ�����0Ԫ5Gʡ��������30�죩������Ʒ��ӡ�

SELECT OPER_DAY,
       AREA_NO,
       AREA_NO_DESC,
       DEVICE_NUMBER,
       USER_NO,
       INNET_DATE,
       IS_OCS,
       IS_VALID,
       USER_STATUS_DESC,
       USER_DINNER,
       USER_DINNER_DESC,
       TERMINAL_CODE,
       TERMINAL_MODEL,
       REG_DATE
  FROM TMP170720_ZQP_BKZD_BASE_AIM_U
 WHERE OPER_DAY = TO_CHAR(SYSDATE - 1, 'YYYYMMDD');
