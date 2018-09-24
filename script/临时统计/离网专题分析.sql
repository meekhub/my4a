---------------------离网用户-----------------------------
DECLARE
  V_MONTH VARCHAR2(100); 
BEGIN
  FOR V_NUM IN 201801 .. 201804 LOOP
    V_MONTH := TO_CHAR(V_NUM);
--拍照离网用户
EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_LW_OUT_01';
insert into tmp_lw_out_01
SELECT user_no,a.TERMINAL_CODE,account_no,cert_id,a.DEVICE_NUMBER
  FROM DW.DW_V_USER_BASE_INFO_USER A
 WHERE A.ACCT_MONTH =V_MONTH
   AND (A.IS_LOGOUT = '1' OR A.IS_OUTNET = '1')
   AND A.TELE_TYPE = '2';
   commit;


--拍照离网前3个月使用的终端
EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_LW_OUT_TRM';
insert into TMP_LW_OUT_TRM
select 
a.user_no,b.terminal_code 
 from tmp_lw_out_01 a,
(
select user_no,terminal_code from dw.dw_v_user_terminal_user_m a
where acct_month=to_char(add_months(to_date(V_MONTH, 'yyyymm'), -4),
                               'yyyymm')
)b
where a.user_no=b.user_no(+);
commit;


--匹配离网用户终端截止昨日是否还在用
EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_LW_OUT_02';
insert into tmp_lw_out_02
select a.user_no,
       case
         when b.user_no is null then
          '0'
         when b.user_no is not null and a.user_no = b.user_no then
          '0'
         else
          '1'
       end is_term_use
  from TMP_LW_OUT_TRM a,
       (select *
          from (select user_no,
                       terminal_code,
                       row_number() over(partition by terminal_code order by reg_date desc) rn
                  from dw.dw_v_user_terminal_user_m b
                 where acct_month =
                       to_char(add_months(to_date(V_MONTH, 'yyyymm'), 1),
                               'yyyymm')
                   --and reg_date >add_months(to_date(V_MONTH, 'yyyymm'), -6)
                   )
         where rn = 1) b
 where a.terminal_code = b.terminal_code(+);
commit;

--匹配同账户下是否还有在用的C网终端
EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_LW_OUT_03';
insert into tmp_lw_out_03 
select 
a.user_no,case when b.user_no is not null then '1' else '0' end is_same_account_use 
 from tmp_lw_out_01 a,
(
select user_no,cert_id from dw.dw_v_user_base_info_user b
where b.acct_month=V_MONTH 
and is_onnet='1'
and tele_type='2'
and innet_date > add_months(to_date(V_MONTH,'yyyymm'),-5)
)b
where a.CERT_ID=b.cert_id(+);
commit;


EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_LW_OUT_04';
insert into tmp_lw_out_04 
select *
  from (select a.*, row_number() over(partition by user_no order by 1) rn
          from tmp_lw_out_03 a)
 where rn = 1;
commit;


delete from tmp_lw_base_01 where acct_month=V_MONTH;
commit;

