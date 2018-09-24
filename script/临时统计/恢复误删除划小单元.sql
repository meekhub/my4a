select day_id,count(*) from dim.DIM_HUAXIAO_INFO_DAY_BAK a where a.huaxiao_no='813110310050000' group by day_id



select * from dim.DIM_HUAXIAO_INFO_DAY_BAK a where a.huaxiao_no='813110310050000'
and day_id='20180513'



dmpro.p_dmpro_dim_day




select * from dim.dim_zq_channel_huaxiao a where a.huaxiao_no='813110310050000'
