CREATE OR REPLACE PROCEDURE P_INTEGRAL_SYS_WEIXI_JF_M(V_MONTH   VARCHAR2,
                                                      V_RETCODE OUT VARCHAR2,
                                                      V_RETINFO OUT VARCHAR2) IS
  /*****************************************************************
  *名称 --%NAME: P_INTEGRAL_SYS_DEVLP_JF_M
  *功能描述 --%COMMENT:
  *执行周期 --%PERIOD: 月
  *参数 --%PARAM:V_MONTH  日期,格式YYYYMMDD
  *参数 --%PARAM:V_RETCODE  过程运行结束成功与否标志
  *参数 --%PARAM:V_RETCODE  过程运行结束成功与否描述
  *创建人 --%CREATOR: LIYA
  *创建时间 --%CREATED_TIME:20170710
  *备注 --%REMARK:
  *来源表 --%FROM:
  *目标表 --%TO:
  *修改记录 --%MODIFY:
  *******************************************************************/
  V_PKG      VARCHAR2(40);
  V_PROCNAME VARCHAR2(40);
  V_COUNT    NUMBER := 0;
  --V_MONTH      VARCHAR2(40);
  V_LAST_MONTH VARCHAR2(40);
  --V_DAY        VARCHAR2(40);
  V_LAST_DAY VARCHAR2(40);

  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO NOT IN ('018');

