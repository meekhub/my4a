select * from cs_dss.oa_org_user_name_mulu@hbods where user_name='曹华磊' --OA同步
SELECT * FROM ALLDM.VIEW_SYS_REPORT_ALLINFO T where t.报表名称 like '%综合分析表%'  --查询新门户公共sql
select * from newdataplatform.e_user@hbods where user_name='周伟'
select * from NEW_ALLDMCODE.DMCODE_AREA@new_hbdw
select * from NEW_ALLDMCODE.DMCODE_CITY@new_hbdw;

select * from dw.dw_v_user_base_info_user a
where acct_month='201807'
and area_no='188'
and tele_type='2'
and device_number='18931172233'

--bundle_id 100306417871

P_INTEGRAL_SYS_DEVLP_JF_D;  ---日发展积分
P_INTEGRAL_SYS_DEVLP_JF_M;---月发展积分   INTEGRAL_SYS_DEVLP_JF_DETAIL_M
P_INTEGRAL_SYS_INCOME_JF_M;  --收入积分 INTEGRAL_SYS_INCOME_JF_DETAIL  增值包：dim_product_cl
P_INTEGRAL_SYS_WEIXI_JF_M  --维系积分  INTEGRAL_SYS_WEIXI_JF_DETAIL  缴赠码表：DIM_SALES_MODE_CL
P_INTEGRAL_SYS_FINE_JF_M  ---扣罚积分  INTEGRAL_SYS_FINE_JF_DETAIL
P_INTEGRAL_SYS_SUM_M;  --汇总积分  INTEGRAL_SYS_SUM_M
RPT_HBTELE.P_SJZX_WH_CHANNEL_JF_SCORE_M --月积分汇总
RPT_HBTELE.P_SJZX_WH_CHANNEL_JF_SCORE_D --日积分汇总

ALLDM_MAOLI_MODEL_M --毛利模型

dw.P_DW_V_USER_HUAXIAO_INFO_M --划小基础宽表
dw.P_DW_V_USER_HUAXIAO_INFO_D --划小基础宽表
select * from STAGE.ITF_OTHER_HUAXIAO_info@hbods;  --从软创同步过来的划小信息
select * from STAGE.ITF_OTHER_HUAXIAO_xiaoqu@hbods; --从软创同步过来的小区划小信息
--政企划小
--码表：校园与集团ID
mobdss.dmcode_school_name
DW.P_DW_V_USER_HUAXIAO_INFO_ALL;  --月报
ALLDM.P_DM_ZQ_HUAXIAO_INFO_M;
ALLDM.P_DM_ZQ_CHANNEL_HUAXIAO_M;
DW.P_DW_V_USER_HUAXIAO_INFO_ALL_D --日报
RPT_HBTELE.P_SJZX_WH_ZQ_HX_DEV_010_D --

dw.P_DW_V_USER_SCHOOL_HX_USER_M --新校园
P_CHEAT_USER_ALARM_D --欺诈模型
P_CHEAT_SMS_ALARM_D  --短信黑名单

ALLDMCODE.DMCODE_XIAOQU_STD_ADDR_NEW --沙盘五级地址
select * from XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP --营销沙盘dblink
DIM.DIM_HUAXIAO_INFO --承包单元
DIM.DIM_CHANNEL_HUAXIAO --渠道与承包单元关系
DIM.DIM_XIAOQU_HUAXIAO --小区与承包单元关系

ALLDMCODE.DMCODE_XIAOQU_INFO --小区宽带码表

P_DM_MARKETING_USER_JT --集团精准营销
P_MDM_ZERO_BOX_INFO --零箱体


P_DM_V_HUAXIAO_INFO_D ;
P_DM_V_HUAXIAO_INFO_M;
P_DM_V_CHANNEL_INFO_D;
P_DM_V_CHANNEL_INFO_M;
DM_V_USER_FAMILY_WIFI_M;

P_BWT_CNTRT_MGMT_UNIT_M --承包经营单元编码（月）  
P_BWT_CNTRT_MGMT_CHNL_REL_M --承包经营单元与渠道关系（月）  
P_BWT_CNTRT_MGMT_SUM_M --承包经营量收、成本、预算汇总指标（月）  
P_BWT_CNTRT_MGMT_MAIN_REL_M --划小承包单元与承包单元小CEO关系（月）

