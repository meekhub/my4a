--截止18年4月入库但未在注册平台产生记录
SELECT X.RESOURCE_MANUFACTURER, COUNT(*)
  FROM TMP_MAJH_CUAN_0530_04 T, TMP_MAJH_TRM_MODEL X
 WHERE T.TERMINAL_CODE IS NULL
   AND SUBSTR(T.IN_DATE, 1, 4) = '2018'
   AND T.RESOURCE_KIND = X.RESOURCE_KIND_NO
 GROUP BY X.RESOURCE_MANUFACTURER;


--华为、荣耀、VIVO、OPPO
create table tmp_trm_0629_01 as
SELECT X.RESOURCE_MANUFACTURER 厂商,
       upper(X.RESOURCE_KIND_NAME) 型号,
       T.MOBILE_NO 入库串码,
       T.PHONE_NUMBER 入库时对应手机号
  FROM TMP_MAJH_CUAN_0530_04 T, TMP_MAJH_TRM_MODEL X
 WHERE T.TERMINAL_CODE IS NULL
   AND SUBSTR(T.IN_DATE, 1, 4) = '2018'
   AND T.RESOURCE_KIND = X.RESOURCE_KIND_NO
   AND UPPER(X.RESOURCE_MANUFACTURER) IN
       ('华为', 'OPPO', 'VIVO', '华为荣耀', 'HUAWEI', 'HONOR');

--导出
select * from  tmp_trm_0629_01 t where upper(厂商) IN ('VIVO');


--18年窜入明细
create table tmp_trm_0629_02 as 
select a.* 
  FROM (SELECT AREA_NO,
               CITY_NO,
               TERMINAL_CODE,
               TERMINAL_CORP,
               TERMINAL_MODEL,
               REG_DATE,
               ACCT_MONTH
          FROM DW.DW_V_USER_TERMINAL_DEVICE_D A
         WHERE ACCT_MONTH = '201806'
           and day_id='28'
           AND TO_CHAR(REG_DATE, 'YYYY')='2018') A,
       (SELECT MOBILE_NO,
               USED_DATE,
               OPERATE_DATE,
               SUGGEST_PRICE,
               PHONE_NUMBER,
               RESOURCE_KIND,
               TO_CHAR(IN_DATE, 'YYYYMMDD') IN_DATE
          FROM CRM_DSG.IR_MOBILE_USING_T@HBODS A --终端出入库信息表 
        ) B,
       (SELECT * FROM CRM_DSG.BI_MDN_TERMINFO_IMP_T@HBODS) C
 WHERE A.TERMINAL_CODE = B.MOBILE_NO(+)
   AND A.TERMINAL_CODE = C.TERMKEY(+)
   and c.termkey is not  null 
   and b.mobile_no is null;
   
create table tmp_majh_trm_cuan_01 as 
select distinct TERMINAL_CODE from tmp_trm_0629_02;


select * from tmp_majh_trm_cuan_01
   
--统计入库终端带补贴比率
select * from crm_dsg.BRPT_BDN_101201_T a where a.device_no='A000007FA63145'


SELECT COUNT(*), COUNT(DISTINCT A.MOBILE_NO)
  FROM (SELECT MOBILE_NO
          FROM CRM_DSG.IR_MOBILE_USING_T@HBODS A
         WHERE TO_CHAR(IN_DATE, 'YYYY') = '2018') A,
       CRM_DSG.BRPT_BDN_101201_T@HBODS B
 WHERE A.MOBILE_NO = B.DEVICE_NO
 
















