--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! ����� ����� !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_Object_ReplServer() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReplServer'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ReplServer', '������� ��� ������� ��' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReplServer');

CREATE OR REPLACE FUNCTION zc_Object_ReplMovement() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReplMovement'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ReplMovement', '���������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReplMovement');

CREATE OR REPLACE FUNCTION zc_Object_ReplObject() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReplObject'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ReplObject', '���������� ������������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReplObject');

--
CREATE OR REPLACE FUNCTION zc_Object_Account() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Account'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Account', '����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Account');

CREATE OR REPLACE FUNCTION zc_Object_AccountDirection() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AccountDirection'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AccountDirection', '��������� ����� (�����)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AccountDirection');

CREATE OR REPLACE FUNCTION zc_Object_AccountGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AccountGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AccountGroup', '������ ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AccountGroup');

CREATE OR REPLACE FUNCTION zc_Object_AccountKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AccountKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AccountKind', '���� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AccountKind');

CREATE OR REPLACE FUNCTION zc_Object_Action() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Action'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Action', '������� ������ ������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Action');

CREATE OR REPLACE FUNCTION zc_Object_AnalyzerId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AnalyzerId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AnalyzerId', '���� �������� ��� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AnalyzerId');

CREATE OR REPLACE FUNCTION zc_Object_Area() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Area'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Area', '�������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Area');

CREATE OR REPLACE FUNCTION zc_Object_AreaContract() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AreaContact'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_AreaContact', '�������(��������)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AreaContact');

CREATE OR REPLACE FUNCTION zc_Object_Asset() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Asset'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Asset', '�������� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Asset');

CREATE OR REPLACE FUNCTION zc_Object_AssetGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AssetGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AssetGroup', '������ �������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AssetGroup');

CREATE OR REPLACE FUNCTION zc_Object_AccessRole() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AccessRole'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AccessRole', '���� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AccessRole');

CREATE OR REPLACE FUNCTION zc_Object_Bank() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Bank'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Bank', '�����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Bank');

CREATE OR REPLACE FUNCTION zc_Object_BankAccount() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_BankAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_BankAccount', '��������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_BankAccount');

CREATE OR REPLACE FUNCTION zc_Object_BankAccountContract() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_BankAccountContract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_BankAccountContract', '��������� ����(������ ���)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_BankAccountContract');

CREATE OR REPLACE FUNCTION zc_Object_BarCodeBox() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_BarCodeBox'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_BarCodeBox', '���������� �/� ��� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_BarCodeBox');

CREATE OR REPLACE FUNCTION zc_Object_Box() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Box'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Box', '���� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Box');

CREATE OR REPLACE FUNCTION zc_Object_Branch() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Branch'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Branch', '�������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Branch');

CREATE OR REPLACE FUNCTION zc_Object_Business() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Business'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Business', '�������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Business');

CREATE OR REPLACE FUNCTION zc_Object_Calendar() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Calendar'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Calendar', '��������� ������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Calendar');

CREATE OR REPLACE FUNCTION zc_Object_Car() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Car'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Car', '����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Car');

CREATE OR REPLACE FUNCTION zc_Object_CardFuel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CardFuel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CardFuel', '��������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CardFuel');

CREATE OR REPLACE FUNCTION zc_Object_CarExternal() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CarExternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_CarExternal', '���������� (���������)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CarExternal');

CREATE OR REPLACE FUNCTION zc_Object_CarModel() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CarModel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
  SELECT 'zc_Object_CarModel', '������ ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CarModel');

CREATE OR REPLACE FUNCTION zc_Object_Cash() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Cash'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
  SELECT 'zc_Object_Cash', '�����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Cash');

CREATE OR REPLACE FUNCTION zc_Object_CashRegister() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CashRegister'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
  SELECT 'zc_Object_CashRegister', '�������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CashRegister');

CREATE OR REPLACE FUNCTION zc_Object_CashRegisterKind() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CashRegisterKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
  SELECT 'zc_Object_CashRegisterKind', '��� ��������� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CashRegisterKind');

CREATE OR REPLACE FUNCTION zc_Object_ClientKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ClientKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ClientKind', '��������� �����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ClientKind');

CREATE OR REPLACE FUNCTION zc_Object_ContactPerson() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContactPerson'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContactPerson', '���������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContactPerson');

CREATE OR REPLACE FUNCTION zc_Object_ContactPersonKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContactPersonKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContactPersonKind', '��� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContactPersonKind');

CREATE OR REPLACE FUNCTION zc_Object_Contract() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Contract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
  SELECT 'zc_Object_Contract', '��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Contract');

CREATE OR REPLACE FUNCTION zc_Object_ContractArticle() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractArticle'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContractArticle', '������� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractArticle');

CREATE OR REPLACE FUNCTION zc_Object_ContractCondition() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractCondition'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContractCondition', '������� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractCondition');

CREATE OR REPLACE FUNCTION zc_Object_ContractConditionKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractConditionKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContractConditionKind', '���� ������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractConditionKind');

CREATE OR REPLACE FUNCTION zc_Object_ContractDocument() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractDocument'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContractDocument', '����� ���������� � ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractDocument');

CREATE OR REPLACE FUNCTION zc_Object_ContractKind() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_ContractKind', '���� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractKind');

CREATE OR REPLACE FUNCTION zc_Object_ContractStateKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractStateKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContractStateKind', '��������� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractStateKind');

CREATE OR REPLACE FUNCTION zc_Object_CorrespondentAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CorrespondentAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CorrespondentAccount', '����������������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CorrespondentAccount');

CREATE OR REPLACE FUNCTION zc_Object_Currency() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Currency'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Currency', '������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Currency');

CREATE OR REPLACE FUNCTION zc_Object_Form() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Form'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Form', '����� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Form');

CREATE OR REPLACE FUNCTION zc_Object_Freight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Freight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Freight', '�������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Freight');

CREATE OR REPLACE FUNCTION zc_Object_Fuel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Fuel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Fuel', '���� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Fuel');

CREATE OR REPLACE FUNCTION zc_Object_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Goods', '������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Goods');

CREATE OR REPLACE FUNCTION zc_Object_GoodsByGoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsByGoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsByGoodsKind', '����� ������ � ���� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsByGoodsKind');

CREATE OR REPLACE FUNCTION zc_Object_GoodsGroupStat() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsGroupStat'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsGroupStat', '������ �������(����������)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsGroupStat');

CREATE OR REPLACE FUNCTION zc_Object_GoodsGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsGroup', '������ �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsGroup');

CREATE OR REPLACE FUNCTION zc_Object_GoodsGroupAnalyst() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsGroupAnalyst'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_GoodsGroupAnalyst', '������ �������(���������)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsGroupAnalyst');

