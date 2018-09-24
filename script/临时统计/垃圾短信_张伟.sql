create table tmp_cheat_sms_user
(
device_number varchar2(20),
flag varchar2(4)
)



/*      INSERT INTO tmp_cheat_sms_device
        SELECT TERMINAL_CODE, TERMINAL_CORP, TERMINAL_MODEL, TERMINAL_TYPE
          FROM (SELECT TERMINAL_CODE,
                       TERMINAL_CORP,
                       TERMINAL_MODEL,
                       TERMINAL_TYPE,
                       ROW_NUMBER() OVER(PARTITION BY TERMINAL_CODE ORDER BY TERMINAL_TYPE) RN
                  FROM (SELECT B.TERMINAL_CODE,
                               B.TERMINAL_CORP,
                               B.TERMINAL_MODEL,
                               '1' TERMINAL_TYPE
                          FROM tmp_cheat_sms_user A,
                               (SELECT DEVICE_NO,
                                       TERMINAL_CODE,
                                       TERMINAL_CORP,
                                       TERMINAL_MODEL
                                  FROM DW.DW_V_USER_TERMINAL_D
                                 WHERE ACCT_MONTH = SUBSTR(V_DATE,1,6)
                                   AND DAY_ID = SUBSTR(V_DATE,7,2)
                                   AND LENGTH(TERMINAL_CODE) > 8) B
                         WHERE A.DEVICE_NUMBER = B.DEVICE_NO
                           AND A.DAY_ID = V_DATE))
         WHERE RN = 1;
      COMMIT;*/

    -----------------��������������ע���ն���Ϣ---------------------
    EXECUTE IMMEDIATE 'TRUNCATE TABLE tmp_cheat_sms_mid_01';
    INSERT INTO tmp_cheat_sms_mid_01
      SELECT V_DATE,
             AREA_NO,
             DEVICE_NO DEVICE_NUMBER,
             TERMINAL_CODE,
             TERMINAL_MODEL,
             TERMINAL_CORP
        FROM DW.DW_V_USER_TERMINAL_D
       WHERE ACCT_MONTH = TO_CHAR(SYSDATE - 1, 'YYYYMM')
         AND DAY_ID = TO_CHAR(SYSDATE - 1, 'DD')
         AND TO_CHAR(REG_DATE, 'YYYYMMDD') = V_DATE
         AND LENGTH(TERMINAL_CODE) > 8 --�޳��쳣�ն�;
      ;
    COMMIT;
  

--�����2017��12�µ�2018��1��19��ʹ�ù�թƭ�û����ն˵��û�
create table tmp_majh_cheat_sms_his as 
select a.* from 
(select t.* from tmp_cheat_sms_mid_01 t,tmp_cheat_sms_user x
where t.device_number=x.device_number(+)
and x.device_number is null)a,
tmp_cheat_sms_device b
where a.terminal_code=b.terminal_code;


select 
distinct b.area_desc,a.device_number,a.terminal_code,a.terminal_corp,a.terminal_model
 from tmp_majh_cheat_sms_his a,dim.dim_area_no b
where a.area_no=b.area_no





