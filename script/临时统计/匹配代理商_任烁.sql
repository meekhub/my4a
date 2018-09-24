select t.*, t.rowid from tmp_majh_0222_01 t;

select 
x.channel_no,
a.agent_id,
a.agent_name
 from 
tmp_majh_0222_02 x,
(select * from rpt_hbtele.DM_BUSI_CHANNEL_BUILD a
where  acct_month='201801')a
where x.channel_no=a.channel_no(+)
order by x.idx_no
