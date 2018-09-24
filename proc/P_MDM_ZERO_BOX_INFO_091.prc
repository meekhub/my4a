CREATE OR REPLACE PROCEDURE P_MDM_ZERO_BOX_INFO(V_MONTH   VARCHAR2,
                                                V_RETCODE OUT VARCHAR2,
                                                V_RETINFO OUT VARCHAR2) IS
  /*****************************************************************
  *名称 --%NAME: P_INTEGRAL_SYS_DEVLP_JF_M
  *功能描述 --%COMMENT: 零箱体
  *执行周期 --%PERIOD: 月
  *参数 --%PARAM:V_MONTH  日期,格式YYYYMM
  *参数 --%PARAM:V_RETCODE  过程运行结束成功与否标志
  *参数 --%PARAM:V_RETCODE  过程运行结束成功与否描述
  *创建人 --%CREATOR: LIYA
  *创建时间 --%CREATED_TIME:2018.8.22
  *备注 --%REMARK:
  *来源表 --%FROM:
  *目标表 --%TO:
  *修改记录 --%MODIFY:
  *******************************************************************/
  V_PKG        VARCHAR2(40);
  V_PROCNAME   VARCHAR2(40);
  V_COUNT      NUMBER := 0;
  V_LAST_MONTH VARCHAR2(40);

