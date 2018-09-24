--局站信息
--delete from BWT_BUR_STAND_INFO_M where acct_month='201712'
INSERT into BWT_BUR_STAND_INFO_M
SELECT '201712' ACCT_MONTH, -- 账期
       x.std_latn_cd, 
       T.SHITI_NO, --局站编码
       nvl(T.SHITI_NAME,'其他'), --局站名称
       CASE
         WHEN T.SHITI_TYPE LIKE '%通信机房%' THEN
          '10001'
         WHEN T.SHITI_TYPE LIKE '%移动基站%' THEN
          '10002'
         WHEN T.SHITI_TYPE LIKE '%对外IDC机柜机房%' THEN
          '10003'
         WHEN T.SHITI_TYPE LIKE '%自用业务平台%' THEN
          '10004'
         WHEN T.SHITI_TYPE LIKE '%接入局所及室外机柜%' THEN
          '10005'
         WHEN T.SHITI_TYPE LIKE '%管理用房%' THEN
          '20001'
         WHEN T.SHITI_TYPE LIKE '%渠道用房%' THEN
          '20002'
         WHEN T.SHITI_TYPE LIKE '%生产用房-其他%' THEN
          '-1'
         ELSE
          '-2'
       END, --局站类型
       CASE
         WHEN T.SUOYOUQUAN = '自有' THEN
          '10'
         ELSE
          '20'
       END, --是否共享外租
       CASE
         WHEN T.IS_KONGTIAO = '是' THEN
          '1'
         ELSE
          '0'
       END, -- 是否有空调
       CASE
         WHEN T.SHITI_LEVEL LIKE 'A%' THEN
          'A'
         WHEN T.SHITI_LEVEL LIKE 'B%' THEN
          'B'
         WHEN T.SHITI_LEVEL LIKE 'C%' THEN
          'C'
         WHEN T.SHITI_LEVEL LIKE 'D%' THEN
          'D'
       END, --局站等级
       CASE
         WHEN T.SHITI_STATE = '在用' THEN
          '1'
         ELSE
          '0'
       END, --局站状态
      '' is_idstl_elec_apply,
      '' is_apply_idstl_elec,
      '' is_idstl_elec,
      '' is_power_direct_transaction,
      '' idstl_elec_top_price,
      '' idstl_elec_normal_price,
      '' idstl_elec_bottom_price,
      '' gene_other_busi_elec_price,
      '' transformer_cd,
      '' transformer_capacity,
      '' power_element,
       x.area_no
  FROM (SELECT T.*,
               ROW_NUMBER() OVER(PARTITION BY T.SHITI_NO ORDER BY T.SHITI_NAME DESC) RN
          FROM DF_STATION_INFO_new T) T, dim.dim_area_no_jt x
 WHERE RN = 1 and t.area_name=x.area_desc;



--电表信息
--delete from BWT_ELECTRIC_METER_INFO_M where acct_month='201712'
insert into BWT_ELECTRIC_METER_INFO_M
select 
'201712' ACCT_MONTH, -- 账期
       x.std_latn_cd,
       t.city_no, --区县
       nvl(t.dianbiao_huhao,'-1'), -- 供电局编码
       t.dianbiao_no, --电表编号
       '1' ELECTRIC_METER_KD, -- 电表类型
       t.chengben_no, -- 成本中心
       t.shiti_no, -- 局站编码
       nvl(t.beilv,'1'), -- 电表倍率
       case when t.is_hetong='有' then '1' else '0' end, --是否有合同
       substr(trim(t.hetong_no),1,17), -- 合同号
       '', -- 合同类型
       '2' , --缴费方式
       FUNC_PAY_COST_CYCLE(t.jiaofei_zhouqi), -- 缴费周期
       case when t.dianbiao_yongtu like '%综合电表%' then '1'
         when t.dianbiao_yongtu like '%生产电表%' then '2'
            when t.dianbiao_yongtu like '%非生产电表%' then '3'
              else '1' end, -- 电表用途类型
      case when t.gongdian_method like '直供' then '1'
        when t.gongdian_method like '转供' then '2'
          when t.gongdian_method like '外租' then '3' 
            else '2' end, --供电方式
      t.dianbiao_state, -- 电表状态
      case when t.is_dianfu='是' then '1' else '0' end, -- 是否现金支付
      nvl(t.shengchan_rate,'0'), --生产占比
      t.gongyingshang_no, --供应商编码
      case when t.gongyingshang_no like 'G%' then 
        substr(t.gongyingshang_no,1,4)
      else 'G000' end, -- 供应商组
      t.gongyingshang, -- 供应商
      '', --占局站比例
      replace(nvl(trim(t.lilun_amount),'0'),',','.')*439.4,
      x.area_no
  FROM (SELECT T.*,
               ROW_NUMBER() OVER(PARTITION BY t.DIANBIAO_NO ORDER BY decode(t.dianbiao_state,'在用',1,0) DESC) RN
          FROM DF_STATION_INFO T) T, dim.dim_area_no_jt x
 WHERE RN = 1 and t.area_name=x.area_desc;




