select t.*, t.rowid from tmp_majh_term_1212_03 t


create table tmp_majh_term_h as 
select 
a.terminal_code,a.idx_no,case when b.esn is not null then '1' else '0' end flag 
from tmp_majh_term_1212_03 a,
         alldm.bwt_down_rgst_trmnl_prvnc b --本省出库终端在他省注册
 where a.terminal_code = b.esn(+)
