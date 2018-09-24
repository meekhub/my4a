select count(*),count(distinct t.device_number) from  tmp_majh_0525_01 t

create table tmp_majh_0525_04 as 
select 
a.*,b.terminal_code,b.terminal_corp,b.terminal_model,b.area_no
 from tmp_majh_0525_01 a,
(
select area_no,terminal_code,user_no,device_no,terminal_corp,terminal_model from dw.dw_v_user_terminal_user_d where acct_month='201805'
and day_id='24'
)b
where a.device_number=b.device_no(+);


select 
a.device_number,a.idx_no,a.terminal_code,a.terminal_corp,a.terminal_model,b.area_desc
 from  tmp_majh_0525_04 a,dim.dim_area_no b
where a.area_no=b.area_no(+)
order by a.idx_no
