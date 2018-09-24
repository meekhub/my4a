drop table tmp_majh_zhu_call_0724
create table tmp_majh_zhu_call_0724 
(
col1 varchar(50),
col2 varchar(50),
col3 varchar(50),
col4 varchar(50),
col5 varchar(50),
col6 varchar(50),
col7 varchar(50),
col8 varchar(50),
col9 varchar(50),
col10 varchar(50),
col11 varchar(50),
col12 varchar(50)  
)
drop table tmp_majh_zhu_call_0724_2

create table tmp_majh_zhu_call_0724_5
(
col1 varchar(50), 
col13 integer,
col14 integer 
)

tmp_majh_zhu_call_0724_3 --201706
tmp_majh_zhu_call_0724_4 --201705

insert into tmp_majh_zhu_call_0724
{
select * from alldm.tmp_majh_zhu_call_0724
}@hbdw


select * from tmp_majh_zhu_call_0724

INSERT INTO tmp_majh_zhu_call_0724_2
  SELECT  
         A.COL1, 
         nvl(COUNT(CASE
                 WHEN B.ORG_TRM_ID = '10' THEN
                  B.OPPOSE_NUMBER
               END),0) ZHU_CALL_CDR, --主叫通话次数
         nvl(COUNT(CASE
               WHEN B.LONG_TYPE <> '10' AND B.ORG_TRM_ID = '10' THEN
                B.OPPOSE_NUMBER 
             END),0) LONG_DURATION --长途通话次数
    FROM tmp_majh_zhu_call_0724 A
    LEFT JOIN (SELECT DEVICE_NUMBER,OPPOSE_NUMBER,ORG_TRM_ID,LONG_TYPE
                 FROM DW_V_USER_CDR_CDMA B
                WHERE ACCT_MONTH in ('201706')
                union all
                SELECT DEVICE_NUMBER,OPPOSE_NUMBER,ORG_TRM_ID,LONG_TYPE
                 FROM DW_V_USER_CDR_CDMA_OCS B
                WHERE ACCT_MONTH in ('201706')
                ) B
      ON A.col2 = B.DEVICE_NUMBER
   GROUP BY A.COL1


select 
b.*,a.col13,a.col14
 from tmp_majh_zhu_call_0724_2 a, tmp_majh_zhu_call_0724 b
where a.col1=b.col1


select b.* from tmp_majh_zhu_call_0724 a,
(
select * from (SELECT B.*,
               ROW_NUMBER() OVER(PARTITION BY b.DEVICE_NUMBER ORDER BY b.INNET_DATE DESC) RN
          FROM (SELECT device_number,is_ocs,user_status_desc,INNET_DATE
                  FROM DW_V_USER_BASE_INFO_USER B 
                 WHERE B.ACCT_MONTH = '201706') B)
 WHERE RN = 1
)b
where a.col2=b.device_number

select y.*,x.col14/col13 as rate from 
(select col1,sum(col13)col13,sum(col14)col14 from 
(
select * from tmp_majh_zhu_call_0724_3
union all
select * from tmp_majh_zhu_call_0724_4
union all
select * from tmp_majh_zhu_call_0724_5
)
group by col1)x,
tmp_majh_zhu_call_0724 y
where x.col1=y.col1 








