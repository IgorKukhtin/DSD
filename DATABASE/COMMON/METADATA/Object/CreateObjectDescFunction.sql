--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! ����� ����� !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_Object_Bank() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Bank'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Bank', '�����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Bank');

CREATE OR REPLACE FUNCTION zc_Object_BankAccount() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_BankAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_BankAccount', '��������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_BankAccount');

CREATE OR REPLACE FUNCTION zc_Object_BankAccountContract() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_BankAccountContract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_BankAccountContract', '��������� ����(������ ���)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_BankAccountContract');

CREATE OR REPLACE FUNCTION zc_Object_Branch() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Branch'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Branch', '�������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Branch');

CREATE OR REPLACE FUNCTION zc_Object_Business() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Business'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Business', '�������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Business');

CREATE OR REPLACE FUNCTION zc_Object_Car() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Car'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Car', '����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Car');

CREATE OR REPLACE FUNCTION zc_Object_CarModel() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CarModel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_CarModel', '������ ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CarModel');

CREATE OR REPLACE FUNCTION zc_Object_Cash() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Cash'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Cash', '�����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Cash');

CREATE OR REPLACE FUNCTION zc_Object_Contract() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Contract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
  SELECT 'zc_Object_Contract', '��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Contract');

CREATE OR REPLACE FUNCTION zc_Object_ContractKind() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_ContractKind', '���� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractKind');

CREATE OR REPLACE FUNCTION zc_Object_Currency() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Currency'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Currency', '������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Currency');

CREATE OR REPLACE FUNCTION zc_Object_PaidKind() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PaidKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_PaidKind', '����� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PaidKind');

CREATE OR REPLACE FUNCTION zc_Object_Program() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Program'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Program', '���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Program');

-------------------------
CREATE OR REPLACE FUNCTION zc_Object_Status() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Status'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Status', '������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Status');

CREATE OR REPLACE FUNCTION zc_Object_GoodsGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsGroup', '������ �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsGroup');

CREATE OR REPLACE FUNCTION zc_Object_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Goods', '���������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Goods');

CREATE OR REPLACE FUNCTION zc_Object_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsKind', '��� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsKind');

CREATE OR REPLACE FUNCTION zc_Object_GoodsProperty() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsProperty'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsProperty', '�������������� ������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsProperty');

CREATE OR REPLACE FUNCTION zc_Object_GoodsPropertyValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsPropertyValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsPropertyValue', '�������� ������� ������� ��� ��������������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsPropertyValue');

CREATE OR REPLACE FUNCTION zc_Object_Measure() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Measure'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Measure', '������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Measure');

CREATE OR REPLACE FUNCTION zc_Object_InfoMoneyGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoneyGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_InfoMoneyGroup', '������ �������������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoneyGroup');

CREATE OR REPLACE FUNCTION zc_Object_InfoMoneyDestination() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoneyDestination'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_InfoMoneyDestination', '�����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoneyDestination');

CREATE OR REPLACE FUNCTION zc_Object_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_InfoMoney', '�������������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoney');

CREATE OR REPLACE FUNCTION zc_Object_AccountGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AccountGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AccountGroup', '������ ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AccountGroup');

CREATE OR REPLACE FUNCTION zc_Object_AccountDirection() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AccountDirection'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AccountDirection', '��������� ����� (�����)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AccountDirection');

CREATE OR REPLACE FUNCTION zc_Object_Account() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Account'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Account', '����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Account');

CREATE OR REPLACE FUNCTION zc_Object_ProfitLossGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLossGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ProfitLossGroup', '������ ������ �� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLossGroup');

CREATE OR REPLACE FUNCTION zc_Object_ProfitLossDirection() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLossDirection'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ProfitLossDirection', '������ ������ �� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLossDirection');

CREATE OR REPLACE FUNCTION zc_Object_ProfitLoss() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLoss'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ProfitLoss', '������ �� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLoss');

CREATE OR REPLACE FUNCTION zc_Object_JuridicalGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_JuridicalGroup', '������ ��. ���' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalGroup');

CREATE OR REPLACE FUNCTION zc_Object_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Juridical', '����������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Juridical');

