 SELECT T.REGION_NO             CODE,
        T.REGION_NO_DESC        CODEDESC,
        M.AREA_NAME,
        M.DISPLAY_ORDER,
        M.CHANNEL_TYPE_DESC_FIR,
        M.CHANNEL_DEPT_DESC,
        M.REPORT_NAME,
        T.KPI_FZ,
        T.KPI_FM,
        T.LWL_DY_4,
        T.LWL_YJ_4,
        T.LWL_DY_5
   FROM (SELECT T.REGION_NO,
                T.REGION_NO_DESC,
                NVL(SUM(CASE
                          WHEN T.LW_KIND = '移动新发展用户月均离网率' THEN
                           T.KPI_FZ
                        END),
                    0) KPI_FZ,
                NVL(SUM(CASE
                          WHEN T.LW_KIND = '移动新发展用户月均离网率' THEN
                           T.KPI_FM
                        END),
                    0) KPI_FM,
                NVL(SUM(CASE
                          WHEN T.LW_KIND = '移动新发展用户月均离网率' THEN
                           T.LWL_DY
                        END),
                    0) LWL_DY_4,
                NVL(SUM(CASE
                          WHEN T.LW_KIND = '移动新发展用户月均离网率' THEN
                           T.LWL_YJ
                        END),
                    0) LWL_YJ_4,
                NVL(SUM(CASE
                          WHEN T.LW_KIND = '移动新发展用户离网率剔除指定套餐' THEN
                           T.LWL_DY
                        END),
                    0) LWL_DY_5
           FROM NEW_RPT_HBTELE.SJZX_GM_SCZB_LWL_010_M T
          WHERE T.REGION_KIND = '4'
            AND T.ACCT_MONTH = '201806'
          GROUP BY T.REGION_NO, T.REGION_NO_DESC) T,
        (SELECT M.CHANNEL_NO,
                M.CHANNEL_NO_DESC,
                B.AREA_NO,
                B.AREA_NAME,
                B.CITY_NO_NEW CITY_NO,
                NVL(B.DISPLAY_ORDER, '其他') DISPLAY_ORDER,
                B.AREA_NO_ORDER,
                B.CITY_NO_ORDER,
                M.CHANNEL_TYPE_DESC_FIR,
                M.CHANNEL_DEPT_DESC,
                CASE
                  WHEN M.LVL3_NAME IS NOT NULL THEN
                   M.LVL3_NAME
                  ELSE
                   M.LVL2_NAME
                END REPORT_NAME
           FROM DIM.DIM_CHANNEL_NO_LVL_M              M,
                NEW_RPT_HBTELE.DM_BUSI_ANAL_CITY_INFO B
          WHERE M.CITY_NO = B.CITY_NO(+)
            AND NEW_RPT_HBTELE.FUNC_GET_XIONGAN_AREA_NO(M.AREA_NO, M.CITY_NO) =
                B.AREA_NO(+)
            AND M.ACCT_MONTH = '201806') M
  WHERE T.REGION_NO = M.CHANNEL_NO(+)
  ORDER BY M.AREA_NO_ORDER, M.CITY_NO_ORDER
