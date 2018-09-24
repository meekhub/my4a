create table tmp_majh_0416_01 as
select  a.user_no,c.device_number,c.total_fee,a.huaxiao_type,IS_HUAXIAO_01,IS_HUAXIAO_02,IS_HUAXIAO_03,IS_HUAXIAO_04
  from (select *
          from (select a.*,
                       row_number() over(partition by user_no order by total_fee desc) rn
                  from tmp_majh_zq_hx_201803 a where a.area_no='180')
         where rn = 1) a,
       dim.dim_area_no b， (select user_no, device_number,
                                  total_fee + total_fee_ocs as total_fee,
                                  IS_HUAXIAO_01,IS_HUAXIAO_02,IS_HUAXIAO_03,IS_HUAXIAO_04
                             from dw.DW_V_USER_HUAXIAO_INFO_M c
                            where acct_month = '201803'
                              and (IS_HUAXIAO_01 = '1' or
                                  IS_HUAXIAO_02 = '1' or
                                  IS_HUAXIAO_03 = '1' or
                                  IS_HUAXIAO_04 = '1')) c
 where a.area_no = b.area_no
   and a.user_no = c.user_no 
   
   
select
user_no 用户编码，
device_number 手机号，
total_fee 三月出账收入，
huaxiao_type 政企划小类型，
IS_HUAXIAO_01 是否自有厅，
IS_HUAXIAO_02 是否商圈，
IS_HUAXIAO_03 是否社区，
IS_HUAXIAO_04 是否农村
 from tmp_majh_0416_01   