BEGIN
  V_PKG        := '零箱体';
  V_PROCNAME   := 'P_MDM_ZERO_BOX_INFO';
  V_LAST_MONTH := TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH, 'YYYYMM'), -1),
                          'YYYYMM');

  --日志部分
  ALLDM.P_ALLDM_INSERT_LOG(V_MONTH, V_PKG, V_PROCNAME, '12', SYSDATE);
  ---------------------------------------------------------------
  -- 数据部分

  SELECT COUNT(1)
    INTO V_COUNT
    FROM DW.DW_EXECUTE_LOG
   WHERE ACCT_MONTH = V_MONTH
     AND RESULT = 'SUCCESS'
     AND PROCNAME IN ('P_DW_V_USER_ZERO_BOX_M', 'P_DW_V_BOX_INFO_M');
  COMMIT;

  IF V_COUNT >= 2 THEN
  
    --分光器最早入网时间
    EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_ZERO_FGQ_INFO';
    INSERT /*+APPEND*/
    INTO MID_ZERO_FGQ_INFO
      SELECT BOX_NAME,
             FGQ_DATE,
             STANDARD_ID,
             STANDARD_NAME,
             XM_NO,
             RN,
             BOX_ID
        FROM (SELECT BOX_NAME,
                     FGQ_DATE,
                     STANDARD_ID,
                     STANDARD_NAME,
                     PROJECT_ID XM_NO,
                     BOX_ID,
                     ROW_NUMBER() OVER(PARTITION BY BOX_NAME ORDER BY FGQ_DATE ASC) RN
                FROM DW.DW_V_BOX_INFO_M
               WHERE ACCT_MONTH = V_MONTH)
       WHERE RN = 1;
    COMMIT;
  
    --箱体端口占用情况
    EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_ZERO_FGQ_BASE';
    INSERT /*+APPEND*/
    INTO MID_ZERO_FGQ_BASE
      SELECT BOX_ID,
             BOX_NAME，SUM(CASE
                            WHEN TRIM(TRANSLATE(T.DK_NUMBER, '.0123456789', ' ')) IS NULL THEN
                             DK_NUMBER
                            ELSE
                             '0'
                          END) DK_NUMBER,
             SUM(CASE
                   WHEN TRIM(TRANSLATE(T.DK_USE_NUMBER, '.0123456789', ' ')) IS NULL THEN
                    DK_USE_NUMBER
                   ELSE
                    '0'
                 END) DK_USE_NUMBER
        FROM DW.DW_V_BOX_INFO_M T
       WHERE ACCT_MONTH = V_MONTH
       GROUP BY BOX_ID, BOX_NAME;
    COMMIT;
  
    --生成所有箱体中间表
    EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_ZERO_BOX_BASE_INFO';
    INSERT /*+APPEND*/
    INTO MID_ZERO_BOX_BASE_INFO
      SELECT V_MONTH,
             F.AREA_NO,
             G.CITY_NO,
             E.HUAXIAO_NO,
             E.HUAXIAO_NAME,
             E.XIAOQU_NO,
             E.XIAOQU_NAME,
             A.BOX_ID,
             A.BOX_NAME,
             A.FGQ_DATE,
             A.STANDARD_ID,
             T.STDADDR_NAME,
             SUM(H.KD_USER) KD_USER,
             SUM(H.RUZHU_USER) FG_USERS,
             CASE
               WHEN K.DK_USE_NUMBER = 0 THEN
                '1'
               ELSE
                '0'
             END IS_ZERO
        FROM MID_ZERO_FGQ_INFO A,
             (SELECT /*+PARALLEL(T,10)*/
               TO_CHAR(ID) ID,
               GRADE_3,
               T.GRADE_0 || '/' || T.GRADE_1 || '/' || T.GRADE_2 || '/' ||
               T.GRADE_3 || '/' || T.GRADE_4 STDADDR_NAME
                FROM DW.DATMT_GIS_STANDARDADDRESS_QE T) T,
             (SELECT * FROM ALLDMCODE.DMCODE_XIAOQU_STD_ADDR_NEW) C,
             DIM.DIM_XIAOQU_HUAXIAO E,
             DIM.DIM_AREA_NO F,
             DIM.DIM_CITY_NO G， (SELECT SUBDISTRICT_ID AS XIAOQU_NO,
                                        SUBDISTRICT_NAME AS XIAOQU_NAME,
                                        SUM(NET_NUM) KD_USER,
                                        SUM(FAMILY_NUM) RUZHU_USER
                                   FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
                                  WHERE DAY_ID = '20180731'
                                  GROUP BY SUBDISTRICT_ID, SUBDISTRICT_NAME) H,
             MID_ZERO_FGQ_BASE K
       WHERE A.STANDARD_ID = T.ID
         AND T.STDADDR_NAME = C.STDADDR_NAME
         AND C.XIAOQU_NO = E.XIAOQU_NO
         AND E.AREA_NO = F.AREA_NO
         AND E.CITY_NO = G.CITY_NO
         AND C.XIAOQU_NO = H.XIAOQU_NO(+)
         AND A.BOX_ID = K.BOX_ID(+)
       GROUP BY F.AREA_NO,
                G.CITY_NO,
                E.HUAXIAO_NO,
                E.HUAXIAO_NAME,
                E.XIAOQU_NO,
                E.XIAOQU_NAME,
                A.BOX_ID,
                A.BOX_NAME,
                A.FGQ_DATE,
                A.STANDARD_ID,
                T.STDADDR_NAME,
                CASE
                  WHEN K.DK_USE_NUMBER = 0 THEN
                   '1'
                  ELSE
                   '0'
                END;
    COMMIT;
    --零箱体明细
    DELETE FROM DM_ZERO_BOX_BASE_INFO WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
    INSERT /*+APPEND*/
    INTO DM_ZERO_BOX_BASE_INFO
      SELECT ACCT_MONTH,
             FUNC_GET_XIONGAN_AREA_NO(AREA_NO, CITY_NO) AREA_NO,
             CITY_NO,
             HUAXIAO_NO,
             HUAXIAO_NAME,
             XIAOQU_NO,
             XIAOQU_NAME,
             BOX_ID,
             BOX_NAME,
             INNET_DATE,
             STANDARD_ID,
             STANDARD_NAME,
             KD_CNT,
             FG_CNT,
             ''
        FROM MID_ZERO_BOX_BASE_INFO
       WHERE IS_ZERO = '1';
    COMMIT;
  
    --零箱体统计
    DELETE FROM DM_ZERO_BOX_HZ_INFO WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
  
    INSERT /*+APPEND*/
    INTO DM_ZERO_BOX_HZ_INFO
      SELECT V_MONTH V_MONTH,
             FUNC_GET_XIONGAN_AREA_NO(A.AREA_NO, CITY_NO) AREA_NO,
             A.CITY_NO,
             A.HUAXIAO_NO,
             A.HUAXIAO_NAME,
             A.XIAOQU_NO,
             A.XIAOQU_NAME,
             CASE WHEN SUBSTR(A.INNET_DATE, 1, 4) >= '2018' THEN '新' ELSE '老' END， COUNT(DISTINCT CASE WHEN A.IS_ZERO = '1' THEN A.BOX_NAME END),
             COUNT(DISTINCT A.BOX_NAME),
             SUM(A.KD_CNT),
             SUM(A.FG_CNT)
        FROM MID_ZERO_BOX_BASE_INFO A
       GROUP BY FUNC_GET_XIONGAN_AREA_NO(A.AREA_NO, CITY_NO),
                A.CITY_NO,
                A.HUAXIAO_NO,
                A.HUAXIAO_NAME,
                A.XIAOQU_NO,
                A.XIAOQU_NAME,
                CASE
                  WHEN SUBSTR(A.INNET_DATE, 1, 4) >= '2018' THEN
                   '新'
                  ELSE
                   '老'
                END;
    COMMIT;
  
    --1箱体明细
    DELETE FROM DM_ONE_BOX_BASE_INFO WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
  
    INSERT /*+APPEND*/
    INTO DM_ONE_BOX_BASE_INFO
      SELECT ACCT_MONTH,
             FUNC_GET_XIONGAN_AREA_NO(A.AREA_NO, CITY_NO) AREA_NO,
             CITY_NO,
             HUAXIAO_NO,
             HUAXIAO_NAME,
             XIAOQU_NO,
             XIAOQU_NAME,
             BOX_ID,
             BOX_NAME,
             INNET_DATE,
             STANDARD_ID,
             STANDARD_NAME,
             KD_CNT,
             FG_CNT
        FROM MID_ZERO_BOX_BASE_INFO A
       WHERE EXISTS (SELECT 1
                FROM MID_ZERO_FGQ_BASE B
               WHERE A.BOX_ID = B.BOX_ID
                 AND B.DK_USE_NUMBER = 1);
    COMMIT;
  
    --1箱体统计
    DELETE FROM DM_ONE_BOX_HZ_INFO WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
  
    INSERT /*+APPEND*/
    INTO DM_ONE_BOX_HZ_INFO
      SELECT V_MONTH V_MONTH,
             FUNC_GET_XIONGAN_AREA_NO(A.AREA_NO, A.CITY_NO) AREA_NO,
             A.CITY_NO,
             A.HUAXIAO_NO,
             A.HUAXIAO_NAME,
             A.XIAOQU_NO,
             A.XIAOQU_NAME,
             CASE WHEN SUBSTR(A.INNET_DATE, 1, 4) >= '2018' THEN '新' ELSE '老' END， COUNT(DISTINCT B.BOX_NAME),
             COUNT(DISTINCT A.BOX_NAME),
             SUM(A.KD_CNT),
             SUM(A.FG_CNT)
        FROM MID_ZERO_BOX_BASE_INFO A,
             (SELECT * FROM MID_ZERO_FGQ_BASE WHERE DK_USE_NUMBER = 1) B
       WHERE A.BOX_ID = B.BOX_ID(+)
       GROUP BY FUNC_GET_XIONGAN_AREA_NO(A.AREA_NO, A.CITY_NO),
                A.CITY_NO,
                A.HUAXIAO_NO,
                A.HUAXIAO_NAME,
                A.XIAOQU_NO,
                A.XIAOQU_NAME,
                CASE
                  WHEN SUBSTR(A.INNET_DATE, 1, 4) >= '2018' THEN
                   '新'
                  ELSE
                   '老'
                END;
    COMMIT;
  
    --箱体扩容预警表（超70%的列入此表）
    DELETE FROM DM_ALARM_BOX_BASE_INFO WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
  
    INSERT /*+APPEND*/
    INTO DM_ALARM_BOX_BASE_INFO
      SELECT V_MONTH ACCT_MONTH,
             FUNC_GET_XIONGAN_AREA_NO(A.AREA_NO, A.CITY_NO) AREA_NO,
             A.CITY_NO,
             A.HUAXIAO_NO,
             A.HUAXIAO_NAME,
             A.XIAOQU_NO,
             A.XIAOQU_NAME,
             A.BOX_NAME,
             B.DK_NUMBER,
             B.DK_USE_NUMBER,
             B.DK_NUMBER - B.DK_USE_NUMBER AS UNUSE_CNT
        FROM MID_ZERO_BOX_BASE_INFO A, MID_ZERO_FGQ_BASE B
       WHERE A.BOX_ID = B.BOX_ID
         AND B.DK_NUMBER > 0
         AND B.DK_USE_NUMBER / B.DK_NUMBER > 0.7;
    COMMIT;
  
    --零箱体整治效果后评估（区分新老项目）
    EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_ZERO_EVAL_BOX';
    INSERT /*+APPEND*/
    INTO MID_ZERO_EVAL_BOX
      SELECT DISTINCT X.BOX_NAME, Y.FGQ_NAME, Y.FGQ_ID, Y.BOX_ID
        FROM (SELECT A.BOX_ID, A.BOX_NAME
                FROM (SELECT *
                        FROM ALLDM.DM_ZERO_BOX_BASE_INFO
                       WHERE ACCT_MONTH = V_LAST_MONTH) A,
                     (SELECT *
                        FROM ALLDM.DM_ZERO_BOX_BASE_INFO
                       WHERE ACCT_MONTH = V_MONTH) B
               WHERE A.AREA_NO = B.AREA_NO(+)
                 AND A.CITY_NO = B.CITY_NO(+)
                 AND A.BOX_ID = B.BOX_ID(+)
                 AND B.BOX_NAME IS NULL) X,
             (SELECT DISTINCT BOX_ID, BOX_NAME, FGQ_NAME, FGQ_ID
                FROM DW.DW_V_BOX_INFO_M
               WHERE ACCT_MONTH = V_MONTH) Y
       WHERE X.BOX_ID = Y.BOX_ID;
    COMMIT;
  
    --沉淀分光器下挂用户明细
    EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_FGQ_USER_MX';
    INSERT /*+APPEND*/
    INTO MID_FGQ_USER_MX
      SELECT UPPER(SERVICE_CODE) DEVICE_NUMBER,
             RESNAME AS FGQ_NAME，RESID AS FGQ_ID
        FROM DW.DW_V_USER_ZERO_BOX_KD_M
       WHERE ACCT_MONTH = V_MONTH
         AND ATTRIBUTENAME IN ('分光器名称');
    COMMIT;
  
    --当月新增用户明细
    DELETE FROM MID_ZERO_BOX_USER WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
    INSERT /*+APPEND*/
    INTO MID_ZERO_BOX_USER
      SELECT DISTINCT V_MONTH ACCT_MONTH,
                      A.BOX_NAME,
                      A.FGQ_NAME,
                      B.DEVICE_NUMBER,
                      A.FGQ_ID,
                      A.BOX_ID
        FROM MID_ZERO_EVAL_BOX A, MID_FGQ_USER_MX B
       WHERE A.FGQ_NAME = B.FGQ_NAME;
    COMMIT;
  
    --沉淀对应用户明细
    EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_ZERO_BOX_ACCOUNT';
    INSERT /*+APPEND*/
    INTO MID_ZERO_BOX_ACCOUNT
      SELECT DISTINCT A.ACCT_MONTH,
                      ACCOUNT_NO,
                      BOX_NAME,
                      FGQ_NAME,
                      FGQ_ID,
                      BOX_ID
        FROM (SELECT DISTINCT ACCT_MONTH,
                              BOX_ID,
                              BOX_NAME,
                              FGQ_ID,
                              FGQ_NAME,
                              DEVICE_NUMBER
                FROM MID_ZERO_BOX_USER) A,
             (SELECT ACCOUNT_NO,
                     TOTAL_FEE,
                     USER_NO,
                     DEVICE_NUMBER,
                     MONTH_FEE
                FROM DW.DW_V_USER_BASE_INFO_USER B
               WHERE ACCT_MONTH = V_MONTH
                 AND TELE_TYPE IN ('4', '26')) B
       WHERE A.DEVICE_NUMBER = B.DEVICE_NUMBER(+);
    COMMIT;
  
    --剔重
    EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_ZERO_BOX_ACCOUNT_2';
    INSERT /*+APPEND*/
    INTO MID_ZERO_BOX_ACCOUNT_2
      SELECT ACCT_MONTH, ACCOUNT_NO, BOX_NAME, FGQ_NAME, FGQ_ID, BOX_ID
        FROM (SELECT A.*,
                     ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO ORDER BY ACCT_MONTH DESC) RN
                FROM MID_ZERO_BOX_ACCOUNT A)
       WHERE RN = 1;
    COMMIT;
  
    --沉淀收入
    EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_ZERO_BOX_FEE';
    INSERT /*+APPEND*/
    INTO MID_ZERO_BOX_FEE
      SELECT B.ACCT_MONTH,
             A.ACCT_MONTH AS REG_DATE,
             A.BOX_NAME,
             A.FGQ_NAME,
             B.ACCOUNT_NO,
             B.USER_NO,
             B.DEVICE_NUMBER,
             SUM(B.TOTAL_FEE + B.TOTAL_FEE_OCS) TOTAL_FEE,
             A.FGQ_ID,
             A.BOX_ID
        FROM MID_ZERO_BOX_ACCOUNT_2 A,
             (SELECT NVL(BUNDLE_ID_ALLOWANCE, BUNDLE_ID) AS BUNDLE_ID,
                     TOTAL_FEE,
                     TOTAL_FEE_OCS,
                     USER_NO,
                     DEVICE_NUMBER,
                     ACCT_MONTH,
                     ACCOUNT_NO
                FROM DW.DW_V_USER_BASE_INFO_USER B
               WHERE ACCT_MONTH = V_MONTH
                 AND IS_ONNET = '1') B
       WHERE A.ACCOUNT_NO = B.ACCOUNT_NO
       GROUP BY B.ACCT_MONTH,
                A.ACCT_MONTH,
                A.BOX_NAME,
                A.FGQ_NAME,
                B.ACCOUNT_NO,
                B.USER_NO,
                B.DEVICE_NUMBER,
                A.FGQ_ID,
                A.BOX_ID;
    COMMIT;
  
    --写入汇总表
    DELETE FROM DM_BOX_EFFECT_EVAL WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
  
    INSERT /*+APPEND*/
    INTO DM_BOX_EFFECT_EVAL
      SELECT V_MONTH,
             AREA_NO,
             CITY_NO,
             HUAXIAO_NO,
             HUAXIAO_NAME,
             XIAOQU_NO,
             XIAOQU_NAME,
             PROJECT_TYPE,
             SUM(MINUS_CNT),
             SUM(DEV_CNT),
             SUM(MINUS_FEE),
             SUM(MINUS_CNT_LJ),
             SUM(DEV_CNT_LJ),
             SUM(MINUS_FEE_LJ)
        FROM (SELECT FUNC_GET_XIONGAN_AREA_NO(A.AREA_NO, A.CITY_NO) AREA_NO,
                     A.CITY_NO,
                     A.HUAXIAO_NO,
                     A.HUAXIAO_NAME,
                     A.XIAOQU_NO,
                     A.XIAOQU_NAME,
                     CASE
                       WHEN SUBSTR(A.INNET_DATE, 1, 4) >= '2018' THEN
                        '新'
                       ELSE
                        '老'
                     END PROJECT_TYPE,
                     COUNT(DISTINCT CASE
                             WHEN B.REG_DATE = V_MONTH THEN
                              A.BOX_NAME
                           END) MINUS_CNT,
                     COUNT(DISTINCT CASE
                             WHEN B.REG_DATE = V_MONTH THEN
                              B.USER_NO
                           END) DEV_CNT,
                     SUM(CASE
                           WHEN B.REG_DATE = V_MONTH THEN
                            B.TOTAL_FEE
                           ELSE
                            0
                         END) MINUS_FEE,
                     COUNT(DISTINCT A.BOX_NAME) MINUS_CNT_LJ,
                     COUNT(DISTINCT B.USER_NO) DEV_CNT_LJ,
                     SUM(B.TOTAL_FEE) MINUS_FEE_LJ
                FROM MID_ZERO_BOX_BASE_INFO A, MID_ZERO_BOX_FEE B
               WHERE A.BOX_ID = B.BOX_ID
               GROUP BY FUNC_GET_XIONGAN_AREA_NO(A.AREA_NO, A.CITY_NO),
                        A.CITY_NO,
                        A.HUAXIAO_NO,
                        A.HUAXIAO_NAME,
                        A.XIAOQU_NO,
                        A.XIAOQU_NAME,
                        CASE
                          WHEN SUBSTR(A.INNET_DATE, 1, 4) >= '2018' THEN
                           '新'
                          ELSE
                           '老'
                        END
              UNION ALL
              SELECT AREA_NO,
                     CITY_NO,
                     HUAXIAO_NO,
                     HUAXIAO_NAME,
                     XIAOQU_NO,
                     XIAOQU_NAME,
                     PROJECT_TYPE,
                     0            MINUS_CNT,
                     0            DEV_CNT,
                     0            MINUS_FEE,
                     MINUS_CNT_LJ,
                     DEV_CNT_LJ,
                     MINUS_FEE_LJ
                FROM DM_BOX_EFFECT_EVAL
               WHERE ACCT_MONTH = V_LAST_MONTH)
       GROUP BY AREA_NO, CITY_NO, HUAXIAO_NO, HUAXIAO_NAME, PROJECT_TYPE;
  
    COMMIT;
  
    --各模型效果评估
  
    EXECUTE IMMEDIATE 'TRUNCATE TABLE INJECT_EVALUATE_INFO';
    INSERT /*+APPEND*/
    INTO INJECT_EVALUATE_INFO
      SELECT V_MONTH,
             MODEL_NAME,
             MODEL_CNT,
             SMS_CNT,
             MAIL_CNT,
             SYS_CNT,
             SMS_CNT_LM,
             MAIL_CNT_LM,
             SYS_CNT_LM
        FROM INJECT_EVALUATE_INFO
       WHERE ACCT_MONTH = V_LAST_MONTH;
    COMMIT;
  
    --异常PUE
    DELETE FROM ELEC_STATION_ALARM_M WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
  
    INSERT /*+APPEND*/
    INTO ELEC_STATION_ALARM_M
      SELECT V_MONTH,
             B.AREA_NO,
             A.AREA_NAME,
             A.GROUP_NAME,
             --A.ROOM_ID,
             A.ROOM_NAME,
             SUM(A.ELEC_AMOUNT) ELEC_AMOUNT,
             SUM(A.DEVICE_AMOUNT) DEVICE_AMOUNT,
             ROUND(SUM(A.ELEC_AMOUNT) / SUM(A.DEVICE_AMOUNT), 2) AS "PUE"
        FROM ALLDM.ELEC_STATION_D A, DIM.DIM_AREA_NO B
       WHERE ACCT_MONTH = V_MONTH
         AND A.AREA_NAME = B.AREA_DESC
         AND A.DEVICE_AMOUNT > 0
       GROUP BY B.AREA_NO,
                A.AREA_NAME,
                A.GROUP_NAME,
                A.ROOM_ID,
                A.ROOM_NAME
      HAVING SUM(A.ELEC_AMOUNT) / SUM(A.DEVICE_AMOUNT) >= 2;
    COMMIT;
    --更新日志
    V_RETCODE := 'SUCCESS';
    ALLDM.P_ALLDM_UPDATE_LOG(V_MONTH,
                             V_PKG,
                             V_PROCNAME,
                             '结束',
                             V_RETCODE,
                             SYSDATE);
    DBMS_OUTPUT.PUT_LINE(V_RETCODE);
    ------------------------------------- 数据部分结束 -------------------------
  ELSE
    V_RETCODE := 'WAIT';
    ALLDM.P_ALLDM_UPDATE_LOG(V_MONTH,
                             V_PKG,
                             V_PROCNAME,
                             '等待',
                             'WAIT',
                             SYSDATE);
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    V_RETCODE := 'FAIL';
    V_RETINFO := SQLERRM;
    ALLDM.P_ALLDM_UPDATE_LOG(V_MONTH,
                             V_PKG,
                             V_PROCNAME,
                             V_RETINFO,
                             V_RETCODE,
                             SYSDATE);
END;
/
