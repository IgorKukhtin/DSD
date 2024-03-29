CREATE OR REPLACE FUNCTION zc_ObjectLink_User_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_User_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_User_Unit', '�������������', zc_Object_User(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_User_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_UserFormSettings_User() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UserFormSettings_User'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_UserFormSettings_User', '������������', zc_Object_UserFormSettings(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UserFormSettings_User');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Account_AccountGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Account_AccountGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Account_AccountGroup', '����� ����� � ������� ������', zc_Object_Account(), zc_Object_AccountGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Account_AccountGroup');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Account_AccountDirection() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Account_AccountDirection'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Account_AccountDirection', '����� ����� � ��������� ������ - �����������', zc_Object_Account(), zc_Object_AccountDirection() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Account_AccountDirection');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ProfitLoss_ProfitLossGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ProfitLoss_ProfitLossGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ProfitLoss_ProfitLossGroup', '����� ������ ������ � �������� � ������� � ������� ������ ������ � �������� � �������', zc_Object_ProfitLoss(), zc_Object_ProfitLossGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ProfitLoss_ProfitLossGroup');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ProfitLoss_ProfitLossDirection() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ProfitLoss_ProfitLossDirection'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ProfitLoss_ProfitLossDirection', '����� ������ ������ � �������� � ������� � ���������� ������ ������ � �������� � ������� - �����������', zc_Object_ProfitLoss(), zc_Object_ProfitLossDirection() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ProfitLoss_ProfitLossDirection');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ProfitLoss_InfoMoneyDestination() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ProfitLoss_InfoMoneyDestination'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ProfitLoss_InfoMoneyDestination', '����� ������ ������ � �������� � ������� � �������������� ����������', zc_Object_ProfitLoss(), zc_Object_InfoMoneyDestination() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ProfitLoss_InfoMoneyDestination');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ProfitLoss_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ProfitLoss_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ProfitLoss_InfoMoney', '����� ������ ������ � �������� � ������� � �������������� ����������', zc_Object_ProfitLoss(), zc_Object_InfoMoney() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ProfitLoss_InfoMoney');

CREATE OR REPLACE FUNCTION zc_ObjectLink_UserRole_Role() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UserRole_Role'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_UserRole_Role', '������ �� ���� � ����������� ����� ������������� � �����', zc_Object_UserRole(), zc_Object_Role() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UserRole_Role');

CREATE OR REPLACE FUNCTION zc_ObjectLink_UserRole_User() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UserRole_User'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_UserRole_User', '����� � ������������� � ����������� ����� ������������', zc_Object_UserRole(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UserRole_User');

CREATE OR REPLACE FUNCTION zc_ObjectLink_RoleRight_Process() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RoleRight_Process'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_RoleRight_Process', '������ �� ������� � ����������� �������� �����', zc_Object_RoleRight(), zc_Object_Process() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RoleRight_Process');

CREATE OR REPLACE FUNCTION zc_ObjectLink_RoleRight_Role() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RoleRight_Role'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_RoleRight_Role', '������ �� ���� � ����������� �������� �����', zc_Object_RoleRight(), zc_Object_Role() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RoleRight_Role');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Personal_Member() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_Member'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Personal_Member', '���.����', zc_Object_Personal(), zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_Member');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Personal_Position() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_Position'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Personal_Position', '���������', zc_Object_Personal(), zc_Object_Position() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_Position');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Personal_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Personal_Unit', '�������������', zc_Object_Personal(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_User_Member() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_User_Member'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_User_Member', '���.����', zc_Object_User(), zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_User_Member');

-- new

CREATE OR REPLACE FUNCTION zc_ObjectLink_Composition_CompositionGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Composition_CompositionGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Composition_CompositionGroup', '������ ��� ������� ������', zc_Object_Composition(), zc_Object_CompositionGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Composition_CompositionGroup');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_GoodsGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Goods_GoodsGroup', '������ �������', zc_Object_Goods(), zc_Object_GoodsGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsGroup');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_Measure() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_Measure'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Goods_Measure', '��.���.', zc_Object_Goods(), zc_Object_Measure() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_Measure');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_Composition() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_Composition'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Goods_Composition', '������', zc_Object_Goods(), zc_Object_Composition() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_Composition');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_GoodsInfo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsInfo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Goods_GoodsInfo', '��������', zc_Object_Goods(), zc_Object_GoodsInfo() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsInfo');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_LineFabrica() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_LineFabrica'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Goods_LineFabrica', '�����', zc_Object_Goods(), zc_Object_GoodsInfo() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_LineFabrica');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_Label() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_Label'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Goods_Label', '��������', zc_Object_Goods(), zc_Object_Label() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_Label');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Goods_InfoMoney', '������ ����������', zc_Object_Goods(), zc_Object_InfoMoney() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_InfoMoney');


CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsGroup_Parent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsGroup_Parent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsGroup_Parent', '������', zc_Object_GoodsGroup(), zc_Object_GoodsGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsGroup_Parent');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsGroup_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsGroup_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsGroup_InfoMoney', '������ ����������', zc_Object_GoodsGroup(), zc_Object_InfoMoney() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsGroup_InfoMoney');


CREATE OR REPLACE FUNCTION zc_ObjectLink_Account_InfoMoneyDestination() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Account_InfoMoneyDestination'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Account_InfoMoneyDestination', '�������������� ����������', zc_Object_Account(), zc_Object_InfoMoneyDestination() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Account_InfoMoneyDestination');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Account_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Account_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Account_InfoMoney', '�������������� ���������', zc_Object_Account(), zc_Object_InfoMoney() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Account_InfoMoney');

CREATE OR REPLACE FUNCTION zc_ObjectLink_InfoMoney_InfoMoneyGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_InfoMoney_InfoMoneyGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_InfoMoney_InfoMoneyGroup', '����� ������ ���������� � ������� �������������� ����������', zc_Object_InfoMoney(), zc_Object_InfoMoneyGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_InfoMoney_InfoMoneyGroup');

CREATE OR REPLACE FUNCTION zc_ObjectLink_InfoMoney_InfoMoneyDestination() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_InfoMoney_InfoMoneyDestination'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_InfoMoney_InfoMoneyDestination', '����� ������ ���������� � �������������� �����������', zc_Object_InfoMoney(), zc_Object_InfoMoneyDestination() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_InfoMoney_InfoMoneyDestination');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Account_AccountKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Account_AccountKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Account_AccountKind', '��� �����', zc_Object_Account(), zc_Object_AccountKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Account_AccountKind');


CREATE OR REPLACE FUNCTION zc_ObjectLink_DiscountTools_Discount() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_DiscountTools_Discount'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_DiscountTools_Discount', '�������� ������������� ������', zc_Object_DiscountTools(), zc_Object_Discount() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_DiscountTools_Discount');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_Brand() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_Brand'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Partner_Brand', '�������� �����', zc_Object_Partner(), zc_Object_Brand() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_Brand');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_Fabrika() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_Fabrika'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Partner_Fabrika', '�������', zc_Object_Partner(), zc_Object_Fabrika() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_Fabrika');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_Period() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_Period'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Partner_Period', '������', zc_Object_Partner(), zc_Object_Period() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_Period');


CREATE OR REPLACE FUNCTION zc_ObjectLink_ReportOLAP_User() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReportOLAP_User'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ReportOLAP_User', '������������', zc_Object_ReportOLAP(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReportOLAP_User');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ReportOLAP_Object() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReportOLAP_Object'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ReportOLAP_Object', '����������', zc_Object_ReportOLAP(), zc_Object_Brand() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReportOLAP_Object');


CREATE OR REPLACE FUNCTION zc_ObjectLink_JuridicalGroup_Parent() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalGroup_Parent'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_JuridicalGroup_Parent', '������', zc_Object_JuridicalGroup(), zc_Object_JuridicalGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalGroup_Parent');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Juridical_JuridicalGroup() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Juridical_JuridicalGroup'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Juridical_JuridicalGroup', '������ ����������� ���', zc_Object_Juridical(), zc_Object_JuridicalGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Juridical_JuridicalGroup');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_Juridical() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Juridical'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Unit_Juridical', '����������� ����', zc_Object_Unit(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_Parent() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Parent'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Unit_Parent', '������', zc_Object_Unit(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Parent');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_Child() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Child'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Unit_Child', '������������� (�����)', zc_Object_Unit(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Child');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_AccountDirection() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_AccountDirection'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Unit_AccountDirection', '����� � ��������� �������������� ������ - �����������', zc_Object_Unit(), zc_Object_AccountDirection() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_AccountDirection');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_BankAccount() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_BankAccount'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Unit_BankAccount', '��������� ����', zc_Object_Unit(), zc_Object_BankAccount() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_BankAccount');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_GoodsGroup() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_GoodsGroup'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Unit_GoodsGroup', '����� � ������ ������', zc_Object_Unit(), zc_Object_GoodsGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_GoodsGroup');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_PriceList() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_PriceList'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Unit_PriceList', '����� � ����� ������', zc_Object_Unit(), zc_Object_GoodsGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_PriceList');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_GoodsTag() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_GoodsTag'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Unit_GoodsTag', '����� � ��������� ������', zc_Object_Unit(), zc_Object_GoodsTag() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_GoodsTag');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_PeriodTag() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_PeriodTag'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Unit_PeriodTag', '����� � ����� (��� ��������� ���.)', zc_Object_Unit(), zc_Object_Period() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_PeriodTag');


