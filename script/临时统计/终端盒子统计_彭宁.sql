create table tmp_majh_mac_0824_02 as
select 
a.*,b.*
 from tmp_majh_mac_0824_01 a,
CRM_DSG.IR_MOBILE_USING_T@HBODS b
where a.mac_id=b.mobile_no(+);



select 
distinct  nvl(b.area_desc,'全省') 地市,
a.mac_id,
case when a.stock_status='10' then '在库' 
  when a.stock_status='12' then '长期占用'
    else '未知' end 库存状态,
      nvl(c.resource_manufacturer,'未知')厂商,
      nvl(c.resource_kind_name,'未知')终端型号,
      d.channel_no_desc 渠道,
      a.phone_number IPTV服务号,
      a.in_date 入库时间
 from tmp_majh_mac_0824_02 a,
dim.dim_area_no b,
tmp_majh_trm_model c,
dim.dim_channel_no d
where a.city_code=b.area_no(+)
and a.resource_kind=c.resource_kind_no(+)
and a.belongs_to=d.channel_no(+);



