create table xxhb_mjh.tmp_majh_0520_02 as
select t.area_no, t.id, t.user_no, t.importtime
  from DW.DW_V_USER_ADSL_EIGHT_M T, xxhb_mjh.tmp_majh_0520_01 x
 WHERE ACCT_MONTH = '201804'
   and to_char(t.id) = x.addr_id;
   
   
   
create table xxhb_mjh.tmp_majh_0520_03 as
select 
a.*,b.price_fee+b.price_fee_ocs as total_fee
from xxhb_mjh.tmp_majh_0520_02 a,
(select price_fee,price_fee_ocs,user_no from dw.dw_v_user_base_info_user b
where acct_month='201804'
and tele_type in('4','26'))b
where a.user_no=b.user_no;


select a.idx_no, a.addr_id,b.importtime, nvl(count(distinct b.user_no),0), nvl(sum(b.total_fee),0)
  from xxhb_mjh.tmp_majh_0520_01 a, xxhb_mjh.tmp_majh_0520_04 b
 where a.addr_id =b.id(+)
 group by a.idx_no, a.addr_id,b.importtime
