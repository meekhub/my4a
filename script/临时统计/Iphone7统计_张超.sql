truncate table tmp_majh_0328_02

      INSERT /*+ APPEND */
      INTO tmp_majh_0328_02 NOLOGGING
        SELECT USER_NO,
               AREA_NO,
               SALES_MODE,
               TO_CHAR(BEGIN_DATE, 'YYYYMMDD'),
               TO_CHAR(END_DATE, 'YYYYMMDD'),
               COST_PRICE,
               device_no,
               device_number
          FROM (SELECT T.*,
                       ROW_NUMBER() OVER(PARTITION BY USER_NO ORDER BY BEGIN_DATE DESC) RN
                  FROM ODS.O_PRD_USER_DEVICE_RENT_D@hbods T
                 WHERE T.ACCT_MONTH = '201805'
                   AND T.DAY_ID = '23' 
                   AND end_DATE > TO_DATE('20180523', 'YYYYMMDD') + 1)
         WHERE RN = 1;
         commit;

create table tmp_majh_0524_03 as 
select 
a.*,b.begin_date,c.user_dinner_desc,c.AREA_NO_DESC
 from tmp_majh_0524_01 a,tmp_majh_0328_02 b,
(
select * from dw.dw_v_user_base_info_day c
where acct_month='201805'
and day_id='23'
and tele_type='2'
)c
where a.terminal_code=b.device_no(+)
and b.user_no=c.user_no(+);


select 
terminal_code 串码, 
begin_date 受理时间, 
user_dinner_desc 套餐名称,
AREA_NO_DESC
 from tmp_majh_0524_03




