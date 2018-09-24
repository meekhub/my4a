--局站信息表
select 
acct_month                   帐期,                   
latn_id                      地市编码,               
bur_stand_code               局站编码,               
bur_stand_name               局站名称,               
bur_stand_type               局站类型,               
is_shared_rent               局站产权类型,           
is_air_cond                  是否有空调,             
bur_stand_level              局站等级,               
bur_stand_status             局站状态,               
is_idstl_elec_apply          是否满足大工业用电申请, 
is_apply_idstl_elec          是否申请大工业用电,     
is_idstl_elec                是否是大工业用电,       
is_power_direct_transaction  是否电力直接交易,       
idstl_elec_top_price         大工业高峰电价,         
idstl_elec_normal_price      大工业平段电价,         
idstl_elec_bottom_price      大工业低谷电价,         
gene_other_busi_elec_price   一般工商及其他电价,     
transformer_cd               变压器编号,             
transformer_capacity         变压器容量,             
power_element                功率因素
 from BWT_BUR_STAND_INFO_M a where a.acct_month='201804'
 

--电表信息
select 
acct_month              帐期,                         
latn_id                 地市编码,                     
power_sup_bur_code      供电局编码,                   
electric_meter_id       电表编号,                     
electric_meter_kd       电表类型,                     
costcenter              成本中心,                     
bur_stand_code          局站编码,                     
electric_meter_ratio    电表倍率,                     
is_cont                 是否有合同,                   
cont_id                 合同号,                       
cont_type               合同类型,                     
pay_cost_way            缴费方式,                     
pay_cost_cycle          缴费周期,                     
electric_meter_use_type 电表用途类型,           
electric_supply_way     供电方式,                     
electric_meter_state    电表状态,                     
is_supply_pay           是否现金支付, 
production_prop         生产占比,                  
supplier_code           供应商编码,                   
supplier_account_group  供应商账户组,                 
supplier_full_name      供应商名称,                   
bur_stand_propertion    占局站比例,                   
total_electricity       核定电量,                     
area_no                 
from BWT_ELECTRIC_METER_INFO_M a where a.acct_month='201804'

 
--报账信息
select 
acct_month             帐期,                       
latn_id                地市编码,         
elec_fee_month_start   电费发生起始月,   
elec_fee_month_end     电费发生结束月,   
electric_meter_id      电表编号,         
costcenter             成本中心,         
bill_des_code          报账基础信息编号, 
account_date           报账日期,         
recharge_capacity      退补电量,         
recharge_elec_charge   退补电费,         
contract_elec_price    合同电价,     
total_electricity      总电量,       
elec_charge_price      电费价,           
elec_charge_tax        电费税,           
eles_charge            其他费用,         
area_no                  
 from BWT_REIM_BASIC_DATA_INFO_M a where acct_month='201804'


--PUE分析
select 
acct_month                  帐期,       
prvnce_cd                   省份编码,   
latn_id                     本地网编码, 
bur_stand_code              局站编码,   
total_power_consump         总耗电量,   
total_equip_power_consump   总设备耗电量,
area_no
 from BWT_TREND_ANALYSIS_INFO_M where acct_month='201804'



 
