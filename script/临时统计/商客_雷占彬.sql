create table tmp_majh_sk_gw
(
user_no varchar2(20),
std_addr varchar2(2000),
building varchar2(100),
huaxiao_name  varchar2(100),
flag varchar2(2)
);

create table tmp_majh_sk_zjk
(
device_number varchar2(20), 
building varchar2(100),
huaxiao_name  varchar2(100) 
);

--�����û�ƥ���û�����
 DECLARE
  V_MONTH VARCHAR2(100);
  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018' ORDER BY IDX_NO;
BEGIN
  FOR V_NUM IN 201207 .. 201207 LOOP
    V_MONTH := TO_CHAR(V_NUM);
    FOR C1 IN V_AREA LOOP
insert into  tmp_majh_0418_sk
select 
c1.area_no,a.huaxiao_no,a.device_number,b.user_no
 from 
(select *
  from (select t.device_number,
               t.huaxiao_no,
               t.huaxiao_name,
               row_number() over(partition by t.device_number order by 1) rn
          from xxhb_mjh.tmp_majh_sk t
          where t.area_no=c1.area_no)
 where rn = 1)a,
 (select *
          from (select area_no,
                       device_number,
                       user_no,
                       row_number() over(partition by device_number order by innet_date desc) rn
                  from DW.DW_V_USER_BASE_INFO_USER A
                 WHERE ACCT_MONTH = '201803'
                   and area_no =c1.area_no) b
         where rn = 1) b
 where a.device_number = b.device_number(+);
       COMMIT;
    END LOOP;
  END LOOP;
END;
 

select * from tmp_majh_sk_hs

update  tmp_majh_sk_hs set  device_number='0'||device_number where device_number like '3%'

update tmp_majh_sk_hs set HUAXIAO_NAME=trim(HUAXIAO_NAME)��DEVICE_NUMBER=trim(DEVICE_NUMBER);


create table tmp_majh_sk_paizhao as
select 
user_no, 
std_addr, 
building, 
huaxiao_name, 
flag
 from 
(select 
user_no, 
std_addr, 
building, 
huaxiao_name, 
flag��
row_number()over(partition by user_no order by flag asc)rn
 from tmp_majh_sk_gw)
 where rn=1
 
 
 update tmp_majh_sk_paizhao set huaxiao_name='��������1' where huaxiao_name='��������'
 
 select count(*),count(distinct user_no) from tmp_majh_sk_paizhao
 
 
 select huaxiao_name,count(*) from tmp_majh_sk_paizhao group by huaxiao_name;
 
select BUILDING,count(*) from tmp_majh_sk_paizhao group by BUILDING;

--�����û�
/*create table TMP_MAJH_SK_PAIZHAO_2 as 
select 
a.*,
b.huaxiao_no
 from tmp_majh_sk_name a, 
(select * from  DIM.dim_huaxiao_info WHERE HUAXIAO_TYPE = '05') b
where a.huaxiao_name=b.huaxiao_name(+)
*/


select 
distinct a.area_no,a.huaxiao_name
 from tmp_majh_sk_name a, 
(select * from  DIM.dim_huaxiao_info WHERE HUAXIAO_TYPE = '05') b
where a.huaxiao_name=b.huaxiao_name(+)
and a.area_no=b.area_no(+)
and b.huaxiao_name is null


update tmp_majh_sk_qhd set huaxiao_name='������������' where huaxiao_name='�˴��������'


create table TMP_DW_V_USER_HUAXIAO_M as
select * from dw.MID_DW_V_USER_HUAXIAO_M where 1=2;

create table tmp_majh_sk as
select 
distinct a.*,b.huaxiao_no
 from tmp_majh_sk_name a, 
(select * from  DIM.dim_huaxiao_info WHERE HUAXIAO_TYPE = '05') b
where a.huaxiao_name=b.huaxiao_name(+)
and a.area_no=b.area_no(+) 

