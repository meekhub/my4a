--局站等级
select BUR_STAND_LEVEL,count(*) from BWT_BUR_STAND_INFO_M where acct_month='201802'
group by BUR_STAND_LEVEL

--电表状态
select ELECTRIC_METER_STATE,count(*) from BWT_ELECTRIC_METER_INFO_M where acct_month='201802'
group by ELECTRIC_METER_STATE

--是否现金支付（改为付款方式）
select IS_SUPPLY_PAY,count(*) from BWT_ELECTRIC_METER_INFO_M where acct_month='201802'
group by IS_SUPPLY_PAY

--电表抄表信息  回转
select TURN,COUNT(*) from BWT_ELEC_METER_INFO_M where acct_month='201802'
group by TURN


--抄表开始时间
select * from  BWT_REIM_BASIC_DATA_INFO_M where acct_month='201801'

--报账基本表
select distinct ELEC_FEE_MONTH_START from BWT_REIM_BASIC_DATA_INFO_M where acct_month='201801' 

--报账基本表
select distinct ACCOUNT_DATE from BWT_REIM_BASIC_DATA_INFO_M where acct_month='201801' 
