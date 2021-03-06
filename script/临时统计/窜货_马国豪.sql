--分地市
  SELECT SUBSTR(A.REG_DATE, 1, 6),
         B.AREA_DESC，
         SUM(REG_CNT),
         SUM(HANG_CNT),
         SUM(CUAN_CNT)
    FROM tmp_majh_cuan_0530_01 A, DIM.DIM_AREA_NO B
   WHERE FUNC_GET_XIONGAN_AREA_NO(A.AREA_NO, A.CITY_NO) = B.AREA_NO
   AND SUBSTR(A.REG_DATE, 1, 6)='201806'
   GROUP BY SUBSTR(A.REG_DATE, 1, 6),B.AREA_DESC,b.idx_no
   ORDER BY B.IDX_NO
   

--分品牌
  SELECT SUBSTR(A.REG_DATE, 1, 6),
         a.TERMINAL_CORP,
         SUM(REG_CNT),
         SUM(HANG_CNT),
         SUM(CUAN_CNT)
    FROM TMP_MAJH_CUAN_0530_01 A
    where SUBSTR(A.REG_DATE, 1, 6)='201806'
    group by SUBSTR(A.REG_DATE, 1, 6),a.TERMINAL_CORP
    
