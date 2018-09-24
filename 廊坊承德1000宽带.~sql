DECLARE
  V_MONTH VARCHAR2(100);
  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO in ('183','189')  ORDER BY IDX_NO;
BEGIN
  FOR V_NUM IN 201208 .. 201208 LOOP
    V_MONTH := TO_CHAR(V_NUM);
    FOR C1 IN V_AREA LOOP
      INSERT INTO TEMP_USER.TMP_MAJH_0920_01
        SELECT B.AREA_NO, B.CITY_NO, A.CELL_PHONE
          FROM (
                SELECT UPPER(CELL_PHONE) CELL_PHONE
                  FROM STAGE.BWT_DOWN_GU_BDM_D T
                 WHERE T.DAY_ID = '20170814'
                   AND CELL_PHONE LIKE 'ip%')A,
                 (SELECT AREA_NO, CITY_NO, DEVICE_NUMBER
                          FROM DW.DW_V_USER_BASE_INFO_USER
                         WHERE ACCT_MONTH = '201708'
                           AND AREA_NO = C1.AREA_NO
                           AND TELE_TYPE IN ('4', '26')
                           AND IS_ONNET = '1') B
                 WHERE A.CELL_PHONE = B.DEVICE_NUMBER(+);
      COMMIT;
      DELETE FROM TEMP_USER.TMP_MAJH_0920_01 WHERE AREA_NO IS NULL;
      COMMIT;
    END LOOP;
  END LOOP;
END;


--随机提取1000个宽带账号
create table temp_user.TMP_MAJH_0920_02 as
SELECT '189' AREA_NO, CELL_PHONE
  FROM (SELECT *
          FROM TMP_MAJH_0920_01
         WHERE CITY_NO IN
               ('018189026',
                '018189014',
                '018189016' /*,'018183002','018183014','018183001'*/)
         ORDER BY DBMS_RANDOM.RANDOM)
 WHERE ROWNUM < 1001;
 
 
 
 insert into temp_user.TMP_MAJH_0920_02
 SELECT '183' AREA_NO, CELL_PHONE
  FROM (SELECT *
          FROM TMP_MAJH_0920_01
         WHERE CITY_NO IN
               ( '018183002','018183014','018183001')
         ORDER BY DBMS_RANDOM.RANDOM)
 WHERE ROWNUM < 1001;
 
 
 create table TMP_MAJH_0920_03 as
 select 
 a.area_no,a.cell_phone,b.reserv1
  from TMP_MAJH_0920_02 a,tmp_majh_family_out_0830 b where a.cell_phone=b.cell_phone
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
   
   
   
   
