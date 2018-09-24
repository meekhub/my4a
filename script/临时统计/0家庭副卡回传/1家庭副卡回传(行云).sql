 drop table tmp_majh_fuka_0913
 create table tmp_majh_fuka_0913
 (
 area_no varchar(20),
 cell_phone varchar(20)
 )
 
 
 truncate table tmp_majh_fuka_0913
 insert into tmp_majh_fuka_0913
 {
 select area_no,kd_number from temp_user.tmp_majh_kd_01
 }@hbdw
 

--truncate table tmp_majh_0816_01
 
 insert into tmp_majh_0816_01
select 
a.area_no,
a.cell_phone,
c.bundle_id
 from 
tmp_majh_fuka_0913 a
  join
 (select device_number from dw_v_user_base_info_user where acct_month='201710'
 and is_onnet='是'
 and tele_type in ('4','26')
 and is_kd_bundle='0')b
 on a.cell_phone=b.device_number
  join
 (select device_number,bundle_id from dw_v_user_base_info_user where acct_month='201711'
 and is_onnet='是'
 and tele_type in ('4','26')
 and is_kd_bundle<>'0')c
 on a.cell_phone=c.device_number;
 
select count(*) from tmp_majh_0816_01
 
 --营销宽带账号
SELECT distinct cell_phone
 from dw_family_card_user_info
 where area_no='185'
 
 
 drop table tmp_majh_fuka_0913_02
 
create table tmp_majh_fuka_0913_02
( 
area_no  varchar(20), 
kd_number varchar(20), 
mobile_number varchar(20) 
)
 
--truncate table tmp_majh_fuka_0913_02
 
 insert into tmp_majh_fuka_0913_02
 select 
b.area_no,a.device_number kd_number,b.device_number mobile_number
 from tmp_majh_0816_01 a
 join
  (select area_no,device_number,bundle_id,BUNDLE_USER_DINNER_DESC,BUNDLE_DINNER_BEG_DATE from dw_v_user_base_info_user where acct_month='201711'
 and is_onnet='是'
 and tele_type in ('2','72'))b
 on a.bundle_id=b.bundle_id;
 
 
select count(*) from tmp_majh_fuka_0913_02



