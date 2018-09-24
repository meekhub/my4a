create table tmp_kd_flux_183
(
ACCT_MONTH varchar2(20),
DAY_ID varchar2(20),
USER_NO varchar2(20),
AREA_NO varchar2(20),
TELE_TYPE  varchar2(20),
DEVICE_NUMBER varchar2(20),
hour_flag varchar2(20),
TOTAL_OCTETS number
)


DECLARE
  V_DATE VARCHAR2(100);
  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO ='181' ORDER BY IDX_NO;
BEGIN
  FOR V_NUM IN 20180801 .. 20180830 LOOP
    V_DATE := TO_CHAR(V_NUM);
    FOR C1 IN V_AREA LOOP
      INSERT INTO TMP_KD_FLUX_181
        SELECT ACCT_MONTH,
               DAY_ID,
               USER_NO,
               AREA_NO,
               TELE_TYPE,
               DEVICE_NUMBER,
               TO_CHAR(STOPTIME, 'HH24') HOUR_FLAG,
               SUM(TOTAL_OCTETS) / 1024 / 1024
          FROM DW.DW_V_USER_1X_STREAM A
         WHERE ACCT_MONTH = '201808'
           AND DAY_ID = SUBSTR(V_DATE, 7, 2)
           AND AREA_NO = c1.area_no
         GROUP BY ACCT_MONTH,
                  DAY_ID,
                  USER_NO,
                  AREA_NO,
                  TELE_TYPE,
                  DEVICE_NUMBER,
                  TO_CHAR(STOPTIME, 'HH24');
      COMMIT;
    END LOOP;
  END LOOP;
  
  insert into TMP_MOBILE_FLUX_181
select acct_month,
       user_no,
       area_no,
       tele_type,
       device_number,
       hour_flag,
       sum(total_octets) total_octets
  from TMP_KD_FLUX_181
 group by acct_month, user_no, area_no, tele_type, device_number, hour_flag;
 commit;
 
execute immediate 'truncate table TMP_KD_FLUX_181';
END;

--按用户汇总
/*create table TMP_MOBILE_FLUX_181 as 
select acct_month,
       user_no,
       area_no,
       tele_type,
       device_number,
       hour_flag,
       sum(total_octets) total_octets
  from TMP_KD_FLUX_181
 group by acct_month, user_no, area_no, tele_type, device_number, hour_flag
*/

create table tmp_majh_family_out_0526_188 AS 
select * from  
(select CELL_PHONE 宽带账号,
       RESERV1    手机号,
       RESERV3    运营商,
       RESERV4    转网意愿,
       RESERV5    用户价值,
       RESERV6    终端品牌,
       RESERV7    终端型号,
       RESERV8    是否全网通,
       RESERV9    上市时间,
       RESERV10   卡槽数量,
       ROW_NUMBER()OVER(PARTITION BY CELL_PHONE,RESERV1 ORDER BY 1)RN
  from tmp_majh_family_out_0515_2
 where area_no_desc = '石家庄'
    or area_no_desc is null)
    where RN=1;
    
    
    
 create table tmp_wifi_user_188 as    
select 
a.宽带账号 as kd_number,
a.手机号 device_number,
a.运营商 as Operator_flag,
a.转网意愿 as trans_will,
case when b.other_home_code='0316' then '是' else '否' end is_native
 from  tmp_majh_family_out_0526_183 a,
(
SELECT oppose_number,other_home_code
  FROM dw.DW_V_USER_CDR_CDMA
 WHERE ACCT_MONTH = '201806'
   AND AREA_NO = '188' 
   group by oppose_number,other_home_code
)b
where a.手机号=b.oppose_number(+)
and b.oppose_number is not null;



