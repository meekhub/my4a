-- 表二、 TOP10品牌注册串码入库情况
select t.terminal_corp,count(*) cnt1,sum(case when flag=1 then 1 else 0 end)cnt2,
sum(case when flag=0 then 1 else 0 end) cnt3
 from (select * from  tmp_majh_1127_03 where terminal_corp='华为' 
 and (terminal_model like '%-BKL%'
 or terminal_model like '%-LLD%'
  or terminal_model like '%-LND%'
 or terminal_model like '%-BND%' 
 or terminal_model like '%-AUM%'
 or terminal_model like '%-MYA%'
 or terminal_model like '%-JMM%'
 or terminal_model like '%-PRA%'
 or terminal_model like '%-DLI%'
 or terminal_model like '%-PRA%'
 or terminal_model like '%-BLN%'       
 or terminal_model like '%-DUK%'   
 ) ) t 
group by t.terminal_corp;




 select t.terminal_corp,sum(OTHER_CNT)
 from 
 (select * from tmp_majh_1127_04 where 
 terminal_corp='华为' 
 and (terminal_model like '%-BKL%'
 or terminal_model like '%-LLD%'
  or terminal_model like '%-LND%'
 or terminal_model like '%-BND%' 
 or terminal_model like '%-AUM%'
 or terminal_model like '%-MYA%'
 or terminal_model like '%-JMM%'
 or terminal_model like '%-PRA%'
 or terminal_model like '%-DLI%'
 or terminal_model like '%-PRA%'
 or terminal_model like '%-BLN%'       
 or terminal_model like '%-DUK%') 
 )t,
 tmp_majh_term_1212_1 x
where  t.terminal_corp =x.terminal_corp
group by t.terminal_corp,x.idx_no
order by x.idx_no




select 
t.terminal_corp,sum(t.other_cnt)
 from (select * from tmp_majh_1127_05
 where (terminal_model like '%-BKL%'
 or terminal_model like '%-LLD%'
  or terminal_model like '%-LND%'
 or terminal_model like '%-BND%' 
 or terminal_model like '%-AUM%'
 or terminal_model like '%-MYA%'
 or terminal_model like '%-JMM%'
 or terminal_model like '%-PRA%'
 or terminal_model like '%-DLI%'
 or terminal_model like '%-PRA%'
 or terminal_model like '%-BLN%'       
 or terminal_model like '%-DUK%')
 )t,tmp_majh_term_1212_1 x
 where t.terminal_corp=x.terminal_corp
group by t.terminal_corp,x.idx_no
order by x.idx_no
