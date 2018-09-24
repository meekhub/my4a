select  * from dim.dim_channel_no a where a.channel_no_desc like '%迪讯通讯设备销售部%';

--267个号
create table tmp_majh_qizha_1121_01
(
device_number varchar2(20)
)

183564668
183354740
183588572
183585182
183586223

create table tmp_majh_qizha_1121_02
(
device_number varchar(30),
innet_date varchar(30),
area_no_desc varchar(300),
city_no_desc varchar(300),
user_dinner varchar(30),
user_dinner_desc varchar(300),
channel_no varchar(30),
channel_no_desc varchar(300),
is_onnet  varchar(30)
)

create table TMP_MAJH_LONGYAN_1121_01
(
day_id varchar2(20),
DEVICE_NUMBER varchar2(20),
area_no varchar2(20),
zhu_call_cdr number,
bei_call_cdr number,
bei_user_cnt number,
cell_no varchar2(60)
)
create table TMP_MAJH_LONGYAN_1121_02 as
select * from TMP_MAJH_LONGYAN_1121_01 where 1=2

--delete from TMP_MAJH_LONGYAN_1121_02 where day_id='20171127'

DECLARE
  V_MONTH VARCHAR2(100);
  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018' ORDER BY IDX_NO;
BEGIN
  FOR V_NUM IN 20171201 .. 20171201 LOOP
    V_MONTH := TO_CHAR(V_NUM);
    FOR C1 IN V_AREA LOOP
      INSERT INTO TMP_MAJH_LONGYAN_1121_02
        SELECT V_MONTH,
               DEVICE_NUMBER,
               C1.AREA_NO,
               SUM(CASE
                     WHEN ORG_TRM_ID = '10' THEN
                      1
                     ELSE
                      0
                   END),
               SUM(CASE
                     WHEN ORG_TRM_ID = '11' THEN
                      1
                     ELSE
                      0
                   END),
               COUNT(DISTINCT case when ORG_TRM_ID = '10' then OPPOSE_NUMBER end),
               CELL_NO
          FROM DW.DW_V_USER_CDR_CDMA_OCS
         WHERE ACCT_MONTH = '201711'
           AND CALL_DATE = SUBSTR(V_MONTH, 7, 2)
           AND AREA_NO = C1.AREA_NO
           AND ROAM_AREA_CODE in ('384','395')
         GROUP BY DEVICE_NUMBER, CELL_NO
        UNION ALL
        SELECT V_MONTH,
               DEVICE_NUMBER,
               C1.AREA_NO,
               SUM(CASE
                     WHEN ORG_TRM_ID = '10' THEN
                      1
                     ELSE
                      0
                   END),
               SUM(CASE
                     WHEN ORG_TRM_ID = '11' THEN
                      1
                     ELSE
                      0
                   END),
               COUNT(DISTINCT case when ORG_TRM_ID = '10' then OPPOSE_NUMBER end),
               CELL_NO
          FROM DW.DW_V_USER_CDR_CDMA
         WHERE ACCT_MONTH = '201711'
           AND CALL_DATE = SUBSTR(V_MONTH, 7, 2)
           AND AREA_NO = C1.AREA_NO
           AND ROAM_AREA_CODE in ('384','395')
         GROUP BY DEVICE_NUMBER, CELL_NO;
      COMMIT;
    END LOOP;
  END LOOP;
END;


--汇总
CREATE TABLE TMP_MAJH_LONGYAN_1121_03 AS
SELECT T.AREA_NO,
       T.DEVICE_NUMBER,
       SUM(T.ZHU_CALL_CDR)ZHU_CALL_CDR,
       SUM(T.BEI_CALL_CDR)BEI_CALL_CDR,
       SUM(T.BEI_USER_CNT)BEI_USER_CNT
  FROM TMP_MAJH_LONGYAN_1121_02 T WHERE DAY_ID>=TO_CHAR(SYSDATE-1,'YYYYMMDD')
 GROUP BY T.AREA_NO, T.DEVICE_NUMBER;
 


create table TMP_MAJH_LONGYAN_1121_04 as 
select t.*,T.BEI_USER_CNT / T.ZHU_CALL_CDR as lisan_rate from 
(SELECT *
  FROM TMP_MAJH_LONGYAN_1121_03 T where T.ZHU_CALL_CDR + T.BEI_CALL_CDR>0 and T.BEI_CALL_CDR>0) t
 WHERE T.ZHU_CALL_CDR / (T.ZHU_CALL_CDR + T.BEI_CALL_CDR) > 0.8
 and T.BEI_USER_CNT / T.ZHU_CALL_CDR > 0.7;

