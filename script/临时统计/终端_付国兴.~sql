CREATE TABLE TMP_MAJH_TRM_0609_01 AS 
SELECT A.*,
       B.AREA_NO,
       B.CITY_NO,
       B.TERMINAL_CORP,
       B.TERMINAL_MODEL,
       TO_CHAR(B.REG_DATE, 'YYYYMMDDHH24MISS') REG_DATE,
       B.USER_NO,
       B.DEVICE_NO，
       b.terminal_code terminal_code_2
  FROM tmp_majh_0609_02 A,
       (SELECT *
          FROM DW.DW_V_USER_TERMINAL_user_D B
         WHERE ACCT_MONTH = '201806'
         AND DAY_ID='08' 
         ) B
 WHERE A.Terminal_Code = B.Device_No(+);
 
 
 
 select  
a.terminal_code 手机号, 
a.area_desc 地市,  
a.terminal_corp 终端品牌, 
a.terminal_model 型号, 
a.terminal_code_2 串号,
b.area_desc 所在地, 
a.reg_date 末次注册时间 
   from TMP_MAJH_TRM_0609_01 a, dim.dim_area_no b
  where func_get_xiongan_area_no(a.area_no, a.city_no) = b.area_no