CREATE OR REPLACE FUNCTION zc_Object_Partner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Partner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Partner', '�����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Partner');

-- CREATE OR REPLACE FUNCTION zc_Object_UnitGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_UnitGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Unit', '�������������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Unit');

CREATE OR REPLACE FUNCTION zc_Object_Route() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Route'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Route', '��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Route');

CREATE OR REPLACE FUNCTION zc_Object_RouteSorting() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RouteSorting'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RouteSorting', '���������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RouteSorting');

CREATE OR REPLACE FUNCTION zc_Object_PriceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PriceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PriceList', '�����-�����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PriceList');

CREATE OR REPLACE FUNCTION zc_Object_PriceListItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PriceListItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PriceListItem', '���� �����-�����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PriceListItem');

-- CREATE OR REPLACE FUNCTION zc_Object_AccountPlan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AccountPlan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Object_Process() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Process'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Process', '��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Process');

CREATE OR REPLACE FUNCTION zc_Object_Role() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Role'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Role', '����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Role');

CREATE OR REPLACE FUNCTION zc_object_User() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_object_User'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_object_User', '������������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_object_User');

CREATE OR REPLACE FUNCTION zc_Object_RoleRight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RoleRight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RoleRight', '��������� ���� �� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RoleRight');

CREATE OR REPLACE FUNCTION zc_Object_UserRole() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_UserRole'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_UserRole', '����� ������������� � �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_UserRole');

CREATE OR REPLACE FUNCTION zc_Object_Form() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Form'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Form', '����� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Form');

CREATE OR REPLACE FUNCTION zc_Object_UserFormSettings() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_UserFormSettings'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_UserFormSettings', '���������������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_UserFormSettings');

CREATE OR REPLACE FUNCTION zc_Object_Member() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Member'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Member', '���������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Member');

CREATE OR REPLACE FUNCTION zc_Object_Position() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Position'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Position', '���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Position');

CREATE OR REPLACE FUNCTION zc_Object_Personal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Personal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Personal', '����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Personal');

CREATE OR REPLACE FUNCTION zc_Object_AssetGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AssetGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AssetGroup', '������ �������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AssetGroup');

CREATE OR REPLACE FUNCTION zc_Object_Asset() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Asset'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Asset', '�������� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Asset');

CREATE OR REPLACE FUNCTION zc_Object_PartionGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PartionGoods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PartionGoods', '������ �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PartionGoods');

CREATE OR REPLACE FUNCTION zc_Object_PartionMovement() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PartionMovement'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PartionMovement', '������ ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PartionMovement');

CREATE OR REPLACE FUNCTION zc_Object_TradeMark() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_TradeMark'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_TradeMark', '�������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_TradeMark');

CREATE OR REPLACE FUNCTION zc_Object_AccountKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AccountKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AccountKind', '���� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AccountKind');

CREATE OR REPLACE FUNCTION zc_Object_GoodsByGoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsByGoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsByGoodsKind', '����� ������ � ���� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsByGoodsKind');

CREATE OR REPLACE FUNCTION zc_object_receipt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_object_receipt'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_object_receipt', '���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_object_receipt');

CREATE OR REPLACE FUNCTION zc_Object_ReceiptCost() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReceiptCost'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ReceiptCost', '������� � ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReceiptCost');

CREATE OR REPLACE FUNCTION zc_Object_ReceiptChild() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReceiptChild'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ReceiptChild', '������������ ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReceiptChild');


CREATE OR REPLACE FUNCTION zc_object_goodskindcomplete() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_object_goodskindcomplete'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_object_goodskindcomplete', '���� ������� (������� ���������)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_object_goodskindcomplete');


CREATE OR REPLACE FUNCTION zc_object_receiptkind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_object_receiptkind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_object_receiptkind', '���� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_object_receiptkind');

CREATE OR REPLACE FUNCTION zc_Object_Action() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Action'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Action', '������� ������ ������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Action');

CREATE OR REPLACE FUNCTION zc_Object_RoleAction() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RoleAction'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RoleAction', '����� ���� � ������� ������ ������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RoleAction');

CREATE OR REPLACE FUNCTION zc_Object_Fuel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Fuel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Fuel', '���� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Fuel');

