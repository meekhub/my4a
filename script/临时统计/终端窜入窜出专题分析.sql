--1、14-18年各年我省终端窜入分析（分地市/品牌/机型/全省）-----------

--窜入明细
create table tmp_majh_cuan_0530_02 as
select *
  from (select a.*,
               row_number() over(partition by termkey order by registerdate desc) rn
          from CRM_DSG.BI_MDN_TERMINFO_IMP_T@HBODS a)
 where rn = 1;

--明细
create table tmp_majh_cuan_0530_mx as
SELECT TO_CHAR(REG_DATE, 'YYYYMM')REG_DATE,
       A.AREA_NO,
       A.CITY_NO, 
       A.TERMINAL_CORP,
       A.TERMINAL_MODEL,
       A.TERMINAL_CODE,
       a.device_no,
       B.MOBILE_NO,
       C.TERMKEY,
       c.MDN
  FROM (SELECT AREA_NO,
               CITY_NO,
               TERMINAL_CODE,
               TERMINAL_CORP,
               TERMINAL_MODEL,
               REG_DATE,
               ACCT_MONTH,
               device_no
          FROM DW.DW_V_USER_TERMINAL_DEVICE_M A
         WHERE ACCT_MONTH = '201806'
           AND TO_CHAR(REG_DATE, 'YYYY') >= '2018') A,
       (SELECT MOBILE_NO,
               USED_DATE,
               OPERATE_DATE,
               SUGGEST_PRICE,
               PHONE_NUMBER,
               RESOURCE_KIND,
               TO_CHAR(IN_DATE, 'YYYYMMDD') IN_DATE
          FROM CRM_DSG.IR_MOBILE_USING_T@HBODS A --终端出入库信息表 
        ) B,
       tmp_majh_cuan_0530_02 C
 WHERE A.TERMINAL_CODE = B.MOBILE_NO(+)
   AND A.TERMINAL_CODE = C.TERMKEY(+); 
          
--汇总   
create table tmp_majh_cuan_0530_01 as
SELECT TO_CHAR(REG_DATE, 'YYYYMM')REG_DATE,
       A.AREA_NO,
       A.CITY_NO,
       A.TERMINAL_CORP,
       A.TERMINAL_MODEL,
       COUNT(DISTINCT A.TERMINAL_CODE) REG_CNT,
       COUNT(DISTINCT B.MOBILE_NO) HANG_CNT,
       COUNT(DISTINCT case when b.mobile_no is null then C.TERMKEY end ) CUAN_CNT
  FROM (SELECT AREA_NO,
               CITY_NO,
               TERMINAL_CODE,
               TERMINAL_CORP,
               TERMINAL_MODEL,
               REG_DATE,
               ACCT_MONTH
          FROM DW.DW_V_USER_TERMINAL_DEVICE_M A
         WHERE ACCT_MONTH = '201808'
           AND TO_CHAR(REG_DATE, 'YYYYMM') in ('201807','201808')) A,
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
 GROUP BY TO_CHAR(REG_DATE, 'YYYYMM'),
          A.AREA_NO,
          A.CITY_NO,
          A.TERMINAL_CORP,
          A.TERMINAL_MODEL;


--分地市
  SELECT SUBSTR(A.REG_DATE, 1, 4),
         B.AREA_DESC，
         SUM(REG_CNT),
         SUM(HANG_CNT),
         SUM(CUAN_CNT)
    FROM tmp_majh_cuan_0530_01 A, DIM.DIM_AREA_NO B
   WHERE FUNC_GET_XIONGAN_AREA_NO(A.AREA_NO, A.CITY_NO) = B.AREA_NO
   AND SUBSTR(A.REG_DATE, 1, 4)='2018'
   GROUP BY SUBSTR(A.REG_DATE, 1, 4),B.AREA_DESC,b.idx_no
   ORDER BY B.IDX_NO

--分品牌
  SELECT  
         a.TERMINAL_CORP,
         SUM(REG_CNT),
         SUM(HANG_CNT),
         SUM(CUAN_CNT)
    FROM TMP_MAJH_CUAN_0530_01 A
    where SUBSTR(A.REG_DATE, 1, 6)='201807'
    group by a.TERMINAL_CORP

--分型号
  SELECT  a.TERMINAL_CORP，
         a.TERMINAL_MODEL,
         SUM(REG_CNT),
         SUM(HANG_CNT),
         SUM(CUAN_CNT)
    FROM TMP_MAJH_CUAN_0530_01 A
    where SUBSTR(A.REG_DATE, 1, 4)='2018'
    group by a.TERMINAL_CORP，a.TERMINAL_MODEL;




--窜货注册、发展结构、渠道来源

--租机
truncate table tmp_majh_0328_02
  INSERT /*+ APPEND */
  INTO tmp_majh_0328_02 NOLOGGING
    SELECT USER_NO,
           AREA_NO,
           SALES_MODE,
           TO_CHAR(BEGIN_DATE, 'YYYYMMDD'),
           TO_CHAR(END_DATE, 'YYYYMMDD'),
           COST_PRICE,
           device_no,
           device_number,
           present_fee,
           channel_no
      FROM (SELECT T.*,
                   ROW_NUMBER() OVER(PARTITION BY USER_NO ORDER BY BEGIN_DATE DESC) RN
              FROM ODS.O_PRD_USER_DEVICE_RENT_D@hbods T
             WHERE T.ACCT_MONTH = '201808'
               AND T.DAY_ID = '01')
     WHERE RN = 1;
     commit;

--统计 
create table tmp_majh_0328_04 as
select *
  from (SELECT DEVICE_NUMBER,
               USER_NO,
               channel_no,
               innet_date,
               channel_no_desc,
               CHANNEL_KIND,
               channel_type,
               channel_type_desc,
               row_number() over(partition by DEVICE_NUMBER order by innet_date desc) rn
          FROM DW.DW_V_USER_BASE_INFO_USER C
         WHERE ACCT_MONTH = '201804'
           AND TELE_TYPE = '2')
 where rn = 1