--清单输出
create table tmp_mobile_flux_181_010 as 
select a.USER_NO,a.DEVICE_NUMBER,sum(a.TOTAL_OCTETS) 总流量,
sum(case when a.HOUR_FLAG ='00' then a.TOTAL_OCTETS else 0 end) h00,
sum(case when a.HOUR_FLAG ='01' then a.TOTAL_OCTETS else 0 end) h01,
sum(case when a.HOUR_FLAG ='02' then a.TOTAL_OCTETS else 0 end) h02,
sum(case when a.HOUR_FLAG ='03' then a.TOTAL_OCTETS else 0 end) h03,
sum(case when a.HOUR_FLAG ='04' then a.TOTAL_OCTETS else 0 end) h04,
sum(case when a.HOUR_FLAG ='05' then a.TOTAL_OCTETS else 0 end) h05,
sum(case when a.HOUR_FLAG ='06' then a.TOTAL_OCTETS else 0 end) h06,
sum(case when a.HOUR_FLAG ='07' then a.TOTAL_OCTETS else 0 end) h07,
sum(case when a.HOUR_FLAG ='08' then a.TOTAL_OCTETS else 0 end) h08,
sum(case when a.HOUR_FLAG ='09' then a.TOTAL_OCTETS else 0 end) h09,
sum(case when a.HOUR_FLAG ='10' then a.TOTAL_OCTETS else 0 end) h10,
sum(case when a.HOUR_FLAG ='11' then a.TOTAL_OCTETS else 0 end) h11,
sum(case when a.HOUR_FLAG ='12' then a.TOTAL_OCTETS else 0 end) h12,
sum(case when a.HOUR_FLAG ='13' then a.TOTAL_OCTETS else 0 end) h13,
sum(case when a.HOUR_FLAG ='14' then a.TOTAL_OCTETS else 0 end) h14,
sum(case when a.HOUR_FLAG ='15' then a.TOTAL_OCTETS else 0 end) h15,
sum(case when a.HOUR_FLAG ='16' then a.TOTAL_OCTETS else 0 end) h16,
sum(case when a.HOUR_FLAG ='17' then a.TOTAL_OCTETS else 0 end) h17,
sum(case when a.HOUR_FLAG ='18' then a.TOTAL_OCTETS else 0 end) h18,
sum(case when a.HOUR_FLAG ='19' then a.TOTAL_OCTETS else 0 end) h19,
sum(case when a.HOUR_FLAG ='20' then a.TOTAL_OCTETS else 0 end) h20,
sum(case when a.HOUR_FLAG ='21' then a.TOTAL_OCTETS else 0 end) h21,
sum(case when a.HOUR_FLAG ='22' then a.TOTAL_OCTETS else 0 end) h22,
sum(case when a.HOUR_FLAG ='23' then a.TOTAL_OCTETS else 0 end) h23
 from tmp_mobile_flux_181 a 
where 1=1
group by a.USER_NO,a.DEVICE_NUMBER;

--用户占比情况
create table tmp_mobile_flux_181_020 as 
select a.user_no,
       a.device_number,
       a.总流量 总流量,
       a.h00 / a.总流量  hb00,
       a.h01 / a.总流量 * 100 hb01,
       a.h02 / a.总流量 * 100 hb02,
       a.h03 / a.总流量 * 100 hb03,
       a.h04 / a.总流量 * 100 hb04,
       a.h05 / a.总流量 * 100 hb05,
       a.h06 / a.总流量 * 100 hb06,
       a.h07 / a.总流量 * 100 hb07,
       a.h08 / a.总流量 * 100 hb08,
       a.h09 / a.总流量 * 100 hb09,
       a.h10 / a.总流量 * 100 hb10,
       a.h11 / a.总流量 * 100 hb11,
       a.h12 / a.总流量 * 100 hb12,
       a.h13 / a.总流量 * 100 hb13,
       a.h14 / a.总流量 * 100 hb14,
       a.h15 / a.总流量 * 100 hb15,
       a.h16 / a.总流量 * 100 hb16,
       a.h17 / a.总流量 * 100 hb17,
       a.h18 / a.总流量 * 100 hb18,
       a.h19 / a.总流量 * 100 hb19,
       a.h20 / a.总流量 * 100 hb20,
       a.h21 / a.总流量 * 100 hb21,
       a.h22 / a.总流量 * 100 hb22,
       a.h23 / a.总流量 * 100 hb23
  from tmp_mobile_flux_181_010 a
  where a.总流量>0;
  
--使用数据进行分类
create table tmp_mobile_flux_188_030 as 
select a.user_no,a.device_number,a.总流量,
case when a.总流量<100 then 'A4'
  when a.总流量>=100 and  a.hb21+a.hb22+a.hb23+a.hb00+a.hb01+a.hb03+a.hb04+a.hb05<0.162 then 'A1'
    when a.总流量>=100 and a.hb21+a.hb22+a.hb23+a.hb00+a.hb01+a.hb03+a.hb04+a.hb05<0.375 and a.hb21+a.hb22+a.hb23+a.hb00+a.hb01+a.hb03+a.hb04+a.hb05>=0.162 then 'A2'
      when a.总流量>=100 and a.hb21+a.hb22+a.hb23+a.hb00+a.hb01+a.hb03+a.hb04+a.hb05>=0.375 then 'A3'
        else 'AB' end 分类
 from tmp_mobile_flux_181_020 a;
 
 