--�ں��û�
--truncate table TMP_DW_V_USER_HUAXIAO_M
      INSERT INTO TMP_DW_V_USER_HUAXIAO_M
        SELECT /*+ORDERED*/
         '201802' ACCT_MONTH,
         A.AREA_NO,
         A.USER_NO,
         A.DEVICE_NUMBER,
         A.TELE_TYPE,
         A.IS_ONNET,
         A.BUNDLE_ID,
         E.XIAOQU_NO,
         E.XIAOQU_NAME,
         E.HUAXIAO_NO,
         E.HUAXIAO_NAME,
         E.HUAXIAO_TYPE,
         E.HUAXIAO_TYPE_NAME,
         BUNDLE_DINNER_BEG_DATE 
          FROM (SELECT AREA_NO,
                       CITY_NO,
                       USER_NO,
                       DEVICE_NUMBER,
                       CHANNEL_NO,
                       CHANNEL_NO_DESC,
                       IS_KD_BUNDLE,
                       TELE_TYPE,
                       NVL(BUNDLE_ID_ALLOWANCE, BUNDLE_ID) AS BUNDLE_ID,
                       IS_ONNET,
                       BUNDLE_DINNER_BEG_DATE
                  FROM DW.DW_V_USER_BASE_INFO_USER T
                 WHERE ACCT_MONTH = '201802'
                   --AND AREA_NO = '188'
                   AND TELE_TYPE <> '2'
                   AND NVL(IS_KD_BUNDLE, '0') <> '0') A,

               (SELECT USER_NO,
                       T.GRADE_0 || '/' || T.GRADE_1 || '/' || T.GRADE_2 || '/' ||
                       T.GRADE_3 || '/' || T.GRADE_4 STDADDR_NAME
                  FROM DW.DW_V_USER_ADSL_EIGHT_M T
                 WHERE ACCT_MONTH = '201802'
                   --AND T.AREA_NO = '188'
                   AND USER_NO IS NOT NULL) B,

               (SELECT * FROM ALLDMCODE.DMCODE_XIAOQU_STD_ADDR_NEW) C,

               DIM.DIM_XIAOQU_HUAXIAO E

         WHERE A.USER_NO = B.USER_NO(+)
           AND B.STDADDR_NAME = C.STDADDR_NAME(+)
           AND C.XIAOQU_NO = E.XIAOQU_NO(+);
           commit;
           
create table tmp_V_USER_HUAXIAO_M_PLUS as
select * from dw.MID_DW_V_USER_HUAXIAO_M_PLUS where 1=2;

truncate table TMP_V_USER_HUAXIAO_M_PLUS
      INSERT INTO TMP_V_USER_HUAXIAO_M_PLUS
        SELECT ACCT_MONTH,
               AREA_NO,
               USER_NO,
               DEVICE_NUMBER,
               TELE_TYPE,
               IS_ONNET,
               BUNDLE_ID,
               XIAOQU_NO,
               XIAOQU_NAME,
               HUAXIAO_NO,
               HUAXIAO_NAME,
               HUAXIAO_TYPE,
               HUAXIAO_TYPE_NAME,
               RN
          FROM (SELECT A.*,
                       ROW_NUMBER() OVER(PARTITION BY BUNDLE_ID ORDER BY(CASE
                         WHEN TELE_TYPE IN
                              ('4',
                               '26') THEN
                          1
                         WHEN TELE_TYPE = '72' THEN
                          2
                         ELSE
                          3
                       END), BUNDLE_DINNER_BEG_DATE DESC) RN
                  FROM tmp_DW_V_USER_HUAXIAO_M A)
         WHERE RN = 1;
      COMMIT;
      
      
create table tmp_majh_chnnr as
select 
a.*,b.huaxiao_name
 from tmp_majh_chnnr_sjz a,dim.dim_huaxiao_info b
where a.huaxiao_no=b.huaxiao_no  ;    

--�����������
    create table tmp_majh_sk_01 as 
