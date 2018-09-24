create table tmp_majh_family_0830 as
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
 where t.day_id in ('20171116', '20171214', '20180112', '20180316')
   and t.marketing_code = '2017063001'
   and cell_phone like 'ip%';
   
select count(*) from  tmp_majh_family_0830 where reserv1 is null and reserv2 is null 
--总计：46w
--可用：40w

select length(a.reserv2),count(*) from tmp_majh_family_0830 a group by length(a.reserv2);

update tmp_majh_family_0830 set reserv1=substr(reserv1,2) where reserv1 like '|%'
;

create table tmp_majh_family_out_0830 as
select latn_id,cell_phone,reserv1,decode(a.reserv3,'0','联通','移动')reserv3,
decode(RESERV4,'high','高','medium','中','低')reserv4,
decode(RESERV5,'high','高','medium','中','低')reserv5,
substr(reserv6,0,instr(reserv6,'|',1,1)-1)reserv6,
substr(reserv7,0,instr(reserv7,'|',1,1)-1)reserv7,
decode(substr(reserv8,0,instr(reserv8,'|',1,1)-1),'1','是','否')reserv8,
substr(reserv9,0,instr(reserv9,'|',1,1)-1)reserv9,
substr(reserv10,0,instr(reserv10,'|',1,1)-1)reserv10
from tmp_majh_family_0830 a where reserv1 is not null and length(reserv1)=11
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
from tmp_majh_family_0830 a where reserv1 is not null and length(reserv1)=23
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
from tmp_majh_family_0830 a where reserv1 is not null and length(reserv1)=23
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
from tmp_majh_family_0830 a where reserv1 is not null and length(reserv1)=35
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
from tmp_majh_family_0830 a where reserv1 is not null and length(reserv1)=35
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
from tmp_majh_family_0830 a where reserv1 is not null and length(reserv1)=35
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
from tmp_majh_family_0830 a where reserv1 is not null and length(reserv1)=47
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
from tmp_majh_family_0830 a where reserv1 is not null and length(reserv1)=47
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
from tmp_majh_family_0830 a where reserv1 is not null and length(reserv1)=47
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
from tmp_majh_family_0830 a where reserv1 is not null and length(reserv1)=47
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
from tmp_majh_family_0830 a where reserv1 is not null and length(reserv1)=59
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
from tmp_majh_family_0830 a where reserv1 is not null and length(reserv1)=59
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
from tmp_majh_family_0830 a where reserv1 is not null and length(reserv1)=59
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
from tmp_majh_family_0830 a where reserv1 is not null and length(reserv1)=59
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
from tmp_majh_family_0830 a where reserv1 is not null and length(reserv1)=59
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
from tmp_majh_family_0830 a where reserv1 is not null and length(reserv1)=71
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
from tmp_majh_family_0830 a where reserv1 is not null and length(reserv1)=71
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
from tmp_majh_family_0830 a where reserv1 is not null and length(reserv1)=71
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
from tmp_majh_family_0830 a where reserv1 is not null and length(reserv1)=71
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
from tmp_majh_family_0830 a where reserv1 is not null and length(reserv1)=71
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
from tmp_majh_family_0830 a where reserv1 is not null and length(reserv1)=83
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
from tmp_majh_family_0830 a where reserv1 is not null and length(reserv1)=83
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
from tmp_majh_family_0830 a where reserv1 is not null and length(reserv1)=83
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
from tmp_majh_family_0830 a where reserv1 is not null and length(reserv1)=83
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
from tmp_majh_family_0830 a where reserv1 is not null and length(reserv1)=83
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
from tmp_majh_family_0830 a where reserv1 is not null and length(reserv1)=95
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
from tmp_majh_family_0830 a where reserv1 is not null and length(reserv1)=95
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
from tmp_majh_family_0830 a where reserv1 is not null and length(reserv1)=95
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
from tmp_majh_family_0830 a where reserv1 is not null and length(reserv1)=95
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
from tmp_majh_family_0830 a where reserv1 is not null and length(reserv1)=95
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
from tmp_majh_family_0830 a where reserv2 is not null and length(reserv2)=11
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
from tmp_majh_family_0830 a where reserv2 is not null and length(reserv2)=23
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
from tmp_majh_family_0830 a where reserv2 is not null and length(reserv2)=23
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
from tmp_majh_family_0830 a where reserv2 is not null and length(reserv2)=35
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
from tmp_majh_family_0830 a where reserv2 is not null and length(reserv2)=35
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
from tmp_majh_family_0830 a where reserv2 is not null and length(reserv2)=35;


