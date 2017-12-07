with tmpAll AS (
select floor ((Code :: Integer)  / 1000) * 1000 as code1
     , floor ((Code :: Integer)  / 100) * 100 as code2
     , code :: Integer as code3
     , Name1, Name2, Name3
from
(
 select '10101' as code, '��������� �������� ������������' as Name1, '����� �� ����� ������' as Name2, '����� �� ����� ������' as Name3
union select '10201', '��������� �������� ������������', '������', '�������� ������'
union select '10202', '��������� �������� ������������', '������', '������ outlet'
union select '10203', '��������� �������� ������������', '������', '������ �������'
union select '10204', '��������� �������� ������������', '������', '������ ��������������'
union select '10301', '��������� �������� ������������', '������������� ����������', '������������� ����������'
union select '10401', '��������� �������� ������������', '������� �� ����������', '������� �� ����������'
union select '10501', '��������� �������� ������������', '����� ���������', '����� ���������'
union select '10601', '��������� �������� ������������', '������������� ���������', '������������� ���������'
union select '10701', '��������� �������� ������������', '������� �������� ������������', '������� �������� ������������'
union select '20101', '���������������� �������', '���������� �����', '���������� �����'
union select '20102', '���������������� �������', '���������� �����', '������������ ������'
union select '20103', '���������������� �������', '���������� �����', '������ ����������'
union select '20104', '���������������� �������', '���������� �����', '���������������'
union select '20105', '���������������� �������', '���������� �����', '���������'
union select '20106', '���������������� �������', '���������� �����', '������ ���'
union select '20107', '���������������� �������', '���������� �����', '����'
union select '20108', '���������������� �������', '���������� �����', '���'
union select '30101', '������� �� ���������', '���������� ��������', '���������� �����'
union select '30102', '������� �� ���������', '���������� ��������', '������������ ������'
union select '30103', '������� �� ���������', '���������� ��������', '������ ����������'
union select '30104', '������� �� ���������', '���������� ��������', '���������������'
union select '30105', '������� �� ���������', '���������� ��������', '���������'
union select '30106', '������� �� ���������', '���������� ��������', '������ ���'
union select '30107', '������� �� ���������', '���������� ��������', '����'
union select '30108', '������� �� ���������', '���������� ��������', '���'
union select '40101', '������', '����� �� �������', '����� �� �������'
union select '40201', '������', '���', '���'
union select '40301', '������', '��������� ������� (������)', '��������� ������� (������)'
union select '40401', '������', '��������� ������� �� ��', '��������� ������� �� ��'
union select '40501', '������', '������ � ������*', '������ � ������*'
union select '50101', '�������������� �������', '������ ������', '������ ������'
union select '50201', '�������������� �������', '������ ���������������', '������ ���������������'
union select '50301', '�������������� �������', '���������� �� �/�', '����� �� ����� ������'
union select '50302', '�������������� �������', '���������� �� �/�', '������'
union select '50303', '�������������� �������', '���������� �� �/�', '������������� ����������'
union select '50401', '�������������� �������', '�������� �� �/�', '����� ���������'
union select '50402', '�������������� �������', '�������� �� �/�', '������������� ���������'
union select '60101', '������� � �������', '���������� ������������', '�������� �� ��������'
union select '60102', '������� � �������', '���������� ������������', '������'
union select '60201', '������� � �������', '�������� �������', '������'
union select '60202', '������� � �������', '�������� �������', '���������'
union select '60203', '������� � �������', '�������� �������', '��������'
union select '60204', '������� � �������', '�������� �������', '�/��'
union select '60205', '������� � �������', '�������� �������', '�����'
union select '60301', '������� � �������', '�������� �������������', '����������'
union select '60302', '������� � �������', '�������� �������������', '����������'
union select '60401', '������� � �������', '������', '������'
union select '70101', '������ �������', '������ �������', '������ �������'
) as tmp
)

, tmpProfitLossGroup AS (select distinct Name1, Code1  from tmpAll order by 2)
, tmpProfitLossDirection AS (select distinct Name2, Code2 from tmpAll order by 2)


-- 3 - ProfitLoss
select gpInsertUpdate_Object_ProfitLoss     ((Select Id from Object WHERE DescId = zc_Object_ProfitLoss() and ObjectCode = Code3)
                                           , Code3 :: Integer
                                           , Name3
                                           , (Select Id from Object WHERE DescId = zc_Object_ProfitLossGroup() and ObjectCode = Code1) -- ProfitLossGroupId
                                           , (Select Id from Object WHERE DescId = zc_Object_ProfitLossDirection() and ObjectCode = Code2) -- ProfitLossDirectionId
                                           , (Select Id from Object WHERE DescId = zc_Object_InfoMoneyDestination() and ValueData = Name3) -- InfoMoneyDestinationId
                                           , 0
                                           , zfCalc_UserAdmin()
                                            )
from (-- 1 - ProfitLossGroup
      with tmp1 AS (select gpInsertUpdate_Object_ProfitLossGroup ((Select Id from Object WHERE DescId = zc_Object_ProfitLossGroup() and ValueData = Name1)
                                                                    , Code1 :: Integer
                                                                    , Name1
                                                                    , zfCalc_UserAdmin()
                                                                     ) AS Id
                         from tmpProfitLossGroup as tmp
                         
                         union all
                         -- 2 - ProfitLossDirection
                         select gpInsertUpdate_Object_ProfitLossDirection
                                                                     ((Select Id from Object WHERE DescId = zc_Object_ProfitLossDirection() and ObjectCode = Code2)
                                                                    , Code2 :: Integer
                                                                    , Name2
                                                                    , zfCalc_UserAdmin()
                                                                     ) AS Id
                         from tmpProfitLossDirection as tmp
                        )
          , tmp2 AS (SELECT * FROM tmpAll CROSS JOIN (SELECT MAX (Id) AS MAX_Id FROM tmp1) AS tmp_max)
          select Name1, Name2, Name3, Code1, Code2, Code3
           -- , (Select Id from Object WHERE DescId = zc_Object_ProfitLossGroup() and ObjectCode = Code1) AS ProfitLossGroupId
           -- , (Select Id from Object WHERE DescId = zc_Object_ProfitLossDirection() and ObjectCode = Code2) AS ProfitLossDirectionId
           -- , (Select Id from Object WHERE DescId = zc_Object_InfoMoneyDestination() and ValueData = Name3) AS InfoMoneyDestinationId
      from tmp2
      order by Code3
     ) as tmp
;
