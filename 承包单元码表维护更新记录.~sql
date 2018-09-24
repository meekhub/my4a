--两张7月8号备份表
dim_cbdy_and_channel_0708
dim_cbdy_detail_0708

select a.* from dim_cbdy_and_channel_0708 a,
dim_cbdy_detail_0708 b
where a.cbdy_no=b.cbdy_no(+)
and b.cbdy_no is null

create table temp_user.new_cbdy_and_channel as
select * from dim.dim_cbdy_and_channel where to_char(update_date,'yyyymmdd')>='20170709' 

delete from DIM.DIM_CBDY_AND_CHANNEL

INSERT INTO DIM.DIM_CBDY_AND_CHANNEL
  SELECT AREA_NO,
         CITY_NO,
         CBDY_NO,
         CHANNEL_ID,
         CHANNEL_NAME,
         IF_VALID,
         UPDATE_DATE,
         UPDATE_USER
    FROM (SELECT A.*,
                 ROW_NUMBER() OVER(PARTITION BY CHANNEL_ID ORDER BY NVL(UPDATE_DATE, SYSDATE))rn
            FROM (SELECT *
                    FROM DIM_CBDY_AND_CHANNEL_0708
                  UNION
                  SELECT * FROM TEMP_USER.NEW_CBDY_AND_CHANNEL) A)
   WHERE RN = 1
   
   
select a.* from DIM.DIM_CBDY_AND_CHANNEL a,
dim.dim_cbdy_detail b
where a.cbdy_no=b.cbdy_no(+)
and b.cbdy_no is null
   
/*create table temp_user.tmp_cbdy_and_channel as
select b.* from DIM.DIM_CBDY_AND_CHANNEL a,
dim.dim_cbdy_detail b
where a.cbdy_no(+)=b.cbdy_no
and a.cbdy_no is null;*/

select a.* from DIM.DIM_CBDY_AND_CHANNEL a,
dim.dim_cbdy_detail b
where a.cbdy_no(+)=b.cbdy_no
and a.cbdy_no is null

delete from dim.dim_cbdy_detail a
where exists
(select 1 from temp_user.tmp_cbdy_and_channel b where a.cbdy_no=b.cbdy_no)













