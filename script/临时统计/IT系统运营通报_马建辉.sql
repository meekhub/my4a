select a.SYS_KIND,count(*),count(distinct a.mobile) from sys_cat_log a where substr(DAY_ID,1,6)='201808' group by a.SYS_KIND
order by a.SYS_KIND;

--决策系统访问前10报表
select a.REPORT_NAME,REPORT_PATH,count(*) from sys_cat_log a where substr(DAY_ID,1,6)='201808'
and sys_kind='1'
 group by a.REPORT_NAME,REPORT_PATH
order by count(*) desc;


--上月有访问量本月无访问量
select a.* from 
(select REPORT_PATH  from sys_cat_log a where substr(DAY_ID,1,6)='201807'
and sys_kind='1')a,
(select REPORT_PATH from sys_cat_log a where substr(DAY_ID,1,6)='201808'
and sys_kind='1')b
where a.REPORT_PATH=b.report_path(+)
and b.report_path is null



---上架监控
select 
report_name,report_path
 from 
sys_report_log a where substr(up_date,1,6)='201808' 