--承包助手新华小和积分月报
mobile_cbzs.P_CBZS_DM_KKPI_M_JIFEN_CHANNEL
mobile_cbzs.P_CBZS_DM_KKPI_M_DEV_CHANNEL
mobile_cbzs.P_CBZS_DM_KKPI_M_INCO_CHANNEL
;

mobile_cbzs.p_cbzs_dm_kkpi_d_dev
mobile_cbzs.p_cbzs_dm_kkpi_m_dev_channel
mobile_cbzs.p_cbzs_dm_kkpi_m_inco_channel;
mobile_cbzs.p_cbzs_dm_kkpi_m_jifen_channel
;

--标签表
ODS.O_EVT_DPI_MARK_SEARCH_D@hbods --关键字
O_EVT_DPI_HOST_USER_SUM_D  
O_EVT_DPI_MARK_USER_SUM_D
O_EVT_DPI_USER_PREFER_D

--承包助手
MOBILE_CBZS.P_C_DM_KKPI_M_JIFEN_ADMIN_BK --积分月报


SELECT * FROM ALLDM.ALLDM_EXECUTE_LOG A WHERE PROCNAME='P_DM_V_HUAXIAO_INFO_M'


SELECT * FROM DW.DW_EXECUTE_LOG A WHERE PROCNAME='P_DW_V_USER_HUAXIAO_INFO_ALL' for update

 --查询列名
 select column_name,column_comment,DATA_TYPE,CHARACTER_MAXIMUM_LENGTH from information_schema.columns a
 where table_name='DW_B_USER_BASE_INFO_M';
 
 --添加注释
 select column_name||',','/*'||column_comment||'*/' from information_schema.columns a
 where table_name='dma_b_market_user_201411';
 
 
select upper(column_name),column_type,column_comment from information_schema.columns a
 where table_name='DWA_B_USER_BASE_INFO_M';


select table_name,tale_name_desc from infgx.stage_execute_log where acct_month='201611'

select * from infgx.stage_tab_load_log where acct_month='201612';

select * from odsstat.odsstat_execute_log  where acct_month='201701' 

show processlist;

select *  from odsstat.dw_b_user_base_info_d where day_id='20151201' 
and device_number='18630198881'


select * from odsstat.dim_attribute_value;


--同步M2M接口
select * from infgx.v_m2m_dwd_o_cust_group_day where day_id='20160214';

select * from infgx.m2m_cust_information where day_id='20160214';

select * from infgx.m2m_b_cdr_gs_day  where day_id='20160214';



--模型表
SELECT *
  FROM INFGX.STAGE_EXECUTE_LOG
 WHERE ACCT_MONTH = '201507'
   AND TABLE_NAME IN
       ('DWA_M_WDD_USER_MON', 'DWA_M_TH_YANGKA_MON', 'DWA_M_4G_YANGKA_MON',
        'DWA_M_ADAPTER_RESULT', 'DWA_M_PURCHASE_JKFL_MON',
        'DWA_M_MODEL_3G_DOUBLE_CARD', 'DWA_M_MODEL_3G_TERM_ADAPTER',
        'DWA_M_MODEL_3G_RETO_NETWORK')
                 
        
入库：
1、单张入库
call infgx.P_STAGE_TAB_LOAD_SINGLE('20150626','DAY','dwd_r_gsm_terminal_day');
call odsstat.p_dw_tab_load_single('20150710','dwd_r_gsm_terminal_day',@a,@b);


2、整体入库
call infgx.P_STAGE_TAB_LOAD('20150302',@a,@b);
call odsstat.p_dw_tab_load_d('20150708',@a,@b);

3、后台执行shell
 nohup sh gbase_pro_call.sh odsstat p_test_majh 20150409

4、从gbase导入oracle
sh gbase_to_oracle.sh 20150401 st_b_serv_trmnl


--任务实例表
--1 正在运行  2 运行完  4运行报错
select a.*,rowid from domp.etl_task_inst a where a.etl_task_id=259012;

--任务工单表
select a.*,rowid from domp.etl_task_order a where a.order_id=244836

--月接口上月提供本月未提供
select *
  from (select a.*, b.table_name as table_name_b
          from (select *
                  from infgx.stage_execute_log
                 where acct_month = '201702') a
          left join (select *
                      from infgx.stage_execute_log
                     where acct_month = '201703') b on a.table_name =
                                                       b.table_name) a
 where table_name_b is null; 


