create table xxhb_mjh.tmp_majh_develop
(
huaxiao_no varchar2(20),
develop_no varchar2(20) ,
develop_name varchar2(100)  
) 


select * from xxhb_mjh.tmp_majh_develop


create table dim_hx_yw_channel_bak as
select * from dim_hx_yw_channel

truncate table dim_hx_yw_channel

INSERT INTO DIM_HX_YW_CHANNEL
  SELECT B.AREA_NO,
         B.CITY_NO,
         A.DEVELOP_NO AS CHANNEL_NO,
         NVL(A.DEVELOP_NAME, 'δ֪') AS CHANNEL_NO_DESC,
         A.HUAXIAO_NO,
         B.HUAXIAO_NAME,
         B.HUAXIAO_TYPE,
         B.HUAXIAO_TYPE_NAME,
         B.IF_VALID,
         B.UPDATE_USER,
         B.UPDATE_DATE,
         B.IDX_NO,
         B.HUAXIAO_TYPE_BIG,
         B.HUAXIAO_TYPE_NAME_BIG
    FROM XXHB_MJH.TMP_MAJH_DEVELOP A, DIM.DIM_HUAXIAO_INFO B
   WHERE A.HUAXIAO_NO = B.HUAXIAO_NO
     AND B.HUAXIAO_TYPE = '06'
     AND A.DEVELOP_NO IS NOT NULL
