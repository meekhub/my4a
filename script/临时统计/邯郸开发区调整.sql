select * from dim.dim_xiaoqu_huaxiao where huaxiao_no='813040430170000'

select * from dim.dim_channel_huaxiao where huaxiao_no='813040430170000'

select * from dim.dim_channel_huaxiao where channel_no_desc like '%���ʹ��Ӫҵ��%'

select * from dim.dim_channel_huaxiao where channel_no='C18610928'

select * from dim.dim_huaxiao_info where huaxiao_name like '%��ׯ��֧��%'

--����
create table tmp_dim_xiaoqu_huaxiao as
select * from dim_xiaoqu_huaxiao;

--����
create table tmp_dim_channel_huaxiao as
select * from dim_channel_huaxiao

--����
create table tmp_dim_huaxiao_info as
select * from dim_huaxiao_info

select * from dim_huaxiao_info where huaxiao_no='813040430170000'

select * from dim_channel_huaxiao where huaxiao_no='813040430170000'

select * from dim_channel_huaxiao where huaxiao_no='813040430010000'

select * from dim_channel_huaxiao where channel_no='C18610181'

select * from dim_xiaoqu_huaxiao where huaxiao_no='813040430010000'

--�������Ŀ���������֧�ָ��µ�������  ����
update dim_channel_huaxiao set city_no='018186019', huaxiao_no='813040210070000' where huaxiao_no='813040430010000'

--�������Ŀ���������֧�ָ��µ�������  С��  ������ɳ�̸���
update dim_xiaoqu_huaxiao set city_no='018186019', huaxiao_no='813040210070000' where huaxiao_no='813040430010000'


update dim_channel_huaxiao x set city_no='018186019', huaxiao_no='813040210070000',
huaxiao_name='����������֧��', x.huaxiao_type='03', x.huaxiao_type_name='����֧��'
 where channel_no in
��
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
��
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

--��������ׯ��֧�ֵ�C18618254�����������Ļ�����֧��
select * from dim_channel_huaxiao  where channel_no in ('C18618254')


update dim_channel_huaxiao x set  huaxiao_no='813040430160000',
huaxiao_name='��������֧��'
 where channel_no in ('C18618254')
 
 --���������ʹ��Ӫҵ�������ع����ɱ�������Ϊ������ 
 select * from dim_channel_huaxiao where channel_no='C18610754'
 
 
 update dim_channel_huaxiao set city_no='018186019',
 huaxiao_no='813040210080000',
 huaxiao_name='���ſ��������ʹ��Ӫҵ��'
  where channel_no='C18610754'
