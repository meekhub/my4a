--��������ϸ
--�·�  ����  ����  ֧��  С�����ƣ��壩  ����������  �ֹ���¼��ʱ��  
--��׼��ַ���˼���  �弶��׼��ַID  ���ڴ帲���û���  ���ڴ�����͸��	���������δ�ʩ
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
--���������ͳ��
--�·�	����	����	֧��	С�����ƣ��壩	��Ŀ���ͣ���/�ϣ�	���������	��������	������ռ��	���ڴ帲���û���	���ڴ�����͸��
create table dm_zero_box_hz_info
(
acct_month varchar2(20),
area_no varchar2(20),
city_no varchar2(20),
huaxiao_no varchar2(20),
huaxiao_name varchar2(300),
xiaoqu_no varchar2(20),
xiaoqu_name varchar2(500),
project_type varchar2(20)��
zero_cnt number,
all_cnt number,
kd_cnt number,
fg_cnt number
)

--1������ϸ
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

--1�������
create table dm_one_box_hz_info
(
acct_month varchar2(20),
area_no varchar2(20),
city_no varchar2(20),
huaxiao_no varchar2(20),
huaxiao_name varchar2(300),
xiaoqu_no varchar2(60),
xiaoqu_name varchar2(500),
project_type varchar2(20)��
one_cnt number,
all_cnt number,
kd_cnt number,
fg_cnt number
)

--����������Ч��������������������Ŀ��
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
project_type varchar2(20)��  
minus_cnt number,
dev_cnt number,
minus_fee number,
minus_cnt_lj number,
dev_cnt_lj number,
minus_fee_lj  number
)

--��������Ԥ������70%������˱�
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


--��������Ԥ������ܣ���70%������˱�
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

















