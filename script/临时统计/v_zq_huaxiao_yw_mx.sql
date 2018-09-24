create or replace view v_zq_huaxiao_yw_mx as
select area_no,user_no,huaxiao_no from xxhb_mjh.tmp_majh_0418_yw_cz
union all
select area_no,user_no,huaxiao_no from xxhb_mjh.tmp_majh_0418_yw_ts
union all
select area_no,user_no,huaxiao_no from xxhb_mjh.tmp_majh_0418_yw_qhd
union all
select area_no,user_no,huaxiao_no from xxhb_mjh.tmp_majh_0418_yw_lf
union all
select area_no,user_no,huaxiao_no from xxhb_mjh.tmp_majh_0418_yw_zjk
union all
select area_no,user_no,huaxiao_no from xxhb_mjh.tmp_majh_0418_yw_xt
union all
select area_no,user_no,huaxiao_no from xxhb_mjh.tmp_majh_0418_yw_hd
union all
select area_no,user_no,huaxiao_no from xxhb_mjh.tmp_majh_0418_yw_bd
union all
select area_no,user_no,huaxiao_no from xxhb_mjh.tmp_majh_0418_yw_sjz
union all
select area_no,user_no,huaxiao_no from xxhb_mjh.tmp_majh_0418_yw_cd
union all
select area_no,user_no,huaxiao_no from xxhb_mjh.tmp_majh_0418_yw_hs;
