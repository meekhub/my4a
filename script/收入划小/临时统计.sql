create table tmp_majh_huaxiao_channel
(
area_desc varchar2(20),
city_desc varchar2(50),
channel_no varchar2(20),
channel_no_desc varchar2(300),
zhiju_type varchar2(30),
zhiju_name varchar2(290)
)


create table tmp_majh_huaxiao_xq
(
area_desc varchar2(20),
city_desc varchar2(50),
xiaoqu_no varchar2(20),
xiaoqul_no_desc varchar2(300),
zhiju_type varchar2(30),
zhiju_name varchar2(290)
);



select * from ALLDMCODE.dmcode_xiaoqu_info where xiaoqu_no='xq00964753588391';


--融合用户归属
create table tmp_majh_rh_user as 
SELECT a.user_no,a.device_number,a.TELE_TYPE,a.bundle_id,e.xiaoqu_no,e.zhiju_type,e.zhiju_name,is_onnet
  FROM (SELECT area_no,city_no,
               USER_NO,
               DEVICE_NUMBER,
               CHANNEL_NO,
               CHANNEL_NO_DESC,
               IS_KD_BUNDLE,
               TELE_TYPE,
               nvl(BUNDLE_ID_ALLOWANCE,bundle_id) as bundle_id,
               is_onnet
          FROM DW.DW_V_USER_BASE_INFO_USER T
         WHERE ACCT_MONTH = '201708'
           AND AREA_NO = '181'
           --AND CHANNEL_TYPE LIKE '11%'
           --AND IS_ONNET = '1'
           and tele_type <> '2'
           AND IS_KD_BUNDLE <> '0') A,
       (SELECT USER_NO,
               T.GRADE_0 || '->' || T.GRADE_1 || '->' || T.GRADE_2 || '->' ||
               T.GRADE_3 || '->' || T.GRADE_4 STDADDR_NAME
          FROM DW.DW_V_USER_ADSL_EIGHT_M T
         WHERE ACCT_MONTH = '201708'
           AND T.AREA_NO = '181'
           AND USER_NO IS NOT NULL) B,
       (SELECT * FROM ALLDMCODE.DMCODE_XIAOQU_STD_ADDR) C,
       TMP_MAJH_HUAXIAO_XQ E
 WHERE A.USER_NO = B.USER_NO(+)
   AND B.STDADDR_NAME = C.STDADDR_NAME(+)
   AND C.XIAOQU_NO = E.XIAOQU_NO(+);


