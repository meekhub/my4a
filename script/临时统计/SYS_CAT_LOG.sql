CREATE OR REPLACE VIEW SYS_CAT_LOG AS
SELECT SUBSTR(T.CREATE_DATE, 1, 8) AS DAY_ID,
       NVL(Y.ATTR_VALUE, '018') AS AREA_NO,
       '1' SYS_KIND,
       SUBSTR(MENU_PATH, INSTR(MENU_PATH, '>>', -1) + 2) REPORT_NAME,
       SUBSTR(MENU_PATH, 7, LENGTH(MENU_PATH)) REPORT_PATH,
       T.USER_ID,
       X.OA_UID,
       X.USER_NAME,
       X.MEMO,
       X.MOBILE,
       '' HUAXIAO_TYPE,
       '' HUAXIAO_TYPE_NAME,
       '' HUAXIAO_NO,
       '' HUAXIAO_NAME,
       T.CREATE_DATE as LOGIN_DATE
  FROM DSS_FRAME.E_OPERATION_LOG@HBODS T,
       (SELECT T.RESOURCES_ID,
               SYS_CONNECT_BY_PATH(T.RESOURCES_NAME, '>>') MENU_PATH,
               T.ORD
          FROM DSS_FRAME.E_MENU@HBODS T
         START WITH T.RESOURCES_ID = '0'
        CONNECT BY PRIOR T.RESOURCES_ID = T.PARENT_ID) M,
       DSS_FRAME.E_USER@HBODS X,
       (SELECT A.*
          FROM DSS_FRAME.E_USER_ATTRIBUTE@HBODS A
         WHERE ATTR_CODE = 'AREA_NO') Y
 WHERE T.MENU_ID = M.RESOURCES_ID
   AND T.USER_ID = X.USER_ID
   AND SUBSTR(T.CREATE_DATE, 1, 8) >= '20180101'
   AND X.USER_ID = Y.USER_ID(+)
UNION ALL
--承包助手
SELECT TO_CHAR(T.CREATE_DATE, 'YYYYMMDD'),
       NVL(DECODE(Y.ATTR_VALUE,'178','187','-1','018',Y.ATTR_VALUE), '018'),
       '3' SYS_KIND,
       SUBSTR(MENU_PATH, INSTR(MENU_PATH, '>>', -1) + 2) REPORT_NAME,
       SUBSTR(MENU_PATH, 7, LENGTH(MENU_PATH)) MENU_PATH,
       T.USER_ID,
       X.OA_UID,
       X.USER_NAME,
       X.MEMO,
       X.MOBILE,
       T.HUAXIAO_TYPE,
       T.HUAXIAO_TYPE_NAME,
       T.HUAXIAO_NO,
       T.HUAXIAO_NAME,
       TO_CHAR(T.CREATE_DATE, 'YYYYMMDDHH24MISS')
  FROM (SELECT T.*,
               X.HUAXIAO_NO,
               X.HUAXIAO_NAME,
               X.HUAXIAO_TYPE,
               X.HUAXIAO_TYPE_NAME
          FROM NEW_MOBILE_CBZS.E_OPERATION_LOG T, DIM.DIM_HUAXIAO_INFO X
         WHERE T.USER_ID = X.MANAGER_LOGINID(+)) T,
       (SELECT T.RESOURCES_ID,
               SYS_CONNECT_BY_PATH(T.RESOURCES_NAME, '>>') MENU_PATH,
               T.ORD
          FROM NEW_MOBILE_CBZS.E_MENU T
         START WITH T.RESOURCES_ID = '0'
        CONNECT BY PRIOR T.RESOURCES_ID = T.PARENT_ID) M,
       DSS_FRAME.E_USER@HBODS X,
       (SELECT A.*
          FROM NEW_MOBILE_CBZS.E_USER_ATTRIBUTE A
         WHERE ATTR_CODE = 'AREA_NO') Y
 WHERE T.MENU_ID = M.RESOURCES_ID
   AND T.USER_ID = X.USER_ID
   AND to_char(T.CREATE_DATE, 'yyyymmdd') >= '20180101'
   AND X.USER_ID = Y.USER_ID(+)

   UNION ALL
   --手机经分
  SELECT TO_CHAR(T.TIME, 'YYYYMMDD') DAY_ID,
         FUNC_GET_AREA_FROM_DEPT(D.USER_UMO_NAME),
         '2',
         T.ACTION,
         SUBSTR(T.ACTION, 3, INSTR(T.ACTION, '一级') - 3),
         T.ACTION,
         D.ISPIRE_STAFFID,
         D.USER_NAME,
         D.USER_UMOU_NAME,
         D.CTPREFERREDMOBILE,
         '',
         '',
         '',
         '',
         TO_CHAR(T.TIME,'YYYYMMDDHH24MISS')
    FROM NEW_MOBDSS.HISTORY_LOG T, CS_DSS.OA_ORG_USER_NAME_MULU@HBODS D
   WHERE T.OA_UID = D.USER_ID --和实际OA关联，剔除了测试账号
     AND TO_CHAR(T.TIME, 'YYYYMMDD') >= '20180101'
     AND T.ACTION_TYPE = '4'
     AND T.ACTION LIKE '查看%一级%';
comment on column SYS_CAT_LOG.DAY_ID is '日期';
comment on column SYS_CAT_LOG.AREA_NO is '地市';
comment on column SYS_CAT_LOG.SYS_KIND is '分类 1、决策支持专家；2、手机经分 ；3、承包助手';
comment on column SYS_CAT_LOG.REPORT_NAME is '报表名称';
comment on column SYS_CAT_LOG.REPORT_PATH is '报表路径';
comment on column SYS_CAT_LOG.USER_ID is '访问者经分ID';
comment on column SYS_CAT_LOG.OA_UID is 'OA ID';
comment on column SYS_CAT_LOG.USER_NAME is '姓名';
comment on column SYS_CAT_LOG.MEMO is '部门';
comment on column SYS_CAT_LOG.MOBILE is '手机号';
comment on column SYS_CAT_LOG.HUAXIAO_TYPE is '划小类型';
comment on column SYS_CAT_LOG.HUAXIAO_TYPE_NAME is '划小类型名称';
comment on column SYS_CAT_LOG.HUAXIAO_NO is '划小编码';
comment on column SYS_CAT_LOG.HUAXIAO_NAME is '划小名称';
comment on column SYS_CAT_LOG.LOGIN_DATE is '登陆时间';
