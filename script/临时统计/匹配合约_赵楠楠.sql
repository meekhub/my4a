create table tmp_majh_1018_03 as 
select 
t.idx_no,case when x.sales_mode is not null then 'ÊÇ' else '·ñ' end flag
 from tmp_majh_1018_01 t,
(
select device_number,sales_mode from dw.dw_v_user_base_info_day 
where acct_month='201710'
and day_id='17'
and tele_type='2'
and is_onnet='1'
)x
where t.device_number=x.device_number(+)
