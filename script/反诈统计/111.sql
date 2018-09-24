SELECT *
  FROM DW_V_USER_CDR_CDMA_OCS
 WHERE ACCT_MONTH = '201710'
   AND ROAM_AREA_CODE = '384'
   
   
create table tmp_majh_qizha_1121_01
(
device_integer varchar(20)
)

truncate table tmp_majh_qizha_1121_01

insert into tmp_majh_qizha_1121_01
{
select * from temp_user.tmp_majh_qizha_1121_01
}@hbdw


create table tmp_majh_qizha_1121_02
(
device_integer varchar(30),
innet_date varchar(30),
area_no_desc varchar(300),
city_no_desc varchar(300),
user_dinner varchar(30),
user_dinner_desc varchar(300),
channel_no varchar(30),
channel_no_desc varchar(300),
is_onnet  varchar(30)
)

select count(*) from tmp_majh_qizha_1121_01

truncate table tmp_majh_qizha_1121_02

insert into tmp_majh_qizha_1121_02
select 
a.device_integer,
innet_date,
area_no_desc,
city_no_desc,
user_dinner,
user_dinner_desc,
channel_no,
channel_no_desc,
is_onnet
 from tmp_majh_qizha_1121_01 a
 left join
(select 
* from (select 
device_integer,innet_date,is_onnet,area_no_desc,city_no_desc,user_dinner,user_dinner_desc,channel_no,channel_no_desc,
row_integer()over(partition by device_integer order by innet_date desc)rn  from dw_v_user_base_info_day 
where acct_day='20171120'
and tele_type='2') where rn=1)b
on a.device_integer = b.device_integer


select * from dw_v_user_base_info_day where acct_day='20171120'

select * from tmp_majh_qizha_1121_02


drop table tmp_majh_qizha_1121_03
create table tmp_majh_qizha_1121_03
(
device_integer varchar(30),
innet_date varchar(30),
area_no_desc varchar(300),
city_no_desc varchar(300),
user_dinner varchar(30),
user_dinner_desc varchar(300),
channel_no varchar(30),
channel_no_desc varchar(300),
is_onnet  varchar(30)
)

insert into tmp_majh_qizha_1121_03
select 
device_integer,innet_date,area_no_desc,city_no_desc,user_dinner,user_dinner_desc,channel_no,channel_no_desc,is_onnet
from dw_v_user_base_info_day
where acct_day='20171120'
and tele_type='2' 
and innet_date > = '20170801' and innet_date<='20171121'
and channel_no in 
(
'183564668','183354740','183588572','183585182','183586223'
)
and user_dinner='1394929'


select * from tmp_majh_qizha_1121_03


create table TMP_MAJH_LONGYAN_1121_01
(
day_id varchar(20),
DEVICE_integer varchar(20),
area_no varchar(20),
zhu_call_cdr integer,
bei_call_cdr integer,
bei_user_cnt integer,
cell_no varchar(60)
)

truncate table TMP_MAJH_LONGYAN_1121_01

     INSERT INTO TMP_MAJH_LONGYAN_1121_01
        SELECT '201710' V_MONTH,
               DEVICE_integer,
               AREA_NO,
               SUM(CASE
                     WHEN ORG_TRM_ID = '10' THEN
                      1
                     ELSE
                      0
                   END),
               SUM(CASE
                     WHEN ORG_TRM_ID = '11' THEN
                      1
                     ELSE
                      0
                   END),
               COUNT(DISTINCT case when ORG_TRM_ID = '10' then OPPOSE_integer end),
               CELL_NO
          FROM DW_V_USER_CDR_CDMA_OCS
         WHERE ACCT_MONTH = '201710'  
           AND ROAM_AREA_CODE = '384'
         GROUP BY AREA_NO,DEVICE_integer, CELL_NO
        UNION ALL
        SELECT '201710' V_MONTH,
               DEVICE_integer,
               AREA_NO,
               SUM(CASE
                     WHEN ORG_TRM_ID = '10' THEN
                      1
                     ELSE
                      0
                   END),
               SUM(CASE
                     WHEN ORG_TRM_ID = '11' THEN
                      1
                     ELSE
                      0
                   END),
               COUNT(DISTINCT case when ORG_TRM_ID = '10' then OPPOSE_integer end),
               CELL_NO
          FROM DW_V_USER_CDR_CDMA
         WHERE ACCT_MONTH = '201710'  
           AND ROAM_AREA_CODE = '384'
         GROUP BY AREA_NO,DEVICE_integer, CELL_NO;


select * from TMP_MAJH_LONGYAN_1121_01


--是否使用过流量
drop table TMP_MAJH_LONGYAN_1121_02
create table TMP_MAJH_LONGYAN_1121_02
(
area_desc	varchar(20),
device_integer	varchar(20),
zhu_call_cdr	integer,
bei_call_cdr	integer,
bei_user_cnt	integer,
lisan_rate	integer,
is_c	varchar(20)
)

insert into TMP_MAJH_LONGYAN_1121_02
{
select * from temp_user.TMP_MAJH_LONGYAN_1121_05
}@hbdw


create table TMP_MAJH_LONGYAN_1121_03
(
area_desc	varchar(20),
device_integer	varchar(20),
zhu_call_cdr	integer,
bei_call_cdr	integer,
bei_user_cnt	integer,
lisan_rate	integer,
is_c	varchar(20),
is_flux varchar(20)
)

insert into TMP_MAJH_LONGYAN_1121_03
select 
a.area_desc, 
a.device_integer, 
a.zhu_call_cdr, 
a.bei_call_cdr, 
a.bei_user_cnt, 
a.lisan_rate, 
a.is_c,
case when b.ALL_JF_FLUX>0 then '是' else '否' end is_flux
from TMP_MAJH_LONGYAN_1121_02 a
left join
(
select 
device_number,ALL_JF_FLUX
from dw_v_user_base_info_user
where acct_month='201710'
and tele_type='2' 
and is_onnet='是'
)b
on a.device_integer=b.device_number

