create table tmp_majh_family_0515 as
select day_id,
       prvnce_id,
       latn_id,
       upper(cell_phone) cell_phone,
       marketing_code,
       model_id,
       marketing_batch,
       reserv1,
       reserv2,
       reserv3,
       reserv4,
       reserv5,
       reserv6,
       reserv7,
       reserv8,
       reserv9,
       reserv10
  from stage.bwt_down_gu_bdm_pa_d t
 where t.marketing_code = '2017063001' 
 union all
 select to_char(day_id),
       prvnce_id,
       latn_id,
       upper(cell_phone) cell_phone,
       marketing_code,
       model_id,
       marketing_batch,
       reserv1,
       reserv2,
       reserv3,
       reserv4,
       reserv5,
       reserv6,
       reserv7,
       reserv8,
       reserv9,
       reserv10
  from stage.bwt_down_gu_bdm_d@oldhbdw t
 where t.marketing_code = '2017063001';
 

update  tmp_majh_family_0515 set reserv1=substr(reserv1,instr(reserv1,'1',1,1)),
reserv2=substr(reserv2,instr(reserv2,'1',1,1)),
reserv3=substr(reserv3,instr(reserv3,'1',1,1)),
reserv4=substr(reserv4,instr(reserv4,'1',1,1)),
reserv5=substr(reserv5,instr(reserv5,'1',1,1)),
reserv6=substr(reserv6,instr(reserv6,'1',1,1));



delete from  tmp_majh_family_0515 where (reserv1 like '|%' or reserv1 is null) and (reserv2 like '|%' or reserv2 is null)
 
 
 select * from tmp_majh_family_0515;
 
 create table tmp_majh_family_out_0515 as
select latn_id,cell_phone,reserv1,decode(a.reserv3,'0','联通','移动')reserv3,
decode(RESERV4,'high','高','medium','中','低')reserv4,
decode(RESERV5,'high','高','medium','中','低')reserv5,
substr(reserv6,0,instr(reserv6,'|',1,1)-1)reserv6,
substr(reserv7,0,instr(reserv7,'|',1,1)-1)reserv7,
decode(substr(reserv8,0,instr(reserv8,'|',1,1)-1),'1','是','否')reserv8,
substr(reserv9,0,instr(reserv9,'|',1,1)-1)reserv9,
substr(reserv10,0,instr(reserv10,'|',1,1)-1)reserv10
from tmp_majh_family_0515 a where reserv1 is not null and length(reserv1)=11
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
from tmp_majh_family_0515 a where reserv1 is not null and length(reserv1)=23
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
from tmp_majh_family_0515 a where reserv1 is not null and length(reserv1)=23
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
from tmp_majh_family_0515 a where reserv1 is not null and length(reserv1)=35
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
from tmp_majh_family_0515 a where reserv1 is not null and length(reserv1)=35
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
from tmp_majh_family_0515 a where reserv1 is not null and length(reserv1)=35
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
from tmp_majh_family_0515 a where reserv1 is not null and length(reserv1)=47
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
from tmp_majh_family_0515 a where reserv1 is not null and length(reserv1)=47
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
from tmp_majh_family_0515 a where reserv1 is not null and length(reserv1)=47
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
from tmp_majh_family_0515 a where reserv1 is not null and length(reserv1)=47
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
from tmp_majh_family_0515 a where reserv1 is not null and length(reserv1)=59
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
from tmp_majh_family_0515 a where reserv1 is not null and length(reserv1)=59
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
from tmp_majh_family_0515 a where reserv1 is not null and length(reserv1)=59
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
from tmp_majh_family_0515 a where reserv1 is not null and length(reserv1)=59
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
from tmp_majh_family_0515 a where reserv1 is not null and length(reserv1)=59
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
from tmp_majh_family_0515 a where reserv1 is not null and length(reserv1)=71
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
from tmp_majh_family_0515 a where reserv1 is not null and length(reserv1)=71
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
from tmp_majh_family_0515 a where reserv1 is not null and length(reserv1)=71
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
from tmp_majh_family_0515 a where reserv1 is not null and length(reserv1)=71
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
from tmp_majh_family_0515 a where reserv1 is not null and length(reserv1)=71
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
from tmp_majh_family_0515 a where reserv1 is not null and length(reserv1)=83
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
from tmp_majh_family_0515 a where reserv1 is not null and length(reserv1)=83
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
from tmp_majh_family_0515 a where reserv1 is not null and length(reserv1)=83
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
from tmp_majh_family_0515 a where reserv1 is not null and length(reserv1)=83
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
from tmp_majh_family_0515 a where reserv1 is not null and length(reserv1)=83
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
from tmp_majh_family_0515 a where reserv1 is not null and length(reserv1)=95
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
from tmp_majh_family_0515 a where reserv1 is not null and length(reserv1)=95
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
from tmp_majh_family_0515 a where reserv1 is not null and length(reserv1)=95
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
from tmp_majh_family_0515 a where reserv1 is not null and length(reserv1)=95
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
from tmp_majh_family_0515 a where reserv1 is not null and length(reserv1)=95
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
from tmp_majh_family_0515 a where reserv2 is not null and length(reserv2)=11
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
from tmp_majh_family_0515 a where reserv2 is not null and length(reserv2)=23
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
from tmp_majh_family_0515 a where reserv2 is not null and length(reserv2)=23
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
from tmp_majh_family_0515 a where reserv2 is not null and length(reserv2)=35
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
from tmp_majh_family_0515 a where reserv2 is not null and length(reserv2)=35
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
from tmp_majh_family_0515 a where reserv2 is not null and length(reserv2)=35;
 
 
--输出
select  
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
from   tmp_majh_family_out_0515;




