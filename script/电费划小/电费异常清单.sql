--PUE异常局站导出
truncate table elec_station_alarm_m
insert into elec_station_alarm_m
SELECT
        '201807' acct_month,
       b.area_no,
       a.area_name,
       a.group_name,
       --a.room_id,
       a.room_name,
       sum(a.elec_amount)elec_amount,
       sum(a.device_amount)device_amount,
       round(sum(a.elec_amount) / sum(a.device_amount),2) as "PUE"
  FROM alldm.ELEC_STATION_D a,dim.dim_area_no b
 WHERE ACCT_MONTH = '201807'
 and a.area_name=b.area_desc
 and a.device_amount>0
 group by b.area_no,a.area_name, a.group_name, a.room_id, a.room_name
 having sum(a.elec_amount) / sum(a.device_amount)>=2;
 
 

--异常偏离度超过20%（实际报账-实际使用）/实际使用 >= 20%

/*select \*+ordered*\a.area_name, a.shiti_no, b.BUR_STAND_NAME,a.BAOZHANG_FEE,a.ELEC_AMOUNT
  from (SELECT area_name, shiti_no，c.BAOZHANG_FEE,a.ELEC_AMOUNT*1.25 as ELEC_AMOUNT
          FROM (SELECT A.AREA_NAME,
                       REPLACE(A.RELATION_ID, CHR(13), '') RELATION_ID,
                       SUM(ELEC_AMOUNT) ELEC_AMOUNT,
                       SUM(DEVICE_AMOUNT) DEVICE_AMOUNT
                  FROM ALLDM.ELEC_STATION_D A
                 WHERE ACCT_MONTH = '201805'
                 GROUP BY A.AREA_NAME, A.RELATION_ID
                HAVING SUM(ELEC_AMOUNT) > 0) A,
               (SELECT STATION_ID_A, STATION_ID_B
                  FROM (SELECT STATION_ID_A,
                               STATION_ID_B,
                               ROW_NUMBER() OVER(PARTITION BY STATION_ID_A ORDER BY 1) RN
                          FROM DIM.DIM_STATION_REL
                         WHERE STATION_ID_B IS NOT NULL
                           AND STATION_ID_B <> '#N/A')
                 WHERE RN = 1) B,
               (SELECT SHITI_NO, SUM(BAOZHANG_FEE) BAOZHANG_FEE
                  FROM DF_BILL_INFO A
                 WHERE A.BAOZHANG_DATE IN ('2018-05')
                 GROUP BY SHITI_NO) C
         WHERE A.RELATION_ID = B.STATION_ID_A
           AND B.STATION_ID_B = C.SHITI_NO
           AND (BAOZHANG_FEE - ELEC_AMOUNT * 1.2) / ELEC_AMOUNT*1.25 > 0.25) a,
       (select bur_stand_code,bur_stand_name from BWT_BUR_STAND_INFO_M b where acct_month = '201805') b
 where a.shiti_no = b.bur_stand_code*/
 
 --flashback table tmp_elec_alarm to before drop 
 
 truncate table tmp_elec_alarm;
 
 INSERT INTO tmp_elec_alarm
  SELECT '201805' ACCT_MONTH, -- 账期
         A.LATN_ID,
         '201805' ELEC_FEE_MONTH_START, -- 抄表开始时间
         '201805' ELEC_FEE_MONTH_END, --抄表结束时间
         A.ELECTRIC_METER_ID, --电表编号
         A.COSTCENTER, -- 成本中心
         C.BAOZHANG_NO, --报账单号
         --to_char(to_date(ACCOUNT_DATE,'yyyy-mm'),'yyyymmddHH24MISS')
         CASE
           WHEN C.BAOZHANG_NO IS NOT NULL THEN
            to_char(to_date(C.BAOZHANG_DATE,'yyyy-mm'),'yyyymmddHH24MISS')
           ELSE
            to_char(to_date(A.ACCT_MONTH,'yyyy-mm'),'yyyymmddHH24MISS')
         END, --报账日期
         '0', --退补电量
         '0', --退补电费
         X.HT_PRICE_NEW, --合同单价
         DECODE(X.HT_PRICE_NEW,
                0,
                B.BAOZHANG_FEE,
                B.BAOZHANG_FEE / X.HT_PRICE_NEW), --总电量(度)
         B.BAOZHANG_FEE, --报账金额
         CASE
           WHEN C.PIAOJU_TYPE LIKE '%增值税专用发票%' THEN
            B.BAOZHANG_FEE * TO_NUMBER(NVL(X.SHUILV,'0'))
           ELSE
            0
         END TAX_FEE, --电费税额
         0,
         Y.AREA_NO
    FROM (SELECT *
            FROM BWT_ELECTRIC_METER_INFO_M
           WHERE ACCT_MONTH = '201805') A,
         XXHB_MJH.TMP_MAJH_DB B,
         (SELECT *
            FROM (SELECT C.*,
                         C.TAX_FEE / C.BAOZHANG_FEE AS TAX_RATE,
                         ROW_NUMBER() OVER(PARTITION BY C.DUIXIANG_NO ORDER BY C.BAOZHANG_DATE, C.BEGIN_DATE DESC) RN
                    FROM DF_BILL_INFO C)
           WHERE RN = 1) C,
         (SELECT A.*,
                 B.CHENGBEN_NO,
                 CASE
                   WHEN TRIM(TRANSLATE(NVL(REPLACE(A.HT_PRICE, ' ', ''),
                                           '0.68'),
                                       '.0123456789',
                                       ' ')) IS NULL THEN
                    TO_NUMBER(NVL(A.HT_PRICE, 0.68))
                   ELSE
                    1
                 END HT_PRICE_NEW
            FROM MID_STATION_INFO_NEW A, MID_STATION_INFO B
           WHERE A.DIANBIAO_NO = B.DIANBIAO_NO(+)) X,
         DIM.DIM_AREA_NO_JT Y
   WHERE A.ELECTRIC_METER_ID = B.DUIXIANG_NO
     AND A.ELECTRIC_METER_ID = C.DUIXIANG_NO
     AND A.ELECTRIC_METER_ID = X.DIANBIAO_NO
     AND A.LATN_ID = Y.STD_LATN_CD;

