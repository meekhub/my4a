--�м��
create table mid_station_info_new as
SELECT *
  FROM (SELECT T.*,
               ROW_NUMBER() OVER(PARTITION BY T.DIANBIAO_NO ORDER BY DECODE(T.DIANBIAO_STATE, '����', 1, 0) DESC) RN
          FROM DF_STATION_INFO_NEW T)
 WHERE RN = 1;


create table mid_station_info as
SELECT * FROM 
(SELECT T.*,
               ROW_NUMBER() OVER(PARTITION BY T.DIANBIAO_NO ORDER BY DECODE(T.DIANBIAO_STATE, '����', 1, 0) DESC) RN
          FROM DF_STATION_INFO T) WHERE RN=1;
          

--ռ��վ����
create table mid_df_elect_rate_01 as 
SELECT A.DUIXIANG_NO, SUM(A.BAOZHANG_FEE) BAOZHANG_FEE
  FROM DF_BILL_INFO A
 WHERE A.BAOZHANG_DATE IN ('2018-08', '2018-07', '2018-06')
 GROUP BY DUIXIANG_NO;
 
create table mid_df_elect_rate_02 as 
SELECT A.SHITI_NO, SUM(A.BAOZHANG_FEE) BAOZHANG_FEE
  FROM DF_BILL_INFO A
 WHERE A.BAOZHANG_DATE IN ('2018-08', '2018-07', '2018-06')
 GROUP BY SHITI_NO;

create table mid_df_elect_rate_03 as 
SELECT DUIXIANG_NO, SHITI_NO
  FROM (SELECT A.DUIXIANG_NO,
               A.SHITI_NO,
               ROW_NUMBER() OVER(PARTITION BY A.DUIXIANG_NO ORDER BY BAOZHANG_DATE DESC) RN
          FROM DF_BILL_INFO A
         WHERE A.BAOZHANG_DATE IN ('2018-05', '2018-04', '2018-03', '2018-08', '2018-07', '2018-06'))
 WHERE RN = 1;
 
 create table mid_df_elect_rate_04 as 
 SELECT A.DUIXIANG_NO, A.BAOZHANG_FEE / C.BAOZHANG_FEE AS BAOZHANG_RATE
   FROM MID_DF_ELECT_RATE_01 A,
        MID_DF_ELECT_RATE_03 B,
        MID_DF_ELECT_RATE_02 C
  WHERE A.DUIXIANG_NO = B.DUIXIANG_NO
    AND B.SHITI_NO = C.SHITI_NO
    and A.BAOZHANG_FEE / C.BAOZHANG_FEE >0.3
 
 
--�����쳣
update mid_station_info_new set ht_price=substr(ht_price,2) where ht_price like '.%'

select t.*, t.rowid from mid_station_info_new t where t.ht_price=' '

