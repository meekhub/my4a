--ʡ��Ӫ���Ŀ���û������ϴ��ӿڣ�һ�����ϴ���
select * from alldm.bwt_pr_bdm_pa_d t where t.day_id='20171029' and t.model_id='81301100625001';
--����ʡ��ЭͬӪ�����ʡ��Ӫ���ִ�й��������ϴ��ӿ�
select * from alldm.bwt_pr_bdm_pp_d t where t.day_id='20171029' and t.model_id ='81301100625001';
--ʡ��Ӫ���Ӫ���ɹ������ϴ��ӿ�
select * from alldm.bwt_pr_bdm_ps_d t where t.day_id='20171029' and t.model_id='81301100625001';
--ʡ��Ӫ����������ϴ��ӿ�
select * from alldm.bwt_pr_bdm_pm_d t where t.day_id='20171029' and t.mdm_code='813013201707001';

create table tmp_majh_cheat_01
(
device_number varchar2(20)
);

insert into bwt_pr_bdm_pa_d
select 
'20171029' day_id,
'813',
'81301',
device_number,
'813013201707001',
'81301100625001'
 from tmp_majh_cheat_01;

create table tmp_majh_cheat_02
(
device_number varchar2(20)
);
 

insert into bwt_pr_bdm_pp_d
 select 
 '20171029',
 '813',
 '81301',
 device_number,
 '813013201707001',
 '81301100625001',
 '1',
 '1',
 '',
 '1',
 '20170727090001',
 '1',
 '999',
 '�ɿͷ������κ���˺������Ű������й�ͣ',
 '3',
 '','','','','','','','','',''
 from tmp_majh_cheat_02
 
 insert into bwt_pr_bdm_ps_d
 select 
  '20171029',
 '813',
 '81301',
 device_number,
 '813013201707001',
 '81301100625001',
 '������թ�û�ʶ��'
 from tmp_majh_cheat_03
 
 
 insert into bwt_pr_bdm_pm_d
 select 
   '20171029',
 '813',
 '001',
 '813013201707001',
 '������թ�û�ʶ��',
 '20170701',
 '20170901',
 '','','',''
 from dual
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