CREATE OR REPLACE FUNCTION zc_Object_Freight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Freight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Freight', '�������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Freight');

CREATE OR REPLACE FUNCTION zc_Object_PersonalGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PersonalGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PersonalGroup', '����������� �����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PersonalGroup');

CREATE OR REPLACE FUNCTION zc_Object_RateFuel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RateFuel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RateFuel', '����� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RateFuel');

CREATE OR REPLACE FUNCTION zc_Object_RateFuelKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RateFuelKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RateFuelKind', '���� ���� ��� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RateFuelKind');

CREATE OR REPLACE FUNCTION zc_Object_RouteKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RouteKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RouteKind', '���� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RouteKind');

CREATE OR REPLACE FUNCTION zc_Object_WorkTimeKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_WorkTimeKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_WorkTimeKind', '���� �������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_WorkTimeKind');

CREATE OR REPLACE FUNCTION zc_Object_CardFuel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CardFuel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CardFuel', '��������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CardFuel');

CREATE OR REPLACE FUNCTION zc_Object_TicketFuel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_TicketFuel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_TicketFuel', '������ �� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_TicketFuel');

CREATE OR REPLACE FUNCTION zc_Object_PositionLevel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PositionLevel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PositionLevel', '������ ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PositionLevel');

CREATE OR REPLACE FUNCTION zc_Object_StaffList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StaffList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_StaffList', '������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StaffList');

CREATE OR REPLACE FUNCTION zc_Object_ModelServiceKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ModelServiceKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ModelServiceKind', '���� ������ ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ModelServiceKind');

CREATE OR REPLACE FUNCTION zc_Object_ModelService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ModelService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ModelService', '������ ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ModelService');

CREATE OR REPLACE FUNCTION zc_Object_StaffListCost() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StaffListCost'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_StaffListCost', '�������� �������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StaffListCost');

CREATE OR REPLACE FUNCTION zc_Object_ModelServiceItemMaster() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ModelServiceItemMaster'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ModelServiceItemMaster', '������� �������� ������ ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ModelServiceItemMaster');

CREATE OR REPLACE FUNCTION zc_Object_ModelServiceItemChild() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ModelServiceItemChild'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ModelServiceItemChild', '����������� �������� ������ ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ModelServiceItemChild');

CREATE OR REPLACE FUNCTION zc_Object_SelectKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_SelectKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_SelectKind', '���� ������ ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_SelectKind');

CREATE OR REPLACE FUNCTION zc_Object_StaffListSummKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StaffListSummKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_StaffListSummKind', '���� ���� ��� �������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StaffListSummKind');

CREATE OR REPLACE FUNCTION zc_Object_StaffListSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StaffListSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_StaffListSumm', 'C���� ��� �������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StaffListSumm');

CREATE OR REPLACE FUNCTION zc_Object_ContractStateKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractStateKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContractStateKind', '��������� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractStateKind');

CREATE OR REPLACE FUNCTION zc_Object_ContractArticle() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractArticle'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContractArticle', '������� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractArticle');

CREATE OR REPLACE FUNCTION zc_Object_Area() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Area'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Area', '�������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Area');

CREATE OR REPLACE FUNCTION zc_Object_ContractConditionKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractConditionKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContractConditionKind', '���� ������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractConditionKind');

CREATE OR REPLACE FUNCTION zc_Object_ContractCondition() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractCondition'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContractCondition', '������� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractCondition');

CREATE OR REPLACE FUNCTION zc_Object_Calendar() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Calendar'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Calendar', '��������� ������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Calendar');

CREATE OR REPLACE FUNCTION zc_Object_AccessRole() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AccessRole'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AccessRole', '���� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AccessRole');

CREATE OR REPLACE FUNCTION zc_Object_RoleProcessAccess() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RoleProcessAccess'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RoleProcessAccess', '����� ����� � ��������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RoleProcessAccess');

CREATE OR REPLACE FUNCTION zc_Object_ContractDocument() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractDocument'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContractDocument', '����� ���������� � ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractDocument');

CREATE OR REPLACE FUNCTION zc_Object_DocumentTaxKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_DocumentTaxKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_DocumentTaxKind', '���� ������������ ���������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_DocumentTaxKind');

