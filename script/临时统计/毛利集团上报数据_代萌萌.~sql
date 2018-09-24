select * from dim.dim_channel_type a  where a.channel_type_desc like '%独立%';

select * from dim.dim_channel_type a  where a.CHANNEL_TYPE IN ('110101', '110102', '110103')

DECLARE
  V_MONTH VARCHAR2(100);
BEGIN
  FOR V_NUM IN 201701 .. 201706 LOOP
    V_MONTH := TO_CHAR(V_NUM);
    INSERT INTO XXHB_MJH.TMP_MAJH_MAOLI_0723_01
      SELECT ACCT_MONTH,
             CHANNEL_TYPE,
             TELE_TYPE,
             TELE_TYPE_NEW,
             IS_NEW,
             IS_KD_BUNDLE,
             CASE
               WHEN IS_ACCT = '1' OR IS_ACCT_OCS = '1' THEN
                '1'
               ELSE
                '0'
             END IS_ACCT,
             SUM(PRICE_FEE + PRICE_FEE_OCS) AS PRICE_FEE,
             SUM(OWE_FEE) OWE_FEE,
             count(*)cnt_user
        FROM DW.DW_V_USER_BASE_INFO_USER A
       WHERE ACCT_MONTH = V_MONTH
         AND IS_ONNET = '1'
       GROUP BY ACCT_MONTH,
                CHANNEL_TYPE,
                TELE_TYPE,
                TELE_TYPE_NEW,
                IS_NEW,
                IS_KD_BUNDLE,
                CASE
                  WHEN IS_ACCT = '1' OR IS_ACCT_OCS = '1' THEN
                   '1'
                  ELSE
                   '0'
                END;
    COMMIT;
  END LOOP;
END;


--连锁店
select 
'连锁店',
--发展
sum(case when is_new='1' and t.is_kd_bundle='0' and tele_type='2' then cnt_user else 0 end) cnt_user,
sum(case when is_new='1' and t.is_kd_bundle='0' and t.tele_type_new='G010' then cnt_user else 0 end) cnt_user,
sum(case when is_new='1' and t.is_kd_bundle='0' and t.tele_type_new='G110' then cnt_user else 0 end) cnt_user,
sum(case when is_new='1' and t.is_kd_bundle<>'0' then cnt_user else 0 end) cnt_user,
--出账
sum(case when is_acct='1' and t.acct_month='201806' and t.is_kd_bundle='0' and tele_type='2' then cnt_user else 0 end) cnt_user,
sum(case when is_acct='1' and t.acct_month='201806' and t.is_kd_bundle='0' and t.tele_type_new='G010' then cnt_user else 0 end) cnt_user,
sum(case when is_acct='1' and t.acct_month='201806' and t.is_kd_bundle='0' and t.tele_type_new='G110' then cnt_user else 0 end) cnt_user,
sum(case when is_acct='1' and t.acct_month='201806' and t.is_kd_bundle<>'0' then t.cnt_user else 0 end) cnt_user,
--收入
sum(case when t.is_kd_bundle='0' and tele_type='2' then t.price_fee else 0 end) cnt_user,
sum(case when  t.is_kd_bundle='0' and t.tele_type_new='G010' then t.price_fee else 0 end) cnt_user,
sum(case when  t.is_kd_bundle='0' and t.tele_type_new='G110' then t.price_fee else 0 end) cnt_user,
sum(case when  t.is_kd_bundle<>'0' then t.price_fee else 0 end) price_fee,
--欠费
sum(case when  t.is_kd_bundle='0' and tele_type='2'  and t.acct_month='201806' then t.owe_fee else 0 end) cnt_user,
sum(case when  t.is_kd_bundle='0' and t.tele_type_new='G010'  and t.acct_month='201806' then t.owe_fee else 0 end) cnt_user,
sum(case when  t.is_kd_bundle='0' and t.tele_type_new='G110'  and t.acct_month='201806' then t.owe_fee else 0 end) cnt_user,
sum(case when  t.is_kd_bundle<>'0'  and t.acct_month='201806' then t.owe_fee else 0 end) owe_fee
 from xxhb_mjh.tmp_majh_maoli_0723_01 t where t.channel_type in
 ('110301','110302','110303','110304')
