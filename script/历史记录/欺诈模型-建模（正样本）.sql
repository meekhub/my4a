--�������ָ��(�󸶷�)
INSERT INTO TMP_MAJH_QIZHA_02
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
    FROM (SELECT * FROM TMP_MAJH_QIZHA_01 WHERE IS_OCS = '0') A
    LEFT JOIN (SELECT *
                 FROM DW_V_USER_CDR_CDMA B
                WHERE ACCT_MONTH in ('201702','201703','201704','201705')
                  AND B.AREA_NO = '188') B
      ON A.DEVICE_NUMBER = B.DEVICE_NUMBER
   GROUP BY a.DEVICE_NUMBER
   
   
   
   
   --�������ָ��(Ԥ����)
INSERT INTO TMP_MAJH_QIZHA_02
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
    FROM (SELECT * FROM TMP_MAJH_QIZHA_01 WHERE IS_OCS = '1') A
    LEFT JOIN (SELECT *
                 FROM DW_V_USER_CDR_CDMA_OCS B
                WHERE ACCT_MONTH in ('201702','201703','201704','201705')
                  AND B.AREA_NO = '188') B
      ON A.DEVICE_NUMBER = B.DEVICE_NUMBER
   GROUP BY a.DEVICE_NUMBER
   
   
   
   --����ƽ��ֵ
  insert into  TMP_MAJH_QIZHA_03
 select  
device_double device_number,
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
 from TMP_MAJH_QIZHA_02
 
 
 --һ֤�࿨
 insert into tmp_qizha_cert_users
select
customer_no
 FROM DW_V_USER_BASE_INFO_USER B 
                 WHERE B.ACCT_MONTH = '201706'
                   AND B.TELE_TYPE = '2'
                   and is_onnet='��' 
 group by customer_no
 having count(*)>= 3
 
 
 --��ȡ�����Ϣ
insert into TMP_MAJH_QIZHA_04
SELECT x.DEVICE_NUMBER,
       CASE
         WHEN x.CERT_TYPE = '6' THEN
          '1'
         ELSE
          '0'
       END IS_CERT, --�Ƿ�Ӫҵִ������
       (x.TOTAL_FEE + x.TOTAL_FEE_OCS)TOTAL_FEE, --��������
       CASE
         WHEN x.TRANS_ID IS NOT NULL THEN
          '1'
         ELSE
          '0'
       END IS_TRANS, --�Ƿ�������ѽɷ�
       x.INNET_MONTH, -- ����ʱ��
       decode(x.IS_OCS,'��','1','0')is_ocs, --�Ƿ�Ԥ���ѿ�
       x.channel_no, --��������
       x.terminal_corp,--�ն˳��� 
       x.terminal_model, --�ն��ͺ�
       x.terminal_code, --�ն˱���
       x.user_dinner, --�ײ�
       case when x.user_dinner in (
       		'1411909',
			'35774',
			'34478',
			'1381043',
			'35802',
			'1375883',
			'1381044',
			'1398026',
			'1397934',
			'1398016',
			'1404412',
			'1406200') then '1' else '0' end is_risk_dinner, --�Ƿ�߷����ײ�
	case when y.customer_no is not null then '1' else '0' end is_cert_1_n --�Ƿ�һ֤�����û�
  FROM 
  (select * from (SELECT B.*,
               ROW_NUMBER() OVER(PARTITION BY b.DEVICE_NUMBER ORDER BY b.INNET_DATE DESC) RN
          FROM (SELECT   
                       B.DEVICE_NUMBER,
                       B.INNET_DATE,
                       B.CERT_TYPE,
                       B.TRANS_ID,
                       B.INNET_MONTH,
                       B.TOTAL_FEE,
                       B.TOTAL_FEE_OCS,
                       b.is_ocs,
                       b.channel_no,
                       b.customer_no,
                       nvl(b.TERMINAL_CORP,'δ֪����')TERMINAL_CORP,
                       nvl(b.TERMINAL_MODEL,'ZZZ-unknown')TERMINAL_MODEL,
                       b.terminal_code,
                       b.user_dinner
                  FROM DW_V_USER_BASE_INFO_USER B, TMP_MAJH_QIZHA_01 C
                 WHERE B.ACCT_MONTH = '201705'
                   AND B.TELE_TYPE = '2'
                   AND B.DEVICE_NUMBER = C.DEVICE_NUMBER) B)
 WHERE RN = 1)x
 left join
 tmp_qizha_cert_users y
 on x.customer_no=y.customer_no
 
 
 --�Ƿ����������
select * from  tmp_majh_qizha_black_channel

--�Ƿ���ն��û�
select * from tmp_majh_qizha_low_terminal


