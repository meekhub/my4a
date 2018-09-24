create table xxhb_mjh.tmp_zq_huaxiao_info as 
select * from dim.dim_zq_huaxiao_info

create table xxhb_mjh.tmp_zq_channel_huaxiao as 
select * from dim.dim_zq_channel_huaxiao

delete 
  from dim.dim_zq_channel_huaxiao a
 where a.huaxiao_no in (813030310740000,
                        813030220760000,
                        813030010770000,
                        813030010760000,
                        813030010740000)
