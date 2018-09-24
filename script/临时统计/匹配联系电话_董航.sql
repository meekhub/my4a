create table tmp_majh_0503_dh_02 as 
select 
a.*,b.LINK_PHONE
 --from  tmp_majh_0503_dh_01 a,
 from xxhb_qsk.tmp_qisk_device0807 a,
(
select device_number,link_phone from dw.dw_v_user_base_info_day b
where acct_month='201808'
and day_id='06'
and is_onnet='1'
)b
where a.device_number=b.device_number(+);


select * from 
(select 
device_number,  
link_phone,idx_no,row_number()over(partition by idx_no order by 1)rn
 from  tmp_majh_0503_dh_02)
 where rn=1
 order by idx_no;


create table tmp_majh_0503_dh_04 as 
select 
a.*,innet_date,area_no_desc,city_no_desc,user_dinner_desc
 from tmp_majh_0503_dh_03 a,
(
select device_number,link_phone,to_char(innet_date,'yyyymmdd')innet_date,area_no_desc,city_no_desc,user_dinner_desc from dw.dw_v_user_base_info_day b
where acct_month='201805'
and day_id='02'
and is_onnet='1'
)b
where a.device_number=b.device_number(+);



create table tmp_majh_0503_dh_06 as 
select 
a.*,innet_date,area_no_desc,city_no_desc,user_dinner_desc
 from tmp_majh_0503_dh_05 a,
(
select device_number,link_phone,to_char(innet_date,'yyyymmdd')innet_date,area_no_desc,city_no_desc,user_dinner_desc from dw.dw_v_user_base_info_day b
where acct_month='201805'
and day_id='02'
and is_onnet='1'
)b
where a.device_number=b.device_number(+);

select count(*) from xxhb_mjh.tmp_majh_0503_dh_06


--ÊÇ·ñÈÚºÏ Ì×²Í
create table tmp_majh_0514_dh_01 as 
select 
a.*,case when b.is_kd_bundle='0' then '·ñ' else 'ÊÇ' end is_bundle,
b.user_dinner,b.user_dinner_desc
 from  tmp_majh_0503_dh_01 a,
(
select device_number,link_phone,user_dinner,user_dinner_desc,b.IS_KD_BUNDLE from dw.dw_v_user_base_info_day b
where acct_month='201805'
and day_id='13'
and is_onnet='1'
)b
where a.device_number=b.device_number(+);


select 
*
 from tmp_majh_0514_dh_01






