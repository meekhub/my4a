select t.acct_month,t.area_no,
       sum(t.dev_score_all),
       sum(t.income_score_all),
       sum(t.weixi_score_all),
       sum(t.fine_score_all),
       sum(t.FINE_SCORE_DEV),
       sum(t.jf_score_all)
  from rpt_hbtele.SJZX_WH_CHANNEL_JF_SCORE_010_M t
 where t.acct_month >= '201802'
 and area_no='183'
 group by t.acct_month,t.area_no


SELECT A.ACCT_MONTH,
       SUM(NEW_NUM),
       SUM(CDMA_NUM),
       SUM(ADSL_NUM),
       SUM(IPTV_NUM),
       SUM(TOTAL_FEE),
       SUM(TOTAL_FEE_YEAR),
       SUM(DEVLP_SORE),
       SUM(INCOME_SORE),
       SUM(WEIXI_SORE),
       SUM(FINE_SORE),
       SUM(GIVE_SORE),
       SUM(SUM_SORE),
       SUM(ONNET_CDMA_NUM),
       SUM(ONNET_ADSL_NUM),
       SUM(ONNET_IPTV_NUM),
       SUM(ACCT_CDMA_NUM),
       SUM(ACCT_ADSL_NUM),
       SUM(ACCT_IPTV_NUM),
       SUM(SCHOOL_DEVLP_SORE),
       SUM(SCHOOL_INCOME_SORE),
       SUM(SCHOOL_WEIXI_SORE),
       SUM(SCHOOL_FINE_SORE),
       SUM(SCHOOL_GIVE_SORE),
       SUM(SCHOOL_SUM_SORE)
  FROM DM_V_HUAXIAO_INFO_M A
 WHERE A.ACCT_MONTH >= '201802'
 GROUP BY A.ACCT_MONTH



SELECT A.ACCT_MONTH,
       SUM(NEW_NUM),
       SUM(CDMA_NUM),
       SUM(ADSL_NUM),
       SUM(IPTV_NUM),
       SUM(TOTAL_FEE),
       SUM(TOTAL_FEE_YEAR),
       SUM(DEVLP_SORE),
       SUM(INCOME_SORE),
       SUM(WEIXI_SORE),
       SUM(FINE_SORE),
       SUM(GIVE_SORE),
       SUM(SUM_SORE),
       SUM(ONNET_CDMA_NUM),
       SUM(ONNET_ADSL_NUM),
       SUM(ONNET_IPTV_NUM),
       SUM(ACCT_CDMA_NUM),
       SUM(ACCT_ADSL_NUM),
       SUM(ACCT_IPTV_NUM),
       SUM(SCHOOL_DEVLP_SORE),
       SUM(SCHOOL_INCOME_SORE),
       SUM(SCHOOL_WEIXI_SORE),
       SUM(SCHOOL_FINE_SORE),
       SUM(SCHOOL_GIVE_SORE),
       SUM(SCHOOL_SUM_SORE)
  FROM DM_V_CHANNEL_INFO_M A
 WHERE A.ACCT_MONTH >= '201802'
 GROUP BY A.ACCT_MONTH