select * from odsstat.odsstat_execute_log  where acct_month='201505' and pkg_name='MON';

select * from infgx.stage_tab_load_log where acct_month='201505';

call P_DW_TAB_LOAD_M('201505',@a,@b);
select @b

call P_STAGE_TAB_LOAD('201505',@a,@b);
select @b;

select * from infgx.stage_tab_load_log where acct_month='201505'
select * from infgx.stage_execute_log where acct_month='201505';

insert into odsstat.odsstat_execute_log
  select '20160531' acct_month,
         procuser,
         pkg_name,
         procname,
         'DW_M_RES_USER_IMEI_DAY' tabname,
         startdate,
         enddate,
         result,
         duration,
         note,
         login_time,
         rowcount
    from odsstat.odsstat_execute_log
   where lower(tabname) = 'dw_r_gsm_terminal_day'
     and acct_month = '20150531'
     
--oracle查看表空间使用率
SELECT A.TABLESPACE_NAME, TOTAL, FREE, TOTAL - FREE USED,round((TOTAL - FREE)/TOTAL,4)*100||'%' PERCENT
  FROM (SELECT TABLESPACE_NAME, SUM(BYTES) / 1024 / 1024 / 1024 TOTAL
          FROM DBA_DATA_FILES A 
         GROUP BY TABLESPACE_NAME) A,
       (SELECT TABLESPACE_NAME, SUM(BYTES) / 1024 / 1024 / 1024 FREE
          FROM DBA_FREE_SPACE 
         GROUP BY TABLESPACE_NAME) B
 WHERE A.TABLESPACE_NAME = B.TABLESPACE_NAME;

odsstat.dw_b_user_base_info_m
odsstat.p_dw_b_user_base_info_m

--oracle查看表空间使用率（考虑到块大小）     
SELECT F.TABLESPACE_NAME,
       TO_CHAR((T.TOTAL_SPACE - F.FREE_SPACE), '999,999') "USED (MB)",
       TO_CHAR(F.FREE_SPACE, '999,999') "FREE (MB)",
       TO_CHAR(T.TOTAL_SPACE, '999,999') "TOTAL (MB)",
       TO_CHAR((ROUND((F.FREE_SPACE / T.TOTAL_SPACE) * 100)), '999') || ' %' PER_FREE
  FROM (SELECT TABLESPACE_NAME,
               ROUND(SUM(BLOCKS * (SELECT VALUE / 1024
                                     FROM V$PARAMETER
                                    WHERE NAME = 'db_block_size') / 1024)) FREE_SPACE
          FROM DBA_FREE_SPACE
         GROUP BY TABLESPACE_NAME) F,
       (SELECT TABLESPACE_NAME, ROUND(SUM(BYTES / 1048576)) TOTAL_SPACE
          FROM DBA_DATA_FILES
         GROUP BY TABLESPACE_NAME) T
 WHERE F.TABLESPACE_NAME = T.TABLESPACE_NAME
   AND (ROUND((F.FREE_SPACE / T.TOTAL_SPACE) * 100)) < 80;

   
 
 ---查看一个表占多大空间
SELECT SEGMENT_NAME AS TABLENAME, SUM(BYTES / 1024 / 1024) MB
  FROM USER_SEGMENTS
 WHERE SEGMENT_NAME = 'DW_V_USER_TER_DEVICE_FIRST'
 GROUP BY SEGMENT_NAME


--查看表空间中表占用空间
SELECT A.TABLE_NAME, SUM(A.BYTES / 1024 / 1024) MB
  FROM (SELECT SEGMENT_NAME AS TABLE_NAME, A.BYTES
          FROM DBA_SEGMENTS A
         WHERE A.OWNER = 'NEWEBA') A,
       (SELECT *
          FROM DBA_TABLES A
         WHERE A.OWNER = 'NEWEBA'
           AND A.TABLESPACE_NAME = 'DM_TBS_001') B
 WHERE A.TABLE_NAME = B.TABLE_NAME
 GROUP BY A.TABLE_NAME;
 
 --流量整合表核查
