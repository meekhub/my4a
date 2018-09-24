create table tmp_majh_dianqu_risk
(
idx_no number,
device_number varchar2(30),
flag varchar2(2)
)

update tmp_majh_dianqu_risk set device_number=upper(device_number)

select count(*),COUNT(distinct DEVICE_NUMBER) FROM tmp_majh_dianqu_risk
