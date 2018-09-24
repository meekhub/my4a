select a.*, b.发布人,b.发布时间
  from (select report_path, report_name, count(*)
          from sys_cat_log a
         where a.SYS_KIND = '1'
           and day_id like '201804%'
         group by report_path, report_name) a,
       (select distinct '>>'||菜单路径 as report_path , 发布人, 发布时间
          from xxhb_mjh.tmp_majh_0523_01) b
 where a.report_path = b.report_path(+)
