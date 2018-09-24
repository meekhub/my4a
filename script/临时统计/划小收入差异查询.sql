select huaxiao_no,sum(a),sum(b),sum(a)-sum(b) from 
(select a.huaxiao_no,0 a, sum(total_fee) b from DM_V_HUAXIAO_INFO_M a where acct_month='201801' and area_no='187'
group by huaxiao_no
union all
select a.huaxiao_no,sum(total_fee), 0 b from DM_V_CHANNEL_INFO_M a where acct_month='201801' and area_no='187'
group by a.huaxiao_no)
group by huaxiao_no 
having sum(a)<>sum(b)

3	813060040070000	751172.1	751195.58	-23.48
12	813060440070000	612452.17	612545.46	-93.29



select sum(price_fee + price_fee_ocs)
  FROM DW.DW_V_USER_HUAXIAO_INFO_M A
 WHERE A.ACCT_MONTH = '201801'
   AND AREA_NO = '187'
   and huaxiao_no_03='813060440070000'
   667299.91
   
   
   
select * from dim.dim_huaxiao_info where huaxiao_no='813060840070000'



select SUM(NVL(A.PRICE_FEE, 0)) + SUM(NVL(A.PRICE_FEE_OCS, 0)) -
       SUM(NVL(A.IOT_FEE, 0))
  from (select HUAXIAO_NO_03, price_fee, price_fee_ocs, iot_fee
          FROM DW.DW_V_USER_HUAXIAO_INFO_M A
         WHERE A.ACCT_MONTH = '201801'
           AND AREA_NO = '187'
              --AND A.IS_VALID = '1'
           AND A.IS_HUAXIAO_03 = '1') A,
       (SELECT *
          FROM DIM.DIM_HUAXIAO_INFO T
         WHERE T.AREA_NO = '187'
           AND T.HUAXIAO_TYPE IN ('01', '02', '03', '04')
           and huaxiao_no = '813060440070000') T
 WHERE A.HUAXIAO_NO_03 = T.HUAXIAO_NO
