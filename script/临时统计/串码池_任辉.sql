create table  tmp_majh_1127_03 as
select * from tmp_majh_1127_01 where 1=2;

/*create table tmp_majh_1127_02 as
SELECT A.AREA_NO,
       A.TERMINAL_CODE,
       CASE
         WHEN B.MOBILE_NO IS NOT NULL THEN
          '1'
         ELSE
          '0'
       END flag,
       in_date
  FROM (SELECT AREA_NO, TERMINAL_CODE
          FROM DW.DW_V_sUSER_TERMINAL_DEVICE_M A
         WHERE ACCT_MONTH = '201710'
           AND TO_CHAR(REG_DATE, 'YYYYMM') >= '201701') A,
       (SELECT \*+PARALLEL(A,3)*\
         MOBILE_NO,
         USED_DATE,
         OPERATE_DATE,
         SUGGEST_PRICE,
         PHONE_NUMBER,
         RESOURCE_KIND,
         TO_CHAR(in_DATE, 'YYYYMMDD')in_date
          FROM crm_dsg.ir_mobile_using_t@HBODS  A --终端出入库信息表 
) B
 WHERE A.TERMINAL_CODE = B.MOBILE_NO(+);*/
 
create table tmp_majh_1127_03 as
SELECT A.AREA_NO,
       A.TERMINAL_CODE,
       CASE
         WHEN B.MOBILE_NO IS NOT NULL THEN
          '1'
         ELSE
          '0'
       END flag,
       a.terminal_corp,
       a.terminal_model
  FROM (SELECT AREA_NO, TERMINAL_CODE,terminal_corp,terminal_model
          FROM DW.DW_V_USER_TERMINAL_DEVICE_M A
         WHERE ACCT_MONTH = '201803'
           AND TO_CHAR(REG_DATE, 'YYYYMM') >= '201801') A,
       (SELECT /*+PARALLEL(A,3)*/
         MOBILE_NO,
         USED_DATE,
         OPERATE_DATE,
         SUGGEST_PRICE,
         PHONE_NUMBER,
         RESOURCE_KIND,
         TO_CHAR(in_DATE, 'YYYYMMDD')in_date
          FROM crm_dsg.ir_mobile_using_t@HBODS  A --终端出入库信息表 
) B
 WHERE A.TERMINAL_CODE = B.MOBILE_NO(+);
 

create table tmp_majh_0412_trm_01 as
SELECT T2.*
  FROM (SELECT T2.*,
               ROW_NUMBER() OVER(PARTITION BY T2.TERMINAL_CODE ORDER BY T2.REG_DATE DESC) RN
          FROM (SELECT '999' AREA_NO,
                       D.RGST_MDL TERMINAL_MODEL,
                       D.ESN TERMINAL_CODE,
                       SUBSTR(D.RGST_DT, 1, 8) REG_DATE
                  FROM ALLDM.BWT_DOWN_RGST_TRMNL_PRVNC@oldhbdw D
                 WHERE SUBSTR(D.RGST_DT, 1, 6) >='201801'
                   AND D.RGST_PRVNCE <> '813') T2) T2
 WHERE RN = 1;

 
 --本省号码他省开机
 create table tmp_majh_1127_04 as 
select a.area_no,
       a.terminal_corp,
       a.terminal_model,
       count(distinct a.terminal_code) ter_cnt,
       count(distinct case
               when b.terminal_code is not null then
                a.terminal_code
             end) other_cnt
  from (select * from tmp_majh_1127_03 where flag = '1') a,
         tmp_majh_0412_trm_01 b --本省出库终端在他省注册
 where a.terminal_code = b.terminal_code(+)
 group by a.area_no,a.terminal_corp,a.terminal_model;

--他省号码本省开机
 create table tmp_majh_1127_05 as 
select a.area_no,
       a.terminal_corp,
       a.terminal_model,
       count(distinct a.terminal_code) ter_cnt,
       count(distinct case
               when b.termkey is not null then
                a.terminal_code
             end) other_cnt
  from (select * from tmp_majh_1127_03 where flag = '0') a,
         crm_dsg.BI_MDN_TERMINFO_IMP_T@hbods b --他省出库终端在本省注册
 where a.terminal_code = b.termkey(+)
 group by a.area_no,a.terminal_corp,a.terminal_model;

--他省出库终端在本省注册
select * from crm_dsg.BI_MDN_TERMINFO_IMP_T@hbods

--集团集约 LDAPM_LTE_BO_TERM_ORDER
select * from alldm.bwt_down_lte_bo_term_order


-- 表一、分地市注册串码入库情况
 --汇总
 select x.area_desc,count(*),sum(case when flag=1 then 1 else 0 end),
sum(case when flag=0 then 1 else 0 end)
 from tmp_majh_1127_03 t ,dim.dim_area_no x
where t.area_no=x.area_no
group by x.area_desc,x.idx_no
order by x.idx_no;

