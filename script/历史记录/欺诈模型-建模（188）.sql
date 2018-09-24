--���ֺ󸶷ѡ�Ԥ����
truncate table tmp_majh_qizha_pre_base
insert into tmp_majh_qizha_pre_base
select device_number,decode(is_ocs,'��','1','0')
from DW_V_USER_BASE_INFO_USER where acct_month='201706' and is_onnet='��'
and tele_type='2' 
and area_no='188'

select is_ocs,count(*) from tmp_majh_qizha_pre_base group by is_ocs

truncate table TMP_MAJH_QIZHA_02_pre

--�������ָ��(�󸶷�)
INSERT INTO TMP_MAJH_QIZHA_02_pre
  SELECT  
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
    FROM (SELECT * FROM tmp_majh_qizha_pre_base WHERE IS_OCS = '0') A
    LEFT JOIN (SELECT *
                 FROM DW_V_USER_CDR_CDMA B
                WHERE ACCT_MONTH in ('201706')
                and area_no='188') B
      ON A.DEVICE_NUMBER = B.DEVICE_NUMBER
   GROUP BY a.DEVICE_NUMBER

   
   
   --�������ָ��(Ԥ����)
INSERT INTO TMP_MAJH_QIZHA_02_pre
  SELECT  
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
    FROM (SELECT * FROM tmp_majh_qizha_pre_base WHERE IS_OCS = '1') A
    LEFT JOIN (SELECT *
                 FROM DW_V_USER_CDR_CDMA_OCS B
                WHERE ACCT_MONTH in ('201706')
                and area_no='188') B
      ON A.DEVICE_NUMBER = B.DEVICE_NUMBER
   GROUP BY a.DEVICE_NUMBER
   
 
 --��ȡ�����Ϣ
 truncate table TMP_MAJH_QIZHA_04_pre
insert into TMP_MAJH_QIZHA_04_pre
SELECT 
	  x.area_no,
	  x.area_no_desc,
	  x.city_no,
	  x.city_no_desc,
	   x.DEVICE_NUMBER,
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
       nvl(x.INNET_MONTH,'0'), -- ����ʱ��
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
          FROM (SELECT b.area_no,
          			   b.area_no_desc,
          			   b.city_no,
          			   b.city_no_desc,
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
                  FROM DW_V_USER_BASE_INFO_USER B, tmp_majh_qizha_pre_base C
                 WHERE B.ACCT_MONTH = '201706'
                   and area_no='188'
                   AND B.TELE_TYPE = '2'
                   and b.is_onnet='��'
                   AND B.DEVICE_NUMBER = C.DEVICE_NUMBER) B)
 WHERE RN = 1)x
 left join
 tmp_qizha_cert_users y
 on x.customer_no=y.customer_no
 
 --�Ƿ����������
select * from  tmp_majh_qizha_black_channel

--�Ƿ���ն��û�
select * from tmp_majh_qizha_low_terminal
 
--�����û���ĳ��վ��ͨ�����
insert into tmp_majh_qizha_cellmax_pre
select device_number,max(cell_rate) cell_rate
from 
(select 
x.device_number,x.call_duration/y.call_duration cell_rate
from 
(select 
a.device_number,b.cell_no,sum(call_duration)call_duration
    FROM (SELECT * FROM tmp_majh_qizha_pre_base WHERE IS_OCS = '0') A
    LEFT JOIN (SELECT DEVICE_NUMBER,oppose_number,b.cell_no,b.call_duration
                 FROM DW_V_USER_CDR_CDMA B
                WHERE ACCT_MONTH in ('201706')
                  AND B.AREA_NO = '188') B
      ON A.DEVICE_NUMBER = B.DEVICE_NUMBER
group by a.device_number,b.cell_no   
)x
left join
TMP_MAJH_QIZHA_02_pre y
on x.device_number=y.device_number)
group by device_number
   
 
 insert into tmp_majh_qizha_cellmax_pre
select device_number,max(cell_rate) cell_rate
from 
(select 
x.device_number,x.call_duration/y.call_duration cell_rate
from 
(select 
a.device_number,b.cell_no,sum(call_duration)call_duration
    FROM (SELECT * FROM tmp_majh_qizha_pre_base WHERE IS_OCS = '1') A
    LEFT JOIN (SELECT DEVICE_NUMBER,oppose_number,b.cell_no,b.call_duration
                 FROM DW_V_USER_CDR_CDMA_OCS B
                WHERE ACCT_MONTH in ('201706')
                  AND B.AREA_NO = '188') B
      ON A.DEVICE_NUMBER = B.DEVICE_NUMBER
group by a.device_number,b.cell_no   
)x
left join
TMP_MAJH_QIZHA_02_pre y
on x.device_number=y.device_number)
group by device_number
   

--����������
truncate table tmp_majh_qizha_hz_01_pre
insert into tmp_majh_qizha_hz_01_pre 
select 
'201706',
area_no,
area_no_desc,
city_no,
city_no_desc,
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
 from TMP_MAJH_QIZHA_04_pre a --������Ϣ��
