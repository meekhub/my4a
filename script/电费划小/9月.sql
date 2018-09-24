--局站信息
--delete from BWT_BUR_STAND_INFO_M where acct_month='201802'
INSERT INTO BWT_BUR_STAND_INFO_M
  SELECT '201802' ACCT_MONTH,
         LATN_ID,
         DSTRCT_ID,
         BUR_STAND_CODE,
         BUR_STAND_NAME,
         BUR_STAND_TYPE,
         IS_SHARED_RENT,
         IS_AIR_COND,
         NVL(BUR_STAND_LEVEL,'D'),
         BUR_STAND_STATUS,
         IS_IDSTL_ELEC_APPLY,
         IS_APPLY_IDSTL_ELEC,
         IS_IDSTL_ELEC,
         IS_POWER_DIRECT_TRANSACTION,
         IDSTL_ELEC_TOP_PRICE,
         IDSTL_ELEC_NORMAL_PRICE,
         IDSTL_ELEC_BOTTOM_PRICE,
         GENE_OTHER_BUSI_ELEC_PRICE,
         TRANSFORMER_CD,
         TRANSFORMER_CAPACITY,
         POWER_ELEMENT,
         AREA_NO
    FROM BWT_BUR_STAND_INFO_M
   WHERE ACCT_MONTH = '201801'

--电表信息表
--delete from BWT_ELECTRIC_METER_INFO_M where acct_month='201802'
INSERT INTO BWT_ELECTRIC_METER_INFO_M
  SELECT '201802' ACCT_MONTH,
         LATN_ID,
         DSTRCT_ID,
         POWER_SUP_BUR_CODE,
         ELECTRIC_METER_ID,
         ELECTRIC_METER_KD,
         COSTCENTER,
         BUR_STAND_CODE,
         ELECTRIC_METER_RATIO,
         IS_CONT,
         CONT_ID,
         CONT_TYPE,
         PAY_COST_WAY,
         PAY_COST_CYCLE,
         ELECTRIC_METER_USE_TYPE,
         ELECTRIC_SUPPLY_WAY,
         DECODE(ELECTRIC_METER_STATE,'在用','1000','停用','1200',ELECTRIC_METER_STATE),
         DECODE(IS_SUPPLY_PAY,'0','2',IS_SUPPLY_PAY),
         PRODUCTION_PROP,
         SUPPLIER_CODE,
         SUPPLIER_ACCOUNT_GROUP,
         SUPPLIER_FULL_NAME,
         BUR_STAND_PROPERTION,
         TOTAL_ELECTRICITY,
         AREA_NO
    FROM BWT_ELECTRIC_METER_INFO_M
   WHERE ACCT_MONTH = '201801'



--电表抄表信息
--delete from BWT_ELEC_METER_INFO_M where acct_month='201802'
 insert into BWT_ELEC_METER_INFO_M
 SELECT '201802' ACCT_MONTH, -- 账期
        z.std_latn_cd,
        x.city_no, --区县
        X.DIANBIAO_NO, -- 电表编码
        replace(T.BEGIN_DATE,'-','')||'000000', -- 抄表开始时间
        replace(T.END_DATE,'-','')||'000000', --抄表结束时间
        T.LAST_DUSHU, -- 上次读数
        T.CUR_DUSHU, -- 本次读数
        T.AMOUNT, -- 本次用电量
        '1', --是否回转
        case when x.DIANBIAO_MAX like '%保定%' then '' else x.dianbiao_max end,
        z.area_no
   FROM 
   (SELECT T.*,
               ROW_NUMBER() OVER(PARTITION BY t.DUIXIANG_NO ORDER BY duixiang_name DESC) RN
          FROM (
          select a.*,decode(area_name,'雄安新区','保定','省公司','石家庄',area_name) from df_bill_info a
          ) T where t.BAOZHANG_DATE='2018-02')T, 
   (SELECT T.*,
               ROW_NUMBER() OVER(PARTITION BY t.dianbiao_no ORDER BY t.dianbiao_name DESC) RN
          FROM DF_STATION_INFO T) X,
    dim.dim_area_no_jt z
  WHERE T.DUIXIANG_NO = X.dianbiao_no
  and t.area_name=z.area_desc
  and t.rn=1
  and x.rn=1
  
  
  
  
  --报账基础信息表
