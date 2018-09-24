select * from dim.dim_channel_type where channel_type  in ('110101', '110102', '110103')


--
SELECT B.CHANNEL_TYPE, B.CHANNEL_TYPE_DESC, COUNT(DISTINCT A.CHANNEL_NO)
  FROM DIM.DIM_CHANNEL_NO A, DIM.DIM_CHANNEL_TYPE B
 WHERE A.CHANNEL_TYPE = B.CHANNEL_TYPE
   AND A.VALID_STATUS = 1 and SUBSTR(b.CHANNEL_TYPE,1,2)='11'
 GROUP BY B.CHANNEL_TYPE, B.CHANNEL_TYPE_DESC
 
 
 
 
 select * from dim.dim_channel_type where channel_type=110101;
 select * from dim.dim_channel_no where channel_type=110101 and valid_status=1;
 
 select * from dba_dependencies x where x.referenced_name='DIM_CBDY_DETAIL';
 
DMPRO.P_DMPRO_DIM_DAY

select * from DIM.DIM_CBDY_DETAIL where CBJY_COMP_TYPE=3010

--整体情况
select c.cntrt_mgmt_type,count(*) from BWT_CNTRT_MGMT_UNIT_M c where acct_month='201706'
group by c.cntrt_mgmt_type;


--自有渠道  目前上传的自有厅数量(对应集团3010  店长承包)
create table tmp_majh_0703_02 as 
SELECT A.CBDY_NO,a.cbjy_comp_name,'3010' flag
  FROM DIM.DIM_CBDY_DETAIL A, DIM.DIM_CHANNEL_NO B
 WHERE A.CBJY_COMP_TYPE = 3010
   AND A.CITY_NO = B.CITY_NO
   AND A.CBJY_COMP_NAME = B.CHANNEL_NO_DESC
   AND B.CHANNEL_TYPE = 110101
   AND B.VALID_STATUS = 1;
   
--600
insert into tmp_majh_0703_02
SELECT RPAD(A.CBDY_AREA || '6', 11, 0) + ROWNUM AS CBDY_NO,
       A.CHANNEL_NO_DESC,'3010'
  FROM (SELECT *
          FROM DIM.DIM_CHANNEL_NO X, DIM.DIM_AREA_CBDY_NO Y
         WHERE CHANNEL_TYPE = 110101
           AND VALID_STATUS = 1
           AND X.AREA_NO = Y.AREA_NO) A,
       (SELECT A.CBDY_NO, A.CBJY_COMP_NAME
          FROM DIM.DIM_CBDY_DETAIL A, DIM.DIM_CHANNEL_NO B
         WHERE A.CBJY_COMP_TYPE = 3010
           AND A.CITY_NO = B.CITY_NO
           AND A.CBJY_COMP_NAME = B.CHANNEL_NO_DESC
           AND B.CHANNEL_TYPE = 110101
           AND B.VALID_STATUS = 1) B
 WHERE A.CHANNEL_NO_DESC = B.CBJY_COMP_NAME(+)
   AND B.CBJY_COMP_NAME IS NULL
;


--卖场（对应集团3020，按商承包） --不上传
INSERT INTO TMP_MAJH_0703_02
  SELECT CNTRT_MGMT_UNIT_CD, CNTRT_MGMT_UNIT_NM,3020
    FROM BWT_CNTRT_MGMT_UNIT_M C
   WHERE ACCT_MONTH = '201705'
     AND C.CNTRT_MGMT_TYPE = 3020

--商圈(对应集团3030  按片承包)
INSERT INTO TMP_MAJH_0703_02
  SELECT distinct 81311600078 + ROWNUM AS CBDY_NO, b.business_zone_name,3030
    from
    (select distinct b.business_zone_name FROM DIM.DIM_CHANNEL_NO A, TMP_MAJH_0703_01 B, DIM.DIM_CHANNEL_TYPE C
   WHERE A.CHANNEL_NO = B.CHANNEL_NO
     AND A.CHANNEL_TYPE = C.CHANNEL_TYPE
     AND A.VALID_STATUS = 1
     AND A.CHANNEL_TYPE <> 110101)b where b.business_zone_name is not null


delete from TMP_MAJH_0703_02 where flag=3030

--汇总
select flag,count(*),count(distinct cbdy_no) from TMP_MAJH_0703_02 group by flag;


select count(*),count(distinct channel_no),count(distinct cbjy_comp_name) from TMP_MAJH_0703_02 where flag=3030


select distinct cbjy_comp_name from TMP_MAJH_0703_02 where flag=3030 and cbjy_comp_name is not null

delete from TMP_MAJH_0703_02 where cbjy_comp_name is  null;


--
create table tmp_majh_0704_01 as 
select * from BWT_CNTRT_MGMT_UNIT_M c where acct_month='201705';

delete from tmp_majh_0704_01 where CNTRT_MGMT_TYPE<>1020



INSERT INTO TMP_MAJH_0704_01
SELECT 
distinct '201705',
'813',
CBDY_NO,
CBJY_COMP_NAME,
FLAG,
30,
CBDY_NO
FROM TMP_MAJH_0703_02 ;

create table dim.dim_cbdy_jt as
select * from tmp_majh_0703_02;


select x.cntrt_mgmt_type,count(*),count(distinct x.cntrt_mgmt_unit_cd) from TMP_MAJH_0704_01 x group by x.cntrt_mgmt_type



