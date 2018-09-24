select FUNC_GET_XIONGAN_AREA_desc(c.area_desc, a.city_no),
       count(*),
       count(case
               when b.mobile_no is not null then
                a.terminal_code
             end)
  FROM (SELECT AREA_NO,
               city_no,
               TERMINAL_CODE,
               terminal_corp,
               terminal_model,
               REG_DATE
          FROM DW.DW_V_USER_TERMINAL_DEVICE_M A
         WHERE ACCT_MONTH = '201804'
           AND TO_CHAR(REG_DATE, 'YYYY') = '2014') A,
       (SELECT /*+PARALLEL(A,3)*/
         MOBILE_NO,
         USED_DATE,
         OPERATE_DATE,
         SUGGEST_PRICE,
         PHONE_NUMBER,
         RESOURCE_KIND,
         TO_CHAR(in_DATE, 'YYYYMMDD') in_date
          FROM crm_dsg.ir_mobile_using_t@HBODS A --终端出入库信息表 
        ) B,
       dim.dim_area_no c
 WHERE A.TERMINAL_CODE = B.MOBILE_NO(+)
   and a.area_no = c.area_no(+)
 group by FUNC_GET_XIONGAN_AREA_desc(c.area_desc, a.city_no), c.idx_no
 order by c.idx_no
