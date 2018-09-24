create table tmp_majh_0403_qz_01 as 
select 
b.area_no,b.city_no,b.user_no,b.device_number,a.channel_no
 from ��select distinct CHANNEL_NO from  tmp_majh_0403_01) a,
(
select area_no,city_no,user_no,device_number,channel_no from dw.dw_v_user_base_info_day a
where acct_month='201804'
and day_id='02' 
and tele_type='2' 
and to_char(innet_date,'yyyy')='2018'
)b
where a.channel_no=b.channel_no;



create table tmp_majh_0404_01 as
  SELECT ACCT_MONTH,
         AREA_NO,
         DEVICE_NUMBER,
         ORG_TRM_ID,
         OPPOSE_NUMBER,
         CELL_NO,
         FUNC_GET_QIZHA_REGION(ROAM_AREA_CODE)ROAM_AREA
    FROM DW.DW_V_USER_CDR_CDMA_OCS
   WHERE ACCT_MONTH = '201803'
     --AND CALL_DATE = SUBSTR(V_DATE, 7, 2)
     --AND AREA_NO = C1.AREA_NO
     AND ROAM_AREA_CODE IN ('384', '395','305','568','912','713','503','825')
  UNION ALL
  SELECT ACCT_MONTH,
         AREA_NO,
         DEVICE_NUMBER,
         ORG_TRM_ID,
         OPPOSE_NUMBER,
         CELL_NO,
         FUNC_GET_QIZHA_REGION(ROAM_AREA_CODE)
    FROM DW.DW_V_USER_CDR_CDMA
   WHERE ACCT_MONTH = '201803'
     --AND CALL_DATE = SUBSTR(V_DATE, 7, 2)
     --AND AREA_NO = C1.AREA_NO
     AND ROAM_AREA_CODE IN ('384', '395','305','568','912','713','503','825'); 
     
     
     --ƥ��18���������û��Ƿ��ڼ����
 select c.area_desc ����,
        b.device_number �ֻ���, 
        d.channel_no ��������ID,
        d.channel_no_desc ��������,
        count(*)  ͨ������
   from tmp_majh_0404_01    a,
        tmp_majh_0403_qz_01 b,
        dim.dim_area_no     c,
        dim.dim_channel_no  d
  where a.device_number = b.device_number
    and a.area_no = c.area_no
    and b.channel_no = d.channel_no
group by 
c.area_desc,
        b.device_number,
        a.device_number,
        d.channel_no,
        d.channel_no_desc

