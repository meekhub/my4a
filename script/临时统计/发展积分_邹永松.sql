SELECT D.CITY_DESC,
       C.HUAXIAO_NO,
       C.HUAXIAO_NAME,
       E.CHANNEL_NO,
       E.CHANNEL_NO_DESC,
       SUM(case when a.jf_type in ('1','2') then A.LOW_VALUE else 0 end)mobile_value,
       SUM(case when a.jf_type in ('3') then A.LOW_VALUE else 0 end)gw_value
  FROM (SELECT *
          FROM INTEGRAL_SYS_DEVLP_JF_DETAIL_M T
         WHERE T.ACCT_MONTH = '201710'
           AND AREA_NO = '181') A,
       DIM.DIM_CHANNEL_HUAXIAO B,
       DIM.DIM_HUAXIAO_INFO C,
       DIM.DIM_CITY_NO D,
       DIM.DIM_CHANNEL_NO E
 WHERE B.HUAXIAO_TYPE = '01'
   AND A.CHANNEL_NO = B.CHANNEL_NO
   AND B.HUAXIAO_NO = C.HUAXIAO_NO
   AND C.CITY_NO = D.CITY_NO
   AND A.CHANNEL_NO = E.CHANNEL_NO
 GROUP BY D.CITY_DESC,
          C.HUAXIAO_NO,
          C.HUAXIAO_NAME,
          E.CHANNEL_NO,
          E.CHANNEL_NO_DESC
