select * from bwt_down_credit_phone_cheat_m t where t.ACCT_MONTH='201803'


/*select c.area_desc,a.ACCS_NBR,a.PROD_INST_ID,a.acct_month,a.CHEAT_SCORE,a.P_DATE,a.APPEAR_NUM from 
(select * from bwt_down_credit_phone_cheat_m t where t.ACCT_MONTH='201803')a,
(select * from bwt_down_credit_phone_cheat_m t where t.ACCT_MONTH<='201802')b,
dim.dim_area_no_jt c
where a.prod_inst_id=b.prod_inst_id(+)
and a.LATN_ID=c.std_latn_cd
and b.prod_inst_id is null*/



select c.area_desc,a.ACCS_NBR,a.PROD_INST_ID,a.acct_month,a.CHEAT_SCORE,a.P_DATE,a.APPEAR_NUM from 
(select * from alldm.bwt_down_credit_phone_cheat_m t where t.ACCT_MONTH='201806')a ,
dim.dim_area_no_jt c
where  a.LATN_ID=c.std_latn_cd 

