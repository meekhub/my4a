select * from stage.bwt_down_gu_bdm_d t where t.marketing_code='2017063001' 


create table temp_user.tmp_majh_family_1103 as
select  
       distinct upper(cell_phone) cell_phone 
  from stage.bwt_down_gu_bdm_d t
 where  t.marketing_code='2017063001'
   and cell_phone like 'ip%';
   
   
   
create table temp_user.tmp_majh_family_1103_02 as   
select 
a.cell_phone,b.*
from temp_user.tmp_majh_family_1103 a,
(select device_number,area_no_desc,area_no,city_no,city_no_desc,user_dinner,user_dinner_desc,innet_date,is_kd_bundle from dw.dw_v_user_base_info_day where acct_month='201711' and day_id='20'
--and area_no='183'
and tele_type in ('4','26')
and is_onnet='1')b
where a.cell_phone=b.device_number;


create table temp_user.tmp_majh_family_1103_03 as 
select 
t.*,x.area_no_desc,x.city_no_desc
 from stage.bwt_down_gu_bdm_d t,temp_user.tmp_majh_family_1103_02 x where t.marketing_code='2017063001'
and t.cell_phone=lower(x.cell_phone)


create table temp_user.tmp_majh_family_out_1103 as
select latn_id,cell_phone,reserv1,decode(a.reserv3,'0','联通','移动')reserv3,
decode(RESERV4,'high','高','medium','中','低')reserv4,
decode(RESERV5,'high','高','medium','中','低')reserv5,
substr(reserv6,0,instr(reserv6,'|',1,1)-1)reserv6,
substr(reserv7,0,instr(reserv7,'|',1,1)-1)reserv7,
decode(substr(reserv8,0,instr(reserv8,'|',1,1)-1),'1','是','否')reserv8,
substr(reserv9,0,instr(reserv9,'|',1,1)-1)reserv9,
substr(reserv10,0,instr(reserv10,'|',1,1)-1)reserv10
from temp_user.tmp_majh_family_1103_03 a where reserv1 is not null and length(reserv1)=11
union all
select latn_id,cell_phone,
substr(reserv1,1,11),
decode(substr(reserv3,1,1),'0','联通','移动')reserv3,
decode(substr(reserv4,1,instr(reserv4,'|',1,1)-1),'high','高','medium','中','低')reserv4,
decode(substr(reserv5,1,instr(reserv5,'|',1,1)-1),'high','高','medium','中','低')reserv5,
substr(reserv6,1,instr(reserv6,'|',1,1)-1),
substr(reserv7,1,instr(reserv7,'|',1,1)-1),
decode(substr(reserv8,1,1),'1','是','否'), 
substr(reserv9,1,instr(reserv9,'|',1,1)-1),
substr(reserv10,1,1)
from temp_user.tmp_majh_family_1103_03 a where reserv1 is not null and length(reserv1)=23
union all
select latn_id,cell_phone,
substr(reserv1,instr(reserv1,'|',1,1)+1,11),
decode(substr(reserv3,instr(reserv3,'|',1,1)+1,1),'0','联通','移动')reserv3,
decode(substr(reserv4,instr(reserv4,'|',1,1)+1),'high','高','medium','中','低')reserv4,
decode(substr(reserv5,instr(reserv5,'|',1,1)+1),'high','高','medium','中','低')reserv5,
substr(reserv6,instr(reserv6,'|',1,1)+1),
substr(reserv7,instr(reserv7,'|',1,1)+1),
decode(substr(reserv8,instr(reserv8,'|',1,1)-1,1),'1','是','否'), 
substr(reserv9,instr(reserv9,'|',1,1)+1,6),
substr(reserv10,instr(reserv10,'|',1,1)+1,1)
from temp_user.tmp_majh_family_1103_03 a where reserv1 is not null and length(reserv1)=23
union all
select latn_id,cell_phone,
substr(reserv1,1,11),
decode(substr(reserv3,1,1),'0','联通','移动')reserv3,
decode(substr(reserv4,1,instr(reserv4,'|',1,1)-1),'high','高','medium','中','低')reserv4,
decode(substr(reserv5,1,instr(reserv5,'|',1,1)-1),'high','高','medium','中','低')reserv5,
substr(reserv6,1,instr(reserv6,'|',1,1)-1),
substr(reserv7,1,instr(reserv7,'|',1,1)-1),
decode(substr(reserv8,1,1),'1','是','否'), 
substr(reserv9,1,instr(reserv9,'|',1,1)-1),
substr(reserv10,1,1)
from temp_user.tmp_majh_family_1103_03 a where reserv1 is not null and length(reserv1)=35
union all
select latn_id,cell_phone,
substr(reserv1,instr(reserv1,'|',1,1)+1,11),
decode(substr(reserv3,instr(reserv3,'|',1,1)+1,1),'0','联通','移动')reserv3,
decode(substr(reserv4,instr(reserv4,'|',1,1)+1),'high','高','medium','中','低')reserv4,
decode(substr(reserv5,instr(reserv5,'|',1,1)+1),'high','高','medium','中','低')reserv5,
substr(reserv6,instr(reserv6,'|',1,1)+1),
substr(reserv7,instr(reserv7,'|',1,1)+1),
decode(substr(reserv8,instr(reserv8,'|',1,1)-1,1),'1','是','否'), 
substr(reserv9,instr(reserv9,'|',1,1)+1,6),
substr(reserv10,instr(reserv10,'|',1,1)+1,1)
from temp_user.tmp_majh_family_1103_03 a where reserv1 is not null and length(reserv1)=35
union all
select latn_id,cell_phone,
substr(reserv1,instr(reserv1,'|',1,2)+1,11),
decode(substr(reserv3,instr(reserv3,'|',1,2)+1,1),'0','联通','移动')reserv3,
decode(substr(reserv4,instr(reserv4,'|',1,2)+1),'high','高','medium','中','低')reserv4,
decode(substr(reserv5,instr(reserv5,'|',1,2)+1),'high','高','medium','中','低')reserv5,
substr(reserv6,instr(reserv6,'|',1,2)+1),
substr(reserv7,instr(reserv7,'|',1,2)+1),
decode(substr(reserv8,instr(reserv8,'|',1,2)-1,1),'1','是','否'), 
substr(reserv9,instr(reserv9,'|',1,2)+1,6),
substr(reserv10,instr(reserv10,'|',1,2)+1,1)
from temp_user.tmp_majh_family_1103_03 a where reserv1 is not null and length(reserv1)=35
union all
select latn_id,cell_phone,
substr(reserv1,1,11),
decode(substr(reserv3,1,1),'0','联通','移动')reserv3,
decode(substr(reserv4,1,instr(reserv4,'|',1,1)-1),'high','高','medium','中','低')reserv4,
decode(substr(reserv5,1,instr(reserv5,'|',1,1)-1),'high','高','medium','中','低')reserv5,
substr(reserv6,1,instr(reserv6,'|',1,1)-1),
substr(reserv7,1,instr(reserv7,'|',1,1)-1),
decode(substr(reserv8,1,1),'1','是','否'), 
substr(reserv9,1,instr(reserv9,'|',1,1)-1),
substr(reserv10,1,1)
from temp_user.tmp_majh_family_1103_03 a where reserv1 is not null and length(reserv1)=47
union all
select latn_id,cell_phone,
substr(reserv1,instr(reserv1,'|',1,1)+1,11),
decode(substr(reserv3,instr(reserv3,'|',1,1)+1,1),'0','联通','移动')reserv3,
decode(substr(reserv4,instr(reserv4,'|',1,1)+1),'high','高','medium','中','低')reserv4,
decode(substr(reserv5,instr(reserv5,'|',1,1)+1),'high','高','medium','中','低')reserv5,
substr(reserv6,instr(reserv6,'|',1,1)+1),
substr(reserv7,instr(reserv7,'|',1,1)+1),
decode(substr(reserv8,instr(reserv8,'|',1,1)-1,1),'1','是','否'), 
substr(reserv9,instr(reserv9,'|',1,1)+1,6),
substr(reserv10,instr(reserv10,'|',1,1)+1,1)
from temp_user.tmp_majh_family_1103_03 a where reserv1 is not null and length(reserv1)=47
union all
select latn_id,cell_phone,
substr(reserv1,instr(reserv1,'|',1,2)+1,11),
decode(substr(reserv3,instr(reserv3,'|',1,2)+1,1),'0','联通','移动')reserv3,
decode(substr(reserv4,instr(reserv4,'|',1,2)+1),'high','高','medium','中','低')reserv4,
decode(substr(reserv5,instr(reserv5,'|',1,2)+1),'high','高','medium','中','低')reserv5,
substr(reserv6,instr(reserv6,'|',1,2)+1),
substr(reserv7,instr(reserv7,'|',1,2)+1),
decode(substr(reserv8,instr(reserv8,'|',1,2)-1,1),'1','是','否'), 
substr(reserv9,instr(reserv9,'|',1,2)+1,6),
substr(reserv10,instr(reserv10,'|',1,2)+1,1)
from temp_user.tmp_majh_family_1103_03 a where reserv1 is not null and length(reserv1)=47
union all
select latn_id,cell_phone,
substr(reserv1,instr(reserv1,'|',1,3)+1,11),
decode(substr(reserv3,instr(reserv3,'|',1,3)+1,1),'0','联通','移动')reserv3,
decode(substr(reserv4,instr(reserv4,'|',1,3)+1),'high','高','medium','中','低')reserv4,
decode(substr(reserv5,instr(reserv5,'|',1,3)+1),'high','高','medium','中','低')reserv5,
substr(reserv6,instr(reserv6,'|',1,3)+1),
substr(reserv7,instr(reserv7,'|',1,3)+1),
decode(substr(reserv8,instr(reserv8,'|',1,3)-1,1),'1','是','否'), 
substr(reserv9,instr(reserv9,'|',1,3)+1,6),
substr(reserv10,instr(reserv10,'|',1,3)+1,1)
from temp_user.tmp_majh_family_1103_03 a where reserv1 is not null and length(reserv1)=47
union all
select latn_id,cell_phone,
substr(reserv1,1,11),
decode(substr(reserv3,1,1),'0','联通','移动')reserv3,
decode(substr(reserv4,1,instr(reserv4,'|',1,1)-1),'high','高','medium','中','低')reserv4,
decode(substr(reserv5,1,instr(reserv5,'|',1,1)-1),'high','高','medium','中','低')reserv5,
substr(reserv6,1,instr(reserv6,'|',1,1)-1),
substr(reserv7,1,instr(reserv7,'|',1,1)-1),
decode(substr(reserv8,1,1),'1','是','否'), 
substr(reserv9,1,instr(reserv9,'|',1,1)-1),
substr(reserv10,1,1)
from temp_user.tmp_majh_family_1103_03 a where reserv1 is not null and length(reserv1)=59
union all
select latn_id,cell_phone,
substr(reserv1,instr(reserv1,'|',1,1)+1,11),
decode(substr(reserv3,instr(reserv3,'|',1,1)+1,1),'0','联通','移动')reserv3,
decode(substr(reserv4,instr(reserv4,'|',1,1)+1),'high','高','medium','中','低')reserv4,
decode(substr(reserv5,instr(reserv5,'|',1,1)+1),'high','高','medium','中','低')reserv5,
substr(reserv6,instr(reserv6,'|',1,1)+1),
substr(reserv7,instr(reserv7,'|',1,1)+1),
decode(substr(reserv8,instr(reserv8,'|',1,1)-1,1),'1','是','否'), 
substr(reserv9,instr(reserv9,'|',1,1)+1,6),
substr(reserv10,instr(reserv10,'|',1,1)+1,1)
from temp_user.tmp_majh_family_1103_03 a where reserv1 is not null and length(reserv1)=59
union all
select latn_id,cell_phone,
substr(reserv1,instr(reserv1,'|',1,2)+1,11),
decode(substr(reserv3,instr(reserv3,'|',1,2)+1,1),'0','联通','移动')reserv3,
decode(substr(reserv4,instr(reserv4,'|',1,2)+1),'high','高','medium','中','低')reserv4,
decode(substr(reserv5,instr(reserv5,'|',1,2)+1),'high','高','medium','中','低')reserv5,
substr(reserv6,instr(reserv6,'|',1,2)+1),
substr(reserv7,instr(reserv7,'|',1,2)+1),
decode(substr(reserv8,instr(reserv8,'|',1,2)-1,1),'1','是','否'), 
substr(reserv9,instr(reserv9,'|',1,2)+1,6),
substr(reserv10,instr(reserv10,'|',1,2)+1,1)
from temp_user.tmp_majh_family_1103_03 a where reserv1 is not null and length(reserv1)=59
union all
select latn_id,cell_phone,
substr(reserv1,instr(reserv1,'|',1,3)+1,11),
decode(substr(reserv3,instr(reserv3,'|',1,3)+1,1),'0','联通','移动')reserv3,
decode(substr(reserv4,instr(reserv4,'|',1,3)+1),'high','高','medium','中','低')reserv4,
decode(substr(reserv5,instr(reserv5,'|',1,3)+1),'high','高','medium','中','低')reserv5,
substr(reserv6,instr(reserv6,'|',1,3)+1),
substr(reserv7,instr(reserv7,'|',1,3)+1),
decode(substr(reserv8,instr(reserv8,'|',1,3)-1,1),'1','是','否'), 
substr(reserv9,instr(reserv9,'|',1,3)+1,6),
substr(reserv10,instr(reserv10,'|',1,3)+1,1)
from temp_user.tmp_majh_family_1103_03 a where reserv1 is not null and length(reserv1)=59
union all
select latn_id,cell_phone,
substr(reserv1,instr(reserv1,'|',1,4)+1,11),
decode(substr(reserv3,instr(reserv3,'|',1,4)+1,1),'0','联通','移动')reserv3,
decode(substr(reserv4,instr(reserv4,'|',1,4)+1),'high','高','medium','中','低')reserv4,
decode(substr(reserv5,instr(reserv5,'|',1,4)+1),'high','高','medium','中','低')reserv5,
substr(reserv6,instr(reserv6,'|',1,4)+1),
substr(reserv7,instr(reserv7,'|',1,4)+1),
decode(substr(reserv8,instr(reserv8,'|',1,4)-1,1),'1','是','否'), 
substr(reserv9,instr(reserv9,'|',1,4)+1,6),
substr(reserv10,instr(reserv10,'|',1,4)+1,1)
from temp_user.tmp_majh_family_1103_03 a where reserv1 is not null and length(reserv1)=59
union all
select latn_id,cell_phone,
substr(reserv1,1,11),
decode(substr(reserv3,1,1),'0','联通','移动')reserv3,
decode(substr(reserv4,1,instr(reserv4,'|',1,1)-1),'high','高','medium','中','低')reserv4,
decode(substr(reserv5,1,instr(reserv5,'|',1,1)-1),'high','高','medium','中','低')reserv5,
substr(reserv6,1,instr(reserv6,'|',1,1)-1),
substr(reserv7,1,instr(reserv7,'|',1,1)-1),
decode(substr(reserv8,1,1),'1','是','否'), 
substr(reserv9,1,instr(reserv9,'|',1,1)-1),
substr(reserv10,1,1)
from temp_user.tmp_majh_family_1103_03 a where reserv1 is not null and length(reserv1)=71
union all
select latn_id,cell_phone,
substr(reserv1,instr(reserv1,'|',1,1)+1,11),
decode(substr(reserv3,instr(reserv3,'|',1,1)+1,1),'0','联通','移动')reserv3,
decode(substr(reserv4,instr(reserv4,'|',1,1)+1),'high','高','medium','中','低')reserv4,
decode(substr(reserv5,instr(reserv5,'|',1,1)+1),'high','高','medium','中','低')reserv5,
substr(reserv6,instr(reserv6,'|',1,1)+1),
substr(reserv7,instr(reserv7,'|',1,1)+1),
decode(substr(reserv8,instr(reserv8,'|',1,1)-1,1),'1','是','否'), 
substr(reserv9,instr(reserv9,'|',1,1)+1,6),
substr(reserv10,instr(reserv10,'|',1,1)+1,1)
from temp_user.tmp_majh_family_1103_03 a where reserv1 is not null and length(reserv1)=71
union all
select latn_id,cell_phone,
substr(reserv1,instr(reserv1,'|',1,2)+1,11),
decode(substr(reserv3,instr(reserv3,'|',1,2)+1,1),'0','联通','移动')reserv3,
decode(substr(reserv4,instr(reserv4,'|',1,2)+1),'high','高','medium','中','低')reserv4,
decode(substr(reserv5,instr(reserv5,'|',1,2)+1),'high','高','medium','中','低')reserv5,
substr(reserv6,instr(reserv6,'|',1,2)+1),
substr(reserv7,instr(reserv7,'|',1,2)+1),
decode(substr(reserv8,instr(reserv8,'|',1,2)-1,1),'1','是','否'), 
substr(reserv9,instr(reserv9,'|',1,2)+1,6),
substr(reserv10,instr(reserv10,'|',1,2)+1,1)
from temp_user.tmp_majh_family_1103_03 a where reserv1 is not null and length(reserv1)=71
union all
select latn_id,cell_phone,
substr(reserv1,instr(reserv1,'|',1,3)+1,11),
decode(substr(reserv3,instr(reserv3,'|',1,3)+1,1),'0','联通','移动')reserv3,
decode(substr(reserv4,instr(reserv4,'|',1,3)+1),'high','高','medium','中','低')reserv4,
decode(substr(reserv5,instr(reserv5,'|',1,3)+1),'high','高','medium','中','低')reserv5,
substr(reserv6,instr(reserv6,'|',1,3)+1),
substr(reserv7,instr(reserv7,'|',1,3)+1),
decode(substr(reserv8,instr(reserv8,'|',1,3)-1,1),'1','是','否'), 
substr(reserv9,instr(reserv9,'|',1,3)+1,6),
substr(reserv10,instr(reserv10,'|',1,3)+1,1)
from temp_user.tmp_majh_family_1103_03 a where reserv1 is not null and length(reserv1)=71
union all
select latn_id,cell_phone,
substr(reserv1,instr(reserv1,'|',1,5)+1,11),
decode(substr(reserv3,instr(reserv3,'|',1,5)+1,1),'0','联通','移动')reserv3,
decode(substr(reserv4,instr(reserv4,'|',1,5)+1),'high','高','medium','中','低')reserv4,
decode(substr(reserv5,instr(reserv5,'|',1,5)+1),'high','高','medium','中','低')reserv5,
substr(reserv6,instr(reserv6,'|',1,5)+1),
substr(reserv7,instr(reserv7,'|',1,5)+1),
decode(substr(reserv8,instr(reserv8,'|',1,5)-1,1),'1','是','否'), 
substr(reserv9,instr(reserv9,'|',1,5)+1,6),
substr(reserv10,instr(reserv10,'|',1,5)+1,1)
from temp_user.tmp_majh_family_1103_03 a where reserv1 is not null and length(reserv1)=71
union all
select latn_id,cell_phone,
substr(reserv1,1,11),
decode(substr(reserv3,1,1),'0','联通','移动')reserv3,
decode(substr(reserv4,1,instr(reserv4,'|',1,1)-1),'high','高','medium','中','低')reserv4,
decode(substr(reserv5,1,instr(reserv5,'|',1,1)-1),'high','高','medium','中','低')reserv5,
substr(reserv6,1,instr(reserv6,'|',1,1)-1),
substr(reserv7,1,instr(reserv7,'|',1,1)-1),
decode(substr(reserv8,1,1),'1','是','否'), 
substr(reserv9,1,instr(reserv9,'|',1,1)-1),
substr(reserv10,1,1)
from temp_user.tmp_majh_family_1103_03 a where reserv1 is not null and length(reserv1)=83
union all
select latn_id,cell_phone,
substr(reserv1,instr(reserv1,'|',1,1)+1,11),
decode(substr(reserv3,instr(reserv3,'|',1,1)+1,1),'0','联通','移动')reserv3,
decode(substr(reserv4,instr(reserv4,'|',1,1)+1),'high','高','medium','中','低')reserv4,
decode(substr(reserv5,instr(reserv5,'|',1,1)+1),'high','高','medium','中','低')reserv5,
substr(reserv6,instr(reserv6,'|',1,1)+1),
substr(reserv7,instr(reserv7,'|',1,1)+1),
decode(substr(reserv8,instr(reserv8,'|',1,1)-1,1),'1','是','否'), 
substr(reserv9,instr(reserv9,'|',1,1)+1,6),
substr(reserv10,instr(reserv10,'|',1,1)+1,1)
from temp_user.tmp_majh_family_1103_03 a where reserv1 is not null and length(reserv1)=83
union all
select latn_id,cell_phone,
substr(reserv1,instr(reserv1,'|',1,2)+1,11),
decode(substr(reserv3,instr(reserv3,'|',1,2)+1,1),'0','联通','移动')reserv3,
decode(substr(reserv4,instr(reserv4,'|',1,2)+1),'high','高','medium','中','低')reserv4,
decode(substr(reserv5,instr(reserv5,'|',1,2)+1),'high','高','medium','中','低')reserv5,
substr(reserv6,instr(reserv6,'|',1,2)+1),
substr(reserv7,instr(reserv7,'|',1,2)+1),
decode(substr(reserv8,instr(reserv8,'|',1,2)-1,1),'1','是','否'), 
substr(reserv9,instr(reserv9,'|',1,2)+1,6),
substr(reserv10,instr(reserv10,'|',1,2)+1,1)
from temp_user.tmp_majh_family_1103_03 a where reserv1 is not null and length(reserv1)=83
union all
select latn_id,cell_phone,
substr(reserv1,instr(reserv1,'|',1,3)+1,11),
decode(substr(reserv3,instr(reserv3,'|',1,3)+1,1),'0','联通','移动')reserv3,
decode(substr(reserv4,instr(reserv4,'|',1,3)+1),'high','高','medium','中','低')reserv4,
decode(substr(reserv5,instr(reserv5,'|',1,3)+1),'high','高','medium','中','低')reserv5,
substr(reserv6,instr(reserv6,'|',1,3)+1),
substr(reserv7,instr(reserv7,'|',1,3)+1),
decode(substr(reserv8,instr(reserv8,'|',1,3)-1,1),'1','是','否'), 
substr(reserv9,instr(reserv9,'|',1,3)+1,6),
substr(reserv10,instr(reserv10,'|',1,3)+1,1)
from temp_user.tmp_majh_family_1103_03 a where reserv1 is not null and length(reserv1)=83
union all
select latn_id,cell_phone,
substr(reserv1,instr(reserv1,'|',1,6)+1,11),
decode(substr(reserv3,instr(reserv3,'|',1,6)+1,1),'0','联通','移动')reserv3,
decode(substr(reserv4,instr(reserv4,'|',1,6)+1),'high','高','medium','中','低')reserv4,
decode(substr(reserv5,instr(reserv5,'|',1,6)+1),'high','高','medium','中','低')reserv5,
substr(reserv6,instr(reserv6,'|',1,6)+1),
substr(reserv7,instr(reserv7,'|',1,6)+1),
decode(substr(reserv8,instr(reserv8,'|',1,6)-1,1),'1','是','否'), 
substr(reserv9,instr(reserv9,'|',1,6)+1,6),
substr(reserv10,instr(reserv10,'|',1,6)+1,1)
from temp_user.tmp_majh_family_1103_03 a where reserv1 is not null and length(reserv1)=83
union all
select latn_id,cell_phone,
substr(reserv1,1,11),
decode(substr(reserv3,1,1),'0','联通','移动')reserv3,
decode(substr(reserv4,1,instr(reserv4,'|',1,1)-1),'high','高','medium','中','低')reserv4,
decode(substr(reserv5,1,instr(reserv5,'|',1,1)-1),'high','高','medium','中','低')reserv5,
substr(reserv6,1,instr(reserv6,'|',1,1)-1),
substr(reserv7,1,instr(reserv7,'|',1,1)-1),
decode(substr(reserv8,1,1),'1','是','否'), 
substr(reserv9,1,instr(reserv9,'|',1,1)-1),
substr(reserv10,1,1)
from temp_user.tmp_majh_family_1103_03 a where reserv1 is not null and length(reserv1)=95
union all
select latn_id,cell_phone,
substr(reserv1,instr(reserv1,'|',1,1)+1,11),
decode(substr(reserv3,instr(reserv3,'|',1,1)+1,1),'0','联通','移动')reserv3,
decode(substr(reserv4,instr(reserv4,'|',1,1)+1),'high','高','medium','中','低')reserv4,
decode(substr(reserv5,instr(reserv5,'|',1,1)+1),'high','高','medium','中','低')reserv5,
substr(reserv6,instr(reserv6,'|',1,1)+1),
substr(reserv7,instr(reserv7,'|',1,1)+1),
decode(substr(reserv8,instr(reserv8,'|',1,1)-1,1),'1','是','否'), 
substr(reserv9,instr(reserv9,'|',1,1)+1,6),
substr(reserv10,instr(reserv10,'|',1,1)+1,1)
from temp_user.tmp_majh_family_1103_03 a where reserv1 is not null and length(reserv1)=95
union all
select latn_id,cell_phone,
substr(reserv1,instr(reserv1,'|',1,2)+1,11),
decode(substr(reserv3,instr(reserv3,'|',1,2)+1,1),'0','联通','移动')reserv3,
decode(substr(reserv4,instr(reserv4,'|',1,2)+1),'high','高','medium','中','低')reserv4,
decode(substr(reserv5,instr(reserv5,'|',1,2)+1),'high','高','medium','中','低')reserv5,
substr(reserv6,instr(reserv6,'|',1,2)+1),
substr(reserv7,instr(reserv7,'|',1,2)+1),
decode(substr(reserv8,instr(reserv8,'|',1,2)-1,1),'1','是','否'), 
substr(reserv9,instr(reserv9,'|',1,2)+1,6),
substr(reserv10,instr(reserv10,'|',1,2)+1,1)
from temp_user.tmp_majh_family_1103_03 a where reserv1 is not null and length(reserv1)=95
union all
select latn_id,cell_phone,
substr(reserv1,instr(reserv1,'|',1,3)+1,11),
decode(substr(reserv3,instr(reserv3,'|',1,3)+1,1),'0','联通','移动')reserv3,
decode(substr(reserv4,instr(reserv4,'|',1,3)+1),'high','高','medium','中','低')reserv4,
decode(substr(reserv5,instr(reserv5,'|',1,3)+1),'high','高','medium','中','低')reserv5,
substr(reserv6,instr(reserv6,'|',1,3)+1),
substr(reserv7,instr(reserv7,'|',1,3)+1),
decode(substr(reserv8,instr(reserv8,'|',1,3)-1,1),'1','是','否'), 
substr(reserv9,instr(reserv9,'|',1,3)+1,6),
substr(reserv10,instr(reserv10,'|',1,3)+1,1)
from temp_user.tmp_majh_family_1103_03 a where reserv1 is not null and length(reserv1)=95
union all
select latn_id,cell_phone,
substr(reserv1,instr(reserv1,'|',1,7)+1,11),
decode(substr(reserv3,instr(reserv3,'|',1,7)+1,1),'0','联通','移动')reserv3,
decode(substr(reserv4,instr(reserv4,'|',1,7)+1),'high','高','medium','中','低')reserv4,
decode(substr(reserv5,instr(reserv5,'|',1,7)+1),'high','高','medium','中','低')reserv5,
substr(reserv6,instr(reserv6,'|',1,7)+1),
substr(reserv7,instr(reserv7,'|',1,7)+1),
decode(substr(reserv8,instr(reserv8,'|',1,7)-1,1),'1','是','否'), 
substr(reserv9,instr(reserv9,'|',1,7)+1,6),
substr(reserv10,instr(reserv10,'|',1,7)+1,1)
from temp_user.tmp_majh_family_1103_03 a where reserv1 is not null and length(reserv1)=95
--本网
union all
select latn_id,cell_phone,
reserv2,
'电信' reserv3,
'' reserv4,
'' reserv5,
'' reserv6,
'' reserv7,
'' reserv8,
'' reserv9,
'' reserv10
from temp_user.tmp_majh_family_1103_03 a where reserv2 is not null and length(reserv2)=11
union all
select latn_id,cell_phone,
substr(reserv2,1,instr(reserv2,'|',1,1)-1),
'电信' reserv3,
'' reserv4,
'' reserv5,
'' reserv6,
'' reserv7,
'' reserv8,
'' reserv9,
'' reserv10
from temp_user.tmp_majh_family_1103_03 a where reserv2 is not null and length(reserv2)=23
union all
select latn_id,cell_phone,
substr(reserv2,instr(reserv2,'|',1,1)+1,11),
'电信' reserv3,
'' reserv4,
'' reserv5,
'' reserv6,
'' reserv7,
'' reserv8,
'' reserv9,
'' reserv10
from temp_user.tmp_majh_family_1103_03 a where reserv2 is not null and length(reserv2)=23
union all
select latn_id,cell_phone,
substr(reserv2,1,11),
'电信' reserv3,
'' reserv4,
'' reserv5,
'' reserv6,
'' reserv7,
'' reserv8,
'' reserv9,
'' reserv10
from temp_user.tmp_majh_family_1103_03 a where reserv2 is not null and length(reserv2)=35
union all
select latn_id,cell_phone,
substr(reserv2,instr(reserv2,'|',1,1)+1,11),
'电信' reserv3,
'' reserv4,
'' reserv5,
'' reserv6,
'' reserv7,
'' reserv8,
'' reserv9,
'' reserv10
from temp_user.tmp_majh_family_1103_03 a where reserv2 is not null and length(reserv2)=35
union all
select latn_id,cell_phone,
substr(reserv2,instr(reserv2,'|',1,2)+1,11),
'电信' reserv3,
'' reserv4,
'' reserv5,
'' reserv6,
'' reserv7,
'' reserv8,
'' reserv9,
'' reserv10
from temp_user.tmp_majh_family_1103_03 a where reserv2 is not null and length(reserv2)=35;




