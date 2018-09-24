select b.user_dinner_desc, sum(cur_value)
  from mobile_cbzs.MID_CBZS_KKPI_D_DEV_CUR_B a, DIM.DIM_USER_DINNER b,DIM.DIM_CHANNEL_HUAXIAO c
 where a.user_dinner = b.user_dinner
 and b.user_dinner_desc like '%不限量%'
 and a.day_id='20180503'
 and a.type_one='04'
 --and b.user_dinner_desc like '%129%'
 and a.start_time=14
 and a.end_time=16
 and a.dealer_id=c.channel_no(+)
 and c.huaxiao_type in ('01','02','03','04')
 and b.user_dinner_desc='天翼省内不限量109套餐（201711） [基础移动电话]'
 group by b.user_dinner_desc



select b.channel_no_desc,sum(1) from dim.dim_channel_no b where channel_no in (
select distinct dealer_id
  from (select *
          from mobile_cbzs.MID_CBZS_KKPI_D_DEV_CUR_B a
         where a.user_dinner = '1422909'
           and a.day_id = '20180503'
           and a.type_one = '04'
           and a.start_time = 14
           and a.end_time = 16) a,
       DIM.DIM_CHANNEL_HUAXIAO b
 where a.dealer_id = b.channel_no(+)
   and b.channel_no is null)
   group by channel_no_desc
