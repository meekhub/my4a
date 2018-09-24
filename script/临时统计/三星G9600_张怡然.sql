create table tmp_majh_0509_01 as
        SELECT USER_NO,
               AREA_NO,
               SALES_MODE,
               TO_CHAR(BEGIN_DATE, 'YYYYMMDD')BEGIN_DATE,
               TO_CHAR(END_DATE, 'YYYYMMDD')END_DATE,
               COST_PRICE,
               device_no,
               device_number
          FROM (SELECT T.*,
                       ROW_NUMBER() OVER(PARTITION BY USER_NO ORDER BY BEGIN_DATE DESC) RN
                  FROM ODS.O_PRD_USER_DEVICE_RENT_D@HBODS T
                 WHERE T.ACCT_MONTH = '201805'
                   AND T.DAY_ID = '08' 
                   AND begin_DATE > TO_DATE('20180101', 'YYYYMMDD') + 1
                   AND begin_DATE < TO_DATE('20180131', 'YYYYMMDD') + 1)
         WHERE RN = 1 
         and device_type in (
        SELECT RESOURCE_KIND_NO
  FROM (SELECT TRIM(RESOURCE_MANUFACTURER) RESOURCE_MANUFACTURER,
               TRIM(RESOURCE_KIND_ID) RESOURCE_KIND_ID,
               TRIM(RESOURCE_KIND_NO) RESOURCE_KIND_NO,
               TRIM(RESOURCE_KIND_NAME) RESOURCE_KIND_NAME,
               ROW_NUMBER() OVER(PARTITION BY RESOURCE_KIND_NO ORDER BY RESOURCE_KIND_ID DESC) RN
          FROM DSG_STAGE.IR_GET_RESOURCE_KIND_T F) F
 WHERE RN = 1
and RESOURCE_MANUFACTURER like '%ÈýÐÇ%' and RESOURCE_KIND_NAME like '%G9600%'
         )
