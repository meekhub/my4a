create table xxhb_mjh.tmp_zq_huaxiao_info_0530 as 
select * from dim.dim_zq_huaxiao_info t where  huaxiao_no in 
(
'813020240710000',
'813020080730000',
'813020070730000',
'813020290730000',
'813020250760000' 
)


delete from  dim.dim_zq_huaxiao_info t where  huaxiao_no in 
(
'813020240710000',
'813020080730000',
'813020070730000',
'813020290730000',
'813020250760000' 
)

create table tmp_zq_channel_huaxiao as
select * from dim.dim_zq_channel_huaxiao

delete from  dim.dim_zq_channel_huaxiao t where  huaxiao_no in 
(
'813020240710000',
'813020080730000',
'813020070730000',
'813020290730000',
'813020250760000' 
)
