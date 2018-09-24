select 
developer_no 发展人编码,
developer_name 发展人名称,status 发展人状态,
dealer_id 关联渠道编码,
channel_no_desc 渠道名称
  from (select *
          from dim.dim_develop_no a
         where a.area_no = '018'
            or area_no = '185') a,
       crm_dsg.staff_channel_rela@hbods b,
       dim.dim_channel_no c
 where a.developer_no = b.staff_id(+)
   and b.dealer_id = c.channel_no(+)




select * from crm_dsg.staff_channel_rela@hbods
