--����а���Ԫ��Ϣ��
create or replace view dim_zq_huaxiao_info as  
select * from dim_hx_gx
union all
select * from dim_hx_yw
union all
select * from dim_hx_sk
union all
select * from dim.dim_hx_wlw


--������Ӧ��ϵ
create or replace view dim_zq_channel_huaxiao as 
select * from dim_hx_yw_channel
union all
select * from dim_hx_sk_channel;

--С����Ӧ��ϵ
create or replace view dim_zq_xiaoqu_huaxiao as 
select * from dim_hx_sk_xiaoqu;

--���Ŷ�Ӧ��ϵ
create or replace view dim_zq_group_huaxiao as 
select * from dim_group_hx_gx;


--���
select count(*),count(distinct channel_no) from dim_zq_channel_huaxiao;

select channel_no,count(*) from dim_zq_channel_huaxiao where huaxiao_type='06' group by channel_no having count(*)>1

select * from dim_zq_channel_huaxiao where channel_no='C18714237'

select count(*),count(distinct xiaoqu_no) from dim_zq_xiaoqu_huaxiao;

select count(*),count(distinct CHANNEL_NO) from dim_group_hx_gx;



select a.* from dim_zq_xiaoqu_huaxiao a,dim.dim_xiaoqu_huaxiao b
where a.XIAOQU_NO=b.xiaoqu_no(+)
and b.xiaoqu_no is null


--���¿��ϴ�����Ӧ�ı�
--����а���Ԫ��Ϣ��
create or replace view dim.dim_zq_huaxiao_info as
select * from dim.dim_zq_huaxiao_info@oldhbdw

--������Ӧ��ϵ
create or replace view dim.dim_zq_channel_huaxiao as
select * from dim.dim_zq_channel_huaxiao@oldhbdw


--С����Ӧ��ϵ
create or replace view dim.dim_zq_xiaoqu_huaxiao as
select * from dim.dim_zq_xiaoqu_huaxiao@oldhbdw

--���Ŷ�Ӧ��ϵ
create or replace view dim.dim_zq_group_huaxiao as 
select * from dim.dim_zq_group_huaxiao@oldhbdw;


--д��������
insert into dim.dim_channel_huaxiao
select * from dim.dim_zq_channel_huaxiao;

select huaxiao_type,count(*) from dim.dim_huaxiao_info group by huaxiao_type

select huaxiao_type,count(*) from dim.dim_channel_huaxiao group by huaxiao_type

select huaxiao_type,count(*) from dim.dim_xiaoqu_huaxiao group by huaxiao_type










