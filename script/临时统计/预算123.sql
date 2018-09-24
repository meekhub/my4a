--预算自动化
SELECT 
       C.AREA_NO,
       C.CITY_NO, 
       C.HUAXIAO_NO,
       b.cw_huaxiao_no, 
       c.huaxiao_name,
       SUM(CASE
             WHEN UPPER(BUDGET_ITEM_ID) IN ('27_COST_2740') THEN
              A.USED_SUM
             ELSE
              0
           END) 广告宣传费, --广告宣传费
       SUM(CASE
             WHEN UPPER(BUDGET_ITEM_ID) IN ('27_COST_2910') THEN
              A.USED_SUM
             ELSE
              0
           END) 客户服务费, --客户服务费
       SUM(CASE
             WHEN UPPER(BUDGET_ITEM_ID) IN ('27_COST_3091') THEN
              A.USED_SUM
             ELSE
              0
           END) 业务招待费, --业务招待费
       SUM(CASE
             WHEN UPPER(BUDGET_ITEM_ID) IN ('27_COST_3074') THEN
              A.USED_SUM
             ELSE
              0
           END) 低值易耗品费, --低值易耗品费
       SUM(CASE
             WHEN UPPER(BUDGET_ITEM_ID) IN ('27_COST_3004') THEN
              A.USED_SUM
             ELSE
              0
           END) 业务用品费, --业务用品费
       SUM(CASE
             WHEN UPPER(BUDGET_ITEM_ID) IN ('27_COST_2897') THEN
              A.USED_SUM
             ELSE
              0
           END) 业务支撑, --业务支撑
       SUM(CASE
             WHEN UPPER(BUDGET_ITEM_ID) IN ('27_COST_3019') THEN
              A.USED_SUM
             ELSE
              0
           END) 租赁费 --租赁费
  FROM (SELECT *
          FROM (SELECT A.*,
                       ROW_NUMBER() OVER(PARTITION BY ORG_ID ORDER BY CREATE_DATE) RN
                  FROM MSS_DS.BUDGET_INST_APP@HANA A)
         WHERE RN = 1) A,
       DIM.DIM_CW_HUAXIAO_INFO     B,
       DIM.DIM_HUAXIAO_INFO        C
 WHERE  UPPER(BUDGET_ITEM_ID) IN ('27_COST_2740',
                                 '27_COST_2910',
                                 '27_COST_3091',
                                 '27_COST_3074',
                                 '27_COST_3004',
                                 '27_COST_2897',
                                 '27_COST_3019')
   AND A.ORG_ID = B.CW_HUAXIAO_NO
   AND B.YW_HUAXIAO_NO = C.HUAXIAO_NO
 GROUP BY C.AREA_NO, C.CITY_NO, C.HUAXIAO_TYPE, b.cw_huaxiao_no,C.HUAXIAO_NO,c.huaxiao_name;
 
 
--年度预算 
--取数口径  取budget_set_str=2018  按照create_date最近取assign_sum
SELECT *
  FROM mss_ds.BUDGET_INST_COST@hana A, mss_ds.BUDGET_INST_ARCHIVE_COST@hana B
 WHERE A.BUDGET_ARCHIVE_ID = B.ID
   AND A.SUM > 0
   AND B.ORG_ID = '2709050004'
   AND A.BUDGET_ITEM_ID='27_Cost_2740'
   --AND ORG_ID='2701090007'
 
 
 
 
 
