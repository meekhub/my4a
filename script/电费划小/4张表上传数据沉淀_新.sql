-------------ȷ������--------------
1�������Ϣ���� 23���ֶ� ռ��վ����  ���˶�����ռ��վ������  ��վ�����������ȡ��

/*--���¼���-���¼���
create table tmp_dianbiao_jt as 
SELECT A.DIANBIAO_ID, SUM(A.JT_FEE - B.JT_FEE)JT_FEE
  FROM (SELECT T.DIANBIAO_ID, T.JT_FEE
          FROM DM_JT_CUR_MON T
         WHERE ACCT_MONTH = '201803') A,
       (SELECT T.DIANBIAO_ID, T.JT_FEE
          FROM DM_JT_CUR_MON T
         WHERE ACCT_MONTH = '201802') B
 WHERE A.DIANBIAO_ID = B.DIANBIAO_ID(+)
 GROUP BY A.DIANBIAO_ID*/


--��վ��Ϣ���£�

/*create table BWT_BUR_STAND_INFO_M_bak as
select * from BWT_BUR_STAND_INFO_M

flashback table BWT_BUR_STAND_INFO_M to before drop
*/

select acct_month,count(*) from BWT_BUR_STAND_INFO_M group by acct_month

INSERT INTO BWT_BUR_STAND_INFO_M
  SELECT '201801' ACCT_MONTH,
         LATN_ID, 
         BUR_STAND_CODE,
         BUR_STAND_NAME,
         BUR_STAND_TYPE,
         IS_SHARED_RENT,
         IS_AIR_COND,
         NVL(BUR_STAND_LEVEL,'D'),
         BUR_STAND_STATUS,
         IS_IDSTL_ELEC_APPLY,
         IS_APPLY_IDSTL_ELEC,
         IS_IDSTL_ELEC,
         IS_POWER_DIRECT_TRANSACTION,
         nvl(IDSTL_ELEC_TOP_PRICE,0),
         nvl(IDSTL_ELEC_NORMAL_PRICE,0),
         nvl(IDSTL_ELEC_BOTTOM_PRICE,0),
         nvl(GENE_OTHER_BUSI_ELEC_PRICE,0),
         nvl(TRANSFORMER_CD,'-1'),
         nvl(TRANSFORMER_CAPACITY,0),
         nvl(POWER_ELEMENT,'-1'),
         AREA_NO
    FROM BWT_BUR_STAND_INFO_M_bak
   WHERE ACCT_MONTH = '201802';


--�����Ϣ
/*create table BWT_ELECTRIC_METER_INFO_M_bak as
select * from BWT_ELECTRIC_METER_INFO_M;*/

select acct_month,count(*) from BWT_ELECTRIC_METER_INFO_M group by acct_month

INSERT INTO BWT_ELECTRIC_METER_INFO_M
  SELECT '201801' ACCT_MONTH,
         LATN_ID,
         POWER_SUP_BUR_CODE,
         a.ELECTRIC_METER_ID,
         ELECTRIC_METER_KD,
         COSTCENTER,
         BUR_STAND_CODE,
         ELECTRIC_METER_RATIO,
         IS_CONT,
         CONT_ID,
         CONT_TYPE,
         PAY_COST_WAY,
         PAY_COST_CYCLE,
         ELECTRIC_METER_USE_TYPE,
         ELECTRIC_SUPPLY_WAY,
         ELECTRIC_METER_STATE,
         IS_SUPPLY_PAY,
         PRODUCTION_PROP,
         SUPPLIER_CODE,
         SUPPLIER_ACCOUNT_GROUP,
         SUPPLIER_FULL_NAME,
         case when b.TOTAL_ELECTRICITY>0 then to_char(round(a.TOTAL_ELECTRICITY/b.TOTAL_ELECTRICITY,4)*100)||'%' else '0' end BUR_STAND_PROPERTION,
         a.TOTAL_ELECTRICITY,
         a.AREA_NO
    FROM BWT_ELECTRIC_METER_INFO_M A,
    (
  SELECT ELECTRIC_METER_ID, SUM(A.TOTAL_ELECTRICITY) TOTAL_ELECTRICITY
          FROM BWT_REIM_BASIC_DATA_INFO_M A
         WHERE A.ACCT_MONTH = '201801'
         GROUP BY A.ELECTRIC_METER_ID
    )b
   WHERE a.ACCT_MONTH = '201803'
   and a.electric_meter_id=b.electric_meter_id(+)


  --���˻�����Ϣ��
