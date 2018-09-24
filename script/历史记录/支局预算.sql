--指标模板映射预算指标维度表定义
select * from bms_item_group_mapping

--指标模板维度表结构
select * from bms_item_group

--指标维度表结构
select * from bms_item where name like '%业务用品费%'

35721 35722 --广告宣传费 
35751 35743 --客户服务费
35820 --业务招待费
35824 --车辆使用及租赁费
35773 --业务用品费

--成本预算池表
select * from bms_allocate_pool

--组织维度表结构
select * from soupe_organization where  leaf=1

--成本预算使用情况事实表结构
select * from bms_allocate_data_util where period='201708' and org_id=653038

--帐套维度表结构
select * from bms_set_of_books

--域维度表结构
select * from soupe_domain

select b.name,b.leaf,b.no,
ANALYZE_AMOUNT       预算金额      ,
EXECUTED_AMOUNT      本级执行金额  ,      
EXECUTED_P_AMOUNT    执行金额      ,
OCCUPIED_AMOUNT      本级占用金额  ,
OCCUPIED_P_AMOUNT    占用金额      ,
PREOCCUPIED_AMOUNT   本级预占金额  ,
PREOCCUPIED_P_AMOUNT 预占金额      ,
UNEXECUTED_AMOUNT    本级未执行金额,
UNEXECUTED_P_AMOUNT  未执行金额    ,
UNOCCUPIED_AMOUNT    本级未占用金额,
UNOCCUPIED_P_AMOUNT  未占用金额    
 from  BMS_ALLOCATE_POOL a, bms_item b where 
 a.item_id=b.id and
 org_id=662742 and period=201700
 and ANALYZE_AMOUNT>0 and leaf=1;
 
 

 SELECT A.ORG_ID, --支局ID
        C.NAME, --支局名称
        CASE
          WHEN A.ITEM_ID IN (35721, 35722) THEN
           '广告宣传费'
          WHEN A.ITEM_ID IN (35751, 35743) THEN
           '客户服务费'
          WHEN A.ITEM_ID IN (35820) THEN
           '业务招待费'
          WHEN A.ITEM_ID IN (35824) THEN
           '车辆使用及租赁费'
          WHEN A.ITEM_ID IN (35773) THEN
           '业务用品费'
        END NAME, --费用项
        SUM(CASE
              WHEN A.PERIOD = '201708' THEN
               ANALYZE_AMOUNT
              ELSE
               0
            END),--月度预算
        SUM(CASE
              WHEN A.PERIOD = '201708' THEN
               PREOCCUPIED_AMOUNT
              ELSE
               0
            END),--月度预占
        SUM(CASE
              WHEN A.PERIOD = '201708' THEN
               OCCUPIED_AMOUNT
              ELSE
               0
            END),--月度实占
        SUM(CASE
              WHEN A.PERIOD = '201708' THEN
               EXECUTED_AMOUNT
              ELSE
               0
            END),--月度执行
        SUM(CASE
              WHEN A.PERIOD = '201708' THEN
               UNEXECUTED_AMOUNT
              ELSE
               0
            END),--月度剩余
        SUM(CASE
              WHEN A.PERIOD = '201700' THEN
               ANALYZE_AMOUNT
              ELSE
               0
            END),--年度预算
        SUM(CASE
              WHEN A.PERIOD = '201700' THEN
               PREOCCUPIED_AMOUNT
              ELSE
               0
            END),--年度预占
        SUM(CASE
              WHEN A.PERIOD = '201700' THEN
               OCCUPIED_AMOUNT
              ELSE
               0
            END),--年度实占
        SUM(CASE
              WHEN A.PERIOD = '201700' THEN
               EXECUTED_AMOUNT
              ELSE
               0
            END),--年度执行
        SUM(CASE
              WHEN A.PERIOD = '201700' THEN
               UNEXECUTED_AMOUNT
              ELSE
               0
            END)--年度执行
   FROM BMS_ALLOCATE_POOL A, BMS_ITEM B, SOUPE_ORGANIZATION C
  WHERE A.ITEM_ID = B.ID
    AND A.ORG_ID = C.ID
       --AND ORG_ID = 652934
    AND PERIOD IN ('201708', '201700')
    AND ANALYZE_AMOUNT > 0
    AND B.LEAF = 1
    AND C.LEAF = 1
    AND C.ORGANIZATION_TYPE = '2'
    AND A.ITEM_ID IN
        ('35722', '35743', '35820', '35824', '35773', '35721', '35751')
  GROUP BY A.ORG_ID,
           C.NAME,
           CASE
             WHEN A.ITEM_ID IN (35721, 35722) THEN
              '广告宣传费'
             WHEN A.ITEM_ID IN (35751, 35743) THEN
              '客户服务费'
             WHEN A.ITEM_ID IN (35820) THEN
              '业务招待费'
             WHEN A.ITEM_ID IN (35824) THEN
              '车辆使用及租赁费'
             WHEN A.ITEM_ID IN (35773) THEN
              '业务用品费'
           END
  ORDER BY A.ORG_ID


--承包助手毛利
SELECT B.AREA_DESC, B.CITY_DESC, A.ZHIJU_ID, A.ZHIJU_DESC, B.MAOLI
  FROM (SELECT B.ZHIJU_ID, B.ZHIJU_DESC, A.STAFF_ID
          FROM C_DMCODE_CHENGBAO_USER_REL A, DIM.DIM_ZHIJU_NAME B
         WHERE A.CHENGBAO_NO = B.ZHIJU_ID) A,
       (SELECT T.AREA_DESC, T.CITY_DESC, ZHIJU_DESC, SUM(MAOLI) MAOLI
          FROM ALLDM.ALLDM_MAOLI_MODEL_M T
         WHERE ACCT_MONTH = '201708'
           AND T.ZHIJU_DESC IS NOT NULL
         GROUP BY T.AREA_DESC, T.CITY_DESC, ZHIJU_DESC) B
 WHERE A.ZHIJU_DESC = B.ZHIJU_DESC
 
 
select * from soupe_organization where name like '%胜芳杨芬港支局%'




 
 
 
