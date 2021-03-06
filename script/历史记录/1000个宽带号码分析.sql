--随机提取1000个宽带账号
create table temp_user.tmp_majh_0906_01 as
select * from 
(select upper(cell_phone) cell_phone
  from stage.bwt_down_gu_bdm_d t
 where t.day_id = '20170814'
   and cell_phone like 'ip%'
   order by DBMS_RANDOM.RANDOM) where rownum<1001;
  

create table temp_user.tmp_majh_0908_01 as
SELECT CELL_PHONE
  FROM (SELECT *
          FROM (SELECT *
                  FROM (SELECT CELL_PHONE, COUNT(*)
                          FROM TEMP_USER.TMP_MAJH_FAMILY_OUT_0830_2
                         WHERE RESERV3 = '电信'
                         GROUP BY CELL_PHONE
                        HAVING COUNT(*) > 2) A)
         ORDER BY DBMS_RANDOM.RANDOM)
 WHERE ROWNUM < 1001



   
create table temp_user.tmp_majh_0906_02 as
select 
b.AREA_NO, b.CITY_NO, b.CELL_PHONE, b.RESERV1, b.RESERV3
 from temp_user.tmp_majh_0908_01 a,TEMP_USER.TMP_MAJH_FAMILY_OUT_0830_2 b
where a.cell_phone=b.cell_phone ;

--1000个宽带号码信息
select b.area_desc,c.city_desc,a.cell_phone,wm_concat(reserv1) from 
(select distinct * from temp_user.tmp_majh_0906_02) a,dim.dim_area_no b,dim.dim_city_no c
where a.area_no=b.area_no
and a.city_no=c.city_no
group by b.area_desc,c.city_desc,a.cell_phone,b.idx_no
order by b.idx_no


create table temp_user.tmp_majh_fuka_0908 as 
SELECT B.AREA_DESC,
       C.CITY_DESC,
       CELL_PHONE,
       DEVICE_NUMBER,
       OPPOSE_NUMBER,
       ceil(CALL_DURATION/60)CALL_DURATION,
       b.idx_no
  FROM TEMP_USER.TMP_MAJH_0907_01 A, DIM.DIM_AREA_NO B, DIM.DIM_CITY_NO C
 WHERE A.AREA_NO = B.AREA_NO
   AND A.CITY_NO = C.CITY_NO
   ORDER BY b.idx_no,A.CELL_PHONE;
   
   
   
select * from temp_user.tmp_majh_fuka_0908 where cell_phone='IP15502871020'
   
   
   
delete from temp_user.tmp_majh_fuka_0908 a where rowid<
(select max(rowid) from temp_user.tmp_majh_fuka_0908 b where a.cell_phone=b.cell_phone
and a.device_number=b.oppose_number and a.oppose_number=b.device_number)


select 
area_desc, 
city_desc, 
cell_phone, 
device_number, 
oppose_number, 
call_duration
 from temp_user.tmp_majh_fuka_0908 ORDER BY idx_no,CELL_PHONE;