SELECT '201802' ACCT_MONTH,
       A.AREA_NO,
       A.CITY_NO,
       A.USER_NO,
       A.DEVICE_NUMBER,
       A.INNET_DATE,
       A.TOTAL_FEE,
       A.TOTAL_FEE_OCS,
       A.IS_ACCT,
       A.IS_ACCT_OCS,
       A.IS_ONNET,
       A.CHANNEL_NO,
       A.CHANNEL_NO_DESC�� 
       A.TELE_TYPE_NAME,
       A.IS_NEW,
       CASE
         WHEN B.DEVICE_NUMBER IS NOT NULL AND
              TO_CHAR(A.INNET_DATE, 'YYYYMM') <= '201712' THEN
          '1'
         WHEN TO_CHAR(A.INNET_DATE, 'YYYYMM') > '201712' AND
              A.TELE_TYPE_NAME IN
              ('�ƶ�', '���', '����', '�̻�', 'ר�ߵ�·') AND A.IS_KD_BUNDLE = '0' AND
              A.TELE_TYPE = '2' AND D.CHANNEL_NO IS NOT NULL THEN
          '1' --��C
         WHEN TO_CHAR(A.INNET_DATE, 'YYYYMM') > '201712' AND
              A.TELE_TYPE_NAME IN
              ('�ƶ�', '���', '����', '�̻�', 'ר�ߵ�·') AND A.IS_KD_BUNDLE = '0' AND
              A.TELE_TYPE <> '2' AND E2.HUAXIAO_TYPE = '05' THEN
          '1' --����
         WHEN TO_CHAR(A.INNET_DATE, 'YYYYMM') > '201712' AND
              A.TELE_TYPE_NAME IN
              ('�ƶ�', '���', '����', '�̻�', 'ר�ߵ�·') AND C.HUAXIAO_TYPE = '05' THEN
          '1' --�ں�
         ELSE
          '0'
       END IS_SK,
       CASE
         WHEN B.DEVICE_NUMBER IS NOT NULL AND
              TO_CHAR(A.INNET_DATE, 'YYYYMM') <= '201712' THEN
          B.HUAXIAO_NO
         WHEN TO_CHAR(A.INNET_DATE, 'YYYYMM') > '201712' AND
              A.TELE_TYPE_NAME IN
              ('�ƶ�', '���', '����', '�̻�', 'ר�ߵ�·') AND A.IS_KD_BUNDLE = '0' AND
              A.TELE_TYPE = '2' AND D.CHANNEL_NO IS NOT NULL THEN
          D.HUAXIAO_NO --��C
         WHEN TO_CHAR(A.INNET_DATE, 'YYYYMM') > '201712' AND
              A.TELE_TYPE_NAME IN
              ('�ƶ�', '���', '����', '�̻�', 'ר�ߵ�·') AND A.IS_KD_BUNDLE = '0' AND
              A.TELE_TYPE <> '2' AND E2.HUAXIAO_TYPE = '05' THEN
          E2.HUAXIAO_NO --����
         WHEN TO_CHAR(A.INNET_DATE, 'YYYYMM') > '201712' AND
              A.TELE_TYPE_NAME IN
              ('�ƶ�', '���', '����', '�̻�', 'ר�ߵ�·') AND C.HUAXIAO_TYPE = '05' THEN
          C.HUAXIAO_NO --�ں�
       END HUAXIAO_NO,
       CASE
         WHEN B.DEVICE_NUMBER IS NOT NULL AND
              TO_CHAR(A.INNET_DATE, 'YYYYMM') <= '201712' THEN
          B.HUAXIAO_NAME
         WHEN TO_CHAR(A.INNET_DATE, 'YYYYMM') > '201712' AND
              A.TELE_TYPE_NAME IN
              ('�ƶ�', '���', '����', '�̻�', 'ר�ߵ�·') AND A.IS_KD_BUNDLE = '0' AND
              A.TELE_TYPE = '2' AND D.CHANNEL_NO IS NOT NULL THEN
          D.HUAXIAO_NAME --��C
         WHEN TO_CHAR(A.INNET_DATE, 'YYYYMM') > '201712' AND
              A.TELE_TYPE_NAME IN
              ('�ƶ�', '���', '����', '�̻�', 'ר�ߵ�·') AND A.IS_KD_BUNDLE = '0' AND
              A.TELE_TYPE <> '2' AND E2.HUAXIAO_TYPE = '05' THEN
          E2.HUAXIAO_NAME --����
         WHEN TO_CHAR(A.INNET_DATE, 'YYYYMM') > '201712' AND
              A.TELE_TYPE_NAME IN
              ('�ƶ�', '���', '����', '�̻�', 'ר�ߵ�·') AND C.HUAXIAO_TYPE = '05' THEN
          C.HUAXIAO_NAME --�ں�
       END HUAXIAO_NAME,
       CASE
         WHEN B.DEVICE_NUMBER IS NOT NULL AND
              TO_CHAR(A.INNET_DATE, 'YYYYMM') <= '201712' AND
              A.TELE_TYPE = '2' AND A.IS_KD_BUNDLE <> '0' AND
              D.CHANNEL_NO IS NULL THEN
          '1' --����������������չ���ں�C   ����
         WHEN TO_CHAR(A.INNET_DATE, 'YYYYMM') > '201712' AND
              A.TELE_TYPE_NAME IN
              ('�ƶ�', '���', '����', '�̻�', 'ר�ߵ�·') AND C.HUAXIAO_TYPE = '05' AND
              A.TELE_TYPE = '2' AND A.IS_KD_BUNDLE <> '0' AND
              D.CHANNEL_NO IS NULL THEN
          '1'  --����������������չ���ں�C   ����
         ELSE
          '0'
       END IS_DEL

  FROM (SELECT A.AREA_NO,
               A.CITY_NO,
               A.TELE_TYPE,
               A.USER_NO,
               A.CUSTOMER_NO,
               A.ACCOUNT_NO,
               A.DEVICE_NUMBER,
               A.INNET_DATE,
               A.USER_DINNER,
               A.CHANNEL_NO,
               A.CHANNEL_NO_DESC,
               A.GROUP_NO,
               A.IS_ONNET,
               A.IS_NEW,
               A.IS_ACTIVE,
               A.IS_CALL,
               A.USER_STATUS,
               A.LOGOUT_DATE,
               A.IS_LOGOUT,
               A.IS_OUTNET,
               A.IS_VALID,
               A.RECENT_STOP_DATE,
               A.IS_OCS,
               A.IS_ACCT,
               A.IS_ACCT_OCS,
               A.INNET_MONTH,
               A.INNET_METHOD,
               NVL(BUNDLE_ID_ALLOWANCE, BUNDLE_ID) BUNDLE_ID,
               A.IS_KD_BUNDLE,
               A.TOTAL_FEE,
               A.TOTAL_FEE_OCS,
               A.PRICE_FEE,
               A.PRICE_FEE_OCS,
               A.BUNDLE_ID_ALLOWANCE,
               A.ALL_JF_FLUX,
               A.WIFI_JF_FLUX,
               A.JF_TIMES,
               A.TERMINAL_TYPE,
               A.TERMINAL_CORP,
               A.TELE_TYPE_NEW,
               A.IS_3NO_ADJUST,
               CASE
                 WHEN TELE_TYPE = '2' THEN
                  '�ƶ�'
                 WHEN TELE_TYPE_NEW = 'G010' THEN
                  '���'
                 WHEN TELE_TYPE_NEW = 'G110' THEN
                  '����'
                 WHEN TELE_TYPE_NEW IN ('G020', 'G040') THEN
                  'ר�ߵ�·'
                 WHEN TELE_TYPE_NEW IN ('G000', 'G001', 'G002') THEN
                  '�̻�'
               END TELE_TYPE_NAME
          FROM DW.DW_V_USER_BASE_INFO_USER A
         WHERE ACCT_MONTH = '201802'
          -- AND AREA_NO = '188'
           AND (TELE_TYPE = '2' OR
               TELE_TYPE_NEW IN
               ('G010', 'G110', 'G020', 'G040', 'G000', 'G001', 'G002'))) A,
       (SELECT USER_NO,
               T.GRADE_0 || '/' || T.GRADE_1 || '/' || T.GRADE_2 || '/' ||
               T.GRADE_3 || '/' || T.GRADE_4 STDADDR_NAME
          FROM DW.DW_V_USER_ADSL_EIGHT_M T
         WHERE ACCT_MONTH = '201802'
           --AND T.AREA_NO = '188'
           AND USER_NO IS NOT NULL) A1,
       
       (
       select *
              from (select t.device_number,
               t.huaxiao_no,
               t.huaxiao_name,
               row_number() over(partition by t.device_number order by 1) rn
          from tmp_majh_sk t)
           where rn = 1
       ) B,
       TMP_V_USER_HUAXIAO_M_PLUS C�� tmp_majh_chnnr D,
       (SELECT * FROM ALLDMCODE.DMCODE_XIAOQU_STD_ADDR_NEW) E1,
       (SELECT *
          FROM DIM.DIM_XIAOQU_HUAXIAO
         WHERE HUAXIAO_TYPE = '05'
           --AND AREA_NO = '188'
           ) E2 --�̿�
 WHERE A.USER_NO = A1.USER_NO(+)
   AND A.DEVICE_NUMBER = B.DEVICE_NUMBER(+)
   AND A.BUNDLE_ID = C.BUNDLE_ID(+)
   AND A.CHANNEL_NO = D.CHANNEL_NO(+)
   AND A1.STDADDR_NAME = E1.STDADDR_NAME(+)
   AND E1.XIAOQU_NO = E2.XIAOQU_NO(+)

