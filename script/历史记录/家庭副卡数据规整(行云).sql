drop table tmp_majh_family_out_0830
create table tmp_majh_family_out_0830
(
latn_id	varchar(12),
cell_phone	varchar(1000),
reserv1	varchar(4000),
reserv3	varchar(40),
reserv4	varchar(20),
reserv5	varchar(20),
reserv6	varchar(4000),
reserv7	varchar(4000),
reserv8	varchar(20),
reserv9	varchar(4000),
reserv10	varchar(4000)

)

insert into tmp_majh_family_out_0830
{
select * from temp_user.tmp_majh_family_out_0830
}@hbdw


drop table tmp_majh_family_out_0830_2
create table tmp_majh_family_out_0830_2
(
acct_month varchar(20),
area_no varchar(20),
city_no varchar(100),
cell_phone varchar(300),
RESERV1 varchar(4000), 
RESERV3 varchar(200),
RESERV4 varchar(200),
RESERV5 varchar(200),
RESERV6 varchar(4000),
RESERV7 varchar(4000),
RESERV8 varchar(20),
RESERV9 varchar(4000),
RESERV10 varchar(4000)
)







     insert into tmp_majh_family_out_0830_2
    select 
        '201708',
        b.area_no,
        b.city_no,
         CELL_PHONE  宽带账号,
         RESERV1     手机号,
         RESERV3     运营商,
         RESERV4     转网意愿,
         RESERV5     用户价值,
         RESERV6     终端品牌,
         RESERV7     终端型号,
         RESERV8     是否全网通,
         RESERV9     上市时间,
         RESERV10    卡槽数量
    from 
    tmp_majh_family_out_0830 a,
    (select device_number,area_no,city_no from dw_v_user_base_info_user b
    where acct_month='201707'
    and tele_type in ('4','26')
    and is_onnet='是')b
    where a.cell_phone=b.device_number;
    
    
    
    