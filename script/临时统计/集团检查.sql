--如果有值必须为数字，且为正值；报账表的电费税；税点不能为0；
select * from BWT_REIM_BASIC_DATA_INFO_M a
where a.acct_month='201710'
and (a.total_electricity=0 or a.elec_charge_price=0)

--如果有值必须为数字，且为正值；报账表的电费税；税点不能为0；
select * from BWT_REIM_BASIC_DATA_INFO_M a
where a.acct_month='201710'
and  ELEC_CHARGE_TAX<0
