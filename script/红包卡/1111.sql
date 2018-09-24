DECLARE
  V_MONTH      VARCHAR2(100);
  V_LAST_MONTH VARCHAR2(100);
  V_LAST_M3    VARCHAR2(100);
BEGIN
  FOR V_NUM IN 201712 .. 201712 LOOP
    V_MONTH      := TO_CHAR(V_NUM);
    V_LAST_MONTH := TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH, 'YYYYMM'), -1),
                            'YYYYMM');
    V_LAST_M3    := TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH, 'YYYYMM'), -3),
                            'YYYYMM');
    --自由模式红包
    EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_RED_MODEL_00';
    insert into MID_RED_MODEL_00
    SELECT A.USER_NO, A.USER_DINNER, B.ATTR_VALUE
      FROM (SELECT USER_NO, USER_DINNER
              FROM DW.DW_V_USER_BASE_INFO_USER A
             WHERE ACCT_MONTH = v_month
               AND TELE_TYPE = '2') A,
           (SELECT * FROM DIM.DIM_REDBAG_NO WHERE FLAG = '2') B
     WHERE A.USER_DINNER = B.PROMOTION_ID;
    COMMIT;
    
    --当月非自由红包模式返还情况
    EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_RED_MODEL_01';
    INSERT INTO MID_RED_MODEL_01
      SELECT A.AREA_NO,
             A.USER_NO,
             A.PRESENT_FEE,
             A.PROMOTION_ID,
             A.PROMOTION_NAME,
             A.EFF_DATE,
             A.EXP_DATE,
             A.REBAT_CNT,
             CASE
               WHEN B.ATTR_VALUE = 0 THEN
                C.ATTR_VALUE * REBAT_CNT  --自由模式
               ELSE
                B.ATTR_VALUE * REBAT_CNT
             END AS PRESENT_FEE_LJ,
             a.device_number
        FROM (SELECT A.*,
                     CEIL(MONTHS_BETWEEN(TO_DATE(ACCT_MONTH, 'YYYYMM'),
                                         CASE
                                           WHEN TO_CHAR(EFF_DATE, 'DD') = '01' THEN
                                            EFF_DATE - 1
                                           ELSE
                                            EFF_DATE
                                         END)) REBAT_CNT
                FROM DW.DW_V_USER_POLICY_PRESENT_FEE A
               WHERE ACCT_MONTH = V_MONTH
                 AND PROMOTION_TYPE_NAME = '翼支付红包卡') A,
             (SELECT * FROM DIM.DIM_REDBAG_NO WHERE FLAG = '1') B,
             MID_RED_MODEL_00 C
       WHERE A.PROMOTION_ID = B.PROMOTION_ID(+)
         AND A.USER_NO = C.USER_NO(+);
    COMMIT;
  
/*      UPDATE MID_RED_MODEL_01 SET REBAT_CNT=1 WHERE REBAT_CNT=0 OR REBAT_CNT IS NULL;
      commit;
    UPDATE MID_RED_MODEL_01 SET  PRESENT_FEE_LJ=PRESENT_FEE*REBAT_CNT;
    commit;*/
  
    DELETE FROM MID_RED_MODEL_02 WHERE ACCT_MONTH IN (V_MONTH, V_LAST_M3);
    COMMIT;
  
    INSERT INTO MID_RED_MODEL_02
      SELECT V_MONTH, AREA_NO, USER_NO,device_number,promotion_id,promotion_name,eff_date,exp_date, SUM(PRESENT_FEE_LJ)
        FROM (SELECT AREA_NO, USER_NO, device_number，promotion_id,promotion_name, eff_date,exp_date,PRESENT_FEE_LJ
                FROM MID_RED_MODEL_02
               WHERE ACCT_MONTH = V_LAST_MONTH
              UNION ALL
              SELECT AREA_NO, USER_NO, device_number,promotion_id,promotion_name,to_char(eff_date,'yyyymm'),to_char(exp_date,'yyyymm'),PRESENT_FEE FROM MID_RED_MODEL_01)
       GROUP BY AREA_NO, USER_NO,device_number,promotion_id,promotion_name,eff_date,exp_date;
    COMMIT;
  END LOOP;

