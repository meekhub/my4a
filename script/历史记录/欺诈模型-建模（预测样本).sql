--ȫ��Ԥ����������
truncate table tmp_majh_qizha_yc_base

insert into tmp_majh_qizha_yc_base
select device_number,decode(b.is_ocs,'��','1','0') is_ocs from DW_V_USER_BASE_INFO_USER b where 
acct_month='201705' and is_onnet='��' and tele_type='2'

select is_ocs,count(*) from tmp_majh_qizha_yc_base group by is_ocs

truncate table TMP_MAJH_QIZHA_02_ZC

--�������ָ��(�󸶷�)
INSERT INTO TMP_MAJH_QIZHA_02_ZC
  SELECT '201705' ACCT_MONTH,
         A.DEVICE_NUMBER,
         nvl(SUM(CASE
               WHEN B.ORG_TRM_ID = '10' THEN
                B.CALL_DURATION
               ELSE
                0
             END),0) ZHU_CALL_DURATION, --����ͨ��ʱ��
         nvl(SUM(B.CALL_DURATION),0) CALL_DURATION, --��ͨ��ʱ��
         nvl(COUNT(CASE
                 WHEN B.ORG_TRM_ID = '10' THEN
                  B.OPPOSE_NUMBER
               END),0) ZHU_CALL_CDR, --����ͨ������
         nvl(COUNT(B.OPPOSE_NUMBER),0) CALL_CDR, --��ͨ������
         nvl(COUNT(DISTINCT B.OPPOSE_NUMBER),0) CALL_USERS, --��ͨ���˴�
         nvl(COUNT(DISTINCT concat(b.acct_month,b.CALL_DATE)),0) CALL_DAYS, --ͨ�����
         nvl(COUNT(CASE
                 WHEN B.CALL_DURATION < 15 THEN
                  B.OPPOSE_NUMBER
               END),0) LOWER_15_CDR, --15����ͨ������
         nvl(COUNT(CASE
                 WHEN B.CALL_DURATION < 60 THEN
                  B.OPPOSE_NUMBER
               END),0) LOWER_60_CDR, --60����ͨ������
         nvl(SUM(CASE
               WHEN B.ROAM_TYPE <> '10' AND B.ORG_TRM_ID = '10' THEN
                B.CALL_DURATION
               ELSE
                0
             END),0) ROAM_DURATION, --����ͨ��ʱ��
         nvl(SUM(CASE
               WHEN B.LONG_TYPE <> '10' AND B.ORG_TRM_ID = '10' THEN
                B.CALL_DURATION
               ELSE
                0
             END),0) LONG_DURATION --��;ͨ��ʱ��
    FROM (SELECT * FROM tmp_majh_qizha_yc_base WHERE IS_OCS = '0') A
    LEFT JOIN (SELECT *
                 FROM DW_V_USER_CDR_CDMA B
                WHERE ACCT_MONTH in ('201703','201704','201705')) B
      ON A.DEVICE_NUMBER = B.DEVICE_NUMBER
   GROUP BY a.DEVICE_NUMBER

   
   
   --�������ָ��(Ԥ����)
INSERT INTO TMP_MAJH_QIZHA_02_ZC
  SELECT '201705' ACCT_MONTH,
         A.DEVICE_NUMBER,
         nvl(SUM(CASE
               WHEN B.ORG_TRM_ID = '10' THEN
                B.CALL_DURATION
               ELSE
                0
             END),0) ZHU_CALL_DURATION, --����ͨ��ʱ��
         nvl(SUM(B.CALL_DURATION),0) CALL_DURATION, --��ͨ��ʱ��
         nvl(COUNT(CASE
                 WHEN B.ORG_TRM_ID = '10' THEN
                  B.OPPOSE_NUMBER
               END),0) ZHU_CALL_CDR, --����ͨ������
         nvl(COUNT(B.OPPOSE_NUMBER),0) CALL_CDR, --��ͨ������
         nvl(COUNT(DISTINCT B.OPPOSE_NUMBER),0) CALL_USERS, --��ͨ���˴�
         nvl(COUNT(DISTINCT concat(b.acct_month,b.CALL_DATE)),0) CALL_DAYS, --ͨ�����
         nvl(COUNT(CASE
                 WHEN B.CALL_DURATION < 15 THEN
                  B.OPPOSE_NUMBER
               END),0) LOWER_15_CDR, --15����ͨ������
         nvl(COUNT(CASE
                 WHEN B.CALL_DURATION < 60 THEN
                  B.OPPOSE_NUMBER
               END),0) LOWER_60_CDR, --60����ͨ������
         nvl(SUM(CASE
               WHEN B.ROAM_TYPE <> '10' AND B.ORG_TRM_ID = '10' THEN
                B.CALL_DURATION
               ELSE
                0
             END),0) ROAM_DURATION, --����ͨ��ʱ��
         nvl(SUM(CASE
               WHEN B.LONG_TYPE <> '10' AND B.ORG_TRM_ID = '10' THEN
                B.CALL_DURATION
               ELSE
                0
             END),0) LONG_DURATION --��;ͨ��ʱ��
    FROM (SELECT * FROM tmp_majh_qizha_yc_base WHERE IS_OCS = '1') A
    LEFT JOIN (SELECT *
                 FROM DW_V_USER_CDR_CDMA_OCS B
                WHERE ACCT_MONTH in ('201702','201703','201704','201705')
                and area_no='188') B
      ON A.DEVICE_NUMBER = B.DEVICE_NUMBER
   GROUP BY a.DEVICE_NUMBER
   
   
   
   --����ƽ��ֵ
  insert into  TMP_MAJH_QIZHA_03_ZC
 select  