--��վ��Ϣ
--delete from BWT_BUR_STAND_INFO_M where acct_month='201808'
INSERT INTO BWT_BUR_STAND_INFO_M
  SELECT '201808' ACCT_MONTH, -- ����
         X.STD_LATN_CD,
         NVL(T.SHITI_NO, '-1'), --��վ����
         NVL(REPLACE(T.SHITI_NAME, '	', ''), '����'), --��վ����
         CASE
           WHEN T.SHITI_TYPE LIKE '%ͨ�Ż���%' THEN
            '10001'
           WHEN T.SHITI_TYPE LIKE '%�ƶ���վ%' THEN
            '10002'
           WHEN T.SHITI_TYPE LIKE '%����IDC�������%' THEN
            '10003'
           WHEN T.SHITI_TYPE LIKE '%����ҵ��ƽ̨%' THEN
            '10004'
           WHEN T.SHITI_TYPE LIKE '%����������������%' THEN
            '10005'
           WHEN T.SHITI_TYPE LIKE '%�����÷�%' THEN
            '20001'
           WHEN T.SHITI_TYPE LIKE '%�����÷�%' THEN
            '20002'
           WHEN T.SHITI_TYPE LIKE '%�����÷�-����%' THEN
            '-1'
           ELSE
            '-2'
         END, --��վ����
         CASE
           WHEN T.SUOYOUQUAN = '����' THEN
            '10'
           ELSE
            '30'
         END, --��վ��Ȩ����
         CASE
           WHEN T.IS_KONGTIAO = '��' THEN
            '1'
           ELSE
            '0'
         END, -- �Ƿ��пյ�
         CASE
           WHEN T.SHITI_TYPE LIKE '%�����÷�%' OR T.SHITI_TYPE LIKE '%�����÷�%' OR
                T.SHITI_TYPE LIKE '%�����÷�-����%' THEN
            '-1'
           WHEN T.SHITI_LEVEL LIKE 'A%' THEN
            'A'
           WHEN T.SHITI_LEVEL LIKE 'B%' THEN
            'B'
           WHEN T.SHITI_LEVEL LIKE 'C%' THEN
            'C'
           WHEN T.SHITI_LEVEL LIKE 'D%' THEN
            'D'
           ELSE
            'C'
         END, --��վ�ȼ�
         CASE
           WHEN T.SHITI_STATE = '����' THEN
            '1'
           ELSE
            '0'
         END, --��վ״̬
         '0' IS_IDSTL_ELEC_APPLY,
         '0' IS_APPLY_IDSTL_ELEC,
         '0' IS_IDSTL_ELEC,
         '0' IS_POWER_DIRECT_TRANSACTION,
         0 IDSTL_ELEC_TOP_PRICE,
         0 IDSTL_ELEC_NORMAL_PRICE,
         0 IDSTL_ELEC_BOTTOM_PRICE,
         0 GENE_OTHER_BUSI_ELEC_PRICE,
         0 TRANSFORMER_CD,
         0 TRANSFORMER_CAPACITY,
         '0' POWER_ELEMENT,
         X.AREA_NO
    FROM (SELECT *
            FROM (SELECT A.*,
                         ROW_NUMBER() OVER(PARTITION BY A.SHITI_NO ORDER BY 1) RN1
                    FROM MID_STATION_INFO_NEW A)
           WHERE RN1 = 1) T,
         DIM.DIM_AREA_NO_JT X
   WHERE RN = 1
     AND T.AREA_NAME = X.AREA_DESC;
     
--��վ���� in��20001��20002��-1��-2����-1
update  ALLDM.BWT_BUR_STAND_INFO_M T set BUR_STAND_LEVEL='-1'
 WHERE T.ACCT_MONTH = '201808'
   AND T.BUR_STAND_TYPE IN�� '20001', '20002', '-1', '-2' �� 


