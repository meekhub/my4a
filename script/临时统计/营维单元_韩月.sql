select distinct t.area_desc from tmp_majh_0304_yw_01 t;

--发展人
create table tmp_majh_0304_dev
(
area_desc varchar2(20),
huaxiao_no varchar2(20),
DEVELOP_NO varchar2(20)
)

create table tmp_majh_0304_yw_lf as
select * from tmp_majh_0304_yw_01 where 1=2;


update  tmp_majh_0304_yw_lf set  device_number='0'||device_number where device_number like '3%'


--匹配不到
select t.* from   tmp_majh_0304_yw_01 t，
(select * from  dim.dim_huaxiao_info where  huaxiao_type='06')x 
where t.HUAXIAO_NO=x.huaxiao_no(+)
and x.huaxiao_no is null;

--新发展
create table tmp_majh_0304_yw_02 as
select a.*, user_no
  from (select *
          from (select develop_no,
                       huaxiao_no,
                       row_number() over(partition by develop_no order by 1) rn
                  from tmp_majh_0304_dev)
         where rn = 1) a,
       (select DEVELOP_NO, user_no
          FROM DW.DW_V_USER_MOBILEUSER T
         WHERE T.ACCT_MONTH = '201802'
        --AND T.AREA_NO = '188'
        union all
        select DEVELOP_NO, user_no
          FROM DW.DW_V_USER_MOBILEUSER_OCS_M T
         WHERE T.ACCT_MONTH = '201802'
              --AND T.AREA_NO = '188'
           and develop_no is not null) b
 where a.develop_no = b.develop_no;


create table tmp_majh_0304_yw_03 as
select '201802' ACCT_MONTH,
       a.AREA_NO,
       a.CITY_NO,
       a.USER_NO,
       a.DEVICE_NUMBER,
       b.huaxiao_no,
       a.INNET_DATE,
       a.TOTAL_FEE,
       a.TOTAL_FEE_OCS,
       a.IS_ACCT,
       a.IS_ACCT_OCS,
       a.IS_ONNET,
       a.CHANNEL_NO,
       a.CHANNEL_NO_DESC， a.TELE_TYPE_NAME,
       a.IS_NEW，
       c.huaxiao_no as huaxiao_no_dev,
       c.develop_no
  from (SELECT A.AREA_NO,
               A.CITY_NO,
               A.TELE_TYPE,
               A.USER_NO,
               A.CUSTOMER_NO,
               A.ACCOUNT_NO,
               A.DEVICE_NUMBER,
               A.INNET_DATE,
               A.USER_DINNER,
               A.CHANNEL_NO,
               A.CHANNEL_NO_DESC,
               A.GROUP_NO,
               A.IS_ONNET,
               A.IS_NEW,
               A.IS_ACTIVE,
               A.IS_CALL,
               A.USER_STATUS,
               A.LOGOUT_DATE,
               A.IS_LOGOUT,
               A.IS_OUTNET,
               A.IS_VALID,
               A.RECENT_STOP_DATE,
               A.IS_OCS,
               A.IS_ACCT,
               A.IS_ACCT_OCS,
               A.INNET_MONTH,
               A.INNET_METHOD,
               NVL(BUNDLE_ID_ALLOWANCE, BUNDLE_ID) BUNDLE_ID,
               A.IS_KD_BUNDLE,
               A.TOTAL_FEE,
               A.TOTAL_FEE_OCS,
               A.PRICE_FEE,
               A.PRICE_FEE_OCS,
               A.BUNDLE_ID_ALLOWANCE,
               A.ALL_JF_FLUX,
               A.WIFI_JF_FLUX,
               A.JF_TIMES,
               A.TERMINAL_TYPE,
               A.TERMINAL_CORP,
               A.TELE_TYPE_NEW,
               A.IS_3NO_ADJUST,
               CASE
                 WHEN TELE_TYPE = '2' THEN
                  '移动'
                 WHEN TELE_TYPE_NEW = 'G010' THEN
                  '宽带'
                 WHEN TELE_TYPE_NEW = 'G110' THEN
                  '电视'
                 WHEN TELE_TYPE_NEW IN ('G020', 'G040') THEN
                  '专线电路'
                 WHEN TELE_TYPE_NEW IN ('G000', 'G001', 'G002') THEN
                  '固话'
               END TELE_TYPE_NAME
          FROM DW.DW_V_USER_BASE_INFO_USER A
         WHERE ACCT_MONTH = '201802'
           --AND AREA_NO = '188'
           AND (TELE_TYPE = '2' OR
               TELE_TYPE_NEW IN
               ('G010', 'G110', 'G020', 'G040', 'G000', 'G001', 'G002'))) a,
       (select * from (select device_number,huaxiao_no，row_number()over(partition by device_number order by 1)rn from  tmp_majh_yw) where rn=1) b,
       tmp_majh_0304_yw_02 c 
 where a.DEVICE_NUMBER = b.device_number(+)
   and a.user_no = c.user_no(+);


