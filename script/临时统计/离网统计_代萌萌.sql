--ÀëÍø
select 
count(case when TELE_TYPE_NEW='G010' and to_char(a.LOGOUT_DATE,'yyyy')='2017' then a.user_no end)kd_out,
count(case when TELE_TYPE_NEW='G010' and to_char(a.LOGOUT_DATE,'yyyymm') between '201801' and '201803' then a.user_no end)kd_out,
count(case when TELE_TYPE_NEW='G110' and to_char(a.LOGOUT_DATE,'yyyy')='2017' then a.user_no end)itv_out,
count(case when TELE_TYPE_NEW='G110' and to_char(a.LOGOUT_DATE,'yyyymm') between '201801' and '201803' then a.user_no end)itv_out
 from dw.dw_v_user_base_info_user a
where acct_month='201803' 
and TELE_TYPE_NEW in ('G010','G110')


--µ¥×ªÈÚºÏ
select 
count(case when TELE_TYPE_NEW='G010' and b.user_no is not null then a.user_no end),
count(case when TELE_TYPE_NEW='G110' and b.user_no is not null then a.user_no end) 
 from 
(select user_no,is_kd_bundle,TELE_TYPE_NEW
 from dw.dw_v_user_base_info_user a
where acct_month='201803' 
and TELE_TYPE_NEW in ('G010','G110')
and is_kd_bundle<>'0'
)a,
(select user_no,is_kd_bundle 
 from dw.dw_v_user_base_info_user a
where acct_month='201712' 
and TELE_TYPE_NEW in ('G010','G110')
and is_kd_bundle='0'
)b
where a.user_no=b.user_no(+)






