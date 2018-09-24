select day_id,count(*) from stage.BWT_DOWN_GU_BDM_PA_D t where  t.marketing_code='201709272001' group by day_id


create table xxhb_mjh.tmp_zuwang_01 as 
select * from stage.BWT_DOWN_GU_BDM_PA_D t where  t.marketing_code='201709272001' and cell_phone like 'ip%' and day_id>='20180112'

select count(*),count(distinct cell_phone) from xxhb_mjh.tmp_zuwang_01

select day_id, count(*), count(distinct cell_phone)
  from xxhb_mjh.tmp_zuwang_01 a 
 group by day_id


select * from xxhb_mjh.tmp_zuwang_01


--Âë±í
select * from dim.dim_sale_mode_new a where a.city_code='188' and a.kind='1422032'

select * from dim.dim_user_dinner where user_dinner in ('1422032','1422032','1422042')

create table xxhb_mjh.tmp_zuwang_02 as 
select * from dw.dw_v_user_product_info a where acct_month='201804' 
--and area_no='188'
and user_dinner in ('1422032','1422042','1422031');

update xxhb_mjh.tmp_zuwang_01 set cell_phone=upper(cell_phone)



select count(*)
  from xxhb_mjh.tmp_zuwang_01 a,
       (select user_no, device_number
          from dw.dw_v_user_base_info_user b
         where acct_month = '201804'
           and tele_type in ('4', '26')) b,
       xxhb_mjh.tmp_zuwang_02 c
 where a.cell_phone = b.device_number
   and b.user_no = c.user_no










