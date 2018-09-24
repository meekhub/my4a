--------------------------发展积分扣罚
SELECT V_MONTH,
       C1.AREA_NO,
       A.CITY_NO,
       '发展类积分扣罚',
       D.AGENT_ID,
       D.AGENT_NAME,
       A.CHANNEL_NO,
       SUM(CASE
             WHEN A.TELE_TYPE = '2' AND A.IS_KD_BUNDLE = '0' AND
                  A.USER_DINNER_DESC NOT LIKE '%加装%' THEN
              -1 * NVL(C.LOW_VALUE, 0)
             WHEN A.TELE_TYPE = '2' AND A.IS_KD_BUNDLE = '0' AND
                  A.USER_DINNER_DESC LIKE '%加装%' THEN
              -1 * 10
             WHEN A.TELE_TYPE = '2' AND A.IS_KD_BUNDLE <> '0' AND
                  A.USER_DINNER_DESC NOT LIKE '%加装%' THEN
              -1 * NVL(C.LOW_VALUE, 0)
             WHEN A.TELE_TYPE IN ('4', '26') AND
                  A.IS_KD_BUNDLE IN ('0', '03', '031', '05', '051') THEN
              -1 * 60
             WHEN A.TELE_TYPE = '72' AND A.IS_KD_BUNDLE IN ('0', '03', '031') THEN
              -1 * 10
             ELSE
              0
           END) --扣罚积分 
  FROM (SELECT *
          FROM DW.DW_V_USER_BASE_INFO_USER A
         WHERE ACCT_MONTH =
               TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH, 'YYYYMM'), -6), 'YYYYMM')
           AND AREA_NO = C1.AREA_NO
           AND CHANNEL_TYPE LIKE '11%'
           AND IS_NEW = '1'
           AND (TELE_TYPE = '2' OR TELE_TYPE = '72' OR
               TELE_TYPE IN ('4', '26') AND
               INNET_METHOD IN ('1', '2', '4', '5', '15'))) A,
       
       (SELECT *
          FROM DW.DW_V_USER_BASE_INFO_USER B
         WHERE B.ACCT_MONTH = V_MONTH
           AND B.AREA_NO = C1.AREA_NO
           AND (B.LOGOUT_DATE IS NOT NULL OR
               B.USER_STATUS = '4' AND
               LAST_DAY(TO_DATE(V_MONTH, 'YYYYMM')) -
               TO_DATE(TO_CHAR(B.RECENT_STOP_DATE, 'YYYYMMDD'), 'YYYYMMDD') >= 60)) B, --第7个月已经离网或欠停超过60天的用户
       SJZX_WH_DIM_USER_DINNER C,
       (SELECT DISTINCT AGENT_ID, AGENT_NAME, CHANNEL_NO
          FROM RPT_HBTELE.DM_BUSI_CHANNEL_BUILD
         WHERE ACCT_MONTH = V_MONTH
         and area_no=c1.area_no) D
 WHERE A.USER_NO = B.USER_NO
   AND A.USER_DINNER = C.USER_DINNER(+)
   AND A.CHANNEL_NO = D.CHANNEL_NO(+)
 GROUP BY A.CITY_NO,
          '发展类积分扣罚',
          D.AGENT_ID,
          D.AGENT_NAME,
          A.CHANNEL_NO;

-----------------------------套餐升档积分扣罚
  SELECT A.ACCT_MONTH,
         A.AREA_NO,
         A.CITY_NO,
         '维系类积分扣罚',
         E.AGENT_ID,
         E.AGENT_NAME,
         A.CHANNEL_NO,
         SUM(CASE
               WHEN NVL(D.LOW_VALUE, 0) - NVL(C.LOW_VALUE, 0) < 0 THEN
                -1 * A.JIFEN
               ELSE
                0
             END)
    FROM (SELECT *
            FROM INTEGRAL_SYS_WEIXI_JF_DETAIL A ---套餐升档积分明细表
           WHERE A.ACCT_MONTH =
                 TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH, 'YYYYMM'), -6),
                         'YYYYMM')
             AND A.AREA_NO = C1.AREA_NO) A,
         (SELECT *
            FROM DW.DW_V_USER_BASE_INFO_USER B
           WHERE B.ACCT_MONTH = V_MONTH
             AND B.AREA_NO = C1.AREA_NO
             AND B.TELE_TYPE = '2') B, --第7个月套餐情况
         SJZX_WH_DIM_USER_DINNER C,
         SJZX_WH_DIM_USER_DINNER D,
         (SELECT DISTINCT AGENT_ID, AGENT_NAME, CHANNEL_NO
            FROM RPT_HBTELE.DM_BUSI_CHANNEL_BUILD
           WHERE ACCT_MONTH = V_MONTH
             AND AREA_NO = C1.AREA_NO) E
   WHERE A.USER_NO = B.USER_NO
     AND A.USER_DINNER = C.USER_DINNER(+)
     AND B.USER_DINNER = D.USER_DINNER(+)
     AND A.CHANNEL_NO = E.CHANNEL_NO(+)
