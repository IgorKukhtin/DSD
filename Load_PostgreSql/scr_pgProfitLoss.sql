drop table dba._pgProfitLoss;

create table dba._pgProfitLoss (Id integer not null default autoincrement, ObjectCode Integer not null, Name1 TVarCharMedium not null, Name2 TVarCharMedium not null, Name3 TVarCharMedium not null, Id1_Postgres integer null, Id2_Postgres integer null, Id3_Postgres integer null, PRIMARY KEY (ObjectCode));

insert into dba._pgProfitLoss (ObjectCode, Name1, Name2, Name3)

-- select '10101', '��������� �������� ������������', '����� ����������', '������ �����' union all
select '10101', '��������� �������� ������������', '����� ����������', '���������' union all
select '10102', '��������� �������� ������������', '����� ����������', '���� ' union all
-- select '10301', '��������� �������� ������������', '������ �� ������', '������ �����' union all
select '10201', '��������� �������� ������������', '������ �� ������', '���������' union all
select '10202', '��������� �������� ������������', '������ �� ������', '���� ' union all
-- select '10401', '��������� �������� ������������', '������ ��������������', '������ �����' union all
select '10301', '��������� �������� ������������', '������ ��������������', '���������' union all
select '10302', '��������� �������� ������������', '������ ��������������', '���� ' union all
-- select '10501', '��������� �������� ������������', '������������� ����������', '������ �����' union all
select '10401', '��������� �������� ������������', '������������� ����������', '���������' union all
select '10402', '��������� �������� ������������', '������������� ����������', '���� ' union all
-- select '10501', '��������� �������� ������������', '������ �� ���', '������ �����' union all
select '10501', '��������� �������� ������������', '������ �� ���', '���������' union all
select '10502', '��������� �������� ������������', '������ �� ���', '���� ' union all
-- select '10601', '��������� �������� ������������', '������� �� ����������', '������ �����' union all
select '10601', '��������� �������� ������������', '������� �� ����������', '���������' union all
select '10602', '��������� �������� ������������', '������� �� ����������', '���� ' union all
-- select '10701', '��������� �������� ������������', '����� ���������', '������ �����' union all
select '10701', '��������� �������� ������������', '����� ���������', '���������' union all
select '10702', '��������� �������� ������������', '����� ���������', '���� ' union all
-- select '10801', '��������� �������� ������������', '������������� ���������', '������ �����' union all
select '10801', '��������� �������� ������������', '������������� ���������', '���������' union all
select '10802', '��������� �������� ������������', '������������� ���������', '���� ' union all
-- select '10901', '��������� �������� ������������', '���������� ���������', '������ �����' union all
select '10901', '��������� �������� ������������', '���������� ���������', '���������' union all
-- select '11001', '��������� �������� ������������', '������� �������', '������ �����' union all
select '11001', '��������� �������� ������������', '������� �������', '���������' union all
select '11002', '��������� �������� ������������', '������� �������', '���� ' union all
-- select '11101', '��������� �������� ������������', '���������', '������ �����' union all
select '11101', '��������� �������� ������������', '���������', '���������' union all
-- select '11201', '��������� �������� ������������', '������� �������� ������������', '������ �����' union all
select '11201', '��������� �������� ������������', '������� �������� ������������', '���������' union all
select '11202', '��������� �������� ������������', '������� �������� ������������', '���� ' union all


