--truncate table tmp_majh_0412_01
insert into  tmp_majh_0412_01 
SELECT A.ACCT_MONTH,
       D.DESCRIPTION,
       D.IDX_NO,
       c.terminal_code,
       A.TERMINAL_CORP,
       A.TERMINAL_MODEL,
       CASE
         WHEN A.USER_DINNER_DESC LIKE '%加装%' THEN
          '副卡'
         ELSE
          '主卡'
       END is_fk,
       CASE
         WHEN A.TERMINAL_CODE IS NOT NULL AND C.TERMINAL_CODE IS NOT NULL THEN
          '新终端'
         WHEN A.TERMINAL_CODE IS NOT NULL AND C.TERMINAL_CODE IS NULL THEN
          '老终端'
         ELSE
          '未注册'
       END is_reg,
       A.USER_NO,
       to_char(c.reg_date,'yyyymmdd')reg_date
  FROM (SELECT *
          FROM DW.DW_V_USER_BASE_INFO_USER A
         WHERE A.ACCT_MONTH = '201803'
           AND A.TELE_TYPE = '2'
           AND A.IS_NEW = '1'
           AND A.CHANNEL_TYPE LIKE '11%') A,
       (SELECT *
          FROM dw.DW_V_USER_TERMINAL_DEVICE_M C
         WHERE C.ACCT_MONTH = '201803'
           AND TO_CHAR(C.REG_DATE, 'YYYYMM') = '201803') C,
       NEW_ALLDMCODE.DMCODE_AREA D
 WHERE A.TERMINAL_CODE = C.TERMINAL_CODE(+)
   AND func_get_xiongan_area_no(A.AREA_NO, A.CITY_NO) = D.AREA_NO;
   commit;
   
create table    tmp_majh_0412_02 as
select 
a.*,
case when b.mobile_no is not null then '是' else '否' end is_bss
 from tmp_majh_0412_01 a,
CRM_DSG.IR_MOBILE_USING_T@HBODS b
where a.terminal_code=b.MOBILE_NO(+);


select  
description 地市,  
terminal_code 串号, 
terminal_corp 品牌, 
terminal_model 机型, 
is_fk 是否副卡, 
is_reg 是否新终端,  
reg_date 注册时间, 
is_bss 是否bss入库
 from  tmp_majh_0412_02