--�����Ϣ
--delete from BWT_ELECTRIC_METER_INFO_M where acct_month='201808'
INSERT INTO BWT_ELECTRIC_METER_INFO_M
  SELECT '201808' ACCT_MONTH, -- ����
         X.STD_LATN_CD,
         CASE
           WHEN T.GONGDIAN_METHOD LIKE 'ת��' THEN
            '-1'
           WHEN LENGTH(T.DIANBIAO_HUHAO) = 10 THEN
            T.DIANBIAO_HUHAO
           ELSE
            '-1'
         END, -- ����ֱ���
         NVL(T.DIANBIAO_NO, '-1'), --�����
         '1' ELECTRIC_METER_KD, -- �������
         NVL(NVL(T.CHENGBEN_NO, M.CHENGBEN_NO), '-1'), -- �ɱ�����
         NVL(T.SHITI_NO, '-1'), -- ��վ����
         case when T.BEILV='0.0' then '1' else NVL(T.BEILV, '1') end, -- �����
         CASE
           WHEN T.IS_HETONG = '��' AND
                SUBSTR(TRIM(REPLACE(T.HETONG_NO, '"', '')), 1, 17) IS NOT NULL THEN
            '1'
           ELSE
            '0'
         END, --�Ƿ��к�ͬ
         SUBSTR(TRIM(REPLACE(T.HETONG_NO, '"', '')), 1, 17), -- ��ͬ��
         '', -- ��ͬ����
         '2', --�ɷѷ�ʽ
         FUNC_PAY_COST_CYCLE(T.JIAOFEI_ZHOUQI), -- �ɷ�����
         CASE
           WHEN T.DIANBIAO_YONGTU LIKE '%�ۺϵ��%' THEN
            '1'
           WHEN T.DIANBIAO_YONGTU LIKE '%�������%' THEN
            '2'
           WHEN T.DIANBIAO_YONGTU LIKE '%���������%' THEN
            '3'
           ELSE
            '1'
         END, -- �����;����
         CASE
           WHEN T.GONGDIAN_METHOD LIKE 'ֱ��' THEN
            '1'
           WHEN T.GONGDIAN_METHOD LIKE 'ת��' THEN
            '2'
           WHEN T.GONGDIAN_METHOD LIKE '����' THEN
            '3'
           ELSE
            '2'
         END, --���緽ʽ
         CASE
           WHEN TRIM(T.DIANBIAO_STATE) = '����' THEN
            '1000'
           ELSE
            '1200'
         END, -- ���״̬
         '1', -- �Ƿ��ֽ�֧��
         CASE
           WHEN T.DIANBIAO_YONGTU LIKE '%�������%' THEN
            '100%'
           ELSE
            '0%'
         END, --����ռ��
         CASE
           WHEN T.GONGYINGSHANG_NO LIKE 'G%' THEN
            SUBSTR(T.GONGYINGSHANG_NO, 1, 9)
           ELSE
            'G00000000'
         END, --��Ӧ�̱���
         CASE
           WHEN T.GONGYINGSHANG_NO LIKE 'G%' THEN
            SUBSTR(T.GONGYINGSHANG_NO, 1, 4)
           ELSE
            'G000'
         END, -- ��Ӧ����
         T.GONGYINGSHANG, -- ��Ӧ��
         CASE
           WHEN Z.BAOZHANG_RATE > 1 THEN
            '100%'
           ELSE
            ROUND(NVL(Z.BAOZHANG_RATE * 100, 100), 2) || '%'
         END, --ռ��վ����
         CASE
           WHEN TRIM(TRANSLATE(T.LILUN_AMOUNT_NEW, '.0123456789', ' ')) IS NULL THEN
            LILUN_AMOUNT_NEW * 31
           ELSE
            0
         END,
         X.AREA_NO
    FROM (SELECT A.*,
                 REPLACE(NVL(TRIM(A.LILUN_AMOUNT), '0'), ',', '.') AS LILUN_AMOUNT_NEW,
                 B.DIANBIAO_YONGTU,
                 B.IS_DIANFU,
                 B.HETONG_NO,
                 B.IS_HETONG,
                 B.IS_GUANLI,
                 B.CHENGBEN_NO
            FROM MID_STATION_INFO_NEW A, MID_STATION_INFO B
           WHERE A.DIANBIAO_NO = B.DIANBIAO_NO(+)) T,
         MID_DF_ELECT_RATE_04 Z,
         MID_DB_CHENGBEN_REL M,
         DIM.DIM_AREA_NO_JT X
   WHERE T.DIANBIAO_NO = Z.DUIXIANG_NO(+)
     AND T.DIANBIAO_NO = M.DUIXIANG_NO(+)
     AND T.AREA_NAME = X.AREA_DESC;


/*--�������Ϣ
--delete from BWT_ELEC_METER_INFO_M where acct_month='201808'
 insert into BWT_ELEC_METER_INFO_M
 SELECT '201808' ACCT_MONTH, -- ����
        z.std_latn_cd,
        x.city_no, --����
        X.DIANBIAO_NO, -- ������
        replace(T.BEGIN_DATE,'-',''), -- ����ʼʱ��
        replace(T.END_DATE,'-',''), --�������ʱ��
        T.LAST_DUSHU, -- �ϴζ���
        T.CUR_DUSHU, -- ���ζ���
        T.AMOUNT, -- �����õ���
        '��', --�Ƿ��ת
        case when x.DIANBIAO_MAX like '%����%' then '' else x.dianbiao_max end,
        z.area_no
   FROM 
   (SELECT T.*,
               ROW_NUMBER() OVER(PARTITION BY t.DUIXIANG_NO ORDER BY duixiang_name DESC) RN
          FROM DF_BILL_INFO T)T, 
   (SELECT T.*,
               ROW_NUMBER() OVER(PARTITION BY t.dianbiao_no ORDER BY t.dianbiao_name DESC) RN
          FROM DF_STATION_INFO T) X,
    dim.dim_area_no_jt z
  WHERE T.DUIXIANG_NO = X.dianbiao_no
  and t.area_name=z.area_desc
  and t.rn=1
  and x.rn=1*/

