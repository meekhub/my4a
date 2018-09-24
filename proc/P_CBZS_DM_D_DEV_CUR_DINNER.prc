CREATE OR REPLACE PROCEDURE MOBILE_CBZS.P_CBZS_DM_D_DEV_CUR_DINNER IS
  /*****************************************************************
  *名称 --%NAME: P_CBZS_DM_D_DEV_CUR_CHANNEL
  *功能描述 --%COMMENT:当日发展
  *执行周期 --%PERIOD: 日
  *参数 --%PARAM:V_DATE  日期,格式YYYYMMDD
  *参数 --%PARAM:V_RETCODE  过程运行结束成功与否标志
  *参数 --%PARAM:V_RETCODE  过程运行结束成功与否描述
  *创建人 --%CREATOR:LIYA
  *创建时间 --%CREATED_TIME:20180316
  *******************************************************************/
  V_PKG      VARCHAR2(20);
  V_PROCNAME VARCHAR2(30);
  V_CNT      NUMBER;
  V_CNT_1    NUMBER;

  V_BEG_DATE  VARCHAR2(20);
  V_LAST2_MON VARCHAR2(20);

  V_DATE    VARCHAR2(20);
  V_RETCODE VARCHAR2(20);
  V_RETINFO VARCHAR2(200);

  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018';

