/*

MID_INMS_XIAOQU_FLUX   ---LTE综合网管 小区粒度的流量数据
MID_INMS_RRU_INFO      ---LTE综合网管 RRU设备信息
MID_EMS_RENT_INFO      ---能耗系统租赁信息
MID_EMS_ACCT_DETAILS   ---能耗系统报账明细
MID_EMS_INMS_TOWER_MATREL ---能耗-LTE网管-铁塔站址对应关系
MID_TOWER_RENT_BILL    ---铁塔租用管理系统起租表


1、能耗-LTE网管-铁塔站址对应关系 中一个站址编码对应多个租赁编码  是否正常？
2、在“铁塔起租单”表中同一个铁塔站址编码对应站址名称却不一样（全省两万多此种情况），如：
130100908000000154  对应两个名称：信息工程学院南校区西、市区信息工程学院南校区西
 同一个铁塔站址名称对应的区县不一样，如：130100908000001113，对应对应区县有两个：新华区和桥西区
 另外确认一下“铁塔详单-场租费”是否对应表中“场地费(元/年)”、“铁塔详单-产品服务费”是否对应表中“产品服务费合计(元/年)(含税)”?
3、RRU表中 站址编码和小区编码是多对多关系，同时一个站址有对应多个铁塔编码的情况
*/
create table TMP_JZ_ZULIN_01 AS 
SELECT *
  FROM (SELECT '201805' ACCT_MONTH,
               A.AREA_DESC,
               A.CITY_DESC CITY_DESC,
               A.INMS_ZHANZHI_ID,
               A.INMS_ZHANZHI_DESC,
               A.TOWER_ZHANZHI_ID, 
               NVL(SUM(B.PDCP_UP), 0) PDCP_UP,
               NVL(SUM(B.PDCP_DOWN), 0) PDCP_DOWN,
               MIN(A.INNET_DATE) INNET_DATE,
               C.ZULIN_NO,
               D.BZ_START_DATE,
               D.BZ_END_DATE,
               NVL(SUM(D.BZ_JE), 0) BZ_JE,
               NVL(SUM(G.CHD_FEE), 0) CHD_FEE,
               NVL(SUM(G.WH_FEE), 0) WH_FEE,
               CASE
                 WHEN ((NVL(SUM(B.PDCP_UP), 0) > 0 OR
                      NVL(SUM(B.PDCP_DOWN), 0) > 0) AND
                      NVL(SUM(G.CHD_FEE), 0) = 0 AND
                      NVL(SUM(D.BZ_JE), 0) = 0) THEN
                  '有流量，无租赁'
                 WHEN NVL(SUM(G.CHD_FEE), 0) > 0 AND NVL(SUM(D.BZ_JE), 0) > 0 AND A.TOWER_ZHANZHI_ID IS NOT NULL THEN
                  '既有铁塔租赁，又有能耗租赁'
                 WHEN ((A.TOWER_ZHANZHI_ID IS NOT NULL OR
                      NVL(SUM(G.CHD_FEE), 0) > 0) AND
                      NVL(SUM(D.BZ_JE), 0) = 0AND NVL(SUM(B.PDCP_UP), 0) = 0 AND
                       NVL(SUM(B.PDCP_DOWN), 0) = 0) THEN
                  '铁塔租赁，没有流量'
                 WHEN ((A.TOWER_ZHANZHI_ID IS NULL OR
                      NVL(SUM(G.CHD_FEE), 0) = 0) AND
                      NVL(SUM(D.BZ_JE), 0) > 0 AND
                      NVL(SUM(B.PDCP_UP), 0) = 0 AND
                      NVL(SUM(B.PDCP_DOWN), 0) = 0) THEN
                  '能耗租赁，没有流量'
               END ZHDJG_FLAG
        
          FROM (SELECT RRU_ID,
                       INMS_ZHANZHI_ID,
                       INMS_ZHANZHI_DESC,
                       TOWER_ZHANZHI_ID,
                       TOWER_ZHANZHI_DESC,
                       ENB_ID,
                       ENBID_DESC,
                       SHENG_DESC,
                       AREA_DESC,
                       CITY_DESC,
                       XIAOQU_ID,
                       AREA_NO,
                       TO_DATE(INNET_DATE, 'YYYY-MM-DD HH24:MI:SS') INNET_DATE
                  FROM STAGE_INMS_RRU_INFO A
                ) A, ---RRU 站址  
               
               (SELECT AREA_NO,
                       XIAOQU_DESC,
                       XIAOQU_NO,
                       NVL(SUM(PDCP_UP), 0) PDCP_UP,
                       NVL(SUM(PDCP_DOWN), 0) PDCP_DOWN
                  FROM STAGE_INMS_XIAOQU_FLUX B
                 WHERE TO_CHAR(TO_DATE(B.DATE_TIMES, 'YYYY-MM-DD HH24:MI:SS'),
                               'YYYYMM') = '201805'
                
                 GROUP BY XIAOQU_DESC, XIAOQU_NO, AREA_NO) B, --小区流量
               
               (SELECT AREA_NO,
                       ZULIN_NO,
                       ZULIN_ST_NO,
                       ZULIN_ST_DESC,
                       ZHANZHI_NO,
                       ZHANZHI_DESC,
                       TOWER_ZHANZHI_NO
                  FROM STAGE_EMS_INMS_TOWER_MATREL C) C, ---能耗-LTE网管-铁塔站址对应关系
               
               (SELECT *
                  FROM (SELECT E.AREA_NO,E.ZULIN_NO,
                               E.ST_NO,
                               F.BZ_START_DATE,
                               F.BZ_END_DATE,
                               NVL(F.BZ_JE, 0) BZ_JE,
                               ROW_NUMBER() OVER(PARTITION BY F.ST_NO ORDER BY F.BZ_END_DATE DESC) RN
                          FROM STAGE_EMS_RENT_INFO    E, --能耗系统租赁信息
                               STAGE_EMS_ACCT_DETAILS F ----能耗系统报账明细
                         WHERE E.ST_NO = F.ST_NO)
                 WHERE RN = 1) D,
               (SELECT AREA_NO,
                       AREA_NO_DESC,
                       ZHANZHI_NO,
                       NVL(SUM(CHD_FEE), 0) CHD_FEE,
                       NVL(SUM(WH_FEE), 0) WH_FEE
                
                  FROM STAGE_TOWER_RENT_BILL T
                 GROUP BY AREA_NO, AREA_NO_DESC, ZHANZHI_NO) G ---铁塔租用管理系统起租表
         WHERE A.XIAOQU_ID = B.XIAOQU_NO(+)
           AND A.AREA_NO = B.AREA_NO(+)
           AND A.INMS_ZHANZHI_ID = C.ZHANZHI_NO(+)
           AND A.AREA_NO = C.AREA_NO(+)
           AND C.ZULIN_ST_NO = D.ST_NO(+)
           AND C.AREA_NO = D.AREA_NO(+)
           AND C.TOWER_ZHANZHI_NO = G.ZHANZHI_NO(+)
           AND C.AREA_NO = G.AREA_NO(+)
        
         GROUP BY A.AREA_DESC,
                  A.CITY_DESC,
                  A.INMS_ZHANZHI_ID,
                  A.INMS_ZHANZHI_DESC,
                  A.TOWER_ZHANZHI_ID, 
                  C.ZULIN_NO,
                  D.BZ_START_DATE,
                  D.BZ_END_DATE)
 WHERE ZHDJG_FLAG IS NOT NULL
 ORDER BY INMS_ZHANZHI_ID, ZHDJG_FLAG;



