create table tmp_majh_0503_dh_02 as 
select a.*,
       b.LINK_PHONE，b.is_kd_bundle,
       user_dinner,
       user_dinner_desc,
       area_no,
       area_no_desc,
       user_no
--from  tmp_majh_0503_dh_01 a,
  from xxhb_qsk.tmp_qisk_device0807 a,
       (select device_number,user_no,
               link_phone,
               is_kd_bundle,
               user_dinner,
               user_dinner_desc,
               area_no,
               area_no_desc
          from dw.dw_v_user_base_info_day b
         where acct_month = '201808'
           and day_id = '06'
           and is_onnet = '1') b
 where a.device_number = b.device_number(+);


create table tmp_majh_rh_0807_01 as
select a.device_number,
       a.link_phone,
       case
         when a.is_kd_bundle <> '0' then
          '是'
         else
          '否'
       end is_rh,
       a.user_dinner,
       a.user_dinner_desc,
       a.area_no,
       a.area_no_desc,
       case
         when b.is_huaxiao_01 = '1' then
          '自营厅'
         when b.is_huaxiao_02 = '1' then
          '商圈'
         when b.is_huaxiao_03 = '1' then
          '社区'
         when b.is_huaxiao_04 = '1' then
          '农村'
       end hx_flag
  from tmp_majh_0503_dh_02 a,
       (select user_no,
               is_huaxiao_01,
               is_huaxiao_02,
               is_huaxiao_03,
               is_huaxiao_04
          from dw.dw_v_user_huaxiao_info_d a
         where acct_month = '201808'
           and day_id = '06') b
 where a.user_no = b.user_no(+);


--导出
select 
device_number 手机号, 
hx_flag 划小类型，
is_rh 是否融合, 
link_phone 联系电话, 
area_no_desc 地市归属,
user_dinner 套餐编码 , 
user_dinner_desc 套餐名称
 from tmp_majh_rh_0807_01;
