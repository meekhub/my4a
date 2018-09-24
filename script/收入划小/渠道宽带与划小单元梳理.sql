 DECLARE
  V_MONTH VARCHAR2(100);
  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018' ORDER BY IDX_NO;
BEGIN
  FOR V_NUM IN 201208 .. 201208 LOOP
    V_MONTH := TO_CHAR(V_NUM);
    FOR C1 IN V_AREA LOOP
      INSERT INTO TEMP_USER.TMP_MAHH_HUAXIAO_0911_01
        SELECT D.AREA_DESC,
               E.CITY_DESC,
               C.AGENT_ID,
               C.AGENT_NAME,  
               NVL(C.CHANNEL_PROP_NO, '01'),
               NVL(C.CHANNEL_PROP_NAME, '商圈'),
               NVL(C.REGION_PROP_NO, '07'),
               NVL(C.REGION_PROP_NAME, '其他'),
               B.CHANNEL_NO,
               b.channel_no_desc,
               count(*),
               sum(A.total_fee)
          FROM  
           (SELECT ACCT_MONTH, 
                       AREA_NO_DESC,
                       CITY_NO_DESC,
                       TELE_TYPE,
                       CHANNEL_NO,
                       CHANNEL_TYPE,
                       CHANNEL_KIND,
                       USER_NO,
                       DEVICE_NUMBER,
                       IS_VALID,
                       INNET_DATE,
                       USER_DINNER,
                       USER_DINNER_DESC,
                       MONTH_FEE,
                       BILLING_FLAG,
                       IS_KD_BUNDLE,
                       (total_fee+total_fee_ocs)total_fee
                  FROM DW.DW_V_USER_BASE_INFO_DAY T
                 WHERE ACCT_MONTH = '201709' 
                   AND DAY_ID='12'
                   AND AREA_NO = C1.AREA_NO
                   AND CHANNEL_TYPE LIKE '11%'
                   and is_onnet='1') X,
          (SELECT USER_NO,
                       (total_fee+total_fee_ocs)total_fee
                  FROM DW.DW_V_USER_BASE_INFO_USER T
                 WHERE ACCT_MONTH = '201708' 
                   AND AREA_NO = C1.AREA_NO 
                   and is_onnet='1') A,
               (SELECT *
                  FROM DIM.DIM_CHANNEL_NO
                 WHERE CHANNEL_TYPE LIKE '11%') B,
               (SELECT DISTINCT AGENT_ID,
                                AGENT_NAME,
                                CHANNEL_NO,
                                CASE
                                  WHEN BUSINESS_ZONE = '10' THEN
                                   '02'
                                  WHEN BUSINESS_ZONE_NAME LIKE '%商圈%' THEN
                                   '01'
                                  ELSE
                                   '03'
                                END CHANNEL_PROP_NO,
                                CASE
                                  WHEN BUSINESS_ZONE = '10' THEN
                                   '社区'
                                  WHEN BUSINESS_ZONE_NAME LIKE '%商圈%' THEN
                                   '商圈'
                                  ELSE
                                   '农村'
                                END CHANNEL_PROP_NAME,
                                
                                CASE
                                  WHEN T.CHANNEL_TYPE IN
                                       ('110101', '110102', '110103') THEN
                                   '01'
                                  WHEN T.CHANNEL_TYPE IN ('110201') THEN
                                   '02'
                                  WHEN T.CHANNEL_TYPE IN ('110301') THEN
                                   '03'
                                  WHEN T.CHANNEL_TYPE IN ('110302') THEN
                                   '04'
                                  WHEN (T.CHANNEL_TYPE NOT IN
                                       ('110101',
                                         '110102',
                                         '110103',
                                         '110201',
                                         '110301',
                                         '110302') OR T.CHANNEL_TYPE IS NULL) AND
                                       T.PROTOP10 IN ('1', '2') THEN
                                   '05'
                                  WHEN (T.CHANNEL_TYPE NOT IN
                                       ('110101',
                                         '110102',
                                         '110103',
                                         '110201',
                                         '110301',
                                         '110302') OR T.CHANNEL_TYPE IS NULL) AND
                                       (T.PROTOP10 NOT IN ('1', '2') OR
                                       T.PROTOP10 IS NULL) THEN
                                   '06'
                                  ELSE
                                   '07'
                                END REGION_PROP_NO,
                                CASE
                                  WHEN T.CHANNEL_TYPE IN
                                       ('110101', '110102', '110103') THEN
                                   '自营厅'
                                  WHEN T.CHANNEL_TYPE IN ('110201') THEN
                                   '专营店'
                                  WHEN T.CHANNEL_TYPE IN ('110301') THEN
                                   '国家连锁'
                                  WHEN T.CHANNEL_TYPE IN ('110302') THEN
                                   '省级连锁'
                                  WHEN (T.CHANNEL_TYPE NOT IN
                                       ('110101',
                                         '110102',
                                         '110103',
                                         '110201',
                                         '110301',
                                         '110302') OR T.CHANNEL_TYPE IS NULL) AND
                                       T.PROTOP10 IN ('1', '2') THEN
                                   '省市TOP'
                                  WHEN (T.CHANNEL_TYPE NOT IN
                                       ('110101',
                                         '110102',
                                         '110103',
                                         '110201',
                                         '110301',
                                         '110302') OR T.CHANNEL_TYPE IS NULL) AND
                                       (T.PROTOP10 NOT IN ('1', '2') OR
                                       T.PROTOP10 IS NULL) THEN
                                   '中小混营'
                                  ELSE
                                   '其他'
                                END REGION_PROP_NAME
                  FROM RPT_HBTELE.DM_BUSI_CHANNEL_BUILD T
                 WHERE ACCT_MONTH = '201708') C,
                 DIM.DIM_AREA_NO D,
                 DIM.DIM_CITY_NO E
         WHERE X.USER_NO = A.USER_NO(+)
           AND X.CHANNEL_NO = B.CHANNEL_NO(+)
           AND X.CHANNEL_NO = C.CHANNEL_NO(+)
           AND B.AREA_NO=D.AREA_NO(+)
           AND B.CITY_NO=E.CITY_NO(+)
           group by 
           D.AREA_DESC,
               E.CITY_DESC,
               C.AGENT_ID,
               C.AGENT_NAME, 
               NVL(C.CHANNEL_PROP_NO, '01'),
               NVL(C.CHANNEL_PROP_NAME, '商圈'),
               NVL(C.REGION_PROP_NO, '07'),
               NVL(C.REGION_PROP_NAME, '其他'),
               B.CHANNEL_NO,
               b.channel_no_desc;
      COMMIT;
    END LOOP;
  END LOOP;
