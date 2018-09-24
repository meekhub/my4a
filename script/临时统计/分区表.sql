create table DW_V_BOX_INFO_M
(
ACCT_MONTH VARCHAR2(20),
area_desc varchar2(300), 
city_desc varchar2(300), 
fgq_name varchar2(3000), 
fgq_id varchar2(300), 
project_id varchar2(300), 
project_desc varchar2(3000), 
fgq_date varchar2(300), 
standard_name varchar2(3000), 
standard_id varchar2(300), 
box_name varchar2(3000), 
box_id varchar2(300), 
dk_number varchar2(300), 
dk_use_number varchar2(300)
)

COMPRESS
partition by list (ACCT_MONTH)
(

  partition PART201801 values ('201801'),
  partition PART201802 values ('200704'),
  partition PART201803 values ('200705'),
  partition PART201804 values ('200706'),
  partition PART201805 values ('200707'),
  partition PART201806 values ('200708'),
  partition PART201807 values ('200709'),
  partition PART201808 values ('200710'),
  partition PART201809 values ('200711'),
  partition PART201810 values ('200712'),
  partition PART201811 values ('200801'),
  partition PART201812 values ('200802'),
  partition PART201901 values ('200803'),
  partition PART200804 values ('200804'),
  partition PART200805 values ('200805'),
  partition PART200806 values ('200806'),
  partition PART200807 values ('200807'),
  partition PART200808 values ('200808'),
  partition PART200809 values ('200809'),
  partition PART200810 values ('200810'),
  partition PART200811 values ('200811')
)
;
comment on table DW_M_USER_NAR_STW
  is '神通王用户月窄表（按帐期分区）';
comment on column DW_M_USER_NAR_STW.ACCT_MONTH
  is '帐期（分区）';
comment on column DW_M_USER_NAR_STW.USER_NO
  is '用户编号';
comment on column DW_M_USER_NAR_STW.IMSI
  is 'IMSI号';
comment on column DW_M_USER_NAR_STW.AREA_NO
  is '地市';
comment on column DW_M_USER_NAR_STW.FLAG
  is '标识 0 为神通王 1 为冬季突击';
