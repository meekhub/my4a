create table tmp_majh_0608_01 as 
SELECT TO_CHAR(REG_DATE, 'YYYY') REG_DATE ,C.TERMKEY
  FROM (SELECT AREA_NO,
               CITY_NO,
               TERMINAL_CODE,
               TERMINAL_CORP,
               TERMINAL_MODEL,
               REG_DATE,
               ACCT_MONTH
          FROM DW.DW_V_USER_TERMINAL_DEVICE_M A
         WHERE ACCT_MONTH = '201804'
           AND TO_CHAR(REG_DATE, 'YYYY') >= '2014') A,
       (SELECT MOBILE_NO,
               USED_DATE,
               OPERATE_DATE,
               SUGGEST_PRICE,
               PHONE_NUMBER,
               RESOURCE_KIND,
               TO_CHAR(IN_DATE, 'YYYYMMDD') IN_DATE
          FROM CRM_DSG.IR_MOBILE_USING_T@HBODS A --终端出入库信息表
        ) B,
       (SELECT * FROM CRM_DSG.BI_MDN_TERMINFO_IMP_T@HBODS) C
 WHERE A.TERMINAL_CODE = B.MOBILE_NO(+)
   AND A.TERMINAL_CODE = C.TERMKEY(+)
   AND B.MOBILE_NO IS NULL
   GROUP BY TO_CHAR(REG_DATE, 'YYYY') ,C.TERMKEY;
   

create table tmp_majh_trm_0611_01 as
select * from xxhb_mjh.tmp_majh_trm_0611_01

create table xxhb_mjh.tmp_majh_trm_0611_01 as 
select *
  from (select * from xxhb_mjh.tmp_majh_0608_01 order by dbms_random.value)
  where rownum<500000
