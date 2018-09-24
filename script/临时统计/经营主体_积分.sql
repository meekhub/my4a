    --EXECUTE IMMEDIATE 'TRUNCATE TABLE MID_BWT_PRD_PD_VIEW';
    
    create table MID_INT_PRD_PD_JF as 
    select * from MID_BWT_PRD_PD_VIEW where 1=2
    
    INSERT INTO MID_INT_PRD_PD_JF
      SELECT A.STAFF_ID, A.SALES_CODE, '', B.OPERATORS_NBR, ''
        FROM (SELECT *
                FROM (SELECT A.*,
                             ROW_NUMBER() OVER(PARTITION BY A.STAFF_ID ORDER BY EFFECT_DATE DESC) RN
                        FROM (SELECT B.DEALER_ID,
                                     A.SALES_CODE,
                                     A.STAFF_ID,
                                     B.EFFECT_DATE
                                FROM DSG_STAGE.CHANNEL_MEMBER A,
                                     DSG_STAGE.BD_CHANNEL_STAFF_T B
                               WHERE A.STAFF_ID = B.STAFF_ID(+)) A)
               WHERE RN = 1) A, --网点与销售员之间的关系
             (SELECT *
                FROM (SELECT OFFICE_NO,
                             OPERATORS_NBR,
                             ROW_NUMBER() OVER(PARTITION BY OFFICE_NO ORDER BY OPERATORS_NBR) RN
                        FROM DSG_STAGE.BD_AGENT_INFO_T       U,
                             DSG_STAGE.BD_BLC_AGENT_OFFICE_T B --网点与经营主体对应关系
                       WHERE U.AGENT_ID = B.AGENT_NO)
               WHERE RN = 1) B
       WHERE A.DEALER_ID = B.OFFICE_NO(+);
    COMMIT;
    
truncate table MID_INT_PRD_PD_JF
  
CREATE TABLE  MID_INT_PRD_PD_JF  AS
SELECT DEALER_ID, SALES_CODE, STAFF_ID, OPERATORS_NBR
  FROM (SELECT X.* ,ROW_NUMBER() OVER(PARTITION BY STAFF_ID ORDER BY EFFECT_DATE DESC) RN
          FROM (SELECT B.DEALER_ID,
                       A.SALES_CODE,
                       A.STAFF_ID,
                       D.OPERATORS_NBR,
                       B.EFFECT_DATE
                  FROM DSG_STAGE.CHANNEL_MEMBER        A,
                       DSG_STAGE.BD_CHANNEL_STAFF_T    B,
                       DSG_STAGE.BD_BLC_AGENT_OFFICE_T C,
                       DSG_STAGE.BD_AGENT_INFO_T       D
                 WHERE A.STAFF_ID = B.STAFF_ID(+)
                   AND B.DEALER_ID = C.OFFICE_NO(+)
                   AND C.AGENT_NO = D.AGENT_ID(+)) X
         WHERE OPERATORS_NBR IS NOT NULL)
 WHERE RN = 1
 
 
 
 select * from MID_INT_PRD_PD_JF a where staff_id='S10266672'
 
 
 
 select * from DSG_STAGE.CHANNEL_MEMBER a where a.channel_member_name='马建辉'
 
 
 
 select count(*),count(distinct staff_id) from DSG_STAGE.CHANNEL_MEMBER;
 
 
 select count(*) from MID_BWT_PRD_PD_VIEW x where x.operators_nbr is not null
 
 

 
 
 
 
 
