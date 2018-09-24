--天线
create table tmp_majh_0710_tx_01
(
tianxian_no varchar2(300),
station_no varchar2(300),
station_name varchar2(300),
tieta_no varchar2(300),
tieta_name varchar2(300),
area_name varchar2(300),
city_name varchar2(300),
fgi_area_type varchar2(300),
fg_daolu_type varchar2(300),
fg_hot varchar2(300)
)

--RRU
create table tmp_majh_0710_rru_01
(
rru_no  varchar2(300),
station_no varchar2(300),
tieta_no varchar2(300),
enb_no varchar2(300),
enb_name varchar2(300),
area_name varchar2(300),
city_name varchar2(300),
rru_elect_no varchar2(300),
xiaoqu_no varchar2(300),
innet_date varchar2(300),
pinduan varchar2(300)
)

--小区
create table tmp_majh_0710_xiaoqu_01
(
xiaoqu_no  varchar2(300), 
enb_no varchar2(300), 
area_name varchar2(300),
city_name varchar2(300),
xiaoqu_name  varchar2(300), 
eci  varchar2(300), 
pinduan varchar2(300),
fg_type  varchar2(300),
tianxian_no varchar2(300)
)


--站址
create table tmp_majh_0710_zhanzhi_01
(
station_no varchar2(300), 
tieta_no varchar2(300),
tieta_name varchar2(300), 
area_name varchar2(300),
city_name varchar2(300),
station_name varchar2(300),
is_cl_share varchar2(300),
tower_type varchar2(300)
)


--铁塔服务费
create table tmp_majh_0710_fuwu_01
(
acct_month varchar2(20),
operation_flag varchar2(300), 
station_name varchar2(300), 
station_no varchar2(300), 
prod_type varchar2(300), 
fee1 number, 
fee2 number,
fee3 number,
fee4 number
)

create table tmp_majh_0710_fuwu_02 as
select * from tmp_majh_0710_fuwu_01

insert into tmp_majh_0710_fuwu_01
select * from tmp_majh_0710_fuwu_02


--流量
create table tmp_majh_0710_flux_01
(
area_name varchar2(300),
city_name varchar2(300),
xiaoqu_no  varchar2(300),
up_flux number,
down_flux number
)


--RRU整合
create table tmp_majh_0710_rru_01_new as 
select 
t.*,xiaoqu_no as xiaoqu_no_new
 from tmp_majh_0710_rru_01 t WHERE INSTR(XIAOQU_no,',')=0
