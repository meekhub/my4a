select t.*, t.rowid from tmp_majh_0518_01 t;

update tmp_majh_0518_01 set terminal_code=(terminal_code);

create table tmp_majh_0518_02 as 
select a.*,
       case
         when B.MOBILE_NO is not null then
          '是'
         else
          '否'
       end is_bss,
       c.RESOURCE_MANUFACTURER,
       c.RESOURCE_KIND_NAME
  from tmp_majh_0518_01 a,
       (SELECT /*+PARALLEL(A,3)*/
         MOBILE_NO,
         USED_DATE,
         OPERATE_DATE,
         SUGGEST_PRICE,
         PHONE_NUMBER,
         RESOURCE_KIND,
         TO_CHAR(in_DATE, 'YYYYMMDD') in_date
          FROM crm_dsg.ir_mobile_using_t@HBODS A --终端出入库信息表 
        ) B,
  (SELECT *
          FROM (SELECT TRIM(RESOURCE_MANUFACTURER) RESOURCE_MANUFACTURER,
                       TRIM(RESOURCE_KIND_ID) RESOURCE_KIND_ID,
                       TRIM(RESOURCE_KIND_NO) RESOURCE_KIND_NO,
                       TRIM(RESOURCE_KIND_NAME) RESOURCE_KIND_NAME,
                       ROW_NUMBER() OVER(PARTITION BY RESOURCE_KIND_NO ORDER BY RESOURCE_KIND_ID DESC) RN
                  FROM DSG_STAGE.IR_GET_RESOURCE_KIND_T F) F
         WHERE RN = 1)c
 where A.TERMINAL_CODE = B.MOBILE_NO(+)
 and b.resource_kind = c.RESOURCE_KIND_NO(+)


select 
terminal_corp 品牌, 
terminal_model 型号, 
terminal_code 串码, 
is_bss 是否行货, 
resource_manufacturer 厂商, 
resource_kind_name 型号
 from  tmp_majh_0518_02 t
