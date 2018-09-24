select t.*, t.rowid from tmp_majh_0423_01 t


select count(*) from  tmp_majh_0423_01 ;

create table tmp_majh_0423_02 as
select 
a.*,b.area_no,b.reg_date,b.device_no,c.area_desc
from tmp_majh_0423_01 a,
(
select area_no,reg_date,device_no,terminal_code from dw.dw_v_user_terminal_device_d b
where acct_month='201804'
and day_id='22'
)b,
dim.dim_area_no c
where a.terminal_code=b.terminal_code(+)
and b.area_no=c.area_no(+)


select * from tmp_majh_0423_02 
