select t.*, t.rowid from tmp_majh_qz_0718_01 t;

create table tmp_majh_qz_0718_02 as
select 
a.*,b.innet_date,b.user_dinner_desc,b.CUSTOMER_NAME,b.cert_id,b.account_no
 from tmp_majh_qz_0718_01 a,
(
select * from dw.dw_v_user_base_info_day b
where acct_month='201807'
and day_id='17'
and tele_type='2'
and is_onnet='1'
)b
where a.device_number=b.device_number(+)



create table tmp_majh_qz_0718_03 as
select 
a.*,b.device_number as device_number_new
 from (select distinct account_no from  tmp_majh_qz_0718_02) a,
(
select * from dw.dw_v_user_base_info_day b
where acct_month='201807'
and day_id='17'
and tele_type='2'
and is_onnet='1'
)b
where a.account_no=b.account_no(+);


select account_no,count(*) from tmp_majh_qz_0718_03 group by account_no;



select 
device_number �ֻ���,  
innet_date ��������, 
user_dinner_desc �ײ�, 
customer_name �ͻ�����, 
cert_id ֤��ID
 from tmp_majh_qz_0718_02 order by idx_no

















