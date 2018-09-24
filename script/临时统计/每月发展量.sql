create table xxhb_mjh.tmp_majh_new_user as
select 
a.AREA_NO_DESC,a.CITY_NO_DESC,a.CHANNEL_NO,a.CHANNEL_NO_DESC,
count(case when tele_type='2' then user_no end)c1,
count(case when tele_type='2' and a.SALES_MODE is not null then user_no end)c2,
count(case when tele_type in ('4','26') then user_no end)c3,
count(case when tele_type='72' then user_no end)c4
 from dw.dw_v_user_base_info_user a
where acct_month='201808' 
and is_new='1'
and tele_type in ('2','4','26','72') 
group by a.AREA_NO_DESC,a.CITY_NO_DESC,a.CHANNEL_NO,a.CHANNEL_NO_DESC;



select 
area_no_desc ����, 
city_no_desc ����, 
channel_no ��������, 
channel_no_desc ��������, 
c1 �ƶ�, 
c2 ���к�Լ, 
c3 ���, 
c4 ����
 from  xxhb_mjh.tmp_majh_new_user t
