--��ֹ18��4����⵫δ��ע��ƽ̨������¼
SELECT X.RESOURCE_MANUFACTURER, COUNT(*)
  FROM TMP_MAJH_CUAN_0530_04 T, TMP_MAJH_TRM_MODEL X
 WHERE T.TERMINAL_CODE IS NULL
   AND SUBSTR(T.IN_DATE, 1, 4) = '2018'
   AND T.RESOURCE_KIND = X.RESOURCE_KIND_NO
 GROUP BY X.RESOURCE_MANUFACTURER;


--��Ϊ����ҫ��VIVO��OPPO
create table tmp_trm_0629_01 as
SELECT X.RESOURCE_MANUFACTURER ����,
       upper(X.RESOURCE_KIND_NAME) �ͺ�,
       T.MOBILE_NO ��⴮��,
       T.PHONE_NUMBER ���ʱ��Ӧ�ֻ���
  FROM TMP_MAJH_CUAN_0530_04 T, TMP_MAJH_TRM_MODEL X
 WHERE T.TERMINAL_CODE IS NULL
   AND SUBSTR(T.IN_DATE, 1, 4) = '2018'
   AND T.RESOURCE_KIND = X.RESOURCE_KIND_NO
   AND UPPER(X.RESOURCE_MANUFACTURER) IN
       ('��Ϊ', 'OPPO', 'VIVO', '��Ϊ��ҫ', 'HUAWEI', 'HONOR');

--����
select * from  tmp_trm_0629_01 t where upper(����) IN ('VIVO');


--18�������ϸ
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
          FROM CRM_DSG.IR_MOBILE_USING_T@HBODS A --�ն˳������Ϣ�� 
        ) B,
       (SELECT * FROM CRM_DSG.BI_MDN_TERMINFO_IMP_T@HBODS) C
 WHERE A.TERMINAL_CODE = B.MOBILE_NO(+)
   AND A.TERMINAL_CODE = C.TERMKEY(+)
   and c.termkey is not  null 
   and b.mobile_no is null;
   
create table tmp_majh_trm_cuan_01 as 
select distinct TERMINAL_CODE from tmp_trm_0629_02;


select * from tmp_majh_trm_cuan_01
   
--ͳ������ն˴���������
select * from crm_dsg.BRPT_BDN_101201_T a where a.device_no='A000007FA63145'


SELECT COUNT(*), COUNT(DISTINCT A.MOBILE_NO)
  FROM (SELECT MOBILE_NO
          FROM CRM_DSG.IR_MOBILE_USING_T@HBODS A
         WHERE TO_CHAR(IN_DATE, 'YYYY') = '2018') A,
       CRM_DSG.BRPT_BDN_101201_T@HBODS B
 WHERE A.MOBILE_NO = B.DEVICE_NO
 
















