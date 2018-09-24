--truncate table TMP_MAJH_XJXK_0706
 DECLARE
  V_MONTH VARCHAR2(100);
  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018' ORDER BY IDX_NO;
BEGIN
  FOR V_NUM IN 201711 .. 201712 LOOP
    V_MONTH := TO_CHAR(V_NUM); 
  insert into  TMP_MAJH_XJXK_1017_new_03
    SELECT v_month ACCT_MONTH,
           D.AREA_DESC,
           E.CITY_DESC,
           A.DEVICE_NO,
           A.TERMINAL_CODE,
           A.TERMINAL_MODEL,
           A.REG_DATE,
           A.CHANNEL_NO,
           C.CHANNEL_NO_DESC,
           A.INNET_DATE,
           CASE
             WHEN B.USER_NO IS NOT NULL THEN
              '1'
             ELSE
              '0'
           END IS_XJXK,
           b.user_dinner,
           b.user_dinner_desc
      FROM (SELECT *
              FROM DW.DW_V_USER_TERMINAL_DEVICE_D F
             WHERE ACCT_MONTH = '201801'
               AND DAY_ID = '16'
               AND TO_CHAR(F.REG_DATE, 'YYYYMM') = v_month
               AND UPPER(F.TERMINAL_MODEL) LIKE '%VIVO%') A,
           (SELECT *
              FROM DW.DW_V_USER_BASE_INFO_DAY B
             WHERE B.ACCT_MONTH = '201801'
               AND B.DAY_ID = '16'
               AND B.TELE_TYPE = '2'
               AND TO_CHAR(B.INNET_DATE, 'YYYYMM') = v_month) B,
           DIM.DIM_CHANNEL_NO C,
           DIM.DIM_AREA_NO D,
           DIM.DIM_CITY_NO E
     WHERE A.USER_NO = B.USER_NO(+)
       AND A.CHANNEL_NO = C.CHANNEL_NO(+)
       AND A.AREA_NO = D.AREA_NO(+)
       AND A.CITY_NO = E.CITY_NO(+);
      COMMIT; 
  END LOOP;
END;
     
      
select acct_month      ����,
       area_desc       ����,
       city_desc       ����,
       device_no       �ֻ���,
       terminal_code   �ն˴���,
       terminal_model  �ն��ͺ�,
       reg_date        ע��ʱ��,
       channel_no      ��������,
       channel_no_desc ��������,
       innet_date      ����ʱ��,
       is_xjxk         �Ƿ��»��¿�
  from TMP_MAJH_XJXK_1017_new_03 where upper(terminal_model) like '%VIVO%'
