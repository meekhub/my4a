CBZS_DMCODE_HUAXIAO_USER_REL ---CEO身份
new_mobile_cbzs.m_yxin_query_config---菜单路径
new_mobile_cbzs.e_role_permission
new_mobile_cbzs.e_user_permission
new_mobile_cbzs.e_menu
new_mobile_cbzs.e_user
---绑定表，解绑就是删了
select t.login_id, a.mobile
	  from m_regedit_user t, e_user a
	 where t.login_id = a.login_id
	   and t.open_id = #open_id#


经分库新增：号码头归属地市码表 dim.dim_mobile_head ，请知悉 20180727

过程日志：
---政企月报
SELECT * FROM ALLDM.ALLDM_EXECUTE_LOG T
WHERE ACCT_MONTH ='201806'
AND PROCNAME IN ('P_CBZS_ZQ_DM_KKPI_M_DEV_C','P_CBZS_ZQ_DM_KKPI_M_INCO_C')--发展月报、收入月报
--政企日报
SELECT * FROM ALLDM.ALLDM_EXECUTE_LOG T
WHERE ACCT_MONTH ='20180709'
AND PROCNAME IN ('P_CBZS_ZQ_DM_KKPI_D_DEV_C')--发展日报


---渠道月报
SELECT * FROM ALLDM.ALLDM_EXECUTE_LOG T
WHERE ACCT_MONTH ='201806'
AND PROCNAME IN ('P_CBZS_DM_KKPI_M_JIFEN_CHANNEL',
'P_CBZS_DM_KKPI_M_INCO_CHANNEL'
,'P_CBZS_DM_KKPI_M_DEV_CHANNEL',
'P_CBZS_DM_KKPI_M_FINISH',
'P_CBZS_DM_KKPI_M_SHT',
'P_CBZS_DM_KKPI_M_YUSUAN',
'P_CBZS_DM_KKPI_M_MAOLI')

--对标
 p_cbzs_dm_kkpi_D_duibiao-日
 p_cbzs_dm_kkpi_M_duibiao--月

--------------------------------------------------------------------------------
--201711月新增，新划小数据字典
--套餐码表
DIM.DIM_USER_DINNER
--基础码表

渠道划小

select * from DIM.DIM_HUAXIAO_INFO    t;--划小信息码表（增加负责人、联系电话信息）（对应页面：划小承包>>划小维护>>划小单元检索>>划小单元基础信息)
select * from DIM.DIM_CHANNEL_HUAXIAO t;--渠道与划小对应关系码表(对应页面：划小承包>>划小维护>>划小单元检索>>划小单元渠道列表)
select * from DIM.DIM_XIAOQU_HUAXIAO  t;--小区与划小对应关系码表 (对应页面：划小承包>>划小维护>>划小单元检索>>划小单元小区列表)

select * from DIM.DIM_HUAXIAO_TYPE    t;--划小类型码表
select * from DIM.DIM_CHANNEL_INFO_HX t;--该表为视图，基于表：DIM.DIM_CHANNEL_NO   
select * from DIM.DIM_XIAOQU_INFO_HX  t;--该表为视图，基于表：ALLDMCODE.DMCODE_XIAOQU_INFO