END;


--渠道明细
select count(*),channel_no from TEMP_USER.TMP_MAHH_HUAXIAO_0911_01 group by channel_no having count(*)>1;

select * from  TEMP_USER.TMP_MAHH_HUAXIAO_0911_01 where channel_no='188303663';


create table TEMP_USER.TMP_MAHH_HUAXIAO_0911_02 as 
SELECT C.AREA_DESC,
       D.CITY_DESC,
       a.AGENT_ID,
       a.AGENT_NAME,
       a.PROP_ID,
       a.PROP_NAME,
       a.REGION_ID,
       a.REGION_NAME,
       a.CHANNEL_NO,
       a.CHANNEL_NO_DESC,
       to_char(b.CONTRACT_BEGIN,'yyyymm')CONTRACT_BEGIN,
       decode(b.valid_status,'2','注销','正常') valid_status,
       SUM(a.USER_CNT)USER_CNT,
       sum(a.total_fee)total_fee
  FROM TEMP_USER.TMP_MAHH_HUAXIAO_0911_01 A,
       DIM.DIM_CHANNEL_NO                 B,
       DIM.DIM_AREA_NO                    C,
       DIM.DIM_CITY_NO                    D
 WHERE A.CHANNEL_NO = B.CHANNEL_NO
   AND B.AREA_NO = C.AREA_NO
   AND B.CITY_NO = D.CITY_NO
 GROUP BY C.AREA_DESC,
       D.CITY_DESC,
       a.AGENT_ID,
       a.AGENT_NAME,
       a.PROP_ID,
       a.PROP_NAME,
       a.REGION_ID,
       a.REGION_NAME,
       a.CHANNEL_NO,
       a.CHANNEL_NO_DESC,
       to_char(b.CONTRACT_BEGIN,'yyyymm'),
       decode(b.valid_status,'2','注销','正常');
       
SELECT AREA_DESC 地市,
       CITY_DESC 区县,
       AGENT_ID 代理商ID,
       AGENT_NAME 代理商名称, 
       PROP_NAME 区域属性, 
       REGION_NAME 渠道属性,
       CHANNEL_NO 渠道ID,
       CHANNEL_NO_DESC 渠道名称,
       a.CONTRACT_BEGIN 创建时间,
       valid_status 状态,
       USER_CNT 用户量,
       total_fee
  FROM TEMP_USER.TMP_MAHH_HUAXIAO_0911_02 a order by area_desc

--项目明细
SELECT X.AREA_DESC 地市,
       C.CITY_DESC 区县,
       T.CITY_TYPE 区域属性,
       T.TOWN_NAME 乡镇,
       T.GRID_NAME 网格,
       T.SUBTATION 支局,
       T.XIAOQU_NO 小区ID,
       T.XIAOQU_NAME 小区名称
  FROM ALLDMCODE.DMCODE_XIAOQU_INFO T, DIM.DIM_AREA_NO X, DIM.DIM_CITY_NO C
 WHERE T.AREA_NO = X.AREA_NO
   AND T.CITY_NO = C.CITY_NO


--基站信息
SELECT DISTINCT B.AREA_DESC, C.LO_NM_3, A.CELL_NO, A.CELL_DESC
  FROM (SELECT T.AREA_NO, T.CITY_NO, T.CELL_NO, T.CELL_DESC
          FROM DIM.DIM_CELL_NO T
         WHERE CELL_DESC IS NOT NULL) A,
       DIM.DIM_AREA_NO B,
       (SELECT DISTINCT LO_ID_3, LO_NM_3
          FROM ALLDM.BWT_DIM_REGION_M
         WHERE ACCT_MONTH = '201708') C
 WHERE A.AREA_NO = B.AREA_NO(+)
   AND A.CITY_NO = C.LO_ID_3(+)
