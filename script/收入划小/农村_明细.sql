SELECT 
X.CITY_DESC 区县,T.SUB_NAME_4,
----------C网
--全量收入
SUM(CASE WHEN SUB_NO_4='1' AND TELE_TYPE='2' THEN TOTAL_FEE ELSE 0 END) C_TOTAL_FEE, 

--增量收入
SUM(CASE WHEN SUB_NO_4='1' AND SUBSTR(INNET_DATE,1,4)='2017' AND TELE_TYPE='2' THEN TOTAL_FEE ELSE 0 END) C_NEW_FEE, 

--当月发展
SUM(CASE WHEN SUB_NO_4='1' AND IS_NEW='1' AND TELE_TYPE='2' THEN 1 ELSE 0 END) C_DEV_USERS, 

--------固网
--全量收入
SUM(CASE WHEN SUB_NO_4='1' AND TELE_TYPE<>'2' THEN TOTAL_FEE ELSE 0 END) G_TOTAL_FEE, 

--增量收入
SUM(CASE WHEN SUB_NO_4='1' AND SUBSTR(INNET_DATE,1,4)='2017' AND TELE_TYPE<>'2' THEN TOTAL_FEE ELSE 0 END) G_NEW_FEE, 

--当月发展
SUM(CASE WHEN SUB_NO_4='1' AND IS_NEW='1' AND TELE_TYPE<>'2' THEN 1 ELSE 0 END) G_DEV_USERS
 FROM TMP_MAJH_SUB_01 T,DIM.DIM_CITY_NO X WHERE SUB_NAME_4 IS NOT NULL 
 AND T.CITY_NO=X.CITY_NO
 GROUP BY X.CITY_DESC,T.SUB_NAME_4