CREATE OR REPLACE FUNCTION zc_Object_Country() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Country'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Country', '������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Country');

CREATE OR REPLACE FUNCTION zc_Object_Maker() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Maker'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Maker', '������������� (��)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Maker');

-- CREATE OR REPLACE FUNCTION zc_Object_Document() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Document'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- INSERT INTO ObjectDesc (Code, ItemName)
--  SELECT 'zc_Object_Document', '���������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Document');

CREATE OR REPLACE FUNCTION zc_Object_BonusKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_BonusKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_BonusKind', '���� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_BonusKind');

CREATE OR REPLACE FUNCTION zc_Object_ToolsWeighing() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ToolsWeighing'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ToolsWeighing', '��������� �����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ToolsWeighing');

CREATE OR REPLACE FUNCTION zc_Object_GoodsKindWeighing() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsKindWeighing'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsKindWeighing', '���� �������� ��� �����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsKindWeighing');

CREATE OR REPLACE FUNCTION zc_Object_GoodsKindWeighingGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsKindWeighingGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsKindWeighingGroup', '������ ����� �������� ��� �����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsKindWeighingGroup');


CREATE OR REPLACE FUNCTION zc_Object_ContractTag() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractTag'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContractTag', '������� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractTag');

CREATE OR REPLACE FUNCTION zc_Object_ContractKey() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractKey'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContractKey', '���� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractKey');

CREATE OR REPLACE FUNCTION zc_Object_InvNumberTax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_InvNumberTax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_InvNumberTax', '��������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_InvNumberTax');

CREATE OR REPLACE FUNCTION zc_Object_EDIStatus() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_EDIStatus'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_EDIStatus', '������� ���������� EDI' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_EDIStatus');

CREATE OR REPLACE FUNCTION zc_Object_Retail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Retail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Retail', '�������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Retail');

CREATE OR REPLACE FUNCTION zc_Object_Region() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Region'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Region', '�������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Region');

CREATE OR REPLACE FUNCTION zc_Object_Province() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Province'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Province', '�����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Province');


CREATE OR REPLACE FUNCTION zc_Object_CityKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CityKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CityKind', '��� ����������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CityKind');

CREATE OR REPLACE FUNCTION zc_Object_City() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_City'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_City', '���������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_City');

CREATE OR REPLACE FUNCTION zc_Object_ProvinceCity() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ProvinceCity'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ProvinceCity', '����� � ���������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ProvinceCity');

CREATE OR REPLACE FUNCTION zc_Object_StreetKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StreetKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_StreetKind', '���(�����,��������)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StreetKind');

CREATE OR REPLACE FUNCTION zc_Object_Street() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Street'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Street', '�����,��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Street');

CREATE OR REPLACE FUNCTION zc_Object_ContactPersonKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContactPersonKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContactPersonKind', '��� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContactPersonKind');

CREATE OR REPLACE FUNCTION zc_Object_ContactPerson() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContactPerson'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContactPerson', '���������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContactPerson');

CREATE OR REPLACE FUNCTION zc_Object_EDIEvents() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_EDIEvents'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_EDIEvents', '������� EDI' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_EDIEvents');

CREATE OR REPLACE FUNCTION zc_Object_Storage() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Storage'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Storage', '����� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Storage');
  
CREATE OR REPLACE FUNCTION zc_Object_ArticleLoss() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ArticleLoss'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ArticleLoss', '������ ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ArticleLoss');

CREATE OR REPLACE FUNCTION zc_Object_Founder() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Founder'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Founder', '����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Founder');

CREATE OR REPLACE FUNCTION zc_Object_GoodsGroupStat() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsGroupStat'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsGroupStat', '������ �������(����������)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsGroupStat');

CREATE OR REPLACE FUNCTION zc_Object_PersonalServiceList() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PersonalServiceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_PersonalServiceList', '��������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PersonalServiceList');

--!!! ������
CREATE OR REPLACE FUNCTION zc_Object_FileTypeKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_FileTypeKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_FileTypeKind', '���� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_FileTypeKind');