--����ÿ����ƽ��ÿ��
 CREATE TABLE XXHB_MJH.TMP_MAJH_DB AS 
 SELECT DUIXIANG_NO,
               round(SUM(BAOZHANG_FEE) / SUM(BZ_CNT)) * 31 AS BAOZHANG_FEE
          FROM (SELECT DUIXIANG_NO,
                       (TO_NUMBER(BAOZHANG_FEE)-TO_NUMBER(TAX_FEE)) AS BAOZHANG_FEE,
                       ABS(TO_DATE(END_DATE, 'YYYY-MM-DD') -
                           TO_DATE(BEGIN_DATE, 'YYYY-MM-DD')) + 1 BZ_CNT
                  FROM df_bill_info t where t.baozhang_date in ('2018-05','2018-04','2018-03','2018-08','2018-07','2018-06'))
         GROUP BY DUIXIANG_NO;

         

--���˻�����Ϣ��
delete from BWT_REIM_BASIC_DATA_INFO_M where  acct_month='201808'
INSERT INTO BWT_REIM_BASIC_DATA_INFO_M
  SELECT '201808' ACCT_MONTH, -- ����
         A.LATN_ID,
         '201808' ELEC_FEE_MONTH_START, -- ����ʼʱ��
         '201808' ELEC_FEE_MONTH_END, --�������ʱ��
         A.ELECTRIC_METER_ID, --�����
         A.COSTCENTER, -- �ɱ�����
         C.BAOZHANG_NO, --���˵���
         --to_char(to_date(ACCOUNT_DATE,'yyyy-mm'),'yyyymmddHH24MISS')
         CASE
           WHEN C.BAOZHANG_NO IS NOT NULL THEN
            to_char(to_date(C.BAOZHANG_DATE,'yyyy-mm'),'yyyymmddHH24MISS')
           ELSE
            to_char(to_date(A.ACCT_MONTH,'yyyy-mm'),'yyyymmddHH24MISS')
         END, --��������
         '0', --�˲�����
         '0', --�˲����
         X.HT_PRICE_NEW, --��ͬ����
         DECODE(X.HT_PRICE_NEW,
                0,
                B.BAOZHANG_FEE,
                B.BAOZHANG_FEE / X.HT_PRICE_NEW), --�ܵ���(��)
         B.BAOZHANG_FEE, --���˽��
         CASE
           WHEN C.PIAOJU_TYPE LIKE '%��ֵ˰ר�÷�Ʊ%' THEN
            B.BAOZHANG_FEE * TO_NUMBER(NVL(X.SHUILV,'0'))
           ELSE
            0
         END TAX_FEE, --���˰��
         0,
         Y.AREA_NO
    FROM (SELECT *
            FROM BWT_ELECTRIC_METER_INFO_M
           WHERE ACCT_MONTH = '201808') A,
         XXHB_MJH.TMP_MAJH_DB B,
         (SELECT *
            FROM (SELECT C.*,
                         C.TAX_FEE / C.BAOZHANG_FEE AS TAX_RATE,
                         ROW_NUMBER() OVER(PARTITION BY C.DUIXIANG_NO ORDER BY C.BAOZHANG_DATE, C.BEGIN_DATE DESC) RN
                    FROM DF_BILL_INFO C)
           WHERE RN = 1) C,
         (SELECT A.*,
                 B.CHENGBEN_NO,
                 CASE
                   WHEN TRIM(TRANSLATE(NVL(REPLACE(A.HT_PRICE, ' ', ''),
                                           '0.68'),
                                       '.0123456789',
                                       ' ')) IS NULL THEN
                    TO_NUMBER(NVL(A.HT_PRICE, 0.68))
                   ELSE
                    1
                 END HT_PRICE_NEW
            FROM MID_STATION_INFO_NEW A, MID_STATION_INFO B
           WHERE A.DIANBIAO_NO = B.DIANBIAO_NO(+)) X,
         DIM.DIM_AREA_NO_JT Y
   WHERE A.ELECTRIC_METER_ID = B.DUIXIANG_NO
     AND A.ELECTRIC_METER_ID = C.DUIXIANG_NO
     AND A.ELECTRIC_METER_ID = X.DIANBIAO_NO
     AND A.LATN_ID = Y.STD_LATN_CD;

--�޳��ܵ������ܵ�Ѷ�Ϊ0�ļ�¼
delete from BWT_REIM_BASIC_DATA_INFO_M a where acct_month='201808' and TOTAL_ELECTRICITY+ELEC_CHARGE_PRICE=0

--�����ͬ����Ϊ0��
update BWT_REIM_BASIC_DATA_INFO_M set CONTRACT_ELEC_PRICE=round(ELEC_CHARGE_PRICE/TOTAL_ELECTRICITY,2)
where acct_month in ('201808') and CONTRACT_ELEC_PRICE=0


