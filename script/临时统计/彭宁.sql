select t.*, t.rowid from tmp_majh_1016_01 t where rownum>10000

update tmp_majh_1016_01 set flag=1;


update tmp_majh_1016_01 set flag=2 where flag is null


create table tmp_majh_1017_02 as 
select
b.*,a.flag
 from tmp_majh_1016_01 a,
(
 SELECT 
     DEVICE_NO, TERMINAL_CODE, TERMINAL_CORP,TERMINAL_MODEL, REG_DATE
      FROM ALLDM.DM_TERMINAL_FIRST_D C --终端首次注册
     WHERE ACCT_MONTH = TO_CHAR(SYSDATE - 1, 'YYYYMM')
       AND DAY_ID = TO_CHAR(SYSDATE - 1, 'DD') --昨日全量数据  
)b
where a.terminal_code=b.terminal_code(+);


create table TMP_MAJH_1017_01 AS
 SELECT 
     DEVICE_NO, TERMINAL_CODE, TERMINAL_CORP,TERMINAL_MODEL, REG_DATE
      FROM dw.dw_v_user_terminal_device_d C --终端首次注册
     WHERE ACCT_MONTH = TO_CHAR(SYSDATE - 1, 'YYYYMM')
       AND DAY_ID = TO_CHAR(SYSDATE - 1, 'DD') --昨日全量数据  
       AND UPPER(TERMINAL_MODEL)='ZTE-BA603'
       
       
       
       
       
       
