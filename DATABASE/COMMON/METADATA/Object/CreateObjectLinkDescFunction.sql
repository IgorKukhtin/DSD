--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!
CREATE OR REPLACE FUNCTION zc_ObjectLink_RoleRight_Role() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RoleRight_Role'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_RoleRight_Role', 'Ссылка на роль в справочнике указания ролей', zc_Object_RoleRight(), zc_Object_Role() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RoleRight_Role');

CREATE OR REPLACE FUNCTION zc_ObjectLink_RoleRight_Process() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RoleRight_Process'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_RoleRight_Process', 'Ссылка на процесс в справочнике указания ролей', zc_Object_RoleRight(), zc_Object_Process() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RoleRight_Process');

CREATE OR REPLACE FUNCTION zc_ObjectLink_UserRole_Role() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UserRole_Role'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_UserRole_Role', 'Ссылка на роль в справочнике связи пользователей и ролей', zc_Object_UserRole(), zc_Object_Role() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UserRole_Role');

CREATE OR REPLACE FUNCTION zc_ObjectLink_UserRole_User() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UserRole_User'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_UserRole_User', 'Связь с пользователем в справочнике ролей пользователя', zc_Object_UserRole(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UserRole_User');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Cash_Currency() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Cash_Currency'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
   SELECT 'zc_ObjectLink_Cash_Currency', 'Связь кассы с валютой', zc_Object_Cash(), zc_Object_Currency() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Cash_Currency');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Cash_PaidKind() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Cash_PaidKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_ObjectLink_Cash_Branch() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Cash_Branch'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
   SELECT 'zc_ObjectLink_Cash_Branch', 'Связь кассы с филиалом', zc_Object_Cash(), zc_Object_Branch() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Cash_Branch');

CREATE OR REPLACE FUNCTION zc_ObjectLink_JuridicalGroup_Parent() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalGroup_Parent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_JuridicalGroup_Parent', 'Связь группы юр лиц с группой юр лиц', zc_Object_JuridicalGroup(), zc_Object_JuridicalGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalGroup_Parent');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Juridical_JuridicalGroup() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Juridical_JuridicalGroup'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Juridical_JuridicalGroup', 'Связь юр лица с группой юр лиц', zc_Object_Juridical(), zc_Object_JuridicalGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Juridical_JuridicalGroup');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Juridical_GoodsProperty() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Juridical_GoodsProperty'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Juridical_GoodsProperty', 'Связь юр лица с классификатором свойств товаров', zc_Object_Juridical(), zc_Object_GoodsProperty() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Juridical_GoodsProperty');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_Juridical() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Partner_Juridical', 'Связь контрагента с юр лицом', zc_Object_Partner(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_Parent() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Parent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Unit_Parent', 'Связь подразделения с подразделением', zc_Object_Unit(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Parent');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_Branch() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Branch'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Unit_Branch', 'Связь подразделения с филиалом', zc_Object_Unit(), zc_Object_Branch() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Branch');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Bank_Juridical() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Bank_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Bank_Juridical', 'Связь банка с юр лицом', zc_Object_Bank(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Bank_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsGroup_Parent() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsGroup_Parent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsGroup_Parent', 'Связь группы товаров с группой товаров', zc_Object_GoodsGroup(), zc_Object_GoodsGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsGroup_Parent');


-- !!!zc_Object_Goods!!!
CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_GoodsGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Goods_GoodsGroup', 'Связь товаров с группой товаров', zc_Object_Goods(), zc_Object_GoodsGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsGroup');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_Measure() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_Measure'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_Measure', 'Связь товаров с единицей измерения', zc_Object_Goods(), zc_Object_Measure() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_Measure');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_TradeMark() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_TradeMark'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Goods_TradeMark', 'Связь товаров с Торговой маркой', zc_Object_Goods(), zc_Object_TradeMark() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_TradeMark');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Goods_InfoMoney', 'Связь товаров с управленческой статьей', zc_Object_Goods(), zc_Object_InfoMoney() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_InfoMoney');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_Business() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_Business'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_Business', 'Связь товаров с бизнесом', zc_Object_Goods(), zc_Object_Business() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_Business');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_Fuel() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_Fuel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_Fuel', 'Связь товаров с видом топлива', zc_Object_Goods(), zc_Object_Business() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_Fuel');


