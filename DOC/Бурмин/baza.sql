-- InfoMoneyName
update Object set ValueData = '����� 1'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 10101; -- ����� ���
update Object set ValueData = '����� 2'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 10102; -- �������
update Object set ValueData = '����� 3'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 10103; -- ��������
update Object set ValueData = '����� 4'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 10104; -- ������

-- InfoMoneyName
update Object set ValueData = '���. ����� *1*'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 10105; -- ������ ������ �����
update Object set ValueData = '���. ����� *2*'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 10106; -- ���

-- InfoMoneyName
update Object set ValueData = '������������'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 10201; -- ������
update Object set ValueData = '����������'    from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 10202; -- ��������

-- InfoMoneyName
update Object set ValueData = '������ ��������'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 20801; -- ����
update Object set ValueData = '������ ������ 1'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 20901; -- ����
update Object set ValueData = '������ ������ 2'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 21001; -- ����� 
update Object set ValueData = '������ ������ 3'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 21101; -- �������
update Object set ValueData = '������ ��������'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyDestinationId = Object.Id  and InfoMoneyCode = 20801; -- ����
update Object set ValueData = '������ ������ 1'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyDestinationId = Object.Id  and InfoMoneyCode = 20901; -- ����
update Object set ValueData = '������ ������ 2'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyDestinationId = Object.Id  and InfoMoneyCode = 21001; -- ����� 
update Object set ValueData = '������ ������ 3'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyDestinationId = Object.Id  and InfoMoneyCode = 21101; -- �������

-- InfoMoneyName
update Object set ValueData = '�������� ��������� �����'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 21406; -- �������� ������� �����
-- InfoMoneyName
update Object set ValueData = '������ �� ������. �����'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 21502; -- ������ �� ������ �����
update Object set ValueData = '��������� ������ ������ 3'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 21511; -- ��������� ����

-- InfoMoneyName
update Object set ValueData = '�� ������ ������ 2'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 30102; -- �������
update Object set ValueData = '�� ������ ������ 3'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 30103; -- ����
update Object set ValueData = '�����'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 30201; -- ������ �����
update Object set ValueData = '�����'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyDestinationId = Object.Id  and InfoMoneyCode = 30201; -- ������ �����

-- InfoMoneyName
update Object set ValueData = '�������'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 40701; -- ����
update Object set ValueData = '�������'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyDestinationId = Object.Id  and InfoMoneyCode = 40701; -- ����
-- InfoMoneyName
update Object set ValueData = '��� �����'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 70402; -- �������

-- InfoMoneyName
update Object set ValueData = '�'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 80301; -- 
update Object set ValueData = '�'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 80302; -- 
update Object set ValueData = '�'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 80303; -- 
update Object set ValueData = '�'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 80304; -- 

-- InfoMoneyDestinationName = �������� ����� - ������ �����
-- update Object set ValueData = Object_InfoMoney_View.InfoMoneyDestinationName || ' ' || Object.Id :: TVarChar
 update Object set ValueData = Object_InfoMoney_View.InfoMoneyName || ' ' || Object.Id :: TVarChar
from ObjectLink
     join Object_InfoMoney_View on Object_InfoMoney_View.InfoMoneyId = ObjectLink.ChildObjectId
                               and InfoMoneyCode between 10101 and 10106
where ObjectLink.DescId = zc_ObjectLink_Goods_InfoMoney() 
   and Object.Id = ObjectLink.ObjectId;

-- InfoMoneyDestinationName = �������� ����� - ������ �����
 update Object set ValueData = Object_InfoMoney_View.InfoMoneyName || ' ' || Object.Id :: TVarChar
from ObjectLink
     join Object_InfoMoney_View on Object_InfoMoney_View.InfoMoneyId = ObjectLink.ChildObjectId
                               and InfoMoneyCode between 10201 and 10204
where ObjectLink.DescId = zc_ObjectLink_Goods_InfoMoney() 
   and Object.Id = ObjectLink.ObjectId;

-- InfoMoneyDestinationName = ������ �����
 update Object set ValueData = Object_InfoMoney_View.InfoMoneyName || ' ' || Object.Id :: TVarChar
from ObjectLink
     join Object_InfoMoney_View on Object_InfoMoney_View.InfoMoneyId = ObjectLink.ChildObjectId
                               and InfoMoneyCode between 30101 and 10204
where ObjectLink.DescId = zc_ObjectLink_Goods_InfoMoney() 
   and Object.Id = ObjectLink.ObjectId;




