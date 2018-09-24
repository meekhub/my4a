create table xxhb_mjh.tmp_majh_zx_0830 as 
SELECT 
b.area_no_desc,t.device_number,t.user_no,t.huaxiao_no,t.huaxiao_name,
b.innet_date,b.BANDWIDTH,user_dinner_desc,b.user_status_desc
  FROM DW.MID_ZQ_HUAXIAO_SK T,
       (SELECT TELE_TYPE_NEW,user_no,to_char(innet_date,'yyyymmdd')innet_date,BANDWIDTH,user_status_desc,area_no_desc,user_dinner_desc
          FROM DW.DW_V_USER_BASE_INFO_USER b
         WHERE ACCT_MONTH = '201807'
           AND TELE_TYPE_NEW = 'G020') B
 WHERE T.USER_NO = B.USER_NO



--导出
select
area_no_desc 地市, 
device_number 手机号,
user_no 用户编码,
huaxiao_no 支局编码, 
huaxiao_name 支局名称, 
innet_date 入网日期, 
bandwidth 带宽, 
user_dinner_desc 用户套餐, 
user_status_desc 截止7月状态
 from xxhb_mjh.tmp_majh_zx_0830
 
 
 
 
 
 
