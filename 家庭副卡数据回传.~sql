drop table tmp_majh_0816_01

create table tmp_majh_0816_01
(
device_number varchar(20),
bundle_id varchar(30)
)

/**
insert into tmp_majh_0816_01
select 
a.cell_phone,
c.bundle_id
 from 
(SELECT cell_phone
 from dw_family_card_user_info
 where area_no='185')a
  join
 (select device_number from dw_v_user_base_info_user where acct_month='201706'
 and is_onnet='是'
 and tele_type in ('4','26')
 and is_kd_bundle='0')b
 on a.cell_phone=b.device_number
  join
 (select device_number,bundle_id from dw_v_user_base_info_user where acct_month='201707'
 and is_onnet='是'
 and tele_type in ('4','26')
 and is_kd_bundle<>'0')c
 on a.cell_phone=c.device_number;
 **/
 
 create table tmp_majh_fuka_0913
 (
 cell_phone varchar(20)
 )
 truncate table tmp_majh_fuka_0913
 insert into tmp_majh_fuka_0913
 {
 select upper(cell_phone) from temp_user.tmp_majh_fuka_0913
 }@hbdw
 
 
 insert into tmp_majh_0816_01
select 
a.cell_phone,
c.bundle_id
 from 
tmp_majh_fuka_0913 a
  join
 (select device_number from dw_v_user_base_info_user where acct_month='201707'
 and is_onnet='是'
 and tele_type in ('4','26')
 and is_kd_bundle='0')b
 on a.cell_phone=b.device_number
  join
 (select device_number,bundle_id from dw_v_user_base_info_user where acct_month='201708'
 and is_onnet='是'
 and tele_type in ('4','26')
 and is_kd_bundle<>'0')c
 on a.cell_phone=c.device_number;
 
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
 
 
 insert into tmp_majh_fuka_0913_02
 select 
b.area_no,a.device_number kd_number,b.device_number mobile_number
 from tmp_majh_0816_01 a
 join
  (select area_no,device_number,bundle_id,BUNDLE_USER_DINNER_DESC,BUNDLE_DINNER_BEG_DATE from dw_v_user_base_info_user where acct_month='201708'
 and is_onnet='是'
 and tele_type in ('2','72'))b
 on a.bundle_id=b.bundle_id;
 
 
 create table tmp_majh_0914_01
 (
 cell_phone varchar(20)
 )
 
 insert into tmp_majh_0914_01
 {
 select * from temp_user.tmp_majh_0914_01
 }@hbdw
 
 
  create table tmp_majh_0914_02
 (
 area_no varchar(20),
 cell_phone varchar(20)
 )
 
 insert into tmp_majh_0914_02 
select b.area_no,a.cell_phone
 from tmp_majh_0914_02 a
 left join
 (
 select area_no,lower(device_number)device_number from dw_v_user_base_info_user 
 where acct_month='201708'
 and tele_type in ('4','26')
 and is_onnet='是'
 )b
 on a.cell_phone=b.device_number
 


 DECLARE
  V_MONTH VARCHAR2(100);
  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018' ORDER BY IDX_NO;
BEGIN
  FOR V_NUM IN 201208 .. 201208 LOOP
    V_MONTH := TO_CHAR(V_NUM);
    FOR C1 IN V_AREA LOOP
      insert into temp_user.tmp_majh_family_out_0830_4
      select 
      b.area_no,a.cell_phone
       from tmp_majh_0914_01 a,
      (select lower(device_number)device_number,area_no,city_no from dw.dw_v_user_base_info_user b
    where acct_month='201708'
    and tele_type in ('4','26')
    and area_no=c1.area_no
    and is_onnet='1')b
    where a.cell_phone=b.device_number; 
      COMMIT;
      delete from tmp_majh_family_out_0830_4 where area_no is null;commit;
    END LOOP;
  END LOOP;
END;      
 
 
 
 
 
 
 
 
 