--全网用户
create table tmp_majh_sub_01 as 
    SELECT A.AREA_NO,
           A.CITY_NO,
           A.USER_NO,
           A.TELE_TYPE,
           A.IS_NEW,
           A.IS_ONNET,
           A.DEVICE_NUMBER,
           A.CHANNEL_NO,
           A.CHANNEL_NO_DESC, 
           --编码
           CASE
             WHEN D1.ZHIJU_TYPE = '自营厅' THEN
              '1'
             ELSE
              '0'
           END SUB_NO_1,
           CASE
             WHEN D2.ZHIJU_TYPE = '商圈支局' THEN
              '1'
             ELSE
              '0'
           END SUB_NO_2,
           CASE
             WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
                  D3.ZHIJU_TYPE = '社区支局' AND D1.ZHIJU_TYPE IS NULL AND
                  D2.ZHIJU_TYPE IS NULL THEN
              '1'
             WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2' AND
                  E1.ZHIJU_TYPE = '社区支局' THEN
              '1'
             WHEN F.ZHIJU_TYPE = '社区支局' THEN
              '1'
             ELSE
              '0'
           END SUB_NO_3,
           CASE
             WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
                  D4.ZHIJU_TYPE = '农村支局' AND D1.ZHIJU_TYPE IS NULL THEN
              '1'
             WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2' AND
                  E2.ZHIJU_TYPE = '农村支局' THEN
              '1'
             WHEN F.ZHIJU_TYPE = '农村支局' THEN
              '1'
             ELSE
              '0'
           END SUB_NO_4,
           --支局名称
           D1.ZHIJU_NAME SUB_NAME_1,
           D2.ZHIJU_NAME SUB_NAME_2,
           CASE
             WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
                  D3.ZHIJU_TYPE = '社区支局' AND D1.ZHIJU_TYPE IS NULL AND
                  D2.ZHIJU_TYPE IS NULL THEN
              D3.ZHIJU_NAME
             WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2' AND
                  E1.ZHIJU_TYPE = '社区支局' THEN
              E1.ZHIJU_NAME
             WHEN F.ZHIJU_TYPE = '社区支局' THEN
              F.ZHIJU_NAME
           END SUB_NAME_3,
           CASE
             WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
                  D4.ZHIJU_TYPE = '农村支局' AND D1.ZHIJU_TYPE IS NULL THEN
              D4.ZHIJU_NAME
             WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2' AND
                  E2.ZHIJU_TYPE = '农村支局' THEN
              E2.ZHIJU_NAME
             WHEN F.ZHIJU_TYPE = '农村支局' THEN
              F.ZHIJU_NAME
           END SUB_NAME_4,
           C.XIAOQU_NO,
           (TOTAL_FEE_OCS + TOTAL_FEE) TOTAL_FEE,
           TO_CHAR(INNET_DATE, 'YYYYMMDD') INNET_DATE
      FROM (SELECT AREA_NO,
                   CITY_NO,
                   USER_NO,
                   DEVICE_NUMBER,
                   CHANNEL_NO,
                   CHANNEL_NO_DESC,
                   IS_KD_BUNDLE,
                   TELE_TYPE,
                   nvl(BUNDLE_ID_ALLOWANCE,bundle_id) as bundle_id,
                   INNET_DATE,
                   TOTAL_FEE_OCS,
                   TOTAL_FEE,
                   IS_NEW,
                   IS_ONNET
              FROM DW.DW_V_USER_BASE_INFO_USER T
             WHERE ACCT_MONTH = '201708'
               AND AREA_NO = '181'
            --AND CHANNEL_TYPE LIKE '11%'
            --AND IS_ONNET = '1'
            ) A,
           (SELECT USER_NO,
                   T.GRADE_0 || '->' || T.GRADE_1 || '->' || T.GRADE_2 || '->' ||
                   T.GRADE_3 || '->' || T.GRADE_4 STDADDR_NAME
              FROM DW.DW_V_USER_ADSL_EIGHT_M T
             WHERE ACCT_MONTH = '201708'
               AND T.AREA_NO = '181'
               AND USER_NO IS NOT NULL) B,
           (SELECT * FROM ALLDMCODE.DMCODE_XIAOQU_STD_ADDR) C,
           (SELECT *
              FROM TMP_MAJH_HUAXIAO_CHANNEL
             WHERE ZHIJU_TYPE = '自营厅') D1,
           (SELECT *
              FROM TMP_MAJH_HUAXIAO_CHANNEL
             WHERE ZHIJU_TYPE = '商圈支局') D2,
           (SELECT *
              FROM TMP_MAJH_HUAXIAO_CHANNEL
             WHERE ZHIJU_TYPE = '社区支局') D3,
           (SELECT *
              FROM TMP_MAJH_HUAXIAO_CHANNEL
             WHERE ZHIJU_TYPE = '农村支局') D4,
           (SELECT * FROM TMP_MAJH_HUAXIAO_XQ WHERE ZHIJU_TYPE = '社区支局') E1,
           (SELECT * FROM TMP_MAJH_HUAXIAO_XQ WHERE ZHIJU_TYPE = '农村支局') E2,
           (SELECT *
              FROM (SELECT A.*,
                           ROW_NUMBER() OVER(PARTITION BY BUNDLE_ID ORDER BY(CASE
                             WHEN TELE_TYPE IN
                                  ('4',
                                   '26') THEN
                              1
                             WHEN TELE_TYPE = '72' THEN
                              2
                             ELSE
                              3
                           END)) RN
                      FROM TMP_MAJH_RH_USER A)
             WHERE RN = 1) F
     WHERE A.USER_NO = B.USER_NO(+)
       AND A.CHANNEL_NO = D1.CHANNEL_NO(+)
       AND A.CHANNEL_NO = D2.CHANNEL_NO(+)
       AND A.CHANNEL_NO = D3.CHANNEL_NO(+)
       AND A.CHANNEL_NO = D4.CHANNEL_NO(+)
       AND B.STDADDR_NAME = C.STDADDR_NAME(+)
       AND C.XIAOQU_NO = E1.XIAOQU_NO(+)
       AND C.XIAOQU_NO = E2.XIAOQU_NO(+)
       AND A.BUNDLE_ID = F.BUNDLE_ID(+)


