--沉淀中间表
--DIM.DIM_XIAOQU_SHENTOU
--SELECT A.*, C.XIAOQU_NO, C.XIAOQU_NAME, E.HUAXIAO_NO, E.HUAXIAO_NAME
/* SELECT Z.HUAXIAO_NO, SUM(X.ITV_USER + X.KD_USER) ONNET_USER,SUM(Y.POP_NUM)POP_NUM
 FROM DIM.DIM_XIAOQU_SHENTOU X, DIM.DIM_TOWN_RENKOU Y, DIM.DIM_XIAOQU_HUAXIAO Z
WHERE X.XIAOQU_NO = Z.XIAOQU_NO
AND Z.HUAXIAO_NO=Y.HUAXIAO_NO
GROUP BY Z.HUAXIAO_NO*/




delete from DM_ZERO_BOX_INFO where acct_month='201807'
INSERT INTO DM_ZERO_BOX_INFO
  SELECT '201807' ACCT_MONTH,
         F.AREA_NO,
         F.AREA_DESC,
         G.CITY_NO,
         G.CITY_DESC,
         A.BOX_NAME,
         '' TOWN_NO,
         T.GRADE_3,
         E.HUAXIAO_NO,
         E.HUAXIAO_NAME,
         T.STDADDR_NAME,
         SUM(H.RUZHU_USER) FG_USERS,
         DECODE(SUM(H.RUZHU_USER),
                0,
                0,
                ROUND(SUM(H.KD_USER) / SUM(H.RUZHU_USER), 4)) FG_RATE
    FROM (SELECT * FROM ALLDM_LINBOX_M A WHERE A.STANDARD_ID IS NOT NULL AND STAT_TIME = '2018-08-03') A, --翔龙核对应该是入库有问题
         (SELECT /*+PARALLEL(T,10)*/
           TO_CHAR(ID) ID,
           GRADE_3,
           T.GRADE_0 || '/' || T.GRADE_1 || '/' || T.GRADE_2 || '/' ||
           T.GRADE_3 || '/' || T.GRADE_4 STDADDR_NAME
            FROM DW.DATMT_GIS_STANDARDADDRESS_QE T) T,
         (SELECT * FROM ALLDMCODE.DMCODE_XIAOQU_STD_ADDR_NEW) C,
         DIM.DIM_XIAOQU_HUAXIAO E,
         DIM.DIM_AREA_NO F,
         DIM.DIM_CITY_NO G， 
         (SELECT SUBDISTRICT_ID AS XIAOQU_NO,
                  SUBDISTRICT_NAME AS XIAOQU_NAME,
                  SUM(NET_NUM) KD_USER,
                  SUM(FAMILY_NUM) RUZHU_USER
             FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
            WHERE DAY_ID = '20180731'
            GROUP BY SUBDISTRICT_ID, SUBDISTRICT_NAME) H
         --DIM.DIM_TOWN_RENKOU K
   WHERE A.STANDARD_ID = T.ID
     AND T.STDADDR_NAME = C.STDADDR_NAME
     AND C.XIAOQU_NO = E.XIAOQU_NO
     AND E.AREA_NO = F.AREA_NO
     AND E.CITY_NO = G.CITY_NO
     AND C.XIAOQU_NO = H.XIAOQU_NO(+) 
   GROUP BY F.AREA_NO,
            F.AREA_DESC,
            G.CITY_NO,
            G.CITY_DESC, 
            T.GRADE_3,
            A.BOX_NAME,
            E.HUAXIAO_NO,
            E.HUAXIAO_NAME,
            T.STDADDR_NAME;
          
--SELECT AREA_DESC,COUNT(*) FROM DM_ZERO_BOX_INFO GROUP BY AREA_DESC       


create table DSS_FRAME.DM_ZERO_BOX_INFO as
select *
  from alldm.DM_ZERO_BOX_INFO@hbdw
 where area_no in ('018188017',
                   '018181015',
                   '018182008',
                   '018186016',
                   '018185018',
                   '018180027',
                   '018720009');
                   

SELECT ACCT_MONTH,
       AREA_DESC,
       CITY_DESC,
       BOX_NAME,
       HUAXIAO_NAME,
       STDADDR_NAME,
       TOWN_NO,
       TOWN_DESC，
       FG_USERS,
       FG_RATE
  FROM DSS_FRAME.DM_ZERO_BOX_INFO@HBODS  
 WHERE CITY_desc='东光'
 
 
 唐山	玉田
邯郸	魏县
衡水	景县
石家庄	赞皇
秦皇岛	青龙县
邢台	宁晋县
沧州	东光

 
 select area_desc,city_desc,count(*) from DSS_FRAME.DM_ZERO_BOX_INFO@HBODS  group by area_desc,city_desc
 

--派单
insert into DM_ZERO_BOX_INFO
select * from alldm.DM_ZERO_BOX_INFO@hbdw where acct_month='201807'
 
 
                   

select * from DSS_FRAME.DM_ZERO_BOX_INFO@hbods; 




SELECT A.ACCT_MONTH 账期,
       A.AREA_DESC 地市,
       A.CITY_DESC 区县,
       A.BOX_NAME 零箱体名称,
       A.HUAXIAO_NAME 支局名称,
       A.STDADDR_NAME 标准地址, 
       A.TOWN_DESC 所在村名称， 
       A.FG_USERS 覆盖用户数,
       A.FG_RATE 覆盖率
  FROM ALLDM.DM_ZERO_BOX_INFO    A,
       NEW_ALLDMCODE.DMCODE_AREA B,
       NEW_ALLDMCODE.DMCODE_CITY C
 WHERE A.AREA_NO = B.AREA_NO
   AND A.CITY_NO = C.CITY_NO
   AND A.ACCT_MONTH='201807'
   AND A.AREA_NO='181'
   AND A.CITY_DESC='玉田'
   
   
   
   
   
   
   
   
   
   
   
   
   
   
