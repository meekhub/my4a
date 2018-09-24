select sum(long_duration)/sum(zhu_call_duration) from TMP_MAJH_QIZHA_02_pre;

select count(*) from TMP_MAJH_QIZHA_02_pre a

--正常用户
  SELECT call_date,
           nvl(COUNT(CASE
                 WHEN B.ORG_TRM_ID = '10' THEN
                  B.OPPOSE_NUMBER
               END),0) ZHU_CALL_CDR, --主叫通话次数
         nvl(COUNT(CASE
                 WHEN B.ORG_TRM_ID = '10' and b.long_type<>'10' THEN
                  B.OPPOSE_NUMBER
               END),0) ZHU_CALL_CDR, --长途主叫通话次数
         nvl(COUNT(B.OPPOSE_NUMBER),0) CALL_CDR --总通话次数
    FROM (SELECT * FROM tmp_majh_qizha_pre_base where is_ocs='1') A
    LEFT JOIN (SELECT acct_month,ORG_TRM_ID,OPPOSE_NUMBER,call_date,DEVICE_NUMBER,long_type
                 FROM DW_V_USER_CDR_CDMA_OCS B
                WHERE ACCT_MONTH in ('201706')
                and area_no='188'
                ) B
      ON A.DEVICE_NUMBER = B.DEVICE_NUMBER
   GROUP BY call_date


