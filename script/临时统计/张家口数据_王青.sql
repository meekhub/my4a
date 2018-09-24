create table tmp_majh_0603_01 as 
select 
a.area_no_desc,
a.city_no_desc,
a.CHANNEL_NO,
a.CHANNEL_NO_DESC,
a.CHANNEL_TYPE_DESC,
a.USER_NO,
a.DEVICE_NUMBER,
to_char(a.INNET_DATE,'yyyymmdd')innet_date,
a.is_onnet, 
a.PRICE_FEE+a.PRICE_FEE_OCS as price_fee,
a.OWE_FEE
 from dw.dw_v_user_base_info_user a where acct_month='201804'
and area_no='184'
and tele_type='2'
and to_char(innet_date,'yyyymm') between '201607' and '201712';


DECLARE
  V_MONTH VARCHAR2(100); 
BEGIN
  FOR V_NUM IN 201607 .. 201712 LOOP
    V_MONTH := TO_CHAR(V_NUM);
      INSERT INTO TMP_MAJH_0603_02
        SELECT A.USER_NO, A.PRICE_FEE + A.PRICE_FEE_OCS AS PRICE_FEE
          FROM DW.DW_V_USER_BASE_INFO_USER A
         WHERE ACCT_MONTH = '201804'
           AND AREA_NO = '184'
           AND TELE_TYPE = '2'
           AND is_new='1';
      COMMIT; 
    END LOOP; 
END;



select * from dw.DW_V_USER_COMMISION_LIST