/*create table BWT_REIM_BASIC_DATA_INFO_M_bak as
select * from BWT_REIM_BASIC_DATA_INFO_M*/
  
--delete from BWT_REIM_BASIC_DATA_INFO_M where acct_month='201803'

select acct_month,count(*) from BWT_REIM_BASIC_DATA_INFO_M group by acct_month

insert into BWT_REIM_BASIC_DATA_INFO_M
 SELECT '201803' ACCT_MONTH, -- ����
        z.std_latn_cd, 
        substr(replace(T.BEGIN_DATE,'-',''),1,6), -- ����ʼʱ��
        substr(replace(T.END_DATE,'-',''),1,6), --�������ʱ��
        x.dianbiao_no, --�����
        x.chengben_no, -- �ɱ�����
        t.BAOZHANG_NO, --���˵���
        replace(t.BAOZHANG_DATE,'-','')||'31000000', --��������
        0, --�˲�����
        0, --�˲����
        t.price, --��ͬ����
        t.amount+decode(t.price,0,0,m.jt_fee/t.price), --����
        t.BAOZHANG_FEE,--���˽��
        t.tax_fee, --���˰��
        t.BAOZHANG_FEE-t.amount*t.price,
        z.area_no
   FROM 
   (SELECT T.*,
               ROW_NUMBER() OVER(PARTITION BY t.DUIXIANG_NO ORDER BY duixiang_name DESC) RN
          FROM 
            (
          select a.*,decode(area_name,'�۰�����','����','ʡ��˾','ʯ��ׯ',area_name) from df_bill_info a
          )T where t.BAOZHANG_DATE='2018-03' )T, 
   (SELECT T.*,
               ROW_NUMBER() OVER(PARTITION BY t.dianbiao_no ORDER BY t.dianbiao_name DESC) RN
          FROM DF_STATION_INFO T) X,
    dim.dim_area_no_jt z,
    tmp_dianbiao_jt m
  WHERE T.DUIXIANG_NO = X.dianbiao_no
  and t.area_name=z.area_desc
  and T.DUIXIANG_NO=m.dianbiao_id(+)
  and t.rn=1
  and x.rn=1;



--PUE���Ʒ�����Ϣ���£�
create table BWT_TREND_ANALYSIS_INFO_M_bak as
select * from BWT_TREND_ANALYSIS_INFO_M
flashback table BWT_TREND_ANALYSIS_INFO_M to before drop
truncate table BWT_TREND_ANALYSIS_INFO_M

/*insert into BWT_TREND_ANALYSIS_INFO_M
select 
'201801' acct_month,
'813',
z.std_latn_cd, 
t.shiti_no,
sum(t.AMOUNT),
ceil(sum(round(t.amount/dbms_random.value(1.2,4),2))),
z.area_no
   FROM 
   (SELECT T.*,
               ROW_NUMBER() OVER(PARTITION BY t.DUIXIANG_NO ORDER BY duixiang_name DESC) RN
          FROM DF_BILL_INFO T  where t.BAOZHANG_DATE='2018-01')T, 
   (SELECT T.*,
               ROW_NUMBER() OVER(PARTITION BY t.dianbiao_no ORDER BY t.dianbiao_name DESC) RN
          FROM DF_STATION_INFO T) X, 
    dim.dim_area_no_jt z
  WHERE T.DUIXIANG_NO = X.dianbiao_no
  and t.area_name=z.area_desc 
  and t.rn=1
  and x.rn=1
  group by z.std_latn_cd,x.city_no,t.shiti_no,z.area_no*/
truncate table BWT_TREND_ANALYSIS_INFO_M


select acct_month,count(*) from BWT_TREND_ANALYSIS_INFO_M group by acct_month

insert into BWT_TREND_ANALYSIS_INFO_M  
SELECT '201801' ACCT_MONTH,
       '813',
       C.STD_LATN_CD,
       B.STATION_ID_B,
       SUM(A.ELEC_AMOUNT),
       SUM(A.DEVICE_AMOUNT),
       C.AREA_NO
  FROM (SELECT A.AREA_NAME,
               replace(A.RELATION_ID,chr(13),'')RELATION_ID,
               SUM(ELEC_AMOUNT) ELEC_AMOUNT,
               SUM(DEVICE_AMOUNT) DEVICE_AMOUNT
          FROM ALLDM.ELEC_STATION_D A
         WHERE ACCT_MONTH = '201801'
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
group by C.STD_LATN_CD,B.STATION_ID_B,C.AREA_NO



