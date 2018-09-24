create table tmp_majh_base_1026_01
(
area_no varchar2(20),
kd_number varchar2(20) 
)

执行过程数据：
select  alldm.func_get_area_no(t.area_no),lower(t.kd_number) from temp_user.tmp_majh_base_1026_01 t

营销成功的数据：
select alldm.func_get_area_no(t.area_no),lower(t.kd_number),t.device_number from tmp_majh_fuka_1026_02 t; 


--1、
create table tmp_majh_kd_01 as
select distinct area_no, kd_number from alldm.dm_v_user_family_wifi_m;

--------------------------从这里开始分布执行，修改账期--------------------------
--1. 第一步 沉淀下发数据
create table tmp_majh_kd_01 as
select distinct upper(CELL_PHONE) as kd_number
  from stage.BWT_DOWN_GU_BDM_PA_D t
 where t.marketing_code = '2017063001'
   and CELL_PHONE like 'ip%'
   and day_id >= '20180112';


create table tmp_majh_kd_02 as
select b.area_no,a.kd_number,user_no from tmp_majh_kd_01 a,
(select area_no,device_number,user_no,bundle_id,BUNDLE_USER_DINNER_DESC,BUNDLE_DINNER_BEG_DATE from dw.dw_v_user_base_info_user where acct_month='201807'
 and is_onnet='1'
 and tele_type in ('4','26'))b
 where a.kd_number=b.device_number;

--2、从匹配上月单宽本月变为融合的
create table  tmp_majh_0816_01 as
select 
c.area_no,
a.kd_number as cell_phone,
c.bundle_id
 from 
tmp_majh_kd_01 a
  join
 (select device_number from dw.dw_v_user_base_info_user where acct_month='201806'
 and is_onnet='1'
 and tele_type in ('4','26')
 and is_kd_bundle='0')b
 on a.kd_number=b.device_number
  join
 (select area_no,device_number,bundle_id from dw.dw_v_user_base_info_user where acct_month='201807'
 and is_onnet='1'
 and tele_type in ('4','26')
 and is_kd_bundle<>'0')c
 on a.kd_number=c.device_number;

--3、匹配营销成功数
create table  tmp_majh_fuka_0913_02 as
 select 
b.area_no,a.CELL_PHONE,b.device_number mobile_number,b.user_no
 from tmp_majh_0816_01 a
 join
  (select area_no,device_number,user_no,bundle_id,BUNDLE_USER_DINNER_DESC,BUNDLE_DINNER_BEG_DATE from dw.dw_v_user_base_info_user where acct_month='201807'
 and is_onnet='1'
 and tele_type in ('2','72'))b
 on a.bundle_id=b.bundle_id;
 
--------------将表同步到老库上

--4、营销成功用户数
create table tmp_success_user as  
select func_get_area_no(t.area_no) area_no,
       lower(t.cell_phone) kd_number,
       t.mobile_number mobile_number,
       t.user_no
  from tmp_majh_fuka_0913_02 t;

--5、执行用户数
create table tmp_execute_user as
select distinct func_get_area_no(t.area_no) area_no,
       lower(t.cell_phone) kd_number,t.user_no
  from tmp_majh_fuka_0913_02 t
union
select distinct func_get_area_no(t.area_no) area_no,
       lower(t.kd_number) kd_number,t.user_no
  from tmp_majh_kd_02 t
  where rownum<100298
 

--剔除重复
delete from tmp_execute_user a
 where rowid < (select max(rowid)
                  from tmp_execute_user b
                 where a.kd_number = b.kd_number)
                 
                 
                 
                 
                 
