--收入任务
select a.acct_month,c.area_desc,
       d.city_desc,
       b.huaxiao_no,
       b.huaxiao_name,
       b.HUAXIAO_TYPE_NAME,
       ceil(a.month_value),
       ceil(a.task_value)
  from (select acct_month,a.huaxiao_no,
               sum(a.month_value) month_value,
               sum(a.task_value) task_value
          from mobile_cbzs.cbzs_dm_kkpi_m_finish   a,
               mobile_cbzs.cbzs_dmcode_finish_type b
         where a.acct_month = '201803'
           and a.type_one = b.type_one
           and a.type_two = b.type_two
           and a.type_one = '04'
           and a.type_two = '01'
         group by acct_month,a.huaxiao_no) a,
       dim.dim_huaxiao_info b,
       dim.dim_area_no c,
       dim.dim_city_no d
 where a.huaxiao_no = b.huaxiao_no
   and a.huaxiao_no = b.huaxiao_no
   and b.area_no = c.area_no
   and b.city_no = d.city_no


--积分 
select acct_month,c.area_desc,
       d.city_desc,
       b.huaxiao_no,
       b.huaxiao_name,
       b.HUAXIAO_TYPE_NAME,
       ceil(a.month_value),
       ceil(a.task_value)
  from (select acct_month,a.huaxiao_no,
               a.huaxiao_type,
               sum(a.month_value) month_value,
               sum(a.task_value) task_value
          from mobile_cbzs.cbzs_dm_kkpi_m_finish   a,
               mobile_cbzs.cbzs_dmcode_finish_type b
         where a.acct_month = '201803'
           and a.type_one = b.type_one
           and a.type_two = b.type_two
           and a.type_one = '05'
           and a.type_two in ('01','02','03')
         group by acct_month,a.huaxiao_no,a.huaxiao_type) a,
       dim.dim_huaxiao_info b,
       dim.dim_area_no c,
       dim.dim_city_no d
 where a.huaxiao_no = b.huaxiao_no
   and a.huaxiao_no = b.huaxiao_no
   and b.area_no = c.area_no
   and b.city_no = d.city_no
   and a.huaxiao_type='01'


select *
  from mobile_cbzs.cbzs_dm_kkpi_m_finish
 where acct_month = '201803'
   and type_one = '04'
   and type_two = '01'

mobile_cbzs.P_cbzs_dm_kkpi_m_finish


select * from  mobile_cbzs.cbzs_dmcode_finish_type;


--年完成情况
--任务完成
SELECT A.*,
       B.TASK_VALUE,
       NVL(DECODE(TASK_VALUE, 0, 0, TOTAL_FEE / TASK_VALUE), 0)
  FROM (SELECT A.AREA_DESC,
               B.CITY_DESC,
               C.HUAXIAO_TYPE_NAME,
               C.HUAXIAO_NO,
               C.HUAXIAO_NAME,
               SUM(TOTAL_FEE) TOTAL_FEE
          FROM (SELECT AREA_NO,
                       CITY_NO,
                       HUAXIAO_NO,
                       SUM(TOTAL_FEE) TOTAL_FEE,
                       SUM(SUM_SORE) SUM_SORE
                  FROM DM_V_HUAXIAO_INFO_M A
                 WHERE A.ACCT_MONTH BETWEEN '201801' AND '201812'
                 GROUP BY AREA_NO, CITY_NO, HUAXIAO_NO
                UNION ALL
                SELECT AREA_NO,
                       CITY_NO,
                       HUAXIAO_NO,
                       SUM(TOTAL_FEE) TOTAL_FEE,
                       0
                  FROM DM_ZQ_HUAXIAO_INFO_M A
                 WHERE A.ACCT_MONTH BETWEEN '201801' AND '201812'
                 GROUP BY AREA_NO, CITY_NO, HUAXIAO_NO) T,
               DIM.DIM_AREA_NO A,
               DIM.DIM_CITY_NO B,
               DIM.DIM_HUAXIAO_INFO C
         WHERE T.AREA_NO = A.AREA_NO
           AND T.CITY_NO = B.CITY_NO
           AND T.HUAXIAO_NO = C.HUAXIAO_NO
         GROUP BY A.AREA_DESC,
                  B.CITY_DESC,
                  C.HUAXIAO_TYPE_NAME,
                  C.HUAXIAO_NO,
                  C.HUAXIAO_NAME) A,
       (SELECT *
          FROM (SELECT A.HUAXIAO_NO,
                       A.TASK_VALUE，ROW_NUMBER() OVER(PARTITION BY A.HUAXIAO_NO ORDER BY A.INSERT_DATE DESC) RN
                  FROM DIM.DIM_HUAXIAO_TASK_INFO A
                 WHERE A.TASK_NO IN ('T1011', 'T2010', 'T3011', 'T4014'))
         WHERE RN = 1) B
 WHERE A.HUAXIAO_NO = B.HUAXIAO_NO(+)
       