update tmp_majh_family_out_0515 set CELL_PHONE=upper(CELL_PHONE);

--沉淀全网融合
create table  tmp_majh_family_rh as 
select a.device_number as kd_number,b.device_number as mobile_number,b.user_dinner_desc as mobile_dinner
from 
    (select device_number,bundle_id
     from dw.dw_v_user_base_info_user where acct_month='201707'
    and tele_type in ('4','26')
    and is_onnet='1'
    and is_kd_bundle<>'0'
    group by device_number,bundle_id)a
    left join
     (select bundle_id,device_number,user_dinner_desc
     from dw.dw_v_user_base_info_user where acct_month='201707'
    and tele_type in ('2')
    and is_onnet='1'
    and is_kd_bundle<>'0')b
    on a.bundle_id=b.bundle_id;
    

--每个融合用户下手机信息
create table  tmp_majh_family_dinners as 
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
b.mobile_dinner
when c.mobile_number is not null then 
concat(concat(b.mobile_dinner,'|'),c.mobile_dinner)
when d.mobile_number is not null then 
concat(concat(concat(concat(b.mobile_dinner,'|'),c.mobile_dinner),'|'),d.mobile_dinner)
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
on a.kd_number=d.kd_number;


--打标信息
create table tmp_majh_family_out_0515_2 as 
select 
a.*,d.begin_date,d.end_date,e.stdaddr_name,b.*,c.numbers,c.dinners
 from tmp_majh_family_out_0515 a,
(
 select user_no,device_number,area_no,city_no,customer_name,bandwidth,innet_date,user_dinner_desc,
    is_kd_bundle,bundle_id
     from dw.dw_v_user_base_info_user where acct_month='201707'
    --and tele_type in ('4','26')
    and is_onnet='1'
    and tele_type_new='G010'
)b,
tmp_majh_family_dinners c,
(
select bundle_id,to_char(begin_date,'yyyymmdd')begin_date,to_char(end_date,'yyyymmdd')end_date
from dw.DW_BUNDLE_PRODUCT_INFO_month where acct_month='201707'
) d,
(
SELECT USER_NO,
                       T.GRADE_0 || '/' || T.GRADE_1 || '/' || T.GRADE_2 || '/' ||
                       T.GRADE_3 || '/' || T.GRADE_4 STDADDR_NAME
                  FROM DW.DW_V_USER_ADSL_EIGHT_M T
                 WHERE ACCT_MONTH = '201807' 
)e
where a.CELL_PHONE=b.device_number
and a.cell_phone=c.KD_NUMBER(+)
and b.bundle_id=d.bundle_id(+)
and b.user_no=e.user_no(+);


/*RESERV1     手机号,
         RESERV3     运营商,
         RESERV4     转网意愿,
         RESERV5     用户价值,
         RESERV6     终端品牌,
         RESERV7     终端型号,
         RESERV8     是否全网通,
         RESERV9     上市时间,
         RESERV10    卡槽数量,
         dw.dw_v_user_base_info_user
         自2016年4月1日起改为新口径(2016年5月起增加折扣融合,括号中的1代表折扣融合)：
         01(1)-宽带+手机+电视+(固话) 
         02(1)-宽带+手机+(固话) 
         03(1)-宽带+电视+(固话)
         04(1)-手机+电视+(固话) 
         05(1)-宽带+固话 
         06(1)-手机+固话, 括号中的固话表示可有可无
         */

--提取小区和支局信息
select 
func_get_xiongan_area_desc(d.area_desc,a.city_no)地市,
A.cell_phone 宽带账号, 
case when a.is_kd_bundle='0' and a.is_kd_bundle='01' then 
'宽带+手机+电视'
when a.is_kd_bundle='0' and a.is_kd_bundle='02' then
'宽带+手机'
when a.is_kd_bundle='0' and a.is_kd_bundle='03' then
'宽带+电视'
when a.is_kd_bundle='0' and a.is_kd_bundle='04' then
'手机+电视'
when a.is_kd_bundle='0' and a.is_kd_bundle='05' then
'宽带+固话'
when a.is_kd_bundle='0' and a.is_kd_bundle='06' then
'手机+固话'
when a.is_kd_bundle='0' then
'其他融合'
else '非融合' end 融合类型，
A.begin_date 融合开始时间, 
A.end_date 融合结束时间, 
A.reserv1 手机号, 
A.reserv3 运营商, 
nvl(e.call_cnt,0) 过网通话次数,
A.reserv4 转网意愿, 
A.reserv5 用户价值, 
A.reserv6 终端品牌, 
A.reserv7 终端型号, 
A.reserv8 是否全网通, 
A.reserv9 上市时间, 
A.reserv10 卡槽数量, 
A.stdaddr_name 装机地址, 
A.user_no 用户编码,  
A.customer_name 用户名称, 
A.bandwidth 带宽, 
A.innet_date 入网时间, 
A.user_dinner_desc 套餐,
A.numbers 融合下手机号, 
A.dinners 融合下手机号对应套餐
 from tmp_majh_family_out_0515_2 a ,