device_integer device_number,
ceil(zhu_call_duration/4)zhu_call_duration,
ceil(call_duration    /4)call_duration    ,
ceil(zhu_call_cdr     /4)zhu_call_cdr     ,
ceil(call_cdr         /4)call_cdr         ,
ceil(call_users       /4)call_users       ,
ceil(call_days        /4)call_days        ,
ceil(lower_15_cdr     /4)lower_15_cdr     ,
ceil(lower_60_cdr     /4)lower_60_cdr     ,
ceil(roam_duration    /4)roam_duration    ,
ceil(long_duration    /4)long_duration  
 from TMP_MAJH_QIZHA_02_ZC
 
select * from TMP_MAJH_QIZHA_02_ZC 
 
 --��ȡ�����Ϣ
insert into TMP_MAJH_QIZHA_04_ZC
SELECT DEVICE_NUMBER,
       CASE
         WHEN CERT_TYPE = '6' THEN
          '1'
         ELSE
          '0'
       END IS_CERT, --�Ƿ�Ӫҵִ������
       (TOTAL_FEE + TOTAL_FEE_OCS)TOTAL_FEE, --��������
       CASE
         WHEN TRANS_ID IS NOT NULL THEN
          '1'
         ELSE
          '0'
       END IS_TRANS, --�Ƿ�������ѽɷ�
       INNET_MONTH, -- ����ʱ��
       decode(IS_OCS,'��','1','0')is_ocs, --�Ƿ�Ԥ���ѿ�
       channel_no, --�ն˱���
       terminal_corp,--�ն˳���
       terminal_model, --�ն��ͺ�
       user_dinner --�ײ�
  FROM (SELECT B.*,
               ROW_NUMBER() OVER(PARTITION BY DEVICE_NUMBER ORDER BY INNET_DATE DESC) RN
          FROM (SELECT B.AREA_NO,
                       B.USER_NO,
                       B.DEVICE_NUMBER,
                       B.INNET_DATE,
                       B.CERT_TYPE,
                       B.TRANS_ID,
                       B.INNET_MONTH,
                       B.TOTAL_FEE,
                       B.TOTAL_FEE_OCS,
                       b.is_ocs,
                       b.channel_no,
                       nvl(b.TERMINAL_CORP,'δ֪����')TERMINAL_CORP,
                       nvl(b.TERMINAL_MODEL,'ZZZ-unknown')TERMINAL_MODEL,
                       b.user_dinner
                  FROM DW_V_USER_BASE_INFO_USER B, tmp_majh_qizha_yc_base C
                 WHERE B.ACCT_MONTH = '201705'
                   AND B.TELE_TYPE = '2'
                   AND B.DEVICE_NUMBER = C.DEVICE_NUMBER) B)
 WHERE RN = 1
 
 --�Ƿ����������
select * from  tmp_majh_qizha_black_channel

--�Ƿ���ն��û�
select * from tmp_majh_qizha_low_terminal


--��թ�û��Զ˺���
truncate table tmp_majh_qizha_oppose_number;
insert into tmp_majh_qizha_oppose_number
select 
b.oppose_number 
    FROM (SELECT * FROM tmp_majh_qizha_yc_base WHERE IS_OCS = '0') A
    LEFT JOIN (SELECT DEVICE_NUMBER,oppose_number
                 FROM DW_V_USER_CDR_CDMA B
                WHERE ACCT_MONTH in ('201702','201703','201704','201705')
                  AND B.AREA_NO = '188') B
      ON A.DEVICE_NUMBER = B.DEVICE_NUMBER  
union 
select 
b.oppose_number 
    FROM (SELECT * FROM tmp_majh_qizha_yc_base WHERE IS_OCS = '1') A
    LEFT JOIN (SELECT DEVICE_NUMBER,oppose_number
                 FROM DW_V_USER_CDR_CDMA_OCS B
                WHERE ACCT_MONTH in ('201702','201703','201704','201705')
                  AND B.AREA_NO = '188') B
      ON A.DEVICE_NUMBER = B.DEVICE_NUMBER;


  
select * from tmp_majh_qizha_oppose_number      
 
