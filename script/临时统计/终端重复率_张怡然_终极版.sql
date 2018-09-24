 CREATE TABLE TMP_MAJH_0315_01 AS 
 select terminal_code
   from (SELECT terminal_code,
                device_no,
                row_number() over(partition by terminal_code, device_no order by 1) rn
           FROM dw.DW_V_USER_TERMINAL_D
          WHERE ACCT_MONTH = '201803'
            and day_id = '14'
            AND REG_DATE > TO_DATE('20180101', 'YYYY-MM-DD')
            AND REG_DATE < TO_DATE('20180131', 'YYYY-MM-DD'))
  where rn = 1
  GROUP BY terminal_code
 HAVING COUNT(*) > 1;
        
--������     
SELECT C.AREA_DESC,
       COUNT(*),
       COUNT(CASE
               WHEN B.TERMINAL_CODE IS NOT NULL THEN
                A.TERMINAL_CODE
             END)
  FROM (SELECT AREA_NO, DEVICE_NO, TERMINAL_CODE
          FROM DW.DW_V_USER_TERMINAL_DEVICE_M
         WHERE ACCT_MONTH = '201801'
           AND REG_DATE > TO_DATE('20180101', 'YYYY-MM-DD')
           AND REG_DATE < TO_DATE('20180131', 'YYYY-MM-DD')) A,
       TMP_MAJH_0315_01 B,
       DIM.DIM_AREA_NO C
 WHERE A.TERMINAL_CODE = B.TERMINAL_CODE(+)
   AND A.AREA_NO = C.AREA_NO(+)
 GROUP BY C.AREA_DESC, C.IDX_NO
 ORDER BY C.IDX_NO





--��Ʒ��
select a.terminal_corp,
       count(*),
       count(case
               when b.terminal_code is not null then
                a.terminal_code
             end)
  from (SELECT terminal_corp,terminal_model,AREA_NO, DEVICE_NO, terminal_code
          FROM dw.DW_V_USER_TERMINAL_DEVICE_M
         WHERE ACCT_MONTH = '201801'
           AND REG_DATE > TO_DATE('20180101', 'YYYY-MM-DD')
           AND REG_DATE < TO_DATE('20180131', 'YYYY-MM-DD')) a,
       TMP_MAJH_0315_01 b,
       dim.dim_area_no c
 where a.terminal_code = b.terminal_code(+)
   and a.area_no = c.area_no(+)
 group by a.terminal_corp, c.idx_no
 order by c.idx_no
 
 
 
 
 
