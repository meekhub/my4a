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


--���˵���Ƿ��
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



--����
SELECT AREA_DESC ����,
       CITY_DESC ����,
       HUAXIAO_NO_02 ��С����,
       HUAXIAO_NAME_02 ��С����,
       ACCOUNT_NO ��ID,
       DEVICE_NUMBER ����,
       TELE_TYPE_DESC ҵ������,
       TO_CHAR(INNET_DATE, 'YYYYMMDD') ����ʱ��,
       CHANNEL_NO_DESC ��������,
       CHANNEL_TYPE_DESC ��������,
       RECENT_STOP_DATE ���һ��Ƿͣʱ��,
       USER_DINNER �ײ�ID,
       USER_DINNER_DESC �ײ�����,
       LOW_VALUE �ײ����,
       SALES_MODE ��ԼID,
       SALES_MODE_DESC ��Լ����,
       CONSUME_FEE ��Լ����,
       TOTAL_FEE �˵����,
       QFCS_FEE ����Ƿ��,
       OWE_FEE �ۻ�Ƿ��,
       FEE_201803 _2018��3������,
       BQFCS_FEE_201803 _2018��3��Ƿ��,
       FEE_201802 _2018��2������,
       BQFCS_FEE_201802 _2018��2��Ƿ��,
       FEE_201801 _2018��1������,
       BQFCS_FEE_201801 _2018��1��Ƿ��,
       FEE_201712 _2017��12������,
       BQFCS_FEE_201712 _2017��12��Ƿ��,
       FEE_201711_2017��11������,
       BQFCS_FEE_201711 _2017��11��Ƿ��
  FROM TMP_MAJH_0526_06 T
