create table tmp_majh_0409_02 as 
SELECT TO_CHAR(A.REG_DATE, 'YYYYMMDD') REG_DATE,
       B.AREA_NO_DESC,
       A.TERMINAL_CORP,
       A.TERMINAL_MODEL,
       CASE
         WHEN B.USER_DINNER_DESC LIKE '%��װ%' THEN
          '��'
         ELSE
          '��'
       END is_fk,
       A.TERMINAL_CODE,
       to_char(innet_date,'yyyymmdd')innet_date
  FROM (SELECT AREA_NO, TERMINAL_CODE, TERMINAL_CORP, TERMINAL_MODEL,USER_NO,REG_DATE
          FROM DW.DW_V_USER_TERMINAL_DEVICE_M A
         WHERE ACCT_MONTH = '201803'
           AND TO_CHAR(REG_DATE, 'YYYYMM') >= '201801'
           AND TO_CHAR(REG_DATE, 'YYYYMM') <= '201803') A,
       (SELECT AREA_NO_DESC, USER_NO,USER_DINNER_DESC,innet_date
          FROM DW.DW_V_USER_BASE_INFO_USER A
         WHERE ACCT_MONTH = '201803'
           AND TELE_TYPE = '2'
           and to_char(innet_date,'yyyymm') in ('201801','201802','201803')) B,
       CRM_DSG.IR_MOBILE_USING_T@HBODS C
 WHERE A.USER_NO = B.USER_NO
   AND A.TERMINAL_CODE = C.MOBILE_NO(+)

select * from dim.dim_user_dinner a where a.user_dinner_desc like '%��װ%';


--����
select 
reg_date ע��ʱ��, 
area_no_desc ����, 
terminal_corp Ʒ��, 
terminal_model ����, 
is_fk �Ƿ񸱿�, 
terminal_code ����
 from tmp_majh_0409_02
 
 
 
 
