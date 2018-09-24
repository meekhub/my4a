 DECLARE
  V_MONTH VARCHAR2(100); 
BEGIN
  FOR V_NUM IN 201801 .. 201806 LOOP
    V_MONTH := TO_CHAR(V_NUM); 
insert into tmp_majh_arpu_0719_02
select 
v_month,t.*,b.price_fee
 from tmp_majh_arpu_0719_01 t,
(
select device_number, (price_fee+price_fee_ocs)price_fee from 
dw.dw_v_user_base_info_user b
where acct_month=v_month
and tele_type='2'
and is_onnet='1'
)b
where t.device_number=b.device_number(+);
commit;
      COMMIT;
    END LOOP; 
END;


select
a.device_number,
sum(case when a.acct_month='201801' then a.price_fee else 0 end),
sum(case when a.acct_month='201802' then a.price_fee else 0 end),
sum(case when a.acct_month='201803' then a.price_fee else 0 end),
sum(case when a.acct_month='201804' then a.price_fee else 0 end),
sum(case when a.acct_month='201805' then a.price_fee else 0 end),
sum(case when a.acct_month='201806' then a.price_fee else 0 end)
 from tmp_majh_arpu_0719_02 a group by a.device_number
 
 
 
 
 
 
