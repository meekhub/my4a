create table xxhb_mjh.tmp_majh_xy_0720_01 as 
select user_no from  dw.DW_V_USER_HUAXIAO_INFO_M a
 where acct_month = '201805'
   and area_no = '186'
   and (tele_type = '2' or
       tele_type_new in ('G000', 'G001', 'G002', 'G010', 'G110'))
   and xiaoqu_no = '1864509724920160714'


delete from  dw.DW_V_USER_SCHOOL_HX_USER_M a where acct_month='201805' and exists
(select 1 from xxhb_mjh.tmp_majh_xy_0720_01 b where a.user_no=b.user_no)


update  dw.DW_V_USER_HUAXIAO_INFO_M a set is_huaxiao_03='1',huaxiao_no_03='813040420140000',
huaxiao_name_03='西区人民路公众支局', IS_SCHOOL_USER='0',IS_SCHOOL_03='0'
 where acct_month = '201805'
   and area_no = '186'
   and (tele_type = '2' or
       tele_type_new in ('G000', 'G001', 'G002', 'G010', 'G110'))
   and xiaoqu_no = '1864509724920160714'
   
   
   
 select * from dim.dim_huaxiao_info where huaxiao_no='813040420140000'


select distinct tele_type,SERVICE_CLASS from ACCT_DSG.BRPT_SERVICE_KIND_TELE@HBODS
where SERVICE_CLASS IN ('宽带','电信电视','固话')
