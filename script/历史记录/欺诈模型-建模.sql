create table TMP_MAJH_QIZHA_01
(
area_no  varchar(20), 
device_number  varchar(20), 
user_status  varchar(20), 
user_status_desc  varchar(200), 
user_dinner  varchar(20), 
user_dinner_desc  varchar(2000), 
innet_date  varchar(20), 
logout_date  varchar(20), 
is_ocs  varchar(4), 
close_date  varchar(20), 
flag  varchar(20), 
is_onnet varchar(10),
rn varchar(20)
)

--代理商黑名单
create table tmp_majh_qizha_black_channel
(
channel_no varchar2(20),
channel_level varchar2(4)
)

--低价值终端
create table tmp_majh_qizha_low_terminal
(
terminal_corp varchar2(100),
terminal_model varchar2(60)
)




DECLARE
  V_CALL_DATE VARCHAR2(100);
  CURSOR V_AREA IS
    SELECT *
      FROM DIM.DIM_AREA_NO
     WHERE AREA_NO <> '018'
       AND AREA_NO = '188'
     ORDER BY IDX_NO;
BEGIN
  FOR V_NUM IN 20170301 .. 20170301 LOOP
    V_CALL_DATE := SUBSTR(TO_CHAR(V_NUM), 7, 2);
    FOR C1 IN V_AREA LOOP
      INSERT INTO TMP_MAJH_QIZHA_01
        SELECT *
          FROM (SELECT C1.AREA_NO,
                       B.DEVICE_NUMBER,
                       B.USER_STATUS,
                       B.USER_STATUS_DESC,
                       B.USER_DINNER,
                       B.USER_DINNER_DESC,
                       to_char(b.innet_date,'yyyymmdd')innet_date,
                       to_char(b.logout_date,'yyyymmdd')logout_date,
                       b.is_ocs,
                       c.close_date,
                       c.flag,
                       b.is_onnet,
                       ROW_NUMBER() OVER(PARTITION BY b.DEVICE_NUMBER ORDER BY INNET_DATE DESC) RN
                  FROM DW.DW_V_USER_BASE_INFO_USER B,
                       TMP_MAJH_QIZHA_DIM_01       C
                 WHERE B.ACCT_MONTH = '201706'
                   AND B.AREA_NO = C1.AREA_NO
                   AND B.TELE_TYPE = '2'
                   AND B.DEVICE_NUMBER = C.DEVICE_NUMBER) X
         WHERE RN = 1;
      COMMIT;
    END LOOP;
  END LOOP;
END;



--原始正样本负样本
select * from tmp_majh_qizha_hz_01 t

create table tmp_majh_qizha_hz_02 as
select * from tmp_majh_qizha_hz_01

select * from tmp_majh_qizha_hz_02 t where t.call_duration=0 and t.call_cdr=0

update  tmp_majh_qizha_hz_02 t set t.zhu_dur_rate=0,
t.zhu_cdr_rate=0,t.zhu_users_rate=0,t.zhu_per_dur=0,
t.lower_60_rate=0,t.lower_15_rate=0,t.roam_dur_rate=0,
t.long_dur_rate=0,t.call_mon_rate=0,t.cell_rate=0
 where t.call_duration=0 and t.call_cdr=0;


--入网时长
select innet_month,count(*) from tmp_majh_qizha_hz_02 where is_risk_user=1 group by innet_month
order by to_number(innet_month)

select innet_month,count(*) from tmp_majh_qizha_hz_02 where is_risk_user=0 group by innet_month
order by to_number(innet_month)


--是否黑名单代理商
--入网时长
select IS_RISK_CHANNEL,count(*) from tmp_majh_qizha_hz_02 where is_risk_user=1 group by IS_RISK_CHANNEL 

select IS_RISK_CHANNEL,count(*) from tmp_majh_qizha_hz_02 where is_risk_user=0 group by IS_RISK_CHANNEL 

--主叫通话时长占比
select ceil(ZHU_DUR_RATE),count(*) from tmp_majh_qizha_hz_02 where is_risk_user=1 group by ceil(ZHU_DUR_RATE) 
select ceil(ZHU_DUR_RATE),count(*) from tmp_majh_qizha_hz_02 where is_risk_user=0 group by ceil(ZHU_DUR_RATE)


--主叫次数占比
select ceil(ZHU_cdr_RATE),count(*) from tmp_majh_qizha_hz_02 where is_risk_user=1 group by ceil(ZHU_cdr_RATE) 
select ceil(ZHU_cdr_RATE),count(*) from tmp_majh_qizha_hz_02 where is_risk_user=0 group by ceil(ZHU_cdr_RATE)

--主叫通话人次占比
select ceil(ZHU_USERS_RATE),count(*) from tmp_majh_qizha_hz_02 where is_risk_user=1 group by ceil(ZHU_USERS_RATE) 
select ceil(ZHU_USERS_RATE),count(*) from tmp_majh_qizha_hz_02 where is_risk_user=0 group by ceil(ZHU_USERS_RATE)

--60秒内通话占比
select ceil(LOWER_60_RATE),count(*) from tmp_majh_qizha_hz_02 where is_risk_user=1 group by ceil(LOWER_60_RATE) 
select ceil(LOWER_60_RATE),count(*) from tmp_majh_qizha_hz_02 where is_risk_user=0 group by ceil(LOWER_60_RATE)

--15秒内通话占比
select ceil(LOWER_15_RATE),count(*) from tmp_majh_qizha_hz_02 where is_risk_user=1 group by ceil(LOWER_15_RATE) 
select ceil(LOWER_15_RATE),count(*) from tmp_majh_qizha_hz_02 where is_risk_user=0 group by ceil(LOWER_15_RATE)


--漫游通话占比
select ceil(ROAM_DUR_RATE),count(*) from tmp_majh_qizha_hz_02 where is_risk_user=1 group by ceil(ROAM_DUR_RATE)

select ceil(ROAM_DUR_RATE),count(*) from tmp_majh_qizha_hz_02 where is_risk_user=0 group by ceil(ROAM_DUR_RATE)

--月通话分布
select ceil(CALL_MON_RATE),count(*) from tmp_majh_qizha_hz_02 where is_risk_user=1 group by ceil(CALL_MON_RATE)

select ceil(CALL_MON_RATE),count(*) from tmp_majh_qizha_hz_02 where is_risk_user=0 group by ceil(CALL_MON_RATE)


--月分月转兑
select is_trans,count(*) from tmp_majh_qizha_hz_02 where is_risk_user=1 group by is_trans

select is_trans,count(*) from tmp_majh_qizha_hz_02 where is_risk_user=0 group by is_trans

--基站集中度
select ceil(cell_rate),count(*) from tmp_majh_qizha_hz_02 where is_risk_user=1 group by ceil(cell_rate)

select ceil(cell_rate),count(*) from tmp_majh_qizha_hz_02 where is_risk_user=0 group by ceil(cell_rate)


--是否拨打过诈骗用户对端号码
select IS_LINK_RISK,count(*) from tmp_majh_qizha_hz_02 where is_risk_user=1 group by IS_LINK_RISK

select IS_LINK_RISK,count(*) from tmp_majh_qizha_hz_02 where is_risk_user=0 group by IS_LINK_RISK


--输出目标用户
SELECT * FROM TMP_MAJH_QIZHA_HZ_02 T WHERE T.ZHU_CDR_RATE>90 AND T.CALL_MON_RATE>2626.67
AND T.ZHU_DUR_RATE>95.6 


