select b.area_desc,
count(distinct  case when t.huaxiao_type='01' then t.huaxiao_no end)h1,
count(distinct  case when t.huaxiao_type='02' then t.huaxiao_no end)h1,
count(distinct  case when t.huaxiao_type='03' then t.huaxiao_no end)h1,
count(distinct  case when t.huaxiao_type='04' then t.huaxiao_no end)h1,
count(distinct  case when t.huaxiao_type='05' then t.huaxiao_no end)h1,
count(distinct  case when t.huaxiao_type='06' then t.huaxiao_no end)h1,
count(distinct  case when t.huaxiao_type='07' then t.huaxiao_no end)h1,
count(distinct  case when t.huaxiao_type='08' then t.huaxiao_no end)h1
  from dim.dim_huaxiao_info t,dim.dim_area_no b
 where t.huaxiao_type in ('01', '02', '03', '04', '05', '06', '07','08')
and t.area_no=b.area_no
group by b.area_desc,b.idx_no
order by b.idx_no