left join
TMP_MAJH_QIZHA_02_pre b --��4���º�����Ϣ
on a.device_number=b.device_number 
left join
tmp_majh_qizha_black_channel d --������������Ϣ
on a.channel_no=d.channel_no
left join
tmp_majh_qizha_low_terminal e --���ն���Ϣ
on a.terminal_corp=e.terminal_corp and a.terminal_model=e.terminal_model
left join
tmp_majh_qizha_cellmax_pre f --ͨ�����Ļ�վ
on a.device_number=f.device_number
left join
tmp_majh_qizha_oppose_number g --��թ�û��Զ˿�
on a.device_number=g.device_number
left join
tmp_majh_qizha_term h --թƭ�û�ʹ�ù����ն�
on a.terminal_code=h.terminal_code


select count(*) from tmp_majh_qizha_hz_01_pre where call_duration>0 and call_cdr>0


select count(*) from tmp_majh_qizha_hz_01_pre a,  tmp_majh_qizha_hz_01 b where a.device_number=b.device_number

select * from tmp_majh_qizha_hz_01 where device_number='17703311673'

select ceil(cell_rate),count(*) from tmp_majh_qizha_hz_01_pre group by ceil(cell_rate)

select * from tmp_majh_qizha_hz_01_pre where cell_rate=100 and call_cdr>800

truncate table tmp_majh_qizha_out

insert into  tmp_majh_qizha_out
select device_number from 
(
--����1
select a.device_number from tmp_majh_qizha_hz_01_pre a 
 left join tmp_majh_qizha_hz_01 b
on a.device_number=b.device_number
 WHERE a.IS_REG_RISK = '1' and a.is_cert_1_n='1' and a.is_risk_channel='1'
 and b.device_number is null
union 
--����2
select a.device_number from tmp_majh_qizha_hz_01_pre a 
 left join tmp_majh_qizha_hz_01 b
on a.device_number=b.device_number
 WHERE a.ZHU_CDR_RATE > 90 and a.CALL_MON_RATE > 2626.670 and a.ZHU_DUR_RATE > 95.620 and a.is_cert_1_n='1'
 and b.device_number is null
--����3
union
select a.device_number from tmp_majh_qizha_hz_01_pre a 
 left join tmp_majh_qizha_hz_01 b
on a.device_number=b.device_number
 WHERE a.is_link_risk='1' and a.IS_REG_RISK = '1'
 and b.device_number is null
 union
 --����4
 select a.device_number from tmp_majh_qizha_hz_01_pre a 
 left join tmp_majh_qizha_hz_01 b
on a.device_number=b.device_number
 WHERE a.call_cdr>2000 and a.is_dinner_risk='1' and a.is_low_terminal='1' and a.ZHU_CDR_RATE>75.23
 and b.device_number is null
union
 select a.device_number from tmp_majh_qizha_hz_01_pre a 
 left join tmp_majh_qizha_hz_01 b
on a.device_number=b.device_number
 WHERE a.cell_rate=100 and a.call_cdr>800
 and b.device_number is null  
)



--�����û�
select 
a.device_number �ֻ���,
b.is_ocs �Ƿ�Ԥ����,
b.area_no_desc ����,
b.city_no_desc ����,
b.customer_name �ͻ�����,
b.innet_date ��������,
b.innet_month ����ʱ��,
c.call_cdr ����ͨ������,
c.ZHU_CDR_RATE ���д���ռ��,
c.CALL_MON_RATE �»����ж�,
c.is_cert_1_n �Ƿ�һ֤���������û�,
b.user_status_desc �û�״̬,
b.channel_no_desc ��������,
b.user_dinner_desc �ײ�,
b.terminal_model �ն��ͺ�
 from tmp_majh_qizha_out a
join 
(
select 
b.device_number,
b.is_ocs,
b.area_no_desc,
b.city_no_desc,
b.customer_name,
b.innet_month,
b.innet_date,
b.channel_no_desc,
b.user_dinner_desc,
b.terminal_model,
b.user_status_desc
 from dw_v_user_base_info_user b
where acct_month='201706'
and is_onnet='��'
and tele_type='2'
and area_no='188'
)b
on a.device_number=b.device_number
join 
tmp_majh_qizha_hz_01_pre c
on a.device_number=c.device_number

select * from tmp_majh_qizha_out
select count(*) from tmp_majh_qizha_out_187
 
 
--������
insert into tmp_majh_qizha_model
SELECT
    b.area_no ,
    b.area_no_desc ,
    b.city_no,
    b.city_no_desc ,
    b.channel_no ,
    b.channel_no_desc ,
    COUNT(*)
FROM
    tmp_majh_qizha_out a JOIN(
        SELECT
            b.device_number ,
            b.is_ocs ,
            b.area_no ,
            b.area_no_desc ,
            b.city_no,
            b.city_no_desc ,
            b.channel_no ,
            b.channel_no_desc ,
            b.customer_name ,
            b.innet_month ,
            b.innet_date , 
            b.user_dinner_desc ,
            b.terminal_model ,
            b.user_status_desc
        FROM
            dw_v_user_base_info_user b
        WHERE
            acct_month = '201706'
            AND is_onnet = '��'
            AND tele_type = '2'
            AND area_no = '188'
    ) b
        ON a.device_number = b.device_number JOIN tmp_majh_qizha_hz_01_pre c
        ON a.device_number = c.device_number
GROUP BY
    b.area_no ,
    b.area_no_desc ,
    b.city_no,
    b.city_no_desc ,
    b.channel_no ,
    b.channel_no_desc;
    
    
    select * from tmp_majh_qizha_model
    
    
    
    
    
    
    
    
    
    
    
    