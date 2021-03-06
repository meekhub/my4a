DECLARE
  CURSOR V_AREA IS
    SELECT *
      FROM DIM.DIM_AREA_NO
     WHERE AREA_NO <> '018'
     ORDER BY IDX_NO DESC;
  V_MONTH VARCHAR2(10);
BEGIN
  FOR I IN 0 .. 0 LOOP
  
    V_MONTH := TO_CHAR(ADD_MONTHS(TO_DATE('201808', 'YYYYMM'), i), 'YYYYMM');
    FOR C1 IN V_AREA LOOP
    
      INSERT INTO xxhb_mjh.tmp_majh_hy_0813_01
        SELECT V_MONTH,
               C1.AREA_NO,
               A.TERMINAL_CORP,
               A.TERMINAL_MODEL,
               A.SUGGEST_PRICE,
               CASE
                 WHEN A.TERMINAL_TYPE = '4' THEN
                  '4G智能'
                 WHEN A.TERMINAL_TYPE = '1' THEN
                  '3G智能'
                 WHEN A.TERMINAL_TYPE = '2' THEN
                  '3G非智能'
                 ELSE
                  '2G'
               END,
               CASE
                 WHEN B.USER_NO IS NOT NULL THEN
                  '新用户'
                 ELSE
                  '老用户'
               END,
               CASE
                 WHEN C.DEVICE_NO IS NOT NULL THEN
                  '合约'
                 ELSE
                  '非合约'
               END,
               COUNT(DISTINCT(A.TERMINAL_CODE)),
               a.city_no
          FROM (SELECT *
                  FROM dw.DW_V_USER_TERMINAL_DEVICE_D A
                 WHERE A.ACCT_MONTH = '201808'
                   AND A.DAY_ID = '12'
                   AND A.AREA_NO = C1.AREA_NO
                   AND TO_CHAR(A.REG_DATE, 'YYYYMM') = V_MONTH
                   ) A,
               (SELECT *
                  FROM dw.DW_V_USER_BASE_INFO_DAY B
                 WHERE B.ACCT_MONTH = '201808'
                   AND B.DAY_ID = '12'
                   AND B.AREA_NO = C1.AREA_NO
                   AND B.TELE_TYPE = '2'
                   AND TO_CHAR(B.INNET_DATE, 'YYYYMM') = V_MONTH
                   ) B,
               (SELECT T.*
                  FROM (SELECT T.*,
                               ROW_NUMBER() OVER(PARTITION BY DEVICE_NO ORDER BY CREATE_DATE DESC) RN
                          FROM (SELECT A.*,
                                       NVL(B.CREATE_DATE, A.BEGIN_DATE) CREATE_DATE
                                  FROM (SELECT *
                                          FROM CRM_DSG.BB_DEVICE_RENT_INFO_T@HBODS
                                         WHERE CITY_CODE = C1.AREA_NO) A,
                                       (SELECT *
                                          FROM CRM_DSG.SALES_PROMOTION_INST@HBODS
                                         WHERE CITY_CODE = C1.AREA_NO) B
                                 WHERE NVL(A.PROMOTION_INST_ID, '0') =
                                       B.PROMOTION_INST_ID(+)) T) T
                 WHERE RN = 1
                  AND TO_CHAR(CREATE_DATE, 'YYYYMM') = V_MONTH
                   ) C
         WHERE A.USER_NO = B.USER_NO(+)
           AND A.TERMINAL_CODE = C.DEVICE_NO(+)
         GROUP BY V_MONTH,
                  C1.AREA_NO,
                  A.TERMINAL_CORP,
                  A.TERMINAL_MODEL,
                  A.SUGGEST_PRICE,
                  CASE
                    WHEN A.TERMINAL_TYPE = '4' THEN
                     '4G智能'
                    WHEN A.TERMINAL_TYPE = '1' THEN
                     '3G智能'
                    WHEN A.TERMINAL_TYPE = '2' THEN
                     '3G非智能'
                    ELSE
                     '2G'
                  END,
                  CASE
                    WHEN B.USER_NO IS NOT NULL THEN
                     '新用户'
                    ELSE
                     '老用户'
                  END,
                  CASE
                    WHEN C.DEVICE_NO IS NOT NULL THEN
                     '合约'
                    ELSE
                     '非合约'
                  END,a.city_no;
      COMMIT;
    END LOOP;
  END LOOP;
END;
