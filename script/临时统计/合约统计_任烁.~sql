select t.*, t.rowid from tmp_majh_trm_0416_01 t;

TRUNCATE TABLE TMP_MAJH_DQ_RENT
      INSERT /*+ APPEND */
      INTO TMP_MAJH_DQ_RENT NOLOGGING
        SELECT USER_NO,
               AREA_NO,
               SALES_MODE,
               TO_CHAR(BEGIN_DATE, 'YYYYMMDDHH24MISS'),
               TO_CHAR(END_DATE, 'YYYYMMDDHH24MISS'),
               COST_PRICE,
               device_no£¬
               user_dinner
          FROM (SELECT T.*,
                       ROW_NUMBER() OVER(PARTITION BY USER_NO ORDER BY BEGIN_DATE DESC) RN
                  FROM ODS.O_PRD_USER_DEVICE_RENT_D@HBODS T
                 WHERE T.ACCT_MONTH = '201804'
                   AND T.DAY_ID = '15'
                   --AND AREA_NO = C1.AREA_NO
                   AND BEGIN_DATE > TO_DATE('20171231', 'YYYYMMDD') + 1
                   AND BEGIN_DATE < TO_DATE('20180630', 'YYYYMMDD') + 1)
         WHERE RN = 1;
      COMMIT;

create table tmp_majh_0416_02 as 
select 
a.terminal_code, 
b.terminal_corp,
b.terminal_model,
case when d.low_value>=59 then c.begin_date end dinner_date,
b.device_no,
to_char(b.reg_date,'YYYYMMDDHH24MISS')reg_date
 from tmp_majh_trm_0416_01 a,
(
select * from dw.dw_v_user_terminal_device_m a
where acct_month='201803'  
)b,
TMP_MAJH_DQ_RENT c,
 RPT_HBTELE.SJZX_WH_DIM_USER_DINNER d
where a.terminal_code=b.terminal_code(+)
and b.user_no=c.user_no(+)
and c.user_dinner=d.user_dinner(+)
 

