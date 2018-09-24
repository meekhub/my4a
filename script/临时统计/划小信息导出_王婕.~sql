delete from dim.dim_huaxiao_info a
where not exists
(select 1 from dim.dim_xiaoqu_huaxiao b where a.huaxiao_no=b.huaxiao_no)
and not exists
(select 1 from dim.dim_channel_huaxiao c where a.huaxiao_no=c.huaxiao_no)

--划小
select b.area_desc,
       c.city_desc, 
       a.huaxiao_no,
       a.huaxiao_name,
       a.huaxiao_type_name
  from dim.dim_zq_huaxiao_info a, dim.dim_area_no b, dim.dim_city_no c
 where a.area_no = b.area_no
   and a.city_no = c.city_no
   and huaxiao_type in ('05')
   and a.if_valid='1';

--渠道关系
select b.area_desc,
       c.city_desc,
       a.channel_no,
       a.channel_no_desc,
       a.huaxiao_no,
       a.huaxiao_name,
       a.huaxiao_type_name
  from dim.dim_hx_sk_channel a, dim.dim_area_no b, dim.dim_city_no c
 where a.area_no = b.area_no
   and a.city_no = c.city_no 
   
   
--小区关系  
 select b.area_desc,
       c.city_desc,
       a.xiaoqu_no,
       a.xiaoqu_name,
       a.huaxiao_no,
       a.huaxiao_name,
       d.STDADDR_NAME,
       a.huaxiao_type_name
  from dim.dim_zq_xiaoqu_huaxiao a, dim.dim_area_no b, dim.dim_city_no c,
  (select * from 
(select a.xiaoqu_no, STDADDR_NAME,row_number()over(partition by a.xiaoqu_no order by 1)rn
  from alldmcode.dmcode_xiaoqu_std_addr_new a)
 where rn=1)d
 where a.area_no = b.area_no
   and a.city_no = c.city_no
   and a.xiaoqu_no=d.xiaoqu_no   


--小区与五级地址
select xiaoqu_no,XIAOQU_NAME,STDADDR_NAME from alldmcode.dmcode_xiaoqu_std_addr_new a


select *
  from (select a.xiaoqu_no,
               STDADDR_NAME,
               XIAOQU_NAME,
               row_number() over(partition by a.xiaoqu_no order by 1) rn
          from alldmcode.dmcode_xiaoqu_std_addr_new a)
 where rn = 1
 
   
--划小
select b.area_desc,
       c.city_desc, 
       a.huaxiao_no,
       a.huaxiao_name,
       a.huaxiao_type_name
  from dim.dim_huaxiao_info a, dim.dim_area_no b, dim.dim_city_no c
 where a.area_no = b.area_no
   and a.city_no = c.city_no
   and huaxiao_type in ('01','02','03','04','05','06','07','08')
   and a.if_valid='1'


--数据
SELECT A.AREA_DESC 地市,
       B.CITY_DESC 区县,
       C.HUAXIAO_TYPE_NAME 支局类型,
       T.HUAXIAO_NAME 划小名称, 
       t.xiaoqu_name 小区渠道名称,
       sum(NEW_NUM) 新发展,
       sum(CDMA_NUM) 移动,
       sum(ADSL_NUM) 宽带,
       sum(IPTV_NUM) 高清电视,
       sum(TOTAL_FEE) 全业务出账收入,
       sum(TOTAL_FEE_YEAR) 当年新发展出账收入
  FROM DM_V_CHANNEL_INFO_M  T,
       DIM.DIM_AREA_NO      A,
       DIM.DIM_CITY_NO      B,
       DIM.DIM_HUAXIAO_INFO C
 WHERE T.ACCT_MONTH = '201711'
   AND T.AREA_NO = A.AREA_NO
   AND T.CITY_NO = B.CITY_NO
   AND T.HUAXIAO_NO = C.HUAXIAO_NO
   and t.huaxiao_type='02'
   group by A.AREA_DESC,
       B.CITY_DESC,
       C.HUAXIAO_TYPE_NAME,
       T.HUAXIAO_NAME, 
       t.xiaoqu_name