create table TMP_JZ_ZULIN_02 as    
SELECT '201805' ACCT_MONTH,
       A.AREA_DESC,
       A.CITY_DESC,
       A.RRU_ID,
       A.INMS_ZHANZHI_ID,
       A.INMS_ZHANZHI_DESC,
       A.TOWER_ZHANZHI_ID,
       A.TOWER_ZHANZHI_DESC,
       A.XIAOQU_ID,
       B.XIAOQU_DESC,
       NVL(SUM(B.PDCP_UP), 0) PDCP_UP,
       NVL(SUM(B.PDCP_DOWN), 0) PDCP_DOWN
  FROM (SELECT RRU_ID,
               INMS_ZHANZHI_ID,
               INMS_ZHANZHI_DESC,
               TOWER_ZHANZHI_ID,
               TOWER_ZHANZHI_DESC,
               ENB_ID,
               ENBID_DESC,
               SHENG_DESC,
               AREA_DESC,
               CITY_DESC,
               XIAOQU_ID,
               AREA_NO,
               TO_DATE(INNET_DATE, 'YYYY-MM-DD HH24:MI:SS') INNET_DATE
          FROM STAGE_INMS_RRU_INFO A) A, ---RRU 站址  
       
       (SELECT AREA_NO,
               XIAOQU_DESC,
               XIAOQU_NO,
               NVL(SUM(PDCP_UP), 0) PDCP_UP,
               NVL(SUM(PDCP_DOWN), 0) PDCP_DOWN
          FROM STAGE_INMS_XIAOQU_FLUX B
         WHERE TO_CHAR(TO_DATE(B.DATE_TIMES, 'YYYY-MM-DD HH24:MI:SS'),
                       'YYYYMM') = '201805'
        
         GROUP BY XIAOQU_DESC, XIAOQU_NO, AREA_NO) B --小区流量

 WHERE A.XIAOQU_ID = XIAOQU_NO(+)
   AND A.AREA_NO = B.AREA_NO(+)
 GROUP BY A.AREA_DESC,
          A.CITY_DESC,
          A.RRU_ID,
          A.INMS_ZHANZHI_ID,
          A.INMS_ZHANZHI_DESC,
          A.TOWER_ZHANZHI_ID,
          A.TOWER_ZHANZHI_DESC,
          A.XIAOQU_ID,
          B.XIAOQU_DESC
 ORDER BY A.RRU_ID
