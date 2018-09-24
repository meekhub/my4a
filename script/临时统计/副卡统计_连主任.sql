统计一个数。办理融合套餐的用户，同一个月办理了三张（及以上）副卡
且：（3张卡的入网日期在10号以后，或：4张卡的入网日期在15号以后）

分3张卡和4张卡两种情况，各自多少。可以以6月份为例




create table xxhb_mjh.tmp_rh_0730_01 as 
select area_no,city_no,account_no,
       customer_no,
       user_no,
       device_number,
       innet_date,
       bundle_id,
       user_dinner_desc，
       BUNDLE_DINNER_BEG_DATE
  from dw.dw_v_user_base_info_user a
 where acct_month = '201806'
   and to_char(BUNDLE_DINNER_BEG_DATE, 'yyyymm') = '201806'
   and user_dinner_desc like '%加装%'
   and tele_type = '2'


select flag,count(*) from 
(select bundle_id,count(*)flag from xxhb_mjh.tmp_rh_0730_01 group by bundle_id having count(*)>=3)
group by flag



select flag, count(*)
  from (select bundle_id, count(*) flag
          from (select * from  xxhb_mjh.tmp_rh_0730_01 where to_char(BUNDLE_DINNER_BEG_DATE,'yyyymmdd')>='20180615')
         group by bundle_id
        having count(*) = 4)
 group by flag


302
194

3张卡的入网日期在10号以后的有302户，4张卡的入网日期在15号以后的有194户















