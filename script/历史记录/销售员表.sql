select *
  from (select a.staff_code ����,
               a.staff_name ����Ա����,
               a.common_region_id ����Ա����ID,
               u.region_name ����Ա����,
               --u.zone_number ����,
               e.region_name �ϼ�����,
               a.sales_code ����Ա����,
               decode(a.status_cd,
                      '1000',
                      '��Ч',
                      '1100',
                      '��Ч',
                      '1001',
                      '��ͣ',
                      '1020',
                      'ͣ��') ����Ա״̬,
               ss.������Ա�ù�����,
               ss.�ù�����,
               s2.������Ա��λ,
               s2.��λȡֵ,
               decode(uu.cert_type, '1', '���֤', '����') ֤������,
               decode(b.rela_type,
                      '10',
                      '����',
                      '20',
                      '��������',
                      '30',
                      '����') ������ϵ,
               c.channel_nbr ������Ԫ����,
               c.STRUCT_NAME ������Ԫ����
          from (select to_char(staff_id)staff_id,
                       party_id,
                       staff_code,
                       common_region_id,
                       staff_name,
                       status_cd,
                       sales_code
                  from crm_dsg.staff
                 where common_region_id like '813%') a, --����    ���� ��֯����
               (select staff_id, channel_id, rela_type
                  from crm_dsg.staff_channel_rela) b,
               (select channel_id,
                       channel_nbr,
                       channel_name STRUCT_NAME,
                       common_region_id,
                       status_cd
                  from crm_dsg.channel) c,
               (select common_region_id common_region_id1,
                       region_name,
                       up_region_id,
                       REGION_LEVEL 
                  from crm_dsg.common_region
                 where common_region_id like '813%') u,
               (select common_region_id common_region_id2,
                       region_name,
                       up_region_id,
                       REGION_LEVEL 
                  from crm_dsg.common_region
                 where common_region_id like '813%') e,
               (select common_region_id common_region_id3,
                       region_name,
                       up_region_id,
                       REGION_LEVEL REGION_LEVEL
                  from crm_dsg.common_region
                 where common_region_id like '813%') w,
               (select staff_id,
                       attr_id ������Ա�ù�����,
                       decode(attr_value,
                              '10',
                              '��ͬ��',
                              '20',
                              '��ǲ��',
                              '30',
                              '�����') �ù�����
                  from crm_dsg.staff_attr
                 where attr_id = '50000018') ss,
               (select staff_id,
               a.attr_id ������Ա��λ,
               b.attr_value_Desc ��λȡֵ
          from (select staff_id, attr_id, attr_value
                  from crm_dsg.staff_attr
                 where attr_id = '50000016'
                   and attr_value = 12) a,
               (select attr_id, attr_value, attr_desc attr_value_Desc
                  from crm_dsg.attr_value
                 where attr_id = '50000016') b
         where a.attr_id = b.attr_id(+)
           and a.attr_value = b.attr_value(+) )s2,
         (select party_id, cert_type from crm_dsg.party_certification) uu
         where a.staff_id = b.staff_id
           and a.common_region_id = u.common_region_id1(+)
           and u.up_region_id = e.common_region_id2(+)
           and b.channel_id = c.channel_id(+)
           and c.common_region_id = w.common_region_id3(+)
           and a.party_id = uu.party_id(+)
           and a.status_cd = '1000'
           and a.staff_id = ss.staff_id(+)
           and a.staff_id = s2.staff_id) xsy,
       
       (select a.channel_id,
               channel_nbr,
               a.channel_NAME,
               decode(channel_class, '20', '������', '10', '���۵�', '', '') ���۵����,
               b.STRUCT_NAME ��������,
               c.STRUCT_NAME ��������,
               d.STRUCT_NAME һ������, 
               a.common_region_id ����,
               m.region_name ��������,
               n.region_name �ϼ���������,
               decode(status_Cd,
                      '1001',
                      '������ͣ',
                      '1100',
                      '��Ч',
                      '1000',
                      '��Ч',
                      '1002',
                      '�쳣��ͣ') ״̬,
               a.status_date ״̬���ʱ��
          from crm_dsg.channel a,
               crm_dsg.bd_dealer_structure_t b,
               crm_dsg.bd_dealer_structure_t c,
               crm_dsg.bd_dealer_structure_t d,
               (select common_region_id,
                       region_name,
                       up_region_id,
                       region_Desc
                  from crm_dsg.common_region
                 where common_region_id like '813%') m,
               (select common_region_id,
                       region_name,
                       up_region_id,
                       region_Desc
                  from crm_dsg.common_region
                 where common_region_id like '813%') n
         where a.common_region_id like '813%'
           and a.channel_type_cd = b.channel_type_cd(+)
           and b.CHANNEL_TYPE_CD = c.channel_type_cd(+)
           and c.CHANNEL_TYPE_CD = d.channel_type_cd(+)
           and a.common_region_id = m.common_region_id(+)
           and m.up_region_id = n.common_region_id(+)
           and a.status_Cd = '1000') qddy
 where xsy.������Ԫ���� = qddy.channel_nbr(+)
