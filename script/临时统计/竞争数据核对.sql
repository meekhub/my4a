select * from 
(SELECT T.*,
       NVL(C.CITY_NO_NEW, FUNC_CITY_NO_RATE(T.AREA_NO, TELE_MAP)) CITY_NO
  FROM MID_CPT_USER_D_1 T,
       
       (SELECT DISTINCT CITY_NO, CITY_NO_NEW FROM MID_DM_BUSI_ANAL_CITY_INFO) C --20150430 �����г���ά��������������й���

 WHERE T.CITY_NO_NEW = C.CITY_NO(+))
 where city_no in ('018184024', '018182015')



SELECT B.AREA_NO, B.CITY_NO, B.CITY_NO_NEW
  FROM JS_REPORT.BWT_RANDOM_REGION_D B where city_no in ('018184024', '018182015')
  
018184024��  8130734   ������
018182015��  8130398   ����������
018180041��  8130903   ���ݸ�����

select * from bwt_random_region_d t where t.city_no in ('018184024','018182015','018180041')
select * from ODS.O_PTY_COMP_CITY_RATE where city_no in ('018184024','018182015','018180041');

create table tmp_O_PTY_COMP_CITY_RATE as
select * from ODS.O_PTY_COMP_CITY_RATE




--���ݸ������˲�
select * from MID_CPT_USER_D_1 a where a.city_no_new='018180041';

select NET_TYPE_ID,sum(reach_cnt) from MID_CPT_USER_D_1 a where a.city_no_new=''
group by NET_TYPE_ID;


p_cpt_serv_ot_cur;
p_bwt_evt_cpt_user_d;

SELECT /*+PARALLEL(T,2)*/
 count(distinct ACC_NBR) 
  FROM CPT_SERV_OT_CUR T
 WHERE T.ACCT_MONTH = '201805'
   AND T.DAY_ID = '19'
   and city_no='018180041'
   and reach_flag='1'




SELECT LATN_ID,
       REGION_ID,
       B.CITY_DESC,
       NET_TYPE_ID,
       CASE
         WHEN NET_TYPE_ID = '1010' THEN
          '�й�����-����'
         WHEN NET_TYPE_ID = '1020' THEN
          '�й�����-�ƶ���'
         WHEN NET_TYPE_ID = '1090' THEN
          '�й�����-����'
         WHEN NET_TYPE_ID = '2010' THEN
          '�й��ƶ�-����'
         WHEN NET_TYPE_ID = '2020' THEN
          '�й��ƶ�-�ƶ���'
         WHEN NET_TYPE_ID = '2090' THEN
          '�й��ƶ�-����'
         WHEN NET_TYPE_ID = '3010' THEN
          '�й���ͨ-����'
         WHEN NET_TYPE_ID = '3020' THEN
          '�й���ͨ-�ƶ���'
         WHEN NET_TYPE_ID = '3090' THEN
          '�й���ͨ-����'
       END,
       
       SUM(REACH_CNT),
       SUM(REACH_CNT_TMP)
  FROM (SELECT T.LATN_ID,
               T.REGION_ID,
               T.OPERATOR_TYPE_ID,
               T.NET_TYPE_ID,
               T.REACH_CNT,
               0 REACH_CNT_TMP
          FROM BWT_EVT_CPT_USER_D T
         WHERE DAY_ID = '20180527'
        
        UNION ALL
        
        SELECT T.LATN_ID,
               T.REGION_ID,
               T.OPERATOR_TYPE_ID,
               T.NET_TYPE_ID,
               0                  REACH_CNT,
               REACH_CNT          REACH_CNT_TMP
          FROM TMP_EVT_CPT_USER_D T
         WHERE DAY_ID = '20180527') A,
       
       DIM.DIM_CITY_NO_TRANS@hbdw B
 WHERE A.REGION_ID = B.CITY_NO_NEUSOFT(+)
 GROUP BY LATN_ID,
          REGION_ID,
          B.CITY_DESC,
          NET_TYPE_ID,
          CASE
            WHEN NET_TYPE_ID = '1010' THEN
             '�й�����-����'
            WHEN NET_TYPE_ID = '1020' THEN
             '�й�����-�ƶ���'
            WHEN NET_TYPE_ID = '1090' THEN
             '�й�����-����'
            WHEN NET_TYPE_ID = '2010' THEN
             '�й��ƶ�-����'
            WHEN NET_TYPE_ID = '2020' THEN
             '�й��ƶ�-�ƶ���'
            WHEN NET_TYPE_ID = '2090' THEN
             '�й��ƶ�-����'
            WHEN NET_TYPE_ID = '3010' THEN
             '�й���ͨ-����'
            WHEN NET_TYPE_ID = '3020' THEN
             '�й���ͨ-�ƶ���'
            WHEN NET_TYPE_ID = '3090' THEN
             '�й���ͨ-����'
          END
 ORDER BY NET_TYPE_ID, REGION_ID
