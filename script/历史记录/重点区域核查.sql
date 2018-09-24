create table tmp_majh_qizha_0908_01
(
device_number varchar(20),
call_duration integer,
ORG_TRM_ID varchar(10),
roam_area_no varchar(10)
)

drop table tmp_majh_qizha_0908_01
insert into tmp_majh_qizha_0908_01
SELECT DEVICE_NUMBER,
call_duration,ORG_TRM_ID,ROAM_AREA_CODE
                 FROM DW_V_USER_CDR_CDMA_OCS B
                WHERE ACCT_MONTH in ('201708','201707','201706')
                and ROAM_AREA_CODE in ('305','384','757','771','713','791','568','591','503','825')
                
drop table tmp_majh_qizha_0908_03
create table tmp_majh_qizha_0908_03
(
device_number varchar(20),
roam_area_no  varchar(20),
call_cdr integer,
zhu_call_cdr integer,
call_duration integer,
zhu_call_duration integer
)

truncate table tmp_majh_qizha_0908_03
insert into tmp_majh_qizha_0908_03                
select 
DEVICE_NUMBER,roam_area_no,count(*)call_cdr,sum(case when org_trm_id='10' then 1 else 0 end)zhu_call_cdr,
sum(call_duration)call_duration,
sum(case when org_trm_id='10' then call_duration else 0 end)zhu_call_duration
 from 
(               
select * from  tmp_majh_qizha_0908_01
union all
select * from  tmp_majh_qizha_0908_02 
)     
group by  DEVICE_NUMBER,roam_area_no    


create table tmp_majh_qizha_06
(
area_no_desc varchar(20),
city_no_desc varchar(200),
channel_no_desc varchar(2000),
user_dinner_desc varchar(2000),
user_status_desc varchar(60),
device_number  varchar(20),
roam_area varchar(60), 
call_cdr integer,
zhu_call_cdr integer,
call_duration integer,
zhu_call_duration integer
)

insert into tmp_majh_qizha_06
select 
b.*,
case when a.roam_area_no='305' then '���պϷ���' 
when a.roam_area_no='384' then '����������' 
when a.roam_area_no='757' then '����ʡ�����������' 
when a.roam_area_no='771' then '����פ������ϲ���' 
when a.roam_area_no='713' then '����������' 
when a.roam_area_no='791' then '����ʡ¦����˫����' 
when a.roam_area_no='568' then '�㶫ï����' 
when a.roam_area_no='591' then '���������б�����' 
when a.roam_area_no='503' then '����������' 
when a.roam_area_no='825' then '�Ĵ�������' 
end roam_area,
call_cdr,zhu_call_cdr,call_duration,zhu_call_duration
 from tmp_majh_qizha_0908_03 a
join
(
select 
area_no_desc,city_no_desc,channel_no_desc,user_dinner_desc,user_status_desc,device_number
 from dw_v_user_base_info_user where acct_month='201708'
and tele_type='2'
and is_onnet='��'
)b on a.device_number=b.device_number;

select * from tmp_majh_qizha_06

select roam_area,count(*) from tmp_majh_qizha_06 where zhu_call_cdr/call_cdr>0.9 and call_cdr>39
group by roam_area