create table xxhb_mjh.elec_rel_station as 
SELECT STATION_ID_A, STATION_ID_B
                  FROM (SELECT STATION_ID_A,
                               STATION_ID_B,
                               ROW_NUMBER() OVER(PARTITION BY STATION_ID_A ORDER BY 1) RN
                          FROM DIM.DIM_STATION_REL
                         WHERE STATION_ID_B IS NOT NULL
                           AND STATION_ID_B <> '#N/A')
                 WHERE RN = 1

--输出异常
select /*+ordered*/a.area_name, a.shiti_no, b.BUR_STAND_NAME,a.BAOZHANG_FEE,round(a.ELEC_AMOUNT,2)
  from (SELECT area_name, shiti_no，c.BAOZHANG_FEE,a.ELEC_AMOUNT*1.25 as ELEC_AMOUNT
          FROM (SELECT A.AREA_NAME,
                       REPLACE(A.RELATION_ID, CHR(13), '') RELATION_ID,
                       SUM(ELEC_AMOUNT) ELEC_AMOUNT,
                       SUM(DEVICE_AMOUNT) DEVICE_AMOUNT
                  FROM ALLDM.ELEC_STATION_D A
                 WHERE ACCT_MONTH = '201805'
                 GROUP BY A.AREA_NAME, A.RELATION_ID
                HAVING SUM(ELEC_AMOUNT) > 0) A,
               (SELECT STATION_ID_A, STATION_ID_B
                  FROM (SELECT STATION_ID_A,
                               STATION_ID_B,
                               ROW_NUMBER() OVER(PARTITION BY STATION_ID_B ORDER BY 1) RN
                          FROM xxhb_mjh.elec_rel_station)
                 WHERE RN = 1) B,
               (SELECT BUR_STAND_CODE as SHITI_NO, SUM(ELEC_CHARGE_PRICE) BAOZHANG_FEE
                  FROM tmp_elec_alarm A,BWT_ELECTRIC_METER_INFO_M b
                 WHERE A.acct_month='201805'
                 and b.acct_month='201805'
                 and a.ELECTRIC_METER_ID=b.ELECTRIC_METER_ID
                 GROUP BY b.BUR_STAND_CODE) C
         WHERE A.RELATION_ID = B.STATION_ID_A
           AND B.STATION_ID_B = C.SHITI_NO
           AND (BAOZHANG_FEE - ELEC_AMOUNT * 1.25) / (ELEC_AMOUNT*1.25) > 0.2) a,
       (select bur_stand_code,bur_stand_name from BWT_BUR_STAND_INFO_M b where acct_month = '201805') b
 where a.shiti_no = b.bur_stand_code

