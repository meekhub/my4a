SELECT CHENGBAO_TYPE, USER_TYPE, SUM(T.MONTH_VALUE)
  FROM CB_DM_KKPI_M_INCO_CHANNEL T
 WHERE T.ACCT_MONTH = '201711'
   AND T.AREA_NO = '182'
   AND TYPE_ONE = '01'
   AND TYPE_TWO = '00'
 group by CHENGBAO_TYPE, USER_TYPE


--移网全量用户收入
SELECT B.CITY_DESC, MONTH_VALUE, RATE, YEAR_TOTAL_VALUE
  FROM (SELECT T.CITY_NO,
               ROUND(SUM(T.MONTH_VALUE) , 2) MONTH_VALUE,
               DECODE(SUM(T.LAST_MONTH_VALUE),
                      0,
                      0,
                      ROUND((SUM(T.MONTH_VALUE) - SUM(T.LAST_MONTH_VALUE)) /
                            SUM(T.LAST_MONTH_VALUE),
                            4)) * 100 || '%' AS RATE,
               ROUND(SUM(T.YEAR_TOTAL_VALUE) , 2) YEAR_TOTAL_VALUE
          FROM CB_DM_KKPI_M_INCO_CHANNEL T
         WHERE T.ACCT_MONTH = '201712'
           AND T.AREA_NO = '182'
           AND TYPE_ONE = '01'
           AND TYPE_TWO = '00'
           AND CHENGBAO_TYPE = '1' --支局
           AND USER_TYPE = '03'
         GROUP BY T.CITY_NO) A,
       DIM.DIM_CITY_NO B
 WHERE A.CITY_NO = B.CITY_NO
 order by b.city_no

--移网存量用户收入
SELECT B.CITY_DESC, MONTH_VALUE, RATE, YEAR_TOTAL_VALUE
  FROM (SELECT T.CITY_NO,
               ROUND(SUM(T.MONTH_VALUE) , 2) MONTH_VALUE,
               DECODE(SUM(T.LAST_MONTH_VALUE),
                      0,
                      0,
                      ROUND((SUM(T.MONTH_VALUE) - SUM(T.LAST_MONTH_VALUE)) /
                            SUM(T.LAST_MONTH_VALUE),
                            4)) * 100 || '%' AS RATE,
               ROUND(SUM(T.YEAR_TOTAL_VALUE) , 2) YEAR_TOTAL_VALUE
          FROM CB_DM_KKPI_M_INCO_CHANNEL T
         WHERE T.ACCT_MONTH = '201712'
           AND T.AREA_NO = '182'
           AND TYPE_ONE = '01'
           AND TYPE_TWO = '00'
           AND CHENGBAO_TYPE = '1' --支局
           AND USER_TYPE = '02'
         GROUP BY T.CITY_NO) A,
       DIM.DIM_CITY_NO B
 WHERE A.CITY_NO = B.CITY_NO
 order by b.city_no
   
--移网增量量用户收入
SELECT B.CITY_DESC, MONTH_VALUE, RATE, YEAR_TOTAL_VALUE
  FROM (SELECT T.CITY_NO,
               ROUND(SUM(T.MONTH_VALUE) , 2) MONTH_VALUE,
               DECODE(SUM(T.LAST_MONTH_VALUE),
                      0,
                      0,
                      ROUND((SUM(T.MONTH_VALUE) - SUM(T.LAST_MONTH_VALUE)) /
                            SUM(T.LAST_MONTH_VALUE),
                            4)) * 100 || '%' AS RATE,
               ROUND(SUM(T.YEAR_TOTAL_VALUE), 2) YEAR_TOTAL_VALUE
          FROM CB_DM_KKPI_M_INCO_CHANNEL T
         WHERE T.ACCT_MONTH = '201712'
           AND T.AREA_NO = '182'
           AND TYPE_ONE = '01'
           AND TYPE_TWO = '00'
           AND CHENGBAO_TYPE = '1' --支局
           AND USER_TYPE = '01'
         GROUP BY T.CITY_NO) A,
       DIM.DIM_CITY_NO B
 WHERE A.CITY_NO = B.CITY_NO
 order by b.city_no

