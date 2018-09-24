--直销渠道
select distinct z.area_desc,y.F_AREA_NAME,t.develop_no,
decode(x.STATUS_CD,'1102','退出','1200','未生效','1300','已归档','1101','终止','1000','有效','1001','主动暂停','1002','异常暂停','1100','无效')
  from tmp_majh_0401_03_1 t,
       CRM_DSG.CHANNEL_MEMBER@HBODS x,
       (select distinct a.F_AREA_ID, a.F_AREA_NAME
          from dsg_stage.om_area_t a
         where a.F_AREA_LEVEL = 4) y,
         dim.dim_area_no z
 where t.develop_no = x.staff_id
   and x.common_region_id = y.F_AREA_ID(+)
   and x.city_code=z.area_no(+)


--全省发展人明细
select distinct z.area_desc 地市,
                y.F_AREA_NAME 区县,
                x.staff_id 发展人ID,
                x.channel_member_name 名称,
                decode(x.STATUS_CD,
                       '1102',
                       '退出',
                       '1200',
                       '未生效',
                       '1300',
                       '已归档',
                       '1101',
                       '终止',
                       '1000',
                       '有效',
                       '1001',
                       '主动暂停',
                       '1002',
                       '异常暂停',
                       '1100',
                       '无效') 状态
  from CRM_DSG.CHANNEL_MEMBER@HBODS x,
       (select distinct a.F_AREA_ID, a.F_AREA_NAME
          from dsg_stage.om_area_t a
         where a.F_AREA_LEVEL = 4) y,
       dim.dim_area_no z
 where x.common_region_id = y.F_AREA_ID(+)
   and x.city_code = z.area_no(+)
