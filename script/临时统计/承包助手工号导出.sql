select t.login_id "系统工号",
       b.login_name "姓名",
       b.mobile_phone "手机号",
       b.v_id "填写的OA工号",
       b.area_no "看数权限地市",
       b.city_no "看数权限区县",
       nvl(f.area_desc, '全省') || '-' || nvl(d.city_desc, '-') "看数地域",
       b.area "归属地市",
       b.city "归属区县",
       decode(b.state, '1', '正常', '停用') "用户状态"
  from dss_frame.isp_sc_role_user t,
       dss_frame.sc_login_user    b,
       dss_frame.cmcode_city      d,
       dss_frame.cmcode_area      f
 where t.role_id = 'cbzs_xinhuaxiao'
   and t.login_id = b.login_id
   and b.city_no = d.city_no(+)
   and b.area_no = f.area_no(+);
