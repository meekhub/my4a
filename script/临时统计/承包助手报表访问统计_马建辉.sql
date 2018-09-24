select day_id,count(*),count(distinct user_id) from sys_cat_log a where a.SYS_KIND='3' and day_id like '201805%'
and report_name='当日发展(2小时)'
group by day_id


select day_id,count(*),count(distinct mobile) from sys_cat_log a where a.SYS_KIND='3' and day_id like '201804%'
and report_name='当日发展(2小时)'
group by day_id


select day_id,count(*),count(distinct mobile) from sys_cat_log a where a.SYS_KIND='3' and day_id like '201804%' 
group by day_id;


select day_id, count(*), count(distinct mobile)
  from sys_cat_log a
 where a.SYS_KIND = '3'
   and day_id like '201804%'
   and a.USER_ID in (select ispire_staffid
                       from cs_dss.oa_org_user_name_mulu@hbods
                      where user_title like '%经理%')
 group by day_id
 


 select user_id,user_name, count(*)
  from sys_cat_log a
 where a.SYS_KIND = '3'
   and day_id like '201804%'
   and a.USER_ID in (select ispire_staffid
                       from cs_dss.oa_org_user_name_mulu@hbods
                      where user_title like '%经理%')
 group by user_id,user_name
