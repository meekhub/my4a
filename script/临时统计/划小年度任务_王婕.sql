--������
��������  T1011
���˻���  T1012
--��Ȧ
��������  T2010
--����
��������  T3011
--ũ��
��������  T4007


SELECT B.AREA_DESC ����,
       C.CITY_DESC ����,
       A.HUAXIAO_NO ��С��Ԫ����,
       A.HUAXIAO_NAME ��С��Ԫ����,
       CASE
         WHEN A.TASK_NO IN ('T1011', 'T1012') THEN
          '������'
         WHEN A.TASK_NO = 'T2010' THEN
          '��Ȧ'
         WHEN A.TASK_NO = 'T3011' THEN
          '����'
         WHEN A.TASK_NO = 'T4007' THEN
          'ũ��'
       END ��С����,
       A.TASK_NAME ��������,
       A.TASK_VALUE ����ֵ,
       A.INSERT_DATE ¼��ʱ��
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
       A.TASK_VALUE��row_number()over(partition by a.HUAXIAO_NO order by  a.INSERT_DATE desc)rn
  FROM DIM.DIM_HUAXIAO_TASK_INFO A 
 WHERE A.TASK_NO IN ('T1011', 'T2010', 'T3011', 'T4007') ) where rn=1
       )b
       where a.huaxiao_no=b.huaxiao_no(+)
