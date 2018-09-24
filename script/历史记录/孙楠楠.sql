DECLARE
  V_MONTH VARCHAR2(100);
  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO not in ('018')  ORDER BY IDX_NO;
BEGIN
  FOR V_NUM IN 201208 .. 201208 LOOP
    V_MONTH := TO_CHAR(V_NUM);
    FOR C1 IN V_AREA LOOP
      INSERT INTO TEMP_USER.TMP_MAJH_sun_0920_01
        SELECT a.device_number,b.sales_mode,a.idx_no
          FROM tmp_majh_zuji_0920_01 A,
                 (SELECT AREA_NO, CITY_NO, DEVICE_NUMBER,sales_mode
                          FROM DW.DW_V_USER_BASE_INFO_day
                         WHERE ACCT_MONTH = '201709'
                           and day_id='19'
                           AND AREA_NO = C1.AREA_NO
                           AND TELE_TYPE IN ('2')
                           AND IS_ONNET = '1') B
                 WHERE A.Device_Number = B.DEVICE_NUMBER(+);
      COMMIT;
      DELETE FROM TEMP_USER.TMP_MAJH_sun_0920_01 WHERE sales_mode IS NULL;
      COMMIT;
    END LOOP;
  END LOOP;
END;



select 
a.device_number,case when b.device_number is not null then 'ÊÇ' else '·ñ' end flag
 from tmp_majh_zuji_0920_01 a,TMP_MAJH_sun_0920_01 b
where a.idx_no=b.idx_no(+)
order by a.idx_no asc

































