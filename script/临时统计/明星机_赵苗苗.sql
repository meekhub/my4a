--2017年卓越100发展基金结算明细表(月)
select COUNT( *)from stage.bwt_down_comm_nbr_detail_m where acct_month='201708'
--2017年卓越100明星机基金结算明细表(月)
select COUNT(*) from stage.bwt_down_star_comm_nbr_detail where acct_month='201708'
--2017年卓越100渠道直补基金结算明细表(月)
select COUNT(*) from stage.bwt_down_chnl_user_detail_m where acct_month='201708'