union all
--自营厅
select 
'自营厅',
--发展
sum(case when is_new='1' and t.is_kd_bundle='0' and tele_type='2' then cnt_user else 0 end) cnt_user,
sum(case when is_new='1' and t.is_kd_bundle='0' and t.tele_type_new='G010' then cnt_user else 0 end) cnt_user,
sum(case when is_new='1' and t.is_kd_bundle='0' and t.tele_type_new='G110' then cnt_user else 0 end) cnt_user,
sum(case when is_new='1' and t.is_kd_bundle<>'0' then cnt_user else 0 end) cnt_user,
--出账
sum(case when is_acct='1' and t.acct_month='201806' and t.is_kd_bundle='0' and tele_type='2' then cnt_user else 0 end) cnt_user,
sum(case when is_acct='1' and t.acct_month='201806' and t.is_kd_bundle='0' and t.tele_type_new='G010' then cnt_user else 0 end) cnt_user,
sum(case when is_acct='1' and t.acct_month='201806' and t.is_kd_bundle='0' and t.tele_type_new='G110' then cnt_user else 0 end) cnt_user,
sum(case when is_acct='1' and t.acct_month='201806' and t.is_kd_bundle<>'0' then t.cnt_user else 0 end) cnt_user,
--收入
sum(case when t.is_kd_bundle='0' and tele_type='2' then t.price_fee else 0 end) cnt_user,
sum(case when  t.is_kd_bundle='0' and t.tele_type_new='G010' then t.price_fee else 0 end) cnt_user,
sum(case when  t.is_kd_bundle='0' and t.tele_type_new='G110' then t.price_fee else 0 end) cnt_user,
sum(case when  t.is_kd_bundle<>'0' then t.price_fee else 0 end) price_fee,
--欠费
sum(case when t.is_kd_bundle='0' and tele_type='2'  and t.acct_month='201806' then t.owe_fee else 0 end) cnt_user,
sum(case when  t.is_kd_bundle='0' and t.tele_type_new='G010'  and t.acct_month='201806' then t.owe_fee else 0 end) cnt_user,
sum(case when  t.is_kd_bundle='0' and t.tele_type_new='G110'  and t.acct_month='201806' then t.owe_fee else 0 end) cnt_user,
sum(case when  t.is_kd_bundle<>'0'  and t.acct_month='201806' then t.owe_fee else 0 end) owe_fee
 from xxhb_mjh.tmp_majh_maoli_0723_01 t where t.channel_type in
 ('110101','110102','110103')
union all
--专营店
select 
'专营店',
--发展
sum(case when is_new='1' and t.is_kd_bundle='0' and tele_type='2' then cnt_user else 0 end) cnt_user,
sum(case when is_new='1' and t.is_kd_bundle='0' and t.tele_type_new='G010' then cnt_user else 0 end) cnt_user,
sum(case when is_new='1' and t.is_kd_bundle='0' and t.tele_type_new='G110' then cnt_user else 0 end) cnt_user,
sum(case when is_new='1' and t.is_kd_bundle<>'0' then cnt_user else 0 end) cnt_user,
--出账
sum(case when is_acct='1' and t.acct_month='201806' and t.is_kd_bundle='0' and tele_type='2' then cnt_user else 0 end) cnt_user,
sum(case when is_acct='1' and t.acct_month='201806' and t.is_kd_bundle='0' and t.tele_type_new='G010' then cnt_user else 0 end) cnt_user,
sum(case when is_acct='1' and t.acct_month='201806' and t.is_kd_bundle='0' and t.tele_type_new='G110' then cnt_user else 0 end) cnt_user,
sum(case when is_acct='1' and t.acct_month='201806' and t.is_kd_bundle<>'0' then t.cnt_user else 0 end) cnt_user,
--收入
sum(case when t.is_kd_bundle='0' and tele_type='2' then t.price_fee else 0 end) cnt_user,
sum(case when  t.is_kd_bundle='0' and t.tele_type_new='G010' then t.price_fee else 0 end) cnt_user,
sum(case when  t.is_kd_bundle='0' and t.tele_type_new='G110' then t.price_fee else 0 end) cnt_user,
sum(case when  t.is_kd_bundle<>'0' then t.price_fee else 0 end) price_fee,
--欠费
sum(case when t.is_kd_bundle='0' and tele_type='2'  and t.acct_month='201806' then t.owe_fee else 0 end) cnt_user,
sum(case when  t.is_kd_bundle='0' and t.tele_type_new='G010'  and t.acct_month='201806' then t.owe_fee else 0 end) cnt_user,
sum(case when  t.is_kd_bundle='0' and t.tele_type_new='G110'  and t.acct_month='201806' then t.owe_fee else 0 end) cnt_user,
sum(case when  t.is_kd_bundle<>'0'  and t.acct_month='201806' then t.owe_fee else 0 end) owe_fee
 from xxhb_mjh.tmp_majh_maoli_0723_01 t where t.channel_type in
 ('110201')
