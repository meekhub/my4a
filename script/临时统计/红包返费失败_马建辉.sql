select *
  from acct_dsg.bf_yzf_pickup_t@hbods a
 where city_code = '188'
   and acc_nbr = '18031162608'


select pickup_status,count(*) from acct_dsg.bf_yzf_pickup_t@hbods group by pickup_status

select * from acct_dsg.bf_yzf_pickup_t@hbods where pickup_status='5'
