--一卡多机
CREATE TABLE TMP_MAJH_TERM_2016 AS
SELECT AREA_NO, TERMINAL_CODE, TERMINAL_CORP, TERMINAL_MODEL,DEVICE_NO
  FROM DW.DW_V_USER_TERMINAL_DEVICE_M A
 WHERE ACCT_MONTH = '201612'
   AND TO_CHAR(REG_DATE, 'YYYYMM') >= '201601';
   


--取出有重复的号码
create table TMP_MAJH_TERM_2016_2 as
 select device_no from TMP_MAJH_TERM_2016
 group by device_no having count(*)>1

   
select
b.area_desc,count(*),count(c.device_no),count(distinct c.device_no)
 from TMP_MAJH_TERM_2017 a,dim.dim_area_no b,TMP_MAJH_TERM_2017_01 c
where a.area_no=b.area_no(+)
and a.device_no=c.device_no(+)
group by b.area_desc,b.idx_no
order  by b.idx_no



select
a.TERMINAL_CORP,count(*),count(c.device_no)
 from TMP_MAJH_TERM_2017 a,TMP_MAJH_TERM_2017_01 c
where  a.device_no=c.device_no(+)  
group by a.TERMINAL_CORP


select
a.TERMINAL_CORP,a.TERMINAL_model,count(*),count(c.device_no)
 from TMP_MAJH_TERM_2017 a,TMP_MAJH_TERM_2017_01 c
where  a.device_no=c.device_no(+)  
group by a.TERMINAL_CORP,a.TERMINAL_model
