create table tmp_majh_0402_03 as
select a.*,b.RGST_PRVNCE_NM,b.ACCS_NBR,b.day_id,b.RGST_BRAND
  from tmp_majh_0402_01 a,
       (
        select * from alldm.bwt_down_rgst_trmnl_prvnc where day_id between '20180212' and '20180331'
        union all
        select * from alldm.bwt_down_rgst_trmnl_prvnc@oldhbdw where day_id between '20180101' and '20180211'
        ) b --本省出库终端在他省注册
 where a.terminal_code = b.esn(+)  
 
 
 select * from 
(select t.*,row_number()over(partition by t.idx_no order by 1)rn from  tmp_majh_0402_03 t )
where rn=1
