create table tmp_majh_trm_0829_01
(
terminal_code varchar2(50),
idx_no number
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
               device_no£¬
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
                   and to_char(SALESINST_CREATE_DATE,'yyyymm') >= '201801')
         WHERE RN = 1;
      COMMIT;



create table tmp_majh_trm_0829_02 as 
select a.*,
       c.create_date,
       c.BEGIN_DATE,
       b.device_no,
       to_char(b.reg_date, 'yyyymmdd') reg_date,
       c.user_dinner
  from tmp_majh_trm_0829_01 a,
       (select *
          from dw.dw_v_user_terminal_device_d a
         where acct_month = '201808'
           and day_id = '28') b,
       TMP_MAJH_0417_02 c
 where a.TERMINAL_CODE = b.terminal_code(+)
   and a.TERMINAL_CODE = c.device_no(+);
   

--µ¼³ö   
select 
a.*,b.user_dinner_desc
from 
£¨select 
terminal_code, 
idx_no, 
create_date, 
substr(begin_date,1,8), 
device_no, 
reg_date,
user_dinner
 from 
(select t.*,row_number()over(partition by t.idx_no order by 1)rn from  tmp_majh_trm_0829_02 t)
where rn=1)a,
dim.dim_user_dinner b
where a.USER_DINNER=b.user_dinner(+)
   
   
   








