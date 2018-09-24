select count(*),station_no from   ALLDM.DM_BS_STATION_REPORT a where a.acct_month='201807' 
group by station_no
having count(*)>1


select *
  from ALLDM.DM_BS_STATION_REPORT a
 where a.acct_month = '201807'
   and station_no = '312AX.DC-YD'


--表1单站效益计算表 导出
SELECT ACCT_MONTH   账期,
       AREA_NO      地市编,
       AREA_NAME    地市名,
       CITY_NAME    区县名,
       STATION_NO   站址编,
       STATION_NAME 站址名,
       TIETA_NO     铁塔编,
       TIETA_TYPE   铁塔类,
       FLUX_TOTAL   总流量,
       FLUX_PRICE   流量单,
       FLUX_INCOME  流量收,
       FUWU_FEE     服务费,
       POWER_FEE    电费,
       ZHEJIU_FEE   折旧费,
       TOTAL_FEE    总费用,
       MAOLI        毛利,
       MAOLI_RATE   毛利率,
       AREA_RANK    排名
  FROM (SELECT A.*,
               ROW_NUMBER() OVER(PARTITION BY A.STATION_NO ORDER BY 1) RN
          FROM ALLDM.DM_BS_STATION_REPORT A
         WHERE A.ACCT_MONTH = '201807') A
 WHERE RN = 1

--表2连续3个月低效基站清单 \
SELECT ACCT_MONTH     账期,
       AREA_NO        地市编码,
       AREA_NAME      地市名称,
       CITY_NAME      区县名称,
       STATION_NO     站址ID,
       STATION_NAME   站址名称,
       TIETA_NO       铁塔编码,
       TIETA_TYPE     铁塔类型,
       TOTAL_INCOME_1 本月收入,
       TOTAL_FEE_1    本月成本,
       MAOLI_1        本月毛利,
       MAOLI_RATE_1   本月毛利率,
       TOTAL_INCOME_2 上月收入,
       TOTAL_FEE_2    上月成本,
       MAOLI_2        上月毛利,
       MAOLI_RATE_2   上月毛利率,
       TOTAL_INCOME_3 上上月收入,
       TOTAL_FEE_3    上上月成本,
       MAOLI_3        上上月毛利率,
       MAOLI_RATE_3   上上月毛利率
  FROM (SELECT A.*,
               ROW_NUMBER() OVER(PARTITION BY A.STATION_NO ORDER BY 1) RN
          FROM ALLDM.DM_BS_STATION_LOW_REPORT A
         WHERE A.ACCT_MONTH = '201807') A
 WHERE RN = 1

--表3低效基站数量统计
SELECT ACCT_MONTH           账期,
       AREA_NO              地市编码,
       AREA_NAME            地市名称,
       STATION_NUM          站址总量,
       STATION_LOW_NUM      当月低效站址数量,
       STATION_RATE         当月低效站址占比,
       STATION_LOW_LAST_NUM 上月低效站址数量,
       STATION_RATE_ADD     环比增加,
       STATION_RATE_REDUCE  环比减少
  FROM ALLDM.DM_BS_STATION_LOW_NUM where ACCT_MONTH = '201807'

--表4超闲小区（小CEO营销支撑）
SELECT ACCT_MONTH   账期,
       AREA_NO      地市编码,
       AREA_NAME    地市名称,
       CITY_NAME    区县名称,
       STATION_NO   站址编码,
       STATION_NAME 站址名称,
       XIAOQU_NO    小区编码,
       XIAOQU_NAME  小区名称,
       round(UP_FLUX/1024,1)       上行流量,
       round(DOWN_FLUX/1024,1)   下行流量,
       round(UP_FLUX/1024+DOWN_FLUX/1024,1)   总流量
  FROM ALLDM.DM_BS_STATION_FREE_LIST
 WHERE ACCT_MONTH = '201807'


--拆闲清单
SELECT distinct  ACCT_MONTH    账期,
       AREA_NO       地市编码,
       AREA_NAME     地市名称,
       CITY_NAME     区县名称,
       ENB_NO        所属ENBID,
       ENB_NAME      所属ENBID名称,
       XIAOQU_NO     小区编码,
       XIAOQU_NAME   小区名称,
       ECI           ECI,
       RRU_NO        RRU标识,
       RRU_ELECT_NO  RRU的电子序列号,
       FLUX          网管流量,
       USER_NUM      用户数,
       ASSET_NO      资产卡片编号,
       ASSET_PRICE   资产原值,
       ASSESS_RESULT 诊断结果,
       INNET_DATE    入网时间
  FROM ALLDM.DM_BS_STATION_RRU_FREE   WHERE ACCT_MONTH = '201807'
  and ASSESS_RESULT='月流量未达到25G'


--RRU补忙结果反馈清单
SELECT ACCT_MONTH      账期,
       AREA_NO         地市编码,
       AREA_NAME       地市名称,
       CITY_NAME       区县名称,
       ASSET_NO        资产卡片编号,
       ASSET_PRICE     资产原值,
       RRU_ELECT_NO    RRU的电子序列号,
       XIAOQU_NO       小区编码_拆闲清单,
       XIAOQU_NAME     小区名称_拆闲清单,
       XIAOQU_NO_NEW   小区编码_补忙后,
       XIAOQU_NAME_NEW 小区名称_补忙后,
       INNET_DATE      入网时间_补忙后,
       RRU_NUM         扇区个数_补忙前一个月,
       RRU_NUM_NEW     扇区个数_补忙当月,
       RRU_RESULT      逻辑判断
  FROM ALLDM.DM_BS_STATION_RRU_BUSY
 WHERE ACCT_MONTH = '201807'


--RRU补忙结果汇总
SELECT ACCT_MONTH    账期,
       AREA_NO       地市编码,
       AREA_NAME     地市名称,
       RRU_NUM       RRU总量,
       RRU_NUM_VALID 补忙有效RRU数量,
       RRU_BUSY_RATE 补忙数量占比
  FROM ALLDM.DM_BS_STATION_RRU_RATE  WHERE ACCT_MONTH = '201807';
  
  



































