
--首先判断前置两个过程有没有执行完毕，如果执行完毕，再执行下面后续的过程
SELECT *
  FROM ALLDM.ALLDM_EXECUTE_LOG
 WHERE ACCT_MONTH = TO_CHAR(SYSDATE - 1, 'YYYYMMDD')
   AND PROCNAME IN
       ('P_DM_TER_DEVICE_FIRST_D', 'P_DM_TERMINAL_FIRST_D')


==========================================================================================================================================

--经分库 TEMP_USER用户下执行下面语句块
--统计脚本（VIVO X9sPlus，活动时间：7月8日-7月14日，所以从9日-15日每日执行）：

--执行约20-30分钟
DECLARE

BEGIN
  --清理中间表和结果表

  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP170608_ZQP_BKZD_USER_MID';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP170608_ZQP_USER_TER_MID';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP170608_ZQP_USER_FIRST_D';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP170608_ZQP_TERMINAL_FIRST_D';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP170608_ZQP_BKZD_BASE_USER_D';

  --插入目标用户表（活动期间累计用户）
  INSERT INTO TMP170608_ZQP_BKZD_USER_MID
    SELECT ACCT_MONTH,
           DAY_ID,
           AREA_NO,
           AREA_NO_DESC,
           DEVICE_NUMBER,
           USER_NO,
           INNET_DATE,
           IS_OCS,
           IS_VALID,
           USER_STATUS_DESC,
           USER_DINNER,
           USER_DINNER_DESC
      FROM DW.DW_V_USER_BASE_INFO_DAY
     WHERE ACCT_MONTH = TO_CHAR(SYSDATE - 1, 'YYYYMM')
       AND DAY_ID = TO_CHAR(SYSDATE - 1, 'DD')
       AND USER_DINNER IN ('1394904',
                           '1394929',
                           '1394917',
                           '1394919',
                           '1394922',
                           '1419678',
                           '1419645',
                           '1419961',
                           '1413302',
                           '1416516',
                           '1413294',
                           '1411908',
                           '1416471',
                           '1415649')
          --AND TO_CHAR(INNET_DATE, 'YYYYMMDD') >= '20170607' --金立 S10：6月7日至6月13日  
          --AND TO_CHAR(INNET_DATE, 'YYYYMMDD') <= '20170613';
          --AND TO_CHAR(INNET_DATE, 'YYYYMMDD') >= '20170616' --OPPO R11：6月16日至6月21日 
          --AND TO_CHAR(INNET_DATE, 'YYYYMMDD') <= '20170622';
        AND TO_CHAR(INNET_DATE, 'YYYYMMDD') >= '20170708' --VIVO X9sPlus：7月8日-7月14日
        AND TO_CHAR(INNET_DATE, 'YYYYMMDD') <= '20170714';

  COMMIT;

  --将用户入网后的注册信息提取出来，剔除二次卡的历史注册信息
  INSERT INTO TMP170608_ZQP_USER_TER_MID
    SELECT B.*
      FROM (SELECT DEVICE_NUMBER, INNET_DATE
              FROM TMP170608_ZQP_BKZD_USER_MID) A,
           (SELECT TERMINAL_CODE, DEVICE_NO, TERMINAL_MODEL, REG_DATE
              FROM DW.DW_V_USER_TERMINAL_D T
             WHERE ACCT_MONTH = TO_CHAR(SYSDATE - 1, 'YYYYMM')
               AND DAY_ID = TO_CHAR(SYSDATE - 1, 'DD')) B
     WHERE A.DEVICE_NUMBER = B.DEVICE_NO
       AND TO_CHAR(A.INNET_DATE, 'YYYYMMDD') <=
           TO_CHAR(B.REG_DATE, 'YYYYMMDD');
  COMMIT;

  --取用户首次注册：对注册信息按照用户进行升序，取第一条记录，作为用户首次注册
  INSERT INTO TMP170608_ZQP_USER_FIRST_D
    SELECT DEVICE_NO, TERMINAL_CODE, TERMINAL_MODEL, REG_DATE
      FROM (SELECT DEVICE_NO,
                   TERMINAL_CODE,
                   TERMINAL_MODEL,
                   REG_DATE,
                   ROW_NUMBER() OVER(PARTITION BY DEVICE_NO ORDER BY REG_DATE ASC) RN
              FROM TMP170608_ZQP_USER_TER_MID T) A
     WHERE RN = 1
       AND TERMINAL_MODEL = 'VIV-vivo X9s Plus' --VIVO X9sPlus：7月8日-7月14日 
       AND TO_CHAR(REG_DATE, 'YYYYMMDD') >= '20170708' --VIVO X9sPlus：7月8日-7月14日
       AND TO_CHAR(REG_DATE, 'YYYYMMDD') <= '20170714';--用户首次注册时间为活动区间
     COMMIT;

  --取终端首次注册
  INSERT INTO TMP170608_ZQP_TERMINAL_FIRST_D
    SELECT /*+FULL(C)*/
     DEVICE_NO, TERMINAL_CODE, TERMINAL_MODEL, REG_DATE
      FROM ALLDM.DM_TERMINAL_FIRST_D C --终端首次注册
     WHERE ACCT_MONTH = TO_CHAR(SYSDATE - 1, 'YYYYMM')
       AND DAY_ID = TO_CHAR(SYSDATE - 1, 'DD') --昨日全量数据
       AND TERMINAL_MODEL = 'VIV-vivo X9s Plus' --VIVO X9sPlus：7月8日-7月14日 
       AND TO_CHAR(REG_DATE, 'YYYYMMDD') >= '20170708' --VIVO X9sPlus：7月8日-7月14日
       AND TO_CHAR(REG_DATE, 'YYYYMMDD') <= '20170714';--用户首次注册时间为活动区间
  COMMIT;

  --目标数据
  INSERT INTO TMP170608_ZQP_BKZD_BASE_USER_D
    SELECT A.*, B.*
      FROM TMP170608_ZQP_BKZD_USER_MID    A, --活动期间累计入网用户
           TMP170608_ZQP_USER_FIRST_D     B,
           TMP170608_ZQP_TERMINAL_FIRST_D C
     WHERE A.DEVICE_NUMBER = B.DEVICE_NO
       AND B.TERMINAL_CODE = C.TERMINAL_CODE --用户首次注册终端为爆款终端
       AND A.DEVICE_NUMBER = C.DEVICE_NO; --终端首次注册号码为目标号码
    
  COMMIT;

  --沉淀最后用户明细（为了包含特殊场景：前期入网后期注册，所以需排重）
  INSERT INTO TMP170608_ZQP_BKZD_BASE_AIM_U
    SELECT TO_CHAR(SYSDATE - 1, 'YYYYMMDD') OPER_DAY, A.*
      FROM TMP170608_ZQP_BKZD_BASE_USER_D A,
           TMP170608_ZQP_BKZD_BASE_AIM_U  B
     WHERE A.DEVICE_NUMBER = B.DEVICE_NUMBER(+) --剔除已经受理过的号码，防止重复增加包
       AND B.DEVICE_NUMBER IS NULL;

  COMMIT;

END;



==========================================================================================================================================

--以上语句块执行完毕后，执行下面语句，并将数据导出来。
--导出来的结果发给集约组：李丽<15343118065@189.cn>,  时雪娇<18031866773@189.cn>，抄送给渠道部负责人范倩倩：18931177153@189.cn，由集约组完成0元5G省内流量（30天）的销售品添加。

  SELECT 
  oper_day,  
area_no, 
area_no_desc, 
device_number, 
user_no, 
innet_date, 
is_ocs, 
is_valid, 
user_status_desc, 
user_dinner, 
user_dinner_desc,  
terminal_code, 
terminal_model, 
reg_date
   FROM TMP170608_ZQP_BKZD_BASE_AIM_U WHERE OPER_DAY  = TO_CHAR(SYSDATE - 1, 'YYYYMMDD') ;
