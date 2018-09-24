INSERT INTO TMP171102_ZHXL_YZF_XF
  SELECT '20170930' ACCT_MONTH,
         AREA_NO,
         A.DEVICE_NUMBER,
         SUM(A.CHARGE_FEE) XF_JE,
         COUNT(1) XF_NUMS
    FROM (SELECT *
            FROM (SELECT A.DAY_ID,
                         A.LATN_ID AREA_NO,
                         A.SUPPLY_ORG_CODE SHOP_CODE,
                         A.PRODUCT_NO DEVICE_NUMBER,
                         A.TXN_AMT / 100 CHARGE_FEE,
                         A.TXN_TYPE,
                         A.BUSINESS_TYPE,
                         A.CODE_VALUE,
                         CASE
                           WHEN A.CANCEL_FLAG = '1' OR A.REVSAL_FLAG = '1' OR
                                A.RETURN_FLAG = '1' THEN
                            '0'
                           ELSE
                            '1'
                         END IS_SUC
                    FROM ALLDM.BWT_DOWN_YZF_LOGPAY_D A) A
           WHERE A.TXN_TYPE IN ('131300',
                                '131280',
                                '13A010',
                                '13B010',
                                '131014',
                                '131170',
                                '131220',
                                '132010',
                                '131200',
                                '133000',
                                '731050',
                                '131290',
                                '131270',
                                '131191',
                                '131080',
                                '131010',
                                '131090',
                                '131310',
                                '131040',
                                '134020',
                                '131100',
                                '131210',
                                '131240',
                                '131065',
                                '131260',
                                '280010',
                                '131180',
                                '131150',
                                '151120',
                                '131250',
                                '134010',
                                '13Y010',
                                '131070',
                                '133010',
                                '731040',
                                '131230')
             AND SUBSTR(A.DAY_ID, 1, 6) = SUBSTR(20170930, 1, 6)
             AND A.DAY_ID <= '20170930'
             AND A.IS_SUC = '1'
          UNION ALL
          SELECT TO_CHAR(TO_DATE(B.OP_TIME, 'YYYY-MM-DD'), 'YYYYMMDD'),
                 B.JT_CITY_CODE,
                 B.MERCHANT_CODE,
                 B.PHONE,
                 B.TXN_AMT,
                 '',
                 '',
                 '',
                 '1'
            FROM ALLDM.BWT_DOWN_YZF_TXN_O2O_SHANGHU_D B
           WHERE SUBSTR(TO_CHAR(TO_DATE(B.OP_TIME, 'YYYY-MM-DD'), 'YYYYMMDD'),
                        1,
                        6) = SUBSTR(20170930, 1, 6)
             AND TO_CHAR(TO_DATE(B.OP_TIME, 'YYYY-MM-DD'), 'YYYYMMDD') <=
                 '20170930'
             AND TO_CHAR(TO_DATE(B.OP_TIME, 'YYYY-MM-DD'), 'YYYYMMDD') >=
                 '20170901'
             AND B.PAY_TYPE = '收款码'
             AND B.MCHNT_TYPE = '互联网') A
   GROUP BY A.AREA_NO, A.DEVICE_NUMBER;
COMMIT;


create table tmp171102_zhxl_yzf_user as 
SELECT '201709' ACCT_MONTH,
       A.AREA_NO,
       A.CITY_NO,
       A.CHANNEL_NO,
       A.USER_NO,
       A.DEVICE_NUMBER,
       A.IS_OCS,
       A.INNET_DATE,
       A.USER_DINNER,
       A.IS_KD_BUNDLE,
       A.CHANNEL_NO_ZC,
       A.USER_STATUS_DESC,
       A.BEGIN_DATE,
       A.SALES_MODE,
       A.SALES_MODE_DESC,
       A.DW_FLAG,
       A.DW_FLAG_NAME,
       B.BALANCE,
       C.TOTAL_FEE + C.TOTAL_FEE_OCS TOTAL_FEE,
       C.OWE_FEE
  FROM (SELECT *
          FROM RPT_HBTELE.SJZX_GM_YZF_HB_USER_010_D
         WHERE DAY_ID = '20170930') A,
       (SELECT '201709',
               T.CITY_CODE,
               T.USER_ID,
               8,
               SUM(T.BALANCE / 100) BALANCE
          FROM ACCT_DSG.BF_BESTPAY_PAY_FEE_HIS_T@HBODS T
         WHERE TO_CHAR(T.OPERATE_DATE, 'YYYYMM') = '201709'
           AND T.PAY_WAY = 11
           AND T.STATE = 1
         GROUP BY CITY_CODE, USER_ID) B,
       (SELECT *
          FROM DW.DW_V_USER_BASE_INFO_USER
         WHERE ACCT_MONTH = '201709'
           AND TELE_TYPE = '2') C
 WHERE A.USER_NO = B.USER_ID(+)
   AND A.USER_NO = C.USER_NO(+);
       
       
       select count(1) from tmp171102_zhxl_yzf_user
       


select a.*,b.xf_je 消费金额,b.xf_nums 消费次数 from tmp171102_zhxl_yzf_user a,
(select * from tmp171102_zhxl_yzf_xf where acct_month='20170930') b
where a.device_number=b.device_number(+)
