--窜出终端质量分析
create table tmp_majh_bt_0807_01 as
select SUBSTR(IN_DATE, 1, 4)acct_month,b.device_number from 
(select a.terminal_code_out,IN_DATE
  from TMP_MAJH_CUAN_0530_04 a
 where SUBSTR(IN_DATE, 1, 4) >= '2015'
 and a.terminal_code_out is not null)a,
 tmp_majh_0328_02 b
 where a.terminal_code_out=b.device_no(+)
 and b.device_no is not null;
 
create table tmp_majh_bt_0807_02 as
select a.*,b.user_no from tmp_majh_bt_0807_01 a ,
(select * from (select user_no,device_number,row_Number()over(partition by device_number order by innet_date desc)rn
from dw.dw_v_user_base_info_user
where acct_month='201806')
where rn=1)b
where a.device_number=b.device_Number(+);


create table tmp_majh_bt_0807_03
(
acct_month varchar2(20),
butie_fee number
)

truncate table TMP_MAJH_BT_0807_03
DECLARE
  V_MONTH VARCHAR2(100);
BEGIN
  FOR V_NUM IN 201401 .. 201412 LOOP
    V_MONTH := TO_CHAR(V_NUM);
    INSERT INTO TMP_MAJH_BT_0807_03
      SELECT B.ACCT_MONTH, sum(B.BUTIE_FEE)
        FROM TMP_MAJH_BT_0807_02 A,
             (SELECT *
                FROM DW.DW_V_USER_BUTIE_M B
               WHERE ACCT_MONTH = V_MONTH
                 AND BUTIE_FLAG = '01') B
       WHERE A.USER_NO = B.USER_NO
       group by B.ACCT_MONTH;
    COMMIT;
  END LOOP;

  FOR V_NUM IN 201501 .. 201512 LOOP
    V_MONTH := TO_CHAR(V_NUM);
    INSERT INTO TMP_MAJH_BT_0807_03
      SELECT B.ACCT_MONTH, sum(B.BUTIE_FEE)
        FROM TMP_MAJH_BT_0807_02 A,
             (SELECT *
                FROM DW.DW_V_USER_BUTIE_M B
               WHERE ACCT_MONTH = V_MONTH
                 AND BUTIE_FLAG = '01') B
       WHERE A.USER_NO = B.USER_NO
       group by B.ACCT_MONTH;
    COMMIT;
  END LOOP;
 
  FOR V_NUM IN 201601 .. 201612 LOOP
    V_MONTH := TO_CHAR(V_NUM);
    INSERT INTO TMP_MAJH_BT_0807_03
      SELECT B.ACCT_MONTH, sum(B.BUTIE_FEE)
        FROM TMP_MAJH_BT_0807_02 A,
             (SELECT *
                FROM DW.DW_V_USER_BUTIE_M B
               WHERE ACCT_MONTH = V_MONTH
                 AND BUTIE_FLAG = '01') B
       WHERE A.USER_NO = B.USER_NO
       group by B.ACCT_MONTH;
    COMMIT;
  END LOOP;

  FOR V_NUM IN 201701 .. 201712 LOOP
    V_MONTH := TO_CHAR(V_NUM);
    INSERT INTO TMP_MAJH_BT_0807_03
      SELECT B.ACCT_MONTH, sum(B.BUTIE_FEE)
        FROM TMP_MAJH_BT_0807_02 A,
             (SELECT *
                FROM DW.DW_V_USER_BUTIE_M B
               WHERE ACCT_MONTH = V_MONTH
                 AND BUTIE_FLAG = '01') B
       WHERE A.USER_NO = B.USER_NO
       group by B.ACCT_MONTH;
    COMMIT;
  END LOOP;
 
  FOR V_NUM IN 201801 .. 201805 LOOP
    V_MONTH := TO_CHAR(V_NUM);
    INSERT INTO TMP_MAJH_BT_0807_03
      SELECT B.ACCT_MONTH, sum(B.BUTIE_FEE)
        FROM TMP_MAJH_BT_0807_02 A,
             (SELECT *
                FROM DW.DW_V_USER_BUTIE_M B
               WHERE ACCT_MONTH = V_MONTH
                 AND BUTIE_FLAG = '01') B
       WHERE A.USER_NO = B.USER_NO
       group by B.ACCT_MONTH;
    COMMIT;
  END LOOP;
END;




select substr(acct_month,1,4),sum(butie_fee) from TMP_MAJH_BT_0807_03 group by substr(acct_month,1,4);


create table TMP_MAJH_BT_0807_04 as
SELECT area_No, user_no, sum(butie_fee) butie_fee
  FROM DW.DW_V_USER_BUTIE_M B
 WHERE ACCT_MONTH between '201401' and  '201807'
   AND BUTIE_FLAG = '01'
 group by area_No, user_no;

--汇总
select d.area_desc,
       count(distinct a.user_no),
       sum(c.butie_fee),
       sum(b.present_fee)
  from TMP_MAJH_BT_0807_02 a,
       tmp_majh_0328_02    b,
       TMP_MAJH_BT_0807_04 c,
       dim.dim_area_no     d
 where a.device_number = b.device_number
   and b.end_date >= '20180730'
   and b.area_no = d.area_no
   and a.user_no = c.user_no
 group by d.area_desc, d.idx_no
 order by d.idx_no

--分区渠道查看
select e.area_desc,d.CHANNEL_NO_DESC,count(distinct a.user_no)
  from TMP_MAJH_BT_0807_02 a,
       tmp_majh_0328_02    b,
       TMP_MAJH_BT_0807_04 c,
       dim.dim_channel_no d,
       dim.dim_area_no e
 where a.device_number = b.device_number
   and b.end_date >= '20180730' 
   and a.user_no = c.user_no
   and b.channel_no=d.channel_no
   and d.area_no=e.area_no
 group by e.area_desc,d.CHANNEL_NO_DESC
 
 --沉淀用户
 create table TMP_MAJH_BT_0807_05 as
 select distinct a.user_no
  from TMP_MAJH_BT_0807_02 a,
       tmp_majh_0328_02    b,
       TMP_MAJH_BT_0807_04 c,
       dim.dim_area_no     d
 where a.device_number = b.device_number
   and b.end_date >= '20180730'
   and b.area_no = d.area_no
   and a.user_no = c.user_no;
   

 create table TMP_MAJH_BT_0807_06 as
select b.* from TMP_MAJH_BT_0807_05 a,
(select area_no,user_no,user_status,channel_no from dw.dw_v_user_base_info_user a where acct_month='201807'
and tele_type='2')b
where a.user_no=b.user_no;

--代理商
select b.agent_name, count(*), count(distinct a.user_no)
  from TMP_MAJH_BT_0807_06 a,
       (select t.area_no,
               t.agent_id,
               t.agent_name,
               t.channel_no,
               t.channel_name
          from rpt_hbtele.dm_busi_channel_build t
         where t.acct_month = '201807') b
 where a.channel_no = b.channel_no
 group by b.agent_name



select b.channel_name, count(*), count(distinct a.user_no)
  from TMP_MAJH_BT_0807_06 a,
       (select t.area_no,
               t.agent_id,
               t.agent_name,
               t.channel_no,
               t.channel_name
          from rpt_hbtele.dm_busi_channel_build t
         where t.acct_month = '201807') b
 where a.channel_no = b.channel_no
 group by b.channel_name
