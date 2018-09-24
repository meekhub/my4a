--毛利模型

create table maoli_data_model
(
acct_month char(6), 
area_no varchar2(200), 
city_no varchar2(200), 
maoli_fee number
)


create table newdataplatform.maoli_data_model as 
SELECT '201706' acct_month,
       AREA_NO,
       CITY_NO,
       ROUND(ABS((JFSR - COMMISION_FEE - XMFC)) / 10000, 2) MAOLI_FEE
  FROM (SELECT B.AREA_NO,
               B.CITY_NO,
               SUM(A.C_JFSR + A.KD_JFSR + A.TV_JFSR) AS JFSR,
               SUM(A.C_COMMISION_FEE + A.KD_COMMISION_FEE +
                   A.TV_COMMISION_FEE) COMMISION_FEE,
               SUM(A.C_XMFC + A.KD_XMFC + A.TV_XMFC) XMFC
          FROM ALLDM.MAOLI_MODEL_M A, DIM.DIM_CHANNEL_NO B
         WHERE A.ACCT_MONTH >= '201703'
           AND A.CHANNEL_NO = B.CHANNEL_NO
         GROUP BY B.AREA_NO, B.CITY_NO)
 WHERE JFSR - COMMISION_FEE - XMFC < 0;
 
--欺诈模型
select * from newdataplatform.GC_QIZHA_1
 
 
