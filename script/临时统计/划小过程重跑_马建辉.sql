/*create table xxhb_mjh.DM_V_HUAXIAO_INFO_M_bak as
select * from alldm.DM_V_HUAXIAO_INFO_M

create table xxhb_mjh.DM_V_CHANNEL_INFO_M_bak as
select * from alldm.DM_V_CHANNEL_INFO_M*/


--ѭ��ִ�й���
DECLARE
  V_MONTH   VARCHAR2(100);
  V_RETCODE VARCHAR2(100);
  V_RETINFO VARCHAR2(100);
BEGIN
  FOR V_NUM IN 201808 .. 201808 LOOP
    V_MONTH := TO_CHAR(V_NUM);
   -- DW.P_DW_V_USER_SCHOOL_HX_USER_M(V_MONTH, V_RETCODE, V_RETINFO); 
     --DW.P_TMP_V_USER_HUAXIAO_INFO_M(V_MONTH,V_RETCODE, V_RETINFO);
    RPT_HBTELE.P_SJZX_WH_CHANNEL_JF_SCORE_M(V_MONTH, '1',V_RETCODE, V_RETINFO);
    ALLDM.P_dm_V_HUAXIAO_INFO_M(V_MONTH, V_RETCODE, V_RETINFO);
    ALLDM.P_dm_V_CHANNEL_INFO_M(V_MONTH, V_RETCODE, V_RETINFO);  
    MOBILE_CBZS.P_CBZS_DM_KKPI_M_DEV_CHANNEL(V_MONTH, V_RETCODE, V_RETINFO); 
    MOBILE_CBZS.P_CBZS_DM_KKPI_M_INCO_CHANNEL(V_MONTH, V_RETCODE, V_RETINFO);
  END LOOP;    
END;
