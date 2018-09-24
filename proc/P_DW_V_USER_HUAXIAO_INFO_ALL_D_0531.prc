CREATE OR REPLACE PROCEDURE DW.P_DW_V_USER_HUAXIAO_INFO_ALL_D(V_DATE VARCHAR2,
                                                       V_RETCODE    OUT VARCHAR2,
                                                       V_RETINFO    OUT VARCHAR2) IS
  /*-------------------------------------------------------------------------------------------
     过 程 名 : 用户划小信息日表
     生成时间 ：2018.5.31
     编 写 人 ：MAJIANHUI
     生成周期 ：每日执行
     执行时间 :
     使用参数 ：
     修改记录 ：
  -----------------------------------------------------------------------------------------------*/
  V_PROCNAME   VARCHAR2(40);
  V_PKG        VARCHAR2(40);
  V_MONTH      VARCHAR2(40);
  V_DAY        VARCHAR2(40);
  V_CNT        NUMBER;
  ROWLINE      NUMBER := 0;
  V_LAST_MONTH VARCHAR2(40);

  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO not in ('018','728');

BEGIN

  V_PKG      := '用户划小信息日表';
  V_PROCNAME := 'P_DW_V_USER_HUAXIAO_INFO_ALL_D';

  V_MONTH      := SUBSTR(V_DATE, 1, 6);
  V_DAY        := SUBSTR(V_DATE, 7, 2);
  V_LAST_MONTH := TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH, 'YYYYMM'), -1),
                          'YYYYMM');

  --日志部分
  P_INSERT_LOG(V_DATE, V_PKG, V_PROCNAME, '12', SYSDATE);

  SELECT COUNT(1)
    INTO V_CNT
    FROM DW_EXECUTE_LOG
    WHERE ACCT_MONTH = V_DATE
     AND PROCNAME IN ('P_DW_V_USER_BASE_INFO_DAY','P_DW_V_USER_SCHOOL_HX_USER_D','P_DW_V_USER_ADSL_EIGHT_D')
     AND RESULT = 'SUCCESS';

  IF V_CNT = 3 THEN

    --数据部分
    FOR C1 IN V_AREA LOOP

      --固网融合用户【实体】
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_ST_V_USER_HUAXIAO_D';
      INSERT INTO MID_ST_V_USER_HUAXIAO_D
        SELECT /*+ORDERED*/
         V_DATE DAY_ID,
         A.AREA_NO,
         A.USER_NO,
         A.DEVICE_NUMBER,
         A.TELE_TYPE,
         A.IS_ONNET,
         A.BUNDLE_ID,
         E.XIAOQU_NO,
         E.XIAOQU_NAME,
         E.HUAXIAO_NO,
         E.HUAXIAO_NAME,
         E.HUAXIAO_TYPE,
         E.HUAXIAO_TYPE_NAME,
         BUNDLE_DINNER_BEG_DATE
          FROM (SELECT AREA_NO,
                       CITY_NO,
                       USER_NO,
                       DEVICE_NUMBER,
                       CHANNEL_NO,
                       CHANNEL_NO_DESC,
                       IS_KD_BUNDLE,
                       TELE_TYPE,
                       NVL(BUNDLE_ID_ALLOWANCE, BUNDLE_ID) AS BUNDLE_ID,
                       IS_ONNET,
                       BUNDLE_DINNER_BEG_DATE
                  FROM dw.DW_V_USER_BASE_INFO_DAY T
                 WHERE ACCT_MONTH = V_MONTH
                   AND DAY_ID = V_DAY
                   AND AREA_NO = C1.AREA_NO
                   AND TELE_TYPE <> '2'
                   AND NVL(IS_KD_BUNDLE, '0') <> '0') A,

               (SELECT USER_NO,
                       T.GRADE_0 || '/' || T.GRADE_1 || '/' || T.GRADE_2 || '/' ||
                       T.GRADE_3 || '/' || T.GRADE_4 STDADDR_NAME
                  FROM DW.DW_V_USER_ADSL_EIGHT_D T
                 WHERE ACCT_MONTH = V_MONTH
                   AND DAY_ID = V_DAY
                   AND T.AREA_NO = C1.AREA_NO
                   AND USER_NO IS NOT NULL) B,

               (SELECT * FROM ALLDMCODE.DMCODE_XIAOQU_STD_ADDR_NEW) C,

               （SELECT * FROM  DIM.DIM_XIAOQU_HUAXIAO WHERE HUAXIAO_TYPE IN ('01','02','03','04')) E  --实体
         WHERE A.USER_NO = B.USER_NO(+)
           AND B.STDADDR_NAME = C.STDADDR_NAME(+)
           AND C.XIAOQU_NO = E.XIAOQU_NO(+);


      --固网融合用户【政企】
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_ZQ_V_USER_HUAXIAO_D';
      INSERT INTO MID_ZQ_V_USER_HUAXIAO_D
        SELECT /*+ORDERED*/
         V_DATE DAY_ID,
         A.AREA_NO,
         A.USER_NO,
         A.DEVICE_NUMBER,
         A.TELE_TYPE,
         A.IS_ONNET,
         A.BUNDLE_ID,
         E.XIAOQU_NO,
         E.XIAOQU_NAME,
         E.HUAXIAO_NO,
         E.HUAXIAO_NAME,
         E.HUAXIAO_TYPE,
         E.HUAXIAO_TYPE_NAME,
         BUNDLE_DINNER_BEG_DATE
          FROM (SELECT AREA_NO,
                       CITY_NO,
                       USER_NO,
                       DEVICE_NUMBER,
                       CHANNEL_NO,
                       CHANNEL_NO_DESC,
                       IS_KD_BUNDLE,
                       TELE_TYPE,
                       NVL(BUNDLE_ID_ALLOWANCE, BUNDLE_ID) AS BUNDLE_ID,
                       IS_ONNET,
                       BUNDLE_DINNER_BEG_DATE
                  FROM dw.DW_V_USER_BASE_INFO_DAY T
                 WHERE ACCT_MONTH = V_MONTH
                   AND DAY_ID = V_DAY
                   AND AREA_NO = C1.AREA_NO
                   AND TELE_TYPE <> '2'
                   AND NVL(IS_KD_BUNDLE, '0') <> '0') A,

               (SELECT USER_NO,
                       T.GRADE_0 || '/' || T.GRADE_1 || '/' || T.GRADE_2 || '/' ||
                       T.GRADE_3 || '/' || T.GRADE_4 STDADDR_NAME
                  FROM DW.DW_V_USER_ADSL_EIGHT_D T
                 WHERE ACCT_MONTH = V_MONTH
                   AND DAY_ID = V_DAY
                   AND T.AREA_NO = C1.AREA_NO
                   AND USER_NO IS NOT NULL) B,

               (SELECT * FROM ALLDMCODE.DMCODE_XIAOQU_STD_ADDR_NEW) C,

               DIM.DIM_ZQ_XIAOQU_HUAXIAO E
         WHERE A.USER_NO = B.USER_NO(+)
           AND B.STDADDR_NAME = C.STDADDR_NAME(+)
           AND C.XIAOQU_NO = E.XIAOQU_NO(+);


      --实体
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_ST_V_USER_HUAXIAO_D_PLUS';
      INSERT INTO MID_ST_V_USER_HUAXIAO_D_PLUS
        SELECT V_DATE,
               AREA_NO,
               USER_NO,
               DEVICE_NUMBER,
               TELE_TYPE,
               IS_ONNET,
               BUNDLE_ID,
               XIAOQU_NO,
               XIAOQU_NAME,
               HUAXIAO_NO,
               HUAXIAO_NAME,
               HUAXIAO_TYPE,
               HUAXIAO_TYPE_NAME,
               RN
          FROM (SELECT A.*,
                       ROW_NUMBER() OVER(PARTITION BY BUNDLE_ID ORDER BY(CASE
                         WHEN TELE_TYPE IN
                              ('4',
                               '26') THEN
                          1
                         WHEN TELE_TYPE = '72' THEN
                          2
                         ELSE
                          3
                       END), BUNDLE_DINNER_BEG_DATE DESC) RN
                  FROM MID_ST_V_USER_HUAXIAO_D A)
         WHERE RN = 1;
      COMMIT;

      --政企
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_ZQ_V_USER_HUAXIAO_D_PLUS';
      INSERT INTO MID_ZQ_V_USER_HUAXIAO_D_PLUS
        SELECT ACCT_MONTH,
               AREA_NO,
               USER_NO,
               DEVICE_NUMBER,
               TELE_TYPE,
               IS_ONNET,
               BUNDLE_ID,
               XIAOQU_NO,
               XIAOQU_NAME,
               HUAXIAO_NO,
               HUAXIAO_NAME,
               HUAXIAO_TYPE,
               HUAXIAO_TYPE_NAME,
               RN
          FROM (SELECT A.*,
                       ROW_NUMBER() OVER(PARTITION BY BUNDLE_ID ORDER BY(CASE
                         WHEN TELE_TYPE IN
                              ('4',
                               '26') THEN
                          1
                         WHEN TELE_TYPE = '72' THEN
                          2
                         ELSE
                          3
                       END), BUNDLE_DINNER_BEG_DATE DESC) RN
                  FROM MID_ZQ_V_USER_HUAXIAO_D A)
         WHERE RN = 1;
      COMMIT;

      --宽带标准地址明细表
       EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_HUAXIAO_KD_ADDR_D';
      INSERT INTO MID_HUAXIAO_KD_ADDR_D
        SELECT USER_NO,
               T.GRADE_0 || '/' || T.GRADE_1 || '/' || T.GRADE_2 || '/' ||
               T.GRADE_3 || '/' || T.GRADE_4 STDADDR_NAME
          FROM DW.DW_V_USER_ADSL_EIGHT_D T
         WHERE ACCT_MONTH = V_MONTH
           AND DAY_ID = V_DAY
           AND T.AREA_NO = C1.AREA_NO
           AND USER_NO IS NOT NULL;
      COMMIT;

      --上月划小基础信息表
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_HUAXIAO_INFO_LD';
      insert into MID_HUAXIAO_INFO_LD
      SELECT USER_NO, XIAOQU_NO, XIAOQU_NAME
              FROM DW_V_USER_HUAXIAO_INFO_ALL G
             WHERE ACCT_MONTH = V_LAST_MONTH
               AND AREA_NO = C1.AREA_NO;
               COMMIT;

      --校园表
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_HUAXIAO_SCHOOL_USER_D';
      INSERT INTO MID_HUAXIAO_SCHOOL_USER_D
        SELECT USER_NO
          FROM DW.DW_V_USER_SCHOOL_HX_USER_D T
         WHERE ACCT_MONTH = V_MONTH
           AND DAY_ID = V_DAY
           AND T.AREA_NO = C1.AREA_NO;
      COMMIT;

    --政企商客明细（包含18年1至3月新增）
    EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_ZQ_HUAXIAO_SK_D';
    INSERT INTO  MID_ZQ_HUAXIAO_SK_D
      SELECT B.AREA_NO, A.HUAXIAO_NO, A.DEVICE_NUMBER, A.USER_NO,B.HUAXIAO_NAME
        FROM (SELECT A.*, ROW_NUMBER() OVER(PARTITION BY A.USER_NO ORDER BY 1) RN
                FROM V_ZQ_HUAXIAO_SK_MX A
                WHERE AREA_NO = C1.AREA_NO)A,
                DIM.DIM_HUAXIAO_INFO B
       WHERE RN = 1
       AND A.HUAXIAO_NO = B.HUAXIAO_NO;
       COMMIT;

    --政企营维单元明细（包含18年1至4月新增）
    EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_ZQ_HUAXIAO_YW_D';
   INSERT INTO MID_ZQ_HUAXIAO_YW_D
     SELECT B.AREA_NO, A.HUAXIAO_NO, A.USER_NO, B.HUAXIAO_NAME
       FROM (SELECT A.*,
                    ROW_NUMBER() OVER(PARTITION BY A.USER_NO ORDER BY 1) RN
               FROM V_ZQ_HUAXIAO_YW_MX A
              WHERE AREA_NO = C1.AREA_NO) A,
            DIM.DIM_HUAXIAO_INFO B
      WHERE RN = 1
        AND A.HUAXIAO_NO = B.HUAXIAO_NO;
         COMMIT;


     --发展人统计
     EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_ZQ_HUAXIAO_DEVELOP_D';
     INSERT INTO MID_ZQ_HUAXIAO_DEVELOP_D
       SELECT A.USER_NO,
              A.DEVELOP_NO,
              B.HUAXIAO_NO,
              B.HUAXIAO_NAME,
              B.HUAXIAO_TYPE
         FROM (SELECT USER_NO, DEVELOP_NO
                 FROM DW.DW_V_USER_MOBILEUSER_DAY A
                WHERE ACCT_MONTH = V_MONTH
                  AND DAY_ID = V_DAY
                  AND AREA_NO = C1.AREA_NO
               UNION ALL
               SELECT USER_NO, DEVELOP_NO
                 FROM DW.DW_V_USER_MOBILEUSER_OCS_DAY A
                WHERE ACCT_MONTH = V_MONTH
                  AND DAY_ID = V_DAY
                  AND AREA_NO = C1.AREA_NO) A,
              (SELECT CHANNEL_NO, HUAXIAO_NO, HUAXIAO_NAME, HUAXIAO_TYPE
                 FROM DIM.DIM_ZQ_CHANNEL_HUAXIAO
                where IS_DEVELOPER = '1') B
        WHERE A.DEVELOP_NO = B.CHANNEL_NO;
       commit;

      ---------------------------- 向正式表写入数据 -------------------------------------
      EXECUTE IMMEDIATE 'ALTER TABLE DW_V_USER_HUAXIAO_INFO_ALL_D TRUNCATE SUBPARTITION PART' ||
                        V_DAY || '_SUBPART_' ||
                        C1.AREA_NO;

  INSERT /*+APPEND*/
  INTO DW_V_USER_HUAXIAO_INFO_ALL_D
    SELECT /*+ORDERED*/
     V_MONTH,
     V_DAY,
     A.AREA_NO,
     A.CITY_NO,
     A.TELE_TYPE,
     A.USER_NO,
     A.CUSTOMER_NO,
     A.ACCOUNT_NO,
     A.DEVICE_NUMBER,
     A.INNET_DATE,
     A.USER_DINNER,
     A.CHANNEL_NO,
     A.CHANNEL_NO_DESC,
     A.GROUP_NO,
     A.IS_ONNET,
     A.IS_NEW,
     A.IS_ACTIVE,
     A.IS_CALL,
     A.USER_STATUS,
     A.LOGOUT_DATE,
     A.IS_LOGOUT,
     A.IS_OUTNET,
     A.IS_VALID,
     A.RECENT_STOP_DATE,
     A.IS_OCS,
     A.INNET_MONTH,
     A.INNET_METHOD,
     A.BUNDLE_ID,
     A.IS_KD_BUNDLE,
     CASE
       WHEN A.TELE_TYPE = '2' AND A.IS_KD_BUNDLE = '0' AND
            G.XIAOQU_NO IS NOT NULL THEN
        G.XIAOQU_NO
       ELSE
        coalesce(E.XIAOQU_NO, F.XIAOQU_NO,E3.XIAOQU_NO,F1.XIAOQU_NO)
     END, --20171030 柴占飞修改：将与宽带融合的C网用户，录入小区编码
     CASE
       WHEN A.TELE_TYPE = '2' AND A.IS_KD_BUNDLE = '0' AND
            G.XIAOQU_NO IS NOT NULL THEN
        G.XIAOQU_NAME
       ELSE
        coalesce(E.XIAOQU_NAME, F.XIAOQU_NAME,E3.XIAOQU_NAME,F1.XIAOQU_NAME)
     END, --20171030 柴占飞修改：将与宽带融合的C网用户，录入小区名称
     CASE
       WHEN A.TELE_TYPE_NAME IN ('移动', '宽带', '电视', '固话') AND
            D1.HUAXIAO_TYPE = '01' THEN
        '1'
       ELSE
        '0'
     END IS_HUAXIAO_01, --自营厅全部按照渠道归属(不含物联网和专线电路)

     CASE
       WHEN A.TELE_TYPE_NAME IN ('移动', '宽带', '电视', '固话') AND
            D2.HUAXIAO_TYPE = '02' THEN
        '1'
       ELSE
        '0'
     END IS_HUAXIAO_02, --商圈支局全部按照渠道归属(不含物联网和专线电路)

     CASE
       WHEN B2.USER_NO IS NULL AND
            A.TELE_TYPE_NAME IN ('移动', '宽带', '电视', '固话') AND
            A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
            G.XIAOQU_NO IS NOT NULL AND G1.HUAXIAO_TYPE = '03' THEN
        '1' --对于融合解绑的用户，解绑后还是按照融合时固网装机地址   20171120 柴占飞修改：优先取解绑的用户

       WHEN B2.USER_NO IS NULL AND
            A.TELE_TYPE_NAME IN ('移动', '宽带', '电视', '固话') AND
            A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
            D3.HUAXIAO_TYPE = '03' AND D1.HUAXIAO_TYPE IS NULL AND
            D2.HUAXIAO_TYPE IS NULL AND G.XIAOQU_NO IS NULL THEN
        '1' --单C
       WHEN B2.USER_NO IS NULL AND
            A.TELE_TYPE_NAME IN ('移动', '宽带', '电视', '固话') AND
            A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2' AND
            E1.HUAXIAO_TYPE = '03' THEN
        '1' --单固
       WHEN B2.USER_NO IS NULL AND
            A.TELE_TYPE_NAME IN ('移动', '宽带', '电视', '固话') AND
            F.HUAXIAO_TYPE = '03' THEN
        '1' --融合
       ELSE
        '0'
     END IS_HUAXIAO_03, --是否社区支局-渠道类(不含物联网和专线电路)

     CASE
       WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
            G.XIAOQU_NO IS NOT NULL AND G2.HUAXIAO_TYPE = '04' AND
            A.TELE_TYPE_NAME IN
            ('移动', '宽带', '电视', '固话', '专线', '电路') THEN
        '1' --对于融合解绑的用户，解绑后还是按照融合时固网装机地址   20171120 柴占飞修改：优先取解绑的用户

       WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
            D4.HUAXIAO_TYPE = '04' AND D1.HUAXIAO_TYPE IS NULL AND
            D2.HUAXIAO_TYPE IS NULL AND G.XIAOQU_NO IS NULL AND
            A.TELE_TYPE_NAME IN
            ('移动', '宽带', '电视', '固话', '专线', '电路') THEN
        '1' --单C
       WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2' AND
            E2.HUAXIAO_TYPE = '04' AND
            A.TELE_TYPE_NAME IN
            ('移动', '宽带', '电视', '固话', '专线', '电路') THEN
        '1' --单固
       WHEN F.HUAXIAO_TYPE = '04' AND
            A.TELE_TYPE_NAME IN
            ('移动', '宽带', '电视', '固话', '专线', '电路') THEN
        '1' --融合
       ELSE
        '0'
     END IS_HUAXIAO_04, --是否农村支局-渠道类(包含物联网和专线电路)

     CASE
       WHEN J1.USER_NO IS NOT NULL THEN
        '1'  --存量
       WHEN A.INNET_DATE>TO_DATE('201804','YYYYMM') AND A.IS_XINXING='1' AND D5.HUAXIAO_TYPE='05' THEN
        '1' --商客支局的新兴业务应该按照渠道或发展人打标
       WHEN A.INNET_DATE>TO_DATE('201804','YYYYMM') AND A.IS_XINXING<>'1' AND A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND G.XIAOQU_NO IS NOT NULL AND G4.HUAXIAO_TYPE = '05' THEN
        '1' --对于融合解绑的用户，解绑后还是按照融合时固网装机地址
       when A.INNET_DATE>TO_DATE('201804','YYYYMM') AND A.IS_XINXING<>'1' AND ((A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND D5.HUAXIAO_TYPE = '05' AND G.XIAOQU_NO IS NULL) or
         (A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND J3.HUAXIAO_TYPE = '05' AND G.XIAOQU_NO IS NULL)) THEN
        '1' --单C
       when A.INNET_DATE>TO_DATE('201804','YYYYMM') AND A.IS_XINXING<>'1' AND A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2'  AND E3.HUAXIAO_TYPE = '05' THEN
        '1'  --单固
       when A.INNET_DATE>TO_DATE('201804','YYYYMM') AND A.IS_XINXING<>'1' AND F1.HUAXIAO_TYPE = '05' THEN
        '1' --融合
       ELSE
        '0'
     END IS_HUAXIAO_05, --是否商客网格-政企类
     CASE
       WHEN J2.USER_NO IS NOT NULL THEN
        '1' --存量
        WHEN A.INNET_DATE>TO_DATE('201805','YYYYMM') AND J3.USER_NO IS NOT NULL and j3.huaxiao_type='06' THEN
        '1' --新增
       ELSE
        '0'
     END IS_HUAXIAO_06, --是否清单客户-政企类
     CASE
       WHEN D7.CHANNEL_NO IS NOT NULL THEN
        '1'
       ELSE
        '0'
     END IS_HUAXIAO_07, --是否校园承包-政企类
     '0' IS_HUAXIAO_08, --是否新兴业务（物联网专网）-政企类
     CASE
       WHEN A.TELE_TYPE_NAME IN ('移动', '宽带', '电视', '固话') AND
            D1.HUAXIAO_TYPE = '01' THEN
        D1.HUAXIAO_NO
     END HUAXIAO_NO_01, --自有厅划小ID

     CASE
       WHEN A.TELE_TYPE_NAME IN ('移动', '宽带', '电视', '固话') AND
            D2.HUAXIAO_TYPE = '02' THEN
        D2.HUAXIAO_NO
     END HUAXIAO_NO_02, --商圈支局划小ID

     CASE
       WHEN B2.USER_NO IS NULL AND
            A.TELE_TYPE_NAME IN ('移动', '宽带', '电视', '固话') AND
            A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
            G.XIAOQU_NO IS NOT NULL AND G1.HUAXIAO_TYPE = '03' THEN
        G1.HUAXIAO_NO --对于融合解绑的用户，解绑后还是按照融合时固网装机地址   20171120 柴占飞修改：优先取解绑的用户

       WHEN B2.USER_NO IS NULL AND
            A.TELE_TYPE_NAME IN ('移动', '宽带', '电视', '固话') AND
            A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
            D3.HUAXIAO_TYPE = '03' AND D1.HUAXIAO_TYPE IS NULL AND
            D2.HUAXIAO_TYPE IS NULL AND G.XIAOQU_NO IS NULL THEN
        D3.HUAXIAO_NO --单C
       WHEN B2.USER_NO IS NULL AND
            A.TELE_TYPE_NAME IN ('移动', '宽带', '电视', '固话') AND
            A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2' AND
            E1.HUAXIAO_TYPE = '03' THEN
        E1.HUAXIAO_NO --单固
       WHEN B2.USER_NO IS NULL AND
            A.TELE_TYPE_NAME IN ('移动', '宽带', '电视', '固话') AND
            F.HUAXIAO_TYPE = '03' THEN
        F.HUAXIAO_NO --融合
     END HUAXIAO_NO_03, --社区支局划小ID

     CASE
       WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
            G.XIAOQU_NO IS NOT NULL AND G2.HUAXIAO_TYPE = '04' AND
            A.TELE_TYPE_NAME IN
            ('移动', '宽带', '电视', '固话', '专线', '电路') THEN
        G2.HUAXIAO_NO --对于融合解绑的用户，解绑后还是按照融合时固网装机地址   20171120 柴占飞修改：优先取解绑的用户

       WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
            D4.HUAXIAO_TYPE = '04' AND D1.HUAXIAO_TYPE IS NULL AND
            D2.HUAXIAO_TYPE IS NULL AND G.XIAOQU_NO IS NULL AND
            A.TELE_TYPE_NAME IN
            ('移动', '宽带', '电视', '固话', '专线', '电路') THEN
        D4.HUAXIAO_NO --单C
       WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2' AND
            E2.HUAXIAO_TYPE = '04' AND
            A.TELE_TYPE_NAME IN
            ('移动', '宽带', '电视', '固话', '专线', '电路') THEN
        E2.HUAXIAO_NO --单固
       WHEN F.HUAXIAO_TYPE = '04' AND
            A.TELE_TYPE_NAME IN
            ('移动', '宽带', '电视', '固话', '专线', '电路') THEN
        F.HUAXIAO_NO --融合
     END HUAXIAO_NO_04, --农村支局划小ID

     CASE
       WHEN J1.USER_NO IS NOT NULL THEN
        J1.HUAXIAO_NO  --存量
       WHEN A.INNET_DATE>TO_DATE('201804','YYYYMM') AND A.IS_XINXING='1' AND D5.HUAXIAO_TYPE='05' THEN
        D5.HUAXIAO_NO --商客支局的新兴业务应该按照渠道或发展人打标
       WHEN A.INNET_DATE>TO_DATE('201804','YYYYMM') AND A.IS_XINXING<>'1' AND A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND G.XIAOQU_NO IS NOT NULL AND G4.HUAXIAO_TYPE = '05' THEN
        G4.HUAXIAO_NO --对于融合解绑的用户，解绑后还是按照融合时固网装机地址
       when A.INNET_DATE>TO_DATE('201804','YYYYMM') AND A.IS_XINXING<>'1' AND ((A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND D5.HUAXIAO_TYPE = '05' AND G.XIAOQU_NO IS NULL) or
         (A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND J3.HUAXIAO_TYPE = '05' AND G.XIAOQU_NO IS NULL)) THEN
        D5.HUAXIAO_NO --单C
       when A.INNET_DATE>TO_DATE('201804','YYYYMM') AND A.IS_XINXING<>'1' AND A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2'  AND E3.HUAXIAO_TYPE = '05' THEN
        E3.HUAXIAO_NO  --单固
       when A.INNET_DATE>TO_DATE('201804','YYYYMM') AND A.IS_XINXING<>'1' AND F1.HUAXIAO_TYPE = '05' THEN
        F1.Huaxiao_No--融合
        END HUAXIAO_NO_05, --商客网格划小ID

      CASE WHEN J2.HUAXIAO_NO IS NOT NULL THEN
        J2.HUAXIAO_NO
        WHEN A.INNET_DATE>TO_DATE('201805','YYYYMM') AND j3.Huaxiao_Type='06' THEN
        j3.Huaxiao_no
        end HUAXIAO_NO_06， --清单客户划小ID

     D7.HUAXIAO_NO AS HUAXIAO_NO_07, --校园承包划小ID
     '' HUAXIAO_NO_08, --新兴业务（物联网专网）划小ID

     CASE
       WHEN A.TELE_TYPE_NAME IN ('移动', '宽带', '电视', '固话') AND
            D1.HUAXIAO_TYPE = '01' THEN
        D1.HUAXIAO_NAME
     END HUAXIAO_NAME_01, --自有厅划小ID

     CASE
       WHEN A.TELE_TYPE_NAME IN ('移动', '宽带', '电视', '固话') AND
            D2.HUAXIAO_TYPE = '02' THEN
        D2.HUAXIAO_NAME
     END HUAXIAO_NAME_02, --商圈支局划小ID

     CASE
       WHEN B2.USER_NO IS NULL AND
            A.TELE_TYPE_NAME IN ('移动', '宽带', '电视', '固话') AND
            A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
            G.XIAOQU_NO IS NOT NULL AND G1.HUAXIAO_TYPE = '03' THEN
        G1.HUAXIAO_NAME --对于融合解绑的用户，解绑后还是按照融合时固网装机地址   20171120 柴占飞修改：优先取解绑的用户

       WHEN B2.USER_NO IS NULL AND
            A.TELE_TYPE_NAME IN ('移动', '宽带', '电视', '固话') AND
            A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
            D3.HUAXIAO_TYPE = '03' AND D1.HUAXIAO_TYPE IS NULL AND
            D2.HUAXIAO_TYPE IS NULL AND G.XIAOQU_NO IS NULL THEN
        D3.HUAXIAO_NAME --单C
       WHEN B2.USER_NO IS NULL AND
            A.TELE_TYPE_NAME IN ('移动', '宽带', '电视', '固话') AND
            A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2' AND
            E1.HUAXIAO_TYPE = '03' THEN
        E1.HUAXIAO_NAME --单固
       WHEN B2.USER_NO IS NULL AND
            A.TELE_TYPE_NAME IN ('移动', '宽带', '电视', '固话') AND
            F.HUAXIAO_TYPE = '03' THEN
        F.HUAXIAO_NAME --融合
     END HUAXIAO_NAME_03, --社区支局划小ID

     CASE
       WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
            G.XIAOQU_NO IS NOT NULL AND G2.HUAXIAO_TYPE = '04' AND
            A.TELE_TYPE_NAME IN
            ('移动', '宽带', '电视', '固话', '专线', '电路') THEN
        G2.HUAXIAO_NAME --对于融合解绑的用户，解绑后还是按照融合时固网装机地址  20171120 柴占飞修改：优先取解绑的用户

       WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
            D4.HUAXIAO_TYPE = '04' AND D1.HUAXIAO_TYPE IS NULL AND
            D2.HUAXIAO_TYPE IS NULL AND G.XIAOQU_NO IS NULL AND
            A.TELE_TYPE_NAME IN
            ('移动', '宽带', '电视', '固话', '专线', '电路') THEN
        D4.HUAXIAO_NAME --单C
       WHEN A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2' AND
            E2.HUAXIAO_TYPE = '04' AND
            A.TELE_TYPE_NAME IN
            ('移动', '宽带', '电视', '固话', '专线', '电路') THEN
        E2.HUAXIAO_NAME --单固
       WHEN F.HUAXIAO_TYPE = '04' AND
            A.TELE_TYPE_NAME IN
            ('移动', '宽带', '电视', '固话', '专线', '电路') THEN
        F.HUAXIAO_NAME --融合
     END HUAXIAO_NAME_04, --农村支局划小ID

     CASE
       WHEN J1.USER_NO IS NOT NULL THEN
        J1.HUAXIAO_NAME  --存量
       WHEN A.INNET_DATE>TO_DATE('201804','YYYYMM') AND A.IS_XINXING='1' AND D5.HUAXIAO_TYPE='05' THEN
        D5.HUAXIAO_NAME --商客支局的新兴业务应该按照渠道或发展人打标
       WHEN A.INNET_DATE>TO_DATE('201804','YYYYMM') AND A.IS_XINXING<>'1' AND A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND G.XIAOQU_NO IS NOT NULL AND G4.HUAXIAO_TYPE = '05' THEN
        G4.HUAXIAO_NAME --对于融合解绑的用户，解绑后还是按照融合时固网装机地址
       when A.INNET_DATE>TO_DATE('201804','YYYYMM') AND A.IS_XINXING<>'1' AND ((A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND D5.HUAXIAO_TYPE = '05' AND G.XIAOQU_NO IS NULL) or
         (A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND J3.HUAXIAO_TYPE = '05' AND G.XIAOQU_NO IS NULL)) THEN
        D5.HUAXIAO_NAME --单C
       when A.INNET_DATE>TO_DATE('201804','YYYYMM') AND A.IS_XINXING<>'1' AND A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2'  AND E3.HUAXIAO_TYPE = '05' THEN
        E3.HUAXIAO_NAME  --单固
       when A.INNET_DATE>TO_DATE('201804','YYYYMM') AND A.IS_XINXING<>'1' AND F1.HUAXIAO_TYPE = '05' THEN
        F1.HUAXIAO_NAME--融合
        END HUAXIAO_NAME_05, --商客网格划小名称

      CASE WHEN J2.HUAXIAO_NAME IS NOT NULL THEN
        J2.HUAXIAO_NAME
        WHEN A.INNET_DATE>TO_DATE('201805','YYYYMM') AND j3.Huaxiao_Type='06' THEN
        j3.HUAXIAO_NAME
        end HUAXIAO_NAME_06， --清单客户划小名称

     D7.HUAXIAO_NAME AS HUAXIAO_NAME_07, --校园承包划小ID
     '' HUAXIAO_NAME_08, --新兴业务（物联网专网）划小ID
     A.BUNDLE_ID_ALLOWANCE,
     A.TELE_TYPE_NEW,
     CASE
       WHEN B2.USER_NO IS NOT NULL THEN
        '1'
       ELSE
        '0'
     END IS_SCHOOL_USER, --是否校园用户
     CASE
       WHEN A.TELE_TYPE_NAME IN ('移动', '宽带', '电视', '固话') AND
            D1.HUAXIAO_TYPE = '01' THEN
        '1'
       ELSE
        '0'
     END IS_SCHOOL_01, --是否自营厅校园

     CASE
       WHEN A.TELE_TYPE_NAME IN ('移动', '宽带', '电视', '固话') AND
            D2.HUAXIAO_TYPE = '02' THEN
        '1'
       ELSE
        '0'
     END IS_SCHOOL_02, --是否商圈校园

     CASE
       WHEN B2.USER_NO IS NULL AND
            A.TELE_TYPE_NAME IN ('移动', '宽带', '电视', '固话') AND
            A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
            G.XIAOQU_NO IS NOT NULL AND G1.HUAXIAO_TYPE = '03' THEN
        '1'

       WHEN B2.USER_NO IS NULL AND
            A.TELE_TYPE_NAME IN ('移动', '宽带', '电视', '固话') AND
            A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
            D3.HUAXIAO_TYPE = '03' AND D1.HUAXIAO_TYPE IS NULL AND
            D2.HUAXIAO_TYPE IS NULL AND G.XIAOQU_NO IS NULL THEN
        '1' --单C
       WHEN B2.USER_NO IS NOT NULL AND
            A.TELE_TYPE_NAME IN ('移动', '宽带', '电视', '固话') AND
            A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2' AND
            E1.HUAXIAO_TYPE = '03' THEN
        '1' --单固
       WHEN B2.USER_NO IS NOT NULL AND
            A.TELE_TYPE_NAME IN ('移动', '宽带', '电视', '固话') AND
            F.HUAXIAO_TYPE = '03' THEN
        '1' --融合
       ELSE
        '0'
     END IS_SCHOOL_03, --是否社区校园
     A.IS_KD_BUNDLE_NEW,
     A.PRODUCT_ID,
     A.SERVICE_START_DATE,
     A.BUNDLE_USER_DINNER,
     A.BUNDLE_USER_DINNER_DESC,
     A.USER_DINNER_DESC,
     A.TELE_TYPE_NAME, --业务类型
     A.IS_ICT, --是否ICT
     A.IS_XINXING --是否新兴业务（不含物联网）
      FROM (SELECT A.AREA_NO,
                   A.CITY_NO,
                   A.TELE_TYPE,
                   A.USER_NO,
                   A.CUSTOMER_NO,
                   A.ACCOUNT_NO,
                   A.DEVICE_NUMBER,
                   A.INNET_DATE,
                   A.USER_DINNER,
                   A.CHANNEL_NO,
                   A.CHANNEL_NO_DESC,
                   A.GROUP_NO,
                   A.IS_ONNET,
                   A.IS_NEW,
                   A.IS_ACTIVE,
                   A.IS_CALL,
                   A.USER_STATUS,
                   A.LOGOUT_DATE,
                   A.IS_LOGOUT,
                   A.IS_OUTNET,
                   A.IS_VALID,
                   A.RECENT_STOP_DATE,
                   A.IS_OCS,
                   A.INNET_MONTH,
                   A.INNET_METHOD,
                   NVL(BUNDLE_ID_ALLOWANCE, BUNDLE_ID) BUNDLE_ID,
                   A.IS_KD_BUNDLE,
                   A.BUNDLE_ID_ALLOWANCE,
                   A.TELE_TYPE_NEW,
                   A.IS_KD_BUNDLE_NEW,
                   A.PRODUCT_ID,
                   A.SERVICE_START_DATE,
                   A.BUNDLE_USER_DINNER,
                   A.BUNDLE_USER_DINNER_DESC,
                   A.USER_DINNER_DESC,
                   TELE_TYPE_NAME, --业务类型
                   IS_ICT, --是否ICT
                   CASE
                     WHEN TELE_TYPE_NAME = '云应用' OR IS_ICT = '1'  THEN
                      '1'
                     ELSE
                      '0'
                   END IS_XINXING --是否新兴业务（不含物联网）
              FROM (SELECT A.AREA_NO,
                           A.CITY_NO,
                           A.TELE_TYPE,
                           A.USER_NO,
                           A.CUSTOMER_NO,
                           A.ACCOUNT_NO,
                           A.DEVICE_NUMBER,
                           A.INNET_DATE,
                           A.USER_DINNER,
                           A.CHANNEL_NO,
                           A.CHANNEL_NO_DESC,
                           A.GROUP_NO,
                           A.IS_ONNET,
                           A.IS_NEW,
                           A.IS_ACTIVE,
                           A.IS_CALL,
                           A.USER_STATUS,
                           A.LOGOUT_DATE,
                           A.IS_LOGOUT,
                           A.IS_OUTNET,
                           A.IS_VALID,
                           A.RECENT_STOP_DATE,
                           A.IS_OCS,
                           A.INNET_MONTH,
                           A.INNET_METHOD,
                           A.BUNDLE_ID,
                           A.IS_KD_BUNDLE,
                           A.BUNDLE_ID_ALLOWANCE,
                           A.TELE_TYPE_NEW,
                           A.IS_KD_BUNDLE_NEW,
                           A.PRODUCT_ID,
                           A.SERVICE_START_DATE,
                           A.BUNDLE_USER_DINNER,
                           A.BUNDLE_USER_DINNER_DESC,
                           A.USER_DINNER_DESC,
                           CASE
                             WHEN A.TELE_TYPE = '2' THEN
                              '移动'
                             WHEN B.SERVICE_CLASS IN ('宽带') THEN
                              '宽带'
                             WHEN B.SERVICE_CLASS IN ('电信电视') THEN
                              '电视'
                             WHEN B.SERVICE_CLASS IN ('固话') THEN
                              '固话'
                             WHEN B.SERVICE_CLASS IN ('专线') THEN
                              '专线'
                             WHEN B.SERVICE_CLASS IN ('电路') THEN
                              '电路'
                             WHEN B.SERVICE_CLASS IN ('云应用') THEN
                              '云应用'
                             WHEN B.SERVICE_CLASS IN ('IDC') THEN
                              'IDC'
                             WHEN B.SERVICE_CLASS IN ('设备出租') THEN
                              '设备出租'
                             ELSE
                              '其他'
                           END TELE_TYPE_NAME,
                           CASE
                             WHEN C.PRODUCT_ID IS NOT NULL THEN
                              '1'
                             ELSE
                              '0'
                           END IS_ICT
                      FROM DW.DW_V_USER_BASE_INFO_DAY           A,
                           ACCT_DSG.BRPT_SERVICE_KIND_TELE@HBODS B,
                           RPT_HBTELE.SJZX_WH_ICT_PRODUCT_ID     C
                     WHERE ACCT_MONTH = V_MONTH
                  AND DAY_ID = V_DAY
                       AND A.AREA_NO = C1.AREA_NO
                       AND A.PRODUCT_ID = B.PRODUCT_ID(+)
                       AND A.PRODUCT_ID = C.PRODUCT_ID(+)) A) A,

            MID_HUAXIAO_KD_ADDR_D B,

           MID_HUAXIAO_SCHOOL_USER_D B2,

           (SELECT * FROM ALLDMCODE.DMCODE_XIAOQU_STD_ADDR_NEW) C,

           (SELECT * FROM DIM.DIM_CHANNEL_HUAXIAO WHERE HUAXIAO_TYPE = '01') D1, --自营厅
           (SELECT * FROM DIM.DIM_CHANNEL_HUAXIAO WHERE HUAXIAO_TYPE = '02') D2, --商圈支局
           (SELECT * FROM DIM.DIM_CHANNEL_HUAXIAO WHERE HUAXIAO_TYPE = '03') D3, --社区支局
           (SELECT * FROM DIM.DIM_CHANNEL_HUAXIAO WHERE HUAXIAO_TYPE = '04') D4, --农村支局
           (SELECT * FROM DIM.DIM_ZQ_CHANNEL_HUAXIAO WHERE HUAXIAO_TYPE = '05') D5, --政企支局
            DIM.DIM_ZQ_GROUP_HUAXIAO D7, --政企校园

           (SELECT * FROM DIM.DIM_XIAOQU_HUAXIAO) E, --小区与划小对应关系表

           (SELECT * FROM DIM.DIM_XIAOQU_HUAXIAO WHERE HUAXIAO_TYPE = '03') E1, --社区支局
           (SELECT * FROM DIM.DIM_XIAOQU_HUAXIAO WHERE HUAXIAO_TYPE = '04') E2, --农村支局
           DIM.DIM_ZQ_XIAOQU_HUAXIAO E3, --政企商客

           MID_ST_V_USER_HUAXIAO_D_PLUS F, --融合宽带用户【实体渠道】
           MID_ZQ_V_USER_HUAXIAO_D_PLUS F1, --融合宽带用户【政企渠道】

           MID_HUAXIAO_INFO_LD G, --上月沉淀的基础表

           (SELECT * FROM DIM.DIM_XIAOQU_HUAXIAO WHERE HUAXIAO_TYPE = '03') G1, --社区支局
           (SELECT * FROM DIM.DIM_XIAOQU_HUAXIAO WHERE HUAXIAO_TYPE = '04') G2, --农村支局
           DIM.DIM_ZQ_XIAOQU_HUAXIAO G4, --政企商客
           MID_ZQ_HUAXIAO_SK_D J1, --商客【存量】
           MID_ZQ_HUAXIAO_YW_D J2, --营维【存量】
           MID_ZQ_HUAXIAO_DEVELOP_D J3 --商客发展人/营维【增量】
     WHERE A.USER_NO = B.USER_NO(+)
       AND B.STDADDR_NAME = C.STDADDR_NAME(+)
       AND A.USER_NO = B2.USER_NO(+)
       AND A.CHANNEL_NO = D1.CHANNEL_NO(+)
       AND A.CHANNEL_NO = D2.CHANNEL_NO(+)
       AND A.CHANNEL_NO = D3.CHANNEL_NO(+)
       AND A.CHANNEL_NO = D4.CHANNEL_NO(+)
       AND A.CHANNEL_NO = D5.CHANNEL_NO(+)
       AND C.XIAOQU_NO = E.XIAOQU_NO(+)
       AND C.XIAOQU_NO = E1.XIAOQU_NO(+)
       AND C.XIAOQU_NO = E2.XIAOQU_NO(+)
       AND C.XIAOQU_NO = E3.XIAOQU_NO(+)
       AND A.BUNDLE_ID = F.BUNDLE_ID(+)
       AND A.BUNDLE_ID = F1.BUNDLE_ID(+)
       AND A.USER_NO = G.USER_NO(+)
       AND G.XIAOQU_NO = G1.XIAOQU_NO(+)
       AND G.XIAOQU_NO = G2.XIAOQU_NO(+)
       AND G.XIAOQU_NO = G4.XIAOQU_NO(+)
       AND A.USER_NO = J1.USER_NO(+)
       AND A.USER_NO = J2.USER_NO(+)
       AND A.USER_NO = J3.USER_NO(+)
       AND A.GROUP_NO = D7.CHANNEL_NO(+);
  ROWLINE := SQL%ROWCOUNT;
  COMMIT;

      --写入结果表记录数
      DELETE FROM DW_EXECUTE_LST T
       WHERE T.ACCT_MONTH = V_DATE
         AND T.AREA = C1.AREA_NO
         AND T.PROCNAME = V_PROCNAME;
      COMMIT;
      INSERT INTO DW_EXECUTE_LST
        (ACCT_MONTH,
         PROCNAME,
         SERVICE_CODE,
         TARGETTABLE,
         AREA,
         DESCRIBE,
         ENDTIME,
         RESULT,
         ROW_NUM)
      VALUES
        (V_DATE,
         V_PROCNAME,
         '2',
         SUBSTR(V_PROCNAME, 3),
         C1.AREA_NO,
         'INSERT',
         SYSDATE,
         'SUCCESS',
         ROWLINE);
      COMMIT;

    END LOOP;

    --更新日志
    V_RETCODE := 'SUCCESS';
    P_UPDATE_LOG(V_DATE,
                 V_PKG,
                 V_PROCNAME,
                 '结束',
                 'SUCCESS',
                 SYSDATE);
  ELSE
    V_RETCODE := 'WAIT';
    P_UPDATE_LOG(V_DATE, V_PKG, V_PROCNAME, '等待', 'WAIT', SYSDATE);
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    V_RETCODE := 'FAIL';
    V_RETINFO := SQLERRM;
    P_UPDATE_LOG(V_DATE,
                 V_PKG,
                 V_PROCNAME,
                 V_RETINFO,
                 'FAIL',
                 SYSDATE);
END;
/