SELECT ACCT_MONTH,
       SUM(PROD_OFFER_GPRS),
       SUM(PROD_OFFER_USE_GPRS),
       SUM(OUT_PROD_OFFER_USE_GPRS),
       SUM(CHARGE_PACKAGE_GPRS),
       SUM(CHARGE_PACKAGE_USE_GPRS),
       SUM(FREE_PACKAGE_GPRS),
       SUM(FREE_PACKAGE_USE_GPRS)
  FROM ODSSTAT.DMW_B_OFFER_FLUX_MON
 WHERE ACCT_MONTH IN ('201505', '201506')
 GROUP BY ACCT_MONTH

--oracle找回delete数据
SELECT *
  FROM DM_JT_KEY_TARGET_D AS OF TIMESTAMP  (systimestamp - interval '20' minute) 
 WHERE DAY_ID = '20140331'
 
SELECT *
  FROM ALLDMCODE.DMCODE_XIAOQU_STD_ADDR_NEW  AS OF TIMESTAMP TO_TIMESTAMP('20171226 08:10:51','YYYYMMDD HH24:MI:SS');
   
 
 --oracle循环执行
 DECLARE
  V_MONTH VARCHAR2(100);
  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018' ORDER BY IDX_NO;
BEGIN
  FOR V_NUM IN 201207 .. 201207 LOOP
    V_MONTH := TO_CHAR(V_NUM);
    FOR C1 IN V_AREA LOOP
。。。。
      COMMIT;
    END LOOP;
  END LOOP;
END;


--循环执行过程
DECLARE
  V_MONTH   VARCHAR2(100);
  V_RETCODE VARCHAR2(100);
  V_RETINFO VARCHAR2(100);
BEGIN
  FOR V_NUM IN 201607 .. 201612 LOOP
    V_MONTH := TO_CHAR(V_NUM);
    P_INTEGRAL_SYS_WEIXI_JF_M(V_MONTH, V_RETCODE, V_RETINFO);
  END LOOP;
END;


--查到的都是被锁的表
SELECT /*+ RULE*/
 A.SID, B.OWNER, OBJECT_NAME, OBJECT_TYPE
  FROM V$LOCK A, ALL_OBJECTS B
 WHERE TYPE = 'TM'
   AND A.ID1 = B.OBJECT_ID;

   
--然后找出SESSION和ID，杀掉SESSION
SELECT distinct SID, SERIAL# FROM V$SESSION WHERE SID = 153;

ALTER SYSTEM KILL SESSION 'SID,SERIAL#';

ALTER SYSTEM KILL SESSION '153,11703';


--oracle创建临时表
DECLARE
  V_SQL VARCHAR(2000);
BEGIN
  V_SQL := 'CREATE GLOBAL TEMPORARY TABLE STUDENT
(
STU_ID NUMBER(5),
CLASS_ID NUMBER(5),
STU_NAME VARCHAR2(8),
STU_MEMO VARCHAR2(200))
 ON COMMIT PRESERVE ROWS';
  EXECUTE IMMEDIATE V_SQL;
END;

--oracle触发器
CREATE OR REPLACE TRIGGER BEFORE_INSERT_FAULT_TEMP_TABLE
  BEFORE INSERT ON FAULT_TEMP_TABLE
  FOR EACH ROW
BEGIN
  SELECT FAULT_EXTEND_TEMP_TABLE_SEQ.NEXTVAL INTO :NEW.IDENTITY_ID FROM SYS.DUAL;
END;   


SELECT UPPER(F.TABLESPACE_NAME) "表空间名",
       D.TOT_GROOTTE_MB "表空间大小(M)",
       D.TOT_GROOTTE_MB - F.TOTAL_BYTES "已使用空间(M)",
       TO_CHAR(ROUND((D.TOT_GROOTTE_MB - F.TOTAL_BYTES) / D.TOT_GROOTTE_MB * 100,
                     2),
               '990.99') "使用比",
       F.TOTAL_BYTES "空闲空间(M)",
       F.MAX_BYTES "最大块(M)"
  FROM (SELECT TABLESPACE_NAME,
               ROUND(SUM(BYTES) / (1024 * 1024), 2) TOTAL_BYTES,
               ROUND(MAX(BYTES) / (1024 * 1024), 2) MAX_BYTES
          FROM SYS.DBA_FREE_SPACE
         GROUP BY TABLESPACE_NAME) F,
       (SELECT DD.TABLESPACE_NAME,
               ROUND(SUM(DD.BYTES) / (1024 * 1024), 2) TOT_GROOTTE_MB
          FROM SYS.DBA_DATA_FILES DD
         GROUP BY DD.TABLESPACE_NAME) D
