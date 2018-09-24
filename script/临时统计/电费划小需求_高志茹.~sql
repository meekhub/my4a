--表1.PUE动态监控报表
create table xxhb_mjh.tmp_majh_pue_01 as 
SELECT c.area_no,
       c.area_desc,
       a.group_name,
       B.STATION_ID_B,
       a.room_id,
       a.ROOM_NAME,
       SUM(A.ELEC_AMOUNT)ELEC_AMOUNT,
       SUM(A.DEVICE_AMOUNT)DEVICE_AMOUNT
  FROM (SELECT A.AREA_NAME,
               room_id,
               group_name,
               ROOM_NAME,
               SUM(ELEC_AMOUNT) ELEC_AMOUNT,
               SUM(DEVICE_AMOUNT) DEVICE_AMOUNT
          FROM ALLDM.ELEC_STATION_D A
         WHERE ACCT_MONTH = '201808'
         GROUP BY AREA_NAME, room_id,group_name,ROOM_NAME
        having SUM(ELEC_AMOUNT) > 0) A,
       (SELECT STATION_ID_A, STATION_ID_B, room_id
          FROM (SELECT STATION_ID_A,
                       STATION_ID_B,
                       room_id,
                       ROW_NUMBER() OVER(PARTITION BY room_id ORDER BY 1) RN
                  FROM DIM.DIM_STATION_REL
                 WHERE STATION_ID_B IS NOT NULL
                   and STATION_ID_B <> '#N/A'
                   and STATION_ID_B <> '0')
         WHERE RN = 1) B,
       DIM.DIM_AREA_NO_JT C
 WHERE A.room_id = B.room_id
   AND A.AREA_NAME = C.AREA_DESC
 group by c.area_no, c.area_desc, a.group_name,B.STATION_ID_B,a.room_id,a.ROOM_NAME;


--动环每天耗电量
create table xxhb_mjh.tmp_majh_pue_02 as 
select 
room_id,
sum(case when day_id='01' then ELEC_AMOUNT end)amout_01,
max(case when day_id='01' then PUE end)pue_01,
sum(case when day_id='02' then ELEC_AMOUNT end)amout_02,
max(case when day_id='02' then PUE end)pue_02,
sum(case when day_id='03' then ELEC_AMOUNT end)amout_03,
max(case when day_id='03' then PUE end)pue_03,
sum(case when day_id='04' then ELEC_AMOUNT end)amout_04,
max(case when day_id='04' then PUE end)pue_04,
sum(case when day_id='05' then ELEC_AMOUNT end)amout_05,
max(case when day_id='05' then PUE end)pue_05,
sum(case when day_id='06' then ELEC_AMOUNT end)amout_06,
max(case when day_id='06' then PUE end)pue_06,
sum(case when day_id='07' then ELEC_AMOUNT end)amout_07,
max(case when day_id='07' then PUE end)pue_07,
sum(case when day_id='08' then ELEC_AMOUNT end)amout_08,
max(case when day_id='08' then PUE end)pue_08,
sum(case when day_id='09' then ELEC_AMOUNT end)amout_09,
max(case when day_id='09' then PUE end)pue_09,
sum(case when day_id='10' then ELEC_AMOUNT end)amout_10,
max(case when day_id='10' then PUE end)pue_10,
sum(case when day_id='11' then ELEC_AMOUNT end)amout_11,
max(case when day_id='11' then PUE end)pue_11,
sum(case when day_id='12' then ELEC_AMOUNT end)amout_12,
max(case when day_id='12' then PUE end)pue_12,
sum(case when day_id='13' then ELEC_AMOUNT end)amout_13,
max(case when day_id='13' then PUE end)pue_13,
sum(case when day_id='14' then ELEC_AMOUNT end)amout_14,
max(case when day_id='14' then PUE end)pue_14,
sum(case when day_id='15' then ELEC_AMOUNT end)amout_15,
max(case when day_id='15' then PUE end)pue_15,
sum(case when day_id='16' then ELEC_AMOUNT end)amout_16,
max(case when day_id='16' then PUE end)pue_16,
sum(case when day_id='17' then ELEC_AMOUNT end)amout_17,
max(case when day_id='17' then PUE end)pue_17,
sum(case when day_id='18' then ELEC_AMOUNT end)amout_18,
max(case when day_id='18' then PUE end)pue_18,
sum(case when day_id='19' then ELEC_AMOUNT end)amout_19,
max(case when day_id='19' then PUE end)pue_19,
sum(case when day_id='20' then ELEC_AMOUNT end)amout_20,
max(case when day_id='20' then PUE end)pue_20,
sum(case when day_id='21' then ELEC_AMOUNT end)amout_21,
max(case when day_id='21' then PUE end)pue_21,
sum(case when day_id='22' then ELEC_AMOUNT end)amout_22,
max(case when day_id='22' then PUE end)pue_22,
sum(case when day_id='23' then ELEC_AMOUNT end)amout_23,
max(case when day_id='23' then PUE end)pue_23,
sum(case when day_id='24' then ELEC_AMOUNT end)amout_24,
max(case when day_id='24' then PUE end)pue_24,
sum(case when day_id='25' then ELEC_AMOUNT end)amout_25,
max(case when day_id='25' then PUE end)pue_25,
sum(case when day_id='26' then ELEC_AMOUNT end)amout_26,
max(case when day_id='26' then PUE end)pue_26,
sum(case when day_id='27' then ELEC_AMOUNT end)amout_27,
max(case when day_id='27' then PUE end)pue_27,
sum(case when day_id='28' then ELEC_AMOUNT end)amout_28,
max(case when day_id='28' then PUE end)pue_28,
sum(case when day_id='29' then ELEC_AMOUNT end)amout_29,
max(case when day_id='29' then PUE end)pue_29,
sum(case when day_id='30' then ELEC_AMOUNT end)amout_30,
max(case when day_id='30' then PUE end)pue_30,
sum(case when day_id='31' then ELEC_AMOUNT end)amout_31,
max(case when day_id='31' then PUE end)pue_31
from
(SELECT DAY_ID,
       A.ROOM_ID,
       SUM(ELEC_AMOUNT) ELEC_AMOUNT,
       ROUND(DECODE(SUM(DEVICE_AMOUNT),
                    0,
                    0,
                    SUM(ELEC_AMOUNT) / SUM(DEVICE_AMOUNT)),
             1) PUE
  FROM ALLDM.ELEC_STATION_D A
 WHERE ACCT_MONTH = '201808'
 GROUP BY DAY_ID, A.ROOM_ID)
 group by room_id;
 
 



