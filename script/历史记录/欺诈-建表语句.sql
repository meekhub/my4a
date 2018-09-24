create table TMP_MAJH_QIZHA_02_pre_187
(
DEVICE_NUMBER varchar(20),
ZHU_CALL_DURATION integer,
CALL_DURATION integer,
ZHU_CALL_CDR integer,
CALL_CDR integer,
CALL_USERS integer,
CALL_DAYS integer,
LOWER_15_CDR integer,
LOWER_60_CDR integer,
ROAM_DURATION integer,
LONG_DURATION integer
)



drop table TMP_MAJH_QIZHA_04
create table TMP_MAJH_QIZHA_04
(
DEVICE_NUMBER VARCHAR(20),
IS_CERT VARCHAR(20),
TOTAL_FEE double,
IS_TRANS VARCHAR(20),
INNET_MONTH VARCHAR(20),
IS_OCS VARCHAR(20),
channel_no VARCHAR(20),
terminal_corp VARCHAR(200),
terminal_model VARCHAR(200),
terminal_code varchar(50),
user_dinner VARCHAR(20),
is_risk_dinner  VARCHAR(20),
is_cert_1_n   VARCHAR(20)
);

drop table TMP_MAJH_QIZHA_04_pre
create table TMP_MAJH_QIZHA_04_pre_187
(
area_no varchar(20),
area_no_desc varchar(20),
city_no varchar(30),
city_no_desc varchar(60),
DEVICE_NUMBER VARCHAR(20),
IS_CERT VARCHAR(20),
TOTAL_FEE double,
IS_TRANS VARCHAR(20),
INNET_MONTH VARCHAR(20),
IS_OCS VARCHAR(20),
channel_no VARCHAR(20),
terminal_corp VARCHAR(200),
terminal_model VARCHAR(200),
terminal_code varchar(30),
user_dinner VARCHAR(20),
is_risk_dinner  VARCHAR(20),
is_cert_1_n VARCHAR(20)
);

create table TMP_MAJH_QIZHA_04
(
DEVICE_NUMBER VARCHAR(20),
IS_CERT VARCHAR(20),
TOTAL_FEE double
);

drop table TMP_MAJH_QIZHA_04;


select * from TMP_MAJH_QIZHA_04

create table TMP_MAJH_QIZHA_03
(
device_number varchar(20),
zhu_call_duration integer,
call_duration integer,
zhu_call_cdr integer,
call_cdr       integer,
call_users     integer,
call_days      integer,
lower_15_cdr   integer,
lower_60_cdr   integer,
roam_duration  integer,
long_duration  integer
)

create table TMP_MAJH_QIZHA_03_ZC
(
device_number varchar(20),
zhu_call_duration integer,
call_duration integer,
zhu_call_cdr integer,
call_cdr       integer,
call_users     integer,
call_days      integer,
lower_15_cdr   integer,
lower_60_cdr   integer,
roam_duration  integer,
long_duration  integer
)


--代理商黑名单
create table tmp_majh_qizha_black_channel
(
channel_no varchar(20),
channel_level varchar(4)
)

--低价值终端
create table tmp_majh_qizha_low_terminal
(
terminal_corp varchar(100),
terminal_model varchar(60)
)

insert into tmp_majh_qizha_black_channel
{
select * from alldm.tmp_majh_qizha_black_channel
}@hbdw


truncate table tmp_majh_qizha_zc
insert into tmp_majh_qizha_zc
{
select * from alldm.tmp_majh_qizha_zc
}@hbdw


create table tmp_majh_qizha_oppose_number
(
device_number varchar(20)
)


--通话最多的基站
create table tmp_majh_qizha_cellmax
(
device_number varchar(20),
cell_rate double
)

create table tmp_majh_qizha_cellmax_pre_187
(
device_number varchar(20),
cell_rate double
)


SELECT DEVICE_NUMBER,oppose_number,b.cell_no,b.call_duration
                 FROM DW_V_USER_CDR_CDMA B
                WHERE ACCT_MONTH ='201702'
                
                


select count(*) from tmp_majh_qizha_cellmax where cell_rate is not null   

select * from TMP_MAJH_QIZHA_04

truncate table TMP_MAJH_QIZHA_02



select * from TMP_MAJH_QIZHA_04 where is_trans='1';


select * from tmp_majh_qizha_oppose_number

drop table  tmp_majh_qizha_hz_01_pre

create table tmp_majh_qizha_hz_01_pre_187
(
acct_month varchar(20),
area_no varchar(20),
area_no_desc varchar(20),
city_no varchar(30),
city_no_desc varchar(60),
device_number varchar(20),
INNET_MONTH  varchar(20),
is_risk_channel  varchar(20),
call_duration integer,
call_cdr integer,
zhu_dur_rate double,
zhu_cdr_rate double,
zhu_users_rate double,
zhu_per_dur double,
lower_60_rate double,
lower_15_rate double,
roam_dur_rate double,
long_dur_rate double,
total_fee double,
call_mon_rate double,
is_trans  varchar(20),
is_ocs  varchar(20),
cell_rate double,
is_link_risk  varchar(20),
is_reg_risk  varchar(20),
is_dinner_risk varchar(20),
is_low_terminal  varchar(20),
is_cert_1_n   varchar(20)
)

drop table tmp_majh_qizha_hz_01_zc
create table tmp_majh_qizha_hz_01_zc
(
device_number varchar(20),
INNET_MONTH  varchar(20),
is_risk_channel  varchar(20),
call_duration integer,
call_cdr integer,
zhu_dur_rate double,
zhu_cdr_rate double,
zhu_users_rate double,
zhu_per_dur integer,
lower_60_rate double,
lower_15_rate double,
roam_dur_rate double,
long_dur_rate double,
total_fee double,
call_mon_rate double,
is_trans  varchar(20),
is_ocs  varchar(20),
cell_rate double,
is_link_risk  varchar(20)
)
truncate table tmp_majh_qizha_hz_01


--正常用户
drop table tmp_majh_qizha_zc
create table tmp_majh_qizha_zc
(
device_number varchar(20)
)


create table tmp_majh_qizha_out_187
(
device_number varchar(20)
)

create table tmp_majh_qizha_pre_base_187 
(
device_number varchar(20),
is_ocs varchar(2)
)



         
