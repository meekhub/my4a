select * from mobile_cbzs.CBZS_DM_KKPI_M_YUSUAN_ADMIN;
select * from  mobile_cbzs.cbzs_dmcode_yusuan_type for update


select * from mobile_cbzs.CBZS_DM_KKPI_M_YUSUAN_ADMIN where acct_month='201808';


select * from mobile_cbzs.CBZS_DM_KKPI_M_YUSUAN

select * from mobile_cbzs.MSS_BMS_ZHIJU_YUSUAN;

create table xxhb_mjh.mid_kkpi_yusuan as 
select * from mid_kkpi_yusuan


create table xxhb_mjh.mid_kkpi_yusuan_0526 as
select * from mid_kkpi_yusuan

insert into mid_kkpi_yusuan
select 
acct_month,
area_desc, 
city_desc, 
huaxiao_no, 
year_guangao_fee, 
year_kefu_fee, 
year_zhaodai_fee, 
year_cheliang_fee, 
year_yongpin_fee, 
year_butie_fee, 
year_zulin_fee, 
year_qita_fee, 
month_guangao_fee, 
month_kefu_fee, 
month_zhaodai_fee, 
month_cheliang_fee, 
month_yongpin_fee, 
month_butie_fee, 
month_zulin_fee, 
month_qita_fee
 from xxhb_mjh.mid_kkpi_yusuan 

create table mid_kkpi_yusuan
(
acct_month varchar2(40),
area_desc varchar2(40),
city_desc varchar2(40),
huaxiao_no varchar2(40),
year_guangao_ys number,
year_kefu_ys number,
year_zhaodai_ys number,
year_cheliang_ys number,
year_yongpin_ys number,
year_butie_ys number,
year_zulin_ys number,
year_qita_ys number,
year_guangao_sz number,
year_kefu_sz number,
year_zhaodai_sz number,
year_cheliang_sz number,
year_yongpin_sz number,
year_butie_sz number,
year_zulin_sz number,
year_qita_sz number
)

create table xxhb_mjh.CBZS_DM_KKPI_M_YUSUAN as
select * from CBZS_DM_KKPI_M_YUSUAN

select * from CBZS_DM_KKPI_M_YUSUAN where acct_month='201808'


update mid_kkpi_yusuan set huaxiao_no=trim(huaxiao_no) where acct_month='201808'

update mid_kkpi_yusuan set huaxiao_no=replace(huaxiao_no,chr(13),'') where acct_month='201808'

--年度预算
delete from CBZS_DM_KKPI_M_YUSUAN where acct_month='201808'

insert into MOBILE_CBZS.CBZS_DM_KKPI_M_YUSUAN
SELECT '201808' ACCT_MONTH,
       B.AREA_NO,
       B.CITY_NO,
       '1',
       B.HUAXIAO_TYPE,
       B.HUAXIAO_NO,
       '02',
       '01',
       SUM(A.YEAR_GUANGAO_YS), --广告宣传费 
       SUM(A.YEAR_KEFU_YS), --客户服务费
       SUM(A.YEAR_ZHAODAI_YS), --业务招待费
       SUM(A.YEAR_CHELIANG_YS), --车辆使用及租赁费 
       SUM(A.YEAR_YONGPIN_YS), --业务用品费
       SUM(A.Year_Butie_Ys), --渠道补贴费 
       SUM(A.Year_Zulin_Ys) --租赁费 
  FROM mobile_cbzs.MID_KKPI_YUSUAN A, DIM.DIM_HUAXIAO_INFO B
 WHERE A.ACCT_MONTH = '201808'
   AND A.HUAXIAO_NO = B.HUAXIAO_NO
 GROUP BY ACCT_MONTH,
          B.AREA_NO,
          B.CITY_NO,
          '1',
          B.HUAXIAO_TYPE,
          B.HUAXIAO_NO

--只导入预算
/*insert into MOBILE_CBZS.CBZS_DM_KKPI_M_YUSUAN
  select '201808' acct_month,
         area_no,
         city_no,
         huaxiao_type_big,
         huaxiao_type,
         huaxiao_no,
         type_one,
         type_two,
         fee_1,
         fee_2,
         fee_3,
         fee_4,
         fee_5,
         fee_6,
         fee_7
    from MOBILE_CBZS.CBZS_DM_KKPI_M_YUSUAN a
   where acct_month = '201804'
     and area_no in ('182', '184', '185')
     and type_one='02'
     and type_two='01'*/
     

--年度实占
insert into CBZS_DM_KKPI_M_YUSUAN
SELECT '201808' ACCT_MONTH,
       B.AREA_NO,
       B.CITY_NO,
       '1',
       B.HUAXIAO_TYPE,
       B.HUAXIAO_NO,
       '02',
       '03',
       SUM(A.YEAR_GUANGAO_SZ), --广告宣传费 
       SUM(A.YEAR_KEFU_SZ), --客户服务费
       SUM(A.YEAR_ZHAODAI_SZ), --业务招待费
       SUM(A.YEAR_CHELIANG_SZ), --车辆使用及租赁费 
       SUM(A.YEAR_YONGPIN_SZ), --业务用品费 
       SUM(A.Year_Butie_sz), --渠道补贴费 
       SUM(A.Year_Zulin_sz) --租赁费 
  FROM MID_KKPI_YUSUAN A, DIM.DIM_HUAXIAO_INFO B
 WHERE A.ACCT_MONTH = '201808'
   AND A.HUAXIAO_NO = B.HUAXIAO_NO
 GROUP BY ACCT_MONTH,
          B.AREA_NO,
          B.CITY_NO,
          '1',
          B.HUAXIAO_TYPE,
          B.HUAXIAO_NO



    DELETE FROM CBZS_DM_KKPI_M_YUSUAN_ADMIN WHERE ACCT_MONTH = '201808';
    COMMIT;
    
    INSERT INTO CBZS_DM_KKPI_M_YUSUAN_ADMIN
      SELECT ACCT_MONTH,
             AREA_NO,
             CITY_NO,
             HUAXIAO_TYPE_BIG,
             HUAXIAO_TYPE,
             TYPE_ONE,
             TYPE_TWO,
             SUM(FEE_1),
             SUM(FEE_2),
             SUM(FEE_3),
             SUM(FEE_4),
             SUM(FEE_5),
             SUM(FEE_6),
             SUM(FEE_7)
        FROM CBZS_DM_KKPI_M_YUSUAN
       WHERE ACCT_MONTH = '201808'
       GROUP BY ACCT_MONTH,
                AREA_NO,
                CITY_NO,
                HUAXIAO_TYPE_BIG,
                HUAXIAO_TYPE,
                TYPE_ONE,
                TYPE_TWO;










