--融合用户
INSERT INTO TEMP_SJZX_WH_20170928_01
  SELECT a.user_no,
         a.device_number,
         a.TELE_TYPE,
         a.bundle_id,
         e.xiaoqu_no,
         e.zhiju_type,
         e.zhiju_name,
         A.IS_ONNET,
         '201708' ACCT_MONTH
    FROM (SELECT area_no,
                 city_no,
                 USER_NO,
                 DEVICE_NUMBER,
                 CHANNEL_NO,
                 CHANNEL_NO_DESC,
                 IS_KD_BUNDLE,
                 TELE_TYPE,
                 nvl(BUNDLE_ID_ALLOWANCE, bundle_id) as bundle_id,
                 is_onnet
            FROM DW.DW_V_USER_BASE_INFO_USER T
           WHERE ACCT_MONTH = '201708'
             AND AREA_NO = '181'
             and tele_type <> '2'
             AND NVL(IS_KD_BUNDLE, '0') <> '0') A,
         (SELECT USER_NO,
                 T.GRADE_0 || '->' || T.GRADE_1 || '->' || T.GRADE_2 || '->' ||
                 T.GRADE_3 || '->' || T.GRADE_4 STDADDR_NAME
            FROM DW.DW_V_USER_ADSL_EIGHT_M T
           WHERE ACCT_MONTH = '201708'
             AND T.AREA_NO = '181'
             AND USER_NO IS NOT NULL) B,
         (SELECT * FROM ALLDMCODE.DMCODE_XIAOQU_STD_ADDR) C,
         TEMP_USER.TMP_MAJH_HUAXIAO_XQ E
   WHERE A.USER_NO = B.USER_NO(+)
     AND B.STDADDR_NAME = C.STDADDR_NAME(+)
     AND C.XIAOQU_NO = E.XIAOQU_NO(+);


--全网用户
CREATE TABLE TEMP_SJZX_WH_20170928_03 AS
    SELECT '201708' ACCT_MONTH,
           A.AREA_NO,
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
             WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
                  G.XIAOQU_NO IS NOT NULL AND G1.ZHIJU_TYPE = '社区支局' THEN
              '1'
             ELSE
              '0'
           END SUB_NO_3,
           CASE
             WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
                  D4.ZHIJU_TYPE = '农村支局' AND D1.ZHIJU_TYPE IS NULL AND
                  D2.ZHIJU_TYPE IS NULL THEN
              '1'
             WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2' AND
                  E2.ZHIJU_TYPE = '农村支局' THEN
              '1'
             WHEN F.ZHIJU_TYPE = '农村支局' THEN
              '1'
             WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
                  G.XIAOQU_NO IS NOT NULL AND G2.ZHIJU_TYPE = '农村支局' THEN
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
             WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
                  G.XIAOQU_NO IS NOT NULL AND G1.ZHIJU_TYPE = '社区支局' THEN
              G1.ZHIJU_NAME
           END SUB_NAME_3,
           CASE
             WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
                  D4.ZHIJU_TYPE = '农村支局' AND D1.ZHIJU_TYPE IS NULL AND
                  D2.ZHIJU_TYPE IS NULL THEN
              D4.ZHIJU_NAME
             WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2' AND
                  E2.ZHIJU_TYPE = '农村支局' THEN
              E2.ZHIJU_NAME
             WHEN F.ZHIJU_TYPE = '农村支局' THEN
              F.ZHIJU_NAME
             WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
                  G.XIAOQU_NO IS NOT NULL AND G2.ZHIJU_TYPE = '农村支局' THEN
              G2.ZHIJU_NAME
           END SUB_NAME_4,
           CASE
             WHEN NVL(A.IS_KD_BUNDLE, '0') = '0' AND A.TELE_TYPE <> '2' THEN
              C.XIAOQU_NO
             WHEN NVL(A.IS_KD_BUNDLE, '0') <> '0' THEN
              F.XIAOQU_NO
             WHEN NVL(A.IS_KD_BUNDLE, '0') = '0' AND A.TELE_TYPE = '2' THEN
              G.XIAOQU_NO
           END XIAOQU_NO,
           (A.PRICE_FEE_OCS + A.PRICE_FEE) PRICE_FEE,
           TO_CHAR(A.INNET_DATE, 'YYYYMMDD') INNET_DATE
      FROM (SELECT AREA_NO,
                   CITY_NO,
                   USER_NO,
                   DEVICE_NUMBER,
                   CHANNEL_NO,
                   CHANNEL_NO_DESC,
                   IS_KD_BUNDLE,
                   TELE_TYPE,
                   NVL(T.BUNDLE_ID_ALLOWANCE, T.BUNDLE_ID) BUNDLE_ID,
                   INNET_DATE,
                   TOTAL_FEE_OCS,
                   TOTAL_FEE,
                   IS_NEW,
                   IS_ONNET,
                   PRICE_FEE,
                   PRICE_FEE_OCS,
                   xiaoqu_no
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
              FROM temp_user.TMP_MAJH_HUAXIAO_CHANNEL
             WHERE ZHIJU_TYPE = '自营厅') D1,
           (SELECT *
              FROM temp_user.TMP_MAJH_HUAXIAO_CHANNEL
             WHERE ZHIJU_TYPE = '商圈支局') D2,
           (SELECT *
              FROM temp_user.TMP_MAJH_HUAXIAO_CHANNEL
             WHERE ZHIJU_TYPE = '社区支局') D3,
           (SELECT *
              FROM temp_user.TMP_MAJH_HUAXIAO_CHANNEL
             WHERE ZHIJU_TYPE = '农村支局') D4,
           (SELECT *
              FROM temp_user.TMP_MAJH_HUAXIAO_XQ
             WHERE ZHIJU_TYPE = '社区支局') E1,
           (SELECT *
              FROM temp_user.TMP_MAJH_HUAXIAO_XQ
             WHERE ZHIJU_TYPE = '农村支局') E2,
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
                      FROM TEMP_SJZX_WH_20170928_01 A
                     WHERE A.ACCT_MONTH = '201708')
             WHERE RN = 1) F,
           (SELECT *
              FROM TEMP_SJZX_WH_20170928_02 G
             WHERE G.ACCT_MONTH = '201707') G,
           (SELECT *
              FROM temp_user.TMP_MAJH_HUAXIAO_XQ
             WHERE ZHIJU_TYPE = '社区支局') G1,
           (SELECT *
              FROM temp_user.TMP_MAJH_HUAXIAO_XQ
             WHERE ZHIJU_TYPE = '农村支局') G2
     WHERE A.USER_NO = B.USER_NO(+)
       AND A.CHANNEL_NO = D1.CHANNEL_NO(+)
       AND A.CHANNEL_NO = D2.CHANNEL_NO(+)
       AND A.CHANNEL_NO = D3.CHANNEL_NO(+)
       AND A.CHANNEL_NO = D4.CHANNEL_NO(+)
       AND B.STDADDR_NAME = C.STDADDR_NAME(+)
       AND C.XIAOQU_NO = E1.XIAOQU_NO(+)
       AND C.XIAOQU_NO = E2.XIAOQU_NO(+)
       AND A.BUNDLE_ID = F.BUNDLE_ID(+)
       AND A.USER_NO = G.USER_NO(+)
       AND G.XIAOQU_NO = G1.XIAOQU_NO(+)
       AND G.XIAOQU_NO = G2.XIAOQU_NO(+);


