create table tmp_majh_0409_01 as
SELECT T2.*
  FROM (SELECT T2.*,
               ROW_NUMBER() OVER(PARTITION BY T2.TERMINAL_CODE ORDER BY T2.REG_DATE DESC) RN
          FROM (SELECT '999' AREA_NO,
                       D.RGST_MDL TERMINAL_MODEL,
                       D.ESN TERMINAL_CODE,
                       SUBSTR(D.RGST_DT, 1, 8) REG_DATE
                  FROM ALLDM.BWT_DOWN_RGST_TRMNL_PRVNC@oldhbdw D
                 WHERE  D.RGST_PRVNCE <> '813') T2) T2
 WHERE RN = 1;
 

create table  tmp_majh_0424_02 as 
select 
a.terminal_code 终端串号,
case when b.terminal_code is not null then '省外注册'
  when c.terminal_code is not null then '省内注册' else
    '未知'
    end 省外注册,
 case when b.terminal_code is not null then b.REG_DATE
  when c.terminal_code is not null then to_char(c.reg_date,'yyyymmdd') else
    '未知'
    end 注册时间,
 case when b.terminal_code is not null then b.TERMINAL_MODEL
  when c.terminal_code is not null then c.TERMINAL_MODEL else
    '未知'
    end  终端型号    
 from tmp_majh_0424_01 a,
tmp_majh_0409_01 b,
(select terminal_code,reg_date,TERMINAL_MODEL from dw.dw_v_user_terminal_device_d c
where acct_month='201804'
and day_id='23')c
where a.terminal_code=b.terminal_code(+)
and a.terminal_code=c.terminal_code(+);



select * from tmp_majh_0424_02