CREATE OR REPLACE FUNCTION zc_ObjectLink_Client_City() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Client_City'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Client_City', '���������� �����', zc_Object_Client(), zc_Object_City() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Client_City');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Client_DiscountKind() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Client_DiscountKind'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Client_DiscountKind', '��� ������', zc_Object_Client(), zc_Object_DiscountKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Client_DiscountKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Client_LastUser() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Client_LastUser'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Client_LastUser', '������������ ������������� ��������� �������', zc_Object_Client(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Client_LastUser');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Client_InsertUnit() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Client_InsertUnit'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Client_InsertUnit', '������������� (��������)', zc_Object_Client(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Client_InsertUnit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Client_Currency() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Client_Currency'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Client_Currency', '������', zc_Object_Client(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Client_Currency');


CREATE OR REPLACE FUNCTION zc_ObjectLink_Brand_CountryBrand() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Brand_CountryBrand'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Brand_CountryBrand', '������ �������������', zc_Object_Brand(), zc_Object_CountryBrand() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Brand_CountryBrand');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Discount_DiscountKind() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Discount_DiscountKind'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Discount_DiscountKind', '��� ������', zc_Object_Discount(), zc_Object_DiscountKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Discount_DiscountKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PriceList_Currency() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PriceList_Currency'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_PriceList_Currency', '������', zc_Object_PriceList(), zc_Object_Currency() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PriceList_Currency');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PriceListItem_PriceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PriceListItem_PriceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_PriceListItem_PriceList', '�����-����', zc_Object_PriceListItem(), zc_Object_PriceList() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PriceListItem_PriceList');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PriceListItem_Goods()  RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PriceListItem_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_PriceListItem_Goods', '�����', zc_Object_PriceListItem(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PriceListItem_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_DiscountPeriodItem_Goods()  RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_DiscountPeriodItem_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_DiscountPeriodItem_Goods', '�����', zc_Object_DiscountPeriodItem(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_DiscountPeriodItem_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_DiscountPeriodItem_Unit()  RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_DiscountPeriodItem_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_DiscountPeriodItem_Unit', '�������������', zc_Object_DiscountPeriodItem(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_DiscountPeriodItem_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_RoleAction_Role() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RoleAction_Role'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_RoleAction_Role', '������ �� ���� � ����������� �������� �����', zc_Object_RoleAction(), zc_Object_Role() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RoleAction_Role');

CREATE OR REPLACE FUNCTION zc_ObjectLink_RoleAction_Action() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RoleAction_Action'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_RoleAction_Action', '������ �� �������� � ����������� ����� �����', zc_Object_RoleAction(), zc_Object_Action() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RoleAction_Action');

CREATE OR REPLACE FUNCTION zc_ObjectLink_RoleProcessAccess_Role() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RoleProcessAccess_Role'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_RoleProcessAccess_Role', '������ �� ���� � ����������� �������� �����', zc_Object_RoleProcessAccess(), zc_Object_Role() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RoleProcessAccess_Role');

CREATE OR REPLACE FUNCTION zc_ObjectLink_RoleProcessAccess_Process() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RoleProcessAccess_Process'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_RoleProcessAccess_Process', '������ �� ���� � ����������� �������� �����', zc_Object_RoleProcessAccess(), zc_Object_Process() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RoleProcessAccess_Process');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Cash_Currency() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Cash_Currency'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Cash_Currency', '������', zc_Object_Cash(), zc_Object_Currency() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Cash_Currency');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Cash_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Cash_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Cash_Unit', '�������������', zc_Object_Cash(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Cash_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Bank_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Bank_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Bank_Juridical', '����������� ����', zc_Object_Bank(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Bank_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_BankAccount_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BankAccount_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_BankAccount_Juridical', '����������� ����', zc_Object_BankAccount(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BankAccount_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_BankAccount_Bank() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BankAccount_Bank'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_BankAccount_Bank', '����', zc_Object_BankAccount(), zc_Object_Bank() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BankAccount_Bank');

CREATE OR REPLACE FUNCTION zc_ObjectLink_BankAccount_Currency() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BankAccount_Currency'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_BankAccount_Currency', '������', zc_Object_BankAccount(), zc_Object_Currency() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BankAccount_Currency');

CREATE OR REPLACE FUNCTION zc_ObjectLink_DiscountPeriod_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_DiscountPeriod_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_DiscountPeriod_Unit', '�������������', zc_Object_DiscountPeriod(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_DiscountPeriod_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_DiscountPeriod_Period() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_DiscountPeriod_Period'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_DiscountPeriod_Period', '�����', zc_Object_DiscountPeriod(), zc_Object_Period() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_DiscountPeriod_Period');


