select t.*, t.rowid from tmp_majh_0620_02 t;


CREATE TABLE TMP_MAJH_TRM_0620_03 AS 
SELECT A.*,
       B.DEVICE_NO,
       TO_CHAR(B.REG_DATE, 'YYYYMMDDHH24MISS') REG_DATE,
       B.TERMINAL_CORP,
       B.TERMINAL_MODEL,
       CASE
         WHEN C.USER_NO IS NOT NULL THEN
          '��'
         ELSE
          '��'
       END is_onnet
  FROM TMP_MAJH_0620_02 A,
       (SELECT *
          FROM DW.DW_V_USER_TERMINAL_DEVICE_D B
         WHERE ACCT_MONTH = '201806'
           AND DAY_ID = '19') B,
       (SELECT user_no
          FROM DW.DW_V_USER_BASE_INFO_DAY C
         WHERE ACCT_MONTH = '201806'
           AND DAY_ID = '19'
           AND TELE_TYPE = '2'
           AND IS_ONNET = '1') C
 WHERE A.TERMINAL_CODE = B.TERMINAL_CODE(+)
   AND b.USER_NO = C.USER_NO(+);



select 
terminal_code ����,  
device_no, 
reg_date, 
terminal_corp, 
terminal_model, 
is_onnet
 from TMP_MAJH_TRM_0620_03 order by idx_no
