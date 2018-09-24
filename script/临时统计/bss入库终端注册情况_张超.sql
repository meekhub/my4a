create table tmp_majh_trm_0315_01 as
SELECT MOBILE_NO,
       USED_DATE,
       OPERATE_DATE,
       SUGGEST_PRICE,
       PHONE_NUMBER,
       RESOURCE_KIND,
       TO_CHAR(in_DATE, 'YYYYMMDD') in_date,
       RESOURCE_MANUFACTURER,
       RESOURCE_KIND_NAME
  FROM crm_dsg.ir_mobile_using_t@HBODS A， --终端出入库信息表
  (
SELECT *
  FROM (SELECT TRIM(RESOURCE_MANUFACTURER) RESOURCE_MANUFACTURER,
               TRIM(RESOURCE_KIND_ID) RESOURCE_KIND_ID,
               TRIM(RESOURCE_KIND_NO) RESOURCE_KIND_NO,
               TRIM(RESOURCE_KIND_NAME) RESOURCE_KIND_NAME,
               ROW_NUMBER() OVER(PARTITION BY RESOURCE_KIND_NO ORDER BY RESOURCE_KIND_ID DESC) RN
          FROM DSG_STAGE.IR_GET_RESOURCE_KIND_T F) F
 WHERE RN = 1
)b
  where TO_CHAR(in_DATE, 'YYYYMM')='201801'
  and a.resource_kind=b.RESOURCE_KIND_NO;
  

create table tmp_majh_trm_0315_02 as
select 
a.*,case when b.terminal_code is not null then '1' else '0' end is_reg
 from tmp_majh_trm_0315_01 a,
(
SELECT AREA_NO, TERMINAL_CODE, TERMINAL_CORP, TERMINAL_MODEL,DEVICE_NO
  FROM DW.DW_V_USER_TERMINAL_DEVICE_M A
 WHERE ACCT_MONTH = '201802'
   AND TO_CHAR(REG_DATE, 'YYYYMM') in ('201801','201802')
)b
where a.MOBILE_NO=b.terminal_code(+);


create table tmp_majh_trm_0315_03 as
select 
a.*,case when b.esn is not null then '1' else '0' end is_out_prov_reg
 from tmp_majh_trm_0315_02 a,
(
select esn from alldm.bwt_down_rgst_trmnl_prvnc@oldhbdw where day_id>='20180101'
union all
select esn from alldm.bwt_down_rgst_trmnl_prvnc
)b
where a.MOBILE_NO=b.esn(+)







