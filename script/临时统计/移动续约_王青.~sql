 DECLARE
  V_MONTH VARCHAR2(100);
  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018' ORDER BY IDX_NO;
BEGIN
  FOR V_NUM IN 201710 .. 201711 LOOP
    V_MONTH := TO_CHAR(V_NUM);
    FOR C1 IN V_AREA LOOP
     INSERT INTO TMP_MAJH_WEIXI_JF_DETAIL  --该表用户USER_NO可能会重复，因为可能有多个政策都生效
        SELECT V_MONTH,
               A.AREA_NO,
               A.CITY_NO,
               '3' TELE_TYPE,
               MOBILE_AGENT,
               '' AGENT_NAME,
               A.CHANNEL_NO,
               A.USER_NO,
               '' DEVICE_NUMBER,
               A.USER_DINNER,
               LOW_VALUE * 0.1
          FROM (SELECT AREA_NO,
                       CITY_NO,
                       USER_NO,
                       USER_DINNER,
                       CHANNEL_NO,
                       MOBILE_AGENT,
                       BEGIN_DATE,
                       END_DATE
                  FROM DW.DW_V_USER_DEVICE_RENT
                 WHERE ACCT_MONTH = v_MONTH
                   AND AREA_NO = c1.area_no
                   AND TO_CHAR(TO_DATE(BEGIN_DATE, 'YYYY/MM/DD HH24:MI:SS'),
                               'YYYYMM') < v_MONTH
                   AND MONTHS_BETWEEN(TO_DATE(V_MONTH,
                                              'YYYYMM'),
                                      TO_DATE(BEGIN_DATE, 'YYYY/MM/DD HH24:MI:SS')) < 13
                   AND TO_CHAR(TO_DATE(END_DATE, 'YYYY/MM/DD HH24:MI:SS'),
                               'YYYYMM') > v_MONTH) A, --这个是连续积分，次月开始积12个月，并且政策不能失效
               (SELECT *
                  FROM DW.DW_V_USER_BASE_INFO_USER C
                 WHERE C.ACCT_MONTH = V_MONTH
                   AND C.AREA_NO = C1.AREA_NO
                   AND C.TELE_TYPE = '2'
                   AND (C.IS_ACCT = '1' OR C.IS_ACCT_OCS = '1')) C, --需判断当月是否出账
               RPT_HBTELE.SJZX_WH_DIM_USER_DINNER B
         WHERE C.USER_DINNER = B.USER_DINNER
           AND A.USER_NO = C.USER_NO;
      COMMIT;
    END LOOP;
  END LOOP;
END;
