/*select t.*, t.rowid from tmp_majh_trm_0417_01 t

create table TMP_MAJH_0417_02 as
select * from TMP_MAJH_DQ_RENT where 1=2;
*/

truncate table TMP_MAJH_0417_02

      INSERT /*+ APPEND */
      INTO TMP_MAJH_0417_02 NOLOGGING
        SELECT USER_NO,
               AREA_NO,
               SALES_MODE,
               TO_CHAR(BEGIN_DATE, 'YYYYMMDDHH24MISS'),
               TO_CHAR(END_DATE, 'YYYYMMDDHH24MISS'),
               COST_PRICE,
               device_no��
               user_dinner,
               device_type,
               device_number,
               channel_no,
               to_char(SALESINST_CREATE_DATE,'yyyymmdd') create_date
          FROM (SELECT T.*,
                       ROW_NUMBER() OVER(PARTITION BY USER_NO ORDER BY BEGIN_DATE DESC) RN
                  FROM ODS.O_PRD_USER_DEVICE_RENT_D@HBODS T
                 WHERE T.ACCT_MONTH = '201808'
                   AND T.DAY_ID = '26' 
                   AND (END_DATE > sysdate or END_DATE is null))
         WHERE RN = 1;
      COMMIT;
  

    create table tmp_trm_device_type as
   select distinct RESOURCE_MANUFACTURER,RESOURCE_KIND_NAME,RESOURCE_KIND_NO,a.RESOURCE_KIND_ID from tmp_majh_trm_0810_01 a, 
   (SELECT *
                  FROM (SELECT TRIM(RESOURCE_MANUFACTURER) RESOURCE_MANUFACTURER,
                               TRIM(RESOURCE_KIND_ID) RESOURCE_KIND_ID,
                               TRIM(RESOURCE_KIND_NO) RESOURCE_KIND_NO,
                               TRIM(RESOURCE_KIND_NAME) RESOURCE_KIND_NAME,
                               ROW_NUMBER() OVER(PARTITION BY RESOURCE_KIND_NO ORDER BY RESOURCE_KIND_ID DESC) RN
                          FROM DSG_STAGE.IR_GET_RESOURCE_KIND_T F) F
                 WHERE RN = 1)b
                 where a.RESOURCE_KIND_ID=b.RESOURCE_KIND_ID;

--����
CREATE TABLE TMP_TRM_0417 AS 
SELECT A.CREATE_DATE,
       A.AREA_NO,
       B.RESOURCE_KIND_NAME DEVCIE_NAME,
       B.RESOURCE_MANUFACTURER,
       B.RESOURCE_KIND_NAME,
       B.RESOURCE_KIND_ID,
       A.DEVICE_NO,
       A.DEVICE_NUMBER,
       A.CHANNEL_NO,
       BEGIN_DATE��
       END_DATE
  FROM TMP_MAJH_0417_02 A, TMP_TRM_DEVICE_TYPE B
 WHERE A.DEVICE_TYPE = B.RESOURCE_KIND_NO;
 
 
  create table tmp_trm_0417_2 as 
select a.create_date ��������,
       a.area_no,
       func_get_xiongan_area_no(a.area_no,c.CITY_NO) area_no_new,
       city_no_desc,
       a.RESOURCE_MANUFACTURER Ʒ��,
       a.resource_kind_name �ͺ�,
       a.resource_kind_id   �ն˱���,
       a.device_no          ����,
       a.device_number      ��Լ�ֻ���,
       a.begin_date �����ʼ����,
       a.end_date �����������,
       b.CHANNEL_NO ����,
       b.channel_name ��������,
       b.AGENT_ID ������ID,
       b.AGENT_NAME ����������, 
       case when c.USER_DINNER_DESC like '%��װ%' then '��' else '��' end �Ƿ�����,
       c.USER_DINNER_DESC �ײ�
  from tmp_trm_0417 a,
  (select * from rpt_hbtele.DM_BUSI_CHANNEL_BUILD a where a.acct_month='201807')b,
  (
  select area_no_desc,user_no, device_number,user_dinner_desc,city_no,city_no_desc
    from dw.dw_v_user_base_info_day c
   where acct_month = '201808'
   and day_id='26'
     and is_onnet = '1'
     and tele_type = '2' 
  )c
  where a.channel_no=b.channel_no(+)
  and a.device_number=c.device_number(+);

--����
SELECT ��������,
       B.AREA_DESC    ����,
       B.CITY_NO_DESC ����,
       Ʒ��,
       �ͺ�,
       �ն˱���,
       ����,
       ��Լ�ֻ���,
       �����ʼ����,
       �����������,
       ����,
       ��������,
       ������ID,
       ����������,
       �Ƿ�����,
       �ײ�
  FROM TMP_TRM_0417_2 A, DIM.DIM_AREA_NO B
 WHERE A.AREA_NO = B.AREA_NO
   AND A.�������� LIKE '201807%'
  
  
  
create table tmp_majh_0604_01 as
select a.*,
       case
         when a.���� = c.terminal_code then
          '��'
         else
          '��'
       end is_fit,
       case
         when b.ALL_JF_FLUX > 50 then
          '��'
         else
          '��'
       end is_over_50
  from tmp_trm_0417_2 a,
       (select area_no_desc,
               user_no,
               device_number,
               user_dinner_desc,
               city_no,
               city_no_desc,
               ALL_JF_FLUX
          from dw.dw_v_user_base_info_user c
         where acct_month = '201807'
           and is_onnet = '1'
           and tele_type = '2') b,
       (select device_no, terminal_code
          from dw.dw_v_user_terminal_d c
         where acct_month = '201807'
           and day_id = '10'
           and to_char(reg_date, 'yyyymm') >= '201806'
         group by device_no, terminal_code) c
 where a.��Լ�ֻ��� = b.device_number(+)
   and a.��Լ�ֻ��� = c.device_no(+)
  

select ��������,
       case
         when city_no_desc in ('����', '����', '�ݳ�') then
          '�۰�'
         else
          b.area_desc
       end ����,
       city_no_desc ����,
       Ʒ��,
       �ͺ�,
       �ն˱���,
       ����,
       ��Լ�ֻ���,
       �����ʼ����,
       �����������,
       ����,
       ��������,
       ������id,
       ����������,
       �Ƿ������� �ײ�,
       IS_FIT �Ƿ�������һ�β���ƥ��,
       IS_OVER_50 ������4G�����Ƿ����50M
  from (select *
          from (select a.*,
                       row_number() over(partition by a.���� order by a.�������� desc) rn
                  from tmp_majh_0604_01 a)
         where rn = 1) a,
       dim.dim_area_no_new b
 where a.area_no = b.area_no
   and substr(a.�����ʼ����, 1, 8) >= '20180601'
   and substr(a.��������, 1, 6) = '201806'
   and months_between(to_date(nvl(substr(�����������, 1, 6), '202801'),
                              'yyyymm'),
                      to_date(substr(�����ʼ����, 1, 6), 'yyyymm')) >= 24







