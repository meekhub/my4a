select *
  from (select a.staff_code 工号,
               a.staff_name 销售员姓名,
               a.common_region_id 销售员区域ID,
               u.region_name 销售员区域,
               --u.zone_number 区号,
               e.region_name 上级区域,
               a.sales_code 销售员编码,
               decode(a.status_cd,
                      '1000',
                      '有效',
                      '1100',
                      '无效',
                      '1001',
                      '暂停',
                      '1020',
                      '停用') 销售员状态,
               ss.销售人员用工性质,
               ss.用工性质,
               s2.销售人员岗位,
               s2.岗位取值,
               decode(uu.cert_type, '1', '身份证', '其他') 证件类型,
               decode(b.rela_type,
                      '10',
                      '受理',
                      '20',
                      '渠道经理',
                      '30',
                      '归属') 关联关系,
               c.channel_nbr 渠道单元编码,
               c.STRUCT_NAME 渠道单元名称
          from (select to_char(staff_id)staff_id,
                       party_id,
                       staff_code,
                       common_region_id,
                       staff_name,
                       status_cd,
                       sales_code
                  from crm_dsg.staff
                 where common_region_id like '813%') a, --工号    区域 组织机构
               (select staff_id, channel_id, rela_type
                  from crm_dsg.staff_channel_rela) b,
               (select channel_id,
                       channel_nbr,
                       channel_name STRUCT_NAME,
                       common_region_id,
                       status_cd
                  from crm_dsg.channel) c,
               (select common_region_id common_region_id1,
                       region_name,
                       up_region_id,
                       REGION_LEVEL 
                  from crm_dsg.common_region
                 where common_region_id like '813%') u,
               (select common_region_id common_region_id2,
                       region_name,
                       up_region_id,
                       REGION_LEVEL 
                  from crm_dsg.common_region
                 where common_region_id like '813%') e,
               (select common_region_id common_region_id3,
                       region_name,
                       up_region_id,
                       REGION_LEVEL REGION_LEVEL
                  from crm_dsg.common_region
                 where common_region_id like '813%') w,
               (select staff_id,
                       attr_id 销售人员用工性质,
                       decode(attr_value,
                              '10',
                              '合同制',
                              '20',
                              '派遣制',
                              '30',
                              '外包制') 用工性质
                  from crm_dsg.staff_attr
                 where attr_id = '50000018') ss,
               (select staff_id,
               a.attr_id 销售人员岗位,
               b.attr_value_Desc 岗位取值
          from (select staff_id, attr_id, attr_value
                  from crm_dsg.staff_attr
                 where attr_id = '50000016'
                   and attr_value = 12) a,
               (select attr_id, attr_value, attr_desc attr_value_Desc
                  from crm_dsg.attr_value
                 where attr_id = '50000016') b
         where a.attr_id = b.attr_id(+)
           and a.attr_value = b.attr_value(+) )s2,
         (select party_id, cert_type from crm_dsg.party_certification) uu
         where a.staff_id = b.staff_id
           and a.common_region_id = u.common_region_id1(+)
           and u.up_region_id = e.common_region_id2(+)
           and b.channel_id = c.channel_id(+)
           and c.common_region_id = w.common_region_id3(+)
           and a.party_id = uu.party_id(+)
           and a.status_cd = '1000'
           and a.staff_id = ss.staff_id(+)
           and a.staff_id = s2.staff_id) xsy,
       
       (select a.channel_id,
               channel_nbr,
               a.channel_NAME,
               decode(channel_class, '20', '店中商', '10', '销售点', '', '') 销售点类别,
               b.STRUCT_NAME 三级分类,
               c.STRUCT_NAME 二级分类,
               d.STRUCT_NAME 一级分类, 
               a.common_region_id 区域,
               m.region_name 所属地区,
               n.region_name 上级所属地区,
               decode(status_Cd,
                      '1001',
                      '主动暂停',
                      '1100',
                      '无效',
                      '1000',
                      '有效',
                      '1002',
                      '异常暂停') 状态,
               a.status_date 状态变更时间
          from crm_dsg.channel a,
               crm_dsg.bd_dealer_structure_t b,
               crm_dsg.bd_dealer_structure_t c,
               crm_dsg.bd_dealer_structure_t d,
               (select common_region_id,
                       region_name,
                       up_region_id,
                       region_Desc
                  from crm_dsg.common_region
                 where common_region_id like '813%') m,
               (select common_region_id,
                       region_name,
                       up_region_id,
                       region_Desc
                  from crm_dsg.common_region
                 where common_region_id like '813%') n
         where a.common_region_id like '813%'
           and a.channel_type_cd = b.channel_type_cd(+)
           and b.CHANNEL_TYPE_CD = c.channel_type_cd(+)
           and c.CHANNEL_TYPE_CD = d.channel_type_cd(+)
           and a.common_region_id = m.common_region_id(+)
           and m.up_region_id = n.common_region_id(+)
           and a.status_Cd = '1000') qddy
 where xsy.渠道单元编码 = qddy.channel_nbr(+)
