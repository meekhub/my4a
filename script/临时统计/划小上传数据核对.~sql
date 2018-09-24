SELECT T.ACCT_MONTH 账期,
       X.AREA_DESC 地市,
       H_LEVEL_UNIT_NAME 承包单元上一级生产单元名称,
       CNTRT_MGMT_UNIT_CD 划小承包单元编码,
       CNTRT_MGMT_UNIT_NM 划小承包单元名称,
       decode(CNTRT_MGMT_UNIT_LEVEL,'40','四级单元') 划小承包单元层级,
       case when CNTRT_MGMT_TYPE='1020' then '农村支局承包经营'
         when CNTRT_MGMT_TYPE='3010' then '店长承包经营' 
           when CNTRT_MGMT_TYPE='3020' then '渠道经理按商承包经营'
             when CNTRT_MGMT_TYPE='3030' then '渠道经理按片区承包经营' end 划小承包单元类型,
       decode(CNTRT_MGMT_CHECK_TYPE,'10','业务量承包','收入承包') 划小承包考核类型,
       CNTRT_AGRMNT_CD 承包协议编码
  FROM BWT_CNTRT_MGMT_UNIT_M T, DIM.DIM_AREA_NO_JT X
 WHERE T.ACCT_MONTH = '201711'
   AND T.LATN_ID = X.STD_LATN_CD;
   
   
select 
b.huaxiao_no,b.huaxiao_name,c.channel_nbr,c.channel_name
 from BWT_CNTRT_MGMT_CHNL_REL_M a,dim.dim_huaxiao_info b,
crm_dsg.channel@hbods c
 where a.acct_month='201711'
 and a.sale_outlets_cd=c.channel_nbr
 and a.cntrt_mgmt_unit_cd=b.huaxiao_no;
 
 
 select 
 b.huaxiao_no,b.huaxiao_name,c.target_name,c.target_cd,
 decode(a.cntrt_target_unit,'1','户','元'),a.target_value
  from BWT_CNTRT_MGMT_SUM_M a,dim.dim_huaxiao_info b,tmp_majh_target c
  where a.acct_month='201711'
  and a.cntrt_mgmt_unit_cd=b.huaxiao_no
  and a.cntrt_target_cd=c.target_name





