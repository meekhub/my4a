--省级营销活动目标用户数据上传接口（一次性上传）
select * from alldm.bwt_pr_bdm_pa_d t where t.day_id='20171029' and t.model_id='81301100625001';
--集团省分协同营销活动或省级营销活动执行过程数据上传接口
select * from alldm.bwt_pr_bdm_pp_d t where t.day_id='20171029' and t.model_id ='81301100625001';
--省级营销活动营销成功数据上传接口
select * from alldm.bwt_pr_bdm_ps_d t where t.day_id='20171029' and t.model_id='81301100625001';
--省级营销活动主数据上传接口
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
 '由客服进行任何审核后，再有信安部进行关停',
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
 '疑似欺诈用户识别'
 from tmp_majh_cheat_03
 
 
 insert into bwt_pr_bdm_pm_d
 select 
   '20171029',
 '813',
 '001',
 '813013201707001',
 '疑似欺诈用户识别',
 '20170701',
 '20170901',
 '','','',''
 from dual
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
