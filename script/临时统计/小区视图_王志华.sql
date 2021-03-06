SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME,
       ADDR5_ID,
       case when instr(ADDR5_ID,',',1,1)=0 then ADDR5_ID else  substr(ADDR5_ID,1,instr(ADDR5_ID,',',1,1)-1) end as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   union all
 SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME, 
       ADDR5_ID,
       substr(ADDR5_ID,instr(ADDR5_ID,',',1,1)+1,instr(ADDR5_ID,',',1,2)-instr(ADDR5_ID,',',1,1)-1) as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   and   instr(ADDR5_ID,',',1,2)>0
    union all
 SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME, 
       ADDR5_ID,
       substr(ADDR5_ID,instr(ADDR5_ID,',',1,2)+1,instr(ADDR5_ID,',',1,3)-instr(ADDR5_ID,',',1,2)-1) as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   and   instr(ADDR5_ID,',',1,3)>0  
    union all
 SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME, 
       ADDR5_ID,
       substr(ADDR5_ID,instr(ADDR5_ID,',',1,3)+1,instr(ADDR5_ID,',',1,4)-instr(ADDR5_ID,',',1,3)-1) as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   and   instr(ADDR5_ID,',',1,4)>0  
    union all
 SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME, 
       ADDR5_ID,
       substr(ADDR5_ID,instr(ADDR5_ID,',',1,4)+1,instr(ADDR5_ID,',',1,5)-instr(ADDR5_ID,',',1,4)-1) as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   and   instr(ADDR5_ID,',',1,5)>0  
    union all
 SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME, 
       ADDR5_ID,
       substr(ADDR5_ID,instr(ADDR5_ID,',',1,5)+1,instr(ADDR5_ID,',',1,6)-instr(ADDR5_ID,',',1,5)-1) as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   and   instr(ADDR5_ID,',',1,6)>0  
    union all
 SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME, 
       ADDR5_ID,
       substr(ADDR5_ID,instr(ADDR5_ID,',',1,6)+1,instr(ADDR5_ID,',',1,7)-instr(ADDR5_ID,',',1,6)-1) as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   and   instr(ADDR5_ID,',',1,7)>0  
    union all
 SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME, 
       ADDR5_ID,
       substr(ADDR5_ID,instr(ADDR5_ID,',',1,7)+1,instr(ADDR5_ID,',',1,8)-instr(ADDR5_ID,',',1,7)-1) as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   and   instr(ADDR5_ID,',',1,8)>0  
    union all
 SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME, 
       ADDR5_ID,
       substr(ADDR5_ID,instr(ADDR5_ID,',',1,8)+1,instr(ADDR5_ID,',',1,9)-instr(ADDR5_ID,',',1,8)-1) as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   and   instr(ADDR5_ID,',',1,9)>0  
     union all
 SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME, 
       ADDR5_ID,
       substr(ADDR5_ID,instr(ADDR5_ID,',',1,9)+1,instr(ADDR5_ID,',',1,10)-instr(ADDR5_ID,',',1,9)-1) as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   and   instr(ADDR5_ID,',',1,10)>0  
     union all
 SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME, 
       ADDR5_ID,
       substr(ADDR5_ID,instr(ADDR5_ID,',',1,10)+1,instr(ADDR5_ID,',',1,11)-instr(ADDR5_ID,',',1,10)-1) as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   and   instr(ADDR5_ID,',',1,11)>0  
     union all
 SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME, 
       ADDR5_ID,
       substr(ADDR5_ID,instr(ADDR5_ID,',',1,11)+1,instr(ADDR5_ID,',',1,12)-instr(ADDR5_ID,',',1,11)-1) as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   and   instr(ADDR5_ID,',',1,12)>0 
     union all
 SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME, 
       ADDR5_ID,
       substr(ADDR5_ID,instr(ADDR5_ID,',',1,12)+1,instr(ADDR5_ID,',',1,13)-instr(ADDR5_ID,',',1,12)-1) as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   and   instr(ADDR5_ID,',',1,13)>0
     union all
 SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME, 
       ADDR5_ID,
       substr(ADDR5_ID,instr(ADDR5_ID,',',1,13)+1,instr(ADDR5_ID,',',1,14)-instr(ADDR5_ID,',',1,13)-1) as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   and   instr(ADDR5_ID,',',1,14)>0 
     union all
 SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME, 
       ADDR5_ID,
       substr(ADDR5_ID,instr(ADDR5_ID,',',1,14)+1,instr(ADDR5_ID,',',1,15)-instr(ADDR5_ID,',',1,14)-1) as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   and   instr(ADDR5_ID,',',1,15)>0  
     union all
 SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME, 
       ADDR5_ID,
       substr(ADDR5_ID,instr(ADDR5_ID,',',1,15)+1,instr(ADDR5_ID,',',1,16)-instr(ADDR5_ID,',',1,15)-1) as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   and   instr(ADDR5_ID,',',1,16)>0  
     union all
 SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME, 
       ADDR5_ID,
       substr(ADDR5_ID,instr(ADDR5_ID,',',1,16)+1,instr(ADDR5_ID,',',1,17)-instr(ADDR5_ID,',',1,16)-1) as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   and   instr(ADDR5_ID,',',1,17)>0  
     union all
 SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME, 
       ADDR5_ID,
       substr(ADDR5_ID,instr(ADDR5_ID,',',1,17)+1,instr(ADDR5_ID,',',1,18)-instr(ADDR5_ID,',',1,17)-1) as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   and   instr(ADDR5_ID,',',1,18)>0  
     union all
 SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME, 
       ADDR5_ID,
       substr(ADDR5_ID,instr(ADDR5_ID,',',1,18)+1,instr(ADDR5_ID,',',1,19)-instr(ADDR5_ID,',',1,18)-1) as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   and   instr(ADDR5_ID,',',1,19)>0  
      union all
 SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME, 
       ADDR5_ID,
       substr(ADDR5_ID,instr(ADDR5_ID,',',1,19)+1,instr(ADDR5_ID,',',1,20)-instr(ADDR5_ID,',',1,19)-1) as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   and   instr(ADDR5_ID,',',1,20)>0  
       union all
 SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME, 
       ADDR5_ID,
       substr(ADDR5_ID,instr(ADDR5_ID,',',1,20)+1,instr(ADDR5_ID,',',1,21)-instr(ADDR5_ID,',',1,20)-1) as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   and   instr(ADDR5_ID,',',1,21)>0  
       union all
 SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME, 
       ADDR5_ID,
       substr(ADDR5_ID,instr(ADDR5_ID,',',1,21)+1,instr(ADDR5_ID,',',1,22)-instr(ADDR5_ID,',',1,21)-1) as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   and   instr(ADDR5_ID,',',1,22)>0  
       union all
 SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME, 
       ADDR5_ID,
       substr(ADDR5_ID,instr(ADDR5_ID,',',1,22)+1,instr(ADDR5_ID,',',1,23)-instr(ADDR5_ID,',',1,22)-1) as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   and   instr(ADDR5_ID,',',1,23)>0  
       union all
 SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME, 
       ADDR5_ID,
       substr(ADDR5_ID,instr(ADDR5_ID,',',1,23)+1,instr(ADDR5_ID,',',1,24)-instr(ADDR5_ID,',',1,23)-1) as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   and   instr(ADDR5_ID,',',1,24)>0  
       union all
 SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME, 
       ADDR5_ID,
       substr(ADDR5_ID,instr(ADDR5_ID,',',1,24)+1,instr(ADDR5_ID,',',1,25)-instr(ADDR5_ID,',',1,24)-1) as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   and   instr(ADDR5_ID,',',1,25)>0 
        union all
 SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME, 
       ADDR5_ID,
       substr(ADDR5_ID,instr(ADDR5_ID,',',1,25)+1,instr(ADDR5_ID,',',1,26)-instr(ADDR5_ID,',',1,25)-1) as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   and   instr(ADDR5_ID,',',1,26)>0 
        union all
 SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME, 
       ADDR5_ID,
       substr(ADDR5_ID,instr(ADDR5_ID,',',1,26)+1,instr(ADDR5_ID,',',1,27)-instr(ADDR5_ID,',',1,26)-1) as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   and   instr(ADDR5_ID,',',1,27)>0 
         union all
 SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME, 
       ADDR5_ID,
       substr(ADDR5_ID,instr(ADDR5_ID,',',1,29)+1,instr(ADDR5_ID,',',1,30)-instr(ADDR5_ID,',',1,29)-1) as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   and   instr(ADDR5_ID,',',1,30)>0 
          union all
 SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME, 
       ADDR5_ID,
       substr(ADDR5_ID,instr(ADDR5_ID,',',1,31)+1,instr(ADDR5_ID,',',1,32)-instr(ADDR5_ID,',',1,31)-1) as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   and   instr(ADDR5_ID,',',1,32)>0 
           union all
 SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME, 
       ADDR5_ID,
       substr(ADDR5_ID,instr(ADDR5_ID,',',1,49)+1,instr(ADDR5_ID,',',1,50)-instr(ADDR5_ID,',',1,49)-1) as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   and   instr(ADDR5_ID,',',1,50)>0 
            union all
 SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME, 
       ADDR5_ID,
       substr(ADDR5_ID,instr(ADDR5_ID,',',1,50)+1,instr(ADDR5_ID,',',1,51)-instr(ADDR5_ID,',',1,50)-1) as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   and   instr(ADDR5_ID,',',1,51)>0 
             union all
 SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME, 
       ADDR5_ID,
       substr(ADDR5_ID,instr(ADDR5_ID,',',1,59)+1,instr(ADDR5_ID,',',1,60)-instr(ADDR5_ID,',',1,59)-1) as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   and   instr(ADDR5_ID,',',1,60)>0 
              union all
 SELECT CITY_NAME,
       AREA_NAME,
       GRID_ID,
       GRID_NAME,
       CHIP_ID,
       CHIP_NAME, 
       ADDR5_ID,
       substr(ADDR5_ID,instr(ADDR5_ID,',',1,74)+1,instr(ADDR5_ID,',',1,75)-instr(ADDR5_ID,',',1,74)-1) as ADDR5_ID,
       SUBDISTRICT_ID,
       SUBDISTRICT_NAME,
       ROOM_NUM,
       NET_NUM
  FROM XQGF.ST_XQGF_LEADER_VIEW_SUBDIS_DAY@YXSP
 WHERE DAY_ID = '20180513'
   AND CITY_NAME = '邢台' 
   and   instr(ADDR5_ID,',',1,75)>0 
