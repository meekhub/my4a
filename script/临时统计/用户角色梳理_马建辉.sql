select * from newdataplatform.e_user;

select * from  newdataplatform.e_user_role;

select * from newdataplatform.e_role

select * from cs_dss.oa_org_user_name_mulu@hbods

select * from cs_dss.oa_org_name_mulu@hbods;


create or replace view sys_user_info as
SELECT EXT1 AS AREA_NO,
       A.USER_ID,
       OA_UID,
       A.MOBILE,
       C.ROLE_NAME,
       A.MEMO      DEPT_NAME
  FROM NEWDATAPLATFORM.E_USER      A,
       NEWDATAPLATFORM.E_USER_ROLE B,
       NEWDATAPLATFORM.E_ROLE      C
 WHERE A.USER_ID = B.USER_ID(+)
   AND B.ROLE_CODE = C.ROLE_CODE(+);
   
   
   