--汇总     
SELECT COUNT(DISTINCT A.TERMKEY),
       COUNT(DISTINCT CASE
               WHEN B.DEVICE_NO IS NOT NULL THEN
                B.DEVICE_NO
             END),
       COUNT(DISTINCT CASE
               WHEN C.CHANNEL_KIND = '002' THEN
                A.TERMKEY
             END),
       COUNT(DISTINCT CASE
               WHEN C.CHANNEL_KIND = '001' THEN
                A.TERMKEY
             END)
  FROM (SELECT *
          FROM TMP_MAJH_CUAN_0530_MX
         WHERE SUBSTR(REG_DATE, 1, 4) = '2014'
           AND MOBILE_NO IS NULL) A,
       TMP_MAJH_0328_02 B,
       tmp_majh_0328_04 C
 WHERE A.TERMKEY = B.DEVICE_NO(+)
   AND A.MDN = C.DEVICE_NUMBER(+);

--细分渠道类型
SELECT C.CHANNEL_TYPE_DESC, COUNT(DISTINCT A.TERMKEY)
  FROM (SELECT *
          FROM TMP_MAJH_CUAN_0530_MX
         WHERE SUBSTR(REG_DATE, 1, 4) = '2016'
           AND MOBILE_NO IS NULL) A,
       TMP_MAJH_0328_04 C 
 WHERE A.MDN = C.DEVICE_NUMBER
   AND C.CHANNEL_KIND = '002' 
 GROUP BY C.CHANNEL_TYPE_DESC
 

--专营店
SELECT B.CHANNEL_NO,
       B.CHANNEL_NO_DESC,
       COUNT(DISTINCT CASE
               WHEN SUBSTR(REG_DATE, 1, 4) = '2014' THEN
                A.MDN
             END),
       COUNT(DISTINCT CASE
               WHEN SUBSTR(REG_DATE, 1, 4) = '2015' THEN
                A.MDN
             END),
       COUNT(DISTINCT CASE
               WHEN SUBSTR(REG_DATE, 1, 4) = '2016' THEN
                A.MDN
             END),
       COUNT(DISTINCT CASE
               WHEN SUBSTR(REG_DATE, 1, 4) = '2017' THEN
                A.MDN
             END),
       COUNT(DISTINCT CASE
               WHEN SUBSTR(REG_DATE, 1, 4) = '2018' THEN
                A.MDN
             END)
  FROM (SELECT * FROM TMP_MAJH_CUAN_0530_MX WHERE MOBILE_NO IS NULL) A,
       TMP_MAJH_0328_04 C,
       TMP_MAJH_0328_04 B
 WHERE A.MDN = C.DEVICE_NUMBER
   AND A.MDN = B.DEVICE_NUMBER
   AND C.CHANNEL_KIND = '002'
   AND C.CHANNEL_TYPE_DESC = '专营店'
   AND MDN IS NOT NULL
 GROUP BY B.CHANNEL_NO, B.CHANNEL_NO_DESC;
 
--14-18年录入我省串码池串号电信自注册情况（分地市/品牌/机型/全省）；

--外省终端统计
CREATE TABLE TMP_MAJH_CUAN_0530_03 AS
SELECT RGST_PRVNCE_NM,
       RGST_BRAND,
       RGST_MDL TERMINAL_MODEL,
       ESN TERMINAL_CODE,
       ACCS_NBR,
       SUBSTR(RGST_DT, 1, 6) REG_DATE
  FROM (SELECT *
          FROM ALLDM.BWT_DOWN_RGST_TRMNL_PRVNC@OLDHBDW D
         WHERE DAY_ID <= '20180211'
           AND SUBSTR(D.RGST_DT, 1, 4) >='2014'
           AND D.RGST_PRVNCE <> '813'
        UNION ALL
        SELECT *
          FROM ALLDM.BWT_DOWN_RGST_TRMNL_PRVNC D
         WHERE DAY_ID >= '20180212'
           AND SUBSTR(D.RGST_DT, 1, 4) >='2014'
           AND D.RGST_PRVNCE <> '813');
           
--沉淀明细
create table tmp_majh_cuan_0530_04 as 
SELECT A.IN_DATE,
       A.CITY_CODE,
       A.RESOURCE_KIND,
       A.MOBILE_NO,
       A.PHONE_NUMBER,
       B.TERMINAL_CORP,
       B.TERMINAL_MODEL,
       B.TERMINAL_CODE,
       C.RGST_PRVNCE_NM,
       C.ACCS_NBR,
       C.TERMINAL_CODE AS TERMINAL_CODE_OUT
  FROM (SELECT CITY_CODE,
               MOBILE_NO,
               PHONE_NUMBER,
               USED_DATE,
               OPERATE_DATE,
               SUGGEST_PRICE, 
               RESOURCE_KIND,
               TO_CHAR(IN_DATE, 'YYYYMM') IN_DATE
          FROM CRM_DSG.IR_MOBILE_USING_T@HBODS A --终端出入库信息表 
          where TO_CHAR(IN_DATE, 'YYYYMM')>='2014'
        ) A,
       (SELECT AREA_NO,
               CITY_NO,
               TERMINAL_CODE,
               TERMINAL_CORP,
               TERMINAL_MODEL,
               REG_DATE,
               ACCT_MONTH,
               DEVICE_NO
          FROM DW.DW_V_USER_TERMINAL_DEVICE_M A
         WHERE ACCT_MONTH = '201804'
           AND TO_CHAR(REG_DATE, 'YYYY') >= '2014') B,
       (SELECT *
          FROM (SELECT A.*,
                       ROW_NUMBER() OVER(PARTITION BY A.TERMINAL_CODE ORDER BY A.REG_DATE ASC) RN
                  FROM TMP_MAJH_CUAN_0530_03 A)
         WHERE RN = 1) C
 WHERE A.MOBILE_NO = B.TERMINAL_CODE(+)
   AND A.MOBILE_NO = C.TERMINAL_CODE(+);