CREATE OR REPLACE FUNCTION zc_ObjectLink_Protocol_Insert() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Protocol_Insert'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Protocol_Insert', '������������ (��������)', zc_Object_User(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Protocol_Insert');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Protocol_Update() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Protocol_Update'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Protocol_Update', '������������ (�������������)', zc_Object_User(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Protocol_Update');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ProfitLossDemo_Unit() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ProfitLossDemo_Unit'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ProfitLossDemo_Unit', '�������������', zc_Object_ProfitLossDemo(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ProfitLossDemo_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ProfitLossDemo_ProfitLoss() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ProfitLossDemo_ProfitLoss'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ProfitLossDemo_ProfitLoss', '������ ������ � �������� � �������', zc_Object_ProfitLossDemo(), zc_Object_ProfitLoss() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ProfitLossDemo_ProfitLoss');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ImportSettings_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportSettings_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ImportSettings_Juridical', '����� � �� �����', zc_Object_ImportSettings(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportSettings_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ImportSettings_FileType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportSettings_FileType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ImportSettings_FileType', '����� � ����� �����', zc_Object_ImportSettings(), zc_Object_FileTypeKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportSettings_FileType');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ImportSettings_ImportType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportSettings_ImportType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ImportSettings_ImportType', '����� � ���� �������', zc_Object_ImportSettings(), zc_Object_ImportType() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportSettings_ImportType');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ImportSettingsItems_ImportSettings() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportSettingsItems_ImportSettings'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ImportSettingsItems_ImportSettings', '����� � ��������� �������', zc_Object_ImportSettingsItems(), zc_Object_ImportSettings() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportSettingsItems_ImportSettings');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ImportSettingsItems_ImportTypeItems() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportSettingsItems_ImportTypeItems'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ImportSettingsItems_ImportTypeItems', '����� � ��������� ��������� �������', zc_Object_ImportSettingsItems(), zc_Object_ImportTypeItems() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportSettingsItems_ImportTypeItems');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ImportTypeItems_ImportType() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportTypeItems_ImportType'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ImportTypeItems_ImportType', '������ �� ��� �������', zc_Object_ImportTypeItems(), zc_Object_ImportType() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportTypeItems_ImportType');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ImportSettings_Email() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportSettings_Email'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ImportSettings_Email', '�������� ����', zc_Object_ImportSettings(), zc_Object_Email() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportSettings_Email');

-- CREATE OR REPLACE FUNCTION zc_ObjectLink_TranslateWord_Language() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_TranslateWord_Language'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
-- SELECT 'zc_ObjectLink_TranslateWord_Language', '����', zc_Object_TranslateWord(), zc_Object_Language() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_TranslateWord_Language');

-- CREATE OR REPLACE FUNCTION zc_ObjectLink_TranslateWord_Parent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_TranslateWord_Parent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
-- SELECT 'zc_ObjectLink_TranslateWord_Parent', '�������', zc_Object_TranslateWord(), zc_Object_TranslateWord() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_TranslateWord_Parent');

-- CREATE OR REPLACE FUNCTION zc_ObjectLink_TranslateWord_Form() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_TranslateWord_Form'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
-- SELECT 'zc_ObjectLink_TranslateWord_Form', '����� ����������', zc_Object_TranslateWord(), zc_Object_Form() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_TranslateWord_Form');

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.  ��������� �.�.
22.09.20          * zc_ObjectLink_TranslateWord_Language
                    zc_ObjectLink_TranslateWord_Parent
                    zc_ObjectLink_TranslateWord_Form
07.02.20          * zc_ObjectLink_Client_Currency
28.01.20          * zc_ObjectLink_Unit_PriceList
29.03.19          * zc_ObjectLink_ImportSettings_Juridical
                    zc_ObjectLink_ImportSettings_FileType
                    zc_ObjectLink_ImportSettings_ImportType
12.03.19          * zc_ObjectLink_ProfitLossDemo_ProfitLoss
                    zc_ObjectLink_ProfitLossDemo_Unit
23.02.18          * zc_ObjectLink_DiscountPeriod_Unit
                    zc_ObjectLink_DiscountPeriod_Period
07.06.17          * zc_ObjectLink_GoodsGroup_InfoMoney
                    zc_ObjectLink_Goods_InfoMoney
07.06.17          * zc_ObjectLink_Unit_AccountDirection
10.05.17                                                         *
09.05.17                                                         *
08.05.17                                                         *
05.05.17                                                         *
28.04.17          * add zc_ObjectLink_PriceList_Currency
10.03.17                                                         *
02.03.17                                                         *
28.02.17                                                         * 
*/