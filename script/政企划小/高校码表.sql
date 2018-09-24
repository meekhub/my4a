select * from dim.dim_city_no a where area_no='188' and city_desc like '%�Ŷ�%';

create table tmp_majh_gx_hx_1
(
area_desc varchar2(20),
city_desc varchar2(30),
huaxiao_name varchar2(100),
huaxiao_type_name varchar2(50)
);


dim.dim_huaxiao_info

area_no  varchar2(800)      ����
city_no  varchar2(800)      ����
huaxiao_no  varchar2(800)      ��С��Ԫ����
huaxiao_name  varchar2(800)      ��С��Ԫ����
huaxiao_type  varchar2(800)      ��С��Ԫ����
huaxiao_type_name  varchar2(800)      ��С��Ԫ��������
if_valid  varchar2(800)      �Ƿ���Ч
update_user  varchar2(800)  y    ������
update_date  date  y  sysdate  ����ʱ��
idx_no  number  y    ����
create_user  varchar2(50)	y		������
create_date	date	y		����ʱ��
huaxiao_type_big	varchar2(5)			��С��Ԫ�������
huaxiao_type_name_big	varchar2(20)			��С��Ԫ��������
manager_loginid	varchar2(50)	y		�а���id
manager_loginname	varchar2(100)	y		�а�������
manager_telephone	varchar2(20)	y		�а�����ϵ�绰

--��У֧������
select a.* from tmp_majh_gx_hx_1 a,dim.dim_area_no b,dim.dim_city_no c
where a.area_desc=b.area_desc(+) 
and a.city_desc=c.city_desc(+)
and c.city_desc is null;

create table dim.dim_hx_gx as
select * from dim.dim_huaxiao_info where 1=2;

truncate table dim_hx_gx

insert into dim.dim_hx_gx
select area_no,city_no,substr(city_no_new,1,5)||'0'||substr(city_no_new,6,2)||'05'||to_char(rn)||'0000' as huaxiao_no,
huaxiao_name,
'07' huaxiao_type,
'��У֧��' huaxiao_type_name,
'1' if_valid,
'sf_majh' update_user,
sysdate update_date,
1 idx_no,
'sf_majh' create_user,
sysdate create_date,
'2' huaxiao_type_big,
'������' huaxiao_type_big_name,
'' MANAGER_LOGINID,
'' MANAGER_LOGINNAME,
'' MANAGER_TELEPHONE
 from
(select x.*,row_number()over(partition by city_no_new order by 1)rn from 
(select 
b.area_no,c.city_no,d.city_no_new,a.huaxiao_name,a.huaxiao_type_name
 from tmp_majh_gx_hx_1 a,dim.dim_area_no b,dim.dim_city_no c,
 (select f_area_id as city_no_new,f_area_name as city_name,'018'||f_city_code as city_no_old from dsg_stage.om_area_t t where t.F_AREA_LEVEL=4)d
where a.area_desc=b.area_desc
and a.city_desc=c.city_desc 
and b.area_no=c.area_no
and c.city_no=d.city_no_old)x)
;
truncate table tmp_majh_gx_group_1
create table tmp_majh_gx_group_1
(
area_desc varchar2(20),
city_desc varchar2(30),
group_no varchar2(50),
group_name varchar2(300),
huaxiao_type_name varchar2(50),
huaxiao_name varchar2(100)
);

--��У����֧������
select a.* from tmp_majh_gx_group_1 a,dim.dim_area_no b,dim.dim_city_no c
where a.area_desc=b.area_desc(+) 
and a.city_desc=c.city_desc(+)
and c.city_desc is null;

select * from dim.dim_city_no where area_no='184' and city_desc like '%����%'

create table dim_group_hx_gx as
select * from dim_channel_huaxiao where 1=2;

--truncate table dim_group_hx_gx
insert into dim.dim_group_hx_gx
select 
b.area_no,
b.city_no,
a.group_no,
a.group_name,
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
 from tmp_majh_gx_group_1 a,dim_hx_gx b,dim_area_no c,dim_city_no d
where a.area_desc=c.area_desc
and a.city_desc=d.city_desc
and c.area_no=d.area_no
and b.area_no=c.area_no
and b.city_no=d.city_no
and a.huaxiao_name=b.huaxiao_name;


--����쳣
delete from dim_group_hx_gx where channel_no 
in
(
'1706JZJKZJK0773658',
'1509JZJKZJK0714149',
'1509JZJKZJK0713880'
) and city_no='018184015'

select * from dim_group_hx_gx where channel_no 
in
(
'1706JZJKZJK0773658',
'1509JZJKZJK0714149',
'1509JZJKZJK0713880'
)  


--����  ֧����Ϣ
select 
a.area_no,b.area_desc,a.city_no,c.city_desc,a.huaxiao_no,a.huaxiao_name,a.huaxiao_type,a.huaxiao_type_name
 from dim_hx_gx a,dim.dim_area_no b,dim.dim_city_no c
where a.area_no=b.area_no
and a.city_no=c.city_no;

--���� ֧�ּ��Ź�ϵ
select 
a.area_no,b.area_desc,a.city_no,c.city_desc,a.huaxiao_no,a.huaxiao_name,a.channel_no,a.channel_no_desc,a.huaxiao_type,a.huaxiao_type_name
 from dim_group_hx_gx a,dim.dim_area_no b,dim.dim_city_no c
where a.area_no=b.area_no
and a.city_no=c.city_no;

select 
a.area_no,b.area_desc,a.city_no,c.city_desc,a.huaxiao_no,a.huaxiao_name,a.channel_no,a.channel_no_desc,a.huaxiao_type,a.huaxiao_type_name
 from dim_group_hx_gx a,dim.dim_area_no b,dim.dim_city_no c
where a.area_no=b.area_no
and a.city_no=c.city_no;


--��ʦ��У��ŷ����Ժ���ʺž�Ӫ����������������У֧��1��
update dim.dim_group_hx_gx a set a.huaxiao_no='813030310510000',
 a.huaxiao_name='��������У֧��1'
 where a.channel_no='1602JQHDQHD0722375'
 
 
--��������У֧��2�������ţ�1708JQHDQHD0181377ŷ��ѧԺ���˺ž�Ӫ����
insert into dim.dim_group_hx_gx
select 
 area_no, 
city_no, 
'1708JQHDQHD0181377' channel_no, 
'ŷ��ѧԺ���˺ž�Ӫ��' channel_no_desc, 
huaxiao_no, 
huaxiao_name, 
huaxiao_type, 
huaxiao_type_name, 
if_valid, 
update_user, 
update_date, 
idx_no, 
huaxiao_type_big, 
huaxiao_type_name_big
 from dim.dim_group_hx_gx where channel_no='1703JQHDQHD0161266'
 ;
 
 
 
 ---ʯ��ׯ����һ��֧�ֱ���
 create table tmp_majh_one_gx as 
select * from dim_hx_gx t where t.huaxiao_no='813010870520000';

create table tmp_majh_one_hx_gx as 
select * from dim_group_hx_gx where huaxiao_no='813010870520000'


delete from  dim_hx_gx t where t.huaxiao_no='813010870520000';


delete from dim_group_hx_gx where huaxiao_no='813010870520000'



 
 
 