create table tmp_majh_trm_model as
SELECT *
  FROM (SELECT TRIM(RESOURCE_MANUFACTURER) RESOURCE_MANUFACTURER,
               TRIM(RESOURCE_KIND_ID) RESOURCE_KIND_ID,
               TRIM(RESOURCE_KIND_NO) RESOURCE_KIND_NO,
               TRIM(RESOURCE_KIND_NAME) RESOURCE_KIND_NAME,
               ROW_NUMBER() OVER(PARTITION BY RESOURCE_KIND_NO ORDER BY RESOURCE_KIND_ID DESC) RN
          FROM DSG_STAGE.IR_GET_RESOURCE_KIND_T F) F
 WHERE RN = 1;

--分地市
SELECT B.AREA_DESC,
       COUNT(DISTINCT A.MOBILE_NO),
       COUNT(DISTINCT CASE
               WHEN A.TERMINAL_CODE IS NULL THEN
                A.MOBILE_NO
             END),
       COUNT(DISTINCT A.TERMINAL_CODE),
       COUNT(DISTINCT A.TERMINAL_CODE_OUT)
  FROM TMP_MAJH_CUAN_0530_04 A, DIM.DIM_AREA_NO B 
 WHERE A.CITY_CODE = B.AREA_NO
 and substr(a.in_date,1,4)='2018'
 GROUP BY B.AREA_DESC, B.IDX_NO
 ORDER BY B.IDX_NO;
 
--分品牌
SELECT B.RESOURCE_MANUFACTURER,
       COUNT(DISTINCT A.MOBILE_NO),
       COUNT(DISTINCT CASE
               WHEN A.TERMINAL_CODE IS NULL THEN
                A.MOBILE_NO
             END),
       COUNT(DISTINCT A.TERMINAL_CODE),
       COUNT(DISTINCT A.TERMINAL_CODE_OUT)
  FROM TMP_MAJH_CUAN_0530_04 A, TMP_MAJH_TRM_MODEL B
 WHERE A.RESOURCE_KIND = B.RESOURCE_KIND_NO
   AND SUBSTR(IN_DATE, 1, 4) = '2018'
 GROUP BY B.RESOURCE_MANUFACTURER


--分机型
SELECT B.RESOURCE_MANUFACTURER,
       B.RESOURCE_KIND_NAME,
       COUNT(DISTINCT A.MOBILE_NO),
       COUNT(DISTINCT CASE
               WHEN A.TERMINAL_CODE IS NULL THEN
                A.MOBILE_NO
             END),
       COUNT(DISTINCT A.TERMINAL_CODE),
       COUNT(DISTINCT A.TERMINAL_CODE_OUT)
  FROM TMP_MAJH_CUAN_0530_04 A, TMP_MAJH_TRM_MODEL B
 WHERE A.RESOURCE_KIND = B.RESOURCE_KIND_NO
   AND SUBSTR(IN_DATE, 1, 4) = '2017'
 GROUP BY B.RESOURCE_MANUFACTURER, B.RESOURCE_KIND_NAME;


--窜出终端去向分析
SELECT A.RGST_PRVNCE_NM, COUNT(DISTINCT A.TERMINAL_CODE_OUT)
  FROM TMP_MAJH_CUAN_0530_04 A
 WHERE SUBSTR(IN_DATE, 1, 4) = '2016'
 GROUP BY A.RGST_PRVNCE_NM;


--窜出终端质量分析
select count(distinct a.terminal_code_out),count(distinct b.device_no) from 
(select a.terminal_code_out
  from TMP_MAJH_CUAN_0530_04 a
 where SUBSTR(IN_DATE, 1, 4) = '2015'
 and a.terminal_code_out is not null)a,
 tmp_majh_0328_02 b
 where a.terminal_code_out=b.device_no(+)


--合约比例变化分析
SELECT COUNT(DISTINCT A.DEVICE_NUMBER),
       COUNT(DISTINCT case when TO_CHAR(A.INNET_DATE, 'YYYYMM') =SUBSTR(B.BEGIN_DATE, 1, 6) then B.DEVICE_NUMBER end),
       COUNT(DISTINCT CASE
               WHEN CHANNEL_KIND = '002'  THEN
                A.DEVICE_NUMBER
             END),
       COUNT(DISTINCT CASE
               WHEN CHANNEL_KIND = '002' AND TO_CHAR(A.INNET_DATE, 'YYYYMM') =SUBSTR(B.BEGIN_DATE, 1, 6) THEN
                B.DEVICE_NUMBER
             END),
       COUNT(DISTINCT CASE
               WHEN CHANNEL_KIND = '001'  THEN
                A.DEVICE_NUMBER
             END),
       COUNT(DISTINCT CASE
               WHEN CHANNEL_KIND = '001' AND TO_CHAR(A.INNET_DATE, 'YYYYMM') =SUBSTR(B.BEGIN_DATE, 1, 6) THEN
                B.DEVICE_NUMBER
             END)
  FROM (SELECT USER_NO, DEVICE_NUMBER, CHANNEL_KIND,INNET_DATE
          FROM DW.DW_V_USER_BASE_INFO_USER A
         WHERE ACCT_MONTH = '201806'
           AND TELE_TYPE = '2'
           AND IS_ONNET = '1'
           AND TO_CHAR(INNET_DATE, 'YYYY') = '2018') A,
       (SELECT *
          FROM TMP_MAJH_0328_02
         WHERE SUBSTR(BEGIN_DATE, 1, 4) >= '2018') B
 WHERE A.DEVICE_NUMBER = B.DEVICE_NUMBER(+)



