select sum(long_duration)/sum(zhu_call_duration) from TMP_MAJH_QIZHA_02_pre;

select count(*) from TMP_MAJH_QIZHA_02_pre a

--�����û�
  SELECT call_date,
           nvl(COUNT(CASE
                 WHEN B.ORG_TRM_ID = '10' THEN
                  B.OPPOSE_NUMBER
               END),0) ZHU_CALL_CDR, --����ͨ������
         nvl(COUNT(CASE
                 WHEN B.ORG_TRM_ID = '10' and b.long_type<>'10' THEN
                  B.OPPOSE_NUMBER
               END),0) ZHU_CALL_CDR, --��;����ͨ������
         nvl(COUNT(B.OPPOSE_NUMBER),0) CALL_CDR --��ͨ������
    FROM (SELECT * FROM tmp_majh_qizha_pre_base where is_ocs='1') A
    LEFT JOIN (SELECT acct_month,ORG_TRM_ID,OPPOSE_NUMBER,call_date,DEVICE_NUMBER,long_type
                 FROM DW_V_USER_CDR_CDMA_OCS B
                WHERE ACCT_MONTH in ('201706')
                and area_no='188'
                ) B
      ON A.DEVICE_NUMBER = B.DEVICE_NUMBER
   GROUP BY call_date