--28号
create table tmp_majh_1128_01
(
device_number varchar2(20)
)

select 
c.area_desc,
b.device_number, 
b.zhu_call_cdr, 
b.bei_call_cdr, 
b.bei_user_cnt, 
b.lisan_rate
 from tmp_majh_1128_01 a,TMP_MAJH_LONGYAN_1121_04 b,dim.dim_area_no c
where a.device_number=b.device_number
and b.area_no=c.area_no


create table TMP_MAJH_LONGYAN_1121_05 as 
SELECT X.AREA_DESC,
       A.DEVICE_NUMBER,
       A.ZHU_CALL_CDR,
       A.BEI_CALL_CDR,
       A.BEI_USER_CNT,
       A.LISAN_RATE,
       CASE
         WHEN B.DEVICE_NUMBER IS NOT NULL THEN
          '是'
         ELSE
          '否'
       END IS_C
  FROM TMP_MAJH_LONGYAN_1121_04 A,
       DIM.DIM_AREA_NO X,
       (SELECT DISTINCT DEVICE_NUMBER
          FROM TMP_MAJH_LONGYAN_1121_02
         WHERE CELL_NO IN
               (SELECT DISTINCT A.CELL_NO
                  FROM TMP_MAJH_LONGYAN_1121_02 A, TMP_MAJH_FZ_1122_01 B
                 WHERE A.DEVICE_NUMBER = B.DEVICE_NUMBER
                   AND B.FLAG = '1')) B
 WHERE A.DEVICE_NUMBER = B.DEVICE_NUMBER(+)
   AND A.AREA_NO = X.AREA_NO

 

----------267个号码跟踪
create table tmp_majh_fz_1122_01
(
device_number varchar2(20),
flag varchar2(2)
)


create table tmp_majh_fz_1122_02
(
day_id varchar2(20),
area_no  varchar2(20),
DEVICE_NUMBER  varchar2(20),
OPPOSE_NUMBER varchar2(20),
call_date varchar2(20),
is_zhu varchar2(20),
CALL_DURATION number,
CELL_NO varchar2(30)
)


DECLARE
  V_MONTH VARCHAR2(100);
  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018' ORDER BY IDX_NO;
BEGIN
  FOR V_NUM IN 20171101 .. 20171122 LOOP
    V_MONTH := TO_CHAR(V_NUM);
    FOR C1 IN V_AREA LOOP
      INSERT INTO tmp_majh_fz_1122_02
        SELECT V_MONTH,
               C1.AREA_NO,
               DEVICE_NUMBER, 
               OPPOSE_NUMBER,
               CALL_DATE,
              CASE WHEN  ORG_TRM_ID='10' THEN '1' ELSE '0' END,
               CALL_DURATION,
               CELL_NO
          FROM DW.DW_V_USER_CDR_CDMA_OCS
         WHERE ACCT_MONTH = '201711'
           AND CALL_DATE = SUBSTR(V_MONTH, 7, 2)
           AND AREA_NO = C1.AREA_NO
           AND ROAM_AREA_CODE in ('384','395') 
        UNION ALL
        SELECT V_MONTH,
               C1.AREA_NO,
               DEVICE_NUMBER, 
               OPPOSE_NUMBER,
               CALL_DATE,
              CASE WHEN  ORG_TRM_ID='10' THEN '1' ELSE '0' END,
               CALL_DURATION,
               CELL_NO 
          FROM DW.DW_V_USER_CDR_CDMA
         WHERE ACCT_MONTH = '201711'
           AND CALL_DATE = SUBSTR(V_MONTH, 7, 2)
           AND AREA_NO = C1.AREA_NO
           AND ROAM_AREA_CODE in ('384','395');
      COMMIT;
    END LOOP;
  END LOOP;
END;



SELECT A.DAY_ID,
       C.AREA_DESC,
       A.DEVICE_NUMBER,
       A.OPPOSE_NUMBER,
       A.CALL_DATE,
       A.IS_ZHU,
       A.CALL_DURATION,
       A.CELL_NO
  FROM TMP_MAJH_FZ_1122_02 A, TMP_MAJH_FZ_1122_01 B, DIM.DIM_AREA_NO C
 WHERE A.DEVICE_NUMBER = B.DEVICE_NUMBER
   AND B.FLAG = '1'
   AND A.AREA_NO = C.AREA_NO
   
   
   
 SELECT  A.CELL_NO,count(*)
   FROM TMP_MAJH_FZ_1122_02 A, TMP_MAJH_FZ_1122_01 B, DIM.DIM_AREA_NO C
  WHERE A.DEVICE_NUMBER = B.DEVICE_NUMBER
    AND B.FLAG = '1'
    AND A.AREA_NO = C.AREA_NO
    group by a.cell_no;