CREATE OR REPLACE FUNCTION zc_Object_GoodsExternal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsExternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsExternal', '���������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsExternal');

CREATE OR REPLACE FUNCTION zc_Object_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsKind', '��� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsKind');

CREATE OR REPLACE FUNCTION zc_object_goodskindcomplete() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_object_goodskindcomplete'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_object_goodskindcomplete', '���� ������� (������� ���������)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_object_goodskindcomplete');

CREATE OR REPLACE FUNCTION zc_Object_GoodsProperty() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsProperty'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsProperty', '�������������� ������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsProperty');

CREATE OR REPLACE FUNCTION zc_Object_GoodsPropertyValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsPropertyValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsPropertyValue', '�������� ������� ������� ��� ��������������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsPropertyValue');

CREATE OR REPLACE FUNCTION zc_Object_GoodsTag() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsTag'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsTag', '�������� ������� ������� ��� ��������������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsTag');

CREATE OR REPLACE FUNCTION zc_Object_GoodsScaleCeh() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsScaleCeh'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsScaleCeh', '������ ��� �������������� ������� � ������������-����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsScaleCeh');

CREATE OR REPLACE FUNCTION zc_Object_GlobalConst() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GlobalConst'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GlobalConst', '���������� ��������� ��� ������������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GlobalConst');

CREATE OR REPLACE FUNCTION zc_Object_ImportExportLink() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ImportExportLink'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ImportExportLink', '����� �������� ��� ��������, ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ImportExportLink');

CREATE OR REPLACE FUNCTION zc_Object_ImportExportLinkType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ImportExportLinkType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ImportExportLinkType', '����� �������� ��� ��������, ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ImportExportLinkType');

CREATE OR REPLACE FUNCTION zc_Object_ImportGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ImportGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ImportGroup', '������ �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ImportGroup');

CREATE OR REPLACE FUNCTION zc_Object_ImportGroupItems() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ImportGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ImportGroupItems', '�������� ������ �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ImportGroupItems');

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

CREATE OR REPLACE FUNCTION zc_Object_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_InfoMoney', '�������������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoney');

CREATE OR REPLACE FUNCTION zc_Object_InfoMoneyDestination() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoneyDestination'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_InfoMoneyDestination', '�����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoneyDestination');

CREATE OR REPLACE FUNCTION zc_Object_InfoMoneyGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoneyGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_InfoMoneyGroup', '������ �������������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoneyGroup');

CREATE OR REPLACE FUNCTION zc_Object_JuridicalGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_JuridicalGroup', '������ ��. ���' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalGroup');

CREATE OR REPLACE FUNCTION zc_Object_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Juridical', '����������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Juridical');

CREATE OR REPLACE FUNCTION zc_Object_MarginCategory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MarginCategory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MarginCategory', '��������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MarginCategory');

CREATE OR REPLACE FUNCTION zc_Object_MarginCategoryItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MarginCategoryItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MarginCategoryItem', '������� ��������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MarginCategoryItem');

CREATE OR REPLACE FUNCTION zc_Object_MarginCategoryLink() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MarginCategoryLink'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MarginCategoryLink', '����� ��������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MarginCategoryLink');

CREATE OR REPLACE FUNCTION zc_Object_MarginReport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MarginReport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MarginReport', '��������� ������� ��� ������ (������� �����������)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MarginReport');

CREATE OR REPLACE FUNCTION zc_Object_MarginReportItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MarginReportItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MarginReportItem', '������� ��������� ������� ��� ������ (������� �����������)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MarginReportItem');


CREATE OR REPLACE FUNCTION zc_Object_Measure() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Measure'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Measure', '������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Measure');

CREATE OR REPLACE FUNCTION zc_Object_Member() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Member'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Member', '���������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Member');

CREATE OR REPLACE FUNCTION zc_Object_MemberExternal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MemberExternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MemberExternal', '���������� ����(���������)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MemberExternal');

CREATE OR REPLACE FUNCTION zc_Object_ModelService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ModelService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ModelService', '������ ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ModelService');

CREATE OR REPLACE FUNCTION zc_Object_ModelServiceItemChild() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ModelServiceItemChild'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ModelServiceItemChild', '����������� �������� ������ ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ModelServiceItemChild');

CREATE OR REPLACE FUNCTION zc_Object_ModelServiceItemMaster() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ModelServiceItemMaster'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ModelServiceItemMaster', '������� �������� ������ ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ModelServiceItemMaster');

CREATE OR REPLACE FUNCTION zc_Object_ModelServiceKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ModelServiceKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ModelServiceKind', '���� ������ ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ModelServiceKind');

CREATE OR REPLACE FUNCTION zc_Object_OrderKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_OrderKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_OrderKind', '��� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_OrderKind');

CREATE OR REPLACE FUNCTION zc_Object_PaidKind() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PaidKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_PaidKind', '����� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PaidKind');

CREATE OR REPLACE FUNCTION zc_Object_Partner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Partner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Partner', '�����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Partner');

CREATE OR REPLACE FUNCTION zc_Object_PartnerTag() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PartnerTag'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_PartnerTag', '������� �������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PartnerTag');

CREATE OR REPLACE FUNCTION zc_Object_Personal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Personal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Personal', '����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Personal');

CREATE OR REPLACE FUNCTION zc_Object_PersonalGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PersonalGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PersonalGroup', '����������� �����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PersonalGroup');

CREATE OR REPLACE FUNCTION zc_Object_PersonalServiceList() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PersonalServiceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_PersonalServiceList', '��������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PersonalServiceList');

CREATE OR REPLACE FUNCTION zc_Object_Position() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Position'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Position', '���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Position');

CREATE OR REPLACE FUNCTION zc_Object_PositionLevel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PositionLevel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PositionLevel', '������ ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PositionLevel');

CREATE OR REPLACE FUNCTION zc_Object_PriceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PriceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PriceList', '�����-�����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PriceList');

CREATE OR REPLACE FUNCTION zc_Object_PriceListItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PriceListItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PriceListItem', '���� �����-�����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PriceListItem');

CREATE OR REPLACE FUNCTION zc_Object_Process() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Process'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Process', '��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Process');

CREATE OR REPLACE FUNCTION zc_Object_Program() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Program'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Program', '���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Program');

CREATE OR REPLACE FUNCTION zc_Object_ProfitLossGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLossGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ProfitLossGroup', '������ ������ ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLossGroup');

CREATE OR REPLACE FUNCTION zc_Object_ProfitLossDirection() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLossDirection'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ProfitLossDirection', '��������� ������ ���� - �����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLossDirection');

