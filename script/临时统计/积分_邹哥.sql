select 
c.city_desc,b.channel_no,b.channel_no_desc,a.dev_score_all,a.income_score_all,a.weixi_score_all,a.fine_score_all
 from rpt_hbtele.SJZX_WH_CHANNEL_JF_SCORE_010_M a ,dim.dim_channel_huaxiao b,dim.dim_city_no c where a.acct_month='201711'
and a.area_no='181' 
and a.channel_no=b.channel_no
and b.huaxiao_type='01'
and b.city_no=c.city_no