--外省注册数量（窜出）
 select x.area_desc,sum(OTHER_CNT)
 from tmp_majh_1127_04 t ,dim.dim_area_no x
where t.area_no=x.area_no
group by x.area_desc,x.idx_no
order by x.idx_no;

--其中在外省入库（窜入）
select 
a.area_desc,sum(t.ter_cnt),sum(t.other_cnt)
 from tmp_majh_1127_05 t,dim.dim_area_no a
where t.area_no=a.area_no
group by a.area_desc,a.idx_no
order by a.idx_no


-- 表二、 TOP10品牌注册串码入库情况
select t.terminal_corp,count(*) cnt1,sum(case when flag=1 then 1 else 0 end)cnt2,
sum(case when flag=0 then 1 else 0 end) cnt3
 from (select * from  tmp_majh_1127_03 where terminal_corp<>'未知厂商') t 
group by t.terminal_corp;
  
--外省注册数量（窜出）
 select t.terminal_corp,sum(OTHER_CNT)
 from tmp_majh_1127_04 t,tmp_majh_term_1212_1 x
where  t.terminal_corp =x.terminal_corp
group by t.terminal_corp,x.idx_no
order by x.idx_no

--其中在外省入库（窜入）
select 
t.terminal_corp,sum(t.other_cnt)
 from tmp_majh_1127_05 t,tmp_majh_term_1212_1 x
 where t.terminal_corp=x.terminal_corp
group by t.terminal_corp,x.idx_no
order by x.idx_no

-- 表三、  TOP50机型注册串码入库情况
select t.terminal_corp||'-'||t.terminal_model,count(*) cnt1,sum(case when flag=1 then 1 else 0 end)cnt2,
sum(case when flag=0 then 1 else 0 end) cnt3
 from (select * from  tmp_majh_1127_03 where terminal_corp<>'未知厂商') t 
group by t.terminal_corp||'-'||t.terminal_model;
  
--外省注册数量（窜出）
 select t.terminal_corp||'-'||t.terminal_model,sum(OTHER_CNT)
 from tmp_majh_1127_04 t,tmp_majh_term_1212_2 x
where  t.terminal_corp||'-'||t.terminal_model =x.terminal_model
group by t.terminal_corp||'-'||t.terminal_model,x.idx_no
order by x.idx_no

--其中在外省入库（窜入）
 select t.terminal_corp||'-'||t.terminal_model,sum(OTHER_CNT)
 from tmp_majh_1127_05 t,tmp_majh_term_1212_2 x
where  t.terminal_corp||'-'||t.terminal_model =x.terminal_model
group by t.terminal_corp||'-'||t.terminal_model,x.idx_no
order by x.idx_no
 

--sheet3 BSS入库串码注册情况
create table tmp_majh_1127_06 as
SELECT a.RESOURCE_KIND,
       count(distinct a.mobile_no) total_cnt,
       a.terminal_corp,
       a.terminal_model
  FROM 
  (SELECT /*+PARALLEL(A,3)*/
         MOBILE_NO,
         USED_DATE,
         OPERATE_DATE,
         SUGGEST_PRICE,
         PHONE_NUMBER,
         RESOURCE_KIND,
         TO_CHAR(in_DATE, 'YYYYMMDD')in_date
          FROM crm_dsg.ir_mobile_using_t@HBODS  A --终端出入库信息表 
) a,
  (SELECT AREA_NO, TERMINAL_CODE,terminal_corp,terminal_model
          FROM DW.DW_V_USER_TERMINAL_DEVICE_M A
         WHERE ACCT_MONTH = '201710'
           AND TO_CHAR(REG_DATE, 'YYYYMM') >= '201701') b 
 WHERE a.MOBILE_NO = b.TERMINAL_CODE(+);
 


create table tmp_majh_reg_01 as 
SELECT 
a.resource_kind,
count(distinct a.mobile_no)rk_cnt,
count(distinct b.terminal_code)reg_cnt,
count(distinct case when b.terminal_code is not null then c.esn end)in_reg_cnt,
count(distinct case when b.terminal_code is null then c.esn end)out_reg_cnt
  FROM (SELECT /*+PARALLEL(A,3)*/
         MOBILE_NO,
         USED_DATE,
         OPERATE_DATE,
         SUGGEST_PRICE,
         PHONE_NUMBER,
         RESOURCE_KIND,
         TO_CHAR(IN_DATE, 'YYYYMMDD') IN_DATE
          FROM CRM_DSG.IR_MOBILE_USING_T@HBODS A --终端出入库信息表
         WHERE TO_CHAR(OPERATE_DATE, 'YYYYMM') >= '201701') A
  LEFT JOIN (SELECT AREA_NO, TERMINAL_CODE, TERMINAL_CORP, TERMINAL_MODEL
               FROM DW.DW_V_USER_TERMINAL_DEVICE_M A
              WHERE ACCT_MONTH = '201711') B
    ON A.MOBILE_NO = B.TERMINAL_CODE
  left join
  alldm.bwt_down_rgst_trmnl_prvnc c
  on a.mobile_no=c.esn
  group by a.resource_kind;
  
  
