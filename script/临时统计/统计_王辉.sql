SELECT A.ACCT_MONTH,
       a.area_no,
       COUNT(DISTINCT CASE
               WHEN A.SUBPRODUCT_ID IS NULL THEN
                A.USER_NO
             END) 溢出用户,
       SUM(CASE
             WHEN A.SUBPRODUCT_ID IS NULL THEN
              A.TOTAL_OCTETS
             ELSE
              0
           END) / 1024 / 1024 / 1024 溢出流量,
       COUNT(DISTINCT CASE
               WHEN A.SUBPRODUCT_ID IS NULL AND A.ROAM_TYPE = '12' THEN
                A.USER_NO
             END) 省际溢出用户,
       SUM(CASE
             WHEN A.SUBPRODUCT_ID IS NULL AND A.ROAM_TYPE = '12' THEN
              A.TOTAL_OCTETS
             ELSE
              0
           END) / 1024 / 1024 / 1024 省际溢出流量
  FROM DW.DW_V_USER_1X_STREAM A 
 WHERE A.ACCT_MONTH = '201806'
   AND A.TELE_TYPE = '2'
   AND A.NET_TYPE <> '1' 
 GROUP BY a.area_no
