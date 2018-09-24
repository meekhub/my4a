create table tmp_majh_0212_01
(
terminal_code varchar2(20),
idx_no number
)

create table tmp_majh_0212_02 as
select a.*, b.device_no, b.reg_date
  from tmp_majh_0212_01 a,
       (SELECT AREA_NO, TERMINAL_CODE, device_no, reg_date
          FROM DW.DW_V_USER_TERMINAL_DEVICE_D A
         WHERE ACCT_MONTH = '201802'
           and day_id = '11') b
 where a.terminal_code = b.terminal_code(+);
 

create table tmp_majh_0212_03 as
select a.*,b.* from tmp_majh_0212_02 a,
(
select esn,rgst_dt,rgst_prvnce_nm,rgst_latn_nm,accs_nbr
 from alldm.bwt_down_rgst_trmnl_prvnc@oldhbdw where day_id>='20170101'
 and rgst_prvnce<>'813'
)b
where a.terminal_code=b.esn(+);


--导出
select 
terminal_code 串码,  
device_no 省内首次注册号码, 
reg_date 省内首次注册时间,  
rgst_dt 外省注册时间, 
rgst_prvnce_nm 省份属性, 
rgst_latn_nm 省份城市, 
accs_nbr 外省注册号码
 from tmp_majh_0212_03
 order by idx_no