--固网全量用户收入
SELECT B.CITY_DESC, MONTH_VALUE, RATE, YEAR_TOTAL_VALUE
  FROM (SELECT T.CITY_NO,
               ROUND(SUM(T.MONTH_VALUE) , 2) MONTH_VALUE,
               DECODE(SUM(T.LAST_MONTH_VALUE),
                      0,
                      0,
                      ROUND((SUM(T.MONTH_VALUE) - SUM(T.LAST_MONTH_VALUE)) /
                            SUM(T.LAST_MONTH_VALUE),
                            4)) * 100 || '%' AS RATE,
               ROUND(SUM(T.YEAR_TOTAL_VALUE), 2) YEAR_TOTAL_VALUE
          FROM CB_DM_KKPI_M_INCO_CHANNEL T
         WHERE T.ACCT_MONTH = '201712'
           AND T.AREA_NO = '182'
           AND TYPE_ONE = '03'
           AND TYPE_TWO = '00'
           AND CHENGBAO_TYPE = '1' --支局
           AND USER_TYPE = '03'
         GROUP BY T.CITY_NO) A,
       DIM.DIM_CITY_NO B
 WHERE A.CITY_NO = B.CITY_NO
 order by b.city_no
   

--固网存量用户收入
SELECT B.CITY_DESC, MONTH_VALUE, RATE, YEAR_TOTAL_VALUE
  FROM (SELECT T.CITY_NO,
               ROUND(SUM(T.MONTH_VALUE) , 2) MONTH_VALUE,
               DECODE(SUM(T.LAST_MONTH_VALUE),
                      0,
                      0,
                      ROUND((SUM(T.MONTH_VALUE) - SUM(T.LAST_MONTH_VALUE)) /
                            SUM(T.LAST_MONTH_VALUE),
                            4)) * 100 || '%' AS RATE,
               ROUND(SUM(T.YEAR_TOTAL_VALUE), 2) YEAR_TOTAL_VALUE
          FROM CB_DM_KKPI_M_INCO_CHANNEL T
         WHERE T.ACCT_MONTH = '201712'
           AND T.AREA_NO = '182'
           AND TYPE_ONE = '03'
           AND TYPE_TWO = '00'
           AND CHENGBAO_TYPE = '1' --支局
           AND USER_TYPE = '02'
         GROUP BY T.CITY_NO) A,
       DIM.DIM_CITY_NO B
 WHERE A.CITY_NO = B.CITY_NO
 order by b.city_no
   
--固网增量量用户收入
SELECT B.CITY_DESC, MONTH_VALUE, RATE, YEAR_TOTAL_VALUE
  FROM (SELECT T.CITY_NO,
               ROUND(SUM(T.MONTH_VALUE) , 2) MONTH_VALUE,
               DECODE(SUM(T.LAST_MONTH_VALUE),
                      0,
                      0,
                      ROUND((SUM(T.MONTH_VALUE) - SUM(T.LAST_MONTH_VALUE)) /
                            SUM(T.LAST_MONTH_VALUE),
                            4)) * 100 || '%' AS RATE,
               ROUND(SUM(T.YEAR_TOTAL_VALUE), 2) YEAR_TOTAL_VALUE
          FROM CB_DM_KKPI_M_INCO_CHANNEL T
         WHERE T.ACCT_MONTH = '201712'
           AND T.AREA_NO = '182'
           AND TYPE_ONE = '03'
           AND TYPE_TWO = '00'
           AND CHENGBAO_TYPE = '1' --支局
           AND USER_TYPE = '01'
         GROUP BY T.CITY_NO) A,
       DIM.DIM_CITY_NO B
 WHERE A.CITY_NO = B.CITY_NO
 order by b.city_no
