select acct_month,count(*) from BWT_BUR_STAND_INFO_M where acct_month>='201808' group by acct_month;
select acct_month,count(*) from BWT_ELECTRIC_METER_INFO_M where acct_month>='201808' group by acct_month; 
select acct_month,count(*) from BWT_REIM_BASIC_DATA_INFO_M where acct_month>='201808' group by acct_month; 
select acct_month,count(*) from BWT_TREND_ANALYSIS_INFO_M where acct_month>='201808' group by acct_month;


------------------
--标识是否现金支付1：是2：否
 update bwt_electric_meter_info_m set is_supply_pay='2' where is_supply_pay='0'
 --电表状态
 1000在用1200停用1100关闭
 --PUE分析总电量大于0

------------------

--局站信息表
3.1.15.1局站信息（月）局站等级|BUR_STAND_LEVEL字段解释修改：
局站类型in（10001、10002、10003、10004、10005）时必填：A，B，C，D；局站类型 in（20001、20002、-1、-2）填-1。主数据参见4.194


--合规性
select *
  from bwt_bur_stand_info_m t
 where t.acct_month = '201808'
   and (BUR_STAND_CODE is null or BUR_STAND_NAME is null or
       BUR_STAND_TYPE is null or IS_SHARED_RENT is null or
       IS_AIR_COND is null or BUR_STAND_LEVEL is null OR BUR_STAND_STATUS IS NULL OR
       IS_IDSTL_ELEC_APPLY IS NULL OR IS_APPLY_IDSTL_ELEC IS NULL OR IS_IDSTL_ELEC IS NULL OR
       IS_POWER_DIRECT_TRANSACTION IS NULL OR IDSTL_ELEC_TOP_PRICE IS NULL OR
       IDSTL_ELEC_NORMAL_PRICE IS NULL OR IDSTL_ELEC_BOTTOM_PRICE IS NULL OR
       GENE_OTHER_BUSI_ELEC_PRICE IS NULL OR TRANSFORMER_CD IS NULL OR
       TRANSFORMER_CAPACITY IS NULL OR POWER_ELEMENT IS NULL)
--主键
select COUNT(*)
  from bwt_bur_stand_info_m t
 where t.acct_month = '201808'
 group by LATN_ID,BUR_STAND_CODE
 HAVING COUNT(*)>1 
     
--省份、本地网字段必须在规范要求的地域维表内
select count(*),a.latn_id from bwt_bur_stand_info_m a where acct_month='201808' group by a.latn_id
--局站状态in（1、 0）  1：在用  0：停用，不能超出枚举值
select count(*),BUR_STAND_STATUS from bwt_bur_stand_info_m a where acct_month='201808' group by BUR_STAND_STATUS
--局站等级 in（A、B、C、D），不能超出枚举值
select count(*),BUR_STAND_LEVEL from bwt_bur_stand_info_m a where acct_month='201808' group by BUR_STAND_LEVEL
--局站类型in（10001、10002、10003、10004、10005）时必填：A，B，C，D；局站类型 in（20001、20002、-1、-2）填-1
select count(*),BUR_STAND_LEVEL from bwt_bur_stand_info_m a where acct_month='201808' and BUR_STAND_TYPE in
(10001,10002,10003,10004,10005)  group by BUR_STAND_LEVEL

--局站类型in（10001、10002、10003、10004、10005、20001、20002、-1、-2）
select count(*),BUR_STAND_TYPE from bwt_bur_stand_info_m a where acct_month='201808' group by BUR_STAND_TYPE

select * from bwt_bur_stand_info_m a where acct_month='201808' and BUR_STAND_TYPE not in
（10001,10002,10003,10004,10005,20001,20002,-1,-2）


--电表信息
如果有合同的话，合同号必须有值
--分地市
select LATN_ID,count(*) from BWT_ELECTRIC_METER_INFO_M where acct_month='201808' group by LATN_ID; 

--合规性
select *
  from BWT_ELECTRIC_METER_INFO_M
 where acct_month = '201808'
 and (LATN_ID is null or POWER_SUP_BUR_CODE is null or
ELECTRIC_METER_ID is null or ELECTRIC_METER_KD is null or
BUR_STAND_CODE is null or ELECTRIC_METER_RATIO is null or IS_CONT is null or 
PAY_COST_WAY is null or PAY_COST_CYCLE is null or ELECTRIC_METER_USE_TYPE is null
or ELECTRIC_SUPPLY_WAY is null or ELECTRIC_METER_STATE is null or 
IS_SUPPLY_PAY is null or PRODUCTION_PROP is null or BUR_STAND_PROPERTION is null or 
TOTAL_ELECTRICITY is null)

