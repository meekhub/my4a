create table tmp_majh_0412_03 as 
select 
c.area_desc,a.TERMINAL_CORP,a.TERMINAL_MODEL,TERMINAL_CODE,TO_CHAR(A.REG_DATE, 'YYYYMMDD')REG_DATE，
case when b.mobile_no is not null then '是' else '否' end is_bss
 from  
      (SELECT AREA_NO, TERMINAL_CODE, TERMINAL_CORP, TERMINAL_MODEL,USER_NO,REG_DATE 
          FROM dw.DW_V_USER_TERMINAL_DEVICE_d C
         WHERE C.ACCT_MONTH = '201804'
         and day_id='10'
           AND TO_CHAR(C.REG_DATE, 'YYYYMMDD')>='20180401'
           and TO_CHAR(C.REG_DATE, 'YYYYMMDD')<='20180410')A,
           CRM_DSG.IR_MOBILE_USING_T@HBODS b,
           dim.dim_area_no c
           where a.terminal_code=b.mobile_no(+)
           and a.area_no=c.area_no(+);
           
           
select 
area_desc 地市, 
terminal_corp 品牌, 
terminal_model 型号, 
terminal_code 串码, 
reg_date 注册时间, 
is_bss 是否bss存在
 from tmp_majh_0412_03
 
 
 
 
 
     
