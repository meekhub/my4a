--用户宽表查询
SELECT *
  FROM DW.DW_V_USER_BASE_INFO_USER A
 WHERE ACCT_MONTH = '201705'
   AND AREA_NO = '188'
   AND TELE_TYPE = '2'
   AND DEVICE_NUMBER IN (17778279569,
                         17778279553,
                         17778279551,
                         17778279576,
                         17778279570,
                         17778279571,
                         17330111020,
                         17330111016,
                         17778285857,
                         17336301507,
                         17778276897,
                         17778276260,
                         17778276896,
                         17778276263,
                         17778276232,
                         17769024540,
                         17778276212,
                         17778282372,
                         17778276165,
                         17778276252,
                         17778276167,
                         17778276191)



--终端注册
SELECT *
  FROM DW.DW_V_USER_TERMINAL_USER_M
 WHERE ACCT_MONTH = '201705'
   AND DEVICE_NO IN (17778279569,
                     17778279553,
                     17778279551,
                     17778279576,
                     17778279570,
                     17778279571,
                     17330111020,
                     17330111016,
                     17778285857,
                     17336301507,
                     17778276897,
                     17778276260,
                     17778276896,
                     17778276263,
                     17778276232,
                     17769024540,
                     17778276212,
                     17778282372,
                     17778276165,
                     17778276252,
                     17778276167,
                     17778276191)



--详单查询
select * from dw.dw_v_user_cdr_cdma_ocs where acct_month='201704'
and device_number='17778279569'


SELECT /*+FULL(B)*/
 *
  FROM DIM.DIM_AREA_CONTRAST
 where city_cd = '384'



--循环跑20个号码通话行为信息
DECLARE
  V_CALL_DATE VARCHAR2(100);
  CURSOR V_AREA IS
    SELECT *
      FROM DIM.DIM_AREA_NO
     WHERE AREA_NO <> '018'
       AND AREA_NO = '188'
     ORDER BY IDX_NO;
BEGIN
  FOR V_NUM IN 20170301 .. 20170331 LOOP
    V_CALL_DATE := SUBSTR(TO_CHAR(V_NUM), 7, 2);
    FOR C1 IN V_AREA LOOP
      INSERT INTO TMP_MAJH_0726_01
        SELECT TO_CHAR(V_NUM),
               DEVICE_NUMBER,
               OPPOSE_NUMBER,
               CELL_NO,
               TO_CHAR(START_CALL_TIME, 'YYYY-MM-DD HH24:MI:SS'),
               CALL_DURATION
          FROM DW.DW_V_USER_CDR_CDMA_OCS
         WHERE ACCT_MONTH =SUBSTR(TO_CHAR(V_NUM), 1, 6)
           --AND AREA_NO='188'
           AND CALL_DATE = V_CALL_DATE
           AND DEVICE_NUMBER IN (17778279569,
                                 17778279553,
                                 17778279551,
                                 17778279576,
                                 17778279570,
                                 17778279571,
                                 17330111020,
                                 17330111016,
                                 17778285857,
                                 17336301507,
                                 17778276897,
                                 17778276260,
                                 17778276896,
                                 17778276263,
                                 17778276232,
                                 17769024540,
                                 17778276212,
                                 17778282372,
                                 17778276165,
                                 17778276252,
                                 17778276167,
                                 17778276191)
           AND ROAM_TYPE = '12';
      COMMIT;
    END LOOP;
  END LOOP;
END;












