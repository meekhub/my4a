--沉淀基础指标(后付费)
INSERT INTO TMP_MAJH_QIZHA_02
  SELECT '201705' ACCT_MONTH,
         A.DEVICE_NUMBER,
         nvl(SUM(CASE
               WHEN B.ORG_TRM_ID = '10' THEN
                B.CALL_DURATION
               ELSE
                0
             END),0) ZHU_CALL_DURATION, --主叫通话时长
         nvl(SUM(B.CALL_DURATION),0) CALL_DURATION, --总通话时长
         nvl(COUNT(CASE
                 WHEN B.ORG_TRM_ID = '10' THEN
                  B.OPPOSE_NUMBER
               END),0) ZHU_CALL_CDR, --主叫通话次数
         nvl(COUNT(B.OPPOSE_NUMBER),0) CALL_CDR, --总通话次数
         nvl(COUNT(DISTINCT B.OPPOSE_NUMBER),0) CALL_USERS, --总通话人次
         nvl(COUNT(DISTINCT concat(b.acct_month,b.CALL_DATE)),0) CALL_DAYS, --通话天次
         nvl(COUNT(CASE
                 WHEN B.CALL_DURATION < 15 THEN
                  B.OPPOSE_NUMBER
               END),0) LOWER_15_CDR, --15秒内通话次数
         nvl(COUNT(CASE
                 WHEN B.CALL_DURATION < 60 THEN
                  B.OPPOSE_NUMBER
               END),0) LOWER_60_CDR, --60秒内通话次数
         nvl(SUM(CASE
               WHEN B.ROAM_TYPE <> '10' AND B.ORG_TRM_ID = '10' THEN
                B.CALL_DURATION
               ELSE
                0
             END),0) ROAM_DURATION, --漫游通话时长
         nvl(SUM(CASE
               WHEN B.LONG_TYPE <> '10' AND B.ORG_TRM_ID = '10' THEN
                B.CALL_DURATION
               ELSE
                0
             END),0) LONG_DURATION --长途通话时长
    FROM (SELECT * FROM TMP_MAJH_QIZHA_01 WHERE IS_OCS = '0') A
    LEFT JOIN (SELECT *
                 FROM DW_V_USER_CDR_CDMA B
                WHERE ACCT_MONTH in ('201702','201703','201704','201705')
                  AND B.AREA_NO = '188') B
      ON A.DEVICE_NUMBER = B.DEVICE_NUMBER
   GROUP BY a.DEVICE_NUMBER
   
   
   
   
   --沉淀基础指标(预付费)
INSERT INTO TMP_MAJH_QIZHA_02
  SELECT '201705' ACCT_MONTH,
         A.DEVICE_NUMBER,
         nvl(SUM(CASE
               WHEN B.ORG_TRM_ID = '10' THEN
                B.CALL_DURATION
               ELSE
                0
             END),0) ZHU_CALL_DURATION, --主叫通话时长
         nvl(SUM(B.CALL_DURATION),0) CALL_DURATION, --总通话时长
         nvl(COUNT(CASE
                 WHEN B.ORG_TRM_ID = '10' THEN
                  B.OPPOSE_NUMBER
               END),0) ZHU_CALL_CDR, --主叫通话次数
         nvl(COUNT(B.OPPOSE_NUMBER),0) CALL_CDR, --总通话次数
         nvl(COUNT(DISTINCT B.OPPOSE_NUMBER),0) CALL_USERS, --总通话人次
         nvl(COUNT(DISTINCT concat(b.acct_month,b.CALL_DATE)),0) CALL_DAYS, --通话天次
         nvl(COUNT(CASE
                 WHEN B.CALL_DURATION < 15 THEN
                  B.OPPOSE_NUMBER
               END),0) LOWER_15_CDR, --15秒内通话次数
         nvl(COUNT(CASE
                 WHEN B.CALL_DURATION < 60 THEN
                  B.OPPOSE_NUMBER
               END),0) LOWER_60_CDR, --60秒内通话次数
         nvl(SUM(CASE
               WHEN B.ROAM_TYPE <> '10' AND B.ORG_TRM_ID = '10' THEN
                B.CALL_DURATION
               ELSE
                0
             END),0) ROAM_DURATION, --漫游通话时长
         nvl(SUM(CASE
               WHEN B.LONG_TYPE <> '10' AND B.ORG_TRM_ID = '10' THEN
                B.CALL_DURATION
               ELSE
                0
             END),0) LONG_DURATION --长途通话时长
    FROM (SELECT * FROM TMP_MAJH_QIZHA_01 WHERE IS_OCS = '1') A
    LEFT JOIN (SELECT *
                 FROM DW_V_USER_CDR_CDMA_OCS B
                WHERE ACCT_MONTH in ('201702','201703','201704','201705')
                  AND B.AREA_NO = '188') B
      ON A.DEVICE_NUMBER = B.DEVICE_NUMBER
   GROUP BY a.DEVICE_NUMBER
   
   
   
   --计算平均值
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
 
 
 --一证多卡
 insert into tmp_qizha_cert_users
select
customer_no
 FROM DW_V_USER_BASE_INFO_USER B 
                 WHERE B.ACCT_MONTH = '201706'
                   AND B.TELE_TYPE = '2'
                   and is_onnet='是' 
 group by customer_no
 having count(*)>= 3
 
 
 --提取宽表信息
