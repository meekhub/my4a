create table tmp_majh_0503_trm_01 as
select 
a.area_no,
count(distinct case when to_char(a.reg_date,'yyyy')='2017' then a.terminal_code end)col1,
count(distinct case when  to_char(a.reg_date,'yyyy')='2017' and b.mobile_no is not null then a.terminal_code end)col2,
count(distinct case when  to_char(reg_date,'yyyy')='2018' then a.terminal_code end)col3,
count(distinct case when  to_char(a.reg_date,'yyyy')='2018' and b.mobile_no is not null then a.terminal_code end)col4,
count(distinct case when  to_char(reg_date,'yyyymm') between '201801' and '201803' then a.terminal_code end)col5,
count(distinct case when  to_char(reg_date,'yyyymm') between '201801' and '201803' and b.mobile_no is not null then a.terminal_code end)col6,
count(distinct case when  to_char(reg_date,'yyyymm') ='201804' then a.terminal_code end)col7,
count(distinct case when  to_char(reg_date,'yyyymm') ='201804' and b.mobile_no is not null then a.terminal_code end)col8
 from 
(SELECT *
  FROM DW.DW_V_USER_TERMINAL_DEVICE_M A
 WHERE ACCT_MONTH = '201804')a,
 crm_dsg.ir_mobile_using_t@HBODS b
 where a.terminal_code=b.mobile_no(+)
 group by a.area_no;
 
 
 
 
 select b.area_desc,a.* from tmp_majh_0503_trm_01 a,dim.dim_area_no b
 where a.area_no=b.area_no 
 order by b.idx_no
 
 
  select b.area_desc,a.* from tmp_majh_0503_trm_02 a,dim.dim_area_no b
 where a.area_no=b.area_no 
 order by b.idx_no