union
--1个逗号
select t.*,substr(XIAOQU_NO,1,INSTR(XIAOQU_NO,',',1,1)-1) from tmp_majh_0710_rru_01 t WHERE INSTR(XIAOQU_NO,',',1,1)>0 and 
length(XIAOQU_NO)-length(replace(XIAOQU_NO,',',''))=1
union 
select t.*,substr(XIAOQU_NO,INSTR(XIAOQU_NO,',',1,1)+1) from tmp_majh_0710_rru_01 t WHERE INSTR(XIAOQU_NO,',',1,1)>0
and length(XIAOQU_NO)-length(replace(XIAOQU_NO,',',''))=1
union
--2个逗号
select t.*,substr(xIAOQU_NO,1,INSTR(xIAOQU_NO,',',1,1)-1) from tmp_majh_0710_rru_01 t WHERE INSTR(xIAOQU_NO,',',1,1)>0 and 
length(xIAOQU_NO)-length(replace(xIAOQU_NO,',',''))=2
union 
select t.*,substr(xIAOQU_NO,INSTR(xIAOQU_NO,',',1,1)+1,INSTR(xIAOQU_NO,',',1,2)-INSTR(xIAOQU_NO,',',1,1)-1) from tmp_majh_0710_rru_01 t WHERE INSTR(xIAOQU_NO,',',1,1)>0
and length(xIAOQU_NO)-length(replace(xIAOQU_NO,',',''))=2
union
select t.*,substr(xIAOQU_NO,INSTR(xIAOQU_NO,',',1,2)+1) from tmp_majh_0710_rru_01 t WHERE INSTR(xIAOQU_NO,',',1,1)>0
and length(xIAOQU_NO)-length(replace(xIAOQU_NO,',',''))=2
union
--3个逗号
select t.*,substr(xIAOQU_NO,1,INSTR(xIAOQU_NO,',',1,1)-1) from tmp_majh_0710_rru_01 t WHERE INSTR(xIAOQU_NO,',',1,1)>0 and 
length(xIAOQU_NO)-length(replace(xIAOQU_NO,',',''))=3
union 
select t.*,substr(xIAOQU_NO,INSTR(xIAOQU_NO,',',1,1)+1,INSTR(xIAOQU_NO,',',1,2)-INSTR(xIAOQU_NO,',',1,1)-1) from tmp_majh_0710_rru_01 t WHERE INSTR(xIAOQU_NO,',',1,1)>0
and length(xIAOQU_NO)-length(replace(xIAOQU_NO,',',''))=3
union 
select t.*,substr(xIAOQU_NO,INSTR(xIAOQU_NO,',',1,2)+1,INSTR(xIAOQU_NO,',',1,3)-INSTR(xIAOQU_NO,',',1,2)-1) from tmp_majh_0710_rru_01 t WHERE INSTR(xIAOQU_NO,',',1,1)>0
and length(xIAOQU_NO)-length(replace(xIAOQU_NO,',',''))=3
union
select t.*,substr(xIAOQU_NO,INSTR(xIAOQU_NO,',',1,3)+1) from tmp_majh_0710_rru_01 t WHERE INSTR(xIAOQU_NO,',',1,1)>0
and length(xIAOQU_NO)-length(replace(xIAOQU_NO,',',''))=3
union
--4个逗号
select t.*,substr(xIAOQU_NO,1,INSTR(xIAOQU_NO,',',1,1)-1) from tmp_majh_0710_rru_01 t WHERE INSTR(xIAOQU_NO,',',1,1)>0 and 
length(xIAOQU_NO)-length(replace(xIAOQU_NO,',',''))=4
union 
select t.*,substr(xIAOQU_NO,INSTR(xIAOQU_NO,',',1,1)+1,INSTR(xIAOQU_NO,',',1,2)-INSTR(xIAOQU_NO,',',1,1)-1) from tmp_majh_0710_rru_01 t WHERE INSTR(xIAOQU_NO,',',1,1)>0
and length(xIAOQU_NO)-length(replace(xIAOQU_NO,',',''))=4
union 
select t.*,substr(xIAOQU_NO,INSTR(xIAOQU_NO,',',1,2)+1,INSTR(xIAOQU_NO,',',1,3)-INSTR(xIAOQU_NO,',',1,2)-1) from tmp_majh_0710_rru_01 t WHERE INSTR(xIAOQU_NO,',',1,1)>0
and length(xIAOQU_NO)-length(replace(xIAOQU_NO,',',''))=4
union 
select t.*,substr(xIAOQU_NO,INSTR(xIAOQU_NO,',',1,3)+1,INSTR(xIAOQU_NO,',',1,4)-INSTR(xIAOQU_NO,',',1,3)-1) from tmp_majh_0710_rru_01 t WHERE INSTR(xIAOQU_NO,',',1,1)>0
and length(xIAOQU_NO)-length(replace(xIAOQU_NO,',',''))=4
union
select t.*,substr(xIAOQU_NO,INSTR(xIAOQU_NO,',',1,4)+1) from tmp_majh_0710_rru_01 t WHERE INSTR(xIAOQU_NO,',',1,1)>0
and length(xIAOQU_NO)-length(replace(xIAOQU_NO,',',''))=4
union
--5个逗号
select t.*,substr(xIAOQU_NO,1,INSTR(xIAOQU_NO,',',1,1)-1) from tmp_majh_0710_rru_01 t WHERE INSTR(xIAOQU_NO,',',1,1)>0 and 
length(xIAOQU_NO)-length(replace(xIAOQU_NO,',',''))=5
union 
select t.*,substr(xIAOQU_NO,INSTR(xIAOQU_NO,',',1,1)+1,INSTR(xIAOQU_NO,',',1,2)-INSTR(xIAOQU_NO,',',1,1)-1) from tmp_majh_0710_rru_01 t WHERE INSTR(xIAOQU_NO,',',1,1)>0
and length(xIAOQU_NO)-length(replace(xIAOQU_NO,',',''))=5
union 
select t.*,substr(xIAOQU_NO,INSTR(xIAOQU_NO,',',1,2)+1,INSTR(xIAOQU_NO,',',1,3)-INSTR(xIAOQU_NO,',',1,2)-1) from tmp_majh_0710_rru_01 t WHERE INSTR(xIAOQU_NO,',',1,1)>0
and length(xIAOQU_NO)-length(replace(xIAOQU_NO,',',''))=5
union 
select t.*,substr(xIAOQU_NO,INSTR(xIAOQU_NO,',',1,3)+1,INSTR(xIAOQU_NO,',',1,4)-INSTR(xIAOQU_NO,',',1,3)-1) from tmp_majh_0710_rru_01 t WHERE INSTR(xIAOQU_NO,',',1,1)>0
and length(xIAOQU_NO)-length(replace(xIAOQU_NO,',',''))=5
union 
select t.*,substr(xIAOQU_NO,INSTR(xIAOQU_NO,',',1,4)+1,INSTR(xIAOQU_NO,',',1,5)-INSTR(xIAOQU_NO,',',1,4)-1) from tmp_majh_0710_rru_01 t WHERE INSTR(xIAOQU_NO,',',1,1)>0
and length(xIAOQU_NO)-length(replace(xIAOQU_NO,',',''))=5
union
select t.*,substr(xIAOQU_NO,INSTR(xIAOQU_NO,',',1,5)+1) from tmp_majh_0710_rru_01 t WHERE INSTR(xIAOQU_NO,',',1,1)>0
and length(xIAOQU_NO)-length(replace(xIAOQU_NO,',',''))=5