--导出结果
create table tmp_majh_1122_03 as 
SELECT Y.CELL_PHONE 宽带号,
       Y.AREA_NO_DESC,
       Y.CITY_NO_DESC 区号,
       Y.USER_DINNER 套餐ID,
       Y.USER_DINNER_DESC 套餐名称,
       Y.INNET_DATE 入网日期,
       DECODE(Y.IS_KD_BUNDLE, '0', '否', '是') 是否融合,
       RESERV1 异网号码,
       RESERV3 运营商,
       RESERV4 转网意愿,
       RESERV5 用户价值,
       replace(RESERV6,'|','') 终端 
  FROM (SELECT A.*
          FROM TEMP_USER.TMP_MAJH_FAMILY_OUT_1103 A,
               (SELECT DISTINCT CELL_PHONE
                  FROM TEMP_USER.TMP_MAJH_FAMILY_OUT_1103 T
                 WHERE RESERV3 = '电信') B
         WHERE A.CELL_PHONE = B.CELL_PHONE(+)
           AND B.CELL_PHONE IS NULL) X,
       TEMP_USER.TMP_MAJH_FAMILY_1103_02 Y
 WHERE X.CELL_PHONE = LOWER(Y.CELL_PHONE)
 AND Y.AREA_NO_DESC='邯郸'
 order  by Y.CELL_PHONE



