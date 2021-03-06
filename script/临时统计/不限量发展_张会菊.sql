DECLARE
  V_MONTH VARCHAR2(100);
  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018' ORDER BY IDX_NO;
BEGIN
  FOR V_NUM IN 20180101 .. 20180121 LOOP
    V_MONTH := TO_CHAR(V_NUM);
    INSERT INTO TMP_MAJH_BXL_0122
      SELECT V_MONTH,
             AREA_NO,
             AREA_NO_DESC,
             CITY_NO,
             CITY_NO_DESC,
             CHANNEL_NO,
             CHANNEL_NO_DESC,
             DEVICE_NUMBER,
             USER_DINNER,
             USER_DINNER_DESC,
             TO_CHAR(INNET_DATE, 'YYYYMMDD') INNET_DATE,
             A.SALES_MODE,
             A.SALES_MODE_DESC
        FROM DW.DW_V_USER_BASE_INFO_DAY A
       WHERE ACCT_MONTH = '201801'
         AND DAY_ID = SUBSTR(V_MONTH, 7, 2)
         AND TELE_TYPE = '2'
         AND EXISTS (SELECT 1
                FROM DIM.DIM_USER_DINNER B
               WHERE B.USER_DINNER_DESC LIKE '%不限量%'
                 AND B.DINNER_TYPE = '1'
                 AND A.USER_DINNER = B.USER_DINNER)
         AND IS_NEW = '1';
    COMMIT;
    COMMIT;
  END LOOP;
END;


select 
innet_date 入网日期,  
area_no 地市编码, 
area_no_desc 地市, 
city_no 区县编码, 
city_no_desc 区县, 
channel_no 渠道编码, 
channel_no_desc 渠道, 
device_number 号码, 
user_dinner 套餐ID, 
user_dinner_desc 套餐, 
case when sales_mode is not null then '是' else '否' end 是否租机
 from tmp_majh_bxl_0122 t
