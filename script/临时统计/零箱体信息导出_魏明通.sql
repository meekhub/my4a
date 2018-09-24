select b.area_desc 地市,
       a.city_desc 区县,
       a.fgq_id 分光器id,
       a.fgq_name 分光器名称,
       a.project_id 项目id,
       a.project_desc 项目名称,
       a.fgq_date 入网日期,
       a.standard_id 标准地市id,
       a.standard_name 标准地市名称,
       a.box_id 箱体id,
       a.box_name 箱体名称,
       a.dk_number 总端口,
       a.dk_use_number 占用端口
  from STAGE.ZIYUAN_LINBOX_M a, dim.dim_area_no b
 where '0' || a.area_desc = b.area_code
 and b.area_desc in ('石家庄','承德');
 

select b.area_desc 地市,
       a.city_desc 区县,
       a.fgq_id 分光器id,
       a.fgq_name 分光器名称,
       a.project_id 项目id,
       a.project_desc 项目名称,
       a.fgq_date 入网日期,
       a.standard_id 标准地市id,
       a.standard_name 标准地市名称,
       a.box_id 箱体id,
       a.box_name 箱体名称,
       a.dk_number 总端口,
       a.dk_use_number 占用端口
  from STAGE.ZIYUAN_LINBOX_M a, dim.dim_area_no b
 where '0' || a.area_desc = b.area_code
 and b.area_desc in ('保定','秦皇岛','衡水');
 

select b.area_desc 地市,
       a.city_desc 区县,
       a.fgq_id 分光器id,
       a.fgq_name 分光器名称,
       a.project_id 项目id,
       a.project_desc 项目名称,
       a.fgq_date 入网日期,
       a.standard_id 标准地市id,
       a.standard_name 标准地市名称,
       a.box_id 箱体id,
       a.box_name 箱体名称,
       a.dk_number 总端口,
       a.dk_use_number 占用端口
  from STAGE.ZIYUAN_LINBOX_M a, dim.dim_area_no b
 where '0' || a.area_desc = b.area_code
 and b.area_desc in ('唐山','邯郸');
 

select b.area_desc 地市,
       a.city_desc 区县,
       a.fgq_id 分光器id,
       a.fgq_name 分光器名称,
       a.project_id 项目id,
       a.project_desc 项目名称,
       a.fgq_date 入网日期,
       a.standard_id 标准地市id,
       a.standard_name 标准地市名称,
       a.box_id 箱体id,
       a.box_name 箱体名称,
       a.dk_number 总端口,
       a.dk_use_number 占用端口
  from STAGE.ZIYUAN_LINBOX_M a, dim.dim_area_no b
 where '0' || a.area_desc = b.area_code
 and b.area_desc in ('沧州','廊坊','张家口','邢台');
 
 
 
 
 
 
