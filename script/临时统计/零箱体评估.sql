SELECT *
  FROM ALLDM.ALLDM_LINBOX_M@hbdxdw A
 WHERE A.STANDARD_ID IS NOT NULL
   AND STAT_TIME = '2018-08-03'

/*
select * from  nn_inf_resserviceinsdetail where attributename in ('分光器端口','分光器名称')---  1 IPTV配置详情 
select * from STAGE.nn_inf_resserviceinsdetail_kd  where attributename in ('分光器端口','分光器名称')---  2 宽带配置详情
*/

--全量分光器
CREATE TABLE XXHB_MJH.TMP_MAJH_ZERO_0810_01 AS 
SELECT SERVICE_CODE,RESNAME FROM STAGE.NN_INF_RESSERVICEINSDETAIL_KD@HBODS  WHERE ATTRIBUTENAME IN ('分光器名称');

--本月环比上月减少的零箱体
CREATE TABLE XXHB_MJH.TMP_MAJH_LM_0810_01 AS 
SELECT DISTINCT X.BOX_NAME, Y.FGQ_NAME
  FROM (SELECT A.BOX_NAME, A.CITY_DESC
          FROM (SELECT *
                  FROM ALLDM.DM_ZERO_BOX_INFO
                 WHERE ACCT_MONTH = '201806') A,
               (SELECT *
                  FROM ALLDM.DM_ZERO_BOX_INFO
                 WHERE ACCT_MONTH = '201807') B
         WHERE A.AREA_NO = B.AREA_NO(+)
           AND A.CITY_NO = B.CITY_NO(+)
           AND A.BOX_NAME = B.BOX_NAME(+)
           AND B.BOX_NAME IS NULL) X,
       (SELECT CITY_DESC, BOX_NAME, FGQ_NAME
          FROM ALLDM.ALLDM_LINBOX_M A
         WHERE A.STANDARD_ID IS NOT NULL
           AND STAT_TIME = '2018-07-05') Y
 WHERE X.BOX_NAME = Y.BOX_NAME;


--当月增加用户明细
create table XXHB_MJH.TMP_MAJH_LM_0810_02 AS 
SELECT DISTINCT A.BOX_NAME, B.RESNAME FGQ_NAME, upper(B.SERVICE_CODE) DEVICE_NUMBER
  FROM XXHB_MJH.TMP_MAJH_LM_0810_01 A, XXHB_MJH.TMP_MAJH_ZERO_0810_01 B
 WHERE A.FGQ_NAME = B.RESNAME;
 
--插入汇总表

INSERT INTO XXHB_MJH.TMP_MAJH_LM_0810_HZ
select '201806',A.* from XXHB_MJH.TMP_MAJH_LM_0810_02 A




select t.* from xxhb_mjh.TMP_MAJH_LM_0810_HZ t

update xxhb_mjh.TMP_MAJH_LM_0810_HZ set device_number=upper(device_number);


create table xxhb_mjh.tmp_majh_xt_0716_02 as
select 
distinct  account_no,box_name,fgq_name
 from (select distinct box_name,fgq_name,device_number from xxhb_mjh.TMP_MAJH_LM_0810_HZ) a ,
(
select account_no,total_fee,user_no,device_number,month_fee from dw.dw_v_user_base_info_user b
where acct_month='201807' 
and tele_type in ('4','26','72')
and is_onnet='1'
)b
where a.device_number=b.device_number(+);


--下次提的时候带上bundle_id
insert into  xxhb_mjh.tmp_majh_xt_0716_03 
select  acct_month,box_name,fgq_name,sum(b.total_fee + b.total_fee_ocs) total_fee
  from xxhb_mjh.tmp_majh_xt_0716_02 a,
       (select NVL(BUNDLE_ID_ALLOWANCE, BUNDLE_ID) AS BUNDLE_ID,
               total_fee,
               total_fee_ocs,
               user_no,
               device_number,
               acct_month,
               account_no
          from dw.dw_v_user_base_info_user b
         where acct_month = '201806'
           and is_onnet = '1') b
 where a.account_no = b.account_no
 group by acct_month,box_name,fgq_name;
 
 


 
 
 
 
 
 
 
 
 
 
 
 
