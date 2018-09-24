create table tmp_majh_0526_01 as 
select e.area_desc,
       f.city_desc,
       a.huaxiao_no_02,
       a.huaxiao_name_02,
       a.account_no,
       a.device_number,
       b.TELE_TYPE_DESC,
       a.innet_date,
       a.channel_no_desc,
       b.CHANNEL_TYPE_DESC,
       b.RECENT_STOP_DATE,
       b.user_dinner,
       b.USER_DINNER_DESC,
       c.low_value,
       b.SALES_MODE,
       b.SALES_MODE_DESC,
       D.CONSUME_FEE,
       (a.price_fee + a.price_fee_ocs) as total_fee,
       a.qfcs_fee,
       b.OWE_FEE
  from (select a.account_no,
               a.device_number,
               a.innet_date,
               a.channel_no,
               a.channel_no_desc,
               a.user_dinner,
               a.qfcs_fee,
               price_fee,
               price_fee_ocs,
               USER_NO,
               area_no,
               city_no,
               a.huaxiao_no_02,
               a.huaxiao_name_02
          from dw.dw_v_user_huaxiao_info_m a
         where acct_month = '201804'
           and is_huaxiao_02 = '1'
           and is_onnet = '1') a,
       (select user_no,
               b.RECENT_STOP_DATE,
               b.TELE_TYPE_DESC,
               b.USER_DINNER,
               b.USER_DINNER_DESC,
               OWE_FEE,
               SALES_MODE,
               SALES_MODE_DESC,
               CHANNEL_TYPE_DESC
          from dw.dw_v_user_base_info_user b
         where acct_month = '201804') b,
       RPT_HBTELE.SJZX_WH_DIM_USER_DINNER c,
       (select *
          from (select user_no,
                       CONSUME_FEE,
                       row_number() over(partition by user_no order by begin_date desc) rn
                  from DW.DW_V_USER_DEVICE_RENT
                 where acct_month = '201804')
         where rn = 1) D,
       dim.dim_area_no e,
       dim.dim_city_no f
 where a.user_no = b.user_No(+)
   and a.user_dinner = c.user_dinner(+)
   AND A.USER_NO = D.USER_NO(+)
   and a.area_no = e.area_no(+)
   and a.city_no = f.city_no(+);


--出账单和欠费
create table TMP_MAJH_0526_02 as 
select 
a.*,b.price_fee as fee_201803,b.qfcs_fee  as bqfcs_fee_201803
 from TMP_MAJH_0526_01 a,
(select  device_number,price_fee,qfcs_fee
          from dw.dw_v_user_huaxiao_info_m a
         where acct_month = '201803'
           and is_huaxiao_02 = '1'
           and is_onnet = '1')b
           where a.DEVICE_NUMBER=b.device_number(+);


create table TMP_MAJH_0526_06 as 
select 
a.*,b.price_fee as fee_201711,b.qfcs_fee  as bqfcs_fee_201711
 from TMP_MAJH_0526_05 a,
(select  device_number,price_fee,qfcs_fee
          from dw.dw_v_user_huaxiao_info_m a
         where acct_month = '201711'
           and is_huaxiao_02 = '1'
           and is_onnet = '1')b
           where a.DEVICE_NUMBER=b.device_number(+);



--导出
SELECT AREA_DESC 地市,
       CITY_DESC 区县,
       HUAXIAO_NO_02 划小编码,
       HUAXIAO_NAME_02 划小名称,
       ACCOUNT_NO 户ID,
       DEVICE_NUMBER 主号,
       TELE_TYPE_DESC 业务类型,
       TO_CHAR(INNET_DATE, 'YYYYMMDD') 入网时间,
       CHANNEL_NO_DESC 入网渠道,
       CHANNEL_TYPE_DESC 渠道类型,
       RECENT_STOP_DATE 最后一次欠停时间,
       USER_DINNER 套餐ID,
       USER_DINNER_DESC 套餐名称,
       LOW_VALUE 套餐租费,
       SALES_MODE 合约ID,
       SALES_MODE_DESC 合约名称,
       CONSUME_FEE 合约低消,
       TOTAL_FEE 账单金额,
       QFCS_FEE 当月欠费,
       OWE_FEE 累积欠费,
       FEE_201803 _2018年3月收入,
       BQFCS_FEE_201803 _2018年3月欠费,
       FEE_201802 _2018年2月收入,
       BQFCS_FEE_201802 _2018年2月欠费,
       FEE_201801 _2018年1月收入,
       BQFCS_FEE_201801 _2018年1月欠费,
       FEE_201712 _2017年12月收入,
       BQFCS_FEE_201712 _2017年12月欠费,
       FEE_201711_2017年11月收入,
       BQFCS_FEE_201711 _2017年11月欠费
  FROM TMP_MAJH_0526_06 T