--任务完成
select a.*, b.TASK_VALUE,nvl(decode(TASK_VALUE,0,0,TOTAL_FEE/TASK_VALUE),0)  from 
(sELECT A.AREA_DESC,
       B.CITY_DESC,
       C.HUAXIAO_TYPE_NAME,
       t.huaxiao_no,
       T.HUAXIAO_NAME,
       sum(TOTAL_FEE)TOTAL_FEE
  FROM DM_V_HUAXIAO_INFO_M  T,
       DIM.DIM_AREA_NO      A,
       DIM.DIM_CITY_NO      B,
       DIM.DIM_HUAXIAO_INFO C
 WHERE T.ACCT_MONTH = '201806'
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
 WHERE A.TASK_NO IN ('T1011','T2010','T3011','T4014') ) where rn=1
       )b
       where a.huaxiao_no=b.huaxiao_no(+)

--全量导出
select b.area_desc 地市,
       c.city_desc 区县, 
       a.huaxiao_no 划小编码,
       a.huaxiao_name 划小名称,
       a.huaxiao_type_name 划小类型，
       decode(a.if_valid,'1','有效','无效') 状态
  from dim.dim_huaxiao_info a, dim.dim_area_no b, dim.dim_city_no c
 where a.area_no = b.area_no
   and a.city_no = c.city_no
   and huaxiao_type in ('01','02','03','04','05','06','07','08') 
   
   

--集团导出 
create table xxhb_mjh.tmp_hx_contract_01 as 
SELECT ACCT_MONTH 日期,
       B.AREA_DESC 地市,
       A.CNTRT_MGMT_UNIT_CD 划小单元编码,
       A.CNTRT_MGMT_UNIT_NM 划小单元名称,
       A.CNTRT_MGMT_UNIT_LEVEL 层级编码,
       C.CNTRT_MGMT_UNIT_LEVEL_NAME 层级名称,
       A.CNTRT_MGMT_TYPE 划小类型编码,
       e.cntrt_mgmt_type_big 一级分类,
       E.CNTRT_MGMT_TYPE_NAME 二级分类,
       A.CNTRT_MGMT_CHECK_TYPE 考核类型编码,
       D.CNTRT_MGMT_CHECK_TYPE_NAME 考核类型名称,
       A.CNTRT_AGRMNT_CD 合同编码,
       decode(f.if_valid,'0','否','是') 是否有效, 
       f.manager_loginname 小CEO姓名,
       f.manager_telephone 电话号码
  FROM BWT_CNTRT_MGMT_UNIT_M      A,
       DIM.DIM_AREA_NO_JT         B,
       XXHB_MJH.TMP_MAJH_HX_LEVEL C,
       XXHB_MJH.TMP_MAJH_HX_KH    D,
       XXHB_MJH.TMP_MAJH_HX_TYPE  E，
       dim.dim_huaxiao_info f 
 WHERE A.ACCT_MONTH = '201808' 
   AND A.LATN_ID = B.STD_LATN_CD
   AND A.CNTRT_MGMT_UNIT_LEVEL = C.CNTRT_MGMT_UNIT_LEVEL
   AND A.CNTRT_MGMT_TYPE = E.CNTRT_MGMT_TYPE
   AND A.CNTRT_MGMT_CHECK_TYPE = D.CNTRT_MGMT_CHECK_TYPE
   and a.cntrt_mgmt_unit_cd=f.huaxiao_no(+)
   and a.CNTRT_AGRMNT_CD is not null;

--导出
SELECT A.*, B.STATUS
  FROM XXHB_MJH.TMP_HX_CONTRACT_01 A,
       (SELECT *
          FROM (SELECT A.*,
                       ROW_NUMBER() OVER(PARTITION BY A.SMALLCODE ORDER BY A.STATUS DESC, CONTRACTID DESC) RN
                  FROM MID_CONTRACT_INFO A)
         WHERE RN = 1) B
 WHERE A.划小单元编码 = B.SMALLCODE(+)

select a.*,
CONTRACTCODE,SMALLCEONAME,SMALLCEOIDCARD
  from (select b.area_desc,
               c.city_desc,
               a.huaxiao_no,
               a.huaxiao_name,
               a.huaxiao_type_name
          from dim.dim_huaxiao_info a, dim.dim_area_no b, dim.dim_city_no c
         where a.area_no = b.area_no
           and a.city_no = c.city_no
           and a.HUAXIAO_TYPE IN
               ('01', '02', '03', '04', '05', '06', '07', '08', '09')) a,
       (SELECT *
          FROM (SELECT A.*,
                       ROW_NUMBER() OVER(PARTITION BY A.SMALLCODE ORDER BY A.STATUS DESC, CONTRACTID DESC) RN
                  FROM CONTRACT_INFO A)
         WHERE RN = 1) b
 where a.huaxiao_no = b.SMALLCODE(+)