-- !!!zc_Object_BankAccount!!!
CREATE OR REPLACE FUNCTION zc_ObjectLink_BankAccount_Juridical() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BankAccount_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_BankAccount_Juridical', 'Связь счета с юр. лицом', zc_Object_BankAccount(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BankAccount_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_BankAccount_Bank() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BankAccount_Bank'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_BankAccount_Bank', 'Связь счета банком', zc_Object_BankAccount(), zc_Object_Bank() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BankAccount_Bank');

CREATE OR REPLACE FUNCTION zc_ObjectLink_BankAccount_Currency() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BankAccount_Currency'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_BankAccount_Currency', 'Связь счета с валютой', zc_Object_BankAccount(), zc_Object_Currency() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BankAccount_Currency');

-- !!!zc_Object_GoodsPropertyValue!!!
CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsPropertyValue_GoodsProperty() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsPropertyValue_GoodsProperty'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsPropertyValue_GoodsProperty', 'Связь Значения свойств товаров для классификатора с Классификатором свойств товаров', zc_Object_GoodsPropertyValue(), zc_Object_GoodsProperty() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsPropertyValue_GoodsProperty');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsPropertyValue_Goods() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsPropertyValue_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsPropertyValue_Goods', 'Связь Значения свойств товаров для классификатора с Товарами', zc_Object_GoodsPropertyValue(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsPropertyValue_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsPropertyValue_GoodsKind() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsPropertyValue_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsPropertyValue_GoodsKind', 'Связь Значения свойств товаров для классификатора с Видами товаров', zc_Object_GoodsPropertyValue(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsPropertyValue_GoodsKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Account_AccountGroup() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Account_AccountGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Account_AccountGroup', 'Связь счета с Группой счетов', zc_Object_Account(), zc_Object_AccountGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Account_AccountGroup');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Account_AccountDirection() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Account_AccountDirection'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Account_AccountDirection', 'Связь счета с Аналитики счетов - направления', zc_Object_Account(), zc_Object_AccountDirection() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Account_AccountDirection');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Account_InfoMoneyDestination() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Account_InfoMoneyDestination'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Account_InfoMoneyDestination', 'Связь счета с Управленческие назначения', zc_Object_Account(), zc_Object_InfoMoneyDestination() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Account_InfoMoneyDestination');

CREATE OR REPLACE FUNCTION zc_ObjectLink_UserFormSettings_User() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UserFormSettings_User'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_UserFormSettings_User', 'Пользователь', zc_Object_UserFormSettings(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UserFormSettings_User');

CREATE OR REPLACE FUNCTION zc_ObjectLink_UserFormSettings_Form() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UserFormSettings_Form'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_UserFormSettings_Form', '???', zc_Object_UserFormSettings(), zc_Object_Form() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UserFormSettings_Form');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PriceListItem_PriceList() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PriceListItem_PriceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_PriceListItem_PriceList', 'Ссылка на прайс-лист', zc_Object_PriceListItem(), zc_Object_PriceList() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PriceListItem_PriceList');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PriceListItem_Goods()  RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PriceListItem_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_PriceListItem_Goods', 'Ссылка на товар', zc_Object_PriceListItem(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PriceListItem_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_Business()  RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Business'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Unit_Business', 'Связь подразделения с бизнесом', zc_Object_Unit(), zc_Object_Business() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Business');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_Juridical() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Unit_Juridical', 'Связь подразделения с юр лицом', zc_Object_Unit(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_AccountDirection() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_AccountDirection'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Unit_AccountDirection', 'Связь подразделения с аналитикой управленческих счетов - направление', zc_Object_Unit(), zc_Object_AccountDirection() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_AccountDirection');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_ProfitLossDirection() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_ProfitLossDirection'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Unit_ProfitLossDirection', 'Связь подразделения с аналитикой управленческих счетов - направление', zc_Object_Unit(), zc_Object_ProfitLossDirection() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_ProfitLossDirection');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Car_CarModel() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Car_CarModel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Car_CarModel', 'Связь Машины с маркой автомобиля', zc_Object_Car(), zc_Object_CarModel() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Car_CarModel');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Car_Unit() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Car_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Car_Unit', 'Связь Машины с Подразделением', zc_Object_Car(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Car_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Car_PersonalDriver() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Car_PersonalDriver'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Car_PersonalDriver', 'Связь Машины с Сотрудником(водитель)', zc_Object_Car(), zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Car_PersonalDriver');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Car_FuelMaster() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Car_FuelMaster'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Car_FuelMaster', 'Связь Машины с Видом топлива(основное)', zc_Object_Car(), zc_Object_Fuel() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Car_FuelMaster');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Car_FuelChild() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Car_FuelChild'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Car_FuelChild', 'Связь Машины с Видом топлива(Дополнительное)', zc_Object_Car(), zc_Object_Fuel() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Car_FuelChild');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Account_InfoMoney() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Account_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Account_InfoMoney', 'Связь счета с Управленческой аналитикой', zc_Object_Account(), zc_Object_InfoMoney() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Account_InfoMoney');