insert into tmp_lw_base_01  
SELECT A.ACCT_MONTH,
       A.AREA_NO,
       A.AREA_NO_DESC,
       A.ACCOUNT_NO,
       NVL(A.BUNDLE_ID, A.BUNDLE_ID_ALLOWANCE) BUNDLE_ID,
       A.USER_NO,
       A.DEVICE_NUMBER,
       A.CUSTOMER_TYPE_DESC,
       CASE
         WHEN A.CERT_TYPE = '1' AND LENGTH(A.CERT_ID)=18 and TRIM(TRANSLATE(SUBSTR(A.CERT_ID, 7, 8),'.0123456789',' ')) IS NULL THEN
          TRUNC((TO_CHAR(SYSDATE, 'YYYYMMDD') -
                SUBSTR(A.CERT_ID, 7, 8)) / 10000)
         WHEN A.CERT_TYPE = '1' AND LENGTH(A.CERT_ID)=15 and TRIM(TRANSLATE(SUBSTR(A.CERT_ID, 7, 8),'.0123456789',' ')) IS NULL THEN
           TRUNC((TO_CHAR(SYSDATE, 'YYYYMMDD') -
                SUBSTR('19'||A.CERT_ID, 7,8)) / 10000)
         ELSE
          0
       END AGE,
       A.INNET_MONTH,
       CASE
         WHEN A.INNET_MONTH <= 12 THEN
          '1'
         ELSE
          '0'
       END IS_IN_ONEYEAR,
       CASE
         WHEN A.IS_LOGOUT = '1' THEN
          '强拆'
         ELSE
          '主动退网'
       END LOGOUT_TYPE,
       CASE
         WHEN A.USER_DINNER_DESC LIKE '%加装%' THEN
          '1'
         ELSE
          '0'
       END IS_FUKA,
       CASE
         WHEN g.IS_KD_BUNDLE = '0' THEN
          '0'
         ELSE
          '1'
       END IS_RONGHE,
       CASE
         WHEN A.TRANS_ID IS NOT NULL THEN
          '1'
         ELSE
          '0'
       END IS_HEYUE,
       CASE
         WHEN B.USER_NO IS NOT NULL THEN
          '1'
         ELSE
          '0'
       END IS_SCHOOL,
       A.USER_DINNER,
       A.USER_DINNER_DESC,
       D.LOW_VALUE,
       A.BUNDLE_USER_DINNER,
       A.BUNDLE_USER_DINNER_DESC,
       A.CHANNEL_TYPE,
       A.CHANNEL_TYPE_DESC,
       CASE
         WHEN C.USER_NO IS NOT NULL THEN
          '1'
         ELSE
          '0'
       END IS_OPEN,
       A.TERMINAL_CORP,
       A.TERMINAL_MODEL,
       NVL(E.IS_TERM_USE,'0') IS_TERM_USE,
       NVL(F.IS_SAME_ACCOUNT_USE,'0')IS_SAME_ACCOUNT_USE,
       A.CHANNEL_NO,
       A.CHANNEL_NO_DESC
  FROM (SELECT *
          FROM DW.DW_V_USER_BASE_INFO_USER A
         WHERE A.ACCT_MONTH = V_MONTH 
           AND (A.IS_LOGOUT = '1' OR A.IS_OUTNET = '1')
           AND A.TELE_TYPE = '2') A,
       (SELECT USER_NO
          FROM DW.DW_V_USER_SCHOOL_HX_USER_M B
         WHERE B.ACCT_MONTH = V_MONTH
           AND B.TELE_TYPE = '2') B,
       (SELECT USER_NO
          FROM DW.DW_V_USER_HUAXIAO_INFO_M C
         WHERE C.ACCT_MONTH = V_MONTH
           AND C.TELE_TYPE = '2'
           AND C.IS_HUAXIAO_02 = '1') C，
        RPT_HBTELE.SJZX_WH_DIM_USER_DINNER D,
        TMP_LW_OUT_02 E,
        TMP_LW_OUT_04 F,
        (SELECT user_no,is_kd_bundle
          FROM DW.DW_V_USER_BASE_INFO_USER A
         WHERE A.ACCT_MONTH = to_char(add_months(to_date(V_MONTH,'yyyymm'),-1),'yyyymm') 
           AND A.TELE_TYPE = '2')g
 WHERE A.USER_NO = B.USER_NO(+)
   AND A.USER_NO = C.USER_NO(+)
   AND A.USER_DINNER = D.USER_DINNER(+)
   AND A.USER_NO=E.USER_NO(+)
   AND A.USER_NO=F.USER_NO(+)
   and a.user_no=g.user_no(+);
commit;
  END LOOP;
END;



--开机时长
create table tmp_lw_kaiji_m1 as 
select 
a.ACCT_MONTH,
a.AREA_NO,
a.USER_NO,
nvl(b.TIMES_KAIJI,0) TIMES_KAIJI_04,
nvl(b.days_kaiji,0) days_kaiji_04
 from tmp_lw_base_01 a ,
(select *
  from rpt_hbtele.signal_alluser_m a
 where acct_month = '201804')b
 where a.USER_NO=b.user_No(+);
 
 
 create table tmp_lw_kaiji_m2 as 
select 
a.*,
nvl(b.TIMES_KAIJI,0) TIMES_KAIJI_03,
nvl(b.days_kaiji,0) days_kaiji_03
 from tmp_lw_kaiji_m1 a ,
(select *
  from rpt_hbtele.signal_alluser_m a
 where acct_month = '201803')b
 where a.USER_NO=b.user_No(+);
 
 
 
--停机
create table tmp_lw_stop_01 as 
 select 
 acct_month, 
area_no, 
user_no, 
43200-times_kaiji_04 as times_stop_04, 
30-days_kaiji_04 as days_stop_04, 
44640-times_kaiji_03 as times_stop_03, 
31-days_kaiji_03 as days_stop_03, 
43200-times_kaiji_02 as times_stop_02, 
30-days_kaiji_02 as days_stop_02, 
44640-times_kaiji_01 as times_stop_01, 
31-days_kaiji_01 as days_stop_01, 
44640-times_kaiji_12 as times_stop_12, 
31-days_kaiji_12 as days_stop_12, 
43200-times_kaiji_11 as times_stop_11, 
30-days_kaiji_11 as days_stop_11, 
44640-times_kaiji_10 as times_stop_10, 
31-days_kaiji_10 as days_stop_10,
43200-times_kaiji_09 as times_stop_09, 
30-days_kaiji_09 as days_stop_09, 
44640-times_kaiji_08 as times_stop_08, 
31-days_kaiji_08 as days_stop_08, 
46080-times_kaiji_07 as times_stop_07, 
32-days_kaiji_07 as days_stop_07 
  from tmp_lw_kaiji_01;


