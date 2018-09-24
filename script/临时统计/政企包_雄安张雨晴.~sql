create table tmp_majh_0326_01 as
select b.area_no_desc,
       b.city_no_desc,
       b.acct_month || b.day_id as acct_date,
       b.device_number,
       a.user_dinner,
       a.begin_date,
       a.end_date,
       b.user_dinner_desc,
       b.channel_no,
       b.channel_no_desc,
       to_char(b.innet_date, 'yyyymmdd')innet_date
  from (select user_no,
               to_char(begin_date, 'yyyymmdd') begin_date,
               to_char(end_date, 'yyyymmdd') end_date,
               user_dinner
          from dw.dw_v_user_product_info_day
         where acct_month = '201804'
           and day_id = '08'
           and area_no = '187'
           and user_dinner = '1422998') a,
       (select acct_month,day_id,area_no_desc,city_no_desc,device_number,user_dinner_desc,channel_no,channel_no_desc,innet_date,user_no
          from dw.dw_v_user_base_info_day
         where acct_month = '201803'
           and day_id = '31'
           and area_no = '187'
           and city_no in ('018187015', '018187022', '018187002')
           and is_onnet = '1') b
 where a.user_no = b.user_no