-- CREATE OR REPLACE FUNCTION zc_ObjectLink_UnitGroup_Parent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UnitGroup_Parent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_ObjectLink_InfoMoney_InfoMoneyGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_InfoMoney_InfoMoneyGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_InfoMoney_InfoMoneyGroup', 'Связь Статьи назначения с Группой управленческих назначений', zc_Object_InfoMoney(), zc_Object_InfoMoneyGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_InfoMoney_InfoMoneyGroup');

CREATE OR REPLACE FUNCTION zc_ObjectLink_InfoMoney_InfoMoneyDestination() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_InfoMoney_InfoMoneyDestination'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_InfoMoney_InfoMoneyDestination', 'Связь Статьи назначения с Управленческим назначением', zc_Object_InfoMoney(), zc_Object_InfoMoneyDestination() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_InfoMoney_InfoMoneyDestination');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ProfitLoss_ProfitLossGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ProfitLoss_ProfitLossGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ProfitLoss_ProfitLossGroup', 'Связь Статьи отчета о прибылях и убытках с Группой статей отчета о прибылях и убытках', zc_Object_ProfitLoss(), zc_Object_ProfitLossGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ProfitLoss_ProfitLossGroup');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ProfitLoss_ProfitLossDirection() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ProfitLoss_ProfitLossDirection'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ProfitLoss_ProfitLossDirection', 'Связь Статьи отчета о прибылях и убытках с Аналитикой статей отчета о прибылях и убытках - направления', zc_Object_ProfitLoss(), zc_Object_ProfitLossDirection() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ProfitLoss_ProfitLossDirection');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ProfitLoss_InfoMoneyDestination() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ProfitLoss_InfoMoneyDestination'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ProfitLoss_InfoMoneyDestination', 'Связь Статьи отчета о прибылях и убытках с Управленческие назначения', zc_Object_ProfitLoss(), zc_Object_InfoMoneyDestination() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ProfitLoss_InfoMoneyDestination');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ProfitLoss_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ProfitLoss_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ProfitLoss_InfoMoney', 'Связь Статьи отчета о прибылях и убытках с Управленческой аналитикой', zc_Object_ProfitLoss(), zc_Object_InfoMoney() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ProfitLoss_InfoMoney');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Personal_Member() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_Member'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Personal_Member', 'Связь Сотрудники с Физ.лицами', zc_Object_Personal(), zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_Member');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Personal_Position() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_Position'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Personal_Position', 'Связь Сотрудники с должностью', zc_Object_Personal(), zc_Object_Position() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_Position');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Personal_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Personal_Unit', 'Связь Сотрудники с подразделением', zc_Object_Personal(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Personal_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Personal_Juridical', 'Связь Сотрудники с юр.лицом', zc_Object_Personal(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Personal_Business() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_Business'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Personal_Business', 'Связь Сотрудники с Бизнесом', zc_Object_Personal(), zc_Object_Business() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_Business');
  
CREATE OR REPLACE FUNCTION zc_ObjectLink_Personal_PersonalGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_PersonalGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Personal_PersonalGroup', 'Связь Сотрудники с Группировкой Сотрудников', zc_Object_Personal(), zc_Object_PersonalGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_PersonalGroup');

