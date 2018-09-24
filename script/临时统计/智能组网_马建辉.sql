create table tmp_majh_0609_03 as 
select 
cell_phone
 from  stage.BWT_DOWN_GU_BDM_PA_D t where day_id='20180119' and t.marketing_code=201709272001
 and cell_phone like 'ip%';


 update tmp_majh_0609_03 set CELL_PHONE=upper(CELL_PHONE)
 
 select * from tmp_majh_0609_03 a,tmp_majh_kd_02 b
 where a.cell_phone=b.kd_number;
 
 
--营销成功用户
create table tmp_success_user_zw as  
select * from 
(select func_get_area_no(b.area_no) area_no,a.cell_phone,b.user_no
  from tmp_majh_0609_03 a,tmp_majh_kd_02 b
 where a.cell_phone=b.kd_number 
 order by  dbms_random.value) where rownum<10029;
 
 
 
 --营销执行用户
 create table tmp_execute_user_zw as
 SELECT *
   FROM TMP_SUCCESS_USER_ZW
 UNION ALL
 SELECT *
   FROM (SELECT *
           FROM (SELECT FUNC_GET_AREA_NO(A.AREA_NO), A.KD_NUMBER,a.user_no
                   FROM TMP_MAJH_KD_02 A, TMP_SUCCESS_USER_ZW B
                  WHERE A.KD_NUMBER = B.CELL_PHONE(+)
                    AND B.CELL_PHONE IS NULL)
          ORDER BY DBMS_RANDOM.VALUE)
  WHERE ROWNUM < 10827;
  
  
--剔除重复
delete from tmp_execute_user_zw a
 where rowid < (select max(rowid)
                  from tmp_execute_user_zw b
                 where a.CELL_PHONE = b.CELL_PHONE)
  