--实体渠道1到3月累计收入  分年
insert into xxhb_mjh.tmp_majh_incr_st
select '2018' acct_year,
       d.area_desc,
       e.city_desc,
       a.huaxiao_no,
       c.huaxiao_name,
       c.huaxiao_type_name,
       sum(total_fee) total_fee,
       sum(case when c.huaxiao_type='01' then SUM_SORE else 0 end)SUM_SORE
  from (select huaxiao_no, sum(total_fee) total_fee,sum(SUM_SORE)SUM_SORE
          from DM_V_HUAXIAO_INFO_M a
         where a.acct_month between '201801' and '201812'
         group by huaxiao_no
         union all
         select huaxiao_no, sum(total_fee) total_fee,0 
          from DM_zq_HUAXIAO_INFO_M a
         where a.acct_month between '201801' and '201812'
         group by huaxiao_no
         ) a,
       dim.dim_huaxiao_info c,
       dim.dim_area_no d,
       dim.dim_city_no e
 where a.huaxiao_no = c.huaxiao_no
   and c.area_no = d.area_no
   and c.city_no = e.city_no
   group by d.area_desc,
       e.city_desc,
       a.huaxiao_no,
       c.huaxiao_name,
       c.huaxiao_type_name;


--实体渠道1到3月累计收入  分月
insert into xxhb_mjh.tmp_majh_incr_st_m
select acct_month,
       d.area_desc,
       e.city_desc,
       a.huaxiao_no,
       c.huaxiao_name,
       c.huaxiao_type_name,
       sum(total_fee) total_fee,
       sum(case when c.huaxiao_type='01' then SUM_SORE else 0 end)SUM_SORE
  from (select acct_month,huaxiao_no, sum(total_fee) total_fee,sum(SUM_SORE)SUM_SORE
          from DM_V_HUAXIAO_INFO_M a
         where a.acct_month between '201801' and '201812'
         group by acct_month,huaxiao_no
         union all
         select acct_month,huaxiao_no, sum(total_fee) total_fee,0 
          from DM_zq_HUAXIAO_INFO_M a
         where a.acct_month between '201801' and '201812'
         group by acct_month,huaxiao_no
         ) a,
       dim.dim_huaxiao_info c,
       dim.dim_area_no d,
       dim.dim_city_no e
 where a.huaxiao_no = c.huaxiao_no
   and c.area_no = d.area_no
   and c.city_no = e.city_no
   group by acct_month,d.area_desc,
       e.city_desc,
       a.huaxiao_no,
       c.huaxiao_name,
       c.huaxiao_type_name;       
       
SELECT A.AREA_DESC,
       A.CITY_DESC,
       A.HUAXIAO_NO,
       A.HUAXIAO_NAME,
       A.HUAXIAO_TYPE_NAME,
       SUM(A.TOTAL_FEE),
       SUM(A.SUM_SORE),
       SUM(B.TOTAL_FEE_TASK_VALUE),
       SUM(CASE
             WHEN A.HUAXIAO_TYPE_NAME = '自有厅' THEN
              B.JF_TASK_VALUE
             ELSE
              0
           END) JF_TASK_VALUE
  FROM XXHB_MJH.TMP_MAJH_INCR_ST A,
       (SELECT HUAXIAO_NO,
               SUM(CASE
                     WHEN TASK_NO IN ('T2004', 'T3006', 'T4007') THEN
                      TASK_VALUE
                     ELSE
                      0
                   END) TOTAL_FEE_TASK_VALUE,
               SUM(CASE
                     WHEN TASK_NO IN ('T1008', 'T1009', 'T1010') THEN
                      TASK_VALUE
                     ELSE
                      0
                   END) JF_TASK_VALUE
          FROM DIM.DIM_HUAXIAO_TASK_INFO
         WHERE TASK_DATE BETWEEN '201801' AND '201803'
           AND TASK_NO IN
               ('T2004', 'T3006', 'T4007', 'T1008', 'T1009', 'T1010')
         GROUP BY HUAXIAO_NO) B
 WHERE A.HUAXIAO_NO = B.HUAXIAO_NO(+)
 GROUP BY A.AREA_DESC,
          A.CITY_DESC,
          A.HUAXIAO_NO,
          A.HUAXIAO_NAME,
          A.HUAXIAO_TYPE_NAME













