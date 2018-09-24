create table tmp_majh_trm_0706_02 as
SELECT a.*,
       SUBSTR(RGST_DT, 1, 6) REG_DATE
  FROM 
  tmp_majh_trm_0706_01 a,
  (SELECT *
          FROM ALLDM.BWT_DOWN_RGST_TRMNL_PRVNC@OLDHBDW D
         WHERE DAY_ID <= '20180211'
           AND SUBSTR(D.RGST_DT, 1, 4) >='2014'
           AND D.RGST_PRVNCE <> '813'
        UNION ALL
        SELECT *
          FROM ALLDM.BWT_DOWN_RGST_TRMNL_PRVNC D
         WHERE DAY_ID >= '20180212'
           AND SUBSTR(D.RGST_DT, 1, 4) >='2014'
           AND D.RGST_PRVNCE <> '813')b
        where a.terminal_code=b.esn(+)   
        
        
        
        
        
create table tmp_majh_trm_0709_02 as
SELECT a.*,
       SUBSTR(RGST_DT, 1, 6) REG_DATE
  FROM 
  tmp_majh_trm_0709_01 a,
  (SELECT *
          FROM ALLDM.BWT_DOWN_RGST_TRMNL_PRVNC@OLDHBDW D
         WHERE DAY_ID <= '20180211'
           AND SUBSTR(D.RGST_DT, 1, 4) >='2014'
           AND D.RGST_PRVNCE <> '813'
        UNION ALL
        SELECT *
          FROM ALLDM.BWT_DOWN_RGST_TRMNL_PRVNC D
         WHERE DAY_ID >= '20180212'
           AND SUBSTR(D.RGST_DT, 1, 4) >='2014'
           AND D.RGST_PRVNCE <> '813')b
        where a.terminal_code=b.esn(+)  
        


select * from 
(select t.*,row_number()over(partition by idx_no order by t.reg_date desc)rn from tmp_majh_trm_0709_02 t )
where rn=1













