create table xxhb_mjh.tmp_majh_df_0810_01 as
select * from 
(SELECT distinct  area_name,group_name,room_id,replace(A.RELATION_ID,chr(13),'')RELATION_ID,room_name
          FROM ALLDM.ELEC_STATION_D A
         WHERE ACCT_MONTH = '201807')a,
         (SELECT STATION_ID_A, STATION_ID_B
          FROM (SELECT x.*,
                       ROW_NUMBER() OVER(PARTITION BY STATION_ID_A ORDER BY 1) RN
                  FROM DIM.DIM_STATION_REL x
                 WHERE STATION_ID_B IS NOT NULL and STATION_ID_B<>'#N/A')
         WHERE RN = 1)b
         where a.relation_id=b.STATION_ID_A(+)
         and b.STATION_ID_A is not null;

         
         
/*create table DIM.DIM_STATION_REL_bak as
select * from DIM.DIM_STATION_REL

create table DIM.DIM_STATION_REL_0830 as
select * from DIM.DIM_STATION_REL
*/

create table DIM.DIM_STATION_REL as
select 
b.area_name, 
b.city_name, 
a.room_id,
b.station_name_a, 
b.station_id_a, 
b.station_id_b, 
b.station_name_b
 from 
(SELECT distinct  area_name,group_name,room_id,replace(A.RELATION_ID,chr(13),'')RELATION_ID,room_name
          FROM ALLDM.ELEC_STATION_D A
         WHERE ACCT_MONTH = '201807')a,
         (SELECT *
          FROM (SELECT x.*,
                       ROW_NUMBER() OVER(PARTITION BY STATION_ID_A ORDER BY 1) RN
                  FROM DIM.DIM_STATION_REL_bak x
                 WHERE STATION_ID_B IS NOT NULL and STATION_ID_B<>'#N/A')
         WHERE RN = 1)b
         where a.relation_id=b.STATION_ID_A(+)
         and b.STATION_ID_A is not null
union     
select 
b.area_name, 
b.city_name, 
a.room_id,
b.station_name_a, 
b.station_id_a, 
b.station_id_b, 
b.station_name_b
 from     
(select area_name,room_id, 
replace(replace(replace(replace(replace(replace(replace(room_name,'_D_',''),'_C_','')
,'_A_',''),'_Y_',''),'_DJ_',''),'_B_',''),'_J_','')room_name_new
 from xxhb_mjh.tmp_majh_df_0810_01)a,
 (SELECT *
          FROM (SELECT x.*,
                       replace(replace(replace(replace(replace(replace(replace(STATION_NAME_A,'_D_',''),'_C_','')
,'_A_',''),'_Y_',''),'_DJ_',''),'_B_',''),'_J_','')STATION_NAME_A_new,
                       ROW_NUMBER() OVER(PARTITION BY STATION_ID_A ORDER BY 1) RN
                  FROM DIM.DIM_STATION_REL_bak x
                 WHERE STATION_ID_B IS NOT NULL and STATION_ID_B<>'#N/A')
         WHERE RN = 1)b
         where A.room_name_new=B.STATION_NAME_A_new

--最终

select a.* from 
(SELECT distinct  area_name,group_name,room_id,replace(A.RELATION_ID,chr(13),'')RELATION_ID,room_name
          FROM ALLDM.ELEC_STATION_D A
         WHERE ACCT_MONTH = '201808')a,
   DIM.DIM_STATION_REL b
   where a.room_id=b.room_id(+)
   and b.room_id is null;


--能耗全量站址
select distinct area_name,city_name,shiti_no,shiti_name from df_bill_info t
   
 
 