BEGIN
  V_PKG      := '渠道积分体系';
  V_PROCNAME := 'P_INTEGRAL_SYS_WEIXI_JF_M';
  --V_MONTH      := SUBSTR(V_MONTH, 1, 6);
  ---V_DAY        := SUBSTR(V_MONTH, 7, 2);
  V_LAST_DAY   := TO_CHAR(LAST_DAY(TO_DATE(V_MONTH, 'YYYYMM')), 'DD');
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
     AND PROCNAME IN
         ('P_DW_V_USER_BASE_INFO_USER', 'P_DW_V_USER_PAY_LOG_MONTH');
  COMMIT;

  IF V_COUNT = 2 THEN
    EXECUTE IMMEDIATE 'ALTER TABLE ALLDM.INTEGRAL_SYS_WEIXI_JF_DETAIL TRUNCATE PARTITION PART_' ||
                      V_MONTH;
  
    FOR C1 IN V_AREA LOOP
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_WEIXI_JF_ZC';
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_WEIXI_JF_ZC_1';
      /*      --移动缴赠业务积分
      INSERT INTO MID_WEIXI_JF_ZC
        SELECT AREA_NO, USER_NO, REAL_PRICE
          FROM DW.DW_V_USER_BASE_INFO_PROTOCOL A
         WHERE ACCT_MONTH = V_MONTH
           AND AREA_NO = C1.AREA_NO
           AND TO_CHAR(BEGIN_DATE, 'YYYYMM') = V_MONTH
           AND (END_DATE IS NULL OR TO_CHAR(END_DATE, 'YYYYMM') > V_MONTH)
           AND EXISTS
           (SELECT 1 FROM DIM.DIM_SALES_MODE_CL B WHERE A.SALES_MODE=B.KIND);  --存量提供的政策ID
      COMMIT;*/
    
      --当月受理信息
      /*      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_JF_WEIXI_ZZ_01';
      INSERT INTO MID_JF_WEIXI_ZZ_01
        SELECT ACCEPT_PERSON,
               DEALER_ID,
               ACCEPT_DATE,
               COMPLETE_DATE,
               CUST_ORDER_ID,
               USER_NO
          FROM ODS.O_PRD_BUS_INFO_D@HBODS T
         WHERE HOME_CITY = C1.AREA_NO
           AND ACCEPT_DATE >= TO_DATE(V_MONTH, 'YYYYMM')
           AND ACCEPT_DATE < ADD_MONTHS(TO_DATE(V_MONTH, 'YYYYMM'), 1);
      COMMIT;
      --找到实例对应的订单 EFF_ORDER_ITEM_ID
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_JF_WEIXI_ZZ_02';
      INSERT INTO MID_JF_WEIXI_ZZ_02
        SELECT B.EFF_ORDER_ITEM_ID,
               B.PROD_OFFER_INST_ID,
               B.PROD_OFFER_ID,
               NVL(A.PAY_FEE, 0)
          FROM DIM.DIM_SALES_MODE_CL A
          LEFT JOIN (SELECT EFF_ORDER_ITEM_ID,
                            PROD_OFFER_INST_ID,
                            PROD_OFFER_ID
                       FROM STAGE.PROD_OFFER_INST A
                      WHERE A.CITY_CODE = C1.AREA_NO
                        AND TO_CHAR(EFF_DATE, 'YYYYMM') = V_MONTH
                        AND A.PROD_OFFER_TYPE = '13') B
            ON A.KIND = B.PROD_OFFER_ID;
      COMMIT;
      --订单表
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_JF_WEIXI_ZZ_03';
      INSERT INTO MID_JF_WEIXI_ZZ_03
        SELECT ORDER_ITEM_ID, CUST_ORDER_ID
          FROM CRM_DSG.ORDER_ITEM@HBODS
         WHERE CITY_CODE = C1.AREA_NO
           AND STATUS_DATE >= TO_DATE(V_MONTH, 'YYYYMM')
           AND STATUS_DATE < ADD_MONTHS(TO_DATE(V_MONTH, 'YYYYMM'), 1);
      COMMIT;
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_JF_WEIXI_ZZ_04';
      INSERT INTO MID_JF_WEIXI_ZZ_04
        SELECT USER_ID, DEALER_ID, PROD_OFFER_ID, PKG_FEE
          FROM (SELECT A.USER_ID,
                       A.DEALER_ID,
                       C.PKG_FEE,
                       C.PROD_OFFER_ID,
                       ROW_NUMBER() OVER(PARTITION BY A.USER_ID, A.DEALER_ID ORDER BY A.COMPLETE_DATE DESC) RN
                  FROM MID_JF_WEIXI_ZZ_01 A
                  LEFT JOIN MID_JF_WEIXI_ZZ_03 B
                    ON A.CUST_ORDER_ID = B.CUST_ORDER_ID
                  LEFT JOIN MID_JF_WEIXI_ZZ_02 C
                    ON B.ORDER_ITEM_ID = C.EFF_ORDER_ITEM_ID)
         WHERE RN = 1;
      COMMIT;*/
      /*    INSERT INTO MID_JF_INCOME_ZZ_04
        SELECT A.USER_ID,
               NVL(A.SOURCE_ID, C.BELONGS_AREA) CHANNEL_NO,
               X.KIND,
               X.PAY_FEE
          FROM (SELECT *
                  FROM CRM_DSG.BB_DEVICE_RENT_INFO_T@HBODS X
                 WHERE CITY_CODE = C1.AREA_NO
                   AND BEGIN_DATE >= TO_DATE(V_MONTH, 'YYYYMM')
                   AND BEGIN_DATE < ADD_MONTHS(TO_DATE(V_MONTH, 'YYYYMM'), 1)) A,
               (SELECT *
                  FROM CRM_DSG.SALES_PROMOTION_INST@HBODS
                 WHERE CITY_CODE = C1.AREA_NO
                   AND EFF_DATE >= TO_DATE(V_MONTH, 'YYYYMM')
                   AND EFF_DATE < ADD_MONTHS(TO_DATE(V_MONTH, 'YYYYMM'), 1)) B,
               (SELECT *
                  FROM ACCT_DSG.BF_TRANSFER_ACCEPT_T@HBODS
                 WHERE CITY_CODE = C1.AREA_NO
                   AND OPERATE_DATE >= TO_DATE(V_MONTH, 'YYYYMM')
                   AND OPERATE_DATE < ADD_MONTHS(TO_DATE(V_MONTH, 'YYYYMM'), 1)) C,
               DIM.DIM_SALES_MODE_CL X
         WHERE A.PROMOTION_ID = X.KIND
           AND B.PROMOTION_INST_ID = A.PROMOTION_INST_ID(+)
           AND B.PROMOTION_INST_ID = C.PROMOTION_INST_ID(+);
      COMMIT;*/
      INSERT INTO MID_JF_INCOME_ZZ_04
        SELECT A.USER_ID, A.BELONGS_AREA, B.KIND, B.PAY_FEE
          FROM (SELECT *
                  FROM ACCT_DSG.BF_TRANSFER_ACCEPT_T@HBODS
                 WHERE CITY_CODE = C1.AREA_NO) A,
               DIM.DIM_SALES_MODE_CL B,
               (SELECT *
                  FROM CRM_DSG.SALES_PROMOTION_INST@HBODS
                 WHERE CITY_CODE = C1.AREA_NO
                   AND EFF_DATE >= TO_DATE(V_MONTH, 'YYYYMM')
                   AND EFF_DATE < ADD_MONTHS(TO_DATE(V_MONTH, 'YYYYMM'), 1)) D
         WHERE D.PROMOTION_ID = B.KIND
           AND A.PROMOTION_INST_ID = D.PROMOTION_INST_ID;
      COMMIT;
    
      INSERT INTO MID_WEIXI_JF_ZC_1
        SELECT V_MONTH,
               C1.AREA_NO,
               B.CITY_NO,
               B.TELE_TYPE,
               A.DEALER_ID,
               B.USER_NO,
               B.DEVICE_NUMBER,
               NVL(A.PKG_FEE, 0)
          FROM MID_JF_INCOME_ZZ_04 A,
               (SELECT ACCT_MONTH,
                       AREA_NO,
                       CITY_NO,
                       TELE_TYPE,
                       CHANNEL_NO,
                       USER_NO,
                       DEVICE_NUMBER
                  FROM DW.DW_V_USER_BASE_INFO_USER T
                 WHERE ACCT_MONTH = V_MONTH
                   AND AREA_NO = C1.AREA_NO
                   AND TELE_TYPE = '2') B
         WHERE A.USER_ID = B.USER_NO(+);
    
      COMMIT;
    
      ---移动套餐升档积分
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_INTEGRAL_SYS_WEIXI_JF_1';
      INSERT INTO MID_INTEGRAL_SYS_WEIXI_JF_1
        SELECT A.*, B.LOW_VALUE
          FROM (SELECT ACCT_MONTH,
                       '' DAY_ID,
                       AREA_NO,
                       CITY_NO,
                       TELE_TYPE,
                       CHANNEL_NO,
                       CHANNEL_TYPE,
                       CHANNEL_KIND,
                       USER_NO,
                       DEVICE_NUMBER,
                       IS_VALID,
                       INNET_DATE,
                       USER_DINNER,
                       USER_DINNER_DESC
                  FROM DW.DW_V_USER_BASE_INFO_USER T
                 WHERE ACCT_MONTH = V_MONTH
                      --AND DAY_ID = V_DAY
                   AND AREA_NO = C1.AREA_NO
                   AND CHANNEL_TYPE LIKE '11%'
                      --AND IS_VALID = '1'
                   AND TELE_TYPE = '2'
                /*AND TO_CHAR(SERVICE_START_DATE, 'YYYYMM') = V_MONTH*/
                ) A,
               (SELECT *
                  FROM RPT_HBTELE.SJZX_WH_DIM_USER_DINNER T
                 WHERE T.LOW_VALUE >= 59) B
         WHERE A.USER_DINNER = B.USER_DINNER;
      COMMIT;
    
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_INTEGRAL_SYS_WEIXI_JF_3';
      INSERT INTO MID_INTEGRAL_SYS_WEIXI_JF_3
        SELECT ACCT_MONTH,
               AREA_NO,
               CITY_NO,
               '1' TELE_TYPE,
               '' AGENT_ID,
               '' AGENT_NAME,
               A.CHANNEL_NO,
               A.USER_NO,
               DEVICE_NUMBER,
               A.USER_DINNER,
               A.LOW_VALUE - C.LOW_VALUE
          FROM MID_INTEGRAL_SYS_WEIXI_JF_1 A,
               (SELECT USER_NO, USER_DINNER
                  FROM DW.DW_V_USER_BASE_INFO_USER T
                 WHERE ACCT_MONTH = V_LAST_MONTH
                   AND AREA_NO = C1.AREA_NO
                   AND TELE_TYPE = '2') B,
               RPT_HBTELE.SJZX_WH_DIM_USER_DINNER C
         WHERE A.USER_NO = B.USER_NO
           AND B.USER_DINNER = C.USER_DINNER
           AND A.LOW_VALUE - C.LOW_VALUE > 0;
      COMMIT;
    
      INSERT INTO INTEGRAL_SYS_WEIXI_JF_DETAIL
        SELECT A.ACCT_MONTH,
               A.AREA_NO,
               A.CITY_NO,
               A.TELE_TYPE,
               '' AGENT_ID,
               '' AGENT_NAME,
               B.DEALER_ID CHANNEL_NO,
               A.USER_NO,
               A.DEVICE_NUMBER,
               A.USER_DINNER,
               A.LOW_VALUE
          FROM MID_INTEGRAL_SYS_WEIXI_JF_3 A
          LEFT JOIN (SELECT *
                       FROM (SELECT ACCEPT_PERSON,
                                    DEALER_ID,
                                    ACCEPT_DATE,
                                    COMPLETE_DATE,
                                    CUST_ORDER_ID,
                                    USER_NO,
                                    ROW_NUMBER() OVER(PARTITION BY USER_NO ORDER BY ACCEPT_DATE DESC) RN
                               FROM ODS.O_PRD_BUS_INFO_D@HBODS T
                              WHERE ACCT_MONTH = V_MONTH
                                AND AREA_NO = C1.AREA_NO
                                AND ACCEPT_DATE >= TO_DATE(V_MONTH, 'YYYYMM')
                                AND ACCEPT_DATE <
                                    ADD_MONTHS(TO_DATE(V_MONTH, 'YYYYMM'), 1)
                                AND APPLY_EVENT = '302')
                      WHERE RN = 1) B
            ON A.USER_NO = B.USER_NO;
    
      -------固网续约积分
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_INTEGRAL_SYS_WEIXI_KD';
      INSERT INTO MID_INTEGRAL_SYS_WEIXI_KD
        SELECT ACCT_MONTH,
               '' DAY_ID,
               AREA_NO,
               CITY_NO,
               TELE_TYPE,
               CHANNEL_NO,
               CHANNEL_TYPE,
               CHANNEL_KIND,
               USER_NO,
               DEVICE_NUMBER,
               ACCOUNT_NO --取账户级缴费
          FROM DW.DW_V_USER_BASE_INFO_USER T
         WHERE ACCT_MONTH = V_MONTH
              --AND DAY_ID = V_DAY
           AND AREA_NO = C1.AREA_NO
              --AND CHANNEL_TYPE LIKE '11%' 跟发展渠道无关
           AND IS_VALID = '1'
           AND (TELE_TYPE IN ('4', '26') AND
               INNET_METHOD IN ('1', '2', '4', '5', '15') OR
               TELE_TYPE = '72') --修改
           AND IS_KD_BUNDLE IN ('0', '03', '031', '05', '051') --修改
        --AND BILLING_FLAG = '3' 这个条件不需要
        ;
      COMMIT;
      INSERT INTO INTEGRAL_SYS_WEIXI_JF_DETAIL
        SELECT ACCT_MONTH,
               AREA_NO,
               CITY_NO,
               '2' TELE_TYPE,
               '' AGENT_ID,
               '' AGENT_NAME,
               B.PAY_CHANNEL, --取缴费渠道
               A.USER_NO,
               DEVICE_NUMBER,
               '' USER_DINNER,
               PAY_CHARGE * 0.1
          FROM (SELECT *
                  FROM (SELECT A.*,
                               ROW_NUMBER() OVER(PARTITION BY ACCTOUNT_NO ORDER BY TELE_TYPE ASC) RN
                          FROM MID_INTEGRAL_SYS_WEIXI_KD A)
                 WHERE RN = 1) A, --取账户唯一
               (SELECT PAY_CHANNEL,
                       ACCOUNT_NO ACCTOUNT_NO,
                       SUM(PAY_CHARGE) PAY_CHARGE --取账户级缴费
                  FROM DW.DW_V_USER_PAY_LOG_MONTH
                 WHERE ACCT_MONTH = V_MONTH
                   AND AREA_NO = C1.AREA_NO
                      --AND TELE_TYPE IN ('4', '26')
                   AND TO_CHAR(OPER_DATE, 'YYYYMM') = V_MONTH
                --AND PAY_CHARGE > 300  累计缴费大于300，不是单次
                 GROUP BY PAY_CHANNEL, ACCOUNT_NO
                HAVING(SUM(PAY_CHARGE)) >= 300) B
         WHERE A.ACCTOUNT_NO = B.ACCTOUNT_NO; --取账户级缴费
      COMMIT;
    
      ------移动用户续约积分
    
      INSERT INTO INTEGRAL_SYS_WEIXI_JF_DETAIL --该表用户USER_NO可能会重复，因为可能有多个政策都生效
        SELECT V_MONTH DAY_ID,
               A.AREA_NO,
               A.CITY_NO,
               '3' TELE_TYPE,
               MOBILE_AGENT,
               '' AGENT_NAME,
               A.CHANNEL_NO,
               A.USER_NO,
               '' DEVICE_NUMBER,
               A.USER_DINNER,
               LOW_VALUE * 0.1
          FROM (SELECT AREA_NO,
                       CITY_NO,
                       USER_NO,
                       USER_DINNER,
                       CHANNEL_NO,
                       MOBILE_AGENT
                  FROM ODS.O_PRD_USER_DEVICE_RENT_D@HBODS
                 WHERE ACCT_MONTH = V_MONTH
                   AND DAY_ID = V_LAST_DAY
                   AND AREA_NO = C1.AREA_NO
                   AND TO_CHAR(BEGIN_DATE, 'YYYYMM') < V_MONTH
                   AND MONTHS_BETWEEN(TO_DATE(TO_CHAR(BEGIN_DATE, 'YYYYMM'),
                                              'YYYYMM'),
                                      TO_DATE(V_MONTH, 'YYYYMM')) < 13
                   AND TO_CHAR(END_DATE, 'YYYYMM') > V_MONTH) A, --这个是连续积分，次月开始积12个月，并且政策不能失效
               (SELECT *
                  FROM DW.DW_V_USER_BASE_INFO_USER C
                 WHERE C.ACCT_MONTH = V_MONTH
                   AND C.AREA_NO = C1.AREA_NO
                   AND C.TELE_TYPE = '2'
                   AND (C.IS_ACCT = '1' OR C.IS_ACCT_OCS = '1')) C, --需判断当月是否出账
               RPT_HBTELE.SJZX_WH_DIM_USER_DINNER B
         WHERE C.USER_DINNER = B.USER_DINNER
           AND A.USER_NO = C.USER_NO;
      COMMIT;
    
      ---移动缴赠业务积分
      INSERT INTO INTEGRAL_SYS_WEIXI_JF_DETAIL
        SELECT ACCT_MONTH,
               AREA_NO,
               CITY_NO,
               '4' TELE_TYPE,
               '' AGENT_ID,
               '' AGENT_NAME,
               A.CHANNEL_NO,
               A.USER_NO,
               DEVICE_NUMBER,
               '',
               REAL_PRICE * 0.1
          FROM MID_WEIXI_JF_ZC_1 A;
      COMMIT;
    
    END LOOP;
  
    DELETE FROM INTEGRAL_SYS_WEIXI_JF_M WHERE ACCT_MONTH = V_MONTH;
    COMMIT;
  
    INSERT INTO INTEGRAL_SYS_WEIXI_JF_M
      SELECT V_MONTH,
             B.AREA_NO,
             B.CITY_NO,
             CASE
               WHEN TELE_TYPE = '1' THEN
                '移动套餐升档积分'
               WHEN TELE_TYPE = '2' THEN
                '固网续约积分'
               WHEN TELE_TYPE = '3' THEN
                '移动用户续约积分'
               WHEN TELE_TYPE = '3' THEN
                '移动缴赠业务积分'
               ELSE
                TELE_TYPE
             END TELE_TYPE,
             C.AGENT_ID,
             C.AGENT_NAME,
             B.CHANNEL_NO,
             CEIL(SUM(NVL(LOW_VALUE, 0)))
        FROM (SELECT AREA_NO,
                     CITY_NO,
                     AGENT_ID,
                     AGENT_NAME,
                     TELE_TYPE,
                     CHANNEL_NO,
                     SUM(NVL(LOW_VALUE, 0)) LOW_VALUE
                FROM INTEGRAL_SYS_WEIXI_JF_DETAIL A
               WHERE ACCT_MONTH = V_MONTH
               GROUP BY AREA_NO,
                        CITY_NO,
                        AGENT_ID,
                        AGENT_NAME,
                        CHANNEL_NO,
                        TELE_TYPE) A,
             (SELECT *
                FROM DIM.DIM_CHANNEL_NO
               WHERE CHANNEL_TYPE LIKE '11%'
              --AND VALID_STATUS = '1'
              ) B,
             (SELECT DISTINCT AGENT_ID, AGENT_NAME, CHANNEL_NO
                FROM RPT_HBTELE.DM_BUSI_CHANNEL_BUILD
               WHERE ACCT_MONTH = V_LAST_MONTH) C
       WHERE B.CHANNEL_NO = A.CHANNEL_NO(+)
         AND B.CHANNEL_NO = C.CHANNEL_NO(+)
      --AND B.VALID_STATUS = '1'
       GROUP BY B.AREA_NO,
                B.CITY_NO,
                C.AGENT_ID,
                C.AGENT_NAME,
                B.CHANNEL_NO,
                A.TELE_TYPE;
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
