--��վ��Ϣ��
select 
acct_month                   ����,                   
latn_id                      ���б���,               
bur_stand_code               ��վ����,               
bur_stand_name               ��վ����,               
bur_stand_type               ��վ����,               
is_shared_rent               ��վ��Ȩ����,           
is_air_cond                  �Ƿ��пյ�,             
bur_stand_level              ��վ�ȼ�,               
bur_stand_status             ��վ״̬,               
is_idstl_elec_apply          �Ƿ������ҵ�õ�����, 
is_apply_idstl_elec          �Ƿ������ҵ�õ�,     
is_idstl_elec                �Ƿ��Ǵ�ҵ�õ�,       
is_power_direct_transaction  �Ƿ����ֱ�ӽ���,       
idstl_elec_top_price         ��ҵ�߷���,         
idstl_elec_normal_price      ��ҵƽ�ε��,         
idstl_elec_bottom_price      ��ҵ�͹ȵ��,         
gene_other_busi_elec_price   һ�㹤�̼��������,     
transformer_cd               ��ѹ�����,             
transformer_capacity         ��ѹ������,             
power_element                ��������
 from BWT_BUR_STAND_INFO_M a where a.acct_month='201804'
 

--�����Ϣ
select 
acct_month              ����,                         
latn_id                 ���б���,                     
power_sup_bur_code      ����ֱ���,                   
electric_meter_id       �����,                     
electric_meter_kd       �������,                     
costcenter              �ɱ�����,                     
bur_stand_code          ��վ����,                     
electric_meter_ratio    �����,                     
is_cont                 �Ƿ��к�ͬ,                   
cont_id                 ��ͬ��,                       
cont_type               ��ͬ����,                     
pay_cost_way            �ɷѷ�ʽ,                     
pay_cost_cycle          �ɷ�����,                     
electric_meter_use_type �����;����,           
electric_supply_way     ���緽ʽ,                     
electric_meter_state    ���״̬,                     
is_supply_pay           �Ƿ��ֽ�֧��, 
production_prop         ����ռ��,                  
supplier_code           ��Ӧ�̱���,                   
supplier_account_group  ��Ӧ���˻���,                 
supplier_full_name      ��Ӧ������,                   
bur_stand_propertion    ռ��վ����,                   
total_electricity       �˶�����,                     
area_no                 
from BWT_ELECTRIC_METER_INFO_M a where a.acct_month='201804'

 
--������Ϣ
select 
acct_month             ����,                       
latn_id                ���б���,         
elec_fee_month_start   ��ѷ�����ʼ��,   
elec_fee_month_end     ��ѷ���������,   
electric_meter_id      �����,         
costcenter             �ɱ�����,         
bill_des_code          ���˻�����Ϣ���, 
account_date           ��������,         
recharge_capacity      �˲�����,         
recharge_elec_charge   �˲����,         
contract_elec_price    ��ͬ���,     
total_electricity      �ܵ���,       
elec_charge_price      ��Ѽ�,           
elec_charge_tax        ���˰,           
eles_charge            ��������,         
area_no                  
 from BWT_REIM_BASIC_DATA_INFO_M a where acct_month='201804'


--PUE����
select 
acct_month                  ����,       
prvnce_cd                   ʡ�ݱ���,   
latn_id                     ����������, 
bur_stand_code              ��վ����,   
total_power_consump         �ܺĵ���,   
total_equip_power_consump   ���豸�ĵ���,
area_no
 from BWT_TREND_ANALYSIS_INFO_M where acct_month='201804'



 