--渠道发展合约当月首次注册匹配占比
SELECT COUNT(DISTINCT CASE
               WHEN A.CHANNEL_KIND = '002' THEN
                C.DEVICE_NUMBER
             END),
       COUNT(DISTINCT CASE
               WHEN A.CHANNEL_KIND = '002' AND TO_CHAR(A.INNET_DATE, 'YYYYMM') =
                    TO_CHAR(B.REG_DATE, 'YYYYMM') AND
                    TO_CHAR(A.INNET_DATE, 'YYYYMM') =
                    SUBSTR(C.BEGIN_DATE,1,6) AND B.TERMINAL_CODE=C.DEVICE_NO THEN
                B.USER_NO
             END),
       COUNT(DISTINCT CASE
               WHEN A.CHANNEL_KIND = '001' THEN
                C.DEVICE_NUMBER
             END),
       COUNT(DISTINCT CASE
               WHEN A.CHANNEL_KIND = '001' AND TO_CHAR(A.INNET_DATE, 'YYYYMM') =
                    TO_CHAR(B.REG_DATE, 'YYYYMM') AND
                    TO_CHAR(A.INNET_DATE, 'YYYYMM') =
                    SUBSTR(C.BEGIN_DATE,1,6) AND B.TERMINAL_CODE=C.DEVICE_NO THEN
                B.USER_NO
             END)
  FROM (SELECT USER_NO, DEVICE_NUMBER, CHANNEL_KIND, INNET_DATE
          FROM DW.DW_V_USER_BASE_INFO_USER A
         WHERE ACCT_MONTH = '201806'
           AND TELE_TYPE = '2'
           AND IS_ONNET = '1'
           AND TO_CHAR(INNET_DATE, 'YYYY') = '2018') A,
       (SELECT USER_NO, REG_DATE,TERMINAL_CODE
          FROM DW.DW_V_USER_TERMINAL_DEVICE_M B
         WHERE ACCT_MONTH = '201806') B,
       (SELECT *
          FROM TMP_MAJH_0328_02
         WHERE SUBSTR(BEGIN_DATE, 1, 4) = '2018') C
 WHERE A.USER_NO = B.USER_NO(+)
   AND A.DEVICE_NUMBER = C.DEVICE_NUMBER(+)


--渠道发展合约当月末次注册匹配占比
SELECT COUNT(DISTINCT CASE
               WHEN A.CHANNEL_KIND = '002' THEN
                C.DEVICE_NUMBER
             END),
       COUNT(DISTINCT CASE
               WHEN A.CHANNEL_KIND = '002'  AND B.TERMINAL_CODE=C.DEVICE_NO THEN
                B.USER_NO
             END),
       COUNT(DISTINCT CASE
               WHEN A.CHANNEL_KIND = '001' THEN
                C.DEVICE_NUMBER
             END),
       COUNT(DISTINCT CASE
               WHEN A.CHANNEL_KIND = '001'  AND B.TERMINAL_CODE=C.DEVICE_NO THEN
                B.USER_NO
             END)
  FROM (SELECT USER_NO, DEVICE_NUMBER, CHANNEL_KIND, INNET_DATE
          FROM DW.DW_V_USER_BASE_INFO_USER A
         WHERE ACCT_MONTH = '201806'
           AND TELE_TYPE = '2'
           AND IS_ONNET = '1'
           AND TO_CHAR(INNET_DATE, 'YYYY') = '2018') A,
       (SELECT USER_NO, REG_DATE,TERMINAL_CODE
          FROM DW.DW_V_USER_TERMINAL_USER_M B
         WHERE ACCT_MONTH = '201806') B,
       (SELECT *
          FROM TMP_MAJH_0328_02
         WHERE SUBSTR(BEGIN_DATE, 1, 4) = '2018') C
 WHERE A.USER_NO = B.USER_NO(+)
   AND A.DEVICE_NUMBER = C.DEVICE_NUMBER(+)

--首次 整体
SELECT COUNT(DISTINCT C.DEVICE_NUMBER),
       COUNT(DISTINCT CASE
               WHEN  TO_CHAR(A.INNET_DATE, 'YYYYMM') =
                    TO_CHAR(B.REG_DATE, 'YYYYMM') AND
                    TO_CHAR(A.INNET_DATE, 'YYYYMM') =
                    SUBSTR(C.BEGIN_DATE,1,6) AND B.TERMINAL_CODE=C.DEVICE_NO THEN
                B.USER_NO
             END) 
  FROM (SELECT USER_NO, DEVICE_NUMBER, CHANNEL_KIND, INNET_DATE
          FROM DW.DW_V_USER_BASE_INFO_USER A
         WHERE ACCT_MONTH = '201806'
           AND TELE_TYPE = '2'
           AND IS_ONNET = '1'
           AND TO_CHAR(INNET_DATE, 'YYYY') = '2018') A,
       (SELECT USER_NO, REG_DATE,TERMINAL_CODE
          FROM DW.DW_V_USER_TERMINAL_DEVICE_M B
         WHERE ACCT_MONTH = '201806') B,
       (SELECT *
          FROM TMP_MAJH_0328_02
         WHERE SUBSTR(BEGIN_DATE, 1, 4) = '2018') C
 WHERE A.USER_NO = B.USER_NO(+)
   AND A.DEVICE_NUMBER = C.DEVICE_NUMBER(+)
   

--末次  整体
SELECT COUNT(DISTINCT C.DEVICE_NUMBER),
       COUNT(DISTINCT CASE
               WHEN  B.TERMINAL_CODE=C.DEVICE_NO THEN
                B.USER_NO
             END) 
  FROM (SELECT USER_NO, DEVICE_NUMBER, CHANNEL_KIND, INNET_DATE
          FROM DW.DW_V_USER_BASE_INFO_USER A
         WHERE ACCT_MONTH = '201806'
           AND TELE_TYPE = '2'
           AND IS_ONNET = '1'
           AND TO_CHAR(INNET_DATE, 'YYYY') = '2018') A,
       (SELECT USER_NO, REG_DATE,TERMINAL_CODE
          FROM DW.DW_V_USER_TERMINAL_USER_M B
         WHERE ACCT_MONTH = '201806') B,
       (SELECT *
          FROM TMP_MAJH_0328_02
         WHERE SUBSTR(BEGIN_DATE, 1, 4) = '2018') C
 WHERE A.USER_NO = B.USER_NO(+)
   AND A.DEVICE_NUMBER = C.DEVICE_NUMBER(+)
   
    
