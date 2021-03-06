select * from dim.dim_zq_channel_huaxiao t where t.huaxiao_no='813090030810000';

select * from dim.dim_zq_xiaoqu_huaxiao a where a.xiaoqu_no='181607874120110113';

create table xxhb_mjh.tmp_majh_xq_05
(
xiaoqu_no varchar2(20),
xiaoqu_name varchar2(200),
huaxiao_no varchar2(20)
);


insert into dim.dim_zq_xiaoqu_huaxiao 
select 
a.area_no, 
a.city_no, 
b.xiaoqu_no, 
b.xiaoqu_name, 
a.huaxiao_no, 
a.huaxiao_name, 
a.huaxiao_type, 
a.huaxiao_type_name, 
a.if_valid, 
a.update_user, 
a.update_date, 
a.idx_no, 
a.huaxiao_type_big, 
a.huaxiao_type_name_big
 from dim.dim_xiaoqu_huaxiao a,xxhb_mjh.tmp_majh_xq_05 b  where 
  a.xiaoqu_no=b.xiaoqu_no