-------在网明细
create table  tmp_zw_base_01 as
SELECT A.ACCT_MONTH,
       A.AREA_NO,
       A.AREA_NO_DESC,
       A.ACCOUNT_NO,
       NVL(A.BUNDLE_ID_ALLOWANCE,A.BUNDLE_ID) BUNDLE_ID,
       A.USER_NO,
       A.DEVICE_NUMBER,
       A.CUSTOMER_TYPE_DESC,
       CASE
         WHEN A.CERT_TYPE = '1' AND LENGTH(A.CERT_ID)=18 and TRIM(TRANSLATE(SUBSTR(A.CERT_ID, 7, 8),'.0123456789',' ')) IS NULL THEN
          TRUNC((TO_CHAR(SYSDATE, 'YYYYMMDD') -
                SUBSTR(A.CERT_ID, 7, 8)) / 10000)
         WHEN A.CERT_TYPE = '1' AND LENGTH(A.CERT_ID)=15 and TRIM(TRANSLATE(SUBSTR(A.CERT_ID, 7, 8),'.0123456789',' ')) IS NULL THEN
           TRUNC((TO_CHAR(SYSDATE, 'YYYYMMDD') -
                SUBSTR('19'||A.CERT_ID, 7,8)) / 10000)
         ELSE
          0
       END AGE,
       A.INNET_MONTH, 
       CASE
         WHEN A.USER_DINNER_DESC LIKE '%加装%' THEN
          '1'
         ELSE
          '0'
       END IS_FUKA,
       a.IS_KD_BUNDLE IS_RONGHE,
       CASE
         WHEN A.TRANS_ID IS NOT NULL THEN
          '1'
         ELSE
          '0'
       END IS_HEYUE,
       CASE
         WHEN B.USER_NO IS NOT NULL THEN
          '1'
         ELSE
          '0'
       END IS_SCHOOL,
       CASE
         WHEN A.IS_LOGOUT = '1' THEN
          '强拆'
         WHEN A.IS_OUTNET = '1' THEN 
          '主动退网'
         ELSE 
          '正常服务'
       END LOGOUT_TYPE, 
       A.USER_DINNER,
       A.USER_DINNER_DESC,
       D.LOW_VALUE,
       A.BUNDLE_USER_DINNER,
       A.BUNDLE_USER_DINNER_DESC,
       A.CHANNEL_TYPE,
       A.CHANNEL_TYPE_DESC,
       CASE
         WHEN C.USER_NO IS NOT NULL THEN
          '1'
         ELSE
          '0'
       END IS_OPEN,
       A.TERMINAL_CORP,
       A.TERMINAL_MODEL,
       A.CHANNEL_NO,
       A.CHANNEL_NO_DESC
  FROM (SELECT *
          FROM DW.DW_V_USER_BASE_INFO_USER A
         WHERE A.ACCT_MONTH = '201805'
           AND (A.IS_LOGOUT = '1' OR A.IS_OUTNET = '1' OR A.USER_STATUS='1')
           AND A.TELE_TYPE = '2') A,
       (SELECT USER_NO
          FROM DW.DW_V_USER_SCHOOL_HX_USER_M B
         WHERE B.ACCT_MONTH = '201805'
           AND B.TELE_TYPE = '2') B,
       (SELECT USER_NO
          FROM DW.DW_V_USER_HUAXIAO_INFO_M C
         WHERE C.ACCT_MONTH = '201805'
           AND C.TELE_TYPE = '2'
           AND C.IS_HUAXIAO_02 = '1') C，
        RPT_HBTELE.SJZX_WH_DIM_USER_DINNER D
 WHERE A.USER_NO = B.USER_NO(+)
   AND A.USER_NO = C.USER_NO(+)
   AND A.USER_DINNER = D.USER_DINNER(+);
commit;