CREATE OR REPLACE FUNCTION zc_Object_ProfitLoss() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLoss'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ProfitLoss', '������ ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLoss');

CREATE OR REPLACE FUNCTION zc_Object_RateFuel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RateFuel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RateFuel', '����� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RateFuel');

CREATE OR REPLACE FUNCTION zc_Object_RateFuelKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RateFuelKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RateFuelKind', '���� ���� ��� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RateFuelKind');

CREATE OR REPLACE FUNCTION zc_object_receipt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_object_receipt'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_object_receipt', '���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_object_receipt');

CREATE OR REPLACE FUNCTION zc_Object_ReceiptCost() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReceiptCost'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ReceiptCost', '������� � ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReceiptCost');

CREATE OR REPLACE FUNCTION zc_Object_ReceiptChild() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReceiptChild'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ReceiptChild', '������������ ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReceiptChild');

CREATE OR REPLACE FUNCTION zc_object_receiptkind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_object_receiptkind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_object_receiptkind', '���� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_object_receiptkind');

CREATE OR REPLACE FUNCTION zc_Object_RetailReport() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RetailReport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_RetailReport', '�������� ����(�����)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RetailReport');

CREATE OR REPLACE FUNCTION zc_Object_ReturnType() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReturnType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_ReturnType', '��� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReturnType');

CREATE OR REPLACE FUNCTION zc_Object_Role() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Role'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Role', '����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Role');

CREATE OR REPLACE FUNCTION zc_Object_RoleAction() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RoleAction'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RoleAction', '����� ���� � ������� ������ ������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RoleAction');

CREATE OR REPLACE FUNCTION zc_Object_RoleProcessAccess() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RoleProcessAccess'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RoleProcessAccess', '����� ����� � ��������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RoleProcessAccess');

CREATE OR REPLACE FUNCTION zc_Object_RoleRight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RoleRight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RoleRight', '��������� ���� �� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RoleRight');

CREATE OR REPLACE FUNCTION zc_Object_Route() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Route'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Route', '��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Route');

CREATE OR REPLACE FUNCTION zc_Object_RouteKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RouteKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RouteKind', '���� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RouteKind');

CREATE OR REPLACE FUNCTION zc_Object_RouteSorting() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RouteSorting'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RouteSorting', '���������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RouteSorting');

CREATE OR REPLACE FUNCTION zc_Object_RouteMember() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RouteMember'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RouteMember', '��������(�����������)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RouteMember');


CREATE OR REPLACE FUNCTION zc_Object_SelectKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_SelectKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_SelectKind', '���� ������ ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_SelectKind');

CREATE OR REPLACE FUNCTION zc_Object_StaffList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StaffList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_StaffList', '������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StaffList');

CREATE OR REPLACE FUNCTION zc_Object_StaffListCost() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StaffListCost'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_StaffListCost', '�������� �������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StaffListCost');

CREATE OR REPLACE FUNCTION zc_Object_StaffListSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StaffListSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_StaffListSumm', 'C���� ��� �������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StaffListSumm');

CREATE OR REPLACE FUNCTION zc_Object_StaffListSummKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StaffListSummKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_StaffListSummKind', '���� ���� ��� �������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StaffListSummKind');

CREATE OR REPLACE FUNCTION zc_Object_Status() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Status'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Status', '������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Status');

CREATE OR REPLACE FUNCTION zc_Object_TicketFuel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_TicketFuel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_TicketFuel', '������ �� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_TicketFuel');

CREATE OR REPLACE FUNCTION zc_Object_TradeMark() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_TradeMark'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_TradeMark', '�������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_TradeMark');

-- CREATE OR REPLACE FUNCTION zc_Object_UnitGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_UnitGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Unit', '�������������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Unit');

-- CREATE OR REPLACE FUNCTION zc_Object_AccountPlan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AccountPlan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_object_User() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_object_User'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_object_User', '������������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_object_User');

CREATE OR REPLACE FUNCTION zc_Object_UserRole() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_UserRole'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_UserRole', '����� ������������� � �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_UserRole');

CREATE OR REPLACE FUNCTION zc_Object_UserFormSettings() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_UserFormSettings'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_UserFormSettings', '���������������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_UserFormSettings');

CREATE OR REPLACE FUNCTION zc_Object_WorkTimeKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_WorkTimeKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_WorkTimeKind', '���� �������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_WorkTimeKind');

CREATE OR REPLACE FUNCTION zc_object_PartionMovement() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_object_PartionMovement'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_object_PartionMovement', '������ �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_object_PartionMovement');

CREATE OR REPLACE FUNCTION zc_object_PartionMovementItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_object_PartionMovementItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_object_PartionMovementItem', '������ �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_object_PartionMovementItem');

CREATE OR REPLACE FUNCTION zc_Object_DocumentTaxKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_DocumentTaxKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_DocumentTaxKind', '���� ������������ ���������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_DocumentTaxKind');

CREATE OR REPLACE FUNCTION zc_Object_Country() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Country'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Country', '������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Country');

CREATE OR REPLACE FUNCTION zc_Object_Maker() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Maker'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Maker', '������������� (��)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Maker');

CREATE OR REPLACE FUNCTION zc_Object_MakerReport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MakerReport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MakerReport', '���������� � �������� ������-�������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MakerReport');
  
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

CREATE OR REPLACE FUNCTION zc_Object_ContractTagGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractTagGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContractTagGroup', '������ �������� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractTagGroup');



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

CREATE OR REPLACE FUNCTION zc_Object_RetailReport() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RetailReport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_RetailReport', '�������� ����(�����)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RetailReport');

CREATE OR REPLACE FUNCTION zc_Object_PartnerTag() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PartnerTag'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_PartnerTag', '������� �������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PartnerTag');

CREATE OR REPLACE FUNCTION zc_Object_GoodsQuality() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsQuality'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_GoodsQuality', '��������� ������������� �������������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsQuality');

CREATE OR REPLACE FUNCTION zc_Object_ContractPartner() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractPartner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_ContractPartner', '�������� �� ������������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractPartner');

CREATE OR REPLACE FUNCTION zc_Object_ContractGoods() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractGoods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_ContractGoods', '�������� �� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractGoods');

CREATE OR REPLACE FUNCTION zc_Object_Quality() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Quality'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Quality', '������������ �������������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Quality');

CREATE OR REPLACE FUNCTION zc_Object_OrderType() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_OrderType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_OrderType', '��� ������� ������ �� ������������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_OrderType');

CREATE OR REPLACE FUNCTION zc_Object_ServiceDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ServiceDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ServiceDate', '������ ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ServiceDate');

