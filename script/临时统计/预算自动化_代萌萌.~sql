SELECT * FROM USER_TABLES A WHERE A.TABLE_NAME LIKE '%PROJECT%';

select * from BUDGET_ACCOUNTING;

--预算成本中心
select * from mss_ds.BUDGET_COST_CENTER@hana;

--预算成本中心组织表
select * from mss_ds.budget_cost_center_org@hana;

--预算事项应用表
select * from mss_ds.budget_inst_app@hana where org_id='2701080002'  and budget_item_id='27_Cost_3091';

--预算指标表
select * from mss_ds.BUDGET_ITEM@hana

select * from budget_inst_app where budget_item_id='27_Cost_3091'

select * from mss_ds.BUDGET_INST_COST@hana

--成本表结构
select * from mss_ds.BUDGET_INST_ARCHIVE_COST@hana where org_id='2708000013'

--预算指标表
select * from budget_item a where a.budget_item_name like '%易耗%';

select * from budget_item a where a.id='27_Cost_3019'



广告宣传费：27_Cost_2740
客户服务费：27_Cost_2910
业务招待费：27_Cost_3091
--车辆使用及租赁费：27_Cost_3095
低值易耗品费：27_Cost_3074
业务用品费：27_Cost_3004
渠道支撑 ：27_Cost_2897
房屋、土地及场地租赁费	27_Cost_3019

select *
  from budget_item a
 where a.id in ('27_Cost_2740',
                '27_Cost_2910',
                '27_Cost_3091',
                '27_Cost_3074',
                '27_Cost_3004',
                '27_Cost_2897',
                '27_Cost_3019')
BUDGET_SET_STR;


create table xxhb_mjh.tmp_majh_dz_fee as 
SELECT '201808' ACCT_MONTH,
       C.AREA_NO,
       C.CITY_NO,
       '1' HUAXIAO_TYPE_BIG,
       C.HUAXIAO_TYPE,
       C.HUAXIAO_NO,
       '02' TYPE_ONE,
       '01' TYPE_TWO,
       SUM(CASE
             WHEN A.BUDGET_SET_STR = '201807' AND
                  UPPER(BUDGET_ITEM_ID) IN ('27_COST_2740') THEN
              A.USED_SUM
             ELSE
              0
           END)gg_fee, --广告宣传费
       SUM(CASE
             WHEN A.BUDGET_SET_STR = '201807' AND
                  UPPER(BUDGET_ITEM_ID) IN ('27_COST_2910') THEN
              A.USED_SUM
             ELSE
              0
           END)kf_fee, --客户服务费
       SUM(CASE
             WHEN A.BUDGET_SET_STR = '201807' AND
                  UPPER(BUDGET_ITEM_ID) IN ('27_COST_3091') THEN
              A.USED_SUM
             ELSE
              0
           END)yw_fee, --业务招待费
       SUM(CASE
             WHEN A.BUDGET_SET_STR = '201807' AND
                  UPPER(BUDGET_ITEM_ID) IN ('27_COST_3074') THEN
              A.USED_SUM
             ELSE
              0
           END)dz_fee, --低值易耗品费
       SUM(CASE
             WHEN A.BUDGET_SET_STR = '201807' AND
                  UPPER(BUDGET_ITEM_ID) IN ('27_COST_3004') THEN
              A.USED_SUM
             ELSE
              0
           END)yp_fee, --业务用品费
       SUM(CASE
             WHEN A.BUDGET_SET_STR = '201807' AND
                  UPPER(BUDGET_ITEM_ID) IN ('27_COST_2897') THEN
              A.USED_SUM
             ELSE
              0
           END)zc_fee, --业务支撑
       SUM(CASE
             WHEN A.BUDGET_SET_STR = '201807' AND
                  UPPER(BUDGET_ITEM_ID) IN ('27_COST_3019') THEN
              A.USED_SUM
             ELSE
              0
           END)zl_fee --租赁费
  FROM MSS_DS.BUDGET_INST_APP@HANA A,
       DIM.DIM_CW_HUAXIAO_INFO     B,
       DIM.DIM_HUAXIAO_INFO        C
 WHERE UPPER(BUDGET_ITEM_ID) IN ('27_COST_2740',
                                 '27_COST_2910',
                                 '27_COST_3091',
                                 '27_COST_3074',
                                 '27_COST_3004',
                                 '27_COST_2897',
                                 '27_COST_3019')
   AND A.ORG_ID = B.CW_HUAXIAO_NO
   AND B.YW_HUAXIAO_NO = C.HUAXIAO_NO
 GROUP BY C.AREA_NO, C.CITY_NO, C.HUAXIAO_TYPE, C.HUAXIAO_NO


--年度预算 
--取数口径  取budget_set_str=2018  按照create_date最近取assign_sum
SELECT *
  FROM BUDGET_INST_COST A, BUDGET_INST_ARCHIVE_COST B
 WHERE A.BUDGET_ARCHIVE_ID = B.ID
   AND A.SUM > 0
   AND B.ORG_ID = '2709050004'
   AND A.BUDGET_ITEM_ID='27_Cost_2740'
   --AND ORG_ID='2701090007'
   
   
   
   
   

渠道费用 ：27_Cost_2741
社会渠道佣金 ：27_Cost_2770
渠道支撑 ：27_Cost_2897
销售费用-渠道及终端补贴★：27_Cash_0611

劳务租赁费	27_Cost_2734
平台坐席租赁运营费	27_Cost_2960
房屋、土地及场地租赁费	27_Cost_3019
电路及其他网元租赁费	27_Cost_3025
CDMA网络设施租赁费	27_Cost_3026
铁塔及相关资产租赁费	27_Cost_30270005
融资租赁	27_Cost_317701
车辆使用及租赁费	27_Cost_3095
办公设备租赁	27_Cost_3100








select * from budget_inst_app;

select * from budget_inst_app_detail


select * from budget_cost_back_certificate



select 
'年度',
sum(gg_fee) 广告,
sum(kf_fee)客服,
sum(yw_fee) 业务招待,
sum(dz_fee) 低值, 
sum(yp_fee) 用品,
sum(zc_fee) 业务支撑,
sum(zl_fee) 租赁
 from xxhb_mjh.tmp_majh_dz_fee t where t.type_two='01'
 union 
 select 
'201808',
sum(gg_fee),
sum(kf_fee),
sum(yw_fee),
sum(dz_fee),
sum(yp_fee),
sum(zc_fee),
sum(zl_fee)
 from xxhb_mjh.tmp_majh_dz_fee t where t.type_two='02'
 union 
 select 
'201807',
sum(gg_fee),
sum(kf_fee),
sum(yw_fee),
sum(dz_fee),
sum(yp_fee),
sum(zc_fee),
sum(zl_fee)
 from xxhb_mjh.tmp_majh_dz_fee t where t.type_two='03'
 union 
 select 
'201806',
sum(gg_fee),
sum(kf_fee),
sum(yw_fee),
sum(dz_fee),
sum(yp_fee),
sum(zc_fee),
sum(zl_fee)
 from xxhb_mjh.tmp_majh_dz_fee t where t.type_two='04'