select '20101', '�������������������� �������', '���������� ������������', '�������� � �������' union all
select '20102', '�������������������� �������', '���������� ������������', '������ ���' union all
select '20103', '�������������������� �������', '���������� ������������', '��������� ����' union all
select '20104', '�������������������� �������', '���������� ������������', '������ ���������' union all
select '20105', '�������������������� �������', '���������� ������������', '������ ����������' union all
select '20106', '�������������������� �������', '���������� ������������', '���������� �����' union all
select '20201', '�������������������� �������', '���������� �������', '�������� � �������' union all
select '20202', '�������������������� �������', '���������� �������', '������ ���' union all
select '20203', '�������������������� �������', '���������� �������', '��������� ����' union all
select '20204', '�������������������� �������', '���������� �������', '������ ���������' union all
select '20205', '�������������������� �������', '���������� �������', '������ ����������' union all
select '20206', '�������������������� �������', '���������� �������', '���������� �����' union all
select '20301', '�������������������� �������', '���������� ����������', '�������� � �������' union all
select '20302', '�������������������� �������', '���������� ����������', '������ ���' union all
select '20303', '�������������������� �������', '���������� ����������', '���' union all
select '20304', '�������������������� �������', '���������� ����������', '������ ����������' union all
select '20305', '�������������������� �������', '���������� ����������', '���������� �����' union all
select '20401', '�������������������� �������', '���������� �����', '�������� � �������' union all
select '20402', '�������������������� �������', '���������� �����', '������ ���' union all
select '20403', '�������������������� �������', '���������� �����', '���������� �����' union all
select '20404', '�������������������� �������', '���������� �����', '������ �����' union all
select '20405', '�������������������� �������', '���������� �����', '������ �����' union all
select '20406', '�������������������� �������', '���������� �����', '���������' union all
select '20407', '�������������������� �������', '���������� �����', '������' union all
select '20408', '�������������������� �������', '���������� �����', '���� ' union all
select '20501', '�������������������� �������', '������ ������ (��������+��������������)', '������ �����' union all
select '20502', '�������������������� �������', '������ ������ (��������+��������������)', '������ �����' union all
select '20503', '�������������������� �������', '������ ������ (��������+��������������)', '�����������' union all
select '20504', '�������������������� �������', '������ ������ (��������+��������������)', '���������' union all
select '20505', '�������������������� �������', '������ ������ (��������+��������������)', '������' union all
select '20506', '�������������������� �������', '������ ������ (��������+��������������)', '���� ' union all
select '20507', '�������������������� �������', '������ ������ (��������+��������������)', '�����' union all
select '20508', '�������������������� �������', '������ ������ (��������+��������������)', '��������' union all
select '20601', '�������������������� �������', '������������ ������', '������������ ������' union all
select '30101', '���������������� �������', '���������� �����', '�������� � �������' union all
select '30102', '���������������� �������', '���������� �����', '������ ���' union all
select '30103', '���������������� �������', '���������� �����', '������ ����������' union all
select '30104', '���������������� �������', '���������� �����', '���������� �����' union all
select '30105', '���������������� �������', '���������� �����', '����������������' union all
select '30201', '���������������� �������', '���������� ����������', '�������� � �������' union all
select '30202', '���������������� �������', '���������� ����������', '������ ���' union all
select '30203', '���������������� �������', '���������� ����������', '���' union all
select '30204', '���������������� �������', '���������� ����������', '������ ����������' union all
select '30205', '���������������� �������', '���������� ����������', '���������� �����' union all
select '30301', '���������������� �������', '���������� ������', '������ ���' union all
select '30302', '���������������� �������', '���������� ������', '������ ����������' union all
select '30303', '���������������� �������', '���������� ������', '���������� �����' union all
select '30401', '���������������� �������', '������������ ������', '������������ ������' union all
select '40101', '������� �� ����', '���������� ����������', '�������� � �������' union all
select '40102', '������� �� ����', '���������� ����������', '������ ���' union all
select '40103', '������� �� ����', '���������� ����������', '���' union all
select '40104', '������� �� ����', '���������� ����������', '������ ����������' union all
select '40105', '������� �� ����', '���������� ����������', '���������� �����' union all
select '40201', '������� �� ����', '���������� ��������', '�������� � �������' union all
select '40202', '������� �� ����', '���������� ��������', '������ ���' union all
select '40203', '������� �� ����', '���������� ��������', '���' union all
select '40204', '������� �� ����', '���������� ��������', '������ ����������' union all
select '40205', '������� �� ����', '���������� ��������', '���������� �����' union all
select '40206', '������� �� ����', '���������� ��������', '����������������' union all
select '40207', '������� �� ����', '���������� ��������', '������������ ������' union all
select '40208', '������� �� ����', '���������� ��������', '���������' union all
select '40209', '������� �� ����', '���������� ��������', '������� � ����' union all
select '40301', '������� �� ����', '�������������', '������ ���' union all
select '40302', '������� �� ����', '�������������', '������ ����������' union all
select '40303', '������� �� ����', '�������������', '���������� �����' union all
select '40304', '������� �� ����', '�������������', '����������������' union all
select '40305', '������� �� ����', '�������������', '���������' union all
select '40401', '������� �� ����', '������ ������ (��������+��������������)', '���������' union all
select '40402', '������� �� ����', '������ ������ (��������+��������������)', '������' union all
select '40403', '������� �� ����', '������ ������ (��������+��������������)', '���� ' union all
select '50101', '������', '����� �� �������', '����� �� �������' union all
select '50201', '������', '���', '���' union all
select '50301', '������', '��������� ������� (������)', '��������� ������� (������)' union all
select '50401', '������', '��������� ������� �� ��', '��������� ������� �� ��' union all
select '50501', '������', '������ � ������', '������ � ������' union all
select '60101', '�����������', '���������������� ��', '�������� ��������' union all
select '60102', '�����������', '���������������� ��', '����������� ������' union all
select '60103', '�����������', '���������������� ��', '����������� �������������' union all
select '60104', '�����������', '���������������� ��', '������ �������� ��-��' union all
select '60201', '�����������', '���������������� ��', '�������� ��������' union all
select '60202', '�����������', '���������������� ��', '����������� ������' union all
select '60203', '�����������', '���������������� ��', '����������� �������������' union all
select '60204', '�����������', '���������������� ��', '������ �������� ��-��' union all
select '60301', '�����������', '���', '���' union all
select '70101', '�������������� �������', '���������� ����� ���������', '���� ' union all
select '70102', '�������������� �������', '���������� ����� ���������', '�����' union all
select '70201', '�������������� �������', '������', '������' union all
select '70202', '�������������� �������', '������', '������ ������' union all
select '70203', '�������������� �������', '������', '������� �����������' union all
select '70204', '�������������� �������', '������', '������ ���������������' union all
select '70205', '�������������� �������', '������', '��������' union all
select '70206', '�������������� �������', '������', '�����' union all
select '70301', '�������������� �������', '���������� (���������, �����)', '�������� � �������' union all
select '70302', '�������������� �������', '���������� (���������, �����)', '������ ���' union all
select '70303', '�������������� �������', '���������� (���������, �����)', '���' union all
select '70304', '�������������� �������', '���������� (���������, �����)', '������ �����' union all
select '70305', '�������������� �������', '���������� (���������, �����)', '������ �����' union all
select '70306', '�������������� �������', '���������� (���������, �����)', '���������' union all
select '70307', '�������������� �������', '���������� (���������, �����)', '������' union all
select '70401', '�������������� �������', '�������� ������������ �������������', '������ �����' union all
select '70402', '�������������� �������', '�������� ������������ �������������', '������ ���' union all
select '70403', '�������������� �������', '�������� ������������ �������������', '������ ����������' union all
select '80101', '������� � �������', '���������� ������������', '�������� �� ��������' union all
select '80102', '������� � �������', '���������� ������������', '����' union all
select '80103', '������� � �������', '���������� ������������', '�������� �������' union all
select '80201', '������� � �������', '������(�������)', '���������' union all
select '80202', '������� � �������', '������(�������)', '������ �����' union all
select '80203', '������� � �������', '������(�������)', '���� ' union all
select '80301', '������� � �������', '�������� ����������� �������������', '���������' union all
select '80302', '������� � �������', '�������� ����������� �������������', '������ �����' union all
select '80303', '������� � �������', '�������� ����������� �������������', '������ ���������������' union all
select '80401', '������� � �������', '������', '������' union all
select '90101', '������ �������', '������ �������', '������ �������'
order by 1;

-- update _pgProfitLoss set Id = 5300+Id;

commit;