union all
--独立店
select 
'独立店',
--发展
sum(case when is_new='1' and t.is_kd_bundle='0' and tele_type='2' then cnt_user else 0 end) cnt_user,
sum(case when is_new='1' and t.is_kd_bundle='0' and t.tele_type_new='G010' then cnt_user else 0 end) cnt_user,
sum(case when is_new='1' and t.is_kd_bundle='0' and t.tele_type_new='G110' then cnt_user else 0 end) cnt_user,
sum(case when is_new='1' and t.is_kd_bundle<>'0' then cnt_user else 0 end) cnt_user,
--出账
sum(case when is_acct='1' and t.acct_month='201806' and t.is_kd_bundle='0' and tele_type='2' then cnt_user else 0 end) cnt_user,
sum(case when is_acct='1' and t.acct_month='201806' and t.is_kd_bundle='0' and t.tele_type_new='G010' then cnt_user else 0 end) cnt_user,
sum(case when is_acct='1' and t.acct_month='201806' and t.is_kd_bundle='0' and t.tele_type_new='G110' then cnt_user else 0 end) cnt_user,
sum(case when is_acct='1' and t.acct_month='201806' and t.is_kd_bundle<>'0' then t.cnt_user else 0 end) cnt_user,
--收入
sum(case when t.is_kd_bundle='0' and tele_type='2' then t.price_fee else 0 end) cnt_user,
sum(case when  t.is_kd_bundle='0' and t.tele_type_new='G010' then t.price_fee else 0 end) cnt_user,
sum(case when  t.is_kd_bundle='0' and t.tele_type_new='G110' then t.price_fee else 0 end) cnt_user,
sum(case when  t.is_kd_bundle<>'0' then t.price_fee else 0 end) price_fee,
--欠费
sum(case when t.is_kd_bundle='0' and tele_type='2'  and t.acct_month='201806' then t.owe_fee else 0 end) cnt_user,
sum(case when  t.is_kd_bundle='0' and t.tele_type_new='G010'  and t.acct_month='201806' then t.owe_fee else 0 end) cnt_user,
sum(case when  t.is_kd_bundle='0' and t.tele_type_new='G110'  and t.acct_month='201806' then t.owe_fee else 0 end) cnt_user,
sum(case when  t.is_kd_bundle<>'0'  and t.acct_month='201806' then t.owe_fee else 0 end) owe_fee
 from xxhb_mjh.tmp_majh_maoli_0723_01 t where t.channel_type in
 ('110401')
 union all
--其他
select 
'其他',
--发展
sum(case when is_new='1' and t.is_kd_bundle='0' and tele_type='2' then cnt_user else 0 end) cnt_user,
sum(case when is_new='1' and t.is_kd_bundle='0' and t.tele_type_new='G010' then cnt_user else 0 end) cnt_user,
sum(case when is_new='1' and t.is_kd_bundle='0' and t.tele_type_new='G110' then cnt_user else 0 end) cnt_user,
sum(case when is_new='1' and t.is_kd_bundle<>'0' then cnt_user else 0 end) cnt_user,
--出账
sum(case when is_acct='1' and t.acct_month='201806' and t.is_kd_bundle='0' and tele_type='2' then cnt_user else 0 end) cnt_user,
sum(case when is_acct='1' and t.acct_month='201806' and t.is_kd_bundle='0' and t.tele_type_new='G010' then cnt_user else 0 end) cnt_user,
sum(case when is_acct='1' and t.acct_month='201806' and t.is_kd_bundle='0' and t.tele_type_new='G110' then cnt_user else 0 end) cnt_user,
sum(case when is_acct='1' and t.acct_month='201806' and t.is_kd_bundle<>'0' then t.cnt_user else 0 end) cnt_user,
--收入
sum(case when t.is_kd_bundle='0' and tele_type='2' then t.price_fee else 0 end) cnt_user,
sum(case when  t.is_kd_bundle='0' and t.tele_type_new='G010' then t.price_fee else 0 end) cnt_user,
sum(case when  t.is_kd_bundle='0' and t.tele_type_new='G110' then t.price_fee else 0 end) cnt_user,
sum(case when  t.is_kd_bundle<>'0' then t.price_fee else 0 end) price_fee,
--欠费
sum(case when t.is_kd_bundle='0' and tele_type='2'  and t.acct_month='201806' then t.owe_fee else 0 end) cnt_user,
sum(case when  t.is_kd_bundle='0' and t.tele_type_new='G010'  and t.acct_month='201806' then t.owe_fee else 0 end) cnt_user,
sum(case when  t.is_kd_bundle='0' and t.tele_type_new='G110'  and t.acct_month='201806' then t.owe_fee else 0 end) cnt_user,
sum(case when  t.is_kd_bundle<>'0' and t.acct_month='201806' then t.owe_fee else 0 end) owe_fee
 from xxhb_mjh.tmp_majh_maoli_0723_01 t where t.channel_type not in
 ('110401','110201','110101','110102','110103','110301','110302','110303','110304');
 