--开机时长
create table tmp_zw_kaiji_01 as 
select 
a.ACCT_MONTH,
a.AREA_NO,
a.USER_NO,
nvl(b1.TIMES_KAIJI,0) TIMES_KAIJI_04,
nvl(b1.days_kaiji,0) days_kaiji_04,
nvl(b2.TIMES_KAIJI,0) TIMES_KAIJI_03,
nvl(b2.days_kaiji,0) days_kaiji_03,
nvl(b3.TIMES_KAIJI,0) TIMES_KAIJI_02,
nvl(b3.days_kaiji,0) days_kaiji_02,
nvl(b4.TIMES_KAIJI,0) TIMES_KAIJI_01,
nvl(b4.days_kaiji,0) days_kaiji_01,
nvl(b5.TIMES_KAIJI,0) TIMES_KAIJI_12,
nvl(b5.days_kaiji,0) days_kaiji_12,
nvl(b6.TIMES_KAIJI,0) TIMES_KAIJI_11,
nvl(b6.days_kaiji,0) days_kaiji_11,
nvl(b7.TIMES_KAIJI,0) TIMES_KAIJI_10,
nvl(b7.days_kaiji,0) days_kaiji_10,
nvl(b8.TIMES_KAIJI,0) TIMES_KAIJI_09,
nvl(b8.days_kaiji,0) days_kaiji_09,
nvl(b9.TIMES_KAIJI,0) TIMES_KAIJI_08,
nvl(b9.days_kaiji,0) days_kaiji_08,
nvl(b10.TIMES_KAIJI,0) TIMES_KAIJI_07,
nvl(b10.days_kaiji,0) days_kaiji_07
 from tmp_zw_base_01 a ,
(select *
  from rpt_hbtele.signal_alluser_m a
 where acct_month = '201804')b1,
 (select *
  from rpt_hbtele.signal_alluser_m a
 where acct_month = '201803')b2,
 (select *
  from rpt_hbtele.signal_alluser_m a
 where acct_month = '201802')b3,
 (select *
  from rpt_hbtele.signal_alluser_m a
 where acct_month = '201801')b4,
 (select *
  from rpt_hbtele.signal_alluser_m a
 where acct_month = '201712')b5,
 (select *
  from rpt_hbtele.signal_alluser_m a
 where acct_month = '201711')b6,
 (select *
  from rpt_hbtele.signal_alluser_m a
 where acct_month = '201710')b7,
 (select *
  from rpt_hbtele.signal_alluser_m a
 where acct_month = '201709')b8,
 (select *
  from rpt_hbtele.signal_alluser_m a
 where acct_month = '201708')b9,
 (select *
  from rpt_hbtele.signal_alluser_m a
 where acct_month = '201707')b10
  where  a.USER_NO =b1.user_No(+)
 and a.USER_NO=b2.user_No(+)
 and a.USER_NO=b3.user_No(+)
 and a.USER_NO=b4.user_No(+)
 and a.USER_NO=b5.user_No(+)
 and a.USER_NO=b6.user_No(+)
 and a.USER_NO=b7.user_No(+)
 and a.USER_NO=b8.user_No(+)
 and a.USER_NO=b9.user_No(+)
 and a.USER_NO=b10.user_No(+);
 
 
--停机
create table tmp_zw_stop_01 as 
 select 
 acct_month, 
area_no, 
user_no, 
43200-times_kaiji_04 as times_stop_04, 
30-days_kaiji_04 as days_stop_04, 
44640-times_kaiji_03 as times_stop_03, 
31-days_kaiji_03 as days_stop_03, 
43200-times_kaiji_02 as times_stop_02, 
30-days_kaiji_02 as days_stop_02, 
44640-times_kaiji_01 as times_stop_01, 
31-days_kaiji_01 as days_stop_01, 
44640-times_kaiji_12 as times_stop_12, 
31-days_kaiji_12 as days_stop_12, 
43200-times_kaiji_11 as times_stop_11, 
30-days_kaiji_11 as days_stop_11, 
44640-times_kaiji_10 as times_stop_10, 
31-days_kaiji_10 as days_stop_10,
43200-times_kaiji_09 as times_stop_09, 
30-days_kaiji_09 as days_stop_09, 
44640-times_kaiji_08 as times_stop_08, 
31-days_kaiji_08 as days_stop_08, 
46080-times_kaiji_07 as times_stop_07, 
32-days_kaiji_07 as days_stop_07 
  from tmp_zw_kaiji_01;

--APP   来源表 cust_label_hb
create table tmp_mjh_label_01 as
select user_no,area_no,
case when flux_app=0 then 0
  when flux_app>0 and flux_app<=10 then 1
   when flux_app>10 and flux_app<=50 then 2
     when flux_app>50 and flux_app<=100  then 3
       else 4 end flux_app
from 
(select 
reserv48 as user_no,
reserv6 as area_no,
nvl(reserv384,0)+
nvl(reserv390,0)+
nvl(reserv393,0)+
nvl(reserv396,0) as flux_app
 from  tmp_mjh_label_0706_01 t)
  

--APP
create table tmp_app_visit as 
select AREA_NO,user_no, sum(DOWNLOAD_BYTES)DOWNLOAD_BYTES, sum(UPLOAD_BYTES)UPLOAD_BYTES, sum(VISIT_DURATION)VISIT_DURATION
  from O_EVT_DPI_MARK_USER_SUM_M a
 where a.acct_month = '201804'
 group by AREA_NO,user_no
 
  
  
  
  
