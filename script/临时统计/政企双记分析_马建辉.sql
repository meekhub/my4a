create table tmp_majh_zq_hx_201802 as 
select b.area_no,
       user_no,
       device_Number,
       (a.total_fee + a.total_fee_ocs) as total_fee,
       a.huaxiao_no,
       '05' huaxiao_type
  from tmp_majh_sk_01 a，dim.dim_huaxiao_info b
  where a.huaxiao_no=b.huaxiao_no
union all
select b.area_no,
       user_no,
       device_Number,
       (a.total_fee + a.total_fee_ocs) as total_fee,
       a.huaxiao_no,
       '06' huaxiao_type
  from tmp_majh_0304_yw_03 a，dim.dim_huaxiao_info b
  where a.huaxiao_no=b.huaxiao_no
union all
select b.area_no,
       user_no,
       device_Number,
       (a.total_fee + a.total_fee_ocs) as total_fee,
       a.huaxiao_no,
       '07' huaxiao_type
  from tmp_majh_0304_gx_01 a，dim.dim_huaxiao_info b
  where a.huaxiao_no=b.huaxiao_no
union all
select b.area_no, to_char(user_no),'', iot_fee,b.huaxiao_no,'07' huaxiao_type
  from dw.MID_DW_V_USER_HUAXIAO_IOT a,
       (select * from dim.dim_huaxiao_info a where a.huaxiao_type = '08') b
       where  a.area_no = b.area_no
       and a.ACCT_MONTH='201802'
       

--汇总
select b.area_desc,sum(total_fee)total_fee 
  from (select *
          from (select a.*,
                       row_number() over(partition by user_no order by total_fee desc) rn
                  from tmp_majh_zq_hx_201802 a)
         where rn = 1) a,
       dim.dim_area_no b
 where a.area_no = b.area_no
 group by b.area_desc, b.idx_no
 order by b.idx_no
 


--政企和实体双记部分
select b.area_desc, sum(a.total_fee) total_fee, sum(c.total_fee) total_fee
  from (select *
          from (select a.*,
                       row_number() over(partition by user_no order by total_fee desc) rn
                  from tmp_majh_zq_hx_201802 a)
         where rn = 1) a,
       dim.dim_area_no b， (select user_no,
                                  total_fee + total_fee_ocs as total_fee
                             from dw.DW_V_USER_HUAXIAO_INFO_M c
                            where acct_month = '201803'
                              and (IS_HUAXIAO_01 = '1' or
                                  IS_HUAXIAO_02 = '1' or
                                  IS_HUAXIAO_03 = '1' or
                                  IS_HUAXIAO_04 = '1')) c
 where a.area_no = b.area_no
   and a.user_no = c.user_no
 group by b.area_desc, b.idx_no
 order by b.idx_no
 
 
 --分类双计分析
 select b.area_desc, 
 --自有厅
 sum(case when a.huaxiao_type='05' and IS_HUAXIAO_01 = '1'  then a.total_fee else 0 end) total_fee1,
  sum(case when a.huaxiao_type='06'  and IS_HUAXIAO_01 = '1' then a.total_fee else 0 end) total_fee2,
   sum(case when a.huaxiao_type='07'  and IS_HUAXIAO_01 = '1' then a.total_fee else 0 end) total_fee3,
    sum(case when a.huaxiao_type='08'  and IS_HUAXIAO_01 = '1' then a.total_fee else 0 end) total_fee4，
  --商圈
 sum(case when a.huaxiao_type='05' and IS_HUAXIAO_02 = '1'  then a.total_fee else 0 end) total_fee1,
  sum(case when a.huaxiao_type='06'  and IS_HUAXIAO_02 = '1' then a.total_fee else 0 end) total_fee2,
   sum(case when a.huaxiao_type='07'  and IS_HUAXIAO_02 = '1' then a.total_fee else 0 end) total_fee3,
    sum(case when a.huaxiao_type='08'  and IS_HUAXIAO_02 = '1' then a.total_fee else 0 end) total_fee4，  
  --社区
 sum(case when a.huaxiao_type='05' and IS_HUAXIAO_03 = '1'  then a.total_fee else 0 end) total_fee1,
  sum(case when a.huaxiao_type='06'  and IS_HUAXIAO_03 = '1' then a.total_fee else 0 end) total_fee2,
   sum(case when a.huaxiao_type='07'  and IS_HUAXIAO_03 = '1' then a.total_fee else 0 end) total_fee3,
    sum(case when a.huaxiao_type='08'  and IS_HUAXIAO_03 = '1' then a.total_fee else 0 end) total_fee4， 
  --农村
 sum(case when a.huaxiao_type='05' and IS_HUAXIAO_04 = '1'  then a.total_fee else 0 end) total_fee1,
  sum(case when a.huaxiao_type='06'  and IS_HUAXIAO_04 = '1' then a.total_fee else 0 end) total_fee2,
   sum(case when a.huaxiao_type='07'  and IS_HUAXIAO_04 = '1' then a.total_fee else 0 end) total_fee3,
    sum(case when a.huaxiao_type='08'  and IS_HUAXIAO_04 = '1' then a.total_fee else 0 end) total_fee4          
  from (select *
          from (select a.*,
                       row_number() over(partition by user_no order by total_fee desc) rn
                  from tmp_majh_zq_hx_201802 a )
         where rn = 1) a,
       dim.dim_area_no b， (select user_no,
                                  total_fee + total_fee_ocs as total_fee,IS_HUAXIAO_01,IS_HUAXIAO_02,IS_HUAXIAO_03,IS_HUAXIAO_04
                             from dw.DW_V_USER_HUAXIAO_INFO_M c
                            where acct_month = '201802'
                              and (IS_HUAXIAO_01 = '1' or
                                  IS_HUAXIAO_02 = '1' or
                                  IS_HUAXIAO_03 = '1' or
                                  IS_HUAXIAO_04 = '1')) c
 where a.area_no = b.area_no
   and a.user_no = c.user_no
 group by b.area_desc, b.idx_no
 order by b.idx_no
 