CREATE OR REPLACE FUNCTION zc_ObjectLink_AssetGroup_Parent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_AssetGroup_Parent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_AssetGroup_Parent', 'Связь с группой  основных средств', zc_Object_AssetGroup(), zc_Object_AssetGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_AssetGroup_Parent');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Asset_AssetGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Asset_AssetGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Asset_AssetGroup', 'Связь основных средств с группой основных средств', zc_Object_Asset(), zc_Object_AssetGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Asset_AssetGroup');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PartionGoods_Partner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartionGoods_Partner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PartionGoods_Partner', 'Связь партий с Контрагентом', zc_Object_PartionGoods(), zc_Object_Partner() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartionGoods_Partner');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PartionGoods_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartionGoods_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PartionGoods_Goods', 'Связь партий с товаром', zc_Object_PartionGoods(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartionGoods_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_Route() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_Route'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Partner_Route', 'Связь Контрагента с маршрутом', zc_Object_Partner(), zc_Object_Route() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_Route');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_RouteSorting() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_RouteSorting'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Partner_RouteSorting', 'Связь Контрагента с Сотрировкой маршрута', zc_Object_Partner(), zc_Object_RouteSorting() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_RouteSorting');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Juridical_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Juridical_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Juridical_InfoMoney', 'Связь Контрагента с Управленческими аналитиками', zc_Object_Juridical(), zc_Object_InfoMoney() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Juridical_InfoMoney');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Account_AccountKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Account_AccountKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Account_AccountKind', 'Связь Счета с Видом счетов', zc_Object_Account(), zc_Object_AccountKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Account_AccountKind');


CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsByGoodsKind_Goods', 'Товары', zc_Object_GoodsByGoodsKind(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsByGoodsKind_GoodsKind', 'Виды товаров', zc_Object_GoodsByGoodsKind(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ReceiptChild_Receipt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReceiptChild_Receipt'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ReceiptChild_Receipt', 'Рецептуры', zc_Object_ReceiptChild(), zc_Object_Receipt() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReceiptChild_Receipt');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ReceiptChild_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReceiptChild_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ReceiptChild_Goods', 'Товары', zc_Object_ReceiptChild(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReceiptChild_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ReceiptChild_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReceiptChild_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ReceiptChild_GoodsKind', 'Виды товаров', zc_Object_ReceiptChild(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReceiptChild_GoodsKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Receipt_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Receipt_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Receipt_Goods', 'Связь рецептуры с Товаром', zc_Object_Receipt(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Receipt_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Receipt_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Receipt_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Receipt_GoodsKind', 'Связь рецептуры с Видом Товаров', zc_Object_Receipt(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Receipt_GoodsKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Receipt_GoodsKindComplete() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Receipt_GoodsKindComplete'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Receipt_GoodsKindComplete', 'Связь рецептуры с Виды товаров (готовая продукция)', zc_Object_Receipt(), zc_Object_GoodsKindComplete() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Receipt_GoodsKindComplete');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Receipt_ReceiptCost() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Receipt_ReceiptCost'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Receipt_ReceiptCost', 'Связь рецептуры с Затраты в рецептурах', zc_Object_Receipt(), zc_Object_ReceiptCost() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Receipt_ReceiptCost');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Receipt_ReceiptKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Receipt_ReceiptKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Receipt_ReceiptKind', 'Связь рецептуры с Виды рецептур', zc_Object_Receipt(), zc_Object_ReceiptKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Receipt_ReceiptKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_PersonalTake() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_PersonalTake'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Partner_PersonalTake', 'Связь Контрагента с Сотрудником (экспедитор)', zc_Object_Partner(), zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_PersonalTake');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_PersonalTake() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_PersonalTake'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Partner_PersonalTake', 'Связь Контрагента с Сотрудником (экспедитор)', zc_Object_Partner(), zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_PersonalTake');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Cash_MainJuridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Cash_MainJuridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Cash_MainJuridical', 'Связь кассы с главным юр лицом', zc_Object_Cash(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Cash_MainJuridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Cash_Business() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Cash_Business'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Cash_Business', 'Связь кассы с бизнесом', zc_Object_Cash(), zc_Object_Business() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Cash_Business');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Contract_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Contract_InfoMoney', 'Связь с Статьи назначения', zc_Object_Contract(), zc_Object_InfoMoney() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_InfoMoney');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Route_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Route_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Route_Unit', 'Связь маршрута с Подразделением', zc_Object_Route(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Route_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Route_RouteKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Route_RouteKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Route_RouteKind', 'Связь маршрута с Типом маршрута', zc_Object_Route(), zc_Object_RouteKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Route_RouteKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Route_Freight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Route_Freight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Route_Freight', 'Связь маршрута с Название груза', zc_Object_Route(), zc_Object_Freight() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Route_Freight');