CREATE OR REPLACE FUNCTION zc_Object_GoodsTag() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsTag'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsTag', '������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsTag');

CREATE OR REPLACE FUNCTION zc_Object_GoodsPlatform() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsPlatform'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsPlatform', '���������������� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsPlatform');

CREATE OR REPLACE FUNCTION zc_Object_RouteGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RouteGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RouteGroup', '������ ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RouteGroup');

CREATE OR REPLACE FUNCTION zc_Object_PrintKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PrintKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PrintKind', '���� ������ ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PrintKind');

CREATE OR REPLACE FUNCTION zc_Object_PrintKindItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PrintKindItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PrintKindItem', '�������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PrintKindItem');

CREATE OR REPLACE FUNCTION zc_Object_PromoKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PromoKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PromoKind', '���� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PromoKind');

CREATE OR REPLACE FUNCTION zc_Object_PromoStateKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PromoStateKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PromoStateKind', '��������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PromoStateKind');

CREATE OR REPLACE FUNCTION zc_Object_Advertising() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Advertising'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Advertising', '��������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Advertising');

CREATE OR REPLACE FUNCTION zc_Object_ConditionPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ConditionPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ConditionPromo', '������� ������� � �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ConditionPromo');
  
CREATE OR REPLACE FUNCTION zc_Object_ContractTermKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractTermKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContractTermKind', '���� ����������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractTermKind');

CREATE OR REPLACE FUNCTION zc_Object_BranchJuridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_BranchJuridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_BranchJuridical', '�������������� ������ ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_BranchJuridical');


CREATE OR REPLACE FUNCTION zc_Object_BranchPrintKindItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_BranchPrintKindItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_BranchPrintKindItem', '��������� ������ �� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_BranchPrintKindItem');

CREATE OR REPLACE FUNCTION zc_Object_ExportKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ExportKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ExportKind', '���� �������� ��� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ExportKind');

CREATE OR REPLACE FUNCTION zc_Object_ExportJuridical() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ExportJuridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_ExportJuridical', '��������� �������� � ��������� �� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ExportJuridical');

CREATE OR REPLACE FUNCTION zc_object_reestrkind() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_object_reestrkind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_object_reestrkind', '���� ��������� �� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_object_reestrkind');

CREATE OR REPLACE FUNCTION zc_Object_NameBefore() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_NameBefore'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_NameBefore', '�����/��/������ (��������������� ��������)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_NameBefore');

CREATE OR REPLACE FUNCTION zc_Object_PartionRemains() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PartionRemains'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_PartionRemains', '������ ����, ����� ���� � ��, (�������)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PartionRemains');

CREATE OR REPLACE FUNCTION zc_Object_PartionGoods() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PartionGoods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_PartionGoods', '������ �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PartionGoods');


CREATE OR REPLACE FUNCTION zc_Object_SignInternal() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_SignInternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_SignInternal', '������ ����������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_SignInternal');

CREATE OR REPLACE FUNCTION zc_Object_SignInternalItem() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_SignInternalItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_SignInternalItem', '�������� ������� ����������� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_SignInternalItem');

CREATE OR REPLACE FUNCTION zc_Object_MobileTariff() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MobileTariff'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
 SELECT 'zc_Object_MobileTariff', 'T����� ��������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MobileTariff');

CREATE OR REPLACE FUNCTION zc_Object_MobileEmployee() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MobileEmployee'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
 SELECT 'zc_Object_MobileEmployee', '��������� �������� �����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MobileEmployee');

CREATE OR REPLACE FUNCTION zc_Object_GoodsListSale() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsListSale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
 SELECT 'zc_Object_GoodsListSale', '������ � ���������� �����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsListSale');

CREATE OR REPLACE FUNCTION zc_Object_DayKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_DayKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_DayKind', '���� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_DayKind');
     
CREATE OR REPLACE FUNCTION zc_Object_SheetWorkTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_SheetWorkTime'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_SheetWorkTime', '����� ������ (������ ������ �������� �������)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_SheetWorkTime');
     
CREATE OR REPLACE FUNCTION zc_Object_ReportCollation() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReportCollation'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ReportCollation', '��� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReportCollation');
     
CREATE OR REPLACE FUNCTION zc_Object_PhotoMobile() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PhotoMobile'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PhotoMobile', '���������� � ���������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PhotoMobile');

CREATE OR REPLACE FUNCTION zc_Object_GoodsListIncome() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsListIncome'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
 SELECT 'zc_Object_GoodsListIncome', ' ������ ��� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsListIncome');

CREATE OR REPLACE FUNCTION zc_Object_ReportExternal() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReportExternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_ReportExternal', '������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReportExternal');

CREATE OR REPLACE FUNCTION zc_Object_StorageLine() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StorageLine'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_StorageLine', '����� ������������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StorageLine');

CREATE OR REPLACE FUNCTION zc_Object_MobileConst() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MobileConst'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_MobileConst', '��������� ��� ���������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MobileConst');

CREATE OR REPLACE FUNCTION zc_Object_Sticker() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Sticker'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Sticker', '��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Sticker');

CREATE OR REPLACE FUNCTION zc_Object_StickerGroup() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StickerGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_StickerGroup', '��� �������� (������)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StickerGroup');

CREATE OR REPLACE FUNCTION zc_Object_StickerType() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StickerType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_StickerType', '������ ������������ ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StickerType');

CREATE OR REPLACE FUNCTION zc_Object_StickerTag() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StickerTag'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_StickerTag', '�������� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StickerTag');

CREATE OR REPLACE FUNCTION zc_Object_StickerSort() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StickerSort'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_StickerSort', '��������� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StickerSort');

CREATE OR REPLACE FUNCTION zc_Object_StickerNorm() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StickerNorm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_StickerNorm', '�� ��� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StickerNorm');

CREATE OR REPLACE FUNCTION zc_Object_StickerFile() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StickerFile'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_StickerFile', '������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StickerFile');

CREATE OR REPLACE FUNCTION zc_Object_Language() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Language'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Language', '����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Language');

CREATE OR REPLACE FUNCTION zc_Object_StickerProperty() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StickerProperty'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_StickerProperty', '�������� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StickerProperty');

CREATE OR REPLACE FUNCTION zc_Object_StickerSkin() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StickerSkin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_StickerSkin', '��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StickerSkin');

CREATE OR REPLACE FUNCTION zc_Object_StickerPack() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StickerPack'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_StickerPack', '��� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StickerPack');

CREATE OR REPLACE FUNCTION zc_Object_GoodsReportSaleInf() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsReportSaleInf'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_GoodsReportSaleInf', '���������� ������ �� ���� ������ (��������)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsReportSaleInf');

