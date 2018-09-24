insert into  tmp_majh_0502_01
SELECT a.etl_date,
       a.account_period,
       a.cert_date,
       a.expiration_date,
       a.pre_cert_amount,
       a.bussiness_type,
       a.created_at,
       a.jt_city_code,
       substr(a.remark, 1, instr(a.remark, '|') - 1) device_number
  from alldm.BWT_DOWN_YZF_CUST_WHITE_LIST_D a
 where etl_date = '20180501'
   --and mobile_no = '11111111111'
   and substr(a.remark, 1, instr(a.remark, '|') - 1) is not null
