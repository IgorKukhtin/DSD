with tmpAll AS (
select floor ((Code :: Integer)  / 1000) * 1000 as code1
     , floor ((Code :: Integer)  / 100) * 100 as code2
     , code :: Integer as code3
     , Name1, Name2, Name3
from
(
 select '10101' as code, '������' as Name1, '��������' as Name2, '������' as Name3
union select '10102', '������', '��������', '���������'
union select '10201', '������', '������', '������'
union select '10202', '������', '������', '���������'
union select '20101', '��������', '���������� ', '������'
union select '20102', '��������', '���������� ', '������� ������� ��������'
union select '20201', '��������', '�������� �� �������', '������ ���������������'
union select '20301', '��������', '������ ��������', '������ ������'
union select '30101', '�������� �������� ', '�����', '�����*****'
union select '30102', '�������� �������� ', '�����', '� ������'
union select '30201', '�������� �������� ', '����� ���������', '�����*****'
union select '30202', '�������� �������� ', '����� ���������', '� ������'
union select '30301', '�������� �������� ', '��������� ����', '��������� ����*****'
union select '30302', '�������� �������� ', '��������� ����', '� ������'
union select '40101', '����������� ������', '���������������� ��', '�������� ��������*****'
union select '40102', '����������� ������', '���������������� ��', '����������� ������'
union select '40103', '����������� ������', '���������������� ��', '����������� �������������'
union select '40104', '����������� ������', '���������������� ��', '����������� ����������'
union select '40201', '����������� ������', '���', '���'
union select '60101', '���������', '����������', '������'
union select '60102', '���������', '����������', '���������'
union select '60201', '���������', '����������', '���������� �����'
union select '60301', '���������', '��������� �� �������', '������ ����������'
union select '60401', '���������', '������������ ������', '������������ ������'
union select '60501', '���������', '���������������� ��', '����������� ������'
union select '60502', '���������', '���������������� ��', '����������� �������������'
union select '60503', '���������', '���������������� ��', '����������� ����������'
union select '70101', '������������', '������� ������', '������� ������'
union select '70201', '������������', '������ �������', '������ �������'
union select '70301', '������������', '�������� �� ��������', '�������� �� ��������'
union select '80101', '������� � ��������', '��������� �������', '��������� �������'
union select '80201', '������� � ��������', '��������� ������� (������)', '��������� ������� (������)'
union select '80301', '������� � ��������', '��������� ������� �� ��', '��������� ������� �� ��'
union select '80401', '������� � ��������', '������ � ������', '������ � ������'
union select '100101', '����������� �������', '�������������� �������', '�������������� �������'
union select '100201', '����������� �������', '�������������� �������', '�������������� �������'
union select '100301', '����������� �������', '������� �������� �������', '������� �������� �������*****'
union select '100401', '����������� �������', '������� � �����������', '������� � �����������'
union select '100501', '����������� �������', '������� �����������', '������� �����������*****'
) as tmp
)

, tmpAccountGroup AS (select distinct Name1, Code1  from tmpAll order by 2)
, tmpAccountDirection AS (select distinct Name2, Code2 from tmpAll order by 2)


-- 1 - AccountGroup
select gpInsertUpdate_Object_AccountGroup ((Select Id from Object WHERE DescId = zc_Object_AccountGroup() and ValueData = Name1)
                                           , Code1 :: Integer
                                           , Name1
                                           , zfCalc_UserAdmin()
                                            )
from tmpAccountGroup as tmp

union all
-- 2 - AccountDirection
select gpInsertUpdate_Object_AccountDirection
                                            ((Select Id from Object WHERE DescId = zc_Object_AccountDirection() and ObjectCode = Code2)
                                           , Code2 :: Integer
                                           , Name2
                                           , zfCalc_UserAdmin()
                                            )
from tmpAccountDirection as tmp

union all
-- 3 - Account
select gpInsertUpdate_Object_Account        ((Select Id from Object WHERE DescId = zc_Object_Account() and ObjectCode = Code3)
                                           , Code3 :: Integer
                                           , Name3
                                           , AccountGroupId
                                           , AccountDirectionId
                                           , InfoMoneyDestinationId 
                                           , 0
                                           , zfCalc_UserAdmin()
                                            )
from (select Name1, Name2, Name3, Code1, Code2, Code3
           , (Select Id from Object WHERE DescId = zc_Object_AccountGroup() and ObjectCode = Code1) AS AccountGroupId
           , (Select Id from Object WHERE DescId = zc_Object_AccountDirection() and ObjectCode = Code2) AS AccountDirectionId
           , (Select Id from Object WHERE DescId = zc_Object_InfoMoneyDestination() and ValueData = Name3) AS InfoMoneyDestinationId
      from tmpAll
      order by Code3
     ) as tmp
where 1=0
;
