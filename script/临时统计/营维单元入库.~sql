select * from tmp_majh_0418_yw_hd t;


create table tmp_majh_0418_yw_qhd_tmp
(
area_no	char(3),
huaxiao_no	varchar2(20),
device_number	varchar2(20)
)

update tmp_majh_0418_yw_qhd_tmp set huaxiao_no=trim(huaxiao_no),device_number=trim(device_number)

update tmp_majh_0418_yw_qhd_tmp set device_number='0'||device_number where device_number like '3%';

--明细表
tmp_majh_0418_yw_hd
tmp_majh_0418_yw_bd
tmp_majh_0418_yw_cd
tmp_majh_0418_yw_hs
tmp_majh_0418_yw_lf
tmp_majh_0418_yw_sjz
tmp_majh_0418_yw_xt
tmp_majh_0418_yw_zjk
tmp_majh_0418_yw_cz
tmp_majh_0418_yw_ts
tmp_majh_0418_yw_qhd
;
--发展人表
tmp_majh_0418_yw_dev_hd
tmp_majh_0418_yw_dev_bd
tmp_majh_0418_yw_dev_cd
tmp_majh_0418_yw_dev_hs
tmp_majh_0418_yw_dev_lf
tmp_majh_0418_yw_dev_sjz
tmp_majh_0418_yw_dev_xt
tmp_majh_0418_yw_dev_zjk
;

create table tmp_majh_0418_yw_qhd as 
select b.area_no, a.huaxiao_no, a.device_number,b.user_no
  from tmp_majh_0418_yw_qhd_tmp a,
       (select *
          from (select area_no,
                       device_number,
                       user_no,
                       row_number() over(partition by device_number order by innet_date desc) rn
                  from DW.DW_V_USER_BASE_INFO_USER A
                 WHERE ACCT_MONTH = '201803'
                   and area_no = '182') b
         where rn = 1) b
 where a.device_number = b.device_number(+);
 
 
 
 

create table  tmp_majh_0418_yw_dev_zjk
(
area_no varchar2(20),
huaxiao_no varchar2(20),
develop_no varchar2(20),
develop_name  varchar2(40)
)