----------------------------------------------------------------------------------
SELECT TELE_TYPE 业务类型,
       CITY_DESC 区县,
       SUB_NAME_1 自营厅,
       SUB_NAME_2 商圈,
       SUB_NAME_3 社区,
       SUB_NAME_4 农村,
       SUM(DEV_NUM) 新发展用户8月,
       SUM(ALL_INCOME) 全量出账收入8月,
       SUM(NEW_INCOME) 当年新发展用户出账收入8月
  FROM (select CASE
                 WHEN A.TELE_TYPE = '2' THEN
                  '移动'
                 ELSE
                  '固网'
               END TELE_TYPE,
               B.CITY_DESC,
               A.SUB_NAME_1,
               A.SUB_NAME_2,
               A.SUB_NAME_3,
               A.SUB_NAME_4,
               COUNT(DISTINCT CASE
                       WHEN A.IS_NEW = '1' THEN
                        A.USER_NO
                     END) DEV_NUM,
               SUM(A.PRICE_FEE) ALL_INCOME,
               0 NEW_INCOME
          from temp_sjzx_wh_20170928_03 A, DIM.DIM_CITY_NO B
         WHERE A.CITY_NO = B.CITY_NO(+)
         GROUP BY CASE
                    WHEN A.TELE_TYPE = '2' THEN
                     '移动'
                    ELSE
                     '固网'
                  END,
                  B.CITY_DESC,
                  A.SUB_NAME_1,
                  A.SUB_NAME_2,
                  A.SUB_NAME_3,
                  A.SUB_NAME_4
        UNION ALL
        select CASE
                 WHEN A.TELE_TYPE = '2' THEN
                  '移动'
                 ELSE
                  '固网'
               END,
               B.CITY_DESC,
               A.SUB_NAME_1,
               A.SUB_NAME_2,
               A.SUB_NAME_3,
               A.SUB_NAME_4,
               0,
               0,
               SUM(C.PRICE_FEE + C.PRICE_FEE_OCS)
          from temp_sjzx_wh_20170928_03 A,
               DIM.DIM_CITY_NO B,
               (SELECT *
                  FROM SJZX_V_USER_BASE_INFO_USER C
                 WHERE C.ACCT_MONTH = '201708'
                   AND C.AREA_NO = '181') C
         WHERE A.CITY_NO = B.CITY_NO(+)
           AND A.USER_NO = C.USER_NO
         GROUP BY CASE
                    WHEN A.TELE_TYPE = '2' THEN
                     '移动'
                    ELSE
                     '固网'
                  END,
                  B.CITY_DESC,
                  A.SUB_NAME_1,
                  A.SUB_NAME_2,
                  A.SUB_NAME_3,
                  A.SUB_NAME_4)
 GROUP BY TELE_TYPE,
          CITY_DESC,
          SUB_NAME_1,
          SUB_NAME_2,
          SUB_NAME_3,
          SUB_NAME_4
