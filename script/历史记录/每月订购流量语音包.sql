select x.user_dinner,x.user_dinner_desc,t.user_num from tmp_majh_user_dinner t ,dim.dim_user_dinner x
where t.user_dinner=x.user_dinner 
and x.dinner_type=3
and (x.user_dinner_desc like '%Á÷Á¿%' or x.user_dinner_desc like '%ÓïÒô%')



select * from tmp_majh_user_dinner


select * from dw_v_user_product_info_day where acct_day='20170730' 
and begin_date='20170710' 
and area_no='188'
and user_dinner='1411051'
and user_no='530604811'