--单独A类
select 
count(*)
 from  tmp_mobile_flux_181_020 a
where 
a.总流量>=500 and  a.hb21+a.hb22+a.hb23+a.hb00+a.hb01+a.hb03+a.hb04+a.hb05<0.082;


--
create table xxhb_mjh.tmp_majh_yw_01 as 
select b.city_no_desc,b.user_no,b.device_number,b.user_dinner,b.user_dinner_desc
from 
(
select 
*
 from  tmp_mobile_flux_181_020 a
where 
a.总流量>=300 and  a.hb21+a.hb22+a.hb23+a.hb00+a.hb01+a.hb03+a.hb04+a.hb05<0.082
) a,
(
select city_no_desc,c.USER_NO,
                       c.DEVICE_NUMBER,
                       c.USER_DINNER_DESC,
                       c.ACCOUNT_NO,
                       c.IS_KD_BUNDLE,
                       c.BUNDLE_ID,
                       c.user_dinner
                  from dw.dw_v_user_base_info_day c
                 where c.acct_month='201809'
                   and c.DAY_ID = '06'
                   and area_no='181'
                   and c.TELE_TYPE = 2
                   and c.IS_VALID = 1
                   and c.IS_KD_BUNDLE='0'
)b
where a.user_no=b.user_no;



create table xxhb_mjh.model_yw_ansys_ts as
select 
user_no,device_number,city_no_desc,user_dinner,user_dinner_desc
 from xxhb_mjh.tmp_majh_yw_01 a,rpt_hbtele.sjzx_wh_dim_user_dinner b
where a.USER_DINNER=b.user_dinner 
and b.low_value>=39;





--生成与wifi关数据及手机信息数据
create table tmp_mobile_flux_188_040 as
select T1.*, T2.IS_KD_BUNDLE,t2.user_dinner,T2.User_Dinner_Desc,T2.融合宽带,T3.KD_NUMBER
  from tmp_mobile_flux_188_030 T1,
       (select M1.User_No,
               M1.Device_Number,
               M1.user_dinner,
               M1.User_Dinner_Desc,
               M1.IS_KD_BUNDLE,
               M2.DEVICE_NUMBER 融合宽带
          from (select c.USER_NO,
                       c.DEVICE_NUMBER,
                       c.USER_DINNER_DESC,
                       c.ACCOUNT_NO,
                       c.IS_KD_BUNDLE,
                       c.BUNDLE_ID,
                       c.user_dinner
                  from dw.dw_v_user_base_info_day c
                 where c.acct_month='201807'
                   and c.DAY_ID = '08'
                   and c.TELE_TYPE = 2
                   and c.IS_VALID = 1) M1,
               (select c.USER_NO,
                       c.DEVICE_NUMBER,
                       c.ACCOUNT_NO,
                       c.IS_KD_BUNDLE,
                       c.BUNDLE_ID
                  from dw.dw_v_user_base_info_day c
                 where c.acct_month='201807'
                   and c.DAY_ID = '08'
                   and c.TELE_TYPE in (4, 26)
                   and c.INNET_METHOD in (1, 2, 4, 5, 15)
                   and c.IS_VALID = 1) M2
         where M1.BUNDLE_ID = M2.BUNDLE_ID(+)) T2,
       
       (select a.DEVICE_NUMBER, a.KD_NUMBER, a.OPERATOR_FLAG
          from tmp_wifi_user_188 a
         where a.IS_NATIVE = '是'
           and a.OPERATOR_FLAG = '电信') T3
 where T1.User_No = T2.USER_NO
   and T1.DEVICE_NUMBER = T3.Device_Number(+);



create table tmp_other_kd_target_188 as 
select 
user_no, 
device_number, 
总流量 as mobile_flux, 
is_kd_bundle, 
a.user_dinner, 
a.user_dinner_desc,
b.low_value
 from tmp_mobile_flux_188_040 a，RPT_HBTELE.SJZX_WH_DIM_USER_DINNER b 
where a.user_dinner=b.user_dinner(+)
and a.分类 ='A1'
and a.kd_number is null
and a.融合宽带 is null

