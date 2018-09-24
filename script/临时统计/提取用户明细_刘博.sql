select t.*, t.rowid from tmp_majh_dinner_0224_01 t;

select * from tmp_majh_dinner_0224_01 a,dim.dim_user_dinner b
where a.user_dinner=b.user_dinner;

create table tmp_majh_dinner_0224_02 as
select area_no_desc,
       city_no_desc, 
       b.device_number,
       b.user_dinner,
       b.user_dinner_desc,
       PAY_MODE_DESC,
       innet_date,
       user_status_desc
  from tmp_majh_dinner_0224_01 a,
       (select area_no_desc,
               city_no_desc,
               user_no,
               device_number,
               user_dinner,
               user_dinner_desc,
               PAY_MODE_DESC,
               innet_date,
               user_status_desc
          from dw.dw_v_user_base_info_day b
         where acct_month = '201802'
           and day_id = '23'
           and is_onnet='1') b
 where a.user_dinner = b.USER_DINNER;
 
 

create table tmp_majh_dinner_0224_03 as 
select area_no_desc,
       city_no_desc, 
       b.device_number,
       b.user_dinner,
       b.user_dinner_desc,
       a.user_dinner as pkg_dinner,
       PAY_MODE_DESC,
       innet_date,
       user_status_desc
 from 
 (select user_no,user_dinner from dw.dw_v_user_product_info_day a 
 where acct_month='201802'
 and day_id='23'
 and user_dinner in 
 ('1410883','1416992','1408444','1410882')
 and end_date>sysdate)a,
        (select area_no_desc,
               city_no_desc,
               user_no,
               device_number,
               user_dinner,
               user_dinner_desc,
               PAY_MODE_DESC,
               innet_date,
               user_status_desc
          from dw.dw_v_user_base_info_day b
         where acct_month = '201802'
           and day_id = '23'
           and is_onnet='1') b
 where a.user_no = b.user_no;
 
 





