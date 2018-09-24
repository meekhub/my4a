select t.*, t.rowid from tmp_majh_trm_0504_01 t;

create table tmp_majh_trm_0504_02 as 
select a.*,
       b.area_no,
       b.city_no,
       b.terminal_corp,
       b.terminal_model,
       to_char(b.reg_date, 'yyyymmddHH24MISS') reg_date,
       b.user_no,
       b.device_no
  from tmp_majh_trm_0504_01 a,
       (select *
          from dw.dw_v_user_terminal_device_m b
         where acct_month = '201803') b
 where a.terminal_code = b.terminal_code(+);



create table tmp_majh_trm_0504_03 as 
select 
a.device_no
 from 
(
select device_no,terminal_code from dw.dw_v_user_terminal_d b
where acct_month='201805'
and day_id='02'
and to_char(reg_date,'yyyymm')<='201803'
)a,
tmp_majh_trm_0504_02 c
where a.terminal_code=c.terminal_code(+)
and c.terminal_code is null
group by a.device_no

create table tmp_majh_trm_0504_04 as
select 
a.*,
case when b.device_no is not null then '是' else '否' end is_cf,
case when c.IS_3NO_ADJUST='1' then '是' else '否' end is_3no，
case when c.user_dinner_desc like '%加装%' then '否' else '是' end is_zhu 
 from tmp_majh_trm_0504_02 a,
tmp_majh_trm_0504_03 b,
(
select user_no,IS_3NO_ADJUST，user_dinner_desc  from dw.dw_v_user_base_info_user c
where acct_month='201803'
and tele_type='2'
)c
where a.device_no=b.device_no(+) 
and a.user_no=c.user_no(+);

select is_zhu,count(*) from tmp_majh_trm_0504_04 group by is_zhu

select count(*),count(distinct idx_no) from  tmp_majh_trm_0504_04

select 
terminal_code 串码, 
area_desc 地市,  
terminal_corp 品牌, 
terminal_model 型号, 
reg_date 首次注册时间,  
device_no 首次注册手机号, 
is_cf 是否重复注册, 
is_3no 是否三无用户, 
is_zhu 是否主卡
 from tmp_majh_trm_0504_04 a 



