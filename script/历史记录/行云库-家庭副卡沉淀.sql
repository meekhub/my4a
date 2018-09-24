create table dim_area_no_jt
(
area_no varchar(10), 
std_latn_cd varchar(20), 
area_desc varchar(20), 
idx_no varchar(10), 
area_code varchar(10)
)

insert into mid_family_card_user_info
{
select * from temp_user.TMP_MAJH_FAMILY_OUT_01
}@hbdw

drop table dw_family_card_user_info
create table mid_family_card_user_info
(
latn_id	varchar(12),
cell_phone	varchar(60),
reserv1	varchar(100),
reserv3	varchar(40),
reserv4	varchar(20),
reserv5	varchar(20),
reserv6	varchar(200),
reserv7	varchar(200),
reserv8	varchar(20),
reserv9	varchar(200),
reserv10	varchar(200)
)

drop table dw_family_card_user_info

create table dw_family_card_user_info
(
acct_month varchar(20),
area_no	varchar(12),
cell_phone	varchar(60),
reserv1	varchar(100),
reserv3	varchar(40),
reserv4	varchar(20),
reserv5	varchar(20),
reserv6	varchar(200),
reserv7	varchar(200),
reserv8	varchar(20),
reserv9	varchar(200),
reserv10	varchar(200),
kd_standard_address varchar(600),
customer_name varchar(200),
bandwidth varchar(20),
innet_date varchar(20),
user_dinner_desc varchar(200),
is_bundle varchar(10),
mobile_numbers varchar(60),
mobile_dinners varchar(400),
is_iptv varchar(10),
end_date varchar(20)
)

--沉淀融合手机用户
create table tmp_majh_family_rh
(
kd_number varchar(20),
mobile_number varchar(20),
user_dinner_desc varchar(500)
)

insert into tmp_majh_family_rh
select a.device_number,b.device_number,b.user_dinner_desc
from 
    (select device_number,bundle_id
     from dw_v_user_base_info_user where acct_month='201706'
    and tele_type in ('4','26')
    and is_onnet='是'
    and is_kd_bundle<>'0'
    group by device_number,bundle_id)a
    left join
     (select bundle_id,device_number,user_dinner_desc
     from dw_v_user_base_info_user where acct_month='201706'
    and tele_type in ('2')
    and is_onnet='是'
    and is_kd_bundle<>'0')b
    on a.bundle_id=b.bundle_id
    

--整合手机号码
create table tmp_majh_family_dinners
(
kd_number varchar(20),
numbers varchar(60),
dinners varchar(400)
)

insert into tmp_majh_family_dinners
select 
a.kd_number,
case when c.mobile_number is null then 
b.mobile_number
when c.mobile_number is not null then 
concat(concat(b.mobile_number,'|'),c.mobile_number)
when d.mobile_number is not null then 
concat(concat(concat(concat(b.mobile_number,'|'),c.mobile_number),'|'),d.mobile_number)
end as numbers,
case when c.mobile_number is null then 
b.user_dinner_desc
when c.mobile_number is not null then 
concat(concat(b.user_dinner_desc,'|'),c.user_dinner_desc)
when d.mobile_number is not null then 
concat(concat(concat(concat(b.user_dinner_desc,'|'),c.user_dinner_desc),'|'),d.user_dinner_desc)
end as dinners
 from 
(select kd_number from tmp_majh_family_rh group by kd_number)a
left join
(select * from (select a.*,row_number()over(partition by kd_number order by mobile_number desc)rn from 
tmp_majh_family_rh a) where rn=1)b
on a.kd_number=b.kd_number
left join
(select * from (select a.*,row_number()over(partition by kd_number order by mobile_number desc)rn from 
tmp_majh_family_rh a) where rn=2)c
on a.kd_number=c.kd_number
left join
(select * from (select a.*,row_number()over(partition by kd_number order by mobile_number desc)rn from 
tmp_majh_family_rh a) where rn=3)d
on a.kd_number=d.kd_number

--融合时间沉淀
create table tmp_majh_family_rh_02
(
bundle_id varchar(20),
begin_date  varchar(20),
end_date  varchar(20)
)    

insert into tmp_majh_family_rh_02
{
select bundle_id,to_char(begin_date,'yyyymmdd')begin_date,to_char(end_date,'yyyymmdd')end_date
from dw.DW_BUNDLE_PRODUCT_INFO_month where acct_month='201706'
}@hbdw

select * from tmp_majh_family_rh_02       

select count(*),count(distinct bundle_id) from tmp_majh_family_rh_02

truncate table dw_family_card_user_info
--写入结果表
insert into dw_family_card_user_info
  SELECT 
  		'201706' acct_month,
  		 AREA_no 地市,
         CELL_PHONE  宽带账号,
         RESERV1     手机号,
         RESERV3     运营商,
         RESERV4     转网意愿,
         RESERV5     用户价值,
         RESERV6     终端品牌,
         RESERV7     终端型号,
         RESERV8     是否全网通,
         RESERV9     上市时间,
         RESERV10    卡槽数量,
         c.kd_standard_address 宽带地址,
         c.customer_name 用户姓名,
         c.bandwidth 宽带速率,
         c.innet_date 入网时间,
         c.user_dinner_desc 套餐,
         decode(c.is_kd_bundle,'0','否','是')是否融合,
         d.numbers 融合号码,
         d.dinners 移动业务套餐,
         case when c.is_kd_bundle in ('01','03') then '是' else '否' end 是否加装电视,
         e.end_date
    FROM mid_family_card_user_info A
    join 
    (
    select device_number,KD_STANDARD_ADDRESS,area_no,customer_name,bandwidth,innet_date,user_dinner_desc,
    is_kd_bundle,bundle_id
     from dw_v_user_base_info_user where acct_month='201706'
    and tele_type in ('4','26')
    and is_onnet='是'
    )c
   on a.cell_phone=c.device_number
   left join
   tmp_majh_family_dinners d
   on a.cell_phone=d.kd_number
   left join
   tmp_majh_family_rh_02 e
   on c.bundle_id=e.bundle_id
   

select * from dw_family_card_user_info

SELECT 
  		 acct_month,
  		 AREA_no 地市,
         CELL_PHONE  宽带账号,
         RESERV1     手机号,
         RESERV3     运营商,
         RESERV4     转网意愿,
         RESERV5     用户价值,
         RESERV6     终端品牌,
         RESERV7     终端型号,
         RESERV8     是否全网通,
         RESERV9     上市时间,
         RESERV10    卡槽数量,
         kd_standard_address 宽带地址
 from dw_family_card_user_info
 where area_no='185'




