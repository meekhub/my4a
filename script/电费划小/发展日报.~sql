new_mobile_cbzs.cbzs_dmcode_dep_type
new_mobile_cbzs.cbzs_dm_kkpi_d_dev_admin
new_mobile_cbzs.cbzs_dm_kkpi_d_dev
new_mobile_cbzs.cbzs_dm_kkpi_d_dev_channel
new_mobile_cbzs.cbzs_dm_kkpi_d_dev_dinner;



/*SELECT B.TYPE_TWO_DESC, SUM(A.CUR_VALUE), SUM(A.MONTH_VALUE)
  FROM CBZS_DM_KKPI_D_DEV_ADMIN A, CBZS_DMCODE_DEP_TYPE B
 WHERE A.DAY_ID = '20180910'
   AND A.TYPE_ONE = B.TYPE_ONE
   AND A.TYPE_TWO = B.TYPE_TWO
 GROUP BY B.TYPE_TWO_DESC, B.TYPE_TWO_ORD
 ORDER BY B.TYPE_TWO_ORD;*/
 
--一级页面 展示指标
SELECT Y.TYPE_TWO_DESC,
       SUM(X.CUR_VALUE),
       SUM(X.MONTH_VALUE),
       ROUND(((SUM(X.MONTH_VALUE) - SUM(X.MONTH_VALUE_LM)) /
             SUM(X.MONTH_VALUE_LM)) * 100,
             2) || '%'
  FROM (SELECT TYPE_ONE, TYPE_TWO, CUR_VALUE, MONTH_VALUE, 0 MONTH_VALUE_LM
          FROM CBZS_DM_KKPI_D_DEV_ADMIN A
         WHERE A.DAY_ID = '20180910'
        UNION ALL
        SELECT TYPE_ONE, TYPE_TWO, 0, 0, MONTH_VALUE
          FROM CBZS_DM_KKPI_D_DEV_ADMIN A
         WHERE A.DAY_ID = '20180810') X,
       CBZS_DMCODE_DEP_TYPE Y
 WHERE X.TYPE_ONE = Y.TYPE_ONE
   AND X.TYPE_TWO = Y.TYPE_TWO
 GROUP BY Y.TYPE_TWO_DESC, Y.TYPE_TWO_ORD
 ORDER BY Y.TYPE_TWO_ORD;
 
 
--二级页面  展示“移动网上”
SELECT Y.AREA_DESC,
       SUM(X.CUR_VALUE),
       SUM(X.MONTH_VALUE),
       ROUND(((SUM(X.MONTH_VALUE) - SUM(X.MONTH_VALUE_LM)) /
             SUM(X.MONTH_VALUE_LM)) * 100,
             2) || '%'
  FROM (SELECT AREA_NO,TYPE_ONE, TYPE_TWO, CUR_VALUE, MONTH_VALUE, 0 MONTH_VALUE_LM
          FROM CBZS_DM_KKPI_D_DEV_ADMIN A
         WHERE A.DAY_ID = '20180910'
        UNION ALL
        SELECT AREA_NO,TYPE_ONE, TYPE_TWO, 0, 0, MONTH_VALUE
          FROM CBZS_DM_KKPI_D_DEV_ADMIN A
         WHERE A.DAY_ID = '20180810') X,
       DIM.DIM_AREA_NO Y
 WHERE X.AREA_NO=Y.AREA_NO
   AND X.TYPE_ONE='01'
   AND X.TYPE_TWO='04'
 GROUP BY Y.AREA_DESC,Y.IDX_NO
 ORDER BY Y.IDX_NO;
 
--三级页面  展示“移动网上”+ "石家庄"
SELECT Y.City_Desc ,
       SUM(X.CUR_VALUE),
       SUM(X.MONTH_VALUE),
       ROUND(((SUM(X.MONTH_VALUE) - SUM(X.MONTH_VALUE_LM)) /
             SUM(X.MONTH_VALUE_LM)) * 100,
             2) || '%'
  FROM (SELECT AREA_NO,CITY_NO,TYPE_ONE, TYPE_TWO, CUR_VALUE, MONTH_VALUE, 0 MONTH_VALUE_LM
          FROM CBZS_DM_KKPI_D_DEV_ADMIN A
         WHERE A.DAY_ID = '20180910'
        UNION ALL
        SELECT AREA_NO,CITY_NO,TYPE_ONE, TYPE_TWO, 0, 0, MONTH_VALUE
          FROM CBZS_DM_KKPI_D_DEV_ADMIN A
         WHERE A.DAY_ID = '20180810') X,
       DIM.Dim_City_No Y
 WHERE X.CITY_NO=Y.CITY_NO
   AND X.TYPE_ONE='01'
   AND X.TYPE_TWO='04'
   and y.area_no='188'
 GROUP BY Y.City_Desc;


--四级页面  展示“移动网上”+ "石家庄" + "自有厅" 
SELECT Y.Huaxiao_Name ,
       SUM(X.CUR_VALUE),
       SUM(X.MONTH_VALUE),
       ROUND(((SUM(X.MONTH_VALUE) - SUM(X.MONTH_VALUE_LM)) /
             SUM(X.MONTH_VALUE_LM)) * 100,
             2) || '%'
  FROM (SELECT AREA_NO,CITY_NO,HUAXIAO_NO,TYPE_ONE, TYPE_TWO, CUR_VALUE, MONTH_VALUE, 0 MONTH_VALUE_LM
          FROM cbzs_dm_kkpi_d_dev A
         WHERE A.DAY_ID = '20180910'
        UNION ALL
        SELECT AREA_NO,CITY_NO,HUAXIAO_NO,TYPE_ONE, TYPE_TWO, 0, 0, MONTH_VALUE
          FROM cbzs_dm_kkpi_d_dev A
         WHERE A.DAY_ID = '20180810') X,
       DIM.Dim_Huaxiao_Info Y
 WHERE x.huaxiao_no=y.huaxiao_no
   AND X.TYPE_ONE='01'
   AND X.TYPE_TWO='04'
   and y.area_no='188'
   and y.huaxiao_type='01'
 GROUP BY Y.Huaxiao_Name;
 
 
 