--移动号卡使用分析
select 
count(distinct a.device_number),
count(distinct case when a.user_dinner_desc not like '%加装%' then a.device_number end),
count(distinct b.device_number)
  FROM (SELECT USER_NO, DEVICE_NUMBER, CHANNEL_KIND, INNET_DATE,user_dinner_desc
          FROM DW.DW_V_USER_BASE_INFO_USER A
         WHERE ACCT_MONTH = '201412'
           AND TELE_TYPE = '2'
           AND IS_ONNET = '1') A,
 (SELECT *
          FROM TMP_MAJH_0328_02
         WHERE SUBSTR(BEGIN_DATE, 1, 4) <= '201412'
           AND (SUBSTR(END_DATE, 1, 4) > '201412' OR END_DATE IS NULL))b
           where A.DEVICE_NUMBER = b.DEVICE_NUMBER(+)


--匹配终端  社会渠道单卡
--沉淀所有插过卡的手机号
CREATE TABLE TMP_MAJH_TRM_0604_01 AS 
SELECT TO_CHAR(REG_DATE, 'YYYY') REG_DATE, DEVICE_NO
  FROM DW.DW_V_USER_TERMINAL_D A
 WHERE ACCT_MONTH = '201805'
   AND DAY_ID = '30'
 GROUP BY TO_CHAR(REG_DATE, 'YYYY'), DEVICE_NO;


--整体情况
SELECT COUNT(DISTINCT A.DEVICE_NUMBER),
       count(distinct case when a.user_dinner_desc not like '%加装%' then a.device_number end) 主卡,
       count(distinct case when a.user_dinner_desc like '%加装%' then a.device_number end) 副卡,
       COUNT(DISTINCT X.DEVICE_NO),
       count(distinct case when a.user_dinner_desc not like '%加装%' then X.DEVICE_NO end)匹配主卡,
       count(distinct case when a.user_dinner_desc  like '%加装%' then X.DEVICE_NO end)匹配副卡,
       COUNT(DISTINCT B.DEVICE_NO),
       count(distinct case when a.user_dinner_desc not like '%加装%' then B.DEVICE_NO end)新主卡,
       count(distinct case when a.user_dinner_desc  like '%加装%' then B.DEVICE_NO end)新副卡,
       COUNT(DISTINCT C.PHONE_NUMBER),
       count(distinct case when a.user_dinner_desc not like '%加装%' then C.PHONE_NUMBER end)匹配行货主卡,
       count(distinct case when a.user_dinner_desc like '%加装%' then C.PHONE_NUMBER end)匹配行货副卡,
       COUNT(DISTINCT D.MDN),
       count(distinct case when a.user_dinner_desc not like '%加装%' then D.MDN end)匹配窜货副卡,
       count(distinct case when a.user_dinner_desc like '%加装%' then D.MDN end)匹配窜货副卡
  FROM (SELECT USER_NO,
               DEVICE_NUMBER,
               CHANNEL_KIND,
               INNET_DATE,
               USER_DINNER_DESC
          FROM DW.DW_V_USER_BASE_INFO_USER A
         WHERE ACCT_MONTH = '201412'
           AND TELE_TYPE = '2'
           AND IS_ONNET = '1' 
           AND a.SALES_MODE is null
           AND TO_CHAR(INNET_DATE, 'YYYY') = '2014') A,
       (SELECT * FROM TMP_MAJH_TRM_0604_01 WHERE REG_DATE = '2014') X,
       (SELECT AREA_NO,
               CITY_NO,
               TERMINAL_CODE,
               TERMINAL_CORP,
               TERMINAL_MODEL,
               REG_DATE,
               ACCT_MONTH,
               DEVICE_NO
          FROM DW.DW_V_USER_TERMINAL_DEVICE_M
         WHERE ACCT_MONTH = '201804'
           AND TO_CHAR(REG_DATE, 'YYYY') = '2014') B,
       (SELECT MOBILE_NO,
               USED_DATE,
               OPERATE_DATE,
               SUGGEST_PRICE,
               PHONE_NUMBER,
               RESOURCE_KIND,
               TO_CHAR(IN_DATE, 'YYYYMMDD') IN_DATE
          FROM CRM_DSG.IR_MOBILE_USING_T@HBODS A --终端出入库信息表 
        ) C,
       TMP_MAJH_CUAN_0530_02 D
 WHERE A.DEVICE_NUMBER = B.DEVICE_NO(+)
   AND A.DEVICE_NUMBER = X.DEVICE_NO(+)
   AND A.DEVICE_NUMBER = C.PHONE_NUMBER(+)
   AND A.DEVICE_NUMBER = D.MDN(+)
   
--社会渠道单卡
SELECT COUNT(DISTINCT A.DEVICE_NUMBER),
       COUNT(DISTINCT X.DEVICE_NO),
       COUNT(DISTINCT B.DEVICE_NO),
       COUNT(DISTINCT C.PHONE_NUMBER),
       COUNT(DISTINCT D.MDN)
  FROM (SELECT USER_NO,
               DEVICE_NUMBER,
               CHANNEL_KIND,
               INNET_DATE,
               USER_DINNER_DESC
          FROM DW.DW_V_USER_BASE_INFO_USER A
         WHERE ACCT_MONTH = '201412'
           AND TELE_TYPE = '2'
           AND IS_ONNET = '1'
           AND CHANNEL_KIND = '002'
           AND a.SALES_MODE is null
           AND TO_CHAR(INNET_DATE, 'YYYY') = '2014') A,
       (SELECT * FROM TMP_MAJH_TRM_0604_01 WHERE REG_DATE = '2014') X,
       (SELECT AREA_NO,
               CITY_NO,
               TERMINAL_CODE,
               TERMINAL_CORP,
               TERMINAL_MODEL,
               REG_DATE,
               ACCT_MONTH,
               DEVICE_NO
          FROM DW.DW_V_USER_TERMINAL_DEVICE_M
         WHERE ACCT_MONTH = '201804'
           AND TO_CHAR(REG_DATE, 'YYYY') = '2014') B,
       (SELECT MOBILE_NO,
               USED_DATE,
               OPERATE_DATE,
               SUGGEST_PRICE,
               PHONE_NUMBER,
               RESOURCE_KIND,
               TO_CHAR(IN_DATE, 'YYYYMMDD') IN_DATE
          FROM CRM_DSG.IR_MOBILE_USING_T@HBODS A --终端出入库信息表 
        ) C,
       TMP_MAJH_CUAN_0530_02 D
 WHERE A.DEVICE_NUMBER = B.DEVICE_NO(+)
   AND A.DEVICE_NUMBER = X.DEVICE_NO(+)
   AND A.DEVICE_NUMBER = C.PHONE_NUMBER(+)
   AND A.DEVICE_NUMBER = D.MDN(+)
 
 
 --匹配终端  社会渠道合约
