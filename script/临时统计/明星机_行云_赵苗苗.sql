create table tmp_majh_star_user
(
acct_month varchar(20), 
prod_inst_id  varchar(20), 
single_com integer
)

insert into tmp_majh_star_user
{
select * from temp_user.tmp_majh_star_user
}@hbdw



select 
area_no_desc,sum(single_com)
from
(select * from tmp_majh_star_user a where acct_month='201701')a,
(select area_no,area_no_desc,user_no from dw_v_user_base_info_user where acct_month='201701' 
and tele_type='2')b,dim.dim_area_no c
where a.prod_inst_id=b.user_no
and b.area_no=c.area_no
group by c.idx_no,c.area_no_desc
order by c.idx_no