--sheet3
select 
upper(b.RESOURCE_MANUFACTURER),
sum(a.rk_cnt),
sum(a.reg_cnt),
sum(a.in_reg_cnt),
sum(a.out_reg_cnt)
 from tmp_majh_reg_01 a,
(
SELECT *
  FROM (SELECT TRIM(RESOURCE_MANUFACTURER) RESOURCE_MANUFACTURER,
               TRIM(RESOURCE_KIND_ID) RESOURCE_KIND_ID,
               TRIM(RESOURCE_KIND_NO) RESOURCE_KIND_NO,
               TRIM(RESOURCE_KIND_NAME) RESOURCE_KIND_NAME,
               ROW_NUMBER() OVER(PARTITION BY RESOURCE_KIND_NO ORDER BY RESOURCE_KIND_ID DESC) RN
          FROM DSG_STAGE.IR_GET_RESOURCE_KIND_T F) F
 WHERE RN = 1
)b
where a.resource_kind=b.RESOURCE_KIND_NO
group by upper(b.RESOURCE_MANUFACTURER)
  


select 
b.RESOURCE_KIND_NAME,
sum(a.rk_cnt),
sum(a.reg_cnt),
sum(a.in_reg_cnt),
sum(a.out_reg_cnt)
 from tmp_majh_reg_01 a,
(
SELECT *
  FROM (SELECT TRIM(RESOURCE_MANUFACTURER) RESOURCE_MANUFACTURER,
               TRIM(RESOURCE_KIND_ID) RESOURCE_KIND_ID,
               TRIM(RESOURCE_KIND_NO) RESOURCE_KIND_NO,
               TRIM(RESOURCE_KIND_NAME) RESOURCE_KIND_NAME,
               ROW_NUMBER() OVER(PARTITION BY RESOURCE_KIND_NO ORDER BY RESOURCE_KIND_ID DESC) RN
          FROM DSG_STAGE.IR_GET_RESOURCE_KIND_T F) F
 WHERE RN = 1
)b
where a.resource_kind=b.RESOURCE_KIND_NO
group by b.RESOURCE_KIND_NAME



--一卡多机
CREATE TABLE TMP_MAJH_TERM_2017 AS
SELECT AREA_NO, TERMINAL_CODE, TERMINAL_CORP, TERMINAL_MODEL,DEVICE_NO
  FROM DW.DW_V_USER_TERMINAL_DEVICE_M A
 WHERE ACCT_MONTH = '201710'
   AND TO_CHAR(REG_DATE, 'YYYYMM') >= '201701';
   


--取出有重复的号码
create table TMP_MAJH_TERM_2017_01 as
 select device_no from TMP_MAJH_TERM_2017
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


--区分省内入库还是省外入库
select
b.area_desc,count(*),count(c.device_no),count(case when d.flag='1' then c.device_no end)
 from TMP_MAJH_TERM_2017 a,dim.dim_area_no b,TMP_MAJH_TERM_2017_01 c,tmp_majh_1127_03 d
where a.area_no=b.area_no(+)
and a.device_no=c.device_no(+)
and a.terminal_code=d.terminal_code(+)
group by b.area_desc,b.idx_no
order  by b.idx_no



select
a.TERMINAL_CORP,count(*),count(c.device_no),count(case when d.flag='1' then c.device_no end),count(distinct case when d.flag='1' then c.device_no end)
 from TMP_MAJH_TERM_2017 a,TMP_MAJH_TERM_2017_01 c,tmp_majh_1127_03 d
where  a.device_no=c.device_no(+)  
and a.terminal_code=d.terminal_code(+)
group by a.TERMINAL_CORP


select
a.TERMINAL_CORP,a.TERMINAL_model,count(*),count(c.device_no),count(case when d.flag='1' then c.device_no end),count(distinct case when d.flag='1' then c.device_no end)
 from TMP_MAJH_TERM_2017 a,TMP_MAJH_TERM_2017_01 c,tmp_majh_1127_03 d
where  a.device_no=c.device_no(+)  
and a.terminal_code=d.terminal_code(+)
group by a.TERMINAL_CORP,a.TERMINAL_model






/*create table tmp_majh_corp_01
(
terminal_corp varchar2(20),
idx_no number
)


select a.terminal_corp,count(case when b.flag='1' then b.terminal_code end) from tmp_majh_corp_01 a,tmp_majh_1127_03 b
where a.terminal_corp=b.terminal_corp
group by a.terminal_corp,a.idx_no
order by a.idx_no;


create table tmp_majh_model_01
(
terminal_model varchar2(40),
idx_no number
)



select a.terminal_model,count(case when b.flag='1' then b.terminal_code end) from tmp_majh_model_01 a,tmp_majh_1127_03 b
where a.terminal_model=b.terminal_model
group by a.terminal_model,a.idx_no
order by a.idx_no;*/




