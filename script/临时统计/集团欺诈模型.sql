 select 
 acct_month, 
prvnce_id, 
t.latn_id, 
x.area_desc,
prod_inst_id, 
accs_nbr, 
cheat_score, 
p_date, 
appear_num
  from alldm.bwt_down_credit_phone_cheat_m t,dim.dim_area_no_jt x
 where t.LATN_ID=x.std_latn_cd
