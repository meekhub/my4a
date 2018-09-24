create table tmp_majh_trm_0810_01
(
RESOURCE_KIND_ID varchar2(50)
)


truncate table TMP_MAJH_0417_02

      INSERT /*+ APPEND */
      INTO TMP_MAJH_0417_02 NOLOGGING
        SELECT USER_NO,
               AREA_NO,
               SALES_MODE,
               TO_CHAR(BEGIN_DATE, 'YYYYMMDDHH24MISS'),
               TO_CHAR(END_DATE, 'YYYYMMDDHH24MISS'),
               COST_PRICE,
               device_no，
               user_dinner,
               device_type,
               device_number,
               channel_no,
               to_char(SALESINST_CREATE_DATE,'yyyymmdd') create_date
          FROM (SELECT T.*,
                       ROW_NUMBER() OVER(PARTITION BY USER_NO ORDER BY BEGIN_DATE DESC) RN
                  FROM ODS.O_PRD_USER_DEVICE_RENT_D@HBODS T
                 WHERE T.ACCT_MONTH = '201808'
                   AND T.DAY_ID = '26' 
                   AND to_char(SALESINST_CREATE_DATE,'yyyymm')='201807')
         WHERE RN = 1;
      COMMIT;
      
      
SELECT DISTINCT create_date 办理日期,
                d.area_desc 地市,
                A.DEVICE_NUMBER 号码,
                A.DEVICE_NO 串码,
                C.RESOURCE_KIND_ID 终端型号ID,
                C.RESOURCE_MANUFACTURER 厂商,
                C.RESOURCE_KIND_NAME 型号
  FROM TMP_MAJH_0417_02 A, TMP_MAJH_TRM_0810_01 B, TMP_TRM_DEVICE_TYPE C,dim.dim_area_no d
 WHERE B.RESOURCE_KIND_ID = B.RESOURCE_KIND_ID
   AND C.RESOURCE_KIND_NO = A.DEVICE_TYPE
   and a.area_no=d.area_no;
   
   
   



