select count(*)  from NEWDATAPLATFORM.CMCODE_YZF_USER;

--场景一（红包风险控制分析场景）
insert  RED_MODEL_SENSE_01
select '201805' ACCT_MONTH,
       t.area_no,
       sum(rebate_amt) / sum(t.total_fee)/100 as redbag_fee_rate, --本月返还红包套餐用户本月返还红包金额/ 本月返还红包套餐用户本月出账收入
       count(case
               when t.innet_month_redbag <= 3 and t.is_logout = '1' then
                t.device_number
             end) / count(case
                            when t.owe_fee > 0 then
                             t.device_number
                          end) as low_onnet_rate, --红包卡在网时长在3个月以内且在当月离网/当月所有红包卡用户离网数
       count(case
               when t.owe_fee > 0 then
                t.user_no
             end) / count(*) as owe_user_rate, --红包用户欠费用户数/所有红包卡用户
       sum(t.owe_fee) / count(case
                                when owe_fee > 0 then
                                 t.user_no
                              end) as per_owe_rate --本月到达红包套餐欠费金额/本月到达红包套餐用户数户均欠费金额
  from yzf_redbag_user_info_m t
 where t.acct_month = '201805'
   and t.carrier_name = 'dx'
   and t.is_redbag = '1'
 group by t.area_no;
 
 --场景一派单
 --当月实际单户返还红包金额/用户所选套餐返费金额
 
 --上月返还失败用户
 create table xxhb_mjh.tmp_red_fail_mx as 
SELECT    
      *
      FROM acct_dsg.BF_BESTPAY_PAY_FEE_HIS_T@hbods T
     WHERE 
     --city_code='188' AND
        T.OPERATE_DATE >= SYSDATE-30
       AND PAY_WAY=11
       --and T.OPERATE_DATE >= VD_BEG_DATE
      -- AND T.OPERATE_DATE <= VD_END_DATE
      --AND T.PAY_WAY = 14
       --AND T.STATE = 1 
       --and service_id='18931177978'
       and STATE=3
       and service_id='17769066399'

      
select *
  from acct_dsg.bf_yzf_pickup_t@hbods a
 where  acc_nbr='15303173637'
 
       
--欠费停机用户
create table xxhb_mjh.tmp_red_owe_mx as
select user_no from dw.dw_v_user_base_info_user b
where acct_month='201806'
and tele_type='2'
and user_status=4


delete from RED_MODEL_SENSE_01_MX where acct_month in ('201806')
 
insert into  RED_MODEL_SENSE_01_MX
 select '201806' acct_month,t.user_no,t.device_number,t.area_no,t.city_no,t.rebate_amt,t.gebate_amt,t.cnsm_amt
   from yzf_redbag_user_info_m t
 where t.acct_month = '201806'
   and t.carrier_name = 'dx'
   and t.is_redbag = '1'
   and t.rebate_amt > 0
   and t.gebate_amt > 0  
   and (t.rebate_amt)/t.gebate_amt >= 4 
   and t.sales_mode<>'1417618';
   commit;

--导出
create table xxhb_mjh.tmp_majh_red_0801 as 
select acct_month, 
       b.area_desc,
       c.city_desc,
       device_number, 
       rebate_amt / 100 as rebate_amt,
       gebate_amt / 100 as gebate_amt
  from RED_MODEL_SENSE_01_MX a,dim.dim_area_no b,dim.dim_city_no c
 where acct_month = '201806'
 and a.area_no=b.area_no
 and a.city_no=c.city_no
 and not exists
 (select 1 from xxhb_mjh.tmp_red_owe_mx x where a.user_no=x.user_no)
 and not exists
 (select 1 from xxhb_mjh.tmp_red_fail_mx y where a.user_no=y.user_id)
 



SELECT a.acct_month,B.AREA_DESC, c.city_desc,A.DEVICE_NUMBER, A.REBATE_AMT/100, A.GEBATE_AMT/100
  FROM RED_MODEL_SENSE_01_MX A, DIM.DIM_AREA_NO B,dim.dim_city_no c
 WHERE A.AREA_NO = B.AREA_NO
 and a.city_no=c.city_no
 and a.acct_month='201803'
 
 
       
--场景二 红包资源盘活分析场景
delete from  RED_MODEL_SENSE_02_MX a where ACCT_MONTH='201806'

insert into  RED_MODEL_SENSE_02_MX
select t.area_no,
       t.city_no,
       t.user_no,
       t.device_number,
       sum(t.rebate_amt) rebate_amt_total,
       sum(REDBAG_USER_AMT) / sum(t.rebate_amt) as per_user_amt,
       '201806'
  from yzf_redbag_user_info_m t
 where t.acct_month in ('201804','201805','201806')
   and t.carrier_name = 'dx'
   and t.is_redbag = '1'
   and t.rebate_amt > 0
   --and t.cnsm_amt > 0
   and t.is_onnet='1'
 group by t.area_no, t.city_no,t.user_no,t.device_number
having sum(t.rebate_amt) > 15000 and sum(REDBAG_USER_AMT) / sum(t.rebate_amt) <= 0.3;
commit;



--导出
select y.area_desc,
       x.city_desc,
       t.device_number,
       t.rebate_amt_total / 100,
       round(per_user_amt, 2)
  from red_model_sense_02_mx t, dim.dim_city_no x, dim.dim_area_no y
 where t.city_no = x.city_no
   and t.area_no = y.area_no
   and t.acct_month='201806'
   
/*
红包套餐用户非通信类业务消费金额/红包套餐用户当月消费额	≤50%
户均消费次数	0*/
create table RED_MODEL_SENSE_02_MX_2 as
select t.area_no, t.city_no, call_amt, cnsm_amt, rebate_amt
  from (select t.area_no,
               t.city_no,
               sum(t.cnsm_amt - t.cmnctn_cnsm_amt) call_amt,
               sum(t.cnsm_amt) cnsm_amt,
               sum(t.rebate_amt) rebate_amt
          from yzf_redbag_user_info_m t
         where t.acct_month in ('201803')
           and t.carrier_name = 'dx'
           and t.is_redbag = '1'
           and t.rebate_amt > 0
           and t.cnsm_amt > 0
         group by t.area_no, t.city_no) t
 where call_amt / cnsm_amt < 0.5
   and cnsm_amt / rebate_amt < 0.5;



--场景三 用户价值提升分析场景
--无法输出用户清单

--场景四 生态建设
SELECT *
  FROM (SELECT T.MERCHANT_CITY_NAME,
               COUNT(DISTINCT CASE
                       WHEN T.IS_ACTIVE_MON = '1' THEN
                        T.MERCHANT_CODE
                     END) ACTIVE_CNT,
               COUNT(DISTINCT CASE
                       WHEN T.IS_ONNET = '1' THEN
                        T.MERCHANT_CODE
                     END) ONNET_CNT,
               sum(CNSM_USER_CNT)CNSM_USER_CNT 
          FROM STAGE.BWT_DOWN_YZF_YPAYO_STORE_M T
         WHERE T.MONTH_ID = '201803'
         GROUP BY T.MERCHANT_CITY_NAME) A
 WHERE ACTIVE_CNT / ONNET_CNT < 0.6













