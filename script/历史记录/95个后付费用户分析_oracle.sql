select t.*, t.rowid from tmp_majh_risk_0803_2 t


select a.*,
case when c.channel_type like '11%' then 'ʵ������'
  when c.channel_type like '12%' then '��������'
    end channel_type
from tmp_majh_risk_0803_2 a,dim.dim_channel_no b,dim.dim_channel_type c
where a.channel_no=b.channel_no
and b.channel_type=c.channel_type
