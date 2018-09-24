--PUE
create table tmp_majh_elec_0423_01 as
SELECT
       -- '201802' acct_month,
       a.area_name,
       a.group_name,
       --a.room_id,
       a.room_name,
       sum(a.elec_amount)elec_amount,
       sum(a.device_amount)device_amount,
       round(sum(a.elec_amount) / sum(a.device_amount),2) as "PUE"，
       sum(a.elec_amount)-sum(a.device_amount)*3 as js_amount
  FROM alldm.ELEC_STATION_D@oldhbdw a
 WHERE ACCT_MONTH = '201803'
 and a.device_amount>0
 group by a.area_name, a.group_name, a.room_id, a.room_name
 having sum(a.elec_amount) / sum(a.device_amount)>3
 
 
 
 --耗电量环比
 create table tmp_majh_elec_rate as
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
                             WHEN A.ACCT_MONTH = '201803' THEN
                              TO_NUMBER(A.ELEC_AMOUNT)
                             ELSE
                              0
                           END) / 31 LAST_ELEC_AMOUNT
                  FROM alldm.ELEC_STATION_D@oldhbdw A
                 WHERE ACCT_MONTH IN ('201802', '201803')
                 GROUP BY A.AREA_NAME, A.GROUP_NAME, A.ROOM_ID, A.ROOM_NAME)
         where LAST_ELEC_AMOUNT > 0)
 where rate > 0.5
 and CUR_ELEC_AMOUNT>100;
 
 
 select area_name,sum(a.cur_elec_amount),sum(a.last_elec_amount) from tmp_majh_elec_rate a group by area_name
 
 select area_name,sum(elec_amount),sum(device_amount),ceil(sum(js_amount)) from tmp_majh_elec_0423_01 group by area_name