;
--��ģ��
select 
c.area_desc,
d.city_desc,
b.huaxiao_no,
b.huaxiao_name,
--����
sum(a.total_fee+a.total_fee_ocs) total_fee_all,
sum(case when to_char(a.innet_date,'yyyymm')<='201712' then a.total_fee+a.total_fee_ocs else 0 end)total_fee_cl,
--�ƶ�
count(case when a.tele_type_name='�ƶ�' and (a.is_acct='1' or a.is_acct_ocs='1') and a.is_del='0' then a.user_no end)acct_cnt_all,
count(case when a.tele_type_name='�ƶ�' and  to_char(a.innet_date,'yyyymm')<='201712' and (a.is_acct='1' or a.is_acct_ocs='1') and a.is_del='0' then a.user_no end)acct_cnt_all,
count(case when a.tele_type_name='�ƶ�' and  a.is_new='1' and a.is_del='0' then a.user_no end)acct_cnt_new,
--���
count(case when a.tele_type_name='���' and (a.is_acct='1' or a.is_acct_ocs='1') then a.user_no end)acct_cnt_all,
count(case when a.tele_type_name='���' and to_char(a.innet_date,'yyyymm')<='201712' and (a.is_acct='1' or a.is_acct_ocs='1') then a.user_no end)acct_cnt_all,
count(case when a.tele_type_name='���' and a.is_new='1' then a.user_no end)acct_cnt_new,
--����
count(case when a.tele_type_name='����' and (a.is_acct='1' or a.is_acct_ocs='1') then a.user_no end)acct_cnt_all,
count(case when a.tele_type_name='����' and to_char(a.innet_date,'yyyymm')<='201712' and (a.is_acct='1' or a.is_acct_ocs='1') then a.user_no end)acct_cnt_all,
count(case when a.tele_type_name='����' and a.is_new='1' then a.user_no end)acct_cnt_new,
--ר�ߵ�·
count(case when a.tele_type_name='ר�ߵ�·' and (a.is_acct='1' or a.is_acct_ocs='1') then a.user_no end)acct_cnt_all,
count(case when a.tele_type_name='ר�ߵ�·' and to_char(a.innet_date,'yyyymm')<='201712' and (a.is_acct='1' or a.is_acct_ocs='1') then a.user_no end)acct_cnt_all,
count(case when a.tele_type_name='ר�ߵ�·' and a.is_new='1' then a.user_no end)acct_cnt_new,
--�̻�
count(case when a.tele_type_name='�̻�' and (a.is_acct='1' or a.is_acct_ocs='1') then a.user_no end)acct_cnt_all,
count(case when a.tele_type_name='�̻�' and to_char(a.innet_date,'yyyymm')<='201712' and (a.is_acct='1' or a.is_acct_ocs='1') then a.user_no end)acct_cnt_all,
count(case when a.tele_type_name='�̻�' and a.is_new='1' then a.user_no end)acct_cnt_new
 from  tmp_majh_sk_01 a, dim.dim_huaxiao_info b,dim.dim_area_no c,dim.dim_city_no d