select 
c.area_desc,
d.city_desc,
b.huaxiao_no,
b.huaxiao_name,
--收入
sum(a.total_fee+a.total_fee_ocs) total_fee_all,
sum(case when to_char(a.innet_date,'yyyymm')<='201712' then a.total_fee+a.total_fee_ocs else 0 end)total_fee_cl,
--移动
count(case when a.tele_type_name='移动' and (a.is_acct='1' or a.is_acct_ocs='1') then a.user_no end)acct_cnt_all,
count(case when a.tele_type_name='移动' and  to_char(a.innet_date,'yyyymm')<='201712' and (a.is_acct='1' or a.is_acct_ocs='1') then a.user_no end)acct_cnt_all,
count(case when a.tele_type_name='移动' and  a.is_new='1' then a.user_no end)acct_cnt_new,
--宽带
count(case when a.tele_type_name='宽带' and (a.is_acct='1' or a.is_acct_ocs='1') then a.user_no end)acct_cnt_all,
count(case when a.tele_type_name='宽带' and to_char(a.innet_date,'yyyymm')<='201712' and (a.is_acct='1' or a.is_acct_ocs='1') then a.user_no end)acct_cnt_all,
count(case when a.tele_type_name='宽带' and a.is_new='1' then a.user_no end)acct_cnt_new,
--电视
count(case when a.tele_type_name='电视' and (a.is_acct='1' or a.is_acct_ocs='1') then a.user_no end)acct_cnt_all,
count(case when a.tele_type_name='电视' and to_char(a.innet_date,'yyyymm')<='201712' and (a.is_acct='1' or a.is_acct_ocs='1') then a.user_no end)acct_cnt_all,
count(case when a.tele_type_name='电视' and a.is_new='1' then a.user_no end)acct_cnt_new,
--专线电路
count(case when a.tele_type_name='专线电路' and (a.is_acct='1' or a.is_acct_ocs='1') then a.user_no end)acct_cnt_all,
count(case when a.tele_type_name='专线电路' and to_char(a.innet_date,'yyyymm')<='201712' and (a.is_acct='1' or a.is_acct_ocs='1') then a.user_no end)acct_cnt_all,
count(case when a.tele_type_name='专线电路' and a.is_new='1' then a.user_no end)acct_cnt_new,
--固话
count(case when a.tele_type_name='固话' and (a.is_acct='1' or a.is_acct_ocs='1') then a.user_no end)acct_cnt_all,
count(case when a.tele_type_name='固话' and to_char(a.innet_date,'yyyymm')<='201712' and (a.is_acct='1' or a.is_acct_ocs='1') then a.user_no end)acct_cnt_all,
count(case when a.tele_type_name='固话' and a.is_new='1' then a.user_no end)acct_cnt_new
 from  tmp_majh_0304_yw_03 a, dim.dim_huaxiao_info b,dim.dim_area_no c,dim.dim_city_no d
where a.huaxiao_no=b.huaxiao_no
and b.area_no=c.area_no
and b.city_no=d.city_no
group by c.area_desc,
d.city_desc,
b.huaxiao_no,
b.huaxiao_name




---双记核算
select 
c.area_desc, 
--收入
sum(a.total_fee+a.total_fee_ocs) total_fee_all
 from  tmp_majh_0304_yw_03 a, dim.dim_huaxiao_info b,dim.dim_area_no c 
where a.huaxiao_no=b.huaxiao_no
and b.huaxiao_type='06'
and b.area_no=c.area_no 
group by c.area_desc,c.idx_no
order by c.idx_no

--与商客双记
select 
c.area_desc, 
--收入
sum(a.total_fee+a.total_fee_ocs) total_fee_all
 from  tmp_majh_0304_yw_03 a, dim.dim_huaxiao_info b,dim.dim_area_no c，tmp_majh_sk_01 d
where a.huaxiao_no=b.huaxiao_no
and b.area_no=c.area_no 
and a.user_no=d.user_no
and b.huaxiao_type='06'
and d.huaxiao_no is not null
group by c.area_desc,c.idx_no
order by c.idx_no



--与校园双记
select 
c.area_desc, 
--收入
sum(a.total_fee+a.total_fee_ocs) total_fee_all
 from  tmp_majh_0304_yw_03 a, dim.dim_huaxiao_info b,dim.dim_area_no c，tmp_majh_0304_gx_01 d
where a.huaxiao_no=b.huaxiao_no
and b.area_no=c.area_no 
and a.user_no=d.user_no 
and d.huaxiao_no is not null
group by c.area_desc,c.idx_no
order by c.idx_no