SELECT * FROM  TMP_MAJH_0704_01;


select * from BWT_SMALL_ORG_INFO where acct_month='201705'

--备份
create table DIM_CBDY_DETAIL_0708 as
select * from dim.dim_cbdy_detail;


create table DIM_CBDY_AND_CHANNEL_0708 as
select * from dim.DIM_CBDY_AND_CHANNEL

--修正dim_cbdy_detail
select count(*) from dim.dim_cbdy_detail



delete from  dim.dim_cbdy_detail a
where not exists
(select 1 from tmp_majh_0703_02 b where a.cbdy_no=b.cbdy_no)

select count(*) from dim.dim_cbdy_and_channel

/*delete from dim.DIM_CBDY_AND_CHANNEL a where not exists
(select 1 from dim.dim_cbdy_detail b where a.cbdy_no=b.cbdy_no)*/
create table tmp_majh_0708_01 as 
SELECT RPAD(A.CBDY_AREA || '6', 11, 0) + ROWNUM AS CBDY_NO,
       A.CHANNEL_NO_DESC,'3010' as cbdy_type,a.channel_no
  FROM (SELECT *
          FROM DIM.DIM_CHANNEL_NO X, DIM.DIM_AREA_CBDY_NO Y
         WHERE CHANNEL_TYPE = 110101
           AND VALID_STATUS = 1
           AND X.AREA_NO = Y.AREA_NO) A,
       (SELECT A.CBDY_NO, A.CBJY_COMP_NAME
          FROM DIM.DIM_CBDY_DETAIL A, DIM.DIM_CHANNEL_NO B
         WHERE A.CBJY_COMP_TYPE = 3010
           AND A.CITY_NO = B.CITY_NO
           AND A.CBJY_COMP_NAME = B.CHANNEL_NO_DESC
           AND B.CHANNEL_TYPE = 110101
           AND B.VALID_STATUS = 1) B
 WHERE A.CHANNEL_NO_DESC = B.CBJY_COMP_NAME(+)
   AND B.CBJY_COMP_NAME IS NULL;

delete from dim.dim_cbdy_and_channel a where exists (select 1 from tmp_majh_0708_01 b
where b.channel_no=a.channel_id)

insert into dim.dim_cbdy_and_channel
select 
'' area_no, 
'' city_no, 
cbdy_no, 
channel_no channel_id, 
CHANNEL_NO_DESC channel_name, 
'1' if_valid, 
'' update_date, 
'' update_user
from tmp_majh_0708_01;

--商圈
create table tmp_majh_0708_02 as
SELECT A.CBDY_NO, B.AREA_NO, B.CITY_NO, B.CHANNEL_NO,b.channel_name,B.BUSINESS_ZONE_NAME
  FROM TMP_MAJH_0703_02 A, TMP_MAJH_0703_01 B
 WHERE A.CBJY_COMP_NAME = B.BUSINESS_ZONE_NAME

delete from dim.dim_cbdy_and_channel a where exists (select 1 from tmp_majh_0708_02 b
where b.channel_no=a.channel_id)

insert into dim.dim_cbdy_and_channel
select 
a.area_no, 
a.city_no, 
a.cbdy_no, 
a.channel_no channel_id, 
a.channel_name channel_name, 
'1' if_valid, 
'' update_date, 
'' update_user
from tmp_majh_0708_02 a;



select * from tmp_majh_0703_02



--修正表
create table tmp_majh_0710_01 as 
SELECT CBDY_NO, CBJY_COMP_NAME, FLAG, AREA_NO, CITY_NO
  FROM (SELECT T.*,
               X.AREA_NO,
               X.CITY_NO,
               ROW_NUMBER() OVER(PARTITION BY T.CBDY_NO ORDER BY 1) RN
          FROM TMP_MAJH_0703_02 T, TMP_MAJH_0703_01 X
         WHERE T.CBJY_COMP_NAME = X.BUSINESS_ZONE_NAME) A
 WHERE RN = 1
;

insert into tmp_majh_0710_01
SELECT CBDY_NO, CBJY_COMP_NAME, FLAG, AREA_NO, CITY_NO
  FROM (SELECT A.*,
               B.AREA_NO,
               B.CITY_NO,
               ROW_NUMBER() OVER(PARTITION BY CBDY_NO ORDER BY 1) RN
          FROM TMP_MAJH_0703_02 A, DIM.DIM_CHANNEL_NO B
         WHERE FLAG = 3010
           AND A.CBJY_COMP_NAME = B.CHANNEL_NO_DESC)
 WHERE RN = 1

insert Into dim.dim_cbdy_detail 
select 
a.cbdy_no, 
a.area_no, 
a.city_no, 
'' zhiju_level, 
'' zhiju_type, 
'' zhiju_manager, 
'' zhiju_username, 
a.CBJY_COMP_NAME cbjy_comp_name, 
a.flag cbjy_comp_type, 
'' cbjy_comp_bigtype, 
'30' cbjy_comp_khtype, 
'' cbdy_xieyi_code, 
'' if_valid, 
'' create_user, 
'' create_date, 
'' update_user, 
'' update_date, 
'' province_no
 from tmp_majh_0710_01 a where not exists
(select 1 from dim.dim_cbdy_detail b where a.cbdy_no=b.cbdy_no)