--汇总表
SELECT A.AREA_NAME,
       B.GROUP_NAME,
       A.SHITI_NO,
       A.SHITI_NAME,
       B.ROOM_ID,
       B.ROOM_NAME,
       B.ELEC_AMOUNT,
       B.DEVICE_AMOUNT,
       ROUND(DECODE(B.DEVICE_AMOUNT, 0, 0, B.ELEC_AMOUNT / B.DEVICE_AMOUNT),
             1) PUE, 
       AMOUT_01,
       PUE_01,
       AMOUT_02,
       PUE_02,
       AMOUT_03,
       PUE_03,
       AMOUT_04,
       PUE_04,
       AMOUT_05,
       PUE_05,
       AMOUT_06,
       PUE_06,
       AMOUT_07,
       PUE_07,
       AMOUT_08,
       PUE_08,
       AMOUT_09,
       PUE_09,
       AMOUT_10,
       PUE_10,
       AMOUT_11,
       PUE_11,
       AMOUT_12,
       PUE_12,
       AMOUT_13,
       PUE_13,
       AMOUT_14,
       PUE_14,
       AMOUT_15,
       PUE_15,
       AMOUT_16,
       PUE_16,
       AMOUT_17,
       PUE_17,
       AMOUT_18,
       PUE_18,
       AMOUT_19,
       PUE_19,
       AMOUT_20,
       PUE_20,
       AMOUT_21,
       PUE_21,
       AMOUT_22,
       PUE_22,
       AMOUT_23,
       PUE_23,
       AMOUT_24,
       PUE_24,
       AMOUT_25,
       PUE_25,
       AMOUT_26,
       PUE_26,
       AMOUT_27,
       PUE_27,
       AMOUT_28,
       PUE_28,
       AMOUT_29,
       PUE_29,
       AMOUT_30,
       PUE_30,
       AMOUT_31,
       PUE_31
  FROM MID_STATION_INFO_NEW     A,
       XXHB_MJH.TMP_MAJH_PUE_01 B,
       XXHB_MJH.TMP_MAJH_PUE_02 C
 WHERE A.SHITI_NO = B.STATION_ID_B
   AND B.ROOM_ID = C.ROOM_ID;






