--决策系统 在55.3执行
select nvl(memo,'其他'),
        MENU_PATH,
       substr(MENU_PATH,instr(MENU_PATH,'>>',-1)+2),
       coun VISIT_NUMS,
       user_cnt
  from (select x.MEMO,count(t.menu_id) coun,count(distinct t.user_id)user_cnt, t.menu_id, substr(MENU_PATH, 7, length(MENU_PATH)) MENU_PATH
          from newdataplatform.E_OPERATION_LOG@hbods t,
               (SELECT T.RESOURCES_ID,
                       SYS_CONNECT_BY_PATH(T.RESOURCES_NAME,'>>' ) MENU_PATH,
                       T.ORD
                  FROM newdataplatform.E_MENU@hbods T
                 START WITH T.RESOURCES_ID = '0'
                CONNECT BY PRIOR T.RESOURCES_ID = T.PARENT_ID) m,
                newdataplatform.e_user@hbods x
         where t.menu_id = m.resources_id
         and t.user_id=x.USER_ID 
          AND substr(t.CREATE_DATE,1,8) >= '20180101' 
         group by x.MEMO,t.menu_id, substr(MENU_PATH, 7, length(MENU_PATH))
         order by coun desc) b
         ORDER BY visit_nums DESC 
         
--承包助手 在55.1执行
select y.area_desc,
       z.city_desc,
       x.huaxiao_no,
       x.huaxiao_name,
       x.huaxiao_type_name,
       x.manager_loginname,
       x.manager_telephone,
       t.MENU_PATH,
       substr(t.MENU_PATH,instr(t.MENU_PATH,'>>',-1)+2),
       sum(coun) 
  from (select count(t.menu_id) coun,
               t.user_id,
               t.menu_id,
               substr(MENU_PATH, 7, length(MENU_PATH)) MENU_PATH
          from new_mobile_cbzs.E_OPERATION_LOG t,
               (SELECT T.RESOURCES_ID,
                       SYS_CONNECT_BY_PATH(T.RESOURCES_NAME, '>>') MENU_PATH,
                       T.ORD
                  FROM new_mobile_cbzs.E_MENU T
                 START WITH T.RESOURCES_ID = '0'
                CONNECT BY PRIOR T.RESOURCES_ID = T.PARENT_ID) m,
               new_mobile_cbzs.e_user x
         where t.menu_id = m.resources_id
           and t.user_id = x.USER_ID
           AND to_char(t.CREATE_DATE, 'yyyymm') >= '201801'
           and t.menu_id in ('3031','3033','3032','3034')
         group by t.menu_id,
                  substr(MENU_PATH, 7, length(MENU_PATH)),
                  t.user_id) t,
       dim.dim_huaxiao_info x,
       dim.dim_area_no y,
       dim.dim_city_no z
 where t.user_id = x.manager_loginid
   and x.area_no = y.area_no
   and x.city_no = z.city_no
 group by y.area_desc,
          z.city_desc,
          x.huaxiao_no,
          x.huaxiao_name,
          x.huaxiao_type_name,
          x.manager_loginname,
          x.manager_telephone,
          t.MENU_PATH,
          substr(t.MENU_PATH,instr(t.MENU_PATH,'>>',-1)+2)

