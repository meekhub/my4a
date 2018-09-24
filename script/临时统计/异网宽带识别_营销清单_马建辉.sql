----------------建模基础表----------------------
1、C网5月份分24小时时间段上网行为表

select * from tmp_mobile_flux_181

2、 家庭WIFI用户表
select * from tmp_wifi_user_183

-----------模型输出清单表----------------------

--异网宽带识别  A1群用户，但无本网宽带上网记录，且为单C用户，为蓝色区域。---策略：单C转融
create table xxhb_mjh.tmp_mobile_flux_050_1_181 as
select * from localnet_stage.tmp_mobile_flux_050_1_181@SFLOCAL;


--6）异网手机，直接可以进行本网外呼
create table xxhb_mjh.tmp_mobile_flux_050_2_181 as
select * from localnet_stage.tmp_mobile_flux_050_2_181@SFLOCAL;

