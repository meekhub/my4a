select t.*, t.rowid from tmp_majh_trm_0417_01 t

create table TMP_MAJH_0417_02 as
select * from TMP_MAJH_DQ_RENT where 1=2;

truncate table TMP_MAJH_0417_02

      INSERT /*+ APPEND */
      INTO TMP_MAJH_0417_02 NOLOGGING
        SELECT USER_NO,
               AREA_NO,
               SALES_MODE,
               TO_CHAR(BEGIN_DATE, 'YYYYMMDDHH24MISS'),
               TO_CHAR(END_DATE, 'YYYYMMDDHH24MISS'),
               COST_PRICE,
               device_no，
               user_dinner,
               device_type,
               device_number,
               channel_no,
               to_char(SALESINST_CREATE_DATE,'yyyymmdd') create_date
          FROM (SELECT T.*,
                       ROW_NUMBER() OVER(PARTITION BY USER_NO ORDER BY BEGIN_DATE DESC) RN
                  FROM ODS.O_PRD_USER_DEVICE_RENT_D@HBODS T
                 WHERE T.ACCT_MONTH = '201806'
                   AND T.DAY_ID = '02'
                   --AND AREA_NO = C1.AREA_NO 
                   AND (END_DATE > sysdate or END_DATE is null))
         WHERE RN = 1;
      COMMIT;
  

    create table tmp_trm_device_type as
   select distinct RESOURCE_MANUFACTURER,RESOURCE_KIND_NAME,RESOURCE_KIND_NO,RESOURCE_KIND_ID,DEVCIE_NAME from tmp_majh_trm_0417_01 a, 
   (SELECT *
                  FROM (SELECT TRIM(RESOURCE_MANUFACTURER) RESOURCE_MANUFACTURER,
                               TRIM(RESOURCE_KIND_ID) RESOURCE_KIND_ID,
                               TRIM(RESOURCE_KIND_NO) RESOURCE_KIND_NO,
                               TRIM(RESOURCE_KIND_NAME) RESOURCE_KIND_NAME,
                               ROW_NUMBER() OVER(PARTITION BY RESOURCE_KIND_NO ORDER BY RESOURCE_KIND_ID DESC) RN
                          FROM DSG_STAGE.IR_GET_RESOURCE_KIND_T F) F
                 WHERE RN = 1)b
                 where a.device_type=b.RESOURCE_KIND_ID;

--导出
create table tmp_trm_0417 as 
select 
a.create_date,a.area_no,b.devcie_name,b.RESOURCE_MANUFACTURER,b.resource_kind_name,b.RESOURCE_KIND_ID,a.device_no,a.device_number,a.channel_no,BEGIN_DATE
 from  TMP_MAJH_0417_02 a, tmp_trm_device_type b
 where a.device_type = b.resource_kind_no
/*   and months_between(to_date(end_date, 'yyyymmddhh24miss'),
                      to_date(begin_date, 'yyyymmddhh24miss')) > 24;
                      */
                      
             
/*create table tmp_trm_0417_2 as 
select a.area_no,a.RESOURCE_MANUFACTURER 品牌,
       a.resource_kind_name 型号,
       a.resource_kind_id   终端编码,
       a.device_no          串号,
       a.device_number      合约手机号,
       b.CHANNEL_NO 渠道,
       b.channel_name 渠道名称,
       b.AGENT_ID 代理商ID,
       b.AGENT_NAME 代理商名称,
       case when c.USER_NO is not null then '是' else '否' end 是否大于50M,
       case when c.USER_DINNER_DESC like '%加装%' then '否' else '是' end 是否主卡,
       c.USER_DINNER_DESC
  from tmp_trm_0417 a,
  (select * from rpt_hbtele.DM_BUSI_CHANNEL_BUILD a where a.acct_month='201803')b,
  (
  select area_no_desc,user_no, ONEX_JF_FLUX, device_number,user_dinner_desc
    from dw.dw_v_user_base_info_user c
   where acct_month = '201803'
     and is_onnet = '1'
     and tele_type = '2'
     and ONEX_JF_FLUX > 50
  )c
  where a.channel_no=b.channel_no(+)
  and a.device_number=c.device_number(+);*/
  ;
  create table tmp_trm_0417_2 as 
select a.create_date 受理日期,
       a.area_no,
       func_get_xiongan_area_no(a.area_no,c.CITY_NO) area_no_new,
       city_no_desc,
       a.RESOURCE_MANUFACTURER 品牌,
       a.resource_kind_name 型号,
       a.resource_kind_id   终端编码,
       a.device_no          串号,
       a.device_number      合约手机号,
       a.begin_date 租机开始日期,
       b.CHANNEL_NO 渠道,
       b.channel_name 渠道名称,
       b.AGENT_ID 代理商ID,
       b.AGENT_NAME 代理商名称, 
       case when c.USER_DINNER_DESC like '%加装%' then '否' else '是' end 是否主卡,
       c.USER_DINNER_DESC 套餐
  from tmp_trm_0417 a,
  (select * from rpt_hbtele.DM_BUSI_CHANNEL_BUILD a where a.acct_month='201804')b,
  (
  select area_no_desc,user_no, device_number,user_dinner_desc,city_no,city_no_desc
    from dw.dw_v_user_base_info_day c
   where acct_month = '201806'
   and day_id='02'
     and is_onnet = '1'
     and tele_type = '2' 
  )c
  where a.channel_no=b.channel_no(+)
  and a.device_number=c.device_number(+);
  
  
  
select 受理日期,
       case
         when city_no_desc in ('雄县', '安新', '容城') then
          '雄安'
         else
          b.area_desc
       end 地市,
       city_no_desc 区县,
       品牌,
       型号,
       终端编码,
       串号,
       合约手机号,
       租机开始日期,
       渠道,
       渠道名称,
       代理商id,
       代理商名称,
       是否主卡， 套餐
  from tmp_trm_0417_2 a, dim.dim_area_no_new b
 where a.area_no = b.area_no
   and substr(a.租机开始日期, 1, 8) >= '20180401'
   and substr(a.受理日期,1,6) >='201804'





