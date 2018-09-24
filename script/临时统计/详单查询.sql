SELECT /*+parallel(1,10)*/
 A.*
  FROM BILL_DSG.BF_CDMA_CALL_T@HBODS A
 WHERE DAY = '30'
   AND MONTH = '07'
   and service_id = '18131132865'