WHERE D.TABLESPACE_NAME = F.TABLESPACE_NAME
ORDER BY 4 DESC  

--查询正在执行的sql
SELECT b.sid oracleID,  
       b.username 登录Oracle用户名,  
       b.serial#,  
       spid 操作系统ID,  
       paddr,  
       sql_text 正在执行的SQL,  
       b.machine 计算机名  
FROM v$process a, v$session b, v$sqlarea c  
WHERE a.addr = b.paddr  
   AND b.sql_hash_value = c.hash_value

--写入日志
insert into odsstat_execute_log
select 
'201512' ACCT_MONTH,
PROCUSER,
PKG_NAME,
PROCNAME,
'DW_M_CBSS_ACCOUNTDEPOSIT_MON' TABNAME,
STARTDATE,
ENDDATE,
RESULT,
DURATION,
NOTE,
LOGIN_TIME,
ROWCOUNT
 from odsstat.odsstat_execute_log  where acct_month='201512' and pkg_name='MON' limit 1

--查看oracle某个进程下运行的sql
select a.spid, a.serial#, b.sid, b.process, b.program, c.sql_text
  from v$process a, v$session b, v$sqlarea c
 where a.addr = b.paddr
   and b.sql_address = c.address
   and b.sql_hash_value = c.hash_value
   and a.spid = ''


DECLARE
  JOB NUMBER;
BEGIN
  SYS.DBMS_JOB.SUBMIT(JOB,
                      'DECLARE
    V_DATE    VARCHAR2(100);
    V_RETCODE VARCHAR2(100);
    V_RETINFO VARCHAR2(100);

BEGIN
  V_DATE:=TO_CHAR(ADD_MONTHS(SYSDATE,-1),''YYYYMM'');
  P_DM_BUS_CUST_MARKET_STAT(V_DATE,V_RETCODE,V_RETINFO);

END ;',
                      SYSDATE,
                      'TRUNC(ADD_MONTHS(SYSDATE,1),''MM'')+4+(15*60+30)/(24*60)');
  COMMIT;
END;

--查看文件大小
ls -lt DAP*.20140512*|awk 'BEGIN{SUM=0};{SUM+=$5}END{print SUM}'

--每月5号导入终端
drop table tmp_res_imei_0630
create table tmp_res_imei_0630 as 
select * from dwa_plf.DWa_M_RES_USER_IMEI_DAY where month_id='201702'
and day_id='28'

insert into DW_M_RES_USER_IMEI_DAY
select * from infgx.tmp_res_imei_0630

--写日志
insert into odsstat_execute_log
select 
'20170228' ACCT_MONTH,
PROCUSER,
PKG_NAME,
PROCNAME,
'DW_M_RES_USER_IMEI_DAY' TABNAME,
STARTDATE,
ENDDATE,
RESULT,
DURATION,
NOTE,
LOGIN_TIME,
ROWCOUNT
 from odsstat.odsstat_execute_log  where acct_month='201512' and pkg_name='MON' limit 1
 
--查询Oracle正在执行的sql语句及执行该语句的用户
SELECT B.SID ORACLEID,
       B.USERNAME 登录ORACLE用户名,
       B.SERIAL#,
       SPID 操作系统ID,
       PADDR,
       SQL_TEXT 正在执行的SQL,
       B.MACHINE 计算机名
  FROM V$PROCESS A, V$SESSION B, V$SQLAREA C
 WHERE A.ADDR = B.PADDR
   AND B.SQL_HASH_VALUE = C.HASH_VALUE
 --查看正在执行sql的发起者的发放程序
 SELECT OSUSER 电脑登录身份,
       PROGRAM 发起请求的程序,
       USERNAME 登录系统的用户名,
       SCHEMANAME,
       B.Cpu_Time 花费cpu的时间,
       STATUS,
       B.SQL_TEXT 执行的sql
  FROM V$SESSION A
  LEFT JOIN V$SQL B ON A.SQL_ADDRESS = B.ADDRESS
                   AND A.SQL_HASH_VALUE = B.HASH_VALUE
 ORDER BY b.cpu_time DESC
