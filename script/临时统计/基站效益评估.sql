--计算流量单价
SELECT b.area_desc,sum(a.JF_TIMES),  --总计费时长
       sum(case
             when a.tele_type = '2' then
              a.JF_TIMES
             else
              0
           end), --其中C网计费时长
       sum(case
             when tele_type = '2' then
              a.ALL_JF_FLUX
             else
              0
           end) --总流量
  FROM DW.DW_V_USER_BASE_INFO_USER A,dim.dim_area_no_base b
 WHERE A.ACCT_MONTH = '201805'
 and func_get_xiongan_area_no(a.area_no,a.city_no)=b.area_no
 group by b.area_desc,b.idx_no
 order by b.idx_no


--根据网管天线基础表，剔除字段“覆盖道路类型”为“高铁”、“高速”的数据
select count(*),count(distinct a.tianxian_no) from  tmp_majh_0710_tx_01 a where a.fg_daolu_type not in ('高铁','高铁');

--RRU基础表根据字段“所属站址编码”列出站址编码表1对应的明细数据。RRU基础表字段“所属小区标识”对应小区基础表的字段“小区标识”，
select count(*),count(distinct RRU_NO),count(distinct xiaoqu_no_new) from  tmp_majh_0710_rru_01_new

--小区基础表字段“小区覆盖类别”剔除“室分覆盖”的所有站点；剔除字段“频段标识”数值为3和5（频段为2.4和800M）所有站址
select * from tmp_majh_0710_xiaoqu_01 c where c.fg_type<>'室分覆盖' and c.pinduan not in ('3','5');

--铁塔产品服务费
select count(*),count(distinct station_no) from  tmp_majh_0710_fuwu_01
--小区流量
select count(*),count(distinct xiaoqu_no) from tmp_majh_0710_flux_01;

--小区处理
create table tmp_majh_0710_xiaoqu_02 as 
select *
          from (select c.*,
                       row_number() over(partition by xiaoqu_no order by 1) rn
                  from tmp_majh_0710_xiaoqu_01 c
                 where c.fg_type <> '室分覆盖' 
                   )
         where rn = 1;

--RRU处理
create table tmp_majh_0710_rru_01_new_01 as 
select *
          from (select b.*,
                       row_number() over(partition by station_no, xiaoqu_no order by 1) rn
                  from tmp_majh_0710_rru_01_new b)
         where rn = 1
         

--天线处理
create table tmp_majh_0710_tx_02 as 
select *
          from (select d.*,
                       row_number() over(partition by tianxian_no order by 1) rn
                  from tmp_majh_0710_tx_01 d
                 where fg_daolu_type not in ('高铁', '高铁'))
         where rn = 1;
         
--站址
create table tmp_majh_station_ays_01 as 
select a.area_name,
       a.city_name,
       a.station_no,
       a.station_name,
       a.tower_type,
       a.tieta_no,
       a.tieta_name,
       b.rru_no,
       c.xiaoqu_no,
       c.xiaoqu_name,
       c.pinduan,
       nvl(e.up_flux, 0) + nvl(e.down_flux, 0) as all_flux
  from (select * from tmp_majh_0710_zhanzhi_01 where tieta_no is not null) a, --站址
       tmp_majh_0710_rru_01_new_01 b, --RRU
       tmp_majh_0710_xiaoqu_02 c, --小区
       tmp_majh_0710_tx_02 d, --天线
       tmp_majh_0710_flux_01 e
 where a.station_no = b.station_no
   and b.xiaoqu_no_new = c.xiaoqu_no
   and c.tianxian_no = d.tianxian_no
   and c.xiaoqu_no = e.xiaoqu_no;
   

select count(*) from  tmp_majh_station_ays_01 a where exists
(select distinct station_no from tmp_majh_station_ays_01 b  where a.pinduan not in ('3','5') 
and a.station_no=b.station_no);

--站址流量
select a.*, nvl(fee, 0) fee
  from (select a.area_name,
               a.city_name,
               a.station_no,
               a.station_name,
               a.tower_type,
               a.tieta_no,
               a.tieta_name,
               round(sum(a.all_flux) * 0.007, 2) flux_fee
          from tmp_majh_station_ays_01 a
         group by a.area_name,
                  a.city_name,
                  a.station_no,
                  a.station_name,
                  a.tower_type,
                  a.tieta_no,
                  a.tieta_name) a,
       (select station_no, sum(fee1 + fee2 + fee3 + fee4) fee
          from tmp_majh_0710_fuwu_01
         group by station_no) b
 where a.tieta_no = b.station_no(+)

