select t.login_id "ϵͳ����",
       b.login_name "����",
       b.mobile_phone "�ֻ���",
       b.v_id "��д��OA����",
       b.area_no "����Ȩ�޵���",
       b.city_no "����Ȩ������",
       nvl(f.area_desc, 'ȫʡ') || '-' || nvl(d.city_desc, '-') "��������",
       b.area "��������",
       b.city "��������",
       decode(b.state, '1', '����', 'ͣ��') "�û�״̬"
  from dss_frame.isp_sc_role_user t,
       dss_frame.sc_login_user    b,
       dss_frame.cmcode_city      d,
       dss_frame.cmcode_area      f
 where t.role_id = 'cbzs_xinhuaxiao'
   and t.login_id = b.login_id
   and b.city_no = d.city_no(+)
   and b.area_no = f.area_no(+);
