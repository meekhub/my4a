

select acct_month,count(*) from BWT_BUR_STAND_INFO_M where acct_month>='201803' group by acct_month;
select acct_month,count(*) from BWT_ELECTRIC_METER_INFO_M where acct_month>='201803' group by acct_month;
select acct_month,count(*) from BWT_ELEC_METER_INFO_M where acct_month>='201803' group by acct_month;
select acct_month,count(*) from BWT_REIM_BASIC_DATA_INFO_M where acct_month>='201803' group by acct_month;
select acct_month,count(*) from BWT_IDC_ENERGY_CONSUM1_M where acct_month>='201803' group by acct_month;
select acct_month,count(*) from BWT_IDC_ENERGY_CONSUM2_M where acct_month>='201803' group by acct_month;
select acct_month,count(*) from BWT_TREND_ANALYSIS_INFO_M where acct_month>='201803' group by acct_month;



--��վ��Ϣ��

select count(*),count(distinct a.bur_stand_code) from bwt_bur_stand_info_m a where acct_month='201803'

select *
  from bwt_bur_stand_info_m t
 where t.acct_month = '201803'
   and (BUR_STAND_CODE is null or BUR_STAND_NAME is null or
       BUR_STAND_TYPE is null or IS_SHARED_RENT is null or
       IS_AIR_COND is null)

select BUR_STAND_TYPE,count(*) from bwt_bur_stand_info_m where acct_month='201803'
group by BUR_STAND_TYPE

--�����Ϣ
select count(*),count(distinct ELECTRIC_METER_ID) from BWT_ELECTRIC_METER_INFO_M where acct_month='201803'

select *
  from BWT_ELECTRIC_METER_INFO_M
 where acct_month = '201803'
 and (LATN_ID is null or POWER_SUP_BUR_CODE is null or
ELECTRIC_METER_ID is null or ELECTRIC_METER_KD is null or
BUR_STAND_CODE is null or ELECTRIC_METER_RATIO is null or
PAY_COST_WAY is null or PAY_COST_CYCLE is null or ELECTRIC_METER_USE_TYPE is null
or ELECTRIC_SUPPLY_WAY is null or IS_SUPPLY_PAY is null or PRODUCTION_PROP is null or 
TOTAL_ELECTRICITY is null )

--�����
select count(*),count(distinct ELECTRIC_METER_ID) from BWT_ELEC_METER_INFO_M where acct_month='201803'

select * from BWT_ELEC_METER_INFO_M where acct_month='201803'
and (LATN_ID is null or ELECTRIC_METER_ID is null or PRESENT_POWER_FLUX is null or PRESENT_POWER_FLUX<=0 )



--������Ϣ
select LATN_ID,DSTRCT_ID,ELECTRIC_METER_ID,BILL_DES_CODE from BWT_REIM_BASIC_DATA_INFO_M where acct_month='201803' group by LATN_ID,DSTRCT_ID,ELECTRIC_METER_ID,BILL_DES_CODE
having count(*)>1

SELECT LATN_ID, DSTRCT_ID, ELECTRIC_METER_ID, BILL_DES_CODE
  FROM BWT_REIM_BASIC_DATA_INFO_M
 WHERE ACCT_MONTH = '201803'
   AND  (TOTAL_ELECTRICITY IS NULL
    OR TOTAL_ELECTRICITY <= 0 or DSTRCT_ID is null or ELEC_CHARGE_PRICE is null or ELEC_CHARGE_PRICE <=0)

select ELEC_CHARGE_TAX from BWT_REIM_BASIC_DATA_INFO_M where acct_month='201803' and ELEC_CHARGE_TAX<0

--IDCͶ������ȳ���һ
select 
acct_month, 
prvnce_cd, 
latn_id, 
dstrct_id, 
bur_stand_code, 
cust_id
 from BWT_IDC_ENERGY_CONSUM1_M where acct_month='201803'
group by 
acct_month, 
prvnce_cd, 
latn_id, 
dstrct_id, 
bur_stand_code, 
cust_id
having count(*)>1


select *
  from BWT_IDC_ENERGY_CONSUM1_M
 where acct_month = '201803'
   and (ELECTRIC_FEE is null or ELECTRIC_FEE <= 0 or ELECTRIC_FLUX is null or
       ELECTRIC_FLUX <= 0 or DSTRCT_ID is null)
       
UPDATE BWT_IDC_ENERGY_CONSUM1_M SET DSTRCT_ID='B131000000' where  DSTRCT_ID is null


--IDCͶ������ȳ�����
select 
acct_month, 
prvnce_cd, 
latn_id, 
dstrct_id, 
bur_stand_code, 
cust_id
 from BWT_IDC_ENERGY_CONSUM2_M where acct_month='201803'