--单表单价

--单表单价>2或<0.3
select 
c.area_desc 地市,b.bur_stand_code 局站ID,b.bur_stand_name 局站名称,round(a.new_price,4) 单表单价
from
(SELECT DUIXIANG_NO, SHITI_NO, PRICE,BAOZHANG_FEE/AMOUNT as new_price
  FROM DF_BILL_INFO A
 WHERE A.BAOZHANG_DATE IN ('2018-05')
 and (BAOZHANG_FEE/AMOUNT <0.3 or BAOZHANG_FEE/AMOUNT>2))a,
 (select latn_id,bur_stand_code,bur_stand_name from BWT_BUR_STAND_INFO_M b where acct_month = '201805') b,
    dim.dim_area_no_jt c
    where a.shiti_no = b.bur_stand_code
    and b.latn_id=c.STD_LATN_CD
 
 --合同单价 >2或<0.3
 select area_name 地市,shiti_no 局站ID, shiti_name 局站名称,dianbiao_no 电表ID, dianbiao_name,nvl(ht_price_new,0) 合同单价,
 case when GONGDIAN_METHOD like '%转供%' then '是' else '否' end 是否转供电
   from (SELECT *
           FROM (SELECT A.*,
           case WHEN TRIM(TRANSLATE(NVL(REPLACE(ht_price, ' ', ''),
                                           '0'),
                                       '.0123456789',
                                       ' ')) IS NULL THEN
                    TO_NUMBER(NVL(ht_price, 0))
                   ELSE
                    1
                 END ht_price_new,
                        ROW_NUMBER() OVER(PARTITION BY A.SHITI_NO ORDER BY 1) RN1
                   FROM MID_STATION_INFO_NEW A)
          WHERE RN1 = 1) T,
        DIM.DIM_AREA_NO_JT X
  WHERE RN = 1
    AND T.AREA_NAME = X.AREA_DESC
    and (((ht_price_new>0 and ht_price_new<0.3) or ht_price_new>2) or (GONGDIAN_METHOD like '%转供%' and ht_price_new=0)) and shiti_state='在用'


--转供电
create table xxhb_mjh.tmp_elec_price as
 SELECT   a.DUIXIANG_NO, a.SHITI_NO, to_char(a.new_price) as new_price, ht_price_new as ht_price
   FROM 
   (select a.*,PRICE,BAOZHANG_FEE/AMOUNT as new_price,
   CASE
                   WHEN TRIM(TRANSLATE(NVL(REPLACE(PRICE, ' ', ''),
                                           '999'),
                                       '.0123456789',
                                       ' ')) IS NULL THEN
                    TO_NUMBER(NVL(PRICE, 999))
                   ELSE
                    1
                 END price_new
    from DF_BILL_INFO a) A,
        (select x.*,CASE
                   WHEN TRIM(TRANSLATE(NVL(REPLACE(x.HT_PRICE, ' ', ''),
                                           '999'),
                                       '.0123456789',
                                       ' ')) IS NULL THEN
                    TO_NUMBER(NVL(x.HT_PRICE, 999))
                   ELSE
                    1
                 END HT_PRICE_NEW
           from MID_STATION_INFO_NEW x
          where exists (select 1
                   from mid_station_info y
                  where x.dianbiao_no = y.dianbiao_no
                    and y.gongdian_method like '%转供%')) b
  WHERE A.BAOZHANG_DATE IN ('2018-05')
    and a.duixiang_no = b.dianbiao_no
    and to_number(round(a.new_price,2)) <> to_number(b.HT_PRICE_NEW)
    

select 
c.area_desc 分公司,b.bur_stand_code 局站ID,b.bur_stand_name 局站名称,round(a.new_price,2) 单表单价,round(a.ht_price,2) 合同单价
 from  xxhb_mjh.tmp_elec_price a,
    (select latn_id,bur_stand_code,bur_stand_name from BWT_BUR_STAND_INFO_M b where acct_month = '201805') b,
    dim.dim_area_no_jt c
    where a.shiti_no = b.bur_stand_code
    and b.latn_id=c.STD_LATN_CD
    and a.new_price<>'0' 
    
    