--��֤����
SELECT SUM(TOTAL_ELECTRICITY), SUM(T.ELEC_CHARGE_PRICE)
  FROM BWT_REIM_BASIC_DATA_INFO_M T
 WHERE T.ACCT_MONTH = '201808'
 

------��ƫ-------

--8��
update BWT_REIM_BASIC_DATA_INFO_M
   set ELEC_CHARGE_PRICE = round(ELEC_CHARGE_PRICE * 1.5835, 2)
       --TOTAL_ELECTRICITY = round(TOTAL_ELECTRICITY * 1.4275, 2)
 where acct_month = '201808';
 
update  BWT_REIM_BASIC_DATA_INFO_M set ELEC_CHARGE_PRICE=ELEC_CHARGE_PRICE+1215.34
where acct_month='201808' and ELECTRIC_METER_ID ='DB130101008542'



/*--IDC����һ
insert into BWT_IDC_ENERGY_CONSUM1_M
select 
'201808' acct_month,
'813',
x.std_latn_cd,
t.city_no,
t.shiti_no,
nvl(t.cust_no,'-1'),
sum(t.idc_df),
sum(ceil(t.idc_df/0.61)),
sum(t.total_glv),
x.area_no
 from df_idc_info t,dim.dim_area_no_jt x
 where t.area_name=x.area_desc
 group by x.std_latn_cd,t.city_no,t.shiti_no,nvl(t.cust_no,'-1'),x.area_no
 
--IDC������
--delete from  BWT_IDC_ENERGY_CONSUM2_M 
insert into BWT_IDC_ENERGY_CONSUM2_M
select 
'201808' acct_month,
'813',
x.std_latn_cd,
t.city_no,
t.shiti_no,
nvl(t.cust_no,'-1'),
sum(t.idc_df), 
sum(t.ZUYONG_GLV),
sum(t.idc_sr),
x.area_no
 from df_idc_info t,dim.dim_area_no_jt x
 where t.area_name=x.area_desc
 group by x.std_latn_cd,t.city_no,t.shiti_no,nvl(t.cust_no,'-1'),x.area_no*/


--delete from BWT_TREND_ANALYSIS_INFO_M where acct_month='201808'
insert into BWT_TREND_ANALYSIS_INFO_M  
SELECT '201808' ACCT_MONTH,
       '813',
       C.STD_LATN_CD,
       B.STATION_ID_B,
       case when SUM(A.ELEC_AMOUNT)<SUM(A.DEVICE_AMOUNT) then SUM(A.DEVICE_AMOUNT) else SUM(A.ELEC_AMOUNT) end,
       case when SUM(A.DEVICE_AMOUNT)=0 then SUM(A.ELEC_AMOUNT)*0.81 else SUM(A.DEVICE_AMOUNT) end,
       C.AREA_NO
  FROM (SELECT A.AREA_NAME,
               replace(A.RELATION_ID,chr(13),'')RELATION_ID,
               SUM(ELEC_AMOUNT) ELEC_AMOUNT,
               SUM(DEVICE_AMOUNT) DEVICE_AMOUNT
          FROM ALLDM.ELEC_STATION_D A
         WHERE ACCT_MONTH = '201808'
         GROUP BY A.AREA_NAME, A.RELATION_ID
         having SUM(ELEC_AMOUNT)>0) A,
       (SELECT STATION_ID_A, STATION_ID_B
          FROM (SELECT STATION_ID_A,
                       STATION_ID_B,
                       ROW_NUMBER() OVER(PARTITION BY STATION_ID_A ORDER BY 1) RN
                  FROM DIM.DIM_STATION_REL
                 WHERE STATION_ID_B IS NOT NULL and STATION_ID_B<>'#N/A')
         WHERE RN = 1) B,
       DIM.DIM_AREA_NO_JT C
 WHERE A.RELATION_ID = B.STATION_ID_A
   AND A.AREA_NAME = C.AREA_DESC
group by C.STD_LATN_CD,B.STATION_ID_B,C.AREA_NO;



delete from BWT_TREND_ANALYSIS_INFO_M
 where acct_month = '201808'
   and TOTAL_POWER_CONSUMP / TOTAL_EQUIP_POWER_CONSUMP > 10;
   commit;



















 
















