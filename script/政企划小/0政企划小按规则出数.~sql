dim.dim_zq_xiaoqu_huaxiao;
dim.dim_zq_huaxiao_info;
dim.dim_zq_channel_huaxiao;
dim.dim_zq_group_huaxiao;

create table xxhb_mjh.tmp_majh_sk_0515_01
(
area_desc varchar2(200), 
city_desc varchar2(200), 
xiaoqu_no varchar2(200), 
xiaoqu_name varchar2(200), 
huaxiao_no varchar2(200), 
huaxiao_name varchar2(200), 
STDADDR_NAME varchar2(200)
)

--商客小区划小表
create table dim.dim_zq_xiaoqu_huaxiao_bak as
select * from dim.dim_zq_xiaoqu_huaxiao

delete from dim.dim_zq_xiaoqu_huaxiao

insert into dim.dim_zq_xiaoqu_huaxiao
select 
b.area_no, 
b.city_no, 
nvl(a.xiaoqu_no,'-1'), 
a.xiaoqu_name, 
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
 from xxhb_mjh.tmp_majh_sk_0515_01 a,dim.dim_huaxiao_info b
where a.huaxiao_no=b.huaxiao_no

update dim.dim_zq_xiaoqu_huaxiao set xiaoqu_no=trim(xiaoqu_no),huaxiao_no=trim(huaxiao_no);


--商客渠道划小表
create table dim.dim_hx_sk_channel_bak as
select * from dim.dim_hx_sk_channel


delete from dim.dim_hx_sk_channel

insert into dim_hx_sk_channel

update dim.dim_zq_xiaoqu_huaxiao set xiaoqu_no=trim(xiaoqu_no),huaxiao_no=trim(huaxiao_no);

insert into dim.dim_hx_sk_channel
select 
b.area_no, 
b.city_no, 
a.channel_no, 
a.channel_name, 
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
 from xxhb_mjh.tmp_majh_sk_0515_02 a,dim.dim_huaxiao_info b
where a.huaxiao_no=b.huaxiao_no
































