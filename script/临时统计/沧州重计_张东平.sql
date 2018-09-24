create table tmp_majh_0416_01 as
select  a.user_no,c.device_number,c.total_fee,a.huaxiao_type,IS_HUAXIAO_01,IS_HUAXIAO_02,IS_HUAXIAO_03,IS_HUAXIAO_04
  from (select *
          from (select a.*,
                       row_number() over(partition by user_no order by total_fee desc) rn
                  from tmp_majh_zq_hx_201803 a where a.area_no='180')
         where rn = 1) a,
       dim.dim_area_no b�� (select user_no, device_number,
                                  total_fee + total_fee_ocs as total_fee,
                                  IS_HUAXIAO_01,IS_HUAXIAO_02,IS_HUAXIAO_03,IS_HUAXIAO_04
                             from dw.DW_V_USER_HUAXIAO_INFO_M c
                            where acct_month = '201803'
                              and (IS_HUAXIAO_01 = '1' or
                                  IS_HUAXIAO_02 = '1' or
                                  IS_HUAXIAO_03 = '1' or
                                  IS_HUAXIAO_04 = '1')) c
 where a.area_no = b.area_no
   and a.user_no = c.user_no 
   
   
select
user_no �û����룬
device_number �ֻ��ţ�
total_fee ���³������룬
huaxiao_type ����С���ͣ�
IS_HUAXIAO_01 �Ƿ���������
IS_HUAXIAO_02 �Ƿ���Ȧ��
IS_HUAXIAO_03 �Ƿ�������
IS_HUAXIAO_04 �Ƿ�ũ��
 from tmp_majh_0416_01   
