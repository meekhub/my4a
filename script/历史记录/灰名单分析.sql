create table tmp_majh_0812_01
(
idx_no number,
device_number varchar2(20)
)

select * from dim.dim_area_contrast where city_cd='384'


--°ëĞ¡Ê±·ÖÎö
create table tmp_majh_0812_02
(
device_number varchar2(20), 
total_cdr_num number,
warn_type varchar2(30)
)
