create table tmp_majh_hezi_01 as 
select * from  crm_dsg.ir_mobile_using_t@HBODS a where upper(phone_number) like 'IP%'