select * from BWT_ELECTRIC_METER_INFO_M a where a.acct_month='201808' and length(a.bur_stand_propertion)>8 

--主键
select count(*) from BWT_ELECTRIC_METER_INFO_M where acct_month='201808'
group by LATN_ID,ELECTRIC_METER_ID
having count(*)>1

--电表类型 in （1 、2）  1：实电表  2：虚电表 ，不能超出枚举值
select count(*),ELECTRIC_METER_KD from BWT_ELECTRIC_METER_INFO_M where acct_month='201808' group by ELECTRIC_METER_KD



--报账信息
--合规性
select * from BWT_REIM_BASIC_DATA_INFO_M where acct_month='201808' 
and (LATN_ID is null or ELECTRIC_METER_ID is null or COSTCENTER is null or 
BILL_DES_CODE is null or ACCOUNT_DATE is null or RECHARGE_CAPACITY is null or 
RECHARGE_ELEC_CHARGE is null or CONTRACT_ELEC_PRICE is null or TOTAL_ELECTRICITY is null or 
ELEC_CHARGE_PRICE is null or ELEC_CHARGE_TAX is null )
--主键
select count(*) from BWT_REIM_BASIC_DATA_INFO_M where acct_month='201808' 
group by LATN_ID,ELECTRIC_METER_ID,BILL_DES_CODE
having count(*)>1

--电费（元），大于0
select * from BWT_REIM_BASIC_DATA_INFO_M where acct_month='201808' and (ELEC_CHARGE_PRICE is null or ELEC_CHARGE_PRICE<=0)
--电费税（元），大于等于0
select * from BWT_REIM_BASIC_DATA_INFO_M where acct_month='201808' and (ELEC_CHARGE_TAX is null or ELEC_CHARGE_TAX<0)
--电表信息（月）表中电表对应的局站编码，要在局站信息（月）表中存在
SELECT *
  FROM (SELECT * FROM BWT_ELECTRIC_METER_INFO_M WHERE ACCT_MONTH = '201808') A,
       (SELECT * FROM BWT_BUR_STAND_INFO_M WHERE ACCT_MONTH = '201808') B
 WHERE A.BUR_STAND_CODE = B.BUR_STAND_CODE(+)
 and B.BUR_STAND_CODE is null
--报账表中的成本中心，要在电表中成本中心的集合中存在
select a.* from 
(select * from BWT_REIM_BASIC_DATA_INFO_M where acct_month='201808')a,
(select * from BWT_ELECTRIC_METER_INFO_M where acct_month='201808')b
where a.COSTCENTER=b.COSTCENTER(+)
and b.COSTCENTER is  null

--报账表中的成本中心，要在电表中成本中心的集合中存在
select a.* from 
(select * from BWT_REIM_BASIC_DATA_INFO_M where acct_month='201808')a,
(select * from BWT_ELECTRIC_METER_INFO_M where acct_month='201808')b
where a.COSTCENTER=b.COSTCENTER(+) 
and b.COSTCENTER is null

--报账表（月）中的电表编码必须在电表基本信息表的电表编码中存在
select a.* from 
(select * from BWT_REIM_BASIC_DATA_INFO_M where acct_month='201808')a,
(select * from BWT_ELECTRIC_METER_INFO_M where acct_month='201808')b
where a.ELECTRIC_METER_ID=b.ELECTRIC_METER_ID(+)
and b.ELECTRIC_METER_ID is null

--（A+B类局站数）/总局站数<=50%
select count(case
               when BUR_STAND_LEVEL in ('A', 'B') then
                BUR_STAND_CODE
             end) / count(case
               when BUR_STAND_TYPE in (10001,10002,10003,10004,10005) then
                BUR_STAND_CODE
             end)
  from bwt_bur_stand_info_m a
 where acct_month = '201808'
 

--PUE分析
--合规性
select * from BWT_TREND_ANALYSIS_INFO_M where acct_month='201808' 
and (LATN_ID is null or BUR_STAND_CODE is null or TOTAL_POWER_CONSUMP is null or
TOTAL_EQUIP_POWER_CONSUMP is null
)