--汇总
SELECT 
--全量收入
ROUND(SUM(CASE WHEN SUB_NO_1='1' THEN TOTAL_FEE ELSE 0 END)/10000,2) "自营厅",
ROUND(SUM(CASE WHEN SUB_NO_2='1' THEN TOTAL_FEE ELSE 0 END)/10000,2) "商圈支局",
ROUND(SUM(CASE WHEN SUB_NO_3='1' THEN TOTAL_FEE ELSE 0 END)/10000,2) "社区支局",
ROUND(SUM(CASE WHEN SUB_NO_4='1' THEN TOTAL_FEE ELSE 0 END)/10000,2) "农村支局",

--增量收入
ROUND(SUM(CASE WHEN SUB_NO_1='1' AND SUBSTR(INNET_DATE,1,4)='2017' THEN TOTAL_FEE ELSE 0 END)/10000,2) "自营厅",
ROUND(SUM(CASE WHEN SUB_NO_2='1' AND SUBSTR(INNET_DATE,1,4)='2017' THEN TOTAL_FEE ELSE 0 END)/10000,2) "商圈支局",
ROUND(SUM(CASE WHEN SUB_NO_3='1' AND SUBSTR(INNET_DATE,1,4)='2017' THEN TOTAL_FEE ELSE 0 END)/10000,2) "社区支局",
ROUND(SUM(CASE WHEN SUB_NO_4='1' AND SUBSTR(INNET_DATE,1,4)='2017' THEN TOTAL_FEE ELSE 0 END)/10000,2) "农村支局",

--当月发展
SUM(CASE WHEN SUB_NO_1='1' AND IS_NEW='1' THEN 1 ELSE 0 END) "自营厅",
SUM(CASE WHEN SUB_NO_2='1' AND IS_NEW='1' THEN 1 ELSE 0 END)"商圈支局",
SUM(CASE WHEN SUB_NO_3='1' AND IS_NEW='1' THEN 1 ELSE 0 END) "社区支局",
SUM(CASE WHEN SUB_NO_4='1' AND IS_NEW='1' THEN 1 ELSE 0 END) "农村支局"
 FROM TMP_MAJH_SUB_01 T WHERE T.TELE_TYPE='2'


SELECT 
X.CITY_DESC 区县,T.SUB_NAME_1,
----------C网
--全量收入
SUM(CASE WHEN SUB_NO_1='1' AND TELE_TYPE='2' THEN TOTAL_FEE ELSE 0 END) C_TOTAL_FEE, 

--增量收入
SUM(CASE WHEN SUB_NO_1='1' AND SUBSTR(INNET_DATE,1,4)='2017' AND TELE_TYPE='2' THEN TOTAL_FEE ELSE 0 END) C_NEW_FEE, 

--当月发展
SUM(CASE WHEN SUB_NO_1='1' AND IS_NEW='1' AND TELE_TYPE='2' THEN 1 ELSE 0 END) C_DEV_USERS, 

--------固网
--全量收入
SUM(CASE WHEN SUB_NO_1='1' AND TELE_TYPE<>'2' THEN TOTAL_FEE ELSE 0 END) G_TOTAL_FEE, 

--增量收入
SUM(CASE WHEN SUB_NO_1='1' AND SUBSTR(INNET_DATE,1,4)='2017' AND TELE_TYPE<>'2' THEN TOTAL_FEE ELSE 0 END) G_NEW_FEE, 

--当月发展
SUM(CASE WHEN SUB_NO_1='1' AND IS_NEW='1' AND TELE_TYPE<>'2' THEN 1 ELSE 0 END) G_DEV_USERS
 FROM TMP_MAJH_SUB_01 T,DIM.DIM_CITY_NO X WHERE SUB_NAME_1 IS NOT NULL 
 AND T.CITY_NO=X.CITY_NO
 GROUP BY X.CITY_DESC,T.SUB_NAME_1
