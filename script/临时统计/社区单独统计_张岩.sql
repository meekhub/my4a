DECLARE
  V_MONTH VARCHAR2(100);
  V_LAST_MONTH  VARCHAR2(100);
  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018' ORDER BY IDX_NO;
BEGIN
  FOR V_NUM IN 201706 .. 201712 LOOP
    V_MONTH := TO_CHAR(V_NUM);
    V_LAST_MONTH := TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH, 'YYYYMM'), -1),
                          'YYYYMM');
    FOR C1 IN V_AREA LOOP
     --取本月固网融合用户
      EXECUTE IMMEDIATE 'TRUNCATE TABLE tmp_majh_sq_0125_01';
      INSERT INTO tmp_majh_sq_0125_01
        SELECT /*+ORDERED*/
         v_month ACCT_MONTH,
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
         E.HUAXIAO_TYPE_NAME
        
          FROM (SELECT AREA_NO,
                       CITY_NO,
                       USER_NO,
                       DEVICE_NUMBER,
                       CHANNEL_NO,
                       CHANNEL_NO_DESC,
                       IS_KD_BUNDLE,
                       TELE_TYPE,
                       NVL(BUNDLE_ID_ALLOWANCE, BUNDLE_ID) AS BUNDLE_ID,
                       IS_ONNET
                  FROM DW.DW_V_USER_BASE_INFO_USER T
                 WHERE ACCT_MONTH = v_month
                   AND AREA_NO = C1.AREA_NO
                   AND TELE_TYPE <> '2'
                   AND NVL(IS_KD_BUNDLE, '0') <> '0') A,
               
               (SELECT USER_NO,
                       T.GRADE_0 || '/' || T.GRADE_1 || '/' || T.GRADE_2 || '/' ||
                       T.GRADE_3 || '/' || T.GRADE_4 STDADDR_NAME
                  FROM DW.DW_V_USER_ADSL_EIGHT_M T
                 WHERE ACCT_MONTH = v_month
                   AND T.AREA_NO = C1.AREA_NO
                   AND USER_NO IS NOT NULL) B,
               
               (SELECT * FROM ALLDMCODE.DMCODE_XIAOQU_STD_ADDR_NEW) C,
               
               DIM.DIM_XIAOQU_HUAXIAO E
        
         WHERE A.USER_NO = B.USER_NO(+)
           AND B.STDADDR_NAME = C.STDADDR_NAME(+)
           AND C.XIAOQU_NO = E.XIAOQU_NO(+);
           commit;      


      EXECUTE IMMEDIATE 'TRUNCATE TABLE tmp_majh_sq_0125_02';
      INSERT INTO tmp_majh_sq_0125_02
        SELECT *
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
                       END)) RN
                  FROM tmp_majh_sq_0125_01 A)
         WHERE RN = 1;
      COMMIT;
          
      execute immediate 'truncate table tmp_majh_shequ_03';
      insert into temp_user.tmp_majh_shequ_03
        select v_month,
               c1.area_no,
               a.user_no,
         
         CASE
           WHEN  A.TELE_TYPE_NAME IN ('移动', '宽带', '电视', '固话') AND
                A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
                G.XIAOQU_NO IS NOT NULL AND G1.HUAXIAO_TYPE = '03' THEN
            '1' --对于融合解绑的用户，解绑后还是按照融合时固网装机地址   20171120 柴占飞修改：优先取解绑的用户
         
           WHEN  A.TELE_TYPE_NAME IN ('移动', '宽带', '电视', '固话') AND
                A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE = '2' AND
                D3.HUAXIAO_TYPE = '03' AND D1.HUAXIAO_TYPE IS NULL AND
                D2.HUAXIAO_TYPE IS NULL AND G.XIAOQU_NO IS NULL THEN
            '1' --单C
           WHEN  A.TELE_TYPE_NAME IN ('移动', '宽带', '电视', '固话') AND
                A.IS_KD_BUNDLE = '0' AND A.TELE_TYPE <> '2' AND
                E1.HUAXIAO_TYPE = '03' THEN
            '1' --单固
           WHEN  A.TELE_TYPE_NAME IN ('移动', '宽带', '电视', '固话') AND
                F.HUAXIAO_TYPE = '03' THEN
            '1' --融合
           ELSE
            '0'
         END IS_HUAXIAO_03, --是否社区支局-渠道类(不含物联网和专线电路)
               case when b2.user_no is not null then '1' else '0' end,
               a.is_onnet,
               case when a.is_acct='1' or a.is_acct_ocs='1' then '1' else '0' end is_acct,
               a.price_fee,
               a.tele_type,
               a.is_kd_bundle
          FROM (SELECT user_no,
                       is_onnet,
                       (price_fee+price_fee_ocs) price_fee,
                       is_acct,
                       is_acct_ocs,
                       channel_no,
                       tele_type,
                       IS_KD_BUNDLE,
                       NVL(BUNDLE_ID_ALLOWANCE, BUNDLE_ID) BUNDLE_ID,
                       CASE
                         WHEN TELE_TYPE = '2' THEN
                          '移动'
                         WHEN TELE_TYPE IN ('4', '26') AND
                              INNET_METHOD IN ('1', '2', '4', '5', '15') THEN
                          '宽带'
                         WHEN TELE_TYPE = '72' THEN
                          '电视'
                         WHEN TELE_TYPE_NEW IN ('G020', 'G040') THEN
                          '专线电路'
                         WHEN TELE_TYPE_NEW IN ('G000', 'G001', 'G002') THEN
                          '固话'
                       END TELE_TYPE_NAME
                  FROM DW.DW_V_USER_BASE_INFO_USER A
                 WHERE ACCT_MONTH = v_month
                   AND AREA_NO = C1.AREA_NO
                   AND tele_type='2'
                   and (TELE_TYPE IN ('2', '72') OR
                       (TELE_TYPE IN ('4', '26') AND
                       INNET_METHOD IN ('1', '2', '4', '5', '15')) OR
                       TELE_TYPE_NEW IN
                       ('G020', 'G040', 'G000', 'G001', 'G002'))) A,
               
               (SELECT USER_NO,
                       T.GRADE_0 || '/' || T.GRADE_1 || '/' || T.GRADE_2 || '/' ||
                       T.GRADE_3 || '/' || T.GRADE_4 STDADDR_NAME
                  FROM DW.DW_V_USER_ADSL_EIGHT_M T
                 WHERE ACCT_MONTH = v_month
                   AND T.AREA_NO = C1.AREA_NO
                   AND USER_NO IS NOT NULL) B,
               
               (SELECT USER_NO
                  FROM DW.DW_V_USER_SCHOOL_HX_USER_M T
                 WHERE ACCT_MONTH = v_month
                   AND T.AREA_NO = C1.AREA_NO) B2,
               
               (SELECT * FROM ALLDMCODE.DMCODE_XIAOQU_STD_ADDR_NEW) C,
               (SELECT *
                  FROM DIM.DIM_CHANNEL_HUAXIAO
                 WHERE HUAXIAO_TYPE = '01') D1, --自营厅
               (SELECT *
                  FROM DIM.DIM_CHANNEL_HUAXIAO
                 WHERE HUAXIAO_TYPE = '02') D2, --商圈支局
               (SELECT *
                  FROM DIM.DIM_CHANNEL_HUAXIAO
                 WHERE HUAXIAO_TYPE = '03') D3, --社区支局 
               
               (SELECT *
                  FROM DIM.DIM_XIAOQU_HUAXIAO
                 WHERE HUAXIAO_TYPE = '03') E1, --社区支局
               
               (SELECT USER_NO, XIAOQU_NO, XIAOQU_NAME
                  FROM dw.DW_V_USER_HUAXIAO_INFO_M G
                 WHERE ACCT_MONTH = V_LAST_MONTH
                   AND AREA_NO = C1.AREA_NO) G, --上月沉淀的基础表                 \
               (SELECT *
                  FROM DIM.DIM_XIAOQU_HUAXIAO
                 WHERE HUAXIAO_TYPE = '03') G1, --社区支局                 
                 (SELECT * FROM tmp_majh_sq_0125_02) F --融合宽带用户
         WHERE A.USER_NO = B.USER_NO(+)
           AND B.STDADDR_NAME = C.STDADDR_NAME(+)
           AND A.USER_NO = B2.USER_NO(+)
           AND A.CHANNEL_NO = D1.CHANNEL_NO(+)
           AND A.CHANNEL_NO = D2.CHANNEL_NO(+)
           AND A.CHANNEL_NO = D3.CHANNEL_NO(+)
           AND C.XIAOQU_NO = E1.XIAOQU_NO(+)
           and a.user_no = g.user_no(+)
           AND G.XIAOQU_NO = G1.XIAOQU_NO(+)
           AND A.BUNDLE_ID = F.BUNDLE_ID(+)
           ;
      COMMIT;
      
      insert into tmp_majh_shequ_04
      select 
      v_month,
      c1.area_desc,
      count(distinct case when a.is_onnet='1' then a.user_no end),
      count(distinct case when a.is_onnet='1' and a.is_school='1' then a.user_no end),
       count(distinct case when a.is_onnet='1'and a.tele_type='2' and a.is_kd_bundle='0' and b.user_no is not null then a.user_no end),
      count(distinct case when a.is_acct='1' then a.user_no end),
      count(distinct case when a.is_acct='1' and a.is_school='1' then a.user_no end),
       count(distinct case when a.is_acct='1'and a.tele_type='2' and a.is_kd_bundle='0' and b.user_no is not null then a.user_no end),       
       sum(a.price_fee),
       sum(case when a.is_school='1' then a.price_fee else 0 end),
       sum(case when b.user_no is not null and a.is_kd_bundle='0' and a.tele_type='2' then a.price_fee else 0 end)
       from (select * from temp_user.tmp_majh_shequ_03 where is_huaxiao_03='1') a,
      (select * from tmp_majh_0116_01 where acct_month=v_month and area_no=c1.area_no) b
      where a.user_no=b.user_no(+);
      commit;
    END LOOP;
  END LOOP;
END;
