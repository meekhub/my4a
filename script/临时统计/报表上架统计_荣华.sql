select a.*, b.������,b.����ʱ��
  from (select report_path, report_name, count(*)
          from sys_cat_log a
         where a.SYS_KIND = '1'
           and day_id like '201804%'
         group by report_path, report_name) a,
       (select distinct '>>'||�˵�·�� as report_path , ������, ����ʱ��
          from xxhb_mjh.tmp_majh_0523_01) b
 where a.report_path = b.report_path(+)
