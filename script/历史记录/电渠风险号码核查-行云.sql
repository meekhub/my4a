create table tmp_majh_dianqu_risk
(
idx_no varchar(20),
device_number varchar(30),
flag varchar(2)
)

drop table tmp_majh_dianqu_risk_2
create table tmp_majh_dianqu_risk_2
(
idx_no varchar(20),
device_number varchar(30),
flag varchar(2),
user_status_desc varchar(100),
is_onnet varchar(4),
is_ocs varchar(4),
area_desc varchar(10)


insert into tmp_majh_dianqu_risk
{
select * from temp_user.tmp_majh_dianqu_risk
}@hbdw

select * from tmp_majh_dianqu_risk_2

--用户状态
insert into tmp_majh_dianqu_risk_2
select 
a.*,user_status_desc,is_onnet,is_ocs,area_no_desc
 from tmp_majh_dianqu_risk a
left join
(select * from (SELECT B.*,
               ROW_NUMBER() OVER(PARTITION BY b.DEVICE_NUMBER ORDER BY b.INNET_DATE DESC) RN
          FROM (SELECT device_number,area_no_desc,is_ocs,user_status_desc,is_onnet,innet_date
                  FROM DW_V_USER_BASE_INFO_USER B
                 WHERE B.ACCT_MONTH = '201706' 
                   AND B.TELE_TYPE = '2') B)
 WHERE RN = 1)b
on a.device_number=b.device_number

create table tmp_majh_longyan_roam
(
acct_month varchar(10),
device_number varchar(20),
roam_num integer
)

--龙岩
insert into tmp_majh_longyan_roam
SELECT 
acct_month,device_number,count(*)
   FROM DW_V_USER_CDR_CDMA_OCS
              WHERE ACCT_MONTH = '201706'
                AND ROAM_AREA_CODE='384'
group by acct_month,device_number                


select * from tmp_majh_dianqu_risk_2 a, tmp_majh_longyan_roam b
where a.device_number=b.device_number


select * from tmp_majh_dianqu_risk_2 a, TMP_MAJH_QIZHA_01 b
where a.device_number=b.device_number

drop table tmp_majh_dianqu_3

create table tmp_majh_dianqu_3
(
idx_no varchar(10),
area_desc varchar(20),
device_number varchar(20),
user_status_desc varchar(60),
is_onnet varchar(10),
is_ocs varchar(10),
roam_num integer,
is_risk varchar(20),
flag varchar(2)
)

truncate table tmp_majh_dianqu_3
--输出
insert into tmp_majh_dianqu_3
select 
a.idx_no,
a.area_desc,
a.device_number,
a.user_status_desc,
a.is_onnet,
a.is_ocs, 
nvl(b.roam_num,0)roam_num,
case when c.device_number is not null then '是' else '否' end is_risk,
a.flag
 from (select * from  tmp_majh_dianqu_risk_2)a
left join 
(select device_number,sum(roam_num)roam_num from tmp_majh_longyan_roam group by device_number) b
on a.device_number=b.device_number
left join TMP_MAJH_QIZHA_01 c
on a.device_number=c.device_number 


--1-7月电渠新发展
create table tmp_majh_ecir_0808
(
device_number varchar(20),
is_onnet varchar(20),
user_status_desc varchar(40),
channel_no_desc  varchar(200),
is_ocs  varchar(20)
)

insert into tmp_majh_ecir_0808
select device_number,is_onnet,user_status_desc,channel_no_desc,is_ocs from dw_v_user_base_info_user 
where acct_month='201707'
and innet_date >='20170101'
and innet_date <= '20170731'
and tele_type='2'
and channel_type like '12%';

select * from tmp_majh_ecir_0808

create table tmp_majh_ecir_0808_2
(
device_number varchar(20),
roam_num integer
)

insert into tmp_majh_ecir_0808_2
select 
a.device_number,SUM(CASE WHEN b.device_number IS NOT NULL THEN 1 ELSE 0 END)
 from tmp_majh_ecir_0808 a
join
(
SELECT 
acct_month,device_number
   FROM DW_V_USER_CDR_CDMA_OCS
              WHERE ACCT_MONTH = '201706'
                AND ROAM_AREA_CODE='384'
)b
on a.device_number=b.device_number
group by a.device_number;

truncate table tmp_majh_ecir_0808_2

select * from tmp_majh_ecir_0808_2 where roam_num>0



--导出
select 
device_number 手机号,
is_onnet 是否在网,
user_status_desc 当前状态,
channel_no_desc 入网渠道,
is_ocs 是否预付费
 from tmp_majh_ecir_0808




--7月漫游龙岩号码
create table tmp_majh_ecir_0808_3
(
device_number varchar(20),
roam_num integer
)

insert into tmp_majh_ecir_0808_3
select device_number,count(*)
from 
(SELECT 
device_number
   FROM DW_V_USER_CDR_CDMA_OCS
              WHERE ACCT_MONTH = '201707'
                AND ROAM_AREA_CODE='384'
union all
SELECT 
device_number
   FROM DW_V_USER_CDR_CDMA
              WHERE ACCT_MONTH = '201707'
                AND ROAM_AREA_CODE='384' 
                )              
group by device_number;


select 
a.device_number,b.is_onnet,b.innet_date,b.user_status_desc,b.channel_no_desc,b.user_dinner_desc,a.roam_num
 from tmp_majh_ecir_0808_3 a
left join
(select * from (SELECT B.*,
               ROW_NUMBER() OVER(PARTITION BY b.DEVICE_NUMBER ORDER BY b.INNET_DATE DESC) RN
          FROM (SELECT device_number,area_no_desc,channel_no_desc,user_dinner_desc,is_ocs,user_status_desc,is_onnet,innet_date
                  FROM DW_V_USER_BASE_INFO_USER B
                 WHERE B.ACCT_MONTH = '201707' 
                   AND B.TELE_TYPE = '2') B)
 WHERE RN = 1)b
 on a.device_number=b.device_number












