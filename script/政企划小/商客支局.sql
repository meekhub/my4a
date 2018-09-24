select * from dim.dim_city_no a where area_no='720' and city_desc like '%桃城%';

create table dim.tmp_majh_sk_hx_2
(
area_desc varchar2(20),
city_desc varchar2(30),
huaxiao_name varchar2(100),
huaxiao_type_name varchar2(50)
);


--整理
select a.* from tmp_majh_sk_hx_2 a,dim.dim_area_no b,dim.dim_city_no c
where a.area_desc=b.area_desc(+) 
and a.city_desc=c.city_desc(+)
and c.city_desc is null; 


--划小单元
create table dim.dim_hx_sk as
select * from dim.dim_huaxiao_info where 1=2;


insert into dim.dim_hx_sk
select area_no,city_no,
substr(city_no_new,1,5)||'0'||substr(city_no_new,6,2)||lpad('8'||to_char(rn),3,'0')||'0000'
 as huaxiao_no,
huaxiao_name,
'05' huaxiao_type,
--huaxiao_level,
'商客支局' huaxiao_type_name,
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
b.area_no,c.city_no,d.city_no_new,a.huaxiao_name,a.huaxiao_type_name
 from tmp_majh_sk_hx_2 a,dim.dim_area_no b,dim.dim_city_no c,
 (select f_area_id as city_no_new,f_area_name as city_name,'018'||f_city_code as city_no_old from dsg_stage.om_area_t t where t.F_AREA_LEVEL=4)d
where a.area_desc=b.area_desc
and a.city_desc=c.city_desc 
and b.area_no=c.area_no
and c.city_no=d.city_no_old)x)

;
--小区和支局
create table dim.tmp_majh_sk_hx_3
(
area_desc varchar2(20),
city_desc varchar2(50),
std_addr varchar2(200),
huaxiao_name varchar2(80),
huaxiao_type  varchar2(20)
)


create table dim.tmp_majh_sk_hx_4 as 
select 
t.*,x.xiaoqu_no,x.xiaoqu_name
 from 
(select area_desc,city_desc,huaxiao_name,
replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(std_addr,'-',''),'/',''),
'河北省','河北'),'邢台市','邢台'),'石家庄市','石家庄'),'秦皇岛市','秦皇岛'),'廊坊市','廊坊'),'邯郸市','邯郸'),'保定市','保定'),
'衡水市','衡水') std_addr 
from tmp_majh_sk_hx_3) t,
(select distinct xiaoqu_no,xiaoqu_name, replace(stdaddr_name,'/','') as std_addr from alldmcode.dmcode_xiaoqu_std_addr_new) x
where t.std_addr=x.std_addr(+)
and x.std_addr is not null

create table dim_hx_sk_xiaoqu as
select * from dim.dim_xiaoqu_huaxiao where 1=2;


insert into dim_hx_sk_xiaoqu
select
b.area_no,
b.city_no,
a.xiaoqu_no,
a.xiaoqu_name,
b.huaxiao_no,
b.huaxiao_name,
b.huaxiao_type,
b.huaxiao_type_name,
b.if_valid,
b.update_user,b.update_date,b.idx_no,b.huaxiao_type_big,b.huaxiao_type_name_big
 from dim.tmp_majh_sk_hx_4 a,dim_hx_sk b,dim.dim_area_no c,dim.dim_city_no d
where a.area_desc=c.area_desc
and a.city_desc=d.city_desc
and a.huaxiao_name=b.huaxiao_name
and c.area_no=d.area_no;


--渠道与支局
create table tmp_majh_sk_hx_5
(
area_desc varchar2(20),
city_desc varchar2(50), 
channel_no varchar2(50), 
channel_no_desc varchar2(200), 
huaxiao_name varchar2(50)
)


create table dim_hx_sk_channel as
select * from dim.dim_channel_huaxiao where 1=2;


insert into dim_hx_sk_channel
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
b.update_user,b.update_date,b.idx_no,b.huaxiao_type_big,b.huaxiao_type_name_big
 from tmp_majh_sk_hx_5 a,dim_hx_sk b,dim.dim_area_no c,dim.dim_city_no d
where a.area_desc=c.area_desc
and a.city_desc=d.city_desc
and a.huaxiao_name=b.huaxiao_name
and c.area_no=d.area_no;


--导出
select 
a.area_no,b.area_desc,a.city_no,c.city_desc,a.huaxiao_no,a.huaxiao_name,a.huaxiao_type,a.huaxiao_type_name
 from dim.dim_hx_sk a,dim.dim_area_no b,dim.dim_city_no c
where a.area_no=b.area_no
and a.city_no=c.city_no;


--渠道对应关系
select 
a.area_no,b.area_desc,a.city_no,c.city_desc,a.huaxiao_no,a.huaxiao_name,a.channel_no,a.channel_no_desc,a.huaxiao_type,a.huaxiao_type_name
 from dim.dim_hx_sk_channel a,dim.dim_area_no b,dim.dim_city_no c
where a.area_no=b.area_no
and a.city_no=c.city_no;



--小区对应关系

select 
a.area_no,b.area_desc,a.city_no,c.city_desc,a.huaxiao_no,a.huaxiao_name,a.xiaoqu_no,a.xiaoqu_name,a.huaxiao_type,a.huaxiao_type_name
 from dim.dim_hx_sk_xiaoqu a,dim.dim_area_no b,dim.dim_city_no c
where a.area_no=b.area_no
and a.city_no=c.city_no;


select distinct 
a.area_desc,
a.city_desc,
a.std_addr,
a.huaxiao_name,
nvl(b.huaxiao_no,'生成编码失败'),
b.xiaoqu_no,
b.xiaoqu_name
 from dim.tmp_majh_sk_hx_3 a,
dim.tmp_majh_sk_hx_4 x,
(
select 
a.area_no,b.area_desc,a.city_no,c.city_desc,a.huaxiao_no,a.huaxiao_name,a.xiaoqu_no,a.xiaoqu_name,a.huaxiao_type,a.huaxiao_type_name
 from dim.dim_hx_sk_xiaoqu a,dim.dim_area_no b,dim.dim_city_no c
where a.area_no=b.area_no
and a.city_no=c.city_no
)b
where 
a.area_desc=x.area_desc(+)
and a.city_desc=x.city_desc(+)
and a.std_addr=x.std_addr(+) 
and x.area_desc=b.area_desc(+)
and x.city_desc=b.city_desc(+)
and x.huaxiao_name=b.huaxiao_name(+)
and x.xiaoqu_no=b.xiaoqu_no(+)