--汇总
  SELECT B.AREA_DESC 地市,
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
    FROM tmp_majh_family_out_0830 A, DIM.DIM_AREA_NO_JT B
   WHERE RESERV6 IS NOT NULL
     AND RESERV7 IS NOT NULL
     AND A.LATN_ID = B.STD_LATN_CD
     and rownum<101
     
--truncate table TMP_MAJH_FAMILY_OUT_0830_2     
DECLARE
  V_MONTH VARCHAR2(100);
  CURSOR V_AREA IS
    SELECT * FROM DIM.DIM_AREA_NO WHERE AREA_NO <> '018' ORDER BY IDX_NO;
BEGIN
  FOR V_NUM IN 201802 .. 201802 LOOP
    V_MONTH := TO_CHAR(V_NUM);
    FOR C1 IN V_AREA LOOP
      INSERT INTO TMP_MAJH_FAMILY_OUT_0830_2
        SELECT V_MONTH,
               B.AREA_NO,
               B.CITY_NO,
               CELL_PHONE 宽带账号,
               RESERV1 手机号,
               RESERV3 运营商,
               RESERV4 转网意愿,
               RESERV5 用户价值,
               RESERV6 终端品牌,
               RESERV7 终端型号,
               RESERV8 是否全网通,
               RESERV9 上市时间,
               nvl(RESERV10, 1) 卡槽数量,
               B.IS_RH 是否推荐办理融合,
               CASE
                 WHEN IS_NUMBER(RESERV10) is not null and  to_number(RESERV10)>= 2 THEN
                  '1'
                 ELSE
                  '0'
               END 是否推进办理副卡,
               b.cert_id,
               CUSTOMER_NAME,
               B.USER_NO
          FROM TMP_MAJH_FAMILY_OUT_0830 A,
               (SELECT DEVICE_NUMBER,
                       AREA_NO,
                       CITY_NO,
                       CERT_ID,
                       DECODE(IS_KD_BUNDLE, '0', '1', '0') IS_RH,
                       CUSTOMER_NAME,
                       USER_NO
                  FROM DW.DW_V_USER_BASE_INFO_USER B
                 WHERE ACCT_MONTH = '201802'
                   AND TELE_TYPE IN ('4', '26')
                   AND AREA_NO = C1.AREA_NO
                   AND IS_ONNET = '1') B
         WHERE A.CELL_PHONE = B.DEVICE_NUMBER;
      COMMIT;
    END LOOP;
  END LOOP;
  UPDATE TMP_MAJH_FAMILY_OUT_0830
     SET RESERV3 = '联通'
   WHERE SUBSTR(RESERV1, 1, 3) IN ('130',
                                   '131',
                                   '132',
                                   '186',
                                   '155',
                                   '156',
                                   '185',
                                   '175',
                                   '176',
                                   '145');
  COMMIT;
END;


select acct_month 账期,
       area_no 地市编码,
       city_no 区县编码,
       CELL_PHONE 宽带账号,
       RESERV1    手机号,
       RESERV3    运营商,
       RESERV4    转网意愿,
       RESERV5    用户价值,
       RESERV6    终端品牌,
       RESERV7    终端型号,
       RESERV8    是否全网通,
       RESERV9    上市时间,
       RESERV10   卡槽数量
  from tmp_majh_family_out_0830_2 where area_no='188'


create table tmp_majh_family_out
(
acct_month varchar2(20),
area_no varchar2(20),
city_no varchar2(100),
cell_phone varchar2(30),
RESERV1 varchar2(4000), 
RESERV3 varchar2(200),
RESERV4 varchar2(200),
RESERV5 varchar2(200),
RESERV6 varchar2(4000),
RESERV7 varchar2(4000),
RESERV8 varchar2(20),
RESERV9 varchar2(4000),
RESERV10 varchar2(4000)
)





