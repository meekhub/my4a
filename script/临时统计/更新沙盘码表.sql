select * from STAGE.ITF_OTHER_HUAXIAO_info@hbods a where a.day_id='20180509'

select * from STAGE.ITF_OTHER_HUAXIAO_xiaoqu@hbods where day_id='20180509';


      DELETE FROM ALLDMCODE.DMCODE_XIAOQU_STD_ADDR_NEW;
      COMMIT;
      
      INSERT INTO ALLDMCODE.DMCODE_XIAOQU_STD_ADDR_NEW
        SELECT DISTINCT T.SUBDISTRICT_ID,
                        T.SUBDISTRICT_NAME,
                        '',
                        T.ADDR1_NAME || '/' || T.ADDR2_NAME || '/' ||
                        T.ADDR3_NAME || '/' || T.ADDR4_NAME || '/' ||
                        T.ADDR5_NAME STDADDR_NAME,
                        T.SCHOOL_FLAG
          FROM STAGE.ITF_OTHER_HUAXIAO_XIAOQU@HBODS T
         WHERE T.DAY_ID = V_DATE
           AND T.SUBDISTRICT_ID IS NOT NULL;
      COMMIT;
      
      --更新划小与小区对应关系表
      DELETE FROM DIM.DIM_XIAOQU_HUAXIAO T;
      COMMIT;
      
      INSERT INTO DIM.DIM_XIAOQU_HUAXIAO
        SELECT DISTINCT AREA_NO,
                        CITY_NO,
                        T.SUBDISTRICT_ID,
                        T.SUBDISTRICT_NAME,
                        HUAXIAO_NO,
                        HUAXIAO_NAME,
                        HUAXIAO_TYPE,
                        HUAXIAO_TYPE_NAME,
                        IF_VALID,
                        UPDATE_USER,
                        TO_DATE(UPDATE_DATE, 'YYYYMMDDHH24MISS'),
                        IDX_NO,
                        HUAXIAO_TYPE_BIG,
                        HUAXIAO_TYPE_NAME_BIG
          FROM STAGE.ITF_OTHER_HUAXIAO_XIAOQU@HBODS T
         WHERE T.DAY_ID = V_DATE
           AND HUAXIAO_NO IS NOT NULL
           AND HUAXIAO_TYPE IN ('01','02','03','04');
      COMMIT;
      
      ---20180209 李亚增加政企数据
    INSERT INTO DIM.DIM_XIAOQU_HUAXIAO
      SELECT *
        FROM DIM.DIM_ZQ_XIAOQU_HUAXIAO A
       WHERE NOT EXISTS (SELECT 1
                FROM DIM.DIM_XIAOQU_HUAXIAO B
               WHERE A.XIAOQU_NO = B.XIAOQU_NO);
           commit;

      
      --更新划小信息表
      DELETE FROM DIM.DIM_HUAXIAO_INFO T;
      COMMIT;
      
      INSERT INTO DIM.DIM_HUAXIAO_INFO
        SELECT AREA_NO,
               CITY_NO,
               HUAXIAO_NO,
               HUAXIAO_NAME,
               HUAXIAO_TYPE,
               HUAXIAO_TYPE_NAME,
               IF_VALID,
               UPDATE_USER,
               TO_DATE(UPDATE_DATE, 'YYYYMMDDHH24MISS'),
               IDX_NO,
               CREATE_USER,
               TO_DATE(CREATE_DATE, 'YYYYMMDDHH24MISS'),
               HUAXIAO_TYPE_BIG,
               HUAXIAO_TYPE_NAME_BIG,
               MANAGER_LOGINID,
               MANAGER_LOGINNAME,
               MANAGER_TELEPHONE
          FROM STAGE.ITF_OTHER_HUAXIAO_INFO@HBODS T
         WHERE T.DAY_ID = V_DATE
           AND T.HUAXIAO_NAME <> '乙类项目';
      COMMIT;
      
     --20180109 增加后端划小数据
     INSERT INTO DIM.DIM_HUAXIAO_INFO
       SELECT AREA_NO,
              CITY_NO,
              HUAXIAO_NO,
              HUAXIAO_NAME,
              HUAXIAO_TYPE,
              HUAXIAO_TYPE_NAME,
              IF_VALID,
              UPDATE_USER,
              UPDATE_DATE,
              IDX_NO,
              CREATE_USER,
              CREATE_DATE,
              HUAXIAO_TYPE_BIG,
              HUAXIAO_TYPE_NAME_BIG,
              MANAGER_LOGINID,
              MANAGER_LOGINNAME,
              MANAGER_TELEPHONE
         FROM DIM.DIM_HD_HUAXIAO_INFO A
        WHERE NOT EXISTS (SELECT 1
                 FROM DIM.DIM_HUAXIAO_INFO B
                WHERE A.HUAXIAO_NO = B.HUAXIAO_NO)
          AND NOT EXISTS
        (SELECT 1
                 FROM DIM.DIM_HUAXIAO_INFO B
                WHERE A.AREA_NO = B.AREA_NO
                  AND A.CITY_NO = B.CITY_NO
                  AND A.HUAXIAO_NAME = B.HUAXIAO_NAME);
     COMMIT;
     ---20180209 李亚增加政企数据
     INSERT INTO DIM.DIM_HUAXIAO_INFO
       SELECT AREA_NO,
              CITY_NO,
              HUAXIAO_NO,
              HUAXIAO_NAME,
              HUAXIAO_TYPE,
              HUAXIAO_TYPE_NAME,
              IF_VALID,
              UPDATE_USER,
              UPDATE_DATE,
              IDX_NO,
              CREATE_USER,
              CREATE_DATE,
              HUAXIAO_TYPE_BIG,
              HUAXIAO_TYPE_NAME_BIG,
              MANAGER_LOGINID,
              MANAGER_LOGINNAME,
              MANAGER_TELEPHONE
         FROM DIM.DIM_ZQ_HUAXIAO_INFO A
        WHERE NOT EXISTS (SELECT 1
                 FROM DIM.DIM_HUAXIAO_INFO B
                WHERE A.HUAXIAO_NO = B.HUAXIAO_NO)
          AND NOT EXISTS
        (SELECT 1
                 FROM DIM.DIM_HUAXIAO_INFO B
                WHERE A.AREA_NO = B.AREA_NO
                  AND A.CITY_NO = B.CITY_NO
                  AND A.HUAXIAO_NAME = B.HUAXIAO_NAME);
     COMMIT;
      
     --与划小信息中的地市、区县等信息保持一致
   UPDATE DIM.DIM_CHANNEL_HUAXIAO T
      SET T.AREA_NO     =
          (SELECT T2.AREA_NO
             FROM DIM.DIM_HUAXIAO_INFO T2
            WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO),
          T.CITY_NO     =
          (SELECT T2.CITY_NO
             FROM DIM.DIM_HUAXIAO_INFO T2
            WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO),
          T.HUAXIAO_NAME =
          (SELECT T2.HUAXIAO_NAME
             FROM DIM.DIM_HUAXIAO_INFO T2
            WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO),
          T.HUAXIAO_TYPE =
          (SELECT T2.HUAXIAO_TYPE
             FROM DIM.DIM_HUAXIAO_INFO T2
            WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO),
          
          T.HUAXIAO_TYPE_NAME =
          (SELECT T2.HUAXIAO_TYPE_NAME
             FROM DIM.DIM_HUAXIAO_INFO T2
            WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO),
          
          T.HUAXIAO_TYPE_BIG =
          (SELECT T2.HUAXIAO_TYPE_BIG
             FROM DIM.DIM_HUAXIAO_INFO T2
            WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO),
          
          T.HUAXIAO_TYPE_NAME_BIG =
          (SELECT T2.HUAXIAO_TYPE_NAME_BIG
             FROM DIM.DIM_HUAXIAO_INFO T2
            WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO),
          
          T.IF_VALID =
          (SELECT T2.IF_VALID
             FROM DIM.DIM_HUAXIAO_INFO T2
            WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO)
       WHERE EXISTS (SELECT 1
          FROM DIM.DIM_HUAXIAO_INFO T2
         WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO);
   COMMIT;
   
   --与划小信息中的地市、区县等信息保持一致
   UPDATE DIM.DIM_XIAOQU_HUAXIAO T
   
      SET T.AREA_NO =
          (SELECT T2.AREA_NO
             FROM DIM.DIM_HUAXIAO_INFO T2
            WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO),
          T.CITY_NO =
          (SELECT T2.CITY_NO
             FROM DIM.DIM_HUAXIAO_INFO T2
            WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO),
          
          T.HUAXIAO_NAME =
          (SELECT T2.HUAXIAO_NAME
             FROM DIM.DIM_HUAXIAO_INFO T2
            WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO),
          T.HUAXIAO_TYPE =
          (SELECT T2.HUAXIAO_TYPE
             FROM DIM.DIM_HUAXIAO_INFO T2
            WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO),
          
          T.HUAXIAO_TYPE_NAME =
          (SELECT T2.HUAXIAO_TYPE_NAME
             FROM DIM.DIM_HUAXIAO_INFO T2
            WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO),
          
          T.HUAXIAO_TYPE_BIG =
          (SELECT T2.HUAXIAO_TYPE_BIG
             FROM DIM.DIM_HUAXIAO_INFO T2
            WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO),
          
          T.HUAXIAO_TYPE_NAME_BIG =
          (SELECT T2.HUAXIAO_TYPE_NAME_BIG
             FROM DIM.DIM_HUAXIAO_INFO T2
            WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO),
          
          T.IF_VALID =
          (SELECT T2.IF_VALID
             FROM DIM.DIM_HUAXIAO_INFO T2
            WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO)
       WHERE EXISTS (SELECT 1
          FROM DIM.DIM_HUAXIAO_INFO T2
         WHERE T2.HUAXIAO_NO = T.HUAXIAO_NO);
   COMMIT;