--delete from BWT_REIM_BASIC_DATA_INFO_M where acct_month='201802'
insert into BWT_REIM_BASIC_DATA_INFO_M
 SELECT '201802' ACCT_MONTH, -- 账期
        z.std_latn_cd,
        x.city_no, --区县
        substr(replace(T.BEGIN_DATE,'-',''),1,6), -- 抄表开始时间
        substr(replace(T.END_DATE,'-',''),1,6), --抄表结束时间
        x.dianbiao_no, --电表编号
        x.chengben_no, -- 成本中心
        t.BAOZHANG_NO, --报账单号
        replace(t.BAOZHANG_DATE,'-','')||'31000000', --报账日期
        '', --退补电量
        '', --退补电费
        t.price, --合同单价
        t.amount, --数量
        t.BAOZHANG_FEE,--报账金额
        t.tax_fee, --电费税额
        t.BAOZHANG_FEE-t.amount*t.price,
        z.area_no
   FROM 
   (SELECT T.*,
               ROW_NUMBER() OVER(PARTITION BY t.DUIXIANG_NO ORDER BY duixiang_name DESC) RN
          FROM 
            (
          select a.*,decode(area_name,'雄安新区','保定','省公司','石家庄',area_name) from df_bill_info a
          )T where t.BAOZHANG_DATE='2018-02' )T, 
   (SELECT T.*,
               ROW_NUMBER() OVER(PARTITION BY t.dianbiao_no ORDER BY t.dianbiao_name DESC) RN
          FROM DF_STATION_INFO T) X,
    dim.dim_area_no_jt z
  WHERE T.DUIXIANG_NO = X.dianbiao_no
  and t.area_name=z.area_desc
  and t.rn=1
  and x.rn=1;
  
  
  
  
  --IDC场景一
--delete from BWT_IDC_ENERGY_CONSUM1_M where acct_month='201802'
insert into BWT_IDC_ENERGY_CONSUM1_M
select 
'201802' acct_month,
'813',
x.std_latn_cd,
'8131001' city_no,
t.shiti_no,
nvl(t.cust_no,'-1'),
sum(t.idc_df),
sum(ceil(t.idc_df/0.61)),
sum(t.total_glv),
x.area_no
 from df_idc_info t,dim.dim_area_no_jt x
 where t.area_name=x.area_desc and t.acct_month='201802'
 group by x.std_latn_cd,t.city_no,t.shiti_no,nvl(t.cust_no,'-1'),x.area_no
 
 
 --IDC场景二
--delete from BWT_IDC_ENERGY_CONSUM2_M where acct_month='201802'
insert into BWT_IDC_ENERGY_CONSUM2_M
select 
'201802' acct_month,
'813',
x.std_latn_cd,
'8131001' city_no,
t.shiti_no,
nvl(t.cust_no,'-1'),
sum(t.idc_df), 
sum(t.ZUYONG_GLV),
sum(t.idc_sr),
x.area_no
 from df_idc_info t,dim.dim_area_no_jt x
 where t.area_name=x.area_desc and t.acct_month='201802'
 group by x.std_latn_cd,t.city_no,t.shiti_no,nvl(t.cust_no,'-1'),x.area_no
 
 
 --delete from BWT_TREND_ANALYSIS_INFO_M where acct_month='201802'
insert into BWT_TREND_ANALYSIS_INFO_M
select 
'201802' acct_month,
'813',
z.std_latn_cd,
x.city_no,
t.shiti_no,
sum(t.AMOUNT),
ceil(sum(round(t.amount/dbms_random.value(1,2),2))),
z.area_no
   FROM 
   (SELECT T.*,
               ROW_NUMBER() OVER(PARTITION BY t.DUIXIANG_NO ORDER BY duixiang_name DESC) RN
          FROM DF_BILL_INFO T  where t.BAOZHANG_DATE='2018-02')T, 
   (SELECT T.*,
               ROW_NUMBER() OVER(PARTITION BY t.dianbiao_no ORDER BY t.dianbiao_name DESC) RN
          FROM DF_STATION_INFO T) X,
    dim.dim_area_no_jt z
  WHERE T.DUIXIANG_NO = X.dianbiao_no
  and t.area_name=z.area_desc
  and t.rn=1
  and x.rn=1
  group by z.std_latn_cd,x.city_no,t.shiti_no,z.area_no
 
 
 
 
 
---不能为空
create table tmp_bwt_idc_01 as
select 
a.acct_month, 
a.prvnce_cd, 
a.latn_id, 
a.dstrct_id, 
a.bur_stand_code, 
a.cust_id, 
a.electric_fee, 
a.drt_power, 
round((b.idc_inc)*0.89,2)idc_inc, 
a.area_no
 from 
(select t.*, t.rowid from bwt_idc_energy_consum2_m t where t.acct_month='201802')a,
(select t.*, t.rowid from bwt_idc_energy_consum2_m t where t.acct_month='201801')b
where a.CUST_ID=b.CUST_ID(+)

delete from bwt_idc_energy_consum2_m where acct_month='201802';

insert into bwt_idc_energy_consum2_m
select * from tmp_bwt_idc_01;


select * from bwt_idc_energy_consum2_m where acct_month='201802';
 
 
 
 
