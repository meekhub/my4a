SELECT * FROM USER_TABLES A WHERE A.TABLE_NAME LIKE '%PROJECT%';

select * from BUDGET_ACCOUNTING;

--Ԥ��ɱ�����
select * from mss_ds.BUDGET_COST_CENTER@hana;

--Ԥ��ɱ�������֯��
select * from mss_ds.budget_cost_center_org@hana;

--Ԥ������Ӧ�ñ�
select * from mss_ds.budget_inst_app@hana where org_id='2701080002'  and budget_item_id='27_Cost_3091';

--Ԥ��ָ���
select * from mss_ds.BUDGET_ITEM@hana

select * from budget_inst_app where budget_item_id='27_Cost_3091'

select * from mss_ds.BUDGET_INST_COST@hana

--�ɱ���ṹ
select * from mss_ds.BUDGET_INST_ARCHIVE_COST@hana where org_id='2708000013'

--Ԥ��ָ���
select * from budget_item a where a.budget_item_name like '%�׺�%';

select * from budget_item a where a.id='27_Cost_3019'



��������ѣ�27_Cost_2740
�ͻ�����ѣ�27_Cost_2910
ҵ���д��ѣ�27_Cost_3091
--����ʹ�ü����޷ѣ�27_Cost_3095
��ֵ�׺�Ʒ�ѣ�27_Cost_3074
ҵ����Ʒ�ѣ�27_Cost_3004
����֧�� ��27_Cost_2897
���ݡ����ؼ��������޷�	27_Cost_3019

select *
  from budget_item a
 where a.id in ('27_Cost_2740',
                '27_Cost_2910',
                '27_Cost_3091',
                '27_Cost_3074',
                '27_Cost_3004',
                '27_Cost_2897',
                '27_Cost_3019')
BUDGET_SET_STR;


create table xxhb_mjh.tmp_majh_dz_fee as 
SELECT '201808' ACCT_MONTH,
       C.AREA_NO,
       C.CITY_NO,
       '1' HUAXIAO_TYPE_BIG,
       C.HUAXIAO_TYPE,
       C.HUAXIAO_NO,
       '02' TYPE_ONE,
       '01' TYPE_TWO,
       SUM(CASE
             WHEN A.BUDGET_SET_STR = '201807' AND
                  UPPER(BUDGET_ITEM_ID) IN ('27_COST_2740') THEN
              A.USED_SUM
             ELSE
              0
           END)gg_fee, --���������
       SUM(CASE
             WHEN A.BUDGET_SET_STR = '201807' AND
                  UPPER(BUDGET_ITEM_ID) IN ('27_COST_2910') THEN
              A.USED_SUM
             ELSE
              0
           END)kf_fee, --�ͻ������
       SUM(CASE
             WHEN A.BUDGET_SET_STR = '201807' AND
                  UPPER(BUDGET_ITEM_ID) IN ('27_COST_3091') THEN
              A.USED_SUM
             ELSE
              0
           END)yw_fee, --ҵ���д���
       SUM(CASE
             WHEN A.BUDGET_SET_STR = '201807' AND
                  UPPER(BUDGET_ITEM_ID) IN ('27_COST_3074') THEN
              A.USED_SUM
             ELSE
              0
           END)dz_fee, --��ֵ�׺�Ʒ��
       SUM(CASE
             WHEN A.BUDGET_SET_STR = '201807' AND
                  UPPER(BUDGET_ITEM_ID) IN ('27_COST_3004') THEN
              A.USED_SUM
             ELSE
              0
           END)yp_fee, --ҵ����Ʒ��
       SUM(CASE
             WHEN A.BUDGET_SET_STR = '201807' AND
                  UPPER(BUDGET_ITEM_ID) IN ('27_COST_2897') THEN
              A.USED_SUM
             ELSE
              0
           END)zc_fee, --ҵ��֧��
       SUM(CASE
             WHEN A.BUDGET_SET_STR = '201807' AND
                  UPPER(BUDGET_ITEM_ID) IN ('27_COST_3019') THEN
              A.USED_SUM
             ELSE
              0
           END)zl_fee --���޷�
  FROM MSS_DS.BUDGET_INST_APP@HANA A,
       DIM.DIM_CW_HUAXIAO_INFO     B,
       DIM.DIM_HUAXIAO_INFO        C
 WHERE UPPER(BUDGET_ITEM_ID) IN ('27_COST_2740',
                                 '27_COST_2910',
                                 '27_COST_3091',
                                 '27_COST_3074',
                                 '27_COST_3004',
                                 '27_COST_2897',
                                 '27_COST_3019')
   AND A.ORG_ID = B.CW_HUAXIAO_NO
   AND B.YW_HUAXIAO_NO = C.HUAXIAO_NO
 GROUP BY C.AREA_NO, C.CITY_NO, C.HUAXIAO_TYPE, C.HUAXIAO_NO


--���Ԥ�� 
--ȡ���ھ�  ȡbudget_set_str=2018  ����create_date���ȡassign_sum
SELECT *
  FROM BUDGET_INST_COST A, BUDGET_INST_ARCHIVE_COST B
 WHERE A.BUDGET_ARCHIVE_ID = B.ID
   AND A.SUM > 0
   AND B.ORG_ID = '2709050004'
   AND A.BUDGET_ITEM_ID='27_Cost_2740'
   --AND ORG_ID='2701090007'
   
   
   
   
   

�������� ��27_Cost_2741
�������Ӷ�� ��27_Cost_2770
����֧�� ��27_Cost_2897
���۷���-�������ն˲����27_Cash_0611

�������޷�	27_Cost_2734
ƽ̨��ϯ������Ӫ��	27_Cost_2960
���ݡ����ؼ��������޷�	27_Cost_3019
��·��������Ԫ���޷�	27_Cost_3025
CDMA������ʩ���޷�	27_Cost_3026
����������ʲ����޷�	27_Cost_30270005
��������	27_Cost_317701
����ʹ�ü����޷�	27_Cost_3095
�칫�豸����	27_Cost_3100








select * from budget_inst_app;

select * from budget_inst_app_detail


select * from budget_cost_back_certificate



select 
'���',
sum(gg_fee) ���,
sum(kf_fee)�ͷ�,
sum(yw_fee) ҵ���д�,
sum(dz_fee) ��ֵ, 
sum(yp_fee) ��Ʒ,
sum(zc_fee) ҵ��֧��,
sum(zl_fee) ����
 from xxhb_mjh.tmp_majh_dz_fee t where t.type_two='01'
 union 
 select 
'201808',
sum(gg_fee),
sum(kf_fee),
sum(yw_fee),
sum(dz_fee),
sum(yp_fee),
sum(zc_fee),
sum(zl_fee)
 from xxhb_mjh.tmp_majh_dz_fee t where t.type_two='02'
 union 
 select 
'201807',
sum(gg_fee),
sum(kf_fee),
sum(yw_fee),
sum(dz_fee),
sum(yp_fee),
sum(zc_fee),
sum(zl_fee)
 from xxhb_mjh.tmp_majh_dz_fee t where t.type_two='03'
 union 
 select 
'201806',
sum(gg_fee),
sum(kf_fee),
sum(yw_fee),
sum(dz_fee),
sum(yp_fee),
sum(zc_fee),
sum(zl_fee)
 from xxhb_mjh.tmp_majh_dz_fee t where t.type_two='04'



