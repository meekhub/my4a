SELECT T.ACCT_MONTH ����,
       X.AREA_DESC ����,
       H_LEVEL_UNIT_NAME �а���Ԫ��һ��������Ԫ����,
       CNTRT_MGMT_UNIT_CD ��С�а���Ԫ����,
       CNTRT_MGMT_UNIT_NM ��С�а���Ԫ����,
       decode(CNTRT_MGMT_UNIT_LEVEL,'40','�ļ���Ԫ') ��С�а���Ԫ�㼶,
       case when CNTRT_MGMT_TYPE='1020' then 'ũ��֧�ֳа���Ӫ'
         when CNTRT_MGMT_TYPE='3010' then '�곤�а���Ӫ' 
           when CNTRT_MGMT_TYPE='3020' then '���������̳а���Ӫ'
             when CNTRT_MGMT_TYPE='3030' then '��������Ƭ���а���Ӫ' end ��С�а���Ԫ����,
       decode(CNTRT_MGMT_CHECK_TYPE,'10','ҵ�����а�','����а�') ��С�а���������,
       CNTRT_AGRMNT_CD �а�Э�����
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
 decode(a.cntrt_target_unit,'1','��','Ԫ'),a.target_value
  from BWT_CNTRT_MGMT_SUM_M a,dim.dim_huaxiao_info b,tmp_majh_target c
  where a.acct_month='201711'
  and a.cntrt_mgmt_unit_cd=b.huaxiao_no
  and a.cntrt_target_cd=c.target_name