--主键
select 
acct_month, 
prvnce_cd, 
latn_id,  
bur_stand_code
 from BWT_TREND_ANALYSIS_INFO_M where acct_month='201808'
group by 
acct_month, 
prvnce_cd, 
latn_id,  
bur_stand_code
having count(*)>1;



--PUE趋势分析信息（月）表中的局站编码，要在局站信息（月）表中存在
delete from BWT_TREND_ANALYSIS_INFO_M where acct_month='201808'
and bur_stand_code in 
(select a.bur_stand_code from 
(select * from BWT_TREND_ANALYSIS_INFO_M where acct_month='201808')a,
(select * from bwt_bur_stand_info_m where acct_month='201808')b
where a.BUR_STAND_CODE=b.BUR_STAND_CODE(+)
and b.BUR_STAND_CODE is null)



--业务稽核
--1<=PUE值<=3
select count(*),
count(case when TOTAL_POWER_CONSUMP/TOTAL_EQUIP_POWER_CONSUMP<1 then BUR_STAND_CODE end),
count(case when TOTAL_POWER_CONSUMP/TOTAL_EQUIP_POWER_CONSUMP>3 then BUR_STAND_CODE end)
 from  BWT_TREND_ANALYSIS_INFO_M where acct_month='201808'  and TOTAL_EQUIP_POWER_CONSUMP>0

select * from BWT_TREND_ANALYSIS_INFO_M where TOTAL_POWER_CONSUMP/TOTAL_EQUIP_POWER_CONSUMP>3

--0.3<=合同电价<=2  
select count(*),
count(case when CONTRACT_ELEC_PRICE>2 then ELECTRIC_METER_ID end ),
count(case when CONTRACT_ELEC_PRICE<0.3 then ELECTRIC_METER_ID end )
 from BWT_REIM_BASIC_DATA_INFO_M where acct_month='201808'


update BWT_REIM_BASIC_DATA_INFO_M set CONTRACT_ELEC_PRICE=1.0 where CONTRACT_ELEC_PRICE>2


--0.3<=单表平均电价<=2
select count(*) from 
(select ELECTRIC_METER_ID,ELEC_CHARGE_PRICE/TOTAL_ELECTRICITY as price
 from BWT_REIM_BASIC_DATA_INFO_M where acct_month='201808')
 where price<0.3 or price>2


update BWT_REIM_BASIC_DATA_INFO_M  set TOTAL_ELECTRICITY=ceil(ELEC_CHARGE_PRICE) where ELEC_CHARGE_PRICE/TOTAL_ELECTRICITY<0.3 or 
ELEC_CHARGE_PRICE/TOTAL_ELECTRICITY>2 

 
--总电量(度)，大于0，并且与集团MSS系统中的总电量相等
select 
sum(TOTAL_ELECTRICITY)
 from BWT_REIM_BASIC_DATA_INFO_M where acct_month='201808'

--电费价+其他费用，要与集团MSS系统的总电费相等
select 
sum(ELEC_CHARGE_PRICE+ELES_CHARGE)
 from BWT_REIM_BASIC_DATA_INFO_M where acct_month='201808'
 
--电费占付现成本<=40%
集团出结果

--能耗占收比<=40%
集团出结果

--单表电费、电量不能超过历史同期50%
SELECT *
  FROM (SELECT A.ELECTRIC_METER_ID,
               (A.TOTAL_ELECTRICITY - B.TOTAL_ELECTRICITY) /
               B.TOTAL_ELECTRICITY AS ELECTRICIT_RATE,
               (A.ELEC_CHARGE_PRICE - B.ELEC_CHARGE_PRICE) /
               B.ELEC_CHARGE_PRICE AS CHARGE_RATE
          FROM (SELECT ELECTRIC_METER_ID,
                       TOTAL_ELECTRICITY,
                       ELEC_CHARGE_PRICE
                  FROM BWT_REIM_BASIC_DATA_INFO_M
                 WHERE ACCT_MONTH = '201808') A,
               (SELECT ELECTRIC_METER_ID,
                       TOTAL_ELECTRICITY,
                       ELEC_CHARGE_PRICE
                  FROM BWT_REIM_BASIC_DATA_INFO_M
                 WHERE ACCT_MONTH = '201805') B
         WHERE A.ELECTRIC_METER_ID = B.ELECTRIC_METER_ID)
 WHERE ABS(ELECTRICIT_RATE) > 0.5
    OR ABS(CHARGE_RATE) > 0.5

