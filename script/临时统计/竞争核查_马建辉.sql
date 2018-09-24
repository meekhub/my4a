select decode(GROUP_TYPE,'1','移动','2','联通','3','电信'),
sum(case when t.user_type='1' then t.user_num else 0 end)到达,
sum(case when t.user_type='3' then t.user_num else 0 end)新增,
sum(case when t.user_type='4' then t.user_num else 0 end)流失
from dm_market_day_list t where t.acct_date='20180201'  
group by decode(GROUP_TYPE,'1','移动','2','联通','3','电信')




create table tmp_majh_0502_01 as
select a.* from 
(SELECT prd_inst_id, acc_nbr
  FROM CPT_SERV_CT_CUR B
 WHERE B.ACCT_MONTH = '201805'
   AND B.DAY_ID = '01'
   and net_type_id = '1020'
   and reach_flag='1'
   )a,
   (SELECT prd_inst_id, acc_nbr
  FROM CPT_SERV_CT_CUR B
 WHERE B.ACCT_MONTH = '201805'
   AND B.DAY_ID = '02'
   and net_type_id = '1020'
   and reach_flag='1'
   )b
   where a.prd_inst_id=b.prd_inst_id(+)
   and b.prd_inst_id is null


select count(*),count(distinct acc_nbr) from tmp_majh_0502_01;




select count(*) from  dw.dw_v_user_cdr_cdma a where acct_month='201805' and CALL_DATE='02'


create table xxhb_mjh.tmp_majh_0502_01 as 
select 
a.*,b.*
 from js_report.tmp_majh_0502_01@hbods a,
(select user_no from  dw.dw_v_user_cdr_cdma where acct_month='201805' and CALL_DATE='02'
union all
select user_no from  dw.dw_v_user_cdr_cdma_ocs where acct_month='201805' and CALL_DATE='02'
)b
where a.prd_inst_id=b.user_no(+);



select * from xxhb_mjh.tmp_majh_0502_01 where user_no is not null;


create table tmp_majh_0502_03 as
select 
a.*,b.user_status,b.is_onnet,user_dinner_desc
 from xxhb_mjh.tmp_majh_0502_01 a,
(
select user_no,user_status,is_onnet,user_dinner_desc from dw.dw_v_user_base_info_day a
where acct_month='201805'
and day_id='02' 
and tele_type='2' 
)b
where a.PRD_INST_ID=b.user_no(+)


select b.user_status_desc, count(*)
  from tmp_majh_0502_03 a, dim.dim_user_status b
 where a.USER_STATUS = b.user_status
 group by b.user_status_desc;
 
 
 select user_dinner_desc, count(*)
   from tmp_majh_0502_03
  where user_status = '1'
  group by user_dinner_desc






