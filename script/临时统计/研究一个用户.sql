create table tmp_majh_0206_01 as
select a.*
  from (select HUAXIAO_NO_03, price_fee, price_fee_ocs, iot_fee,a.device_number,a.user_no
          FROM DW.DW_V_USER_HUAXIAO_INFO_M A
         WHERE A.ACCT_MONTH = '201801'
           AND AREA_NO = '187'
              --AND A.IS_VALID = '1'
           AND A.IS_HUAXIAO_03 = '1') A,
       (SELECT *
          FROM DIM.DIM_HUAXIAO_INFO T
         WHERE T.AREA_NO = '187'
           AND T.HUAXIAO_TYPE IN ('01', '02', '03', '04')
           and huaxiao_no = '813060440070000') T
 WHERE A.HUAXIAO_NO_03 = T.HUAXIAO_NO
 
 
 select sum(price_fee+price_fee_ocs) from tmp_majh_0206_01
 

 create table tmp_majh_0206_02 as
select a.*,'channel' flag
  from (select HUAXIAO_NO_03, price_fee, price_fee_ocs, iot_fee,a.device_number,a.user_no,channel_no
  FROM DW.DW_V_USER_HUAXIAO_INFO_M A
                                 WHERE A.ACCT_MONTH = '201801'
                                   AND AREA_NO = '187' 
                                   AND A.XIAOQU_NO IS NULL
                                   AND A.TELE_TYPE = '2'
                                   AND A.IS_HUAXIAO_03 = '1') A,
                               (SELECT *
                                  FROM DIM.DIM_CHANNEL_HUAXIAO T
                                 WHERE T.AREA_NO = '187'
                                   AND T.HUAXIAO_TYPE = '03'
                                   and huaxiao_no = '813060440070000') T
                         WHERE A.HUAXIAO_NO_03 = T.HUAXIAO_NO
                           AND A.CHANNEL_NO = T.CHANNEL_NO
                           
                           
insert into tmp_majh_0206_02
select a.*,'xiaoqu' flag
  from (select HUAXIAO_NO_03, price_fee, price_fee_ocs, iot_fee,a.device_number,a.user_no,xiaoqu_no                          
                    FROM DW.DW_V_USER_HUAXIAO_INFO_M A
                                 WHERE A.ACCT_MONTH = '201801'
                                   AND AREA_NO = '187'
                                      -- AND A.IS_VALID = '1'
                                   AND ((A.XIAOQU_NO IS NOT NULL AND
                                       A.TELE_TYPE = '2') OR
                                       A.TELE_TYPE <> '2')
                                   AND A.IS_HUAXIAO_03 = '1' 
                                ) A,
                               (SELECT *
                                  FROM DIM.DIM_XIAOQU_HUAXIAO T
                                 WHERE T.AREA_NO = '187'
                                   AND T.HUAXIAO_TYPE = '03'
                                   and huaxiao_no = '813060440070000') T
                         WHERE A.HUAXIAO_NO_03 = T.HUAXIAO_NO
                           AND A.XIAOQU_NO = T.XIAOQU_NO
                           
select sum(price_fee+price_fee_ocs) from tmp_majh_0206_02;



select a.* from tmp_majh_0206_01 a,
tmp_majh_0206_02 b
where a.user_no=b.user_no(+)
and b.user_no is null


select *
  FROM DW.DW_V_USER_HUAXIAO_INFO_M A
 WHERE A.ACCT_MONTH = '201801'
   AND AREA_NO = '187'
      -- AND A.IS_VALID = '1'
   AND ((A.XIAOQU_NO IS NOT NULL AND A.TELE_TYPE = '2') OR
       A.TELE_TYPE <> '2')
   AND A.IS_HUAXIAO_03 = '1'
   and user_no = '930536771'


select * from dim.dim_huaxiao_info where huaxiao_no='813060440070000'


SELECT *
                                  FROM DIM.DIM_XIAOQU_HUAXIAO T
                                 WHERE T.AREA_NO = '187'
                                   --AND T.HUAXIAO_TYPE = '03'
                                   and xiaoqu_no='1873598648020140924'



SELECT AREA_NO,
       account_no,
       customer_no,
       device_number,
       user_status,
       NVL(BUNDLE_ID_ALLOWANCE, BUNDLE_ID) AS BUNDLE_ID,
       IS_ONNET,
       BUNDLE_DINNER_BEG_DATE
  FROM DW.DW_V_USER_BASE_INFO_USER T
 WHERE ACCT_MONTH = '201801'
   AND AREA_NO = '187'
   AND TELE_TYPE <> '2'
   AND NVL(IS_KD_BUNDLE, '0') <> '0'
   and bundle_id = '100650989313'
                   
                   
SELECT USER_NO,
                       T.GRADE_0 || '/' || T.GRADE_1 || '/' || T.GRADE_2 || '/' ||
                       T.GRADE_3 || '/' || T.GRADE_4 STDADDR_NAME
                  FROM DW.DW_V_USER_ADSL_EIGHT_M T
                 WHERE ACCT_MONTH = '201801'
                   AND T.AREA_NO = '187'
                   AND USER_NO in ('1522987645','1360943605','1360943606')
                   
                   
                   