CREATE OR REPLACE FUNCTION zc_Object_GoodsReportSale() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsReportSale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_GoodsReportSale', '���������� ������ �� ���� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsReportSale');

CREATE OR REPLACE FUNCTION zc_Object_MemberSheetWorkTime() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MemberSheetWorkTime'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_MemberSheetWorkTime', '������ � ������ �������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MemberSheetWorkTime');

CREATE OR REPLACE FUNCTION zc_Object_MemberPersonalServiceList() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MemberPersonalServiceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_MemberPersonalServiceList', '������ � ��������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MemberPersonalServiceList');

CREATE OR REPLACE FUNCTION zc_Object_GoodsTypeKind() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsTypeKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_GoodsTypeKind', '��������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsTypeKind');

CREATE OR REPLACE FUNCTION zc_Object_GoodsBrand() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsBrand'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_GoodsBrand', '����� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsBrand');

CREATE OR REPLACE FUNCTION zc_Object_OrderFinance() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_OrderFinance'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_OrderFinance', '���� ������������ ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_OrderFinance');

CREATE OR REPLACE FUNCTION zc_Object_OrderFinanceProperty() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_OrderFinanceProperty'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_OrderFinanceProperty', '�������� ��� ������������ ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_OrderFinanceProperty');

CREATE OR REPLACE FUNCTION zc_Object_JuridicalOrderFinance() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalOrderFinance'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_JuridicalOrderFinance', '��������� ��.���� � ������������ ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalOrderFinance');


CREATE OR REPLACE FUNCTION zc_Object_SubjectDoc() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_SubjectDoc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_SubjectDoc', '��������� ��� �����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_SubjectDoc');

CREATE OR REPLACE FUNCTION zc_Object_MemberMinus() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MemberMinus'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_MemberMinus', '��������� �� �����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MemberMinus');

CREATE OR REPLACE FUNCTION zc_Object_ReportBonus() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReportBonus'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_ReportBonus', '�������� ���������� �� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReportBonus');

CREATE OR REPLACE FUNCTION zc_Object_MemberBranch() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MemberBranch'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_MemberBranch', '������ � ������ �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MemberBranch');

CREATE OR REPLACE FUNCTION zc_Object_PartnerExternal() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PartnerExternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_PartnerExternal', '����������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PartnerExternal');

CREATE OR REPLACE FUNCTION zc_Object_ContractTradeMark() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractTradeMark'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_ContractTradeMark', '�������� ����� � ���������(������������)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractTradeMark');

CREATE OR REPLACE FUNCTION zc_Object_AssetType() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AssetType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_AssetType', '��� (��)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AssetType');

CREATE OR REPLACE FUNCTION zc_Object_ContractConditionPartner() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractConditionPartner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_ContractConditionPartner', '����������� � �������� � ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractConditionPartner');
zc_Object_ContractConditionPartner


--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--!!! ������
CREATE OR REPLACE FUNCTION zc_Object_FileTypeKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_FileTypeKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_FileTypeKind', '���� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_FileTypeKind');

CREATE OR REPLACE FUNCTION zc_Object_JuridicalSettings() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalSettings'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_JuridicalSettings', '��������� ��� ��. ���' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalSettings');

CREATE OR REPLACE FUNCTION zc_Object_JuridicalSettingsItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalSettingsItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_JuridicalSettingsItem', '������� ��������� ��� ��. ���' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalSettingsItem');


CREATE OR REPLACE FUNCTION zc_Object_LinkGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_LinkGoods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_LinkGoods', '' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_LinkGoods');

CREATE OR REPLACE FUNCTION zc_Object_NDSKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_NDSKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_NDSKind', '���� ���' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_NDSKind');

CREATE OR REPLACE FUNCTION zc_Object_PriceGroupSettings() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PriceGroupSettings'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PriceGroupSettings', '��������� ��� ������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PriceGroupSettings');

CREATE OR REPLACE FUNCTION zc_Object_PriceGroupSettingsTOP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PriceGroupSettingsTOP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PriceGroupSettingsTOP', '��������� ��� ������� ����� ���' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PriceGroupSettingsTOP');

CREATE OR REPLACE FUNCTION zc_Object_MedocLoadInfo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MedocLoadInfo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MedocLoadInfo', '���������� � ��������� �� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MedocLoadInfo');

CREATE OR REPLACE FUNCTION zc_Object_Price() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Price'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Price', '���� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Price');

CREATE OR REPLACE FUNCTION zc_Object_AlternativeGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AlternativeGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AlternativeGroup', '������ �����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AlternativeGroup');

CREATE OR REPLACE FUNCTION zc_Object_PaidType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PaidType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PaidType', '���� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PaidType');

CREATE OR REPLACE FUNCTION zc_Object_ReportSoldParams() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReportSoldParams'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ReportSoldParams', '��������� ������ �� ����� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReportSoldParams');

CREATE OR REPLACE FUNCTION zc_Object_ReportPromoParams() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReportPromoParams'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ReportPromoParams', '��������� ������ �� ����� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReportPromoParams');

CREATE OR REPLACE FUNCTION zc_Object_AdditionalGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AdditionalGoods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AdditionalGoods', '�������������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AdditionalGoods');

CREATE OR REPLACE FUNCTION zc_Object_Appointment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Appointment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Appointment', '���������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Appointment');

CREATE OR REPLACE FUNCTION zc_Object_ReasonDifferences() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReasonDifferences'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ReasonDifferences', '���������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReasonDifferences');

CREATE OR REPLACE FUNCTION zc_Object_ChangeIncomePaymentKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ChangeIncomePaymentKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ChangeIncomePaymentKind', '���� ������������� ����� ��������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ChangeIncomePaymentKind');

CREATE OR REPLACE FUNCTION zc_Object_Education() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Education'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Education', '�������������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Education');


CREATE OR REPLACE FUNCTION zc_Object_EmailTools() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_EmailTools'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_EmailTools', '��������� ��������� ��� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_EmailTools');

CREATE OR REPLACE FUNCTION zc_Object_EmailKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_EmailKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_EmailKind', '���� ��������� ��� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_EmailKind');
-- UPDATE  ObjectDesc SET ItemName = '��� �����' WHERE Id = zc_Object_EmailKind()   --  ��� ���������

CREATE OR REPLACE FUNCTION zc_Object_EmailSettings() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_EmailSettings'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_EmailSettings', '��������� ��� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_EmailSettings');

CREATE OR REPLACE FUNCTION zc_Object_Email() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Email'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Email', '�������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Email');

CREATE OR REPLACE FUNCTION zc_Object_DocumentKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_DocumentKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_DocumentKind', '���� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_DocumentKind');