SELECT COUNT(DISTINCT A.DEVICE_NUMBER),
       COUNT(DISTINCT X.DEVICE_NO),
       COUNT(DISTINCT B.DEVICE_NO),
       COUNT(DISTINCT C.PHONE_NUMBER),
       COUNT(DISTINCT D.MDN)
  FROM (SELECT USER_NO,
               DEVICE_NUMBER,
               CHANNEL_KIND,
               INNET_DATE,
               USER_DINNER_DESC
          FROM DW.DW_V_USER_BASE_INFO_USER A
         WHERE ACCT_MONTH = '201412'
           AND TELE_TYPE = '2'
           AND IS_ONNET = '1'
           AND CHANNEL_KIND = '002' 
           AND TO_CHAR(INNET_DATE, 'YYYY') = '2014'
           AND a.SALES_MODE is not null) A,
       (SELECT * FROM TMP_MAJH_TRM_0604_01 WHERE REG_DATE = '2014') X,
       (SELECT AREA_NO,
               CITY_NO,
               TERMINAL_CODE,
               TERMINAL_CORP,
               TERMINAL_MODEL,
               REG_DATE,
               ACCT_MONTH,
               DEVICE_NO
          FROM DW.DW_V_USER_TERMINAL_DEVICE_M
         WHERE ACCT_MONTH = '201804'
           AND TO_CHAR(REG_DATE, 'YYYY') = '2014') B,
       (SELECT MOBILE_NO,
               USED_DATE,
               OPERATE_DATE,
               SUGGEST_PRICE,
               PHONE_NUMBER,
               RESOURCE_KIND,
               TO_CHAR(IN_DATE, 'YYYYMMDD') IN_DATE
          FROM CRM_DSG.IR_MOBILE_USING_T@HBODS A --终端出入库信息表 
        ) C,
       TMP_MAJH_CUAN_0530_02 D
 WHERE A.DEVICE_NUMBER = B.DEVICE_NO(+)
   AND A.DEVICE_NUMBER = X.DEVICE_NO(+)
   AND A.DEVICE_NUMBER = C.PHONE_NUMBER(+)
   AND A.DEVICE_NUMBER = D.MDN(+)
 
 
 
 --自有厅单卡
 SELECT COUNT(DISTINCT A.DEVICE_NUMBER),
       COUNT(DISTINCT X.DEVICE_NO),
       COUNT(DISTINCT B.DEVICE_NO),
       COUNT(DISTINCT C.PHONE_NUMBER),
       COUNT(DISTINCT D.MDN)
  FROM (SELECT USER_NO,
               DEVICE_NUMBER,
               CHANNEL_KIND,
               INNET_DATE,
               USER_DINNER_DESC
          FROM DW.DW_V_USER_BASE_INFO_USER A
         WHERE ACCT_MONTH = '201412'
           AND TELE_TYPE = '2'
           AND IS_ONNET = '1'
           AND CHANNEL_KIND = '001'
           AND a.SALES_MODE is null
           AND TO_CHAR(INNET_DATE, 'YYYY') = '2014') A,
       (SELECT * FROM TMP_MAJH_TRM_0604_01 WHERE REG_DATE = '2014') X,
       (SELECT AREA_NO,
               CITY_NO,
               TERMINAL_CODE,
               TERMINAL_CORP,
               TERMINAL_MODEL,
               REG_DATE,
               ACCT_MONTH,
               DEVICE_NO
          FROM DW.DW_V_USER_TERMINAL_DEVICE_M
         WHERE ACCT_MONTH = '201804'
           AND TO_CHAR(REG_DATE, 'YYYY') = '2014') B,
       (SELECT MOBILE_NO,
               USED_DATE,
               OPERATE_DATE,
               SUGGEST_PRICE,
               PHONE_NUMBER,
               RESOURCE_KIND,
               TO_CHAR(IN_DATE, 'YYYYMMDD') IN_DATE
          FROM CRM_DSG.IR_MOBILE_USING_T@HBODS A --终端出入库信息表 
        ) C,
       TMP_MAJH_CUAN_0530_02 D
 WHERE A.DEVICE_NUMBER = B.DEVICE_NO(+)
   AND A.DEVICE_NUMBER = X.DEVICE_NO(+)
   AND A.DEVICE_NUMBER = C.PHONE_NUMBER(+)
   AND A.DEVICE_NUMBER = D.MDN(+)
 
 
 
  --自有厅合约
 SELECT COUNT(DISTINCT A.DEVICE_NUMBER),
       COUNT(DISTINCT X.DEVICE_NO),
       COUNT(DISTINCT B.DEVICE_NO),
       COUNT(DISTINCT C.PHONE_NUMBER),
       COUNT(DISTINCT D.MDN)
  FROM (SELECT USER_NO,
               DEVICE_NUMBER,
               CHANNEL_KIND,
               INNET_DATE,
               USER_DINNER_DESC
          FROM DW.DW_V_USER_BASE_INFO_USER A
         WHERE ACCT_MONTH = '201412'
           AND TELE_TYPE = '2'
           AND IS_ONNET = '1'
           AND CHANNEL_KIND = '001' 
           AND TO_CHAR(INNET_DATE, 'YYYY') = '2014'
           and a.SALES_MODE is not null) A,
       (SELECT * FROM TMP_MAJH_TRM_0604_01 WHERE REG_DATE = '2014') X,
       (SELECT AREA_NO,
               CITY_NO,
               TERMINAL_CODE,
               TERMINAL_CORP,
               TERMINAL_MODEL,
               REG_DATE,
               ACCT_MONTH,
               DEVICE_NO
          FROM DW.DW_V_USER_TERMINAL_DEVICE_M
         WHERE ACCT_MONTH = '201804'
           AND TO_CHAR(REG_DATE, 'YYYY') = '2014') B,
       (SELECT MOBILE_NO,
               USED_DATE,
               OPERATE_DATE,
               SUGGEST_PRICE,
               PHONE_NUMBER,
               RESOURCE_KIND,
               TO_CHAR(IN_DATE, 'YYYYMMDD') IN_DATE
          FROM CRM_DSG.IR_MOBILE_USING_T@HBODS A --终端出入库信息表 
        ) C,
       TMP_MAJH_CUAN_0530_02 D
 WHERE A.DEVICE_NUMBER = B.DEVICE_NO(+)
   AND A.DEVICE_NUMBER = X.DEVICE_NO(+)
   AND A.DEVICE_NUMBER = C.PHONE_NUMBER(+)
   AND A.DEVICE_NUMBER = D.MDN(+)
 

