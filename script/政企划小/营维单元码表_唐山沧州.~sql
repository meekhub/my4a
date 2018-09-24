select * from dim.dim_city_no a where area_no='180' and city_desc like '%桥东%';

create table tmp_majh_yw_hx_tscz
(
area_desc varchar2(20),
city_desc varchar2(30),
huaxiao_name varchar2(100),
huaxiao_type_name varchar2(50),
huaxiao_level varchar2(30)
);


--整理
select a.* from tmp_majh_yw_hx_tscz a,dim.dim_area_no b,dim.dim_city_no c
where a.area_desc=b.area_desc(+) 
and a.city_desc=c.city_desc(+)
and c.city_desc is null; 

create table dim.dim_hx_yw_tscz as
select * from dim.dim_huaxiao_info where 1=2;

delete from dim.dim_hx_yw_tscz

select
a.* from
tmp_majh_yw_hx_tscz a,dim.dim_hx_yw_tscz b
where a.huaxiao_name=b.huaxiao_name(+)
and b.huaxiao_name is null

--truncate table dim.dim_hx_yw
insert into dim.dim_hx_yw_tscz
select area_no,city_no,
case when huaxiao_level='四级单元' then substr(city_no_new,1,5)||'0'||substr(city_no_new,6,2)||lpad('7'||to_char(rn),3,'0')||'0000'
when huaxiao_level='三级单元' then substr(city_no_new,1,5)||lpad(to_char(rn),3,'0')||'0000000' 
end 
 as huaxiao_no,
huaxiao_name,
'06' huaxiao_type,
--huaxiao_level,
'营维单元' huaxiao_type_name,
'1' if_valid,
'sf_majh' update_user,
sysdate update_date,
1 idx_no,
'sf_majh' create_user,
sysdate create_date,
'2' huaxiao_type_big,
'政企类' huaxiao_type_big_name,
'' MANAGER_LOGINID,
'' MANAGER_LOGINNAME,
'' MANAGER_TELEPHONE
 from
(select x.*,row_number()over(partition by city_no_new order by 1)rn from 
(select 
b.area_no,c.city_no,d.city_no_new,a.huaxiao_name,a.huaxiao_type_name,a.huaxiao_level
 from tmp_majh_yw_hx_tscz a,dim.dim_area_no b,dim.dim_city_no c,
 (select f_area_id as city_no_new,f_area_name as city_name,'018' || decode(f_city_code,'187056','187057',f_city_code) as city_no_old from dsg_stage.om_area_t t where t.F_AREA_LEVEL=4)d
where a.area_desc=b.area_desc
and a.city_desc=c.city_desc
and b.area_no=c.area_no
and c.city_no=d.city_no_old)x);



--渠道对应
create table tmp_majh_yw_hx_3 
(
area_desc varchar2(20),
city_no varchar2(20),
channel_no varchar2(20),
channel_no_desc varchar2(200),
huaxiao_type varchar2(20),
huaxiao_name varchar2(200)
)


select a.* from tmp_majh_yw_hx_3 a,dim.dim_area_no b,dim.dim_city_no c
where a.area_desc=b.area_desc(+) 
and a.city_no=c.city_desc(+)
and c.city_desc is null; 


--truncate  table tmp_majh_yw_hx_3

select * from tmp_majh_yw_hx_3 a, dim_hx_yw_tscz b,dim.dim_area_no c,dim.dim_city_no d
where a.area_desc=c.area_desc
and a.city_no=d.city_desc
and a.huaxiao_name=b.huaxiao_name
and c.area_no=d.area_no

--比对不上的
select * from tmp_majh_yw_hx_3 t,dim_hx_yw_tscz x
where t.huaxiao_name=x.huaxiao_name(+)
and x.huaxiao_name is null;


create table tmp_yw_replace
(
old_name varchar2(100),
new_name varchar2(100)
);





create table tmp_majh_yw_hx_4 as 
select 
area_desc, 
city_no, 
channel_no, 
channel_no_desc, 
huaxiao_type, 
case when y.old_name is not null then y.new_name else x.huaxiao_name end huaxiao_name
from tmp_majh_yw_hx_3 x,tmp_yw_replace y
where x.huaxiao_name=y.old_name(+)

select * from tmp_majh_yw_hx_4 where huaxiao_name in
(select t.huaxiao_name from tmp_majh_yw_hx_4 t,dim_hx_yw_tscz x
where t.huaxiao_name=x.huaxiao_name(+)
and x.huaxiao_name is null) for update
 

--创建关系表
create table dim_hx_yw_tscz_channel as
select * from dim.dim_channel_huaxiao where 1=2;

insert into dim_hx_yw_tscz_channel
select 
b.area_no,
b.city_no,
a.channel_no,
a.channel_no_desc,
b.huaxiao_no,
b.huaxiao_name,
b.huaxiao_type,
b.huaxiao_type_name,
b.if_valid,
b.update_user,
b.update_date,
b.idx_no,
b.huaxiao_type_big,
b.huaxiao_type_name_big
 from 
tmp_majh_yw_hx_4 a,dim_hx_yw_tscz b,dim.dim_area_no c,dim.dim_city_no d
where a.area_desc=c.area_desc
and a.city_no=d.city_desc
and a.huaxiao_name=b.huaxiao_name
and c.area_no=d.area_no;

update dim_hx_yw_tscz_channel set channel_no=replace(channel_no,' ','')



--导出
select 
a.area_no,b.area_desc,a.city_no,c.city_desc,a.huaxiao_no,a.huaxiao_name,a.huaxiao_type,a.huaxiao_type_name
 from dim_hx_yw_tscz a,dim.dim_area_no b,dim.dim_city_no c
where a.area_no=b.area_no
and a.city_no=c.city_no;