CREATE OR REPLACE FUNCTION zc_Object_OverSettings() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_OverSettings'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_OverSettings', '��������� ��� ������������ ��������� �� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_OverSettings');

CREATE OR REPLACE FUNCTION zc_Object_BarCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_BarCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_BarCode', '�����-���� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_BarCode');
  
CREATE OR REPLACE FUNCTION zc_Object_DiscountExternal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_DiscountExternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_DiscountExternal', '������� (���������� �����)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_DiscountExternal');

CREATE OR REPLACE FUNCTION zc_Object_DiscountExternalTools() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_DiscountExternalTools'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_DiscountExternalTools', '��������� �������� (���������� �����)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_DiscountExternalTools');

CREATE OR REPLACE FUNCTION zc_Object_DiscountExternalJuridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_DiscountExternalJuridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_DiscountExternalJuridical', '��������� �������� (���������� �����, ����������� ����)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_DiscountExternalJuridical');

CREATE OR REPLACE FUNCTION zc_Object_DiscountCard() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_DiscountCard'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_DiscountCard', '���������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_DiscountCard');

CREATE OR REPLACE FUNCTION zc_Object_ConfirmedKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ConfirmedKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ConfirmedKind', '������ ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ConfirmedKind');

CREATE OR REPLACE FUNCTION zc_Object_OrderShedule() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_OrderShedule'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_OrderShedule', '������ ������/��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_OrderShedule');

CREATE OR REPLACE FUNCTION zc_Object_ContractSettings() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractSettings'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContractSettings', '��������� ��� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractSettings');

CREATE OR REPLACE FUNCTION zc_Object_BrandSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_BrandSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_BrandSP', '����������� ����� ���������� ������ (���. ������)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_BrandSP');
  
CREATE OR REPLACE FUNCTION zc_Object_IntenalSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_IntenalSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_IntenalSP', '̳�������� ������������� ����� (���. ������)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_IntenalSP');
  
CREATE OR REPLACE FUNCTION zc_Object_KindOutSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_KindOutSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_KindOutSP', '����� ������� (���. ������)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_KindOutSP');
  
CREATE OR REPLACE FUNCTION zc_Object_PartnerMedical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PartnerMedical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PartnerMedical', '����������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PartnerMedical');
  
CREATE OR REPLACE FUNCTION zc_Object_ConditionsKeep() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ConditionsKeep'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ConditionsKeep', '������� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ConditionsKeep');

CREATE OR REPLACE FUNCTION zc_Object_GroupMemberSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GroupMemberSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GroupMemberSP', '��������� ��������(���. ������)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GroupMemberSP');

CREATE OR REPLACE FUNCTION zc_Object_MemberSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MemberSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MemberSP', '��� ��������(���. ������)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MemberSP');

CREATE OR REPLACE FUNCTION zc_Object_MedicSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MedicSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MedicSP', '��� �����(���. ������)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MedicSP');

CREATE OR REPLACE FUNCTION zc_Object_SPKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_SPKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_SPKind', '���� ���.��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_SPKind');

CREATE OR REPLACE FUNCTION zc_Object_MemberIncomeCheck() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MemberIncomeCheck'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MemberIncomeCheck', '��� �������������� ���' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MemberIncomeCheck');

CREATE OR REPLACE FUNCTION zc_Object_JuridicalArea() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalArea'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_JuridicalArea', '������ ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalArea');

CREATE OR REPLACE FUNCTION zc_Object_DataExcel() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_DataExcel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_DataExcel', '�������� ������ �� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_DataExcel');

CREATE OR REPLACE FUNCTION zc_Object_PromoCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PromoCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PromoCode', '����� ��� (�������� �����)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PromoCode');

CREATE OR REPLACE FUNCTION zc_Object_Fiscal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Fiscal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Fiscal', '�������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Fiscal');

CREATE OR REPLACE FUNCTION zc_Object_UnitCategory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_UnitCategory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_UnitCategory', '��������� �������������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_UnitCategory');

CREATE OR REPLACE FUNCTION zc_Object_Address() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Address'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Address', '�����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Address');

CREATE OR REPLACE FUNCTION zc_Object_JuridicalLegalAddress() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalLegalAddress'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_JuridicalLegalAddress', '����������� ����� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalLegalAddress');

CREATE OR REPLACE FUNCTION zc_Object_JuridicalActualAddress() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalActualAddress'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_JuridicalActualAddress', '����������� ����� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalActualAddress');

CREATE OR REPLACE FUNCTION zc_Object_GoodsPropertyBox() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsPropertyBox'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsPropertyBox', 'C������� ������� ��� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsPropertyBox');

CREATE OR REPLACE FUNCTION zc_Object_PriceChange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PriceChange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PriceChange', '���������� ������� ���� �� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PriceChange');

CREATE OR REPLACE FUNCTION zc_Object_Accommodation() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Accommodation'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Accommodation', '���������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Accommodation');

CREATE OR REPLACE FUNCTION zc_Object_Overdraft() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Overdraft'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Overdraft', '��������� ������ �����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Overdraft');

CREATE OR REPLACE FUNCTION zc_Object_Exchange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Exchange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Exchange', '������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Exchange');

CREATE OR REPLACE FUNCTION zc_Object_ClientsByBank() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ClientsByBank'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ClientsByBank', '������� �� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ClientsByBank');

CREATE OR REPLACE FUNCTION zc_Object_GoodsSeparate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsSeparate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsSeparate', '������ � ������������-����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsSeparate');

CREATE OR REPLACE FUNCTION zc_Object_RepriceUnitSheduler() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RepriceUnitSheduler'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RepriceUnitSheduler', '����������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RepriceUnitSheduler');

CREATE OR REPLACE FUNCTION zc_Object_DiffKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_DiffKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_DiffKind', '��� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_DiffKind');

CREATE OR REPLACE FUNCTION zc_Object_RecalcMCSSheduler() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RecalcMCSSheduler'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RecalcMCSSheduler', '����������� �������� ���' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RecalcMCSSheduler');

CREATE OR REPLACE FUNCTION zc_Object_SettingsService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_SettingsService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_SettingsService', '����������� �� �������� ������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_SettingsService');

CREATE OR REPLACE FUNCTION zc_Object_SettingsServiceItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_SettingsServiceItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_SettingsServiceItem', '����������� �� �������� ������� ����� (��������)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_SettingsServiceItem');

CREATE OR REPLACE FUNCTION zc_Object_GoodsCategory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsCategory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsCategory', '�������������� �������(���������)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsCategory');

CREATE OR REPLACE FUNCTION zc_Object_BankPOSTerminal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_BankPOSTerminal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_BankPOSTerminal', '����� ��������������� POS ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_BankPOSTerminal');