create table tmp_majh_risk_cell
(
cell_no varchar2(40),
level_idx number
)

select * from tmp_majh_risk_cell;



SELECT DISTINCT C.AREA_DESC, A.DEVICE_NUMBER, D.LEVEL_IDX
  FROM TMP_MAJH_FZ_1122_02 A,
       TMP_MAJH_FZ_1122_01 B,
       DIM.DIM_AREA_NO     C,
       TMP_MAJH_RISK_CELL  D
 WHERE A.DEVICE_NUMBER = B.DEVICE_NUMBER
   AND B.FLAG = '2'
   AND A.AREA_NO = C.AREA_NO
   AND A.CELL_NO = D.CELL_NO;


--11月22日比对
create table tmp_majh_fz_1123_01
(
device_number varchar2(20)
)

create table tmp_majh_fz_1123_03
(
device_number varchar2(20)
)

create table tmp_majh_fz_1123_02 as
select * from tmp_majh_fz_1122_02 where 1=2;

flashback table tmp_majh_fz_1123_02 to before drop


--delete from tmp_majh_fz_1123_02 where day_id='20171127'
DECLARE
  V_MONTH VARCHAR2(100);
  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018' ORDER BY IDX_NO;
BEGIN
  FOR V_NUM IN 20171129 .. 20171129 LOOP
    V_MONTH := TO_CHAR(V_NUM);
    FOR C1 IN V_AREA LOOP
      INSERT INTO TMP_MAJH_FZ_1123_02
        SELECT V_MONTH,
               C1.AREA_NO,
               DEVICE_NUMBER, 
               OPPOSE_NUMBER,
               CALL_DATE,
              CASE WHEN  ORG_TRM_ID='10' THEN '1' ELSE '0' END,
               CALL_DURATION,
               CELL_NO
          FROM DW.DW_V_USER_CDR_CDMA_OCS
         WHERE ACCT_MONTH = '201711'
           AND CALL_DATE = SUBSTR(V_MONTH, 7, 2)
           AND AREA_NO = C1.AREA_NO
           AND ROAM_AREA_CODE in ('384','395') 
        UNION ALL
        SELECT V_MONTH,
               C1.AREA_NO,
               DEVICE_NUMBER, 
               OPPOSE_NUMBER,
               CALL_DATE,
              CASE WHEN  ORG_TRM_ID='10' THEN '1' ELSE '0' END,
               CALL_DURATION,
               CELL_NO 
          FROM DW.DW_V_USER_CDR_CDMA
         WHERE ACCT_MONTH = '201711'
           AND CALL_DATE = SUBSTR(V_MONTH, 7, 2)
           AND AREA_NO = C1.AREA_NO
           AND ROAM_AREA_CODE in ('384','395');
      COMMIT;
    END LOOP;
  END LOOP;
END;


/*SELECT DISTINCT D.AREA_DESC, A.DEVICE_NUMBER, B.LEVEL_IDX
  FROM TMP_MAJH_FZ_1123_02 A,
       TMP_MAJH_RISK_CELL  B,
       TMP_MAJH_FZ_1123_03 C,
       DIM.DIM_AREA_NO     D
 WHERE A.CELL_NO = B.CELL_NO
   AND A.DEVICE_NUMBER = C.DEVICE_NUMBER
   AND A.AREA_NO = D.AREA_NO*/

create table tmp_majh_1129_01 as
SELECT DISTINCT d.area_no,D.AREA_DESC, A.DEVICE_NUMBER, B.LEVEL_IDX
  FROM TMP_MAJH_FZ_1123_02 A,
       TMP_MAJH_RISK_CELL  B, 
       DIM.DIM_AREA_NO     D
 WHERE A.CELL_NO = B.CELL_NO 
   AND A.AREA_NO = D.AREA_NO
   and a.day_id=to_char(sysdate-1,'yyyymmdd')


select b.area_desc,device_number,flag,level_idx
from
(select t.area_no,device_number,'模型识别' flag,'' level_idx from tmp_majh_longyan_1121_04 t
union all
select area_no,device_number,'CI识别' flag,to_char(LEVEL_IDX) from tmp_majh_1129_01
)a,dim.dim_area_no b
where a.area_no=b.area_no

--更新风险CI
/*truncate table TMP_MAJH_RISK_CELL
select distinct t.cell_no
  from TMP_MAJH_LONGYAN_1121_02 t, tmp_majh_fz_1122_01 b
 where t.device_number = b.device_number
   and b.flag = '1'*/


