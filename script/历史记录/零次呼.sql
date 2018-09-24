SELECT  *
                 FROM DW_V_USER_CDR_CDMA_ocs B,tmp_majh_0824 a
                WHERE ACCT_MONTH >='201701'
                and roam_type<>'10'
                and a.cell_no=b.cell_no;
                
drop table tmp_majh_0824_06
create table tmp_majh_0824_06
(
device_number varchar(30),
org_trm_id varchar(10)
)

13393051690	
13363200230	



insert into tmp_majh_0824_06
SELECT  
device_number,org_trm_id
   FROM DW_V_USER_CDR_CDMA B 
                WHERE ACCT_MONTH ='201702'
                and roam_type<>'10'  
                and roam_area_code='189'
                --and org_trm_id='10'
                

select distinct a.device_number from 
(select * from tmp_majh_0824_06 where org_trm_id='11')a
left join
(select * from tmp_majh_0824_06 where org_trm_id='10')b
on a.device_number=b.device_number 
and b.device_number is null            


select * from tmp_majh_0824_06 where device_number='13363200230'


select * from dw_v_user_base_info_user where acct_month='201707'
and is_onnet='是'
and tele_type='2'
and device_number in
(
'18131408112',	
'18131402136',	
'18903141325',	
'18031422513',	
'18131402692',	
'13315888388',	
'13393051690',	
'13363200230',	
'18131402413',	
'18103244409'
)                

select * from tmp_majh_0824_04;

truncate table tmp_majh_0824_04
create table tmp_majh_0824_04
(
device_number varchar(30)
);

select * from tmp_majh_0824_04


--国际漫游
drop table tmp_majh_0826_01
create table tmp_majh_0826_03
(
device_number varchar(20),
org_trm_id varchar(20),
cdr_num integer,
roam_num integer
)

truncate table tmp_majh_0826_01;

insert into tmp_majh_0826_01
SELECT  
device_number,org_trm_id,count(*)cdr_num,
sum(case when roam_type='13' then 1 else 0 end)roam_num
   FROM DW_V_USER_CDR_CDMA B 
                WHERE ACCT_MONTH ='201706' 
group by device_number,org_trm_id
having sum(case when roam_type='13' then 1 else 0 end)>0

drop table tmp_majh_0826_03
create table tmp_majh_0826_03
(
device_number varchar(20), 
cdr_num integer,
zhu_cdr_num integer,
roam_num integer,
zhu_roam_num integer
)

insert into tmp_majh_0826_03
select device_number,sum(cdr_num),
sum(case when org_trm_id='10' then cdr_num else 0 end)zhu_cdr_num,
sum(roam_num),
sum(case when org_trm_id='10' then roam_num else 0 end)zhu_roam_num
from
(select * from tmp_majh_0826_01
union all
select * from tmp_majh_0826_02)
group by device_number ;

select b.area_no,a.*
from 
(select * from tmp_majh_0826_03 where 
zhu_roam_num/roam_num > 0.8)a
join
(
select area_no,device_number from dw_v_user_base_info_user 
where acct_month='201707'
and tele_type='2'
and is_onnet='是'
)b
on a.device_number=b.device_number



--零次呼

select count(*) from tmp_majh_0826_03 where zhu_roam_num=0 and roam_num>0
and (roam_num-zhu_roam_num)/(cdr_num-zhu_cdr_num)>0.8