CREATE OR REPLACE FUNCTION zc_Object_TaxUnit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_TaxUnit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_TaxUnit', '������� ��� ������ ���' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_TaxUnit');

CREATE OR REPLACE FUNCTION zc_Object_UnitBankPOSTerminal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_UnitBankPOSTerminal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_UnitBankPOSTerminal', '����� ������������� � ������ POS ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_UnitBankPOSTerminal');

CREATE OR REPLACE FUNCTION zc_Object_JackdawsChecks() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_JackdawsChecks'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_JackdawsChecks', '���� ����� ��� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_JackdawsChecks');

CREATE OR REPLACE FUNCTION zc_Object_GoodsAnalog() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsAnalog'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsAnalog', '������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsAnalog');

CREATE OR REPLACE FUNCTION zc_Object_PartionDateKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PartionDateKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PartionDateKind', '���� ����/�� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PartionDateKind');

CREATE OR REPLACE FUNCTION zc_Object_RetailCostCredit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RetailCostCredit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RetailCostCredit', '��������� ��������� ������� �� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RetailCostCredit');

CREATE OR REPLACE FUNCTION zc_Object_HelsiEnum() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_HelsiEnum'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_HelsiEnum', '��������� ������� � ����� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_HelsiEnum');

CREATE OR REPLACE FUNCTION zc_Object_CreditLimitJuridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CreditLimitJuridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CreditLimitJuridical', '��������� ����� �� �������������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CreditLimitJuridical');

CREATE OR REPLACE FUNCTION zc_Object_GoodsGroupPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsGroupPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsGroupPromo', '������ ������� ��� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsGroupPromo');

CREATE OR REPLACE FUNCTION zc_Object_Driver() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Driver'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Driver', '��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Driver');

CREATE OR REPLACE FUNCTION zc_Object_PayrollType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PayrollType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PayrollType', '���� ������� ���������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PayrollType');

CREATE OR REPLACE FUNCTION zc_Object_PayrollGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PayrollGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PayrollGroup', '������ ������� ���������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PayrollGroup');

CREATE OR REPLACE FUNCTION zc_Object_LabSample() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_LabSample'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_LabSample', '�������� ������������ (�������)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_LabSample');

CREATE OR REPLACE FUNCTION zc_Object_LabProduct() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_LabProduct'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_LabProduct', '������� ������������ (������������)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_LabProduct');


CREATE OR REPLACE FUNCTION zc_Object_LabMark() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_LabMark'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_LabMark', '�������� ���������� (��� ������������)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_LabMark');

CREATE OR REPLACE FUNCTION zc_Object_LabReceiptChild() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_LabReceiptChild'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_LabReceiptChild', '����� ��� ������������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_LabReceiptChild');

CREATE OR REPLACE FUNCTION zc_Object_GoodsReprice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsReprice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsReprice', '������ � ����������� ���������� � �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsReprice');

CREATE OR REPLACE FUNCTION zc_Object_CashSettings() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CashSettings'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CashSettings', '����� ��������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CashSettings');

CREATE OR REPLACE FUNCTION zc_Object_Buyer() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Buyer'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Buyer', '����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Buyer');

CREATE OR REPLACE FUNCTION zc_Object_PlanIventory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PlanIventory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PlanIventory', '������ ��������������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PlanIventory');

CREATE OR REPLACE FUNCTION zc_Object_MemberBankAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MemberBankAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MemberBankAccount', '������ � ��������� ��������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MemberBankAccount');

CREATE OR REPLACE FUNCTION zc_Object_CommentTR() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CommentTR'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CommentTR', '����������� ����� ������������ ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CommentTR');

CREATE OR REPLACE FUNCTION zc_Object_DriverSun() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_DriverSun'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_DriverSun', '�������� ���' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_DriverSun');

CREATE OR REPLACE FUNCTION zc_Object_SeasonalityCoefficient() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_SeasonalityCoefficient'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_SeasonalityCoefficient', '������������ ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_SeasonalityCoefficient');
 
CREATE OR REPLACE FUNCTION zc_Object_SunExclusion() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_SunExclusion'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_SunExclusion', '���������� ��� ���' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_SunExclusion');
   
CREATE OR REPLACE FUNCTION zc_Object_Hardware() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Hardware'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Hardware', '���������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Hardware');
   
   
CREATE OR REPLACE FUNCTION zc_Object_CheckSourceKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CheckSourceKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CheckSourceKind', '�������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CheckSourceKind');
   

CREATE OR REPLACE FUNCTION zc_Object_CashFlow() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CashFlow'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CashFlow', '������ ������ ���' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CashFlow');
   
CREATE OR REPLACE FUNCTION zc_Object_HouseholdInventory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_HouseholdInventory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_HouseholdInventory', '������������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_HouseholdInventory');
   
CREATE OR REPLACE FUNCTION zc_Object_PartionHouseholdInventory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PartionHouseholdInventory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PartionHouseholdInventory', '������ �������������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PartionHouseholdInventory');

CREATE OR REPLACE FUNCTION zc_Object_ComputerAccessories() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ComputerAccessories'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ComputerAccessories', '������������ ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ComputerAccessories');

CREATE OR REPLACE FUNCTION zc_Object_DivisionParties() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_DivisionParties'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_DivisionParties', '���������� ������ � ����� ��� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_DivisionParties');

CREATE OR REPLACE FUNCTION zc_Object_CommentSend() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CommentSend'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CommentSend', '����������� ����� ����������� �� ���' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CommentSend');

CREATE OR REPLACE FUNCTION zc_Object_JuridicalPriorities() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalPriorities'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_JuridicalPriorities', '���������� ��� ������ ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalPriorities');

CREATE OR REPLACE FUNCTION zc_Object_Layout() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Layout'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Layout', '�������� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Layout');

CREATE OR REPLACE FUNCTION zc_Object_CancelReason() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CancelReason'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CancelReason', '������� ������ ��� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CancelReason');

CREATE OR REPLACE FUNCTION zc_Object_BuyerForSale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_BuyerForSale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_BuyerForSale', '��� ���������� (�� �������)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_BuyerForSale');

CREATE OR REPLACE FUNCTION zc_Object_MedicForSale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MedicForSale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MedicForSale', '��� ����� (�� �������)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MedicForSale');

