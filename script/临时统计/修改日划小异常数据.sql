create table tmp_cbzs_dm_kkpi_d_dev_channel as
select * from cbzs_dm_kkpi_d_dev_channel


truncate table cbzs_dm_kkpi_d_dev_channel

insert into cbzs_dm_kkpi_d_dev_channel
select * from tmp_cbzs_dm_kkpi_d_dev_channel;

--�ϲ�
delete from cbzs_dm_kkpi_d_dev_channel x where exists
(select 1 from (select a.* from
(select distinct t.huaxiao_no,t.channel_no from mobile_cbzs.cbzs_dm_kkpi_d_dev_channel t)a,
(select huaxiao_no,channel_no from dim.dim_channel_huaxiao
union all
select huaxiao_no,xiaoqu_no from dim.dim_xiaoqu_huaxiao)b
where a.huaxiao_no=b.huaxiao_no(+)
and a.channel_no=b.channel_no(+)
and b.huaxiao_no is null
and b.channel_no is null)y where x.huaxiao_no=y.huaxiao_no and x.channel_no=y.channel_no)


select count(*) from cbzs_dm_kkpi_d_dev_channel

create table alldm.tmp_DM_V_CHANNEL_INFO_D as
select * from alldm.DM_V_CHANNEL_INFO_D


--dm��
delete from alldm.DM_V_CHANNEL_INFO_D x where exists
(select 1 from (select a.* from
(select distinct t.huaxiao_no,XIAOQU_NO from alldm.DM_V_CHANNEL_INFO_D t)a,
(select huaxiao_no,channel_no from dim.dim_channel_huaxiao
union all
select huaxiao_no,xiaoqu_no from dim.dim_xiaoqu_huaxiao)b
where a.huaxiao_no=b.huaxiao_no(+)
and a.XIAOQU_NO=b.channel_no(+)
and b.huaxiao_no is null
and b.channel_no is null)y where x.huaxiao_no=y.huaxiao_no and x.XIAOQU_NO=y.XIAOQU_NO);
commit;












