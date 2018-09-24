create table tmp_majh_trm_02 as
SELECT  
       A.TERMINAL_CODE,
       b.region_code,
       b.RESOURCE_KIND
  FROM tmp_majh_trm_01 A,
       (SELECT /*+PARALLEL(A,3)*/
         region_code,
         MOBILE_NO,
         USED_DATE,
         OPERATE_DATE,
         SUGGEST_PRICE,
         PHONE_NUMBER,
         RESOURCE_KIND,
         TO_CHAR(in_DATE, 'YYYYMMDD')in_date
          FROM crm_dsg.ir_mobile_using_t@HBODS  A --�ն˳������Ϣ�� 
) B
 WHERE A.TERMINAL_CODE = B.MOBILE_NO(+);


create table tmp_majh_trm_03 as
select 
a.terminal_code, 
b.RESOURCE_MANUFACTURER,
b.RESOURCE_KIND_NAME
from tmp_majh_trm_02 a,
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
where a.RESOURCE_KIND=b.RESOURCE_KIND_NO(+);

select 
terminal_code ����, 
resource_manufacturer Ʒ��, 
resource_kind_name �ͺ�
 from tmp_majh_trm_03;
 
 
 
 --�ڶ���ͳ��  ƥ�䲻�ڿ⴮����ϸ
 create table tmp_majh_trm_02 as
 select * from tmp_majh_trm_01 where 1=2;
 
 
 create table tmp_majh_trm_04 as
SELECT  
       A.TERMINAL_CODE,
       b.region_code,
       b.RESOURCE_KIND
  FROM tmp_majh_trm_02 A,
       (SELECT /*+PARALLEL(A,3)*/
         region_code,
         MOBILE_NO,
         USED_DATE,
         OPERATE_DATE,
         SUGGEST_PRICE,
         PHONE_NUMBER,
         RESOURCE_KIND,
         TO_CHAR(in_DATE, 'YYYYMMDD')in_date
          FROM crm_dsg.ir_mobile_using_t@HBODS  A --�ն˳������Ϣ�� 
) B
 WHERE A.TERMINAL_CODE = B.MOBILE_NO(+)
 and b.mobile_no is null