CREATE OR REPLACE FUNCTION zc_Object_AmbulantClinicSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AmbulantClinicSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AmbulantClinicSP', '����������� (���. ������)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AmbulantClinicSP');


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
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �. �.   ������ �.�.
 23.11.20         * zc_Object_ContractConditionPartner
 20.10.20                                                                                        * zc_Object_AmbulantClinicSP
 30.10.20         * zc_Object_PartnerExternal
 07.10.20                                                                                        * zc_Object_BuyerForSale, zc_Object_MedicForSale
 05.10.20         * zc_Object_MemberBranch
 25.09.20         * zc_Object_ReportBonus
 04.09.20         * zc_Object_MemberMinus
 03.09.20                                                                                        * zc_Object_CancelReason
 27.08.20         * zc_Object_Layout
 22.08.20                                                                                        * zc_Object_JuridicalPriorities
 19.08.20                                                                                        * zc_Object_CommentSend
 13.08.20                                                                                        * zc_Object_DivisionParties
 14.07.20                                                                                        * zc_Object_ComputerAccessories
 09.07.20                                                                                        * zc_Object_PartionHouseholdInventory
 08.07.20                                                                                        * zc_Object_HouseholdInventory
 19.06.20         * zc_Object_CashFlow
 15.06.20                                                                                        * zc_Object_CheckSourceKind
 12.04.20                                                                                        * zc_Object_Hardware
 06.04.20         * zc_Object_SunExclusion
 05.04.20                                                                                        * zc_Object_SeasonalityCoefficient
 31.03.20         * zc_Object_PromoStateKind
 05.03.20                                                                                        * zc_Object_DriverSun
 27.02.20                                                                                        * zc_Object_CommentTR
 17.02.20         * zc_Object_MemberBankAccount
 06.02.20         * zc_Object_SubjectDoc
 29.01.20         * zc_Object_PlanIventory
 26.12.19                                                                                        * zc_Object_Buyer
 19.11.19         * zc_Object_GoodsReprice
 16.10.19         * zc_Object_LabSample
                    zc_Object_LabProduct
                    zc_Object_LabMark
                    zc_Object_LabReceiptChild
 22.09.19                                                                                        * zc_Object_PayrollType, zc_Object_PayrollGroup
 07.09.19                                                                                        * zc_Object_Driver
 06.08.19         * zc_Object_JuridicalOrderFinance
 29.07.19         * zc_Object_OrderFinance
                    zc_Object_OrderFinanceProperty
 21.07.19                                                                                        * zc_Object_GoodsGroupPromo
 07.06.19                                                                                        * zc_Object_CreditLimitJuridical
 14.05.19         * zc_Object_ClientKind
 24.04.19                                                                                        * zc_Object_HelsiEnum
 23.04.19         * zc_Object_RetailCostCredit
 19.04.19         * zc_Object_PartionDateKind
 01.04.19                                                                                        * zc_Object_GoodsAnalog
 25.02.19         * zc_Object_GoodsTypeKind
                    zc_Object_GoodsBrand
 25.02.19                                                                                        * zc_Object_JackdawsChecks
 18.02.19                                                                                        * zc_Object_UnitBankPOSTerminal
 16.02.19                                                                                        * zc_Object_BankPOSTerminal
 17.02.19         * zc_Object_TaxUnit
 11.02.19         * zc_Object_GoodsCategory
 28.01.19         * zc_Object_SettingsService
                    zc_Object_SettingsServiceItem
                    
 13.01.19         * zc_Object_JuridicalSettingsItem
 11.01.19         * zc_Object_MakerReport
 21.12.18                                                                                        * zc_Object_RecalcMCSSheduler
 11.12.18         * zc_Object_DiffKind
 22.10.18                                                                                        * zc_Object_RepriceUnitSheduler
 07.10.18         * zc_Object_GoodsSeparate
 28.09.18                                                                                        * zc_Object_Exchange, zc_Object_ClientsByBank  
 27.08.18                                                                                        * zc_Object_Overdraft  
 17.08.18                                                                                        * zc_Object_Accommodation  
 16.08.18         * zc_Object_PriceChange
 24.06.18         * zc_Object_GoodsPropertyBox
 20.06.18         * zc_Object_ReplMovement
                    zc_Object_ReplObject
 28.05.18                                                                                        * zc_Object_Address, zc_Object_JuridicalLegalAddress, zc_Object_JuridicalActualAddress
 04.05.18                                                                                        * zc_Object_UnitCategory
 18.04.18         * zc_Object_MemberSheetWorkTime
 27.12.17         * zc_Object_Fiscal
 13.12.17         * zc_Object_PromoCode
 02.11.17         * zc_Object_GoodsReportSaleInf
                    zc_Object_GoodsReportSale
 30.10.17         * zc_Object_DataExcel
 23.10.17         * zc_Object_Sticker ........
                    zc_Object_StickerProperty
                    zc_Object_Language
 25.09.17         * zc_Object_JuridicalArea
 08.06.17         * zc_Object_MemberIncomeCheck
 25.05.17         * zc_Object_StorageLine
 23.05.17         * zc_Object_SPKind
 30.03.17         * zc_Object_GoodsListIncome
 26.03.17         * zc_Object_PhotoMobile
 19.12.16         * zc_Object_BrandSP
                    zc_Object_IntenalSP
                    zc_Object_KindOutSP
 15.11.16         * zc_Object_DayKind,
                    zc_Object_SheetWorkTime
 10.11.16         * zc_Object_ContractSettings
 20.09.16         * zc_Object_OrderShedule
 26.08.16         * zc_Object_PriceGroupSettingsTOP
 03.08.16         *
 19.07.16         * zc_Object_OverSettings
 23.03.16         *
 03.03.16         * add zc_Object_EmailTools, 
                        zc_Object_EmailKind, 
                        zc_Object_EmailSettings
 22.01.16         * add zc_Object_Education (������)
 16.01.16         * add zc_Object_RouteMember
 10.12.15                                                                       *zc_Object_ChangeIncomePaymentKind
 27.10.15                                                                       *zc_Object_Appointment
 11.10.15                                                                       *zc_Object_AdditionalGoods
 27.09.15                                                                       *zc_ObjectFloat_ReportSoldParams_PlanAmount
 28.06.15                                                                       *zc_Object_AlternativeGroup
 20.04.15         * add zc_Object_RouteGroup
 14.04.15         * add zc_Object_GoodsPlatform
 28.03.15                                        * add zc_Object_MemberExternal
 11.03.15         * add zc_Object_OrderType
 09.02.15         * add zc_Object_Quality
 16.01.15         * add zc_Object_ContractPartner
 12.01.15         * add zc_Object_ContractTagGroup
 18.12.14                                        * zc_Object_AnalyzerId
 08.12.14         * add zc_Object_GoodsQuality
 24.11.14         * add GoodsGroupAnalyst
 06.11.14         * add zc_Object_RetailReport()
                        zc_Object_AreaContract()
 13.10.14                                                        * add zc_Object_CorrespondentAccount
 09.10.14                                                        * add zc_Object_Box
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