--电表抄表信息
--delete from BWT_ELEC_METER_INFO_M where acct_month='201712'
 insert into BWT_ELEC_METER_INFO_M
 SELECT '201712' ACCT_MONTH, -- 账期
        z.std_latn_cd,
        x.city_no, --区县
        X.DIANBIAO_NO, -- 电表编码
        replace(T.BEGIN_DATE,'-',''), -- 抄表开始时间
        replace(T.END_DATE,'-',''), --抄表结束时间
        T.LAST_DUSHU, -- 上次读数
        T.CUR_DUSHU, -- 本次读数
        T.AMOUNT, -- 本次用电量
        '是', --是否回转
        case when x.DIANBIAO_MAX like '%保定%' then '' else x.dianbiao_max end,
        z.area_no
   FROM 
   (SELECT T.*,
               ROW_NUMBER() OVER(PARTITION BY t.DUIXIANG_NO ORDER BY duixiang_name DESC) RN
          FROM DF_BILL_INFO T)T, 
   (SELECT T.*,
               ROW_NUMBER() OVER(PARTITION BY t.dianbiao_no ORDER BY t.dianbiao_name DESC) RN
          FROM DF_STATION_INFO T) X,
    dim.dim_area_no_jt z
  WHERE T.DUIXIANG_NO = X.dianbiao_no
  and t.area_name=z.area_desc
  and t.rn=1
  and x.rn=1


--报账基础信息表
insert into BWT_REIM_BASIC_DATA_INFO_M
 SELECT '201712' ACCT_MONTH, -- 账期
        z.std_latn_cd,
        x.city_no, --区县
        replace(T.BEGIN_DATE,'-',''), -- 抄表开始时间
        replace(T.END_DATE,'-',''), --抄表结束时间
        x.dianbiao_no, --电表编号
        x.chengben_no, -- 成本中心
        t.BAOZHANG_NO, --报账单号
        replace(t.BAOZHANG_DATE,'-',''), --报账日期
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
          FROM DF_BILL_INFO T)T, 
   (SELECT T.*,
               ROW_NUMBER() OVER(PARTITION BY t.dianbiao_no ORDER BY t.dianbiao_name DESC) RN
          FROM DF_STATION_INFO T) X,
    dim.dim_area_no_jt z
  WHERE T.DUIXIANG_NO = X.dianbiao_no
  and t.area_name=z.area_desc
  and t.rn=1
  and x.rn=1;


--IDC场景一
insert into BWT_IDC_ENERGY_CONSUM1_M
select 
'201712' acct_month,
'813',
x.std_latn_cd,
t.city_no,
t.shiti_no,
nvl(t.cust_no,'-1'),
sum(t.idc_df),
sum(ceil(t.idc_df/0.61)),
sum(t.total_glv),
x.area_no
 from df_idc_info t,dim.dim_area_no_jt x
 where t.area_name=x.area_desc
 group by x.std_latn_cd,t.city_no,t.shiti_no,nvl(t.cust_no,'-1'),x.area_no
 
--IDC场景二
--delete from  BWT_IDC_ENERGY_CONSUM2_M 
insert into BWT_IDC_ENERGY_CONSUM2_M
select 
'201712' acct_month,
'813',
x.std_latn_cd,
t.city_no,
t.shiti_no,
nvl(t.cust_no,'-1'),
sum(t.idc_df), 
sum(t.ZUYONG_GLV),
sum(t.idc_sr),
x.area_no
 from df_idc_info t,dim.dim_area_no_jt x
 where t.area_name=x.area_desc
 group by x.std_latn_cd,t.city_no,t.shiti_no,nvl(t.cust_no,'-1'),x.area_no


--delete from BWT_TREND_ANALYSIS_INFO_M
--UE趋势分析信息（月）
insert into BWT_TREND_ANALYSIS_INFO_M
select 
'201712' acct_month,
'813',
z.std_latn_cd,
x.city_no,
t.shiti_no,
sum(t.AMOUNT),
sum(round(t.amount/dbms_random.value(1,2),2)),
z.area_no
   FROM 
   (SELECT T.*,
               ROW_NUMBER() OVER(PARTITION BY t.DUIXIANG_NO ORDER BY duixiang_name DESC) RN
          FROM DF_BILL_INFO T)T, 
   (SELECT T.*,
               ROW_NUMBER() OVER(PARTITION BY t.dianbiao_no ORDER BY t.dianbiao_name DESC) RN
          FROM DF_STATION_INFO T) X,
    dim.dim_area_no_jt z
  WHERE T.DUIXIANG_NO = X.dianbiao_no
  and t.area_name=z.area_desc
  and t.rn=1
  and x.rn=1
  group by z.std_latn_cd,x.city_no,t.shiti_no,z.area_no
 



















 
















