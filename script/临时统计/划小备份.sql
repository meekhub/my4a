create table temp_user.DM_V_HUAXIAO_INFO_M_20180102 as
select * from DM_V_HUAXIAO_INFO_M;

drop table DM_V_HUAXIAO_INFO_M;


create table DM_V_HUAXIAO_INFO_M AS
select * from tmp_V_HUAXIAO_INFO_M;



create table temp_user.DM_V_CHANNEL_INFO_M_20180102 as
select * from DM_V_CHANNEL_INFO_M;


drop table DM_V_CHANNEL_INFO_M;

create table DM_V_CHANNEL_INFO_M as
select * from tmp_V_CHANNEL_INFO_M