where a.huaxiao_no=b.huaxiao_no
and b.area_no=c.area_no
and b.city_no=d.city_no
group by c.area_desc,
d.city_desc,
b.huaxiao_no,
b.huaxiao_name

--˫�Ƿ���
select 
c.area_desc, 
--����
sum(a.total_fee+a.total_fee_ocs) total_fee_all
 from  tmp_majh_sk_01 a, dim.dim_huaxiao_info b,dim.dim_area_no c 
where a.huaxiao_no=b.huaxiao_no 
and b.area_no=c.area_no 
group by c.area_desc,c.idx_no
order by c.idx_no


--���̿�˫��
select 
c.area_desc, 
--����
sum(a.total_fee+a.total_fee_ocs) total_fee_all
 from  tmp_majh_0304_yw_03 a, dim.dim_huaxiao_info b,dim.dim_area_no c��tmp_majh_sk_01 d
where a.huaxiao_no=b.huaxiao_no
and b.area_no=c.area_no 
and a.user_no=d.user_no
and b.huaxiao_type='06'
and d.huaxiao_no is not null
group by c.area_desc,c.idx_no
order by c.idx_no







/*--����01
select 
'201802' acct_month,
nvl(substr(a.huaxiao_name,1,2),'����'),
--��չ
count(distinct case when to_char(innet_date,'yyyymm')='201802' and tele_type_name='�ƶ�' and c.channel_no is not null then a.user_no end) yd_dev,
count(distinct case when to_char(innet_date,'yyyymm')='201802' and tele_type_name='���' and c.channel_no is not null then a.user_no end) kd_dev,
count(distinct case when to_char(innet_date,'yyyymm')='201802' and tele_type_name='ר�ߵ�·' and c.channel_no is not null then a.user_no end) zxdl_dev,
count(distinct case when to_char(innet_date,'yyyymm')='201802' and tele_type_name='����' and c.channel_no is not null then a.user_no end) ds_dev,
count(distinct case when to_char(innet_date,'yyyymm')='201802' and tele_type_name='�̻�' and c.channel_no is not null then a.user_no end) gh_dev,
--����
count(distinct case when  tele_type_name='�ƶ�' and (is_acct='1' or is_acct_ocs='1') and c.channel_no is not null then a.user_no end) yd_acct,
count(distinct case when  tele_type_name='���' and (is_acct='1' or is_acct_ocs='1') and c.channel_no is not null then a.user_no end) kd_acct,
count(distinct case when  tele_type_name='ר�ߵ�·' and (is_acct='1' or is_acct_ocs='1') and c.channel_no is not null then a.user_no end) zxdl_acct,
count(distinct case when  tele_type_name='����' and (is_acct='1' or is_acct_ocs='1') and c.channel_no is not null then a.user_no end) ds_acct,
count(distinct case when  tele_type_name='�̻�' and (is_acct='1' or is_acct_ocs='1') and c.channel_no is not null then a.user_no end) gh_acct,
--����
sum(case when to_char(a.innet_date,'yyyy')='2018' then total_fee+total_fee_ocs else 0 end) new_total_fee,
sum(total_fee+total_fee_ocs) all_total_fee
 from tmp_majh_sk_01 a,dim.dim_city_no b ,tmp_majh_sjz_chnr_2 c
 where a.city_no=b.city_no
 and a.channel_no=c.channel_no(+)
 and a.huaxiao_name not like '%#N%'
 group by nvl(substr(a.huaxiao_name,1,2),'����')
 
--����02
select 
'201802' acct_month,
a.huaxiao_name,
--��չ
count(distinct case when to_char(innet_date,'yyyymm')='201802' and tele_type_name='�ƶ�' then a.user_no end) yd_dev,
count(distinct case when to_char(innet_date,'yyyymm')='201802' and tele_type_name='���' then a.user_no end) kd_dev,
count(distinct case when to_char(innet_date,'yyyymm')='201802' and tele_type_name='ר�ߵ�·' then a.user_no end) zxdl_dev,
count(distinct case when to_char(innet_date,'yyyymm')='201802' and tele_type_name='����' then a.user_no end) ds_dev,
count(distinct case when to_char(innet_date,'yyyymm')='201802' and tele_type_name='�̻�' then a.user_no end) gh_dev,
--����
count(distinct case when  tele_type_name='�ƶ�' and (is_acct='1' or is_acct_ocs='1') then a.user_no end) yd_acct,
count(distinct case when  tele_type_name='���' and (is_acct='1' or is_acct_ocs='1') then a.user_no end) kd_acct,
count(distinct case when  tele_type_name='ר�ߵ�·' and (is_acct='1' or is_acct_ocs='1') then a.user_no end) zxdl_acct,
count(distinct case when  tele_type_name='����' and (is_acct='1' or is_acct_ocs='1') then a.user_no end) ds_acct,
count(distinct case when  tele_type_name='�̻�' and (is_acct='1' or is_acct_ocs='1') then a.user_no end) gh_acct,
--����
sum(case when to_char(a.innet_date,'yyyy')='2018' then total_fee+total_fee_ocs else 0 end) new_total_fee,
sum(total_fee+total_fee_ocs) all_total_fee
 from tmp_majh_sk_01 a,dim.dim_city_no b 
 where a.city_no=b.city_no
 group by a.huaxiao_name
 
--����03
select 
'201802' acct_month,
a.building,
--��չ
count(distinct case when to_char(innet_date,'yyyymm')='201802' and tele_type_name='�ƶ�' then a.user_no end) yd_dev,
count(distinct case when to_char(innet_date,'yyyymm')='201802' and tele_type_name='���' then a.user_no end) kd_dev,
count(distinct case when to_char(innet_date,'yyyymm')='201802' and tele_type_name='ר�ߵ�·' then a.user_no end) zxdl_dev,
count(distinct case when to_char(innet_date,'yyyymm')='201802' and tele_type_name='����' then a.user_no end) ds_dev,
count(distinct case when to_char(innet_date,'yyyymm')='201802' and tele_type_name='�̻�' then a.user_no end) gh_dev,
--����
count(distinct case when  tele_type_name='�ƶ�' and (is_acct='1' or is_acct_ocs='1') then a.user_no end) yd_acct,
count(distinct case when  tele_type_name='���' and (is_acct='1' or is_acct_ocs='1') then a.user_no end) kd_acct,
count(distinct case when  tele_type_name='ר�ߵ�·' and (is_acct='1' or is_acct_ocs='1') then a.user_no end) zxdl_acct,
count(distinct case when  tele_type_name='����' and (is_acct='1' or is_acct_ocs='1') then a.user_no end) ds_acct,
count(distinct case when  tele_type_name='�̻�' and (is_acct='1' or is_acct_ocs='1') then a.user_no end) gh_acct,
--����
sum(case when to_char(a.innet_date,'yyyy')='2018' then total_fee+total_fee_ocs else 0 end) new_total_fee,
sum(total_fee+total_fee_ocs) all_total_fee
 from tmp_majh_sk_01 a,dim.dim_city_no b 
 where a.city_no=b.city_no
 and a.flag=1
 group by a.building
 
 
 --����04
select 
'201802' acct_month,
b.city_desc,c.channel_no,c.channel_no_desc,
--��չ
count(distinct case when to_char(innet_date,'yyyymm')='201802' and tele_type_name='�ƶ�' then a.user_no end) yd_dev,
count(distinct case when to_char(innet_date,'yyyymm')='201802' and tele_type_name='���' then a.user_no end) kd_dev,
count(distinct case when to_char(innet_date,'yyyymm')='201802' and tele_type_name='ר�ߵ�·' then a.user_no end) zxdl_dev,
count(distinct case when to_char(innet_date,'yyyymm')='201802' and tele_type_name='����' then a.user_no end) ds_dev,
count(distinct case when to_char(innet_date,'yyyymm')='201802' and tele_type_name='�̻�' then a.user_no end) gh_dev,
--����
count(distinct case when  tele_type_name='�ƶ�' and (is_acct='1' or is_acct_ocs='1') then a.user_no end) yd_acct,
count(distinct case when  tele_type_name='���' and (is_acct='1' or is_acct_ocs='1') then a.user_no end) kd_acct,
count(distinct case when  tele_type_name='ר�ߵ�·' and (is_acct='1' or is_acct_ocs='1') then a.user_no end) zxdl_acct,
count(distinct case when  tele_type_name='����' and (is_acct='1' or is_acct_ocs='1') then a.user_no end) ds_acct,
count(distinct case when  tele_type_name='�̻�' and (is_acct='1' or is_acct_ocs='1') then a.user_no end) gh_acct,
--����
sum(case when to_char(a.innet_date,'yyyy')='2018' then total_fee+total_fee_ocs else 0 end) new_total_fee,
sum(total_fee+total_fee_ocs) all_total_fee
 from tmp_majh_sk_01 a,dim.dim_city_no b,dim.dim_channel_no c
 where c.city_no=b.city_no
 and a.channel_no=c.channel_no
 and a.flag in ('2','3')
 group by b.city_desc,c.channel_no,c.channel_no_desc*/