--��թ�û��Զ˺���
truncate table tmp_majh_qizha_oppose_number;
insert into tmp_majh_qizha_oppose_number
select 
b.oppose_number 
    FROM (SELECT * FROM TMP_MAJH_QIZHA_01 WHERE IS_OCS = '0') A
    LEFT JOIN (SELECT DEVICE_NUMBER,oppose_number
                 FROM DW_V_USER_CDR_CDMA B
                WHERE ACCT_MONTH in ('201702','201703','201704','201705')
                  AND B.AREA_NO = '188') B
      ON A.DEVICE_NUMBER = B.DEVICE_NUMBER  
union 
select 
b.oppose_number 
    FROM (SELECT * FROM TMP_MAJH_QIZHA_01 WHERE IS_OCS = '1') A
    LEFT JOIN (SELECT DEVICE_NUMBER,oppose_number
                 FROM DW_V_USER_CDR_CDMA_OCS B
                WHERE ACCT_MONTH in ('201702','201703','201704','201705')
                  AND B.AREA_NO = '188') B
      ON A.DEVICE_NUMBER = B.DEVICE_NUMBER;


  
select * from tmp_majh_qizha_oppose_number      
 
--��թ�û��嵥
select device_number from TMP_MAJH_QIZHA_01

truncate table tmp_majh_qizha_cellmax   
--�����û���ĳ��վ��ͨ�����
insert into tmp_majh_qizha_cellmax
select device_number,max(cell_rate) cell_rate
from 
(select 
x.device_number,x.call_duration/y.call_duration cell_rate
from 
(select 
a.device_number,b.cell_no,sum(call_duration)call_duration
    FROM (SELECT * FROM TMP_MAJH_QIZHA_01 WHERE IS_OCS = '0') A
    LEFT JOIN (SELECT DEVICE_NUMBER,oppose_number,b.cell_no,b.call_duration
                 FROM DW_V_USER_CDR_CDMA B
                WHERE ACCT_MONTH in ('201702','201703','201704','201705')
                  AND B.AREA_NO = '188') B
      ON A.DEVICE_NUMBER = B.DEVICE_NUMBER
group by a.device_number,b.cell_no   
)x
left join
TMP_MAJH_QIZHA_02 y
on x.device_number=y.device_double)
group by device_number
   
 
 insert into tmp_majh_qizha_cellmax
select device_number,max(cell_rate) cell_rate
from 
(select 
x.device_number,x.call_duration/y.call_duration cell_rate
from 
(select 
a.device_number,b.cell_no,sum(call_duration)call_duration
    FROM (SELECT * FROM TMP_MAJH_QIZHA_01 WHERE IS_OCS = '1') A
    LEFT JOIN (SELECT DEVICE_NUMBER,oppose_number,b.cell_no,b.call_duration
                 FROM DW_V_USER_CDR_CDMA_OCS B
                WHERE ACCT_MONTH in ('201702','201703','201704','201705')
                  AND B.AREA_NO = '188') B
      ON A.DEVICE_NUMBER = B.DEVICE_NUMBER
group by a.device_number,b.cell_no   
)x
left join
TMP_MAJH_QIZHA_02 y
on x.device_number=y.device_double)
group by device_number

--��թ�û�ע������ն�
insert into tmp_majh_qizha_term 
select 
distinct b.terminal_code
 from TMP_MAJH_QIZHA_04 a,
(select device_no,terminal_code from DW_V_USER_TERMINAL_D where acct_day='20170701')b
where a.device_number=b.device_no



--����������
truncate table tmp_majh_qizha_hz_01

insert into tmp_majh_qizha_hz_01 
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
case when g.device_number is not null then '1' else '0' end is_link_risk, --�Ƿ����թ�Զ˺�����ϵ��
case when h.terminal_code is not null then '1' else '0' end is_reg_risk, -- �Ƿ�ע���թƭ�û��ն�
nvl(a.is_risk_dinner,'0') is_risk_dinner, --�Ƿ�����ײ�
case when e.terminal_model is not null then '1' else '0' end is_low_terminal, --�Ƿ�ͼ�ֵ�ն�
nvl(a.is_cert_1_n,'0') is_cert_1_n --�Ƿ�һ֤�����û�
 from TMP_MAJH_QIZHA_04 a --������Ϣ��
left join
TMP_MAJH_QIZHA_03 b --��4���º�����Ϣ
on a.device_number=b.device_number 
left join
tmp_majh_qizha_black_channel d --������������Ϣ
on a.channel_no=d.channel_no
left join
tmp_majh_qizha_low_terminal e --���ն���Ϣ
on a.terminal_corp=e.terminal_corp and a.terminal_model=e.terminal_model
left join
tmp_majh_qizha_cellmax f --ͨ�����Ļ�վ
on a.device_number=f.device_number
left join
tmp_majh_qizha_oppose_number g --��թ�û��Զ˿�
on a.device_number=g.device_number
left join
tmp_majh_qizha_term h --թƭ�û�ʹ�ù����ն�
on a.terminal_code=h.terminal_code



select * from tmp_majh_qizha_hz_01 where call_duration>0 and call_cdr>0
   












   