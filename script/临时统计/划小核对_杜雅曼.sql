select * from DM_V_CHANNEL_INFO_M where acct_month='201801'
and area_no='183'
and XIAOQU_NO='1830034440046920000000'

select * from DM_V_HUAXIAO_INFO_M where acct_month='201802'
and area_no='183'
and huaxiao_no='813100030160000'

select * from dim.dim_xiaoqu_huaxiao a where a.xiaoqu_name like '%���ׯ��%' and area_no='183'

select * from dim.dim_xiaoqu_huaxiao where xiaoqu_no='1830034440046920000000'


select * from DM_V_HUAXIAO_INFO_M where acct_month='201802'
and area_no='183'
and huaxiao_no='813100240040000'
