select * from dim.dim_sale_mode_new  a where a.kind='1420046';


create table tmp_majh_sales_01
(
idx_no number,
kind varchar2(50),
name varchar2(200)
)

update tmp_majh_sales_01 set kind=trim(kind);

select distinct a.kind,a.name from tmp_majh_sales_01 a,dim.dim_sale_mode_new b
where a.kind=b.kind(+)
and b.kind is null;
1419459	翼支付红包卡-199元档（合约）
1419462	翼支付红包卡-19元档（分月转兑）
1419460	翼支付红包卡-19元档（合约）
1419461	翼支付红包卡-29元档（合约）
1421836	公众-终端直降20元6个月-转兑（201707）
1423354	4G-QoS折扣促销

select * from dim.dim_transfer_solution where trans_id='1419461'

DECLARE
  V_MONTH VARCHAR2(100);
  V_DATE  VARCHAR2(100);
  V_DAY   VARCHAR2(100);
  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018' ORDER BY IDX_NO;
BEGIN
  FOR V_NUM IN 1 .. 1 LOOP
    V_MONTH := TO_CHAR(SYSDATE - 1, 'YYYYMM');
    V_DATE  := TO_CHAR(SYSDATE - 1, 'YYYYMMDD');
    V_DAY   := TO_CHAR(SYSDATE - 1, 'DD');
    --EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_MAJH_DQ_HZ';
    FOR C1 IN V_AREA LOOP
      --EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_MAJH_DQ_RENT';
      INSERT /*+ APPEND */
      INTO TMP_MAJH_DQ_RENT NOLOGGING
        SELECT USER_NO,
               C1.AREA_NO,
               SALES_MODE,
               TO_CHAR(BEGIN_DATE, 'YYYYMMDD'),
               TO_CHAR(END_DATE, 'YYYYMMDD'),
               COST_PRICE
          FROM (SELECT T.*,
                       ROW_NUMBER() OVER(PARTITION BY USER_NO ORDER BY BEGIN_DATE DESC) RN
                  FROM ODS.O_PRD_USER_DEVICE_RENT_D@HBODS T
                 WHERE T.ACCT_MONTH = V_MONTH
                   AND T.DAY_ID = V_DAY
                   AND AREA_NO = C1.AREA_NO
                   AND BEGIN_DATE > TO_DATE('20161231', 'YYYYMMDD') + 1
                   AND BEGIN_DATE < TO_DATE('20171231', 'YYYYMMDD') + 1
                   AND EXISTS (SELECT 1
                          FROM TMP_MAJH_SALES_01 B
                         WHERE T.SALES_MODE = B.KIND))
         WHERE RN = 1;
      COMMIT;
    END LOOP;
  END LOOP;
END;


select 
a.idx_no,a.kind,count(distinct user_no),count(b.user_no)
 from TMP_MAJH_SALES_01 a,
TMP_MAJH_DQ_RENT b
where a.kind=b.SALES_MODE(+)
group by a.idx_no,a.kind


DECLARE
  V_MONTH VARCHAR2(100);
  V_DATE  VARCHAR2(100);
  V_DAY   VARCHAR2(100);
  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018' ORDER BY IDX_NO;
BEGIN
  FOR V_NUM IN 1 .. 1 LOOP
    V_MONTH := TO_CHAR(SYSDATE - 1, 'YYYYMM');
    V_DATE  := TO_CHAR(SYSDATE - 1, 'YYYYMMDD');
    V_DAY   := TO_CHAR(SYSDATE - 1, 'DD');
    --EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_MAJH_DQ_HZ';
    FOR C1 IN V_AREA LOOP
--使用实例表
      --EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_JF_WEIXI_ZZ_04';
      INSERT INTO MID_JF_WEIXI_ZZ_04
        SELECT A.USER_ID, A.BELONGS_AREA, B.KIND, 0 PAY_FEE
          FROM (SELECT *
                  FROM ACCT_DSG.BF_TRANSFER_ACCEPT_T@HBODS
                 WHERE CITY_CODE = C1.AREA_NO) A,
               TMP_MAJH_SALES_01 B,
               (SELECT *
                  FROM CRM_DSG.SALES_PROMOTION_INST@HBODS
                 WHERE CITY_CODE = C1.AREA_NO
                   AND EFF_DATE >= TO_DATE('201701', 'YYYYMM')
                   AND EFF_DATE < TO_DATE('201801', 'YYYYMM')) D
         WHERE D.PROMOTION_ID = B.KIND
           AND A.PROMOTION_INST_ID = D.PROMOTION_INST_ID;
      COMMIT;
    END LOOP;
  END LOOP;
END;

select 
a.idx_no,a.kind,count(distinct user_id),count(b.user_id)
 from TMP_MAJH_SALES_01 a,
MID_JF_WEIXI_ZZ_04 b
where a.kind=b.prod_offer_id(+)
group by a.idx_no,a.kind