ALLDMCODE.DMCODE_XIAOQU_STD_ADDR_NEW b,
dim.dim_xiaoqu_huaxiao c,
dim.dim_area_no d,
(select * from  ods.CPT_HEB_OT_CALL@hbods a where acct_month='201807')e
where a.stdaddr_name=b.stdaddr_name(+)
and b.xiaoqu_no=c.xiaoqu_no(+)
and c.area_no=d.area_no(+)
and a.reserv1=e.acc_nbr(+);


--生成宽表
create table FAMILY_WIFI_USER_INFO as 
select 
'201807' acct_month,
func_get_xiongan_area_no(d.area_no,a.city_no) area_no,
func_get_xiongan_area_desc(d.area_desc,a.city_no) area_desc,
A.cell_phone kd_number, 
case when a.is_kd_bundle='0' and a.is_kd_bundle='01' then 
'宽带+手机+电视'
when a.is_kd_bundle='0' and a.is_kd_bundle='02' then
'宽带+手机'
when a.is_kd_bundle='0' and a.is_kd_bundle='03' then
'宽带+电视'
when a.is_kd_bundle='0' and a.is_kd_bundle='04' then
'手机+电视'
when a.is_kd_bundle='0' and a.is_kd_bundle='05' then
'宽带+固话'
when a.is_kd_bundle='0' and a.is_kd_bundle='06' then
'手机+固话'
when a.is_kd_bundle='0' then
'其他融合'
else '非融合' end rh_type，
A.begin_date rh_begin_date, 
A.end_date rh_end_date, 
A.reserv1 mobile_number, 
A.reserv3 operator_flag, 
nvl(e.call_cnt,0) yw_call_cnt,
A.reserv4 trans_flag, 
A.reserv5 user_value, 
A.reserv6 trm_corp, 
A.reserv7 trm_modek, 
A.reserv8 is_all_type, 
A.reserv9 market_date, 
A.reserv10 card_cnt, 
A.stdaddr_name install_address, 
A.user_no,  
A.customer_name, 
A.bandwidth, 
A.innet_date, 
A.user_dinner_desc,
A.numbers, 
A.dinners
 from tmp_majh_family_out_0515_2 a ,
ALLDMCODE.DMCODE_XIAOQU_STD_ADDR_NEW b,
dim.dim_xiaoqu_huaxiao c,
dim.dim_area_no d,
(select * from  ods.CPT_HEB_OT_CALL@hbods a where acct_month='201807')e
where a.stdaddr_name=b.stdaddr_name(+)
and b.xiaoqu_no=c.xiaoqu_no(+)
and c.area_no=d.area_no(+)
and a.reserv1=e.acc_nbr(+)
and d.area_no is not null;



create table tmp_majh_family_out_0515_3 AS 
select * from  
(select CELL_PHONE 宽带账号,
       RESERV1    手机号,
       RESERV3    运营商,
       RESERV4    转网意愿,
       RESERV5    用户价值,
       RESERV6    终端品牌,
       RESERV7    终端型号,
       RESERV8    是否全网通,
       RESERV9    上市时间,
       RESERV10   卡槽数量,
       ROW_NUMBER()OVER(PARTITION BY CELL_PHONE,RESERV1 ORDER BY 1)RN
  from tmp_majh_family_out_0515_2
 where area_no_desc = '石家庄'
    or area_no_desc is null)
    where RN=1;


create table tmp_family_wifi_info as     
select 宽带账号,
       手机号,
       运营商,
       转网意愿,
       用户价值,
       终端品牌,
       终端型号,
       是否全网通,
       上市时间,
       卡槽数量
  from tmp_majh_family_out_0515_3;
 
 --dw_family_card_user_info
 
 --生成宽表
insert into  alldm.dm_v_user_family_wifi_m 
SELECT '201807' acct_month, 
       Y.AREA_NO,
       Y.CITY_NO, 
       X.CELL_PHONE,
       Y.INNET_DATE,
       DECODE(Y.IS_KD_BUNDLE, '0', '否', '是') IS_RH,
       x.RESERV1 YW_DEVICE_NUMBER,
       x.RESERV3 AS CARRIER_NAME,
       x.RESERV4 TRANS_FINE,
       x.RESERV5 USER_VALUE,
       REPLACE(x.RESERV6, '|', '') TERMINAL
  FROM tmp_majh_family_out_0515 X,
       tmp_majh_family_out_0515_2 Y
 WHERE X.CELL_PHONE = upper(Y.CELL_PHONE) 
 and x.cell_phone like 'IP%';
 
 
 
 