BEGIN
  V_PKG      := '承包住手-当日发展';
  V_PROCNAME := 'P_CBZS_DM_D_DEV_CUR_DINNER';

  V_DATE      := TO_CHAR(SYSDATE, 'YYYYMMDDHH24');
  V_LAST2_MON := TO_CHAR(ADD_MONTHS(TO_DATE(SUBSTR(V_DATE, 1, 8),
                                            'YYYYMMDD'),
                                    -2),
                         'YYYYMMDD');

  V_BEG_DATE := CASE
                  WHEN V_DATE <=
                       SUBSTR(V_DATE, 1, 8) || TRIM(TO_CHAR(05, '09')) THEN
                   SUBSTR(V_DATE, 1, 8) || TRIM(TO_CHAR(00, '09'))
                  ELSE
                   TO_CHAR(TO_DATE(V_DATE, 'YYYYMMDDHH24') - 1 / 12,
                           'YYYYMMDDHH24')
                END;

  --日志
  ALLDM.P_ALLDM_INSERT_LOG(V_DATE, V_PKG, V_PROCNAME, '承包住手', SYSDATE);
  IF V_BEG_DATE >= SUBSTR(V_BEG_DATE, 1, 8) || TRIM(TO_CHAR(05, '09')) AND
     V_BEG_DATE <= SUBSTR(V_BEG_DATE, 1, 8) || TRIM(TO_CHAR(24, '09')) THEN

    EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_CBZS_KKPI_D_DEV_CUR_1B';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_CBZS_KKPI_D_DEV_CUR_2B';
    --EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_DM_KKPI_D_DEV_CUR_IPHONE';

    FOR C1 IN V_AREA LOOP

      --沉淀当日新发展用户
      INSERT INTO MID_CBZS_KKPI_D_DEV_CUR_1B
        SELECT /*+PARALLEL(T,3)*/
         USER_ID,
         SERVICE_KIND,
         SERVICE_ID,
         SERVICE_OFFER_ID,
         ACCEPT_CITY,
         REGION_CODE,
         SOURCE_ID,
         DEALER_ID,
         TO_CHAR(ACCEPT_DATE, 'YYYYMMDDHH24MISS'),
         REGISTER_NUMBER,
         ACCEPT
          FROM BSS_STAGE.BB_BUS_INFO_T@HBODS T
         WHERE ACCEPT_DATE >= TO_DATE(SUBSTR(V_DATE, 1, 8), 'YYYYMMDD')
           AND ACCEPT_DATE < TO_DATE(SUBSTR(V_DATE, 1, 10), 'YYYYMMDDHH24')
           AND ACCEPT_CITY = C1.AREA_NO
           AND SERVICE_OFFER_ID IN ('301')
           AND T.SERVICE_KIND IN ('8', '55', '11', '72');
      COMMIT;

      --沉淀当日新发展用户
      INSERT INTO MID_CBZS_KKPI_D_DEV_CUR_2B
        SELECT /*+PARALLEL(T,3)*/
         ACCEPT_CITY,
         SERVICE_ID,
         SERVICE_KIND,
         MAX(CASE
               WHEN T.SERVICE_OFFER_ID = '301' AND T.ATTR_ID = '50185' THEN
                NEW_INFO_VALUE
               ELSE
                '0'
             END), --受理渠道
         MAX(TO_CHAR(ACCEPT_DATE, 'YYYYMMDDHH24MISS')) ACCEPT_DATE, --受理时间
         MAX(CASE
               WHEN T.SERVICE_OFFER_ID = '301' AND T.ATTR_ID = '51122' AND
                    NEW_INFO_VALUE = '2100' THEN
                '1'
               ELSE
                '0'
             END), --是否OCS
         MAX(CASE
               WHEN /*T.SERVICE_OFFER_ID = '4001' AND*/
                ATTR_ID = '50211' THEN
                NEW_INFO_VALUE
               ELSE
                '0'
             END), --基础套餐
         MAX(CASE
               WHEN T.SERVICE_OFFER_ID = '4001' AND ATTR_ID = '50217' THEN
                NEW_INFO_VALUE
               ELSE
                '0'
             END), --融合套餐
         MAX(CASE
               WHEN T.SERVICE_OFFER_ID = '4001' AND T.ATTR_ID = '10611' AND
                    NEW_INFO_VALUE IN ('271', '1519') AND SERVICE_KIND = '8' ---此条件 柴占飞要求加
                THEN
                '1'
               ELSE
                '0'
             END), --是否合约
         MAX(CASE
               WHEN SERVICE_OFFER_ID IN ('301', '4001') AND
                    T.SERVICE_KIND IN ('8') AND T.ATTR_ID IN ('50211') AND
                    T.NEW_INFO_VALUE IN
                    ('1419678', '1419961', '1419645', '1419639') THEN
                NEW_INFO_VALUE
             END), --主套餐
         ACCEPT_CITY,
         REGION_CODE,
         REGISTER_NUMBER,
         DEALER_ID
          FROM BSS_STAGE.BB_BUS_DETAIL_T@HBODS T
         WHERE ACCEPT_DATE >= TO_DATE(SUBSTR(V_DATE, 1, 8), 'YYYYMMDD')
           AND ACCEPT_DATE < TO_DATE(SUBSTR(V_DATE, 1, 10), 'YYYYMMDDHH24')
           AND ACCEPT_CITY = C1.AREA_NO
           AND SERVICE_OFFER_ID IN ('301', '4001')
           AND T.SERVICE_KIND IN ('8', '55', '11')
         GROUP BY ACCEPT_CITY,
                  REGION_CODE,
                  SERVICE_ID,
                  SERVICE_KIND,
                  REGISTER_NUMBER,
                  DEALER_ID;
      COMMIT;

    END LOOP;

    --====================== 临时表数据 ==========================

    --移动、宽带
    DELETE FROM MID_CBZS_KKPI_D_DEV_CUR_B;
    COMMIT;

    INSERT INTO MID_CBZS_KKPI_D_DEV_CUR_B
      SELECT SUBSTR(V_DATE, 1, 8),
             FUNC_GET_NEW_AREA_NO(A.ACCEPT_CITY,
                                  NVL(C.F_CITY_NO,
                                      FUNC_GET_OTHER_CITY_NO(A.ACCEPT_CITY))),
             NVL(C.F_CITY_NO, FUNC_GET_OTHER_CITY_NO(A.ACCEPT_CITY)) CITY_NO,
             CASE
               WHEN A.SERVICE_KIND = '8' AND NVL(B.IS_OCS, '0') = '0' THEN
                '01' --后付费
               WHEN A.SERVICE_KIND = '8' AND NVL(B.IS_OCS, '0') = '1' THEN
                '01' --预付费
               WHEN A.SERVICE_KIND IN ('11', '55') THEN
                '03' --宽带
               WHEN A.SERVICE_KIND IN ('72') THEN
                '06' --电信电视
             END TYPE_ONE,
             COUNT(DISTINCT CASE
                     WHEN A.ACCEPT_DATE BETWEEN V_BEG_DATE AND V_DATE THEN
                      A.SERVICE_ID
                   END) APPEND_VALUE,
             COUNT(DISTINCT A.SERVICE_ID) CUR_VALUE,
             SUBSTR(V_BEG_DATE, 9, 2),
             SUBSTR(V_DATE, 9, 2),
             A.DEALER_ID,
             CASE
               WHEN A.SERVICE_KIND = '8' AND NVL(B.IS_OCS, '0') = '0' THEN
                '01' --后付费
               WHEN A.SERVICE_KIND = '8' AND NVL(B.IS_OCS, '0') = '1' THEN
                '02' --预付费
               WHEN A.SERVICE_KIND IN ('11', '55') THEN
                '00' --宽带
               WHEN A.SERVICE_KIND IN ('72') THEN
                '00' --电信电视
             END TYPE_TWO,
             B.USER_DINNER
        FROM (SELECT * FROM MID_CBZS_KKPI_D_DEV_CUR_1B T) A,

             (SELECT *
                FROM (SELECT A.*,
                             ROW_NUMBER() OVER(PARTITION BY A.SERVICE_ID ORDER BY A.USER_DINNER DESC, A.BUNDLE_DINNER DESC) RN
                        FROM MID_CBZS_KKPI_D_DEV_CUR_2B A
                      --WHERE A.DEALER_ID <> '0'
                      )
               WHERE RN = 1) B,

             (SELECT * FROM DIM.DIM_OM_AREA_T) C

       WHERE A.SERVICE_ID = B.SERVICE_ID(+)
         AND A.REGION_CODE = C.F_AREA_ID(+)
       GROUP BY FUNC_GET_NEW_AREA_NO(A.ACCEPT_CITY,
                                     NVL(C.F_CITY_NO,
                                         FUNC_GET_OTHER_CITY_NO(A.ACCEPT_CITY))),
                NVL(C.F_CITY_NO, FUNC_GET_OTHER_CITY_NO(A.ACCEPT_CITY)),
                CASE
                  WHEN A.SERVICE_KIND = '8' AND NVL(B.IS_OCS, '0') = '0' THEN
                   '01' --后付费
                  WHEN A.SERVICE_KIND = '8' AND NVL(B.IS_OCS, '0') = '1' THEN
                   '01' --预付费
                  WHEN A.SERVICE_KIND IN ('11', '55') THEN
                   '03' --宽带
                  WHEN A.SERVICE_KIND IN ('72') THEN
                   '06' --电信电视
                END,
                A.DEALER_ID,
                CASE
                  WHEN A.SERVICE_KIND = '8' AND NVL(B.IS_OCS, '0') = '0' THEN
                   '01' --后付费
                  WHEN A.SERVICE_KIND = '8' AND NVL(B.IS_OCS, '0') = '1' THEN
                   '02' --预付费
                  WHEN A.SERVICE_KIND IN ('11', '55') THEN
                   '00' --宽带
                  WHEN A.SERVICE_KIND IN ('72') THEN
                   '00' --电信电视
                END,
                B.USER_DINNER;
    COMMIT;

    --合约用户
    INSERT INTO MID_CBZS_KKPI_D_DEV_CUR_B
      SELECT SUBSTR(V_DATE, 1, 8),
             FUNC_GET_NEW_AREA_NO(A.ACCEPT_CITY,
                                  NVL(C.F_CITY_NO,
                                      FUNC_GET_OTHER_CITY_NO(A.ACCEPT_CITY))),
             NVL(C.F_CITY_NO, FUNC_GET_OTHER_CITY_NO(A.ACCEPT_CITY)) CITY_NO,
             '01' TELE_TYPE,
             COUNT(DISTINCT CASE
                     WHEN A.ACCEPT_DATE BETWEEN V_BEG_DATE AND V_DATE THEN
                      A.SERVICE_ID
                   END) APPEND_VALUE,
             COUNT(DISTINCT A.SERVICE_ID) CUR_VALUE,
             SUBSTR(V_BEG_DATE, 9, 2),
             SUBSTR(V_DATE, 9, 2),
             A.DEALER_ID,
             '05',
             B.USER_DINNER
        FROM (SELECT * FROM MID_CBZS_KKPI_D_DEV_CUR_1B T) A,

             (SELECT *
                FROM (SELECT A.*,
                             ROW_NUMBER() OVER(PARTITION BY A.SERVICE_ID ORDER BY A.USER_DINNER DESC, A.BUNDLE_DINNER DESC) RN
                        FROM MID_CBZS_KKPI_D_DEV_CUR_2B A
                       WHERE A.IS_HY = '1'
                      --AND A.DEALER_ID <> '0'
                      )
               WHERE RN = 1) B,

             (SELECT * FROM DIM.DIM_OM_AREA_T) C

       WHERE A.SERVICE_ID = B.SERVICE_ID
         AND A.REGION_CODE = C.F_AREA_ID(+)
       GROUP BY FUNC_GET_NEW_AREA_NO(A.ACCEPT_CITY,
                                     NVL(C.F_CITY_NO,
                                         FUNC_GET_OTHER_CITY_NO(A.ACCEPT_CITY))),
                NVL(C.F_CITY_NO, FUNC_GET_OTHER_CITY_NO(A.ACCEPT_CITY)),
                A.DEALER_ID,
                B.USER_DINNER;
    COMMIT;

    --副卡用户
    INSERT INTO MID_CBZS_KKPI_D_DEV_CUR_B
      SELECT SUBSTR(V_DATE, 1, 8),
             FUNC_GET_NEW_AREA_NO(A.ACCEPT_CITY,
                                  NVL(C.F_CITY_NO,
                                      FUNC_GET_OTHER_CITY_NO(A.ACCEPT_CITY))),
             NVL(C.F_CITY_NO, FUNC_GET_OTHER_CITY_NO(A.ACCEPT_CITY)) CITY_NO,
             '01' TELE_TYPE,
             COUNT(DISTINCT CASE
                     WHEN A.ACCEPT_DATE BETWEEN V_BEG_DATE AND V_DATE THEN
                      A.SERVICE_ID
                   END) APPEND_VALUE,
             COUNT(DISTINCT A.SERVICE_ID) CUR_VALUE,
             SUBSTR(V_BEG_DATE, 9, 2),
             SUBSTR(V_DATE, 9, 2),
             A.DEALER_ID,
             '04',
             B.USER_DINNER
        FROM (SELECT * FROM MID_CBZS_KKPI_D_DEV_CUR_1B T) A,

             (SELECT *
                FROM (SELECT A.*,
                             ROW_NUMBER() OVER(PARTITION BY A.SERVICE_ID ORDER BY A.USER_DINNER DESC, A.BUNDLE_DINNER DESC) RN
                        FROM MID_CBZS_KKPI_D_DEV_CUR_2B A,
                             DIM.DIM_USER_DINNER        B
                       WHERE A.USER_DINNER = B.USER_DINNER
                         AND B.USER_DINNER_DESC LIKE '%加装%')
               WHERE RN = 1) B,

             (SELECT * FROM DIM.DIM_OM_AREA_T) C

       WHERE A.SERVICE_ID = B.SERVICE_ID
         AND A.REGION_CODE = C.F_AREA_ID(+)
       GROUP BY FUNC_GET_NEW_AREA_NO(A.ACCEPT_CITY,
                                     NVL(C.F_CITY_NO,
                                         FUNC_GET_OTHER_CITY_NO(A.ACCEPT_CITY))),
                NVL(C.F_CITY_NO, FUNC_GET_OTHER_CITY_NO(A.ACCEPT_CITY)),
                A.DEALER_ID,
                B.USER_DINNER;
    COMMIT;

    --======================== --全流量套餐 20170602  柴占飞 修改为如下口径 ==========================
    FOR C1 IN V_AREA LOOP
      INSERT INTO MID_CBZS_KKPI_D_DEV_CUR_B
        SELECT SUBSTR(V_DATE, 1, 8),
               A.ACCEPT_CITY,
               NVL(C.F_CITY_NO, FUNC_GET_OTHER_CITY_NO(A.ACCEPT_CITY)) CITY_NO,
               CASE
                 WHEN B.SERVICE_OFFER_ID IN ('301') AND
                      A.NEW_INFO_VALUE IN ('1419678', '1419961', '1422907') THEN
                  '04' --不限量199元套餐(全流量套餐新装)
               ----20171211根据王俊飞要求增加1422907省内199不限量套餐
                 WHEN B.SERVICE_OFFER_ID IN ('301') AND A.NEW_INFO_VALUE IN ('1419645') THEN
                  '04' -- 十全十美不限量299元套餐[基础移动电话](全流量套餐新装)

               --20170803 柴占飞根据张翔龙要求，增加109,229不限量套餐
                 WHEN B.SERVICE_OFFER_ID IN ('301') AND
                      A.NEW_INFO_VALUE IN ('1421729', '1422909') THEN
                  '04' -- 天翼省内不限量99套餐[基础移动电话]
                 WHEN B.SERVICE_OFFER_ID IN ('301') AND A.NEW_INFO_VALUE IN ('1420514') THEN
                  '04' -- 天翼省内不限量109套餐[基础移动电话]
               -----20171211根据王俊飞要求增加1422909省内109不限量套餐
                 WHEN B.SERVICE_OFFER_ID IN ('302') AND
                      A.NEW_INFO_VALUE IN ('1419678', '1419961', '1422907') THEN
                  '05' --不限量199元套餐(全流量套餐迁移)
               ----20171211根据王俊飞要求增加1422907省内199不限量套餐
                 WHEN B.SERVICE_OFFER_ID IN ('302') AND A.NEW_INFO_VALUE IN ('1419645') THEN
                  '05' -- 十全十美不限量299元套餐[基础移动电话](全流量套餐迁移)

               --20170803 柴占飞根据张翔龙要求，增加109,229不限量套餐
                 WHEN B.SERVICE_OFFER_ID IN ('302') AND
                      A.NEW_INFO_VALUE IN ('1421729', '1422909') THEN
                  '05' -- 天翼省内不限量99套餐[基础移动电话]
                 WHEN B.SERVICE_OFFER_ID IN ('302') AND A.NEW_INFO_VALUE IN ('1420514') THEN
                  '05' -- 天翼省内不限量109套餐[基础移动电话]
               -----20171211根据王俊飞要求增加1422909省内109不限量套餐
               END TELE_TYPE,
               COUNT(DISTINCT CASE
                       WHEN TO_CHAR(A.ACCEPT_DATE, 'YYYYMMDDHH24') BETWEEN V_BEG_DATE AND V_DATE THEN
                        A.SERVICE_ID
                     END) APPEND_VALUE,
               COUNT(DISTINCT A.SERVICE_ID) CUR_VALUE,
               SUBSTR(V_BEG_DATE, 9, 2),
               SUBSTR(V_DATE, 9, 2),
               A.DEALER_ID,
               CASE
                 WHEN B.SERVICE_OFFER_ID IN ('301') AND
                      A.NEW_INFO_VALUE IN ('1419678', '1419961', '1422907') THEN
                  '03' --不限量199元套餐(全流量套餐新装)
               ----20171211根据王俊飞要求增加1422907省内199不限量套餐
                 WHEN B.SERVICE_OFFER_ID IN ('301') AND A.NEW_INFO_VALUE IN ('1419645') THEN
                  '04' -- 十全十美不限量299元套餐[基础移动电话](全流量套餐新装)

               --20170803 柴占飞根据张翔龙要求，增加109,229不限量套餐
                 WHEN B.SERVICE_OFFER_ID IN ('301') AND
                      A.NEW_INFO_VALUE IN ('1421729', '1422909') THEN
                  '01' -- 天翼省内不限量99套餐[基础移动电话]
                 WHEN B.SERVICE_OFFER_ID IN ('301') AND A.NEW_INFO_VALUE IN ('1420514') THEN
                  '02' -- 天翼省内不限量109套餐[基础移动电话]
               -----20171211根据王俊飞要求增加1422909省内109不限量套餐
                 WHEN B.SERVICE_OFFER_ID IN ('302') AND
                      A.NEW_INFO_VALUE IN ('1419678', '1419961', '1422907') THEN
                  '03' --不限量199元套餐(全流量套餐迁移)
               ----20171211根据王俊飞要求增加1422907省内199不限量套餐
                 WHEN B.SERVICE_OFFER_ID IN ('302') AND A.NEW_INFO_VALUE IN ('1419645') THEN
                  '04' -- 十全十美不限量299元套餐[基础移动电话](全流量套餐迁移)

               --20170803 柴占飞根据张翔龙要求，增加109,229不限量套餐
                 WHEN B.SERVICE_OFFER_ID IN ('302') AND
                      A.NEW_INFO_VALUE IN ('1421729', '1422909') THEN
                  '01' -- 天翼省内不限量99套餐[基础移动电话]
                 WHEN B.SERVICE_OFFER_ID IN ('302') AND A.NEW_INFO_VALUE IN ('1420514') THEN
                  '02' -- 天翼省内不限量109套餐[基础移动电话]
               -----20171211根据王俊飞要求增加1422909省内109不限量套餐
               END,
               A.NEW_INFO_VALUE
          FROM (SELECT /*+PARALLEL(T, 3)*/
                 *
                  FROM BSS_STAGE.BB_BUS_DETAIL_T@HBODS T
                 WHERE ACCEPT_DATE >=
                       TO_DATE(SUBSTR(V_DATE, 1, 8), 'YYYYMMDD')
                   AND ACCEPT_DATE <
                       TO_DATE(SUBSTR(V_DATE, 1, 10), 'YYYYMMDDHH24')
                   AND ACCEPT_CITY = C1.AREA_NO
                   AND SERVICE_OFFER_ID IN ('4001')
                   AND T.SERVICE_KIND IN ('8')
                   AND T.ATTR_ID IN ('50211')
                   AND T.NEW_INFO_VALUE IN ('1419678',
                                            '1419961',
                                            '1419645',
                                            '1420514',
                                            '1421729',
                                            '1422909',
                                            '1422907')) A,

               (SELECT /*+PARALLEL(T, 3)*/
                 *
                  FROM BSS_STAGE.BB_BUS_INFO_T@HBODS T
                 WHERE ACCEPT_DATE >=
                       TO_DATE(SUBSTR(V_DATE, 1, 8), 'YYYYMMDD')
                   AND ACCEPT_DATE <
                       TO_DATE(SUBSTR(V_DATE, 1, 10), 'YYYYMMDDHH24')
                   AND ACCEPT_CITY = C1.AREA_NO
                   AND SERVICE_OFFER_ID IN ('301', '302')
                   AND T.SERVICE_KIND IN ('8')
                   AND T.DEALER_ID <> '-1'
                   AND T.ACCEPT = '1') B,

               (SELECT * FROM DIM.DIM_OM_AREA_T) C

         WHERE A.REGISTER_NUMBER = B.REGISTER_NUMBER
           AND A.REGION_CODE = C.F_AREA_ID(+)
         GROUP BY A.ACCEPT_CITY,
                  NVL(C.F_CITY_NO, FUNC_GET_OTHER_CITY_NO(A.ACCEPT_CITY)),
                  CASE
                    WHEN B.SERVICE_OFFER_ID IN ('301') AND
                         A.NEW_INFO_VALUE IN ('1419678', '1419961', '1422907') THEN
                     '04' --不限量199元套餐(全流量套餐新装)
                  ----20171211根据王俊飞要求增加1422907省内199不限量套餐
                    WHEN B.SERVICE_OFFER_ID IN ('301') AND A.NEW_INFO_VALUE IN ('1419645') THEN
                     '04' -- 十全十美不限量299元套餐[基础移动电话](全流量套餐新装)

                  --20170803 柴占飞根据张翔龙要求，增加109,229不限量套餐
                    WHEN B.SERVICE_OFFER_ID IN ('301') AND
                         A.NEW_INFO_VALUE IN ('1421729', '1422909') THEN
                     '04' -- 天翼省内不限量99套餐[基础移动电话]
                    WHEN B.SERVICE_OFFER_ID IN ('301') AND A.NEW_INFO_VALUE IN ('1420514') THEN
                     '04' -- 天翼省内不限量109套餐[基础移动电话]
                  -----20171211根据王俊飞要求增加1422909省内109不限量套餐
                    WHEN B.SERVICE_OFFER_ID IN ('302') AND
                         A.NEW_INFO_VALUE IN ('1419678', '1419961', '1422907') THEN
                     '05' --不限量199元套餐(全流量套餐迁移)
                  ----20171211根据王俊飞要求增加1422907省内199不限量套餐
                    WHEN B.SERVICE_OFFER_ID IN ('302') AND A.NEW_INFO_VALUE IN ('1419645') THEN
                     '05' -- 十全十美不限量299元套餐[基础移动电话](全流量套餐迁移)

                  --20170803 柴占飞根据张翔龙要求，增加109,229不限量套餐
                    WHEN B.SERVICE_OFFER_ID IN ('302') AND
                         A.NEW_INFO_VALUE IN ('1421729', '1422909') THEN
                     '05' -- 天翼省内不限量99套餐[基础移动电话]
                    WHEN B.SERVICE_OFFER_ID IN ('302') AND A.NEW_INFO_VALUE IN ('1420514') THEN
                     '05' -- 天翼省内不限量109套餐[基础移动电话]
                  -----20171211根据王俊飞要求增加1422909省内109不限量套餐
                  END,
                  A.DEALER_ID,
                  CASE
                    WHEN B.SERVICE_OFFER_ID IN ('301') AND
                         A.NEW_INFO_VALUE IN ('1419678', '1419961', '1422907') THEN
                     '03' --不限量199元套餐(全流量套餐新装)
                  ----20171211根据王俊飞要求增加1422907省内199不限量套餐
                    WHEN B.SERVICE_OFFER_ID IN ('301') AND A.NEW_INFO_VALUE IN ('1419645') THEN
                     '04' -- 十全十美不限量299元套餐[基础移动电话](全流量套餐新装)

                  --20170803 柴占飞根据张翔龙要求，增加109,229不限量套餐
                    WHEN B.SERVICE_OFFER_ID IN ('301') AND
                         A.NEW_INFO_VALUE IN ('1421729', '1422909') THEN
                     '01' -- 天翼省内不限量99套餐[基础移动电话]
                    WHEN B.SERVICE_OFFER_ID IN ('301') AND A.NEW_INFO_VALUE IN ('1420514') THEN
                     '02' -- 天翼省内不限量109套餐[基础移动电话]
                  -----20171211根据王俊飞要求增加1422909省内109不限量套餐
                    WHEN B.SERVICE_OFFER_ID IN ('302') AND
                         A.NEW_INFO_VALUE IN ('1419678', '1419961', '1422907') THEN
                     '03' --不限量199元套餐(全流量套餐迁移)
                  ----20171211根据王俊飞要求增加1422907省内199不限量套餐
                    WHEN B.SERVICE_OFFER_ID IN ('302') AND A.NEW_INFO_VALUE IN ('1419645') THEN
                     '04' -- 十全十美不限量299元套餐[基础移动电话](全流量套餐迁移)

                  --20170803 柴占飞根据张翔龙要求，增加109,229不限量套餐
                    WHEN B.SERVICE_OFFER_ID IN ('302') AND
                         A.NEW_INFO_VALUE IN ('1421729', '1422909') THEN
                     '01' -- 天翼省内不限量99套餐[基础移动电话]
                    WHEN B.SERVICE_OFFER_ID IN ('302') AND A.NEW_INFO_VALUE IN ('1420514') THEN
                     '02' -- 天翼省内不限量109套餐[基础移动电话]
                  -----20171211根据王俊飞要求增加1422909省内109不限量套餐
                  END,
                  A.NEW_INFO_VALUE;
    END LOOP;

    --移动合计
    INSERT INTO MID_CBZS_KKPI_D_DEV_CUR_B
      SELECT DAY_ID,
             T.AREA_NO,
             T.CITY_NO,
             '01' TELE_TYPE,
             SUM(APPEND_VALUE),
             SUM(CUR_VALUE),
             START_TIME,
             END_TIME,
             DEALER_ID,
             '00',
             USER_DINNER
        FROM MID_CBZS_KKPI_D_DEV_CUR_B T
       WHERE T.DAY_ID = SUBSTR(V_DATE, 1, 8)
         AND T.AREA_NO <> T.CITY_NO
         AND T.TYPE_ONE = '01'
         AND T.TYPE_TWO IN ('01', '02')
       GROUP BY DAY_ID, T.AREA_NO, CITY_NO, START_TIME, END_TIME, DEALER_ID,USER_DINNER;
    COMMIT;

    --全流量套餐新装 全流量套餐迁移 合计
    INSERT INTO MID_CBZS_KKPI_D_DEV_CUR_B
      SELECT DAY_ID,
             T.AREA_NO,
             T.CITY_NO,
             TYPE_ONE TELE_TYPE,
             SUM(APPEND_VALUE),
             SUM(CUR_VALUE),
             START_TIME,
             END_TIME,
             DEALER_ID,
             '00',
             USER_DINNER
        FROM MID_CBZS_KKPI_D_DEV_CUR_B T
       WHERE T.DAY_ID = SUBSTR(V_DATE, 1, 8)
         AND T.AREA_NO <> T.CITY_NO
         AND T.TYPE_ONE IN ('04', '05') --等正式上线的时候 再放开
       GROUP BY DAY_ID,
                T.AREA_NO,
                CITY_NO,
                TYPE_ONE,
                START_TIME,
                END_TIME,
                DEALER_ID,
                USER_DINNER;
    COMMIT;

    --====================== 正式数据 ==========================
    INSERT INTO CBZS_DM_KKPI_D_DEV_CUR_DINNER
      SELECT SUBSTR(V_DATE, 1, 8),
             A.AREA_NO,
             B.CITY_NO,
             '1',
             B.HUAXIAO_TYPE,
             B.HUAXIAO_NO,
             '',
             B.CHANNEL_NO,
             B.CHANNEL_NO_DESC,
             A.USER_DINNER,
             NVL(C.USER_DINNER_DESC, '其他'),
             A.TYPE_ONE,
             A.TYPE_TWO,
             SUM(A.APPEND_VALUE),
             SUM(A.CUR_VALUE),
             A.START_TIME,
             A.END_TIME
        FROM MID_CBZS_KKPI_D_DEV_CUR_B A,
             DIM.DIM_CHANNEL_HUAXIAO   B,
             DIM.DIM_USER_DINNER       C
       WHERE A.DEALER_ID = B.CHANNEL_NO
         AND A.USER_DINNER = C.USER_DINNER(+)
         AND B.HUAXIAO_TYPE IN ('01', '02', '03', '04')
       GROUP BY A.AREA_NO,
                B.CITY_NO,
                '1',
                B.HUAXIAO_TYPE,
                B.HUAXIAO_NO,
                '',
                B.CHANNEL_NO,
                B.CHANNEL_NO_DESC,
                A.USER_DINNER,
                NVL(C.USER_DINNER_DESC, '其他'),
                A.TYPE_ONE,
                A.TYPE_TWO,
                A.START_TIME,
                A.END_TIME;
    COMMIT;

    /*----插入渠道数据
    EXECUTE IMMEDIATE 'TRUNCATE TABLE CBZS_DM_KKPI_D_DEV_CUR_CHANNEL';
    INSERT INTO CBZS_DM_KKPI_D_DEV_CUR_CHANNEL
      SELECT SUBSTR(V_DATE, 1, 8),
             A.AREA_NO,
             B.CITY_NO,
             '1',
             B.HUAXIAO_TYPE,
             B.HUAXIAO_NO,
             '',
             B.CHANNEL_NO,
             B.CHANNEL_NO_DESC,
             A.TYPE_ONE,
             A.TYPE_TWO,
             SUM(A.APPEND_VALUE),
             SUM(A.CUR_VALUE),
             A.START_TIME,
             A.END_TIME
        FROM MID_CBZS_KKPI_D_DEV_CUR A, DIM.DIM_CHANNEL_HUAXIAO B
       WHERE A.DEALER_ID = B.CHANNEL_NO
       AND B.HUAXIAO_TYPE IN ('01','02','03','04')
       GROUP BY A.AREA_NO,
                B.CITY_NO,
                '1',
                B.HUAXIAO_TYPE,
                B.HUAXIAO_NO,
                '',
                B.CHANNEL_NO,
                B.CHANNEL_NO_DESC,
                A.TYPE_ONE,
                A.TYPE_TWO,
                A.START_TIME,
                A.END_TIME;
    COMMIT;

    -----插入二级指标数据
    EXECUTE IMMEDIATE 'TRUNCATE TABLE CBZS_DM_KKPI_D_DEV_CUR';

    INSERT INTO CBZS_DM_KKPI_D_DEV_CUR
      SELECT DAY_ID,
             AREA_NO,
             CITY_NO,
             HUAXIAO_TYPE_BIG,
             HUAXIAO_TYPE,
             HUAXIAO_NO,
             TYPE_ONE,
             TYPE_TWO,
             SUM(APPEND_VALUE),
             SUM(CUR_VALUE),
             START_TIME,
             END_TIME
        FROM CBZS_DM_KKPI_D_DEV_CUR_CHANNEL
       GROUP BY DAY_ID,
                AREA_NO,
                CITY_NO,
                HUAXIAO_TYPE_BIG,
                HUAXIAO_TYPE,
                HUAXIAO_NO,
                TYPE_ONE,
                TYPE_TWO,
                START_TIME,
                END_TIME;
    COMMIT;

    ----插入ADMIN数据
    EXECUTE IMMEDIATE 'TRUNCATE TABLE CBZS_DM_KKPI_D_DEV_CUR_ADMIN';
    INSERT INTO CBZS_DM_KKPI_D_DEV_CUR_ADMIN
      SELECT DAY_ID,
             AREA_NO,
             CITY_NO,
             HUAXIAO_TYPE_BIG,
             HUAXIAO_TYPE,
             TYPE_ONE,
             TYPE_TWO,
             SUM(APPEND_VALUE),
             SUM(CUR_VALUE),
             START_TIME,
             END_TIME
        FROM CBZS_DM_KKPI_D_DEV_CUR_CHANNEL
       GROUP BY DAY_ID,
                AREA_NO,
                CITY_NO,
                HUAXIAO_TYPE_BIG,
                HUAXIAO_TYPE,
                TYPE_ONE,
                TYPE_TWO,
                START_TIME,
                END_TIME;
    COMMIT;

    --=========================================== 备份数据 ==================================
    DELETE FROM CBZS_KKPI_D_DEV_CUR_BAK T
     WHERE T.DAY_ID = SUBSTR(V_DATE, 1, 8)
       AND T.END_TIME = SUBSTR(V_DATE, 9, 2);
    COMMIT;

    --删除2个月之前的数据
    DELETE FROM CBZS_KKPI_D_DEV_CUR_BAK T WHERE T.DAY_ID = V_LAST2_MON;
    COMMIT;

    INSERT INTO CBZS_KKPI_D_DEV_CUR_BAK
      SELECT * FROM CBZS_DM_KKPI_D_DEV_CUR_CHANNEL;

    COMMIT;*/

    --更新日志
    V_RETCODE := 'SUCCESS';
    ALLDM.P_ALLDM_UPDATE_LOG(V_DATE,
                             V_PKG,
                             V_PROCNAME,
                             '结束',
                             'SUCCESS',
                             SYSDATE);
  ELSE
    V_RETCODE := 'WAIT';
    ALLDM.P_ALLDM_UPDATE_LOG(V_DATE,
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
    ALLDM.P_ALLDM_UPDATE_LOG(V_DATE,
                             V_PKG,
                             V_PROCNAME,
                             V_RETINFO,
                             'FAIL',
                             SYSDATE);

END;
/