--匹配终端占比前10品牌
SELECT a.TERMINAL_CORP, COUNT(DISTINCT B.DEVICE_NO)/count(distinct a.device_number)
  FROM (SELECT USER_NO,
               DEVICE_NUMBER,
               CHANNEL_KIND,
               INNET_DATE,
               USER_DINNER_DESC,
               a.TERMINAL_CORP
          FROM DW.DW_V_USER_BASE_INFO_USER A
         WHERE ACCT_MONTH = '201412'
           AND TELE_TYPE = '2'
          --AND IS_ONNET = '1'
           AND TO_CHAR(INNET_DATE, 'YYYY') = '2014') A,
       (SELECT * FROM TMP_MAJH_TRM_0604_01 WHERE REG_DATE = '2014') B
 WHERE A.DEVICE_NUMBER = B.DEVICE_NO(+)
 group by a.TERMINAL_CORP


--在网用户匹配终端分析
--套餐、行、窜货
SELECT COUNT(DISTINCT A.DEVICE_NUMBER),
       COUNT(DISTINCT CASE
               WHEN A.SALES_MODE IS NULL THEN
                A.DEVICE_NUMBER
             END),
       COUNT(DISTINCT CASE
               WHEN A.SALES_MODE IS NOT NULL THEN
                A.DEVICE_NUMBER
             END),
       COUNT(DISTINCT B.MOBILE_NO),
       COUNT(DISTINCT CASE
               WHEN B.MOBILE_NO IS NULL THEN
                C.TERMKEY
             END),
       COUNT(DISTINCT CASE
               WHEN A.SALES_MODE IS NULL then
                B.MOBILE_NO
             END),
       COUNT(DISTINCT CASE
               WHEN A.SALES_MODE IS NULL AND B.MOBILE_NO IS NULL THEN
                C.TERMKEY
             END),
       COUNT(DISTINCT CASE
               WHEN A.SALES_MODE IS NOT NULL THEN
                B.MOBILE_NO
             END),
       COUNT(DISTINCT CASE
               WHEN A.SALES_MODE IS NOT NULL AND B.MOBILE_NO IS NULL THEN
                C.TERMKEY
             END)
  from (SELECT USER_NO,
               DEVICE_NUMBER,
               CHANNEL_KIND,
               INNET_DATE,
               USER_DINNER_DESC,
               IS_BUNDLE,
               SALES_MODE,
               TERMINAL_CODE
          FROM DW.DW_V_USER_BASE_INFO_USER A
         WHERE ACCT_MONTH = '201806'
           AND TELE_TYPE = '2'
           AND IS_ONNET = '1') A,
       (SELECT MOBILE_NO,
               USED_DATE,
               OPERATE_DATE,
               SUGGEST_PRICE,
               PHONE_NUMBER,
               RESOURCE_KIND,
               TO_CHAR(IN_DATE, 'YYYYMMDD') IN_DATE
          FROM CRM_DSG.IR_MOBILE_USING_T@HBODS A --终端出入库信息表 
        ) B,
       TMP_MAJH_CUAN_0530_02 C
 WHERE A.TERMINAL_CODE = B.MOBILE_NO(+)
   AND A.TERMINAL_CODE = C.TERMKEY(+);


--品牌、机型
SELECT a.TERMINAL_CORP, count(*)
  FROM DW.DW_V_USER_BASE_INFO_USER A
 WHERE ACCT_MONTH = '201512'
   AND TELE_TYPE = '2'
   AND IS_ONNET = '1'
 group by a.TERMINAL_CORP
having count(*) > 1



--终端使用时长
SELECT a.STATUS_EVDO,COUNT(DISTINCT A.TERMINAL_CODE),
       COUNT(DISTINCT CASE
               WHEN A.DEVICE_NO = B.DEVICE_NO THEN
                A.TERMINAL_CODE
             END)
  FROM (SELECT *
          FROM DW.DW_V_USER_TERMINAL_DEVICE_M A
         WHERE ACCT_MONTH = '201804'
           AND TO_CHAR(REG_DATE, 'YYYYMM') = '201406') A,
       (SELECT *
           FROM DW.DW_V_USER_TERMINAL_USER_M A
          WHERE ACCT_MONTH = '201804'
          and TO_CHAR(REG_DATE, 'YYYYMM') <= '201606') B
 WHERE A.TERMINAL_CODE = b.TERMINAL_CODE(+)
 group by a.STATUS_EVDO



