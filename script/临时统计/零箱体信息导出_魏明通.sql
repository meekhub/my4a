select b.area_desc ����,
       a.city_desc ����,
       a.fgq_id �ֹ���id,
       a.fgq_name �ֹ�������,
       a.project_id ��Ŀid,
       a.project_desc ��Ŀ����,
       a.fgq_date ��������,
       a.standard_id ��׼����id,
       a.standard_name ��׼��������,
       a.box_id ����id,
       a.box_name ��������,
       a.dk_number �ܶ˿�,
       a.dk_use_number ռ�ö˿�
  from STAGE.ZIYUAN_LINBOX_M a, dim.dim_area_no b
 where '0' || a.area_desc = b.area_code
 and b.area_desc in ('ʯ��ׯ','�е�');
 

select b.area_desc ����,
       a.city_desc ����,
       a.fgq_id �ֹ���id,
       a.fgq_name �ֹ�������,
       a.project_id ��Ŀid,
       a.project_desc ��Ŀ����,
       a.fgq_date ��������,
       a.standard_id ��׼����id,
       a.standard_name ��׼��������,
       a.box_id ����id,
       a.box_name ��������,
       a.dk_number �ܶ˿�,
       a.dk_use_number ռ�ö˿�
  from STAGE.ZIYUAN_LINBOX_M a, dim.dim_area_no b
 where '0' || a.area_desc = b.area_code
 and b.area_desc in ('����','�ػʵ�','��ˮ');
 

select b.area_desc ����,
       a.city_desc ����,
       a.fgq_id �ֹ���id,
       a.fgq_name �ֹ�������,
       a.project_id ��Ŀid,
       a.project_desc ��Ŀ����,
       a.fgq_date ��������,
       a.standard_id ��׼����id,
       a.standard_name ��׼��������,
       a.box_id ����id,
       a.box_name ��������,
       a.dk_number �ܶ˿�,
       a.dk_use_number ռ�ö˿�
  from STAGE.ZIYUAN_LINBOX_M a, dim.dim_area_no b
 where '0' || a.area_desc = b.area_code
 and b.area_desc in ('��ɽ','����');
 

select b.area_desc ����,
       a.city_desc ����,
       a.fgq_id �ֹ���id,
       a.fgq_name �ֹ�������,
       a.project_id ��Ŀid,
       a.project_desc ��Ŀ����,
       a.fgq_date ��������,
       a.standard_id ��׼����id,
       a.standard_name ��׼��������,
       a.box_id ����id,
       a.box_name ��������,
       a.dk_number �ܶ˿�,
       a.dk_use_number ռ�ö˿�
  from STAGE.ZIYUAN_LINBOX_M a, dim.dim_area_no b
 where '0' || a.area_desc = b.area_code
 and b.area_desc in ('����','�ȷ�','�żҿ�','��̨');
 
 
 
 
 
 
