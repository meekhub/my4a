create table tmp_majh_df_0504_01
(
db_code varchar2(100),
jz_code varchar2(100),
baozhang_date varchar2(100),
begin_date varchar2(100),
end_date varchar2(100),
amount varchar2(100),
price varchar2(100),
baozhang_fee varchar2(100),
tax_fee varchar2(100)
);


/*select db_code,sum(amount)/sum(bz_cnt) from 
(select DB_CODE,
       ceil(decode(PRICE,0,BAOZHANG_FEE / 0.6,BAOZHANG_FEE / PRICE)) as amount,
       to_date(end_date, 'yyyy-mm-dd') - to_date(begin_date, 'yyyy-mm-dd') bz_cnt
  from tmp_majh_df_0504_01) group by db_code*/
  
--3月份报账  
/*create table tmp_majh_db as 
select a.db_code, b.BAOZHANG_FEE
  from (select distinct db_code
          from tmp_majh_df_0504_01 a
         where a.baozhang_date = '2018-03') a,
       (select db_code,
               ceil(sum(BAOZHANG_FEE) / sum(bz_cnt)) * 31 as BAOZHANG_FEE
          from (select DB_CODE,
                       BAOZHANG_FEE,
                       abs(to_date(end_date, 'yyyy-mm-dd') -
                           to_date(begin_date, 'yyyy-mm-dd')) + 1 bz_cnt
                  from tmp_majh_df_0504_01)
         group by db_code) b
 where a.db_code = b.db_code;*/
 create table xxhb_mjh.tmp_majh_db as 
 select db_code,
               ceil(sum(BAOZHANG_FEE) / sum(bz_cnt)) * 31 as BAOZHANG_FEE
          from (select DB_CODE,
                       (to_number(BAOZHANG_FEE)-to_number(TAX_FEE)) as BAOZHANG_FEE,
                       abs(to_date(end_date, 'yyyy-mm-dd') -
                           to_date(begin_date, 'yyyy-mm-dd')) + 1 bz_cnt
                  from xxhb_mjh.tmp_majh_df_0504_01)
         group by db_code


--停用电表状态
create table tmp_majh_db_0507_01
(
db_code varchar2(20)
)

--纠偏
select 18994072/17804943 from dual


--报账金额
select a.db_code,sum(a.baozhang_fee),sum(a.baozhang_fee)/1.0668 from tmp_majh_db a,tmp_majh_db_0507_01 b
where a.db_code=b.db_code(+)
and b.db_code is null
group by a.db_code

纠偏后比实际值少227元


--总电量
select 
a.db_code,a.baozhang_fee,b.price,decode(b.price,0,a.baozhang_fee,a.baozhang_fee/b.price)
 from tmp_majh_db a,
(
select *
  from (select db_code,price,
               row_number() over(partition by db_code order by END_DATE desc) rn
          from (select distinct t.db_code, t.price,t.END_DATE from tmp_majh_df_0504_01 t))
 where rn = 1
) b,
tmp_majh_db_0507_01 c
where a.db_code=b.db_code
and a.db_code=c.db_code(+)
and c.db_code is null




