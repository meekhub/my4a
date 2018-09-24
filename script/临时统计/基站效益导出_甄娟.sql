select count(*),station_no from   ALLDM.DM_BS_STATION_REPORT a where a.acct_month='201807' 
group by station_no
having count(*)>1


select *
  from ALLDM.DM_BS_STATION_REPORT a
 where a.acct_month = '201807'
   and station_no = '312AX.DC-YD'


--��1��վЧ������ ����
SELECT ACCT_MONTH   ����,
       AREA_NO      ���б�,
       AREA_NAME    ������,
       CITY_NAME    ������,
       STATION_NO   վַ��,
       STATION_NAME վַ��,
       TIETA_NO     ������,
       TIETA_TYPE   ������,
       FLUX_TOTAL   ������,
       FLUX_PRICE   ������,
       FLUX_INCOME  ������,
       FUWU_FEE     �����,
       POWER_FEE    ���,
       ZHEJIU_FEE   �۾ɷ�,
       TOTAL_FEE    �ܷ���,
       MAOLI        ë��,
       MAOLI_RATE   ë����,
       AREA_RANK    ����
  FROM (SELECT A.*,
               ROW_NUMBER() OVER(PARTITION BY A.STATION_NO ORDER BY 1) RN
          FROM ALLDM.DM_BS_STATION_REPORT A
         WHERE A.ACCT_MONTH = '201807') A
 WHERE RN = 1

--��2����3���µ�Ч��վ�嵥 \
SELECT ACCT_MONTH     ����,
       AREA_NO        ���б���,
       AREA_NAME      ��������,
       CITY_NAME      ��������,
       STATION_NO     վַID,
       STATION_NAME   վַ����,
       TIETA_NO       ��������,
       TIETA_TYPE     ��������,
       TOTAL_INCOME_1 ��������,
       TOTAL_FEE_1    ���³ɱ�,
       MAOLI_1        ����ë��,
       MAOLI_RATE_1   ����ë����,
       TOTAL_INCOME_2 ��������,
       TOTAL_FEE_2    ���³ɱ�,
       MAOLI_2        ����ë��,
       MAOLI_RATE_2   ����ë����,
       TOTAL_INCOME_3 ����������,
       TOTAL_FEE_3    �����³ɱ�,
       MAOLI_3        ������ë����,
       MAOLI_RATE_3   ������ë����
  FROM (SELECT A.*,
               ROW_NUMBER() OVER(PARTITION BY A.STATION_NO ORDER BY 1) RN
          FROM ALLDM.DM_BS_STATION_LOW_REPORT A
         WHERE A.ACCT_MONTH = '201807') A
 WHERE RN = 1

--��3��Ч��վ����ͳ��
SELECT ACCT_MONTH           ����,
       AREA_NO              ���б���,
       AREA_NAME            ��������,
       STATION_NUM          վַ����,
       STATION_LOW_NUM      ���µ�Чվַ����,
       STATION_RATE         ���µ�Чվַռ��,
       STATION_LOW_LAST_NUM ���µ�Чվַ����,
       STATION_RATE_ADD     ��������,
       STATION_RATE_REDUCE  ���ȼ���
  FROM ALLDM.DM_BS_STATION_LOW_NUM where ACCT_MONTH = '201807'

--��4����С����СCEOӪ��֧�ţ�
SELECT ACCT_MONTH   ����,
       AREA_NO      ���б���,
       AREA_NAME    ��������,
       CITY_NAME    ��������,
       STATION_NO   վַ����,
       STATION_NAME վַ����,
       XIAOQU_NO    С������,
       XIAOQU_NAME  С������,
       round(UP_FLUX/1024,1)       ��������,
       round(DOWN_FLUX/1024,1)   ��������,
       round(UP_FLUX/1024+DOWN_FLUX/1024,1)   ������
  FROM ALLDM.DM_BS_STATION_FREE_LIST
 WHERE ACCT_MONTH = '201807'


--�����嵥
SELECT distinct  ACCT_MONTH    ����,
       AREA_NO       ���б���,
       AREA_NAME     ��������,
       CITY_NAME     ��������,
       ENB_NO        ����ENBID,
       ENB_NAME      ����ENBID����,
       XIAOQU_NO     С������,
       XIAOQU_NAME   С������,
       ECI           ECI,
       RRU_NO        RRU��ʶ,
       RRU_ELECT_NO  RRU�ĵ������к�,
       FLUX          ��������,
       USER_NUM      �û���,
       ASSET_NO      �ʲ���Ƭ���,
       ASSET_PRICE   �ʲ�ԭֵ,
       ASSESS_RESULT ��Ͻ��,
       INNET_DATE    ����ʱ��
  FROM ALLDM.DM_BS_STATION_RRU_FREE   WHERE ACCT_MONTH = '201807'
  and ASSESS_RESULT='������δ�ﵽ25G'


--RRU��æ��������嵥
SELECT ACCT_MONTH      ����,
       AREA_NO         ���б���,
       AREA_NAME       ��������,
       CITY_NAME       ��������,
       ASSET_NO        �ʲ���Ƭ���,
       ASSET_PRICE     �ʲ�ԭֵ,
       RRU_ELECT_NO    RRU�ĵ������к�,
       XIAOQU_NO       С������_�����嵥,
       XIAOQU_NAME     С������_�����嵥,
       XIAOQU_NO_NEW   С������_��æ��,
       XIAOQU_NAME_NEW С������_��æ��,
       INNET_DATE      ����ʱ��_��æ��,
       RRU_NUM         ��������_��æǰһ����,
       RRU_NUM_NEW     ��������_��æ����,
       RRU_RESULT      �߼��ж�
  FROM ALLDM.DM_BS_STATION_RRU_BUSY
 WHERE ACCT_MONTH = '201807'


--RRU��æ�������
SELECT ACCT_MONTH    ����,
       AREA_NO       ���б���,
       AREA_NAME     ��������,
       RRU_NUM       RRU����,
       RRU_NUM_VALID ��æ��ЧRRU����,
       RRU_BUSY_RATE ��æ����ռ��
  FROM ALLDM.DM_BS_STATION_RRU_RATE  WHERE ACCT_MONTH = '201807';
  
  



































