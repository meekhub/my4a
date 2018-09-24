create table tmp_majh_0908_07 
(
device_number varchar(20),
call_duration integer,
oppose_number varchar(20)
)

insert into tmp_majh_0908_07
select 
b.device_number,b.CALL_DURATION,b.oppose_number
 from 
(select *  from tmp_majh_0908_06 where reserv3='电信')a
left join
(SELECT device_number,CALL_DURATION,oppose_number FROM DW_V_USER_CDR_CDMA_OCS B
                WHERE ACCT_MONTH ='201708' )b
on a.reserv1=b.device_number;


select * from   tmp_majh_0908_01 where device_number is not null;

create table tmp_majh_0908_09 
(
device_number varchar(20),
oppose_number varchar(20),
call_duration integer
)

insert into tmp_majh_0908_09
select device_number,oppose_number,sum(call_duration) from 
(
select * from tmp_majh_0908_07
union all
select * from tmp_majh_0908_08
)
where device_number is not null
group by device_number,oppose_number;

select * from tmp_majh_0906_02

select count(*) from tmp_majh_0908_06

select 
distinct area_no,city_no,cell_phone,device_number,oppose_number,call_duration
 from tmp_majh_0908_09 a,tmp_majh_0908_06 b
where a.oppose_number=b.reserv1 and call_duration>0


--汇总数据统计 
select count(distinct reserv1) from 
tmp_majh_0908_06
where substr(reserv1,1,3) not in ('133','153','180','177','181','189','173')


--有通话行为的本网
select sum(call_duration)/60/count(*) from 
--select device_number,oppose_number,ceil(call_duration/60) from 
(select 
distinct area_no,city_no,cell_phone,device_number,oppose_number,call_duration
 from tmp_majh_0908_09 a,tmp_majh_0908_06 b
where a.oppose_number=b.reserv1 and call_duration>0) 
where substr(device_number,1,3) in ('133','153','180','177','181','189','173')
and substr(oppose_number,1,3) not in ('133','153','180','177','181','189','173')

--异网
select 
sum(call_duration)/60,count(distinct oppose_number)
 from 
(select 
distinct area_no,city_no,cell_phone,device_number,oppose_number,call_duration
 from tmp_majh_0908_09 a,tmp_majh_0908_06 b
where a.oppose_number=b.reserv1 and call_duration>0) 
where substr(device_number,1,3) in ('133','153','180','177','181','189','173')
and substr(oppose_number,1,3) not in ('133','153','180','177','181','189','173')

整个宽带：1000	
本网号码共有：1695	 
异网号码：3138
本网与异网平均通话：16分钟


异网：3555/180=19分钟 
19/0.18=105


--提取异网号码
--异网
create table tmp_majh_0913_01
(
oppose_number varchar(30)
)

insert into tmp_majh_0913_01
select 
distinct oppose_number
 from 
(select 
distinct area_no,city_no,cell_phone,device_number,oppose_number,call_duration
 from tmp_majh_0908_09 a,tmp_majh_0908_06 b
where a.oppose_number=b.reserv1 and call_duration>0)  
where substr(oppose_number,1,3) not in ('133','153','180','177','181','189','173')

create table tmp_majh_0913_02
(
oppose_number varchar(30),
CALL_DURATION integer
)


insert into tmp_majh_0913_02
select 
a.oppose_number,b.CALL_DURATION
 from tmp_majh_0913_01 a
left join
(SELECT device_number,CALL_DURATION,oppose_number FROM DW_V_USER_CDR_CDMA_OCS B
                WHERE ACCT_MONTH ='201708' )b
on a.oppose_number = b.oppose_number             


insert into tmp_majh_0913_02
select 
a.oppose_number,b.CALL_DURATION
 from tmp_majh_0913_01 a
left join
(SELECT device_number,CALL_DURATION,oppose_number FROM DW_V_USER_CDR_CDMA B
                WHERE ACCT_MONTH ='201708' )b
on a.oppose_number = b.oppose_number  



select oppose_number, sum(call_duration) from tmp_majh_0913_02 where call_duration>0
group by oppose_number










