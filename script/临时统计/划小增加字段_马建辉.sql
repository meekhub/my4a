alter table DW_V_USER_HUAXIAO_INFO_M add qfcs_fee number;
alter table DW_V_USER_HUAXIAO_INFO_M add xmfc_fee number;


 COMMENT ON COLUMN DW.DW_V_USER_HUAXIAO_INFO_M.qfcs_fee IS '欠费冲收';
 
 COMMENT ON COLUMN DW.DW_V_USER_HUAXIAO_INFO_M.xmfc_fee IS '项目分成';
