select 
developer_no ��չ�˱���,
developer_name ��չ������,status ��չ��״̬,
dealer_id ������������,
channel_no_desc ��������
  from (select *
          from dim.dim_develop_no a
         where a.area_no = '018'
            or area_no = '185') a,
       crm_dsg.staff_channel_rela@hbods b,
       dim.dim_channel_no c
 where a.developer_no = b.staff_id(+)
   and b.dealer_id = c.channel_no(+)




select * from crm_dsg.staff_channel_rela@hbods
