select 
t.device_number,
sum(case when t.acct_mont='201704' then t.all_jf_flux else 0 end)a4,
sum(case when t.acct_mont='201705' then t.all_jf_flux else 0 end)a4,
sum(case when t.acct_mont='201706' then t.all_jf_flux else 0 end)a4,
sum(case when t.acct_mont='201707' then t.all_jf_flux else 0 end)a4,
sum(case when t.acct_mont='201708' then t.all_jf_flux else 0 end)a4,
sum(case when t.acct_mont='201709' then t.all_jf_flux else 0 end)a4,
sum(case when t.acct_mont='201710' then t.all_jf_flux else 0 end)a4,
sum(case when t.acct_mont='201711' then t.all_jf_flux else 0 end)a4 
 from tmp_majh_1209_2 t 
 group by t.device_number,t.idx_no
 order by t.idx_no
