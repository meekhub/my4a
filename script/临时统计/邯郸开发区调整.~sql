select * from dim.dim_xiaoqu_huaxiao where huaxiao_no='813040430170000'

select * from dim.dim_channel_huaxiao where huaxiao_no='813040430170000'

select * from dim.dim_channel_huaxiao where channel_no_desc like '%世纪大街营业厅%'

select * from dim.dim_channel_huaxiao where channel_no='C18610928'

select * from dim.dim_huaxiao_info where huaxiao_name like '%兼庄乡支局%'

--备份
create table tmp_dim_xiaoqu_huaxiao as
select * from dim_xiaoqu_huaxiao;

--备份
create table tmp_dim_channel_huaxiao as
select * from dim_channel_huaxiao

--备份
create table tmp_dim_huaxiao_info as
select * from dim_huaxiao_info

select * from dim_huaxiao_info where huaxiao_no='813040430170000'

select * from dim_channel_huaxiao where huaxiao_no='813040430170000'

select * from dim_channel_huaxiao where huaxiao_no='813040430010000'

select * from dim_channel_huaxiao where channel_no='C18610181'

select * from dim_xiaoqu_huaxiao where huaxiao_no='813040430010000'

--将北区的开发区公众支局更新到开发区  渠道
update dim_channel_huaxiao set city_no='018186019', huaxiao_no='813040210070000' where huaxiao_no='813040430010000'

--将北区的开发区公众支局更新到开发区  小区  必须在沙盘更新
update dim_xiaoqu_huaxiao set city_no='018186019', huaxiao_no='813040210070000' where huaxiao_no='813040430010000'


update dim_channel_huaxiao x set city_no='018186019', huaxiao_no='813040210070000',
huaxiao_name='开发区公众支局', x.huaxiao_type='03', x.huaxiao_type_name='社区支局'
 where channel_no in
（
'186405841',
'186585009',
'186468021',
'C18610181',
'186570370',
'318618951',
'318618601',
'C18620022',
'C18619219',
'C18618703',
'186525562',
'186573012',
'186577194',
'186569036',
'C18619897',
'186305320'
)


select * from dim_channel_huaxiao  where channel_no in
（
'186405841',
'186585009',
'186468021',
'C18610181',
'186570370',
'318618951',
'318618601',
'C18620022',
'C18619219',
'C18618703',
'186525562',
'186573012',
'186577194',
'186569036',
'C18619897',
'186305320'
)

--将北区兼庄乡支局的C18618254调整至北区的黄粱梦支局
select * from dim_channel_huaxiao  where channel_no in ('C18618254')


update dim_channel_huaxiao x set  huaxiao_no='813040430160000',
huaxiao_name='黄粱梦镇支局'
 where channel_no in ('C18618254')
 
 --将北区世纪大街营业厅的区县归属由北区更改为开发区 
 select * from dim_channel_huaxiao where channel_no='C18610754'
 
 
 update dim_channel_huaxiao set city_no='018186019',
 huaxiao_no='813040210080000',
 huaxiao_name='电信开发区世纪大街营业厅'
  where channel_no='C18610754'