CREATE OR REPLACE FUNCTION zc_Object_ImportSettings() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ImportSettings'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ImportSettings', '��������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ImportSettings');

CREATE OR REPLACE FUNCTION zc_Object_ImportSettingsItems() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ImportSettingsItems'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ImportSettingsItems', '��������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ImportSettingsItems');

CREATE OR REPLACE FUNCTION zc_Object_ImportType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ImportType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ImportType', '���� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ImportType');

CREATE OR REPLACE FUNCTION zc_Object_ImportTypeItems() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ImportTypeItems'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ImportTypeItems', '�������� ���� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ImportTypeItems');

CREATE OR REPLACE FUNCTION zc_Object_JuridicalSettings() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalSettings'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_JuridicalSettings', '��������� ��� ��. ���' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalSettings');

CREATE OR REPLACE FUNCTION zc_Object_LinkGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_LinkGoods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_LinkGoods', '' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_LinkGoods');

CREATE OR REPLACE FUNCTION zc_Object_NDSKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_NDSKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_NDSKind', '���� ���' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_NDSKind');

CREATE OR REPLACE FUNCTION zc_Object_PriceGroupSettings() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PriceGroupSettings'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PriceGroupSettings', '��������� ��� ������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PriceGroupSettings');

CREATE OR REPLACE FUNCTION zc_Object_ServiceDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ServiceDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ServiceDate', '������ ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ServiceDate');

CREATE OR REPLACE FUNCTION zc_Object_GoodsTag() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsTag'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsTag', '������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsTag');


--------------------------- !!!!!!!!!!!!!!!!!!!!!!!!!
--------------------------- !!! ��������� ������� !!!
--------------------------- !!!!!!!!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_Object_Partner1CLink() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Partner1CLink'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Partner1CLink', '����� ����� �������� � ����� � 1�' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Partner1CLink');

CREATE OR REPLACE FUNCTION  zc_Object_GoodsByGoodsKind1CLink() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsByGoodsKind1CLink'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsByGoodsKind1CLink', '����� ����� ������ � ����� � 1�' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsByGoodsKind1CLink');


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 04.09.14                                                        * + zc_Object_ServiceDate
 01.09.14         * add zc_Object_ArticleLoss, zc_Object_Founder
 26.07.14                      	                 * add zc_Object_Storage
 01.05.14                      	                 * add zc_Object_InvNumberTax
 25.04.14         * add zc_Object_BankAccountContract
 21.04.14         * add zc_Object_ContractKey()
                        zc_Object_ContractTag()
 25.03.14                                                        * + zc_Object_GoodsKindWeighingGroup
 21.03.14                                                        * + zc_Object_GoodsKindWeighing
 12.03.14                                                        * + zc_Object_ToolsWeighing
 19.02.14         * add zc_Object_BonusKind()
 11.02.14                      	                 * del 11.02.14 :)
 11.02.14                      	                                * add zc_Object_Document
 09.02.14                      					* add zc_Object_DocumentTaxKind
 27.01.14                       * add zc_Object_Partner1CLink
 10.12.13                       * add zc_Object_ContractDocument
 16.11.13         * add zc_Object_ContractConditionKind, zc_Object_ContractCondition
 14.11.13         * add zc_Object_ContractStateKind, zc_Object_ContractArticle, zc_Object_Area
 30.10.13         * add zc_object_stafflistsummkind, zc_Object_StaffListSumm
 19.10.13         * add zc_Object_ModelService,
                        zc_Object_StaffListCost,
                        zc_Object_ModelServiceItemMaster
                        zc_Object_ModelServiceItemChild,
                        zc_Object_SelectKind
 18.10.13         * add zc_Object_ModelServiceKind
 17.10.13         * add zc_Object_PositionLevel
 13.10.13                                        * add zc_Object_CardFuel and zc_Object_TicketFuel
 01.10.13         * add zc_Object_WorkTimeKind
 25.09.13         * Add zc_Object_PersonalGroup, zc_Object_RateFuelKind, zc_Object_RouteKind
 24.09.13         * Add	zc_Object_Fuel, zc_Object_Freight
 21.08.13         * ����� ����� 2
 08.07.13         * ������� ����� �� ����� �����
 28.06.13                                        * ����� �����
*/
