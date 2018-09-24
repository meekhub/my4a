 SELECT c.area_desc,sum(case when user_no='0' then CHARGE else 0 end),sum(case when user_no<>'0' then CHARGE else 0 end)
        FROM DW.DW_V_USER_COMMISION_XMFC B,dim.dim_area_no c
       WHERE ACCT_MONTH = '201802'
         AND IF_PROJECT = '1' 
         and IF_FINANCIAL='1'
         and b.area_no=c.area_no
         group by c.area_desc,c.idx_no
         order by c.idx_no