--终端在用率分析
SELECT C.AREA_DESC,
       COUNT(DISTINCT A.TERMINAL_CODE),
       COUNT(DISTINCT CASE
               WHEN A.DEVICE_NO = B.DEVICE_NO THEN
                A.TERMINAL_CODE
             END)
  FROM (SELECT *
          FROM DW.DW_V_USER_TERMINAL_DEVICE_M A
         WHERE ACCT_MONTH = '201804'
           AND TO_CHAR(REG_DATE, 'YYYYMM') = '201506') A,
       (SELECT *
          FROM DW.DW_V_USER_TERMINAL_USER_M A
         WHERE ACCT_MONTH = '201804'
           AND TO_CHAR(REG_DATE, 'YYYYMM') >= '201509') B,
       DIM.DIM_AREA_NO C
 WHERE A.TERMINAL_CODE = B.TERMINAL_CODE(+)
   AND FUNC_GET_XIONGAN_AREA_NO(A.AREA_NO, A.CITY_NO) = C.AREA_NO
 GROUP BY C.AREA_DESC, C.IDX_NO
 ORDER BY C.IDX_NO;


--分品牌
SELECT A.TERMINAL_CORP,
       COUNT(DISTINCT A.TERMINAL_CODE),
       COUNT(DISTINCT CASE
               WHEN A.DEVICE_NO = B.DEVICE_NO THEN
                A.TERMINAL_CODE
             END)
  FROM (SELECT *
          FROM DW.DW_V_USER_TERMINAL_DEVICE_M A
         WHERE ACCT_MONTH = '201804'
           AND TO_CHAR(REG_DATE, 'YYYYMM') = '201606') A,
       (SELECT *
          FROM DW.DW_V_USER_TERMINAL_USER_M A
         WHERE ACCT_MONTH = '201609') B 
 WHERE A.TERMINAL_CODE = B.TERMINAL_CODE(+) 
 GROUP BY A.TERMINAL_CORP
 
 
  --分行窜货
  SELECT  
       COUNT(DISTINCT CASE WHEN B.MOBILE_NO IS NOT NULL THEN A.TERMINAL_CODE END),
       
       COUNT(DISTINCT CASE
               WHEN A.DEVICE_NO = B.DEVICE_NO AND B.MOBILE_NO IS NOT NULL THEN
                A.TERMINAL_CODE
             END),
       COUNT(DISTINCT CASE WHEN C.TERMKEY IS NOT NULL and B.MOBILE_NO IS NULL THEN A.TERMINAL_CODE END),
       COUNT(DISTINCT CASE
               WHEN A.DEVICE_NO = B.DEVICE_NO AND C.TERMKEY IS NOT NULL and B.MOBILE_NO IS NULL  THEN
                A.TERMINAL_CODE
             END)
  FROM (SELECT *
          FROM DW.DW_V_USER_TERMINAL_DEVICE_M A
         WHERE ACCT_MONTH = '201804'
           AND TO_CHAR(REG_DATE, 'YYYYMM') = '201606') A,
       (SELECT *
          FROM DW.DW_V_USER_TERMINAL_USER_M A
         WHERE ACCT_MONTH = '201609') B，
                (SELECT MOBILE_NO,
               USED_DATE,
               OPERATE_DATE,
               SUGGEST_PRICE,
               PHONE_NUMBER,
               RESOURCE_KIND,
               TO_CHAR(IN_DATE, 'YYYYMMDD') IN_DATE
          FROM CRM_DSG.IR_MOBILE_USING_T@HBODS A --终端出入库信息表 
        ) B,
       TMP_MAJH_CUAN_0530_02 C
 WHERE A.TERMINAL_CODE = B.TERMINAL_CODE(+) 
 AND  A.TERMINAL_CODE = B.MOBILE_NO(+)
 AND A.TERMINAL_CODE = C.TERMKEY(+) ;
 
 
 
 --重复注册
/*  CREATE TABLE TMP_MAJH_T_0605_01 AS 
 SELECT TERMINAL_CODE
   FROM DW.DW_V_USER_TERMINAL_D
  WHERE ACCT_MONTH = '201806'
    AND DAY_ID = '03'
    AND TO_CHAR(REG_DATE, 'YYYY') = '2015'
  GROUP BY TERMINAL_CODE
 HAVING COUNT(*) > 1;
        */
--按地市     
SELECT C.AREA_DESC,
       COUNT(*),
       COUNT(DISTINCT A.DEVICE_NO)
  FROM (SELECT AREA_NO, DEVICE_NO, TERMINAL_CODE, CITY_NO
          FROM DW.DW_V_USER_TERMINAL_DEVICE_M
         WHERE ACCT_MONTH = '201804'
           AND TO_CHAR(REG_DATE, 'YYYY') = '2014') A,
       DIM.DIM_AREA_NO C
 WHERE FUNC_GET_XIONGAN_AREA_NO(A.AREA_NO, A.CITY_NO) = C.AREA_NO(+)
 GROUP BY C.AREA_DESC, C.IDX_NO
 ORDER BY C.IDX_NO
 
 --按品牌  
SELECT TERMINAL_CORP, COUNT(*), COUNT(DISTINCT A.DEVICE_NO)
  FROM (SELECT AREA_NO, DEVICE_NO, TERMINAL_CODE, CITY_NO, TERMINAL_CORP
          FROM DW.DW_V_USER_TERMINAL_DEVICE_M
         WHERE ACCT_MONTH = '201804'
           AND TO_CHAR(REG_DATE, 'YYYY') = '2014') A
 GROUP BY TERMINAL_CORP
 
 
 --2、3、4G用户分布
 SELECT COUNT(CASE
                WHEN A.IS_4G = '1' AND B.STATUS_SMART = '1' THEN
                 A.USER_NO
              END),
        COUNT(CASE
                WHEN A.IS_4G = '0' AND B.STATUS_EVDO = '2' THEN
                 A.USER_NO
              END)
   FROM (SELECT USER_NO, IS_4G
           FROM DW.DW_V_USER_BASE_INFO_USER A
          WHERE ACCT_MONTH = '201805'
            AND TELE_TYPE = '2'
            AND (is_acct='1' or is_acct_ocs='1')) A,
        (SELECT USER_NO, B.STATUS_EVDO, B.STATUS_SMART
           FROM DW.DW_V_USER_TERMINAL_USER_M B
          WHERE ACCT_MONTH = '201805') B
  WHERE A.USER_NO = B.USER_NO(+)



--截止五月份
--总出账：14718085
--无线座机：306205
--无线网卡：7073
--4G智能机：11067482






