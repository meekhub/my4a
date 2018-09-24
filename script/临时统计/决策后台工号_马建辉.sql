select

from
(select a.login_id,
             a.staff_id "staffId",
             a.login_name "loginName",
            
             a.gender "gender",
             a.mobile_phone "mobilePhone",
             a.email "email",
             a.office_tel "officeTel",
             a.state "stateValue",
             case a.state
               when '1' then
                '启用'
               else
                '停用'
             end "state",
             a.init_pwd "initPwd",
             a.reg_date "regDate",
             a.themes "themes",
             a.memo as "memo",
             a.update_user "updateUser",
             a.update_date "updateDate",
             
             a.area_no "areaId",
             a.city_no "cityId",
             a.town_no "townId",
             a.sect_no "sectId",
             
             nvl(b.area_desc, '省份') ||'-'||  c.city_desc"areaDesc",
             c.city_desc "cityDesc",
             d.town_desc "townDesc",
             e.sect_desc "sectDesc",
             
             a.area   "areaPersonId",
             a.city "cityPersonId",
             a.town "townPersonId",
             
             nvl(bp.area_desc, '省份')||'-'||cp.city_desc  "areaPersonDesc",
             cp.city_desc "cityPersonDesc",
             dp.town_desc "townPersonDesc",
             
             a.oa_department "department",
             decode(a.oa_department, '2700000000', '未知', f.department_desc) "deptName",
             
             a.v_id "oaVID"
        from DSS_FRAME.SC_LOGIN_USER a
      
        left outer join DSS_FRAME.ISP_CODE_AREA b
          on (a.area_no = b.area_no)
        left outer join DSS_FRAME.ISP_CODE_CITY c
          on (a.city_no = c.city_no)
        left outer join DSS_FRAME.ISP_CODE_TOWN d
          on (a.town_no = d.town_no)
        left outer join DSS_FRAME.ISP_CODE_SECT e
          on (a.sect_no = e.sect_no)
      
        left outer join DSS_FRAME.ISP_CODE_AREA bp
          on (a.area = bp.area_no)
        left outer join DSS_FRAME.ISP_CODE_CITY cp
          on (a.city = cp.city_no)
        left outer join DSS_FRAME.ISP_CODE_TOWN dp
          on (a.town = dp.town_no)
      
        left outer join DSS_FRAME.code_oa_department f
          on (a.oa_department = f.department and f.state = '1')
          where 1=1)
