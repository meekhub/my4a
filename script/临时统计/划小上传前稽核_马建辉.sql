select acct_month,count(*) from  BWT_CNTRT_MGMT_UNIT_M A
 WHERE ACCT_MONTH >= '201801'  group by acct_month
 
select * from  BWT_CNTRT_MGMT_UNIT_M A
 WHERE ACCT_MONTH = '201805' and a.cntrt_agrmnt_cd is null


select acct_month,count(*) from  BWT_CNTRT_MGMT_CHNL_REL_M A
 WHERE ACCT_MONTH >= '201801'  group by acct_month


select acct_month,count(*) from  BWT_CNTRT_MGMT_MAIN_REL_M A
 WHERE ACCT_MONTH >= '201801'  group by acct_month
 
 select * from  BWT_CNTRT_MGMT_MAIN_REL_M A
 WHERE ACCT_MONTH = '201805' and a.CNTRT_MGMT_CEO_CD is null

 
 select acct_month,count(*) from  bwt_cntrt_mgmt_sum_m A
 WHERE ACCT_MONTH >= '201801'  group by acct_month

select huaxiao_type,count(*) from dim.dim_huaxiao_info t group by huaxiao_type

SELECT CNTRT_MGMT_TYPE, COUNT(*)
  FROM BWT_CNTRT_MGMT_UNIT_M A
 WHERE ACCT_MONTH = '201805'
 GROUP BY A.CNTRT_MGMT_TYPE

SELECT COUNT(*), COUNT(DISTINCT CNTRT_MGMT_UNIT_CD)
  FROM (SELECT DISTINCT H_LEVEL_UNIT_NAME,
                        SUBSTR(A.CNTRT_MGMT_UNIT_CD, 1, 8) CNTRT_MGMT_UNIT_CD
          FROM BWT_CNTRT_MGMT_UNIT_M A
         WHERE ACCT_MONTH = '201802')


SELECT COUNT(*), CNTRT_MGMT_UNIT_CD
  FROM (SELECT DISTINCT H_LEVEL_UNIT_NAME,
                        SUBSTR(A.CNTRT_MGMT_UNIT_CD, 1, 8) CNTRT_MGMT_UNIT_CD
          FROM BWT_CNTRT_MGMT_UNIT_M A
         WHERE ACCT_MONTH = '201802')
group by CNTRT_MGMT_UNIT_CD
having count(*)>1


select * from BWT_CNTRT_MGMT_UNIT_M WHERE ACCT_MONTH = '201802' and CNTRT_MGMT_UNIT_CD like '81306001%';


select 
b.area_desc,a.h_level_unit_name,a.cntrt_mgmt_unit_cd,a.cntrt_mgmt_unit_nm,
case when a.cntrt_mgmt_unit_level='10' then '一级单元'
  when a.cntrt_mgmt_unit_level='20' then '二级单元'
    when a.cntrt_mgmt_unit_level='30' then '三级单元'
      when a.cntrt_mgmt_unit_level='40' then '四级单元'
        when a.cntrt_mgmt_unit_level='50' then '五级单元'
          end ，
      c.cb_second_name,
          
 from BWT_CNTRT_MGMT_UNIT_M a,dim.dim_area_no_jt b,dim.dim_cntrt_mgmt_type c WHERE ACCT_MONTH = '201802'
 and a.latn_id=b.std_latn_cd
 and a.cntrt_mgmt_type=c.CB_SECOND_TYPE
 
 select * from  dim.dim_cntrt_mgmt_type;
select * from  dim.dim_cntrt_mgmt_check_type