--生成宽表
insert into  dm_v_user_family_wifi_m 
SELECT '201711' acct_month, 
       Y.AREA_NO,
       Y.CITY_NO, 
       Y.CELL_PHONE DEVICE_NUMBER,
       Y.INNET_DATE,
       DECODE(Y.IS_KD_BUNDLE, '0', '否', '是') IS_RH,
       RESERV1 YW_DEVICE_NUMBER,
       RESERV3 AS CARRIER_NAME,
       RESERV4 TRANS_FINE,
       RESERV5 USER_VALUE,
       REPLACE(RESERV6, '|', '') TERMINAL
  FROM (SELECT A.*
          FROM TEMP_USER.TMP_MAJH_FAMILY_OUT_1103 A,
               (SELECT DISTINCT CELL_PHONE
                  FROM TEMP_USER.TMP_MAJH_FAMILY_OUT_1103 T
                 WHERE RESERV3 = '电信') B
         WHERE A.CELL_PHONE = B.CELL_PHONE(+)
           AND B.CELL_PHONE IS NULL) X,
       TEMP_USER.TMP_MAJH_FAMILY_1103_02 Y
 WHERE X.CELL_PHONE = LOWER(Y.CELL_PHONE)
 ORDER BY Y.CELL_PHONE;
 
 
 
 
 
 
 
 
 
 
