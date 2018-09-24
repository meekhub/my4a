delete from dim.dim_huaxiao_info a where a.huaxiao_no='813020030170000';
select * from dim.dim_xiaoqu_huaxiao a where a.huaxiao_no='813020400070000';


create table dim.dim_huaxiao_info_1128 as
select * from dim.dim_huaxiao_info


delete from dim.dim_huaxiao_info a
where not exists
(select 1 from dim.dim_xiaoqu_huaxiao b where a.huaxiao_no=b.huaxiao_no)
and not exists
(select 1 from dim.dim_channel_huaxiao c where a.huaxiao_no=c.huaxiao_no)



MERGE INTO dim.dim_huaxiao_info A
  USING (select distinct huaxiao_no,huaxiao_name from  dim.dim_channel_huaxiao) B
  ON (A.Huaxiao_No = B.Huaxiao_No)
  WHEN MATCHED THEN
  UPDATE SET A.Huaxiao_Name=B.Huaxiao_Name;
