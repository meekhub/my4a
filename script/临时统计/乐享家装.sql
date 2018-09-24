SELECT user_dinner,user_dinner_desc,demo
  FROM DIM.DIM_USER_DINNER
 WHERE USER_DINNER IN ('1410261',
                       '1410262',
                       '1410265',
                       '1410266',
                       '1414359',
                       '1414362',
                       '1414364',
                       '1414361',
                       '1414365',
                       '1414363',
                       '1414368',
                       '1414370',
                       '1414382',
                       '1414383');

create table TMP_MAJH_DIM_DINNER
(
user_dinner varchar2(20),
user_dinner_desc varchar2(200),
dinner_flux number,
dinner_call number,
dinner_sms number
)


create table tmp_majh_dim_dinner
(
ACCt_month varchar2(20),
area_no  varchar2(20), 
USER_NO  varchar2(20), 
user_dinner varchar2(20), 
ALL_JF_FLUX number,
SP_NUM number,
SP_MO_NUM number,
SP_MT_NUM number,
JF_TIMES  number
)

DECLARE
  V_MONTH VARCHAR2(100);
  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018' ORDER BY IDX_NO;
BEGIN
  FOR V_NUM IN 201601 .. 201612 LOOP
    V_MONTH := TO_CHAR(V_NUM);
    FOR C1 IN V_AREA LOOP
      INSERT INTO tmp_majh_user_1106
        SELECT V_MONTH,
               C1.AREA_NO,
               B.USER_NO,
               A.USER_DINNER,
               B.ALL_JF_FLUX,
               B.SP_NUM,
               B.SP_MO_NUM,
               B.SP_MT_NUM,
               B.JF_TIMES
          FROM TMP_MAJH_DIM_DINNER A,
               (SELECT ACCT_MONTH,
                       AREA_NO,
                       USER_NO,
                       ALL_JF_FLUX,
                       SP_NUM,
                       SP_MO_NUM,
                       SP_MT_NUM,
                       JF_TIMES,
                       USER_DINNER
                  FROM DW.DW_V_USER_BASE_INFO_USER
                 WHERE ACCT_MONTH = V_MONTH
                   AND AREA_NO = C1.AREA_NO
                   AND TO_CHAR(INNET_DATE, 'YYYYMM') >= '201601'
                   AND TELE_TYPE = '2'
                   AND IS_ONNET = '1') B
         WHERE A.USER_DINNER = B.USER_DINNER(+);
      COMMIT;
    END LOOP;
  END LOOP;
END;
   
   
select * from dw.dw_v_user_stream
   



SELECT ACCT_MONTH,
       USER_DINNER,
       USER_DINNER_DESC,
       SUM(CASE
             WHEN USE_FLUX > 0 THEN
              1
             ELSE
              0
           END) USER_CNT,
       SUM(USE_FLUX) USE_FLUX,
       SUM(DINNER_FLUX),
       SUM(CASE
             WHEN USE_CALL > 0 THEN
              1
             ELSE
              0
           END) USER_CNT,
       SUM(USE_CALL) USE_CALL,
       SUM(DINNER_CALL),
       SUM(CASE
             WHEN USE_SMS > 0 THEN
              1
             ELSE
              0
           END) USER_CNT,
       SUM(USE_SMS) USE_SMS,
       SUM(DINNER_SMS)
  FROM (SELECT A.ACCT_MONTH,
               A.USER_NO,
               A.USER_DINNER,
               B.USER_DINNER_DESC,
               CASE
                 WHEN A.ALL_JF_FLUX > B.DINNER_FLUX THEN
                  B.DINNER_FLUX
                 ELSE
                  A.ALL_JF_FLUX
               END USE_FLUX,
               CASE
                 WHEN A.SP_NUM > B.DINNER_SMS THEN
                  B.DINNER_SMS
                 ELSE
                  A.SP_NUM
               END USE_SMS,
               CASE
                 WHEN A.JF_TIMES > B.DINNER_CALL THEN
                  B.DINNER_CALL
                 ELSE
                  A.JF_TIMES
               END USE_CALL,
               DINNER_FLUX,
               DINNER_CALL,
               DINNER_SMS
          FROM TMP_MAJH_USER_1106 A, TMP_MAJH_DIM_DINNER B
         WHERE A.USER_DINNER = B.USER_DINNER)
 GROUP BY ACCT_MONTH, USER_DINNER, USER_DINNER_DESC

