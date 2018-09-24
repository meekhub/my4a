select * from xxhb_mjh.tmp_majh_0418_sk t;

create table xxhb_mjh.tmp_majh_0418_sk_bak as
select * from xxhb_mjh.tmp_majh_0418_sk;


delete from xxhb_mjh.tmp_majh_0418_sk;

select count(*),count(distinct user_no) from xxhb_mjh.tmp_majh_0418_sk

create table xxhb_mjh.tmp_majh_0418_sk_cl as
select a.* from xxhb_mjh.tmp_majh_0418_sk a,
(select user_no from dw.dw_v_user_base_info_user b
where acct_month='201712'
and to_char(innet_date,'yyyymm')<='201712')b
where a.user_no=b.user_no


select count(*) from xxhb_mjh.tmp_majh_0418_sk_cl

insert into xxhb_mjh.tmp_majh_0418_sk
select * from xxhb_mjh.tmp_majh_0418_sk_cl


update xxhb_mjh.tmp_majh_0418_sk set is_cl='1';


create table xxhb_mjh.tmp_majh_0418_sk_2 as
select * from xxhb_mjh.tmp_majh_0418_sk where 1=2


update xxhb_mjh.tmp_majh_0418_sk_2 set device_number='0'||device_number where device_number like '3%'


update xxhb_mjh.tmp_majh_0418_sk_2 set area_no=trim(area_no),user_no=trim(user_no)

update xxhb_mjh.tmp_majh_0418_sk_2 set area_no=case when area_no like '188%' then 'Ê¯¼Ò×¯' else area_no end


select * from xxhb_mjh.tmp_majh_0418_sk_2 

insert into xxhb_mjh.tmp_majh_0418_sk
select b.area_no,a.huaxiao_no,a.device_number,a.user_no,'0' from xxhb_mjh.tmp_majh_0418_sk_2 a,dim.dim_area_no b
where a.area_no=b.area_desc

update xxhb_mjh.tmp_majh_0418_sk_2 set area_no=replace(area_no,'    ','')

select a.* from xxhb_mjh.tmp_majh_0418_sk_2 a,dim.dim_area_no b
where a.area_no=b.area_desc(+)
and b.area_desc is null


