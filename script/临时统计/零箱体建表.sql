--零箱体明细
--月份  地市  区县  支局  小区名称（村）  零箱体名称  分光器录入时间  
--标准地址（八级）  五级标准地址ID  所在村覆盖用户数  所在村宽带渗透率	零箱体整治措施
create table dm_zero_box_base_info
(
acct_month varchar2(20),
area_no varchar2(20),
city_no varchar2(20),
huaxiao_no varchar2(20),
huaxiao_name varchar2(300),
xiaoqu_no varchar2(20),
xiaoqu_name varchar2(500),
box_name varchar2(200),
innet_date  varchar2(20),
STANDARD_id  varchar2(20),
STANDARD_name  varchar2(200),
kd_cnt number,
fg_cnt number,
handle_info   varchar2(1000)
)

1
--零箱体汇总统计
--月份	地市	区县	支局	小区名称（村）	项目类型（新/老）	零箱体个数	箱体总数	零箱体占比	所在村覆盖用户数	所在村宽带渗透率
create table dm_zero_box_hz_info
(
acct_month varchar2(20),
area_no varchar2(20),
city_no varchar2(20),
huaxiao_no varchar2(20),
huaxiao_name varchar2(300),
xiaoqu_no varchar2(20),
xiaoqu_name varchar2(500),
project_type varchar2(20)，
zero_cnt number,
all_cnt number,
kd_cnt number,
fg_cnt number
)

--1箱体明细
create table dm_one_box_base_info
(
acct_month varchar2(20),
area_no varchar2(20),
city_no varchar2(20),
huaxiao_no varchar2(20),
huaxiao_name varchar2(300),
xiaoqu_no varchar2(20),
xiaoqu_name varchar2(500),
box_id varchar2(20),
box_name varchar2(200),
innet_date  varchar2(20),
STANDARD_id  varchar2(20),
STANDARD_name  varchar2(200),
kd_cnt number,
fg_cnt number 
)

--1箱体汇总
create table dm_one_box_hz_info
(
acct_month varchar2(20),
area_no varchar2(20),
city_no varchar2(20),
huaxiao_no varchar2(20),
huaxiao_name varchar2(300),
xiaoqu_no varchar2(60),
xiaoqu_name varchar2(500),
project_type varchar2(20)，
one_cnt number,
all_cnt number,
kd_cnt number,
fg_cnt number
)

--零箱体整治效果后评估（区分新老项目）
create table dm_box_effect_eval
(
acct_month varchar2(20),
area_no varchar2(20),
city_no varchar2(20),
huaxiao_no varchar2(20),
huaxiao_name varchar2(300),
xiaoqu_no varchar2(20),
xiaoqu_name varchar2(500),
project_no  varchar2(60),
project_name   varchar2(300),
project_type varchar2(20)，  
minus_cnt number,
dev_cnt number,
minus_fee number,
minus_cnt_lj number,
dev_cnt_lj number,
minus_fee_lj  number
)

--箱体扩容预警表（超70%的列入此表）
create table dm_alarm_box_base_info
(
acct_month varchar2(20),
area_no varchar2(20),
city_no varchar2(20),
huaxiao_no varchar2(20),
huaxiao_name varchar2(300),
xiaoqu_no varchar2(20),
xiaoqu_name varchar2(500),
box_name varchar2(200),
port_cnt number,
use_cnt number,
unuse_cnt number
)


--箱体扩容预警表汇总（超70%的列入此表）
create table dm_alarm_box_hz_info
(
acct_month varchar2(20),
area_no varchar2(20),
city_no varchar2(20),
huaxiao_no varchar2(20),
huaxiao_name varchar2(300),
xiaoqu_no varchar2(20),
xiaoqu_name varchar2(500),
alarm_box_cnt number
)

