insert into TMP_MAJH_QIZHA_04
SELECT x.DEVICE_NUMBER,
       CASE
         WHEN x.CERT_TYPE = '6' THEN
          '1'
         ELSE
          '0'
       END IS_CERT, --是否营业执照入网
       (x.TOTAL_FEE + x.TOTAL_FEE_OCS)TOTAL_FEE, --出账收入
       CASE
         WHEN x.TRANS_ID IS NOT NULL THEN
          '1'
         ELSE
          '0'
       END IS_TRANS, --是否参与赠费缴费
       x.INNET_MONTH, -- 入网时长
       decode(x.IS_OCS,'是','1','0')is_ocs, --是否预付费卡
       x.channel_no, --渠道编码
       x.terminal_corp,--终端厂商 
       x.terminal_model, --终端型号
       x.terminal_code, --终端编码
       x.user_dinner, --套餐
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
			'1406200') then '1' else '0' end is_risk_dinner, --是否高风险套餐
	case when y.customer_no is not null then '1' else '0' end is_cert_1_n --是否一证三卡用户
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
                       nvl(b.TERMINAL_CORP,'未知厂商')TERMINAL_CORP,
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
 
 
 --是否黑名单渠道
select * from  tmp_majh_qizha_black_channel

--是否低终端用户
select * from tmp_majh_qizha_low_terminal


--欺诈用户对端号码
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
 
--欺诈用户清单
select device_number from TMP_MAJH_QIZHA_01

truncate table tmp_majh_qizha_cellmax   
--计算用户在某基站下通话最多
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

--欺诈用户注册过的终端
insert into tmp_majh_qizha_term 
select 
distinct b.terminal_code
 from TMP_MAJH_QIZHA_04 a,
(select device_no,terminal_code from DW_V_USER_TERMINAL_D where acct_day='20170701')b
where a.device_number=b.device_no



--样本集汇总
truncate table tmp_majh_qizha_hz_01

insert into tmp_majh_qizha_hz_01 
select 
a.device_number, --手机号
a.INNET_MONTH, --入网时长
case when d.channel_no is not null then '1' else '0' end is_risk_channel, --是否高风险代理商
nvl(b.call_duration,0) call_duration,--近4个月均通话时长
nvl(b.call_cdr,0) call_cdr, --近4个月均通话次数
nvl(round(b.zhu_call_duration/b.call_duration,4),0)*100 zhu_dur_rate, --主叫通话时长占比 
nvl(round(b.zhu_call_cdr/b.call_cdr,4),0)*100 zhu_cdr_rate, --主叫通话次数占比
nvl(round(b.call_users/b.call_cdr,4),0)*100 zhu_users_rate, --主叫离散度
nvl(round(b.call_duration/b.call_cdr,4),0)*100 zhu_per_dur, --主叫通话时长
nvl(round(b.lower_60_cdr/b.call_cdr,4),0)*100 lower_60_rate, --60秒内通话次数占比
nvl(round(b.lower_15_cdr/b.call_cdr,4),0)*100 lower_15_rate, --15秒内通话次数占比
nvl(round(b.roam_duration/b.zhu_call_duration,4),0)*100 roam_dur_rate, --漫游通话占比
nvl(round(b.long_duration/b.zhu_call_duration,4),0)*100 long_dur_rate, --长途通话占比
nvl(a.total_fee,0)total_fee, --出账收入
nvl(round(b.call_cdr/b.call_days,4),0)*100 call_mon_rate, --月话务分布
nvl(a.is_trans,'0')is_trans,--是否参与赠费缴费
nvl(a.is_ocs,'0')is_ocs, -- 是否预付费
nvl(round(f.cell_rate,4),0)*100 cell_rate, --通话基站集中率
case when g.device_number is not null then '1' else '0' end is_link_risk, --是否和欺诈对端号码联系过
case when h.terminal_code is not null then '1' else '0' end is_reg_risk, -- 是否注册过诈骗用户终端
nvl(a.is_risk_dinner,'0') is_risk_dinner, --是否风险套餐
case when e.terminal_model is not null then '1' else '0' end is_low_terminal, --是否低价值终端
nvl(a.is_cert_1_n,'0') is_cert_1_n --是否一证三卡用户
 from TMP_MAJH_QIZHA_04 a --基础信息表
left join
TMP_MAJH_QIZHA_03 b --近4个月呼叫信息
on a.device_number=b.device_number 
left join
tmp_majh_qizha_black_channel d --黑名单渠道信息
on a.channel_no=d.channel_no
left join
tmp_majh_qizha_low_terminal e --低终端信息
on a.terminal_corp=e.terminal_corp and a.terminal_model=e.terminal_model
left join
tmp_majh_qizha_cellmax f --通话最多的基站
on a.device_number=f.device_number
left join
tmp_majh_qizha_oppose_number g --欺诈用户对端库
on a.device_number=g.device_number
left join
tmp_majh_qizha_term h --诈骗用户使用过的终端
on a.terminal_code=h.terminal_code



select * from tmp_majh_qizha_hz_01 where call_duration>0 and call_cdr>0
   












   