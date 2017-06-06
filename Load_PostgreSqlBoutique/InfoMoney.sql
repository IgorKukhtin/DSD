with tmpAll AS (
select floor ((Code :: Integer)  / 1000) * 1000 as code1
     , floor ((Code :: Integer)  / 100) * 100 as code2
     , code :: Integer as code3
     , Name1, Name2, Name3
from
(
 select '10101' as code , '������' as Name1, '������' as Name2, '������' as Name3
union select '10102', '������', '������', '�����'
union select '10103', '������', '������', '����������'
union select '10201', '������', '������ ������', '������ ������'
union select '20101', '�������������', '���������', '���������'
union select '20201', '�������������', '������ ���', '***���� ������'
union select '20202', '�������������', '������ ���', '***������ ���'
union select '20301', '�������������', '����', '***������'
union select '20302', '�������������', '����', '***����. � ����������'
union select '20303', '�������������', '����', '***���. �������'
union select '20304', '�������������', '����', '***�������������'
union select '20305', '�������������', '����', '***������ ����'
union select '20401', '�������������', '���������������', '***���������������'
union select '20501', '�������������', '������ ����������', '***����. � ����������'
union select '20502', '�������������', '������ ����������', '***������������'
union select '20503', '�������������', '������ ����������', '***������ �����'
union select '20504', '�������������', '������ ����������', '������ �����'
union select '20505', '�������������', '������ ����������', '***������ ���������'
union select '20506', '�������������', '������ ����������', '�����������, ������������'
union select '20507', '�������������', '������ ����������', '***������ ������, ������'
union select '20508', '�������������', '������ ����������', '***�������'
union select '20509', '�������������', '������ ����������', '������ ���.�����'
union select '20601', '�������������', '������������ ������', '��������������'
union select '20602', '�������������', '������������ ������', '����'
union select '20603', '�������������', '������������ ������', '���'
union select '20604', '�������������', '������������ ������', '����� ���'
union select '30101', '���������� ������������', '������� ������', '������� ������'
union select '30201', '���������� ������������', '������ �������', '������ �������'
union select '30301', '���������� ������������', '�������� �� ��������', '% �� �������� ������'
union select '30302', '���������� ������������', '�������� �� ��������', '% �� ������ ��������'
union select '30303', '���������� ������������', '�������� �� ��������', '% �� ����������'
union select '30401', '���������� ������������', '�����', '�����'
union select '30402', '���������� ������������', '�����', '% �� ������'
union select '30501', '���������� ������������', '��������', '��������'
union select '30502', '���������� ������������', '��������', '% �� ���������'
union select '30601', '���������� ������������', '���������� ������', '���������� ������'
union select '40101', '������� � ��������', '��������� ������� �� ��', '����������'
union select '40102', '������� � ��������', '��������� ������� �� ��', '����������'
union select '40201', '������� � ��������', '��������� �������', '����� �� �������'
union select '40202', '������� � ��������', '��������� �������', '���'
union select '40301', '������� � ��������', '��������� ������� (������)', '������������ �����'
union select '40302', '������� � ��������', '��������� ������� (������)', '����������� ���.�����'
union select '40303', '������� � ��������', '��������� ������� (������)', '����� �� ����'
union select '40304', '������� � ��������', '��������� ������� (������)', '����� �� �����'
union select '40305', '������� � ��������', '��������� ������� (������)', '������ �����'
union select '40306', '������� � ��������', '��������� ������� (������)', '���� ���������'
union select '40401', '������� � ��������', '������ � ������', '������ � ������'
union select '50101', '���������� �����', '���������� �����', '���������� �����'
union select '60101', '����������', '����������� ����������', '���� � ����������'
union select '60102', '����������', '����������� ����������', '�������� ������������'
union select '60103', '����������', '����������� ����������', '����������'
union select '60201', '����������', '����������� ������', '���� � ����������'
union select '60202', '����������', '����������� ������', '�������� ������������'
union select '60203', '����������', '����������� ������', '����������'
union select '60301', '����������', '����������� �������������', '����������� �������������'
union select '60401', '����������', '���', '���'
union select '70101', '����������� �������', '�������������� �������', '�������������� �������'
union select '70201', '����������� �������', '�������������� �������', '�������������� �������'
union select '70301', '����������� �������', '������� � �����������', '*1'
union select '70302', '����������� �������', '������� � �����������', '*2'
union select '70303', '����������� �������', '������� � �����������', '*3'
union select '70304', '����������� �������', '������� � �����������', '*4'
union select '70401', '����������� �������', '������� �������� �������', '������� �������� �������'
union select '70501', '����������� �������', '������', '������� � �������'
union select '70502', '����������� �������', '������', '������� �����������'
) as tmp
)

, tmpInfoMoneyGroup AS (select distinct Name1, Code1  from tmpAll order by 2)
, tmpInfoMoneyDestination AS (select distinct Name2, Code2 from tmpAll order by 2)

-- 1 - InfoMoneyGroup
select gpInsertUpdate_Object_InfoMoneyGroup ((Select Id from Object WHERE DescId = zc_Object_InfoMoneyGroup() and ValueData = Name1)
                                           , Code1 :: Integer
                                           , Name1
                                           , zfCalc_UserAdmin()
                                            )
from tmpInfoMoneyGroup as tmp

union all
-- 2 - InfoMoneyDestination
select gpInsertUpdate_Object_InfoMoneyDestination
                                            ((Select Id from Object WHERE DescId = zc_Object_InfoMoneyDestination() and ObjectCode = Code2)
                                           , Code2 :: Integer
                                           , Name2
                                           , zfCalc_UserAdmin()
                                            )
from tmpInfoMoneyDestination as tmp

union all
-- 3 - InfoMoney
select gpInsertUpdate_Object_InfoMoney      ((Select Id from Object WHERE DescId = zc_Object_InfoMoney() and ObjectCode = Code3)
                                           , Code3 :: Integer
                                           , Name3
                                           , InfoMoneyGroupId
                                           , InfoMoneyDestinationId
                                           , FALSE
                                           , zfCalc_UserAdmin()
                                            )
from (select Name1, Name2, Name3, Code1, Code2, Code3
           , (Select Id from Object WHERE DescId = zc_Object_InfoMoneyGroup() and ObjectCode = Code1) AS InfoMoneyGroupId
           , (Select Id from Object WHERE DescId = zc_Object_InfoMoneyDestination() and ObjectCode = Code2) AS InfoMoneyDestinationId
      from tmpAll
      order by Code3
     ) as tmp
where 1=0
;
