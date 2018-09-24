CREATE TABLE "ALLDM"."INTEGRAL_SYS_WEIXI_JF_DETAIL" 
   (  "ACCT_MONTH" VARCHAR2(600), 
  "AREA_NO" VARCHAR2(300), 
  "CITY_NO" VARCHAR2(300), 
  "TELE_TYPE" VARCHAR2(300), 
  "AGENT_ID" VARCHAR2(100), 
  "AGENT_NAME" VARCHAR2(1000), 
  "CHANNEL_NO" VARCHAR2(300), 
  "USER_NO" VARCHAR2(300), 
  "DEVICE_NUMBER" VARCHAR2(300), 
  "USER_DINNER" VARCHAR2(300), 
  "LOW_VALUE" NUMBER
   ) PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
  STORAGE(
  BUFFER_POOL DEFAULT)
  TABLESPACE "DM_TBS_001" 
  PARTITION BY RANGE ("ACCT_MONTH") 
  SUBPARTITION BY LIST ("AREA_NO") 
  SUBPARTITION TEMPLATE ( 
    SUBPARTITION "SUBPART_180" values ( '180' ), 
    SUBPARTITION "SUBPART_181" values ( '181' ), 
    SUBPARTITION "SUBPART_182" values ( '182' ), 
    SUBPARTITION "SUBPART_183" values ( '183' ), 
    SUBPARTITION "SUBPART_184" values ( '184' ), 
    SUBPARTITION "SUBPART_185" values ( '185' ), 
    SUBPARTITION "SUBPART_186" values ( '186' ), 
    SUBPARTITION "SUBPART_187" values ( '187' ), 
    SUBPARTITION "SUBPART_188" values ( '188' ), 
    SUBPARTITION "SUBPART_189" values ( '189' ), 
    SUBPARTITION "SUBPART_720" values ( '720' ) ) 
 (PARTITION "PART_201607"  VALUES LESS THAN ('201608') 
PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
  STORAGE(
  BUFFER_POOL DEFAULT)
  TABLESPACE "DM_TBS_001" ) ;
  
  
  
  
  DECLARE
  V_DATE       VARCHAR2(100);
  V_NEXT_MONTH VARCHAR2(20);
BEGIN
  FOR V_NUM IN 201701 .. 201712 LOOP
    V_DATE       := TO_CHAR(V_NUM);
    V_NEXT_MONTH := TO_CHAR(ADD_MONTHS(TO_DATE(V_DATE, 'YYYYMM'), 1),
                            'YYYYMM');
    EXECUTE IMMEDIATE 'ALTER TABLE INTEGRAL_SYS_WEIXI_JF_DETAIL ADD PARTITION PART_' ||
                      V_DATE || ' VALUES LESS THAN(''' || V_NEXT_MONTH ||
                      ''') TABLESPACE BWT_TBS_001 COMPRESS';
  END LOOP;
END;
