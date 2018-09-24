--邢台
update mid_hx_yw_xt set huaxiao_no=trim(huaxiao_no),user_no=trim(user_no) 

select t.*, t.rowid from mid_hx_yw_xt t where rownum>1000000

--保定
create table xxhb_mjh.tmp_majh_yw_ts
(
area_no	char(3),
huaxiao_no	varchar2(20),
device_number	varchar2(20)
);

--备份
create table xxhb_mjh.mid_hx_yw_ts_201805 as
select * from mid_hx_yw_ts;

truncate table mid_hx_yw_ts

mid_hx_yw_bd

select user_no,count(*) from mid_hx_yw_bd group by user_no having count(*)>1

select * from mid_hx_yw_xt where user_no='54487956' for update

truncate table mid_hx_yw_bd;
update mid_hx_yw_bd set is_cl='1';

delete from mid_hx_yw_cz a where rowid<(select max(rowid) from mid_hx_yw_cz b where a.user_no=b.user_no)

--邢台
select count(*),count(distinct user_no) from   mid_hx_yw_xt

--保定
select count(*),count(distinct user_no) from   mid_hx_yw_bd

--邯郸
select count(*) from   mid_hx_yw_hd

--沧州
select count(*) from  mid_hx_yw_cz

--承德
select count(*) from mid_hx_yw_cd;

--廊坊
select count(*) from mid_hx_yw_lf

--秦皇岛
select count(*) from mid_hx_yw_qhd

--石家庄
select count(*) from  mid_hx_yw_sjz

--张家口
select count(*) from  mid_hx_yw_zjk

--唐山
select count(*) from  mid_hx_yw_ts

--衡水
select count(*) from  mid_hx_yw_hs


update xxhb_mjh.tmp_majh_yw_ts set device_number='0'||device_number where device_number like '3%'

update xxhb_mjh.tmp_majh_yw_ts set device_number=trim(device_number),huaxiao_no=trim(huaxiao_no)

update mid_hx_yw_cd set user_no=trim(user_no),huaxiao_no=trim(huaxiao_no)



insert into mid_hx_yw_ts
select b.area_no, a.huaxiao_no,b.device_number,b.user_no
  from xxhb_mjh.tmp_majh_yw_ts a,
       (select *
          from (select area_no,
                       device_number,
                       user_no,
                       row_number() over(partition by device_number order by innet_date desc) rn
                  from DW.DW_V_USER_BASE_INFO_USER A
                 WHERE ACCT_MONTH = '201805'
                   and area_no = '181') b
         where rn = 1) b
 where a.device_number = b.device_number(+);
 
 
 
 
 
 
 
 
 
 
 