--��թ�û��嵥
select device_number from tmp_majh_qizha_yc_base
truncate table tmp_majh_qizha_cellmax_zc   
--�����û���ĳ��վ��ͨ�����
insert into tmp_majh_qizha_cellmax_zc
select device_number,max(cell_rate) cell_rate
from 
(select 
x.device_number,x.call_duration/y.call_duration cell_rate
from 
(select 
a.device_number,b.cell_no,sum(call_duration)call_duration
    FROM (SELECT * FROM tmp_majh_qizha_yc_base WHERE IS_OCS = '0') A
    LEFT JOIN (SELECT DEVICE_NUMBER,oppose_number,b.cell_no,b.call_duration
                 FROM DW_V_USER_CDR_CDMA B
                WHERE ACCT_MONTH in ('201702','201703','201704','201705')
                  AND B.AREA_NO = '188') B
      ON A.DEVICE_NUMBER = B.DEVICE_NUMBER
group by a.device_number,b.cell_no   
)x
left join
TMP_MAJH_QIZHA_02_ZC y
on x.device_number=y.device_integer)
group by device_number
   
 
 insert into tmp_majh_qizha_cellmax_zc
select device_number,max(cell_rate) cell_rate
from 
(select 
x.device_number,x.call_duration/y.call_duration cell_rate
from 
(select 
a.device_number,b.cell_no,sum(call_duration)call_duration
    FROM (SELECT * FROM tmp_majh_qizha_yc_base WHERE IS_OCS = '1') A
    LEFT JOIN (SELECT DEVICE_NUMBER,oppose_number,b.cell_no,b.call_duration
                 FROM DW_V_USER_CDR_CDMA_OCS B
                WHERE ACCT_MONTH in ('201702','201703','201704','201705')
                  AND B.AREA_NO = '188') B
      ON A.DEVICE_NUMBER = B.DEVICE_NUMBER
group by a.device_number,b.cell_no   
)x
left join
TMP_MAJH_QIZHA_02_ZC y
on x.device_number=y.device_integer)
group by device_number
   

--����������
truncate table tmp_majh_qizha_hz_01_zc
insert into tmp_majh_qizha_hz_01_zc 
select 
a.device_number, --�ֻ���
a.INNET_MONTH, --����ʱ��
case when d.channel_no is not null then '1' else '0' end is_risk_channel, --�Ƿ�߷��մ�����
nvl(b.call_duration,0) call_duration,--��4���¾�ͨ��ʱ��
nvl(b.call_cdr,0) call_cdr, --��4���¾�ͨ������
nvl(round(b.zhu_call_duration/b.call_duration,4),0)*100 zhu_dur_rate, --����ͨ��ʱ��ռ�� 
nvl(round(b.zhu_call_cdr/b.call_cdr,4),0)*100 zhu_cdr_rate, --����ͨ������ռ��
nvl(round(b.call_users/b.call_cdr,4),0)*100 zhu_users_rate, --������ɢ��
nvl(round(b.call_duration/b.call_cdr,4),0)*100 zhu_per_dur, --����ͨ��ʱ��
nvl(round(b.lower_60_cdr/b.call_cdr,4),0)*100 lower_60_rate, --60����ͨ������ռ��
nvl(round(b.lower_15_cdr/b.call_cdr,4),0)*100 lower_15_rate, --15����ͨ������ռ��
nvl(round(b.roam_duration/b.zhu_call_duration,4),0)*100 roam_dur_rate, --����ͨ��ռ��
nvl(round(b.long_duration/b.zhu_call_duration,4),0)*100 long_dur_rate, --��;ͨ��ռ��
nvl(a.total_fee,0)total_fee, --��������
nvl(round(b.call_cdr/b.call_days,4),0)*100 call_mon_rate, --�»���ֲ�
nvl(a.is_trans,'0')is_trans,--�Ƿ�������ѽɷ�
nvl(a.is_ocs,'0')is_ocs, -- �Ƿ�Ԥ����
nvl(round(f.cell_rate,4),0)*100 cell_rate, --ͨ����վ������
case when g.device_number is not null then '1' else '0' end is_link_risk --�Ƿ����թ�Զ˺�����ϵ��
 from TMP_MAJH_QIZHA_04_ZC a --������Ϣ��
left join
TMP_MAJH_QIZHA_03_ZC b --��4���º�����Ϣ
on a.device_number=b.device_number 
left join
tmp_majh_qizha_black_channel d --������������Ϣ
on a.channel_no=d.channel_no
left join
tmp_majh_qizha_low_terminal e --���ն���Ϣ
on a.terminal_corp=e.terminal_corp and a.terminal_model=e.terminal_model
left join
tmp_majh_qizha_cellmax_zc f --ͨ�����Ļ�վ
on a.device_number=f.device_number
left join
tmp_majh_qizha_oppose_number g --��թ�û��Զ˿�
on a.device_number=g.device_number;


select * from tmp_majh_qizha_hz_01_zc where call_duration>0 and call_cdr>0
      