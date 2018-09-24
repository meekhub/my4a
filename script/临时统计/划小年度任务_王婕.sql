--自有厅
出账收入  T1011
考核积分  T1012
--商圈
出账收入  T2010
--社区
出账收入  T3011
--农村
出账收入  T4007


SELECT B.AREA_DESC 地市,
       C.CITY_DESC 区县,
       A.HUAXIAO_NO 划小单元编码,
       A.HUAXIAO_NAME 划小单元名称,
       CASE
         WHEN A.TASK_NO IN ('T1011', 'T1012') THEN
          '自有厅'
         WHEN A.TASK_NO = 'T2010' THEN
          '商圈'
         WHEN A.TASK_NO = 'T3011' THEN
          '社区'
         WHEN A.TASK_NO = 'T4007' THEN
          '农村'
       END 划小类型,
       A.TASK_NAME 任务类型,
       A.TASK_VALUE 任务值,
       A.INSERT_DATE 录入时间
  FROM DIM.DIM_HUAXIAO_TASK_INFO A, DIM.DIM_AREA_NO B, DIM.DIM_CITY_NO C
 WHERE A.TASK_NO IN ('T1011', 'T1012', 'T2010', 'T3011', 'T4007')
   AND A.AREA_NO = B.AREA_NO
   AND A.CITY_NO = C.CITY_NO




select a.*, b.TASK_VALUE,nvl(decode(TASK_VALUE,0,0,TOTAL_FEE/TASK_VALUE),0)  from 
(sELECT A.AREA_DESC,
       B.CITY_DESC,
       C.HUAXIAO_TYPE_NAME,
       t.huaxiao_no,
       T.HUAXIAO_NAME,
       sum(TOTAL_FEE)TOTAL_FEE
  FROM DM_V_CHANNEL_INFO_M  T,
       DIM.DIM_AREA_NO      A,
       DIM.DIM_CITY_NO      B,
       DIM.DIM_HUAXIAO_INFO C
 WHERE T.ACCT_MONTH = '201805'
   AND T.AREA_NO = A.AREA_NO
   AND T.CITY_NO = B.CITY_NO
   AND T.HUAXIAO_NO = C.HUAXIAO_NO 
   group by A.AREA_DESC,
       B.CITY_DESC,
       C.HUAXIAO_TYPE_NAME,
       t.huaxiao_no,
       T.HUAXIAO_NAME)a,
       (select * from 
(select   
       A.HUAXIAO_NO,  
       A.TASK_VALUE，row_number()over(partition by a.HUAXIAO_NO order by  a.INSERT_DATE desc)rn
  FROM DIM.DIM_HUAXIAO_TASK_INFO A 
 WHERE A.TASK_NO IN ('T1011', 'T2010', 'T3011', 'T4007') ) where rn=1
       )b
       where a.huaxiao_no=b.huaxiao_no(+)