/*insert into temp_user.tmp_elec_pue_m
select 
'201709' acct_month, 
area_name, 
group_name, 
room_id, 
room_name, 
elec_amount, 
device_amount, 
pue
 from temp_user.tmp_elec_pue_m*/


--电费能耗分析模型 
--耗电量环比
select AREA_NAME,
       GROUP_NAME,
       ROOM_ID,
       ROOM_NAME,
       CUR_ELEC_AMOUNT,
       LAST_ELEC_AMOUNT,
       rate
  from (SELECT AREA_NAME,
               GROUP_NAME,
               ROOM_ID,
               ROOM_NAME,
               CUR_ELEC_AMOUNT,
               LAST_ELEC_AMOUNT,
               ROUND((CUR_ELEC_AMOUNT - LAST_ELEC_AMOUNT) / LAST_ELEC_AMOUNT,
                     4) as rate
          FROM (SELECT A.AREA_NAME,
                       A.GROUP_NAME,
                       A.ROOM_ID,
                       A.ROOM_NAME,
                       SUM(CASE
                             WHEN A.ACCT_MONTH = '201802' THEN
                              TO_NUMBER(A.ELEC_AMOUNT)
                             ELSE
                              0
                           END) / 30 CUR_ELEC_AMOUNT,
                       SUM(CASE
                             WHEN A.ACCT_MONTH = '201805' THEN
                              TO_NUMBER(A.ELEC_AMOUNT)
                             ELSE
                              0
                           END) / 31 LAST_ELEC_AMOUNT
                  FROM alldm.ELEC_STATION_D@oldhbdw A
                 WHERE ACCT_MONTH IN ('201802', '201805')
                 GROUP BY A.AREA_NAME, A.GROUP_NAME, A.ROOM_ID, A.ROOM_NAME)
         where LAST_ELEC_AMOUNT > 0)
 where rate > 0.5
 and CUR_ELEC_AMOUNT>100;
 
 
--综合电价
SELECT B.AREA_DESC,
       BUR_STAND_NAME,
       --BUR_STAND_CODE,
       TOTAL_ELECTRICITY,
       ELEC_CHARGE_PRICE,
       RATE
  FROM (SELECT A.AREA_NO,
               C.BUR_STAND_NAME,
               C.BUR_STAND_CODE,
               SUM(A.TOTAL_ELECTRICITY) TOTAL_ELECTRICITY,
               SUM(A.ELEC_CHARGE_PRICE) ELEC_CHARGE_PRICE,
               SUM(A.ELEC_CHARGE_PRICE) / SUM(A.TOTAL_ELECTRICITY) AS RATE
          FROM (SELECT AREA_NO,
                       ELECTRIC_METER_ID,
                       TOTAL_ELECTRICITY,
                       ELEC_CHARGE_PRICE
                  FROM alldm.BWT_REIM_BASIC_DATA_INFO_M A
                 WHERE A.ACCT_MONTH = '201805') A,
               (SELECT *
                  FROM alldm.BWT_ELECTRIC_METER_INFO_M B
                 WHERE ACCT_MONTH = '201805') B,
               (SELECT *
                  FROM alldm.BWT_BUR_STAND_INFO_M
                 WHERE ACCT_MONTH = '201805') C
         WHERE A.ELECTRIC_METER_ID = B.ELECTRIC_METER_ID
           AND B.BUR_STAND_CODE = C.BUR_STAND_CODE
         GROUP BY A.AREA_NO, C.BUR_STAND_NAME, C.BUR_STAND_CODE) A,
       DIM.DIM_AREA_NO B
 WHERE (RATE < 0.3
    OR RATE > 2)
   AND A.AREA_NO = B.AREA_NO;
   
   
--合同电价
SELECT *
  FROM (SELECT *
          FROM MID_STATION_INFO_NEW A
         WHERE TRIM(TRANSLATE(NVL(REPLACE(A.HT_PRICE, ' ', ''), '9999'),
                              '.0123456789',
                              ' ')) IS NULL)
   
   
   
