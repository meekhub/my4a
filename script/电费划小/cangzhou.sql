select t.*, t.rowid from mid_kkpi_yusuan t where t.acct_month='201808' for update;

update mid_kkpi_yusuan set acct_month='201808' where acct_month is null;

select area_desc,count(*) from mid_kkpi_yusuan where acct_month='201808' group by area_desc;


update mid_kkpi_yusuan set 
year_guangao_ys=year_guangao_ys/10000,
year_kefu_ys=year_kefu_ys/10000,
year_zhaodai_ys=year_zhaodai_ys/10000,
year_cheliang_ys=year_cheliang_ys/10000,
year_yongpin_ys=year_yongpin_ys/10000,
year_butie_ys=year_butie_ys/10000,
year_zulin_ys=year_zulin_ys/10000,
year_guangao_sz=year_guangao_sz/10000,
year_kefu_sz=year_kefu_sz/10000,
year_zhaodai_sz=year_zhaodai_sz/10000,
year_cheliang_sz=year_cheliang_sz/10000,
year_yongpin_sz=year_yongpin_sz/10000,
year_butie_sz=year_butie_sz/10000,
year_zulin_sz=year_zulin_sz/10000
where acct_month='201808'
and area_desc='²×ÖÝ'