CREATE OR REPLACE FUNCTION zc_ObjectLink_RoleAction_Role() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RoleAction_Role'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_RoleAction_Role', 'Ссылка на роль в справочнике указания ролей', zc_Object_RoleAction(), zc_Object_Role() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RoleAction_Role');

CREATE OR REPLACE FUNCTION zc_ObjectLink_RoleAction_Action() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RoleAction_Action'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_RoleAction_Action', 'Ссылка на действие в справочнике свзяи ролей', zc_Object_RoleAction(), zc_Object_Action() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RoleAction_Action');

CREATE OR REPLACE FUNCTION zc_ObjectLink_User_Member() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_User_Member'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_User_Member', 'Ссылка на физ лицо в справочнике пользователей', zc_Object_User(), zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_User_Member');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Fuel_RateFuelKind() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Fuel_RateFuelKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Fuel_RateFuelKind', 'Ссылка на Виды норм для топлива', zc_Object_Fuel(), zc_Object_RateFuelKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Fuel_RateFuelKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_RateFuel_RouteKind() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RateFuel_RouteKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_RateFuel_RouteKind', 'Ссылка на Типы маршрутов', zc_Object_RateFuel(), zc_Object_RateFuelKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RateFuel_RouteKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_RateFuel_Car() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RateFuel_Car'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_RateFuel_Car', 'Ссылка на Автомобили', zc_Object_RateFuel(), zc_Object_RateFuelKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RateFuel_Car');


CREATE OR REPLACE FUNCTION zc_ObjectLink_PersonalGroup_Unit() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PersonalGroup_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PersonalGroup_Unit', 'Ссылка на Автомобили', zc_Object_PersonalGroup(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PersonalGroup_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_CardFuel_PersonalDriver() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CardFuel_PersonalDriver'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_CardFuel_PersonalDriver', 'Ссылка на Сотрудника(водителя)', zc_Object_CardFuel(), zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CardFuel_PersonalDriver');

CREATE OR REPLACE FUNCTION zc_ObjectLink_CardFuel_Car() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CardFuel_Car'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_CardFuel_Car', 'Ссылка на Автомобили', zc_Object_CardFuel(), zc_Object_Car() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CardFuel_Car');

CREATE OR REPLACE FUNCTION zc_ObjectLink_CardFuel_PaidKind() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CardFuel_PaidKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_CardFuel_PaidKind', 'Ссылка на Виды форм оплаты ', zc_Object_CardFuel(), zc_Object_PaidKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CardFuel_PaidKind');
  
CREATE OR REPLACE FUNCTION zc_ObjectLink_CardFuel_Juridical() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CardFuel_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_CardFuel_Juridical', 'Ссылка на Юридические лица', zc_Object_CardFuel(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CardFuel_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_CardFuel_Goods() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CardFuel_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_CardFuel_Goods', 'Ссылка на Товары', zc_Object_CardFuel(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CardFuel_Goods');


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.10.13         * add _CardFuel_PersonalDriver, _CardFuel_Car, _CardFuel_PaidKind, _CardFuel_Juridical, _CardFuel_Goods   
 29.09.13         * add zc_ObjectLink_PersonalGroup_Unit
 01.09.13                                        * add zc_ObjectLink_Goods_Fuel
 26.09.13         * add zc_ObjectLink_Fuel_RateFuelKind,  del Car_RateFuelKind, RateFuel_RateFuelKind
 24.09.13         * add  _Route_Unit, _Route_RouteKind, _Route_Freight
                       , _RateFuel_Car, _RateFuel_RouteKind, _RateFuel_RateFuelKind
                       , _Car_Unit, _Car_PersonalDriver, _Car_FuelMaster, _Car_FuelChild, _Car_RateFuelKind            
 07.09.13                                        * add zc_ObjectLink_Contract_InfoMoney
 01.09.13                                        * add zc_ObjectLink_Goods_Business
 27.08.13         * НОВАЯ СХЕМА 2              
 28.06.13                                        * НОВАЯ СХЕМА
*/
