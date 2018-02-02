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
union select '10301', '������', '������ ���������������', '������ ���������������'
union select '20101', '�������������', '���������', '���������'
union select '20201', '�������������', '������ ���', '***���� ������'
union select '20202', '�������������', '������ ���', '***������ ���'
union select '20301', '�������������', '����', '***������'
union select '20302', '�������������', '����', '***����. � ����������'
union select '20303', '�������������', '����', '***���. �������'
union select '20304', '�������������', '����', '***�������������'
union select '20305', '�������������', '����', '***������ ����'
union select '20401', '�������������', '���', '���'
union select '20501', '�������������', '���������������', '***���������������'
union select '20601', '�������������', '������ ����������', '***����. � ����������'
union select '20602', '�������������', '������ ����������', '***������������'
union select '20603', '�������������', '������ ����������', '***������ �����'
union select '20604', '�������������', '������ ����������', '������ �����'
union select '20605', '�������������', '������ ����������', '***������ ���������'
union select '20606', '�������������', '������ ����������', '�����������, ������������'
union select '20607', '�������������', '������ ����������', '***������ ������, ������'
union select '20608', '�������������', '������ ����������', '***�������'
union select '20609', '�������������', '������ ����������', '������ ���.�����'
union select '20701', '�������������', '������������ ������', '��������������'
union select '20702', '�������������', '������������ ������', '����'
union select '20703', '�������������', '������������ ������', '���'
union select '20704', '�������������', '������������ ������', '����� ���'
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
union select '80101', '����������� �������', '�������������� �������', '�������������� �������'
union select '80201', '����������� �������', '�������������� �������', '�������������� �������'
union select '80301', '����������� �������', '������� � �����������', '*1'
union select '80302', '����������� �������', '������� � �����������', '*2'
union select '80303', '����������� �������', '������� � �����������', '*3'
union select '80304', '����������� �������', '������� � �����������', '*4'
union select '80401', '����������� �������', '������� �������� �������', '������� �������� �������'
union select '80501', '����������� �������', '������', '������� � �������'
union select '80502', '����������� �������', '������', '������� �����������'
) as tmp
)

, tmpInfoMoneyGroup AS (select distinct Name1, Code1  from tmpAll order by 2)
, tmpInfoMoneyDestination AS (select distinct Name2, Code2 from tmpAll order by 2)

-- 3 - InfoMoney
select gpInsertUpdate_Object_InfoMoney      ((Select Id from Object WHERE DescId = zc_Object_InfoMoney() and ObjectCode = Code3)
                                           , Code3 :: Integer
                                           , Name3
                                           , (Select Id from Object WHERE DescId = zc_Object_InfoMoneyGroup() and ObjectCode = Code1) -- InfoMoneyGroupId
                                           , (Select Id from Object WHERE DescId = zc_Object_InfoMoneyDestination() and ObjectCode = Code2) --  InfoMoneyDestinationId
                                           , FALSE
                                           , zfCalc_UserAdmin()
                                            )
from (-- 1 - InfoMoneyGroup
      with tmp1 AS (select gpInsertUpdate_Object_InfoMoneyGroup ((Select Id from Object WHERE DescId = zc_Object_InfoMoneyGroup() and ValueData = Name1)
                                                               , Code1 :: Integer
                                                               , Name1
                                                               , zfCalc_UserAdmin()
                                                                ) AS Id
                    from tmpInfoMoneyGroup as tmp
                    
                    union all
                    -- 2 - InfoMoneyDestination
                    select gpInsertUpdate_Object_InfoMoneyDestination
                                                                ((Select Id from Object WHERE DescId = zc_Object_InfoMoneyDestination() and ObjectCode = Code2)
                                                               , Code2 :: Integer
                                                               , Name2
                                                               , zfCalc_UserAdmin()
                                                                ) AS Id
                    from tmpInfoMoneyDestination as tmp
                   )
          , tmp2 AS (SELECT * FROM tmpAll CROSS JOIN (SELECT MAX (Id) AS MAX_Id FROM tmp1) AS tmp_max)
      select Name1, Name2, Name3, Code1, Code2, Code3
           -- , (Select Id from Object WHERE DescId = zc_Object_InfoMoneyGroup() and ObjectCode = Code1) AS InfoMoneyGroupId
           -- , (Select Id from Object WHERE DescId = zc_Object_InfoMoneyDestination() and ObjectCode = Code2) AS InfoMoneyDestinationId
      from tmp2
      order by Code3
     ) as tmp
;
