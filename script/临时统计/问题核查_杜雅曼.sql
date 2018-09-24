select * from dim.dim_huaxiao_info a where huaxiao_name='安平支局'

select sum(total_fee) from DM_V_HUAXIAO_INFO_M a where acct_month='201803' and huaxiao_no='813100240010000'

select sum(total_fee) from DM_V_CHANNEL_INFO_M a where acct_month='201803' and huaxiao_no='813100240010000'

select sum(TOTAL_FEE+TOTAL_FEE_OCS-IOT_FEE) from dw.DW_V_USER_HUAXIAO_INFO_M a where acct_month='201803'
and HUAXIAO_NO_04='813100240010000'


-- 745101.06
select xiaoqu_No,SUM(price_fee+price_fee_ocs)
  FROM DW.DW_V_USER_HUAXIAO_INFO_M A
 WHERE A.ACCT_MONTH = '201803'
   AND AREA_NO = '183' 
   AND A.IS_HUAXIAO_04 = '1' 
   and HUAXIAO_NO_04='813100240010000'
   group by xiaoqu_No


--131773.99
select sum(price_fee + price_fee_ocs)
  from (select price_fee, price_fee_ocs, user_no, channel_no,HUAXIAO_NO_04
          FROM DW.DW_V_USER_HUAXIAO_INFO_M A
         WHERE A.ACCT_MONTH = '201803'
   AND AREA_NO = '183'
   AND A.TELE_TYPE = '2'
   AND A.XIAOQU_NO IS NULL
   AND A.IS_HUAXIAO_04 = '1'
   and HUAXIAO_NO_04 = '813100240010000') a,
       (SELECT *
          FROM DIM.DIM_CHANNEL_HUAXIAO T
         WHERE T.AREA_NO = '183'
           AND T.HUAXIAO_TYPE = '04'
           and HUAXIAO_NO = '813100240010000') t
 where A.HUAXIAO_NO_04 = T.HUAXIAO_NO
   AND A.CHANNEL_NO = T.CHANNEL_NO


--613313.52
select sum(price_fee + price_fee_ocs)
  from (select price_fee,
               price_fee_ocs,
               user_no,
               channel_no,
               HUAXIAO_NO_04,
               xiaoqu_no
          FROM DW.DW_V_USER_HUAXIAO_INFO_M A
         WHERE A.ACCT_MONTH = '201803'
           AND AREA_NO = '183'
           AND ((A.XIAOQU_NO IS NOT NULL AND A.TELE_TYPE = '2') OR
               A.TELE_TYPE <> '2')
           AND A.IS_HUAXIAO_04 = '1'
           and HUAXIAO_NO_04 = '813100240010000') a,
       (SELECT *
          FROM DIM.dim_xiaoqu_huaxiao T
         WHERE T.AREA_NO = '183'
           AND T.HUAXIAO_TYPE = '04'
           and HUAXIAO_NO = '813100240010000') t
 where A.HUAXIAO_NO_04 = T.HUAXIAO_NO
   AND A.xiaoqu_no = T.xiaoqu_no
   
   
   select xiaoqu_no,sum(total_fee) from DM_V_CHANNEL_INFO_M a where acct_month='201803' 
   and HUAXIAO_NO = '813100240010000'
   group by xiaoqu_no
   
   
   
   --问题2
      select sum(total_fee) from DM_V_CHANNEL_INFO_M a where acct_month='201803' 
   and xiaoqu_no in ('183598592','183601914')
   
   select channel_no,user_no,device_number,tele_type,price_fee+price_fee_ocs
    FROM DW.DW_V_USER_HUAXIAO_INFO_M A
         WHERE A.ACCT_MONTH = '201803'
           AND AREA_NO = '183'
           and channel_no in ('183598592','183601914')
           
   --AND A.TELE_TYPE = '2'
   --AND A.XIAOQU_NO IS NULL
   --AND A.IS_HUAXIAO_04 = '1'
   
   
   
   

   
   
   select * from dim.dim_channel_huaxiao where channel_no in ('183598592','183601914')
   
   
--问题3
select t.*, t.rowid from tmp_majh_addr_0416 t;

create table tmp_majh_addr_0416_2 as
select * from tmp_majh_addr_0416 a,
(SELECT /*+PARALLEL(T,10)*/
         TO_CHAR(ID) ID,
         T.GRADE_0 || '/' || T.GRADE_1 || '/' || T.GRADE_2 || '/' ||
         T.GRADE_3 || '/' || T.GRADE_4 STDADDR_NAME
          FROM DW.DATMT_GIS_STANDARDADDRESS_QE T)b
          where a.addr_id=b.id
          
          

select * from tmp_majh_addr_0416_2 a,ALLDMCODE.DMCODE_XIAOQU_STD_ADDR_NEW b
where a.STDADDR_NAME=b.STDADDR_NAME       


select * from 
(SELECT USER_NO,
                       T.GRADE_0 || '/' || T.GRADE_1 || '/' || T.GRADE_2 || '/' ||
                       T.GRADE_3 || '/' || T.GRADE_4 STDADDR_NAME
                  FROM DW.DW_V_USER_ADSL_EIGHT_M T
                 WHERE ACCT_MONTH = '201803'
                   AND T.AREA_NO = '183'
                   AND USER_NO IS NOT NULL)a,
                   tmp_majh_addr_0416_2 b
                   where a.STDADDR_NAME=b.stdaddr_name   