/*  FOR V_NUM IN 201801 .. 201807 LOOP
    V_MONTH      := TO_CHAR(V_NUM);
    V_LAST_MONTH := TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH, 'YYYYMM'), -1),
                            'YYYYMM');
    V_LAST_M3    := TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH, 'YYYYMM'), -3),
                            'YYYYMM');
    --自由模式红包
    EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_RED_MODEL_00';
    insert into MID_RED_MODEL_00
    SELECT A.USER_NO, A.USER_DINNER, B.ATTR_VALUE
      FROM (SELECT USER_NO, USER_DINNER
              FROM DW.DW_V_USER_BASE_INFO_USER A
             WHERE ACCT_MONTH = v_month
               AND TELE_TYPE = '2') A,
           (SELECT * FROM DIM.DIM_REDBAG_NO WHERE FLAG = '2') B
     WHERE A.USER_DINNER = B.PROMOTION_ID;
    COMMIT;
    
    --当月非自由红包模式返还情况
    EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_RED_MODEL_01';
    INSERT INTO MID_RED_MODEL_01
      SELECT A.AREA_NO,
             A.USER_NO,
             A.PRESENT_FEE,
             A.PROMOTION_ID,
             A.PROMOTION_NAME,
             A.EFF_DATE,
             A.EXP_DATE,
             A.REBAT_CNT,
             CASE
               WHEN B.ATTR_VALUE = 0 THEN
                C.ATTR_VALUE * REBAT_CNT  --自由模式
               ELSE
                B.ATTR_VALUE * REBAT_CNT
             END AS PRESENT_FEE_LJ,
             a.device_number
        FROM (SELECT A.*,
                     CEIL(MONTHS_BETWEEN(TO_DATE(ACCT_MONTH, 'YYYYMM'),
                                         CASE
                                           WHEN TO_CHAR(EFF_DATE, 'DD') = '01' THEN
                                            EFF_DATE - 1
                                           ELSE
                                            EFF_DATE
                                         END)) REBAT_CNT
                FROM DW.DW_V_USER_POLICY_PRESENT_FEE A
               WHERE ACCT_MONTH = V_MONTH
                 AND PROMOTION_TYPE_NAME = '翼支付红包卡') A,
             (SELECT * FROM DIM.DIM_REDBAG_NO WHERE FLAG = '1') B,
             MID_RED_MODEL_00 C
       WHERE A.PROMOTION_ID = B.PROMOTION_ID(+)
         AND A.USER_NO = C.USER_NO(+);
    COMMIT;
  
\*      UPDATE MID_RED_MODEL_01 SET REBAT_CNT=1 WHERE REBAT_CNT=0 OR REBAT_CNT IS NULL;
      commit;
    UPDATE MID_RED_MODEL_01 SET  PRESENT_FEE_LJ=PRESENT_FEE*REBAT_CNT;
    commit;*\
  
    DELETE FROM MID_RED_MODEL_02 WHERE ACCT_MONTH IN (V_MONTH, V_LAST_M3);
    COMMIT;
  
    INSERT INTO MID_RED_MODEL_02
      SELECT V_MONTH, AREA_NO, USER_NO,device_number,promotion_id,promotion_name,eff_date,exp_date, SUM(PRESENT_FEE_LJ)
        FROM (SELECT AREA_NO, USER_NO, device_number，promotion_id,promotion_name, eff_date,exp_date,PRESENT_FEE_LJ
                FROM MID_RED_MODEL_02
               WHERE ACCT_MONTH = V_LAST_MONTH
              UNION ALL
              SELECT AREA_NO, USER_NO, device_number,promotion_id,promotion_name,to_char(eff_date,'yyyymm'),to_char(exp_date,'yyyymm'),PRESENT_FEE FROM MID_RED_MODEL_01)
       GROUP BY AREA_NO, USER_NO,device_number,promotion_id,promotion_name,eff_date,exp_date;
    COMMIT;
  END LOOP;*/
END;