group by 
acct_month, 
prvnce_cd, 
latn_id, 
dstrct_id, 
bur_stand_code, 
cust_id
having count(*)>1


select *
  from BWT_IDC_ENERGY_CONSUM2_M
 where acct_month = '201803'
   and (ELECTRIC_FEE is null or ELECTRIC_FEE <= 0 or DSTRCT_ID is null)

--PUE����
select 
acct_month, 
prvnce_cd, 
latn_id, 
dstrct_id, 
bur_stand_code
 from BWT_TREND_ANALYSIS_INFO_M where acct_month='201803'
group by 
acct_month, 
prvnce_cd, 
latn_id, 
dstrct_id, 
bur_stand_code
having count(*)>1


select * from BWT_TREND_ANALYSIS_INFO_M where acct_month='201803' and (TOTAL_POWER_CONSUMP is null or TOTAL_POWER_CONSUMP<=0 or 
TOTAL_EQUIP_POWER_CONSUMP <=0)



--һ����
--�����Ϣ���£����е���Ӧ�ľ�վ���룬Ҫ�ھ�վ��Ϣ���£����д���
SELECT *
  FROM (SELECT * FROM BWT_ELECTRIC_METER_INFO_M WHERE ACCT_MONTH = '201803') A,
       (SELECT * FROM BWT_BUR_STAND_INFO_M WHERE ACCT_MONTH = '201803') B
 WHERE A.BUR_STAND_CODE = B.BUR_STAND_CODE(+)
 and B.BUR_STAND_CODE is null


--���˱��еĳɱ����ģ�Ҫ�ڵ���гɱ����ĵļ����д���
select a.* from 
(select * from BWT_REIM_BASIC_DATA_INFO_M where acct_month='201803')a,
(select * from BWT_ELECTRIC_METER_INFO_M where acct_month='201803')b
where a.COSTCENTER=b.COSTCENTER(+)
and b.COSTCENTER is  null

--������£������˱��£��еĵ���������ڵ�������Ϣ��ĵ������д���
select a.* from 
(select * from BWT_ELEC_METER_INFO_M where acct_month='201803')a,
(select * from BWT_ELECTRIC_METER_INFO_M where acct_month='201803')b
where a.ELECTRIC_METER_ID=b.ELECTRIC_METER_ID(+)
and b.ELECTRIC_METER_ID is  null


select a.* from 
(select * from BWT_REIM_BASIC_DATA_INFO_M where acct_month='201803')a,
(select * from BWT_ELECTRIC_METER_INFO_M where acct_month='201803')b
where a.ELECTRIC_METER_ID=b.ELECTRIC_METER_ID(+)
and b.ELECTRIC_METER_ID is null



--PUE���Ʒ�����Ϣ���£����еľ�վ���룬Ҫ�ھ�վ��Ϣ���£����д���
delete from BWT_TREND_ANALYSIS_INFO_M where acct_month='201803'
and bur_stand_code in 
(select a.bur_stand_code from 
(select * from BWT_TREND_ANALYSIS_INFO_M where acct_month='201803')a,
(select * from bwt_bur_stand_info_m where acct_month='201803')b
where a.BUR_STAND_CODE=b.BUR_STAND_CODE(+)
and b.BUR_STAND_CODE is null)



--IDC�����ܺ�Ͷ����� ����һ����������ľ�վ���룬��վ���С���վ���͡�=�������÷����������ġ�����IDC����������ļ����д��ڡ�
select a.* from 
(select * from BWT_IDC_ENERGY_CONSUM1_M where acct_month='201803')a,
(select * from bwt_bur_stand_info_m where acct_month='201803')b
where a.BUR_STAND_CODE=b.BUR_STAND_CODE(+)
and b.BUR_STAND_CODE is null


--����Ϊ10003
select distinct b.bur_stand_type from 
(select * from BWT_IDC_ENERGY_CONSUM1_M where acct_month='201803')a,
(select * from bwt_bur_stand_info_m where acct_month='201803')b
where a.BUR_STAND_CODE=b.BUR_STAND_CODE 

select a.* from 
(select * from BWT_IDC_ENERGY_CONSUM2_M where acct_month='201803')a,
(select * from bwt_bur_stand_info_m where acct_month='201803')b
where a.BUR_STAND_CODE=b.BUR_STAND_CODE(+)
and b.BUR_STAND_CODE is null


--����Ϊ10003
select distinct b.bur_stand_type from 
(select * from BWT_IDC_ENERGY_CONSUM2_M where acct_month='201803')a,
(select * from bwt_bur_stand_info_m where acct_month='201803')b
where a.BUR_STAND_CODE=b.BUR_STAND_CODE 


