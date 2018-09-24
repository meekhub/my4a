drop table TMP_MAJH_0920_01

create table TMP_MAJH_0920_01
(
area_no varchar(20),
cell_phone varchar(20),
reserv1  varchar(20)
)


insert into tmp_majh_0920_01
{
select * from temp_user.tmp_majh_0920_03
}@hbdw

select * from tmp_majh_0920_01

drop table tmp_majh_0920_03
create table tmp_majh_0920_03
(
area_no varchar(20),
device_number varchar(20),
call_duration integer,
oppose_number varchar(20)
)

insert into tmp_majh_0920_03
select 
a.area_no,b.device_number,b.CALL_DURATION,b.oppose_number
 from 
(select *  from tmp_majh_0920_01)a
left join
(SELECT device_number,CALL_DURATION,oppose_number FROM DW_V_USER_CDR_CDMA_ocs B
                WHERE ACCT_MONTH ='201708' )b
on a.reserv1=b.device_number

drop table tmp_majh_0920_04
create table tmp_majh_0920_04
(
area_no varchar(20),
device_number varchar(20),
oppose_number varchar(20),
call_duration integer
)


insert into tmp_majh_0920_04
select area_no,device_number,oppose_number,sum(call_duration)
from tmp_majh_0920_03 group by area_no,device_number,oppose_number

select 
sum(call_duration)/count(*)
 from tmp_majh_0920_04 a, tmp_majh_0920_01 b
where a.oppose_number=b.reserv1 and a.call_duration>0 
and a.area_no='189'



select count(distinct reserv1) from tmp_majh_0920_01 where
substr(reserv1,1,3) not in ('133','153','180','181','189','177','173') and area_no='183'


--云利効呟利
select 
sum(call_duration)/count(*)
 from tmp_majh_0920_04 a, tmp_majh_0920_01 b
where a.oppose_number=b.reserv1 and a.call_duration>0 
and a.area_no='183'
and substr(a.device_number,1,3)  in ('133','153','180','181','189','177','173')
and substr(a.oppose_number,1,3) not in ('133','153','180','181','189','177','173')



249
1413	


120
1240	



















