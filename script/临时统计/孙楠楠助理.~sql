create table tmp_majh_0420_02
(
terminal_code varchar2(20),
idx_no number
)


create table tmp_majh_0420_03 as
select 
a.*,
to_char(b.reg_date,'yyyymmddHH24MISS')reg_date,c.area_desc,b.device_no
 from tmp_majh_0420_02 a,
(
select area_no,terminal_code,reg_date,device_no from dw.dw_v_user_terminal_device_d b
where acct_month='201804'
and day_id='19'
)b,
dim.dim_area_no c
where a.terminal_code=b.terminal_code(+)
and b.area_no=c.area_no(+)

create table tmp_majh_0420_04 as
select area_no,terminal_code,terminal_model,to_char(b.reg_date,'yyyymmddHH24MISS')reg_date,device_no from dw.dw_v_user_terminal_device_d b
where acct_month='201804'
and day_id='19'
and terminal_corp='Apple'
and terminal_model in ('ACM-A7','ACM-A7Plus')
and to_char(reg_date,'yyyymmdd') between '20180305' and '20180315'



select 
area_desc,terminal_code,terminal_model,reg_date,device_no
from tmp_majh_0420_04 a,dim.dim_area_no b
where a.area_no=b.area_no














