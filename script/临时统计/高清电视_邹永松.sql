--先跑一个过程
p_tmp_tmp_int_sys_income_jf_m


select 
x.city_desc,t.jf_type,t.agent_name,t.channel_no,y.channel_no_desc,t.low_value
 from tmp_int_sys_income_jf_m t,dim.dim_city_no x,dim.dim_channel_no y where t.low_value>0
and t.city_no=x.city_no
and t.channel_no=y.channel_no
and t.jf_type='增值业务积分'
and t.acct_month='201808';