create table xxhb_mjh.tmp_redbag_hz_01 as 
SELECT A.AREA_NO,
       A.USER_NO,
       A.DEVICE_NUMBER,
       A.PRESENT_FEE,
       A.PROMOTION_ID,
       A.PROMOTION_NAME,
       B.EFF_DATE,
       B.EXP_DATE,
       A.PRESENT_FEE_LJ 应返累计,
       B.PRESENT_FEE_LJ 实返累计
  FROM (SELECT *
          FROM (SELECT A.*,
                       ROW_NUMBER() OVER(PARTITION BY USER_NO, PROMOTION_ID, PROMOTION_NAME ORDER BY 1) RN
                  FROM alldm.MID_RED_MODEL_01 A)
         WHERE RN = 1) A,
       (SELECT *
          FROM (SELECT A.*,
                       ROW_NUMBER() OVER(PARTITION BY USER_NO, PROMOTION_ID ORDER BY eff_date desc) RN
                  FROM alldm.MID_RED_MODEL_02 A)
         WHERE RN = 1) B
 WHERE A.USER_NO = B.USER_NO
   AND A.PROMOTION_ID = B.PROMOTION_ID;
 
select count(*),count(distinct user_no) from  XXHB_MJH.tmp_redbag_hz_01 T WHERE  T.实返累计-T.应返累计 >present_fee*3


select count(*) from  XXHB_MJH.tmp_redbag_hz_01 T WHERE  T.实返累计-T.应返累计 > present_fee*3
and not exists 
(select 1 from XXHB_MJH.tmp_redbag_hz_01 x where x.promotion_name like '%自由%'
and t.user_no=x.user_no) 



全省截止7月份累计实返大于累计应返共计2.9万，差异大于一个月应返有0.28万，差异大于2倍0.14万，差异大于3倍1017户


--异常号码 如：17367698579  剔除自由模式
CREATE TABLE XXHB_MJH.TMP_REDBAG_OUT AS 
SELECT B.AREA_NO_DESC,
       B.CITY_NO_DESC,
       B.DEVICE_NUMBER,
       A.PROMOTION_ID,
       A.PROMOTION_NAME,
       B.USER_DINNER,
       B.USER_DINNER_DESC,
       A.应返累计,
       A.实返累计
  FROM (SELECT B.*
          FROM XXHB_MJH.TMP_REDBAG_HZ_01 B
         WHERE B.实返累计 - B.应返累计 > B.PRESENT_FEE*3) A,
       (SELECT AREA_NO_DESC,
               CITY_NO_DESC,
               USER_NO,
               DEVICE_NUMBER,
               USER_DINNER,
               USER_DINNER_DESC
          FROM DW.DW_V_USER_BASE_INFO_USER B
         WHERE ACCT_MONTH = '201807'
           AND TELE_TYPE = '2') B
 WHERE A.USER_NO = B.USER_NO;

--导出
select 
area_no_desc 分公司, 
city_no_desc 区县, 
device_number 号码, 
promotion_id 政策ID, 
promotion_name 政策名称, 
user_dinner 套餐ID, 
user_dinner_desc 套餐名称, 
应返累计, 
实返累计
 from XXHB_MJH.TMP_REDBAG_OUT
 
--剔除自由模式
SELECT B.AREA_NO_DESC,
       B.CITY_NO_DESC,
       B.DEVICE_NUMBER,
       --A.PROMOTION_ID,
       --A.PROMOTION_NAME,
       A.应返累计,
       A.实返累计
  FROM (SELECT B.*
          FROM (SELECT USER_NO
                  FROM XXHB_MJH.TMP_RED_HS_01
                 GROUP BY USER_NO
                HAVING COUNT(*) = 1) A,
               XXHB_MJH.TMP_RED_HS_01 B
         WHERE A.USER_NO = B.USER_NO
              --AND B.AREA_NO = '188'
              --AND B.DEVICE_NUMBER='17367698579'
           AND B.实返累计 - B.应返累计 > B.PRESENT_FEE * 3) A,
       (SELECT AREA_NO_DESC, CITY_NO_DESC, USER_NO, DEVICE_NUMBER
          FROM DW.DW_V_USER_BASE_INFO_USER B
         WHERE ACCT_MONTH = '201807'
           AND TELE_TYPE = '2'
        --AND AREA_NO = '188'
        ) B
 WHERE A.USER_NO = B.USER_NO