--程序读取的表
select * from mobile_cbzs.cbzs_dmcode_huaxiao_user_rel t;--(程序读取试图)划小单元和人员分配关系表(试图，测试小CEO的时候，union all 一条test_ceo 对应的承包单元信息）
select * from mobile_cbzs.CBZS_DMCODE_HUAXIAO_TYPE t;--(程序读取试图)划小类型码表
select * from mobile_cbzs.cbzs_DMCODE_HUAXIAO t;--(程序读取试图)划小信息表




--积分月报

ALLDM.DM_V_CHANNEL_INFO_M
上层表：alldm.P_DM_V_CHANNEL_INFO_M

select * from mobile_cbzs.cbzs_dmcode_jifen_type_m t;--(新划小)积分月报码表
select * from mobile_cbzs.cbzs_dm_kkpi_m_jifen_admin t;--(新划小)积分月报(admin)
select * from mobile_cbzs.cbzs_dm_kkpi_m_jifen t ;--(新划小)积分月报(ceo)
select * from mobile_cbzs.cbzs_dm_kkpi_m_jifen_channel t;--(新划小)积分月报渠道明细表(ceo)
P_cbzs_dm_kkpi_m_jifen_channel

              
--收入月报    
select * from mobile_cbzs.cbzs_dmcode_income_type_m t;--(新划小)收入月报码表
select * from mobile_cbzs.cbzs_dm_kkpi_m_inco_admin t;--(新划小)收入月报(admin)
select * from mobile_cbzs.cbzs_dm_kkpi_m_inco t ;--(新划小)收入月报(ceo)
select * from mobile_cbzs.cbzs_dm_kkpi_m_inco_channel t;--(新划小)收入月报渠道明细表(ceo)
P_cbzs_dm_kkpi_m_inco_channel

              
--发展月报    
select * from mobile_cbzs.cbzs_dmcode_dep_type_m t;--(新划小)发展月报码表
select * from mobile_cbzs.cbzs_dm_kkpi_m_dev_admin t;--(新划小)发展月报(admin)
select * from mobile_cbzs.cbzs_dm_kkpi_m_dev t;--(新划小)发展月报(ceo)
select * from mobile_cbzs.cbzs_dm_kkpi_m_dev_channel t;--(新划小)发展月报渠道明细表(ceo)
P_CBZS_DM_KKPI_M_DEV_CHANNEL
上层表：alldm.P_DM_V_CHANNEL_INFO_M
                           
--发展日报    
select * from mobile_cbzs.cbzs_dmcode_dep_type t;--(新划小)发展日报码表
select * from mobile_cbzs.cbzs_dm_kkpi_d_dev_admin t;--(新划小)发展日报(admin)
select * from mobile_cbzs.cbzs_dm_kkpi_d_dev t ;--(新划小)发展日报(ceo)
select * from mobile_cbzs.cbzs_dm_kkpi_d_dev_channel t ;--(新划小)发展日报渠道明细表(ceo)
select * from mobile_cbzs.cbzs_dm_kkpi_d_dev_dinner t ;    ----套餐明细

P_CBZS_DM_KKPI_D_DEV_CHAL_BF  ---备份过程
P_CBZS_DM_KKPI_D_DEV_CHANNEL



--当日发展（实时）LIANGXIAOSHI
select * from cbzs_dmcode_dep_type_cur t ;--当日发展码表
select * from CBZS_DM_KKPI_D_DEV_CUR_ADMIN t;--当日发展 (admin)
select * from CBZS_DM_KKPI_D_DEV_CUR t ;--当日发展 (ceo)
select * from CBZS_DM_KKPI_D_DEV_CUR_CHANNEL t ;--当日发展渠道明细表(ceo)
select * from CBZS_DM_KKPI_D_DEV_CUR_DINNER t ;---套餐明细

P_CBZS_DM_D_DEV_CUR_CHANNEL_bf  --备份过程
CBZS_KKPI_D_DEV_CUR_BAK_bf   --历史数据备份
P_CBZS_DM_D_DEV_CUR_CHANNEL
P_CBZS_DM_D_DEV_CUR_DINNER


--积分日报
select * from mobile_cbzs.cbzs_dmcode_jifen_type_d t;--(新划小)积分日报码表
select * from mobile_cbzs.cbzs_dm_kkpi_d_jifen_admin t;--(新划小)积分日报(admin)
select * from mobile_cbzs.cbzs_dm_kkpi_d_jifen t ;--(新划小)积分日报(ceo)
select * from mobile_cbzs.cbzs_dm_kkpi_d_jifen_channel t;--(新划小)积分日报渠道明细表(ceo)
P_cbzs_dm_kkpi_d_jifen_channel


--完成情况月报
select * from mobile_cbzs.cbzs_dmcode_finish_type t;--(新划小)完成情况月报码表
select * from mobile_cbzs.cbzs_dm_kkpi_m_finish_admin t;--(新划小)完成情况月报(admin)
select * from mobile_cbzs.cbzs_dm_kkpi_m_finish t ;--(新划小)完成情况月报(ceo)
select * from mobile_cbzs.cbzs_dm_kkpi_m_finish_channel t;--(新划小)完成情况月报渠道明细表(ceo) ---作废
P_cbzs_dm_kkpi_m_finish
上层表
RPT_HBTELE.SJZX_WH_CHANNEL_JF_SCORE_010_M 


--收入日报
select * from mobile_cbzs.cbzs_dmcode_income_type_d t;--(新划小)收入日报码表
select * from mobile_cbzs.cbzs_dm_kkpi_d_inco_admin t;--(新划小)收入日报(admin)
select * from mobile_cbzs.cbzs_dm_kkpi_d_inco t ;--(新划小)收入日报(ceo)
select * from mobile_cbzs.cbzs_dm_kkpi_d_inco_channel t;--(新划小)收入日报渠道明细表(ceo)
P_cbzs_dm_kkpi_d_inco_channel


--渗透月报
select * from mobile_cbzs.cbzs_dmcode_sht_type_m t;--(新划小)渗透月报码表
select * from mobile_cbzs.cbzs_dm_kkpi_m_sht_admin t;--(新划小)渗透月报(admin)
select * from mobile_cbzs.cbzs_dm_kkpi_m_sht t;--(新划小)渗透月报(ceo)
select * from mobile_cbzs.cbzs_dm_kkpi_m_sht_channel t;--(新划小)渗透月报渠道明细表(ceo)--作废
P_cbzs_dm_kkpi_m_sht
------我的预算
P_CBZS_DM_KKPI_M_YUSUAN
-------我的毛利
P_CBZS_DM_KKPI_M_MAOLI
-----产品日报
CBZS_DM_KKPI_D_DIN_ADMIN
P_CBZS_DM_KKPI_D_DEV_CHANNEL



收入预测日报
select * from mobile_cbzs.cbzs_dmcode_ycincome_type_d t;--(新划小)收入预测日报码表
select * from mobile_cbzs.cbzs_dm_kkpi_d_ycincome_admin t;--(新划小)收入预测日报(admin)
select * from mobile_cbzs.cbzs_dm_kkpi_d_ycincome t ;--(新划小)收入预测日报(ceo)
select * from mobile_cbzs.cbzs_dm_kkpi_d_ycincome_c t;--(新划小)收入预测日报渠道明细表(ceo)
P_cbzs_dm_kkpi_d_ycincome_c





政企

商客网格 ---修改为同社区支局，可添加渠道和小区，涉及商客的码表：
     划小单元表：dim.dim_zq_huaxiao_info  huaxiao_type=05
     小区关系表：dim.dim_zq_xiaoqu_huaxiao huaxiao_type=05
     渠道关系表：dim_zq_channel_huaxiao  huaxiao_type=05
清单客户（名称修改为：营维单元）---将渠道和小区修改为“发展人”
    划小单元表：dim.dim_zq_huaxiao_info  huaxiao_type=06
    发展人关系表：dim_zq_channel_huaxiao  huaxiao_type=06
校园承包（修改为：校园支局）
    划小单元表：dim.dim_zq_huaxiao_info  huaxiao_type=07
    发展人关系表：dim_zq_group_huaxiao  huaxiao_type=07
新型业务（修改为：物联网）
    --暂不处理以后待定

    政企划小涉及的过程(收入月报、发展月报)
DW.P_DW_V_USER_HUAXIAO_INFO_ALL;   --基础宽表
ALLDM.P_DM_ZQ_HUAXIAO_INFO_M;  --划小单元上层表
ALLDM.P_DM_ZQ_CHANNEL_HUAXIAO_M;  --渠道小区上层表
   (发展日报)
DW.P_DW_V_USER_HUAXIAO_INFO_ALL_D --政企划小基础日宽表
RPT_HBTELE.P_SJZX_WH_ZQ_HX_DEV_010_D --汇总表（类似于实体 ALLDM.P_DM_HUAXIAO_INFO_D）



1、
--收入月报
mobile_cbzs.cbzs_zq_dmcode_income_type_m    
mobile_cbzs.cbzs_zq_dm_kkpi_m_inco_admin    
mobile_cbzs.cbzs_zq_dm_kkpi_m_inco          
mobile_cbzs.cbzs_zq_dm_kkpi_m_inco_channel 
P_CBZS_ZQ_DM_KKPI_M_INCO_C
P_CBZS_ZQ_DM_KKPI_M_INCO_C_BF

select * from cbzs_zq_dmcode_income_type_m t order by t.TYPE_ONE_ORD,t.TYPE_TWO_ORD

--发展月报
mobile_cbzs.cbzs_zq_dmcode_dep_type_m       
mobile_cbzs.cbzs_zq_dm_kkpi_m_dev_admin     
mobile_cbzs.cbzs_zq_dm_kkpi_m_dev           
mobile_cbzs.cbzs_zq_dm_kkpi_m_dev_channel
p_cbzs_zq_dm_kkpi_m_dev_c
P_CBZS_ZQ_DM_KKPI_M_DEV_C_BF

select * from cbzs_zq_dmcode_dep_type_m t order by t.TYPE_ONE_ORD,t.TYPE_TWO_ORD


--发展日报    
select * from mobile_cbzs.cbzs_zq_dmcode_dep_type t;--(新划小)发展日报码表
select * from mobile_cbzs.cbzs_zq_dm_kkpi_d_dev_admin t;--(新划小)发展日报(admin)
select * from mobile_cbzs.cbzs_zq_dm_kkpi_d_dev t ;--(新划小)发展日报(ceo)
select * from mobile_cbzs.cbzs_zq_dm_kkpi_d_dev_channel t ;--(新划小)发展日报渠道明细表(ceo)
select * from mobile_cbzs.cbzs_zq_dm_kkpi_d_dev_dinner t ;    ----套餐明细
p_cbzs_zq_dm_kkpi_d_dev_c



create table cbzs_dm_db_dep_type_cur  as select * from cbzs_dmcode_dep_type_cur t ;
create table CBZS_DM_db_D_DEV_CUR_ADMIN as select * from CBZS_DM_KKPI_D_DEV_CUR_ADMIN t     where 1=0;
create table CBZS_DM_db_D_DEV_CUR as select * from CBZS_DM_KKPI_D_DEV_CUR t  		    where 1=0;
create table CBZS_DM_db_D_DEV_CUR_CHANNEL as select * from CBZS_DM_KKPI_D_DEV_CUR_CHANNEL t where 1=0; 
create table CBZS_DM_db_D_DEV_CUR_DINNER  as select * from CBZS_DM_KKPI_D_DEV_CUR_DINNER t  where 1=0;

grant select on cbzs_dm_db_dep_type_cur	     to new_mobile_cbzs;
commit;
grant select on CBZS_DM_db_D_DEV_CUR_ADMIN   to new_mobile_cbzs;
commit;
grant select on CBZS_DM_db_D_DEV_CUR 	     to new_mobile_cbzs;
commit;
grant select on CBZS_DM_db_D_DEV_CUR_CHANNEL to new_mobile_cbzs;
commit;
grant select on CBZS_DM_db_D_DEV_CUR_DINNER  to new_mobile_cbzs;
commit;
------29180704 张亚维接手
---对标日报
--日指标对标数据表
    cbzs_dmcode_kpi_type_duibiao_d--对标日码表
    cbzs_dm_kkpi_d_duibiao_admin --地市，区县
    cbzs_dm_kkpi_d_duibiao--划小支局
    cbzs_dm_kkpi_d_duibiao_channel--渠道
    cbzs_dm_kkpi_d_duibiao_dinner--套餐
    过程 P_CBZS_DM_KKPI_D_DUIBIAO
    
     --月指标对标数据表
 cbzs_dmcode_kpi_type_duibiao_m--月数据指标码表
 cbzs_dm_kkpi_M_duibiao_ADMIN、 
 cbzs_dm_kkpi_M_duibiao、
 cbzs_dm_kkpi_M_duibiao_channel、
 cbzs_dm_kkpi_M_duibiao_dinner
    p_cbzs_dm_kkpi_M_duibiao
 
 
 新发展用户离网月报
  CBZS_DMCODE_OUTNET_TYPE-- 码表
  MOBILE_CBZS.CBZS_DM_KKPI_M_OUTNET_ADMIN
  MOBILE_CBZS.CBZS_DM_KKPI_M_OUTNET
  MOBILE_CBZS.CBZS_DM_KKPI_M_OUTNET_CHANNEL
P_CBZS_DM_KKPI_M_OUTNET   
    
    --发展日报（渠道）
MOBILE_CBZS.CBZS_QD_DMCODE_DEP_TYPE
MOBILE_CBZS.CBZS_QD_DM_KKPI_D_DEV_ADMIN
MOBILE_CBZS.CBZS_QD_DM_KKPI_D_DEV
MOBILE_CBZS.CBZS_QD_DM_KKPI_D_DEV_CHANNEL
MOBILE_CBZS.CBZS_QD_DM_KKPI_D_DEV_DINNER
过程 P_CBZS_QD_DM_KKPI_D_DEV 
底层 P_CBZS_QD_DM_V_USER_INFO_D--（渠道）底层用户汇总表 MOBILE_CBZS.CBZS_QD_DM_V_USER_INFO_D--20180718 zyw新建
  