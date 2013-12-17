--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_Object_Program() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Program'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Program', 'Программы' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Program');

CREATE OR REPLACE FUNCTION zc_Object_Cash() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Cash'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Cash', 'Кассы' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Cash');

CREATE OR REPLACE FUNCTION zc_Object_Currency() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Currency'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Currency', 'Валюты' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Currency');

CREATE OR REPLACE FUNCTION zc_Object_PaidKind() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PaidKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_PaidKind', 'Формы оплат' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PaidKind');

CREATE OR REPLACE FUNCTION zc_Object_Branch() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Branch'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Branch', 'Филиалы' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Branch');

CREATE OR REPLACE FUNCTION zc_Object_ContractKind() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_ContractKind', 'Виды договоров' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractKind');

CREATE OR REPLACE FUNCTION zc_Object_Business() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Business'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Business', 'Бизнесы' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Business');

CREATE OR REPLACE FUNCTION zc_Object_Bank() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Bank'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Bank', 'Банки' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Bank');

CREATE OR REPLACE FUNCTION zc_Object_BankAccount() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_BankAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_BankAccount', 'Расчетный счет' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_BankAccount');

CREATE OR REPLACE FUNCTION zc_Object_Contract() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Contract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
  SELECT 'zc_Object_Contract', 'Договора' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Contract');

CREATE OR REPLACE FUNCTION zc_Object_Car() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Car'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Car', 'Автомобили' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Car');

CREATE OR REPLACE FUNCTION zc_Object_CarModel() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CarModel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_CarModel', 'Модели автомобиля' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CarModel');
-------------------------
CREATE OR REPLACE FUNCTION zc_Object_Status() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Status'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Status', 'Статусы документов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Status');

CREATE OR REPLACE FUNCTION zc_Object_GoodsGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsGroup', 'Группы товаров' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsGroup');

CREATE OR REPLACE FUNCTION zc_Object_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Goods', 'Справочник товаров' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Goods');

CREATE OR REPLACE FUNCTION zc_Object_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsKind', 'Тип товара' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsKind');

CREATE OR REPLACE FUNCTION zc_Object_GoodsProperty() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsProperty'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsProperty', 'Классификаторы свойств товаров' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsProperty');

CREATE OR REPLACE FUNCTION zc_Object_GoodsPropertyValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsPropertyValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsPropertyValue', 'Значения свойств товаров для классификатора' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsPropertyValue');

CREATE OR REPLACE FUNCTION zc_Object_Measure() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Measure'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Measure', 'Единицы измерения' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Measure');
 
CREATE OR REPLACE FUNCTION zc_Object_InfoMoneyGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoneyGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_InfoMoneyGroup', 'Группа управленческих статей' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoneyGroup');

CREATE OR REPLACE FUNCTION zc_Object_InfoMoneyDestination() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoneyDestination'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_InfoMoneyDestination', 'Направление' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoneyDestination');

CREATE OR REPLACE FUNCTION zc_Object_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_InfoMoney', 'Управленческие статьи' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoney');

CREATE OR REPLACE FUNCTION zc_Object_AccountGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AccountGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AccountGroup', 'Группы счетов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AccountGroup');

CREATE OR REPLACE FUNCTION zc_Object_AccountDirection() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AccountDirection'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AccountDirection', 'Аналитика счета (место)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AccountDirection');

CREATE OR REPLACE FUNCTION zc_Object_Account() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Account'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Account', 'Счет' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Account');

CREATE OR REPLACE FUNCTION zc_Object_ProfitLossGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLossGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ProfitLossGroup', 'Группы отчета по прибылям' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLossGroup');

CREATE OR REPLACE FUNCTION zc_Object_ProfitLossDirection() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLossDirection'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ProfitLossDirection', 'Группы отчета по прибылям' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLossDirection');

CREATE OR REPLACE FUNCTION zc_Object_ProfitLoss() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLoss'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ProfitLoss', 'Отчеты по прибылям' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLoss');

CREATE OR REPLACE FUNCTION zc_Object_JuridicalGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_JuridicalGroup', 'Группы юр. лиц' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalGroup');

CREATE OR REPLACE FUNCTION zc_Object_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Juridical', 'Юридические лица' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Juridical');

CREATE OR REPLACE FUNCTION zc_Object_Partner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Partner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Partner', 'Контрагенты' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Partner');
  
-- CREATE OR REPLACE FUNCTION zc_Object_UnitGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_UnitGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Unit', 'Подразделения' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Unit');

CREATE OR REPLACE FUNCTION zc_Object_Route() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Route'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Route', 'Маршруты' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Route');

CREATE OR REPLACE FUNCTION zc_Object_RouteSorting() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RouteSorting'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RouteSorting', 'Сортировки маршрутов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RouteSorting');

CREATE OR REPLACE FUNCTION zc_Object_PriceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PriceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PriceList', 'Прайс-листы' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PriceList');

CREATE OR REPLACE FUNCTION zc_Object_PriceListItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PriceListItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PriceListItem', 'Цены прайс-листа' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PriceListItem');

-- CREATE OR REPLACE FUNCTION zc_Object_AccountPlan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AccountPlan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Object_Process() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Process'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Process', 'Процессы' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Process');

CREATE OR REPLACE FUNCTION zc_Object_Role() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Role'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Role', 'Роли' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Role');

CREATE OR REPLACE FUNCTION zc_object_User() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_object_User'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_object_User', 'Пользователи' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_object_User');

CREATE OR REPLACE FUNCTION zc_Object_RoleRight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RoleRight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RoleRight', 'Установка прав на роли' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RoleRight');

CREATE OR REPLACE FUNCTION zc_Object_UserRole() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_UserRole'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_UserRole', 'Связь пользователей и ролей' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_UserRole');

CREATE OR REPLACE FUNCTION zc_Object_Form() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Form'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Form', 'Формы приложения' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Form');

CREATE OR REPLACE FUNCTION zc_Object_UserFormSettings() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_UserFormSettings'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_UserFormSettings', 'Пользовательские установки' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_UserFormSettings');

CREATE OR REPLACE FUNCTION zc_Object_Member() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Member'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Member', 'Физические лица' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Member');

CREATE OR REPLACE FUNCTION zc_Object_Position() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Position'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Position', 'Должности' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Position');

CREATE OR REPLACE FUNCTION zc_Object_Personal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Personal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Personal', 'Сотрудники' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Personal');

CREATE OR REPLACE FUNCTION zc_Object_AssetGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AssetGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AssetGroup', 'Группы основных средств' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AssetGroup');

CREATE OR REPLACE FUNCTION zc_Object_Asset() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Asset'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Asset', 'Основные средства' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Asset');

CREATE OR REPLACE FUNCTION zc_Object_PartionGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PartionGoods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PartionGoods', 'Партии товаров' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PartionGoods');

CREATE OR REPLACE FUNCTION zc_Object_PartionMovement() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PartionMovement'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PartionMovement', 'Партии накладных' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PartionMovement');

CREATE OR REPLACE FUNCTION zc_Object_TradeMark() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_TradeMark'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_TradeMark', 'Торговые марки' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_TradeMark');

CREATE OR REPLACE FUNCTION zc_Object_AccountKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AccountKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AccountKind', 'Виды счетов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AccountKind');

CREATE OR REPLACE FUNCTION zc_Object_GoodsByGoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsByGoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsByGoodsKind', 'Связи Товары и Виды товаров' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsByGoodsKind');

CREATE OR REPLACE FUNCTION zc_object_receipt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_object_receipt'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_object_receipt', 'Рецептуры' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_object_receipt');

CREATE OR REPLACE FUNCTION zc_Object_ReceiptCost() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReceiptCost'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ReceiptCost', 'Затраты в рецептурах' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReceiptCost');

CREATE OR REPLACE FUNCTION zc_Object_ReceiptChild() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReceiptChild'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ReceiptChild', 'Составляющие рецептур' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReceiptChild');


CREATE OR REPLACE FUNCTION zc_object_goodskindcomplete() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_object_goodskindcomplete'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_object_goodskindcomplete', 'Виды товаров (готовая продукция)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_object_goodskindcomplete');

 
CREATE OR REPLACE FUNCTION zc_object_receiptkind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_object_receiptkind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_object_receiptkind', 'Виды рецептур' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_object_receiptkind');

CREATE OR REPLACE FUNCTION zc_Object_Action() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Action'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Action', 'Команды вызова пунктов меню' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Action');

CREATE OR REPLACE FUNCTION zc_Object_RoleAction() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RoleAction'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RoleAction', 'Связь роли и команды вызова пунктов меню' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RoleAction');

CREATE OR REPLACE FUNCTION zc_Object_Fuel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Fuel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Fuel', 'Виды топлива' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Fuel');

CREATE OR REPLACE FUNCTION zc_Object_Freight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Freight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Freight', 'Названия грузов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Freight');

CREATE OR REPLACE FUNCTION zc_Object_PersonalGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PersonalGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PersonalGroup', 'Группировки Сотрудников' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PersonalGroup');

CREATE OR REPLACE FUNCTION zc_Object_RateFuel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RateFuel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RateFuel', 'Нормы топлива' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RateFuel');

CREATE OR REPLACE FUNCTION zc_Object_RateFuelKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RateFuelKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RateFuelKind', 'Типы норм для топлива' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RateFuelKind');

CREATE OR REPLACE FUNCTION zc_Object_RouteKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RouteKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RouteKind', 'Типы маршрутов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RouteKind');

CREATE OR REPLACE FUNCTION zc_Object_WorkTimeKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_WorkTimeKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_WorkTimeKind', 'Типы рабочего времени' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_WorkTimeKind');

CREATE OR REPLACE FUNCTION zc_Object_CardFuel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CardFuel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CardFuel', 'Топливные карты' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CardFuel');

CREATE OR REPLACE FUNCTION zc_Object_TicketFuel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_TicketFuel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_TicketFuel', 'Талоны на топливо' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_TicketFuel');

CREATE OR REPLACE FUNCTION zc_Object_PositionLevel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PositionLevel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PositionLevel', 'Разряд должности' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PositionLevel');

CREATE OR REPLACE FUNCTION zc_Object_StaffList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StaffList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_StaffList', 'Штатное расписание' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StaffList');

CREATE OR REPLACE FUNCTION zc_Object_ModelServiceKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ModelServiceKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ModelServiceKind', 'Типы модели начисления' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ModelServiceKind');

CREATE OR REPLACE FUNCTION zc_Object_ModelService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ModelService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ModelService', 'Модели начисления' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ModelService');

CREATE OR REPLACE FUNCTION zc_Object_StaffListCost() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StaffListCost'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_StaffListCost', 'Расценки штатного расписания' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StaffListCost');

CREATE OR REPLACE FUNCTION zc_Object_ModelServiceItemMaster() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ModelServiceItemMaster'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ModelServiceItemMaster', 'Главные элементы Модели начисления' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ModelServiceItemMaster');

CREATE OR REPLACE FUNCTION zc_Object_ModelServiceItemChild() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ModelServiceItemChild'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ModelServiceItemChild', 'Подчиненные элементы Модели начисления' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ModelServiceItemChild');

CREATE OR REPLACE FUNCTION zc_Object_SelectKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_SelectKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_SelectKind', 'Типы выбора данных' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_SelectKind');

CREATE OR REPLACE FUNCTION zc_Object_StaffListSummKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StaffListSummKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_StaffListSummKind', 'Типы сумм для штатного расписания' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StaffListSummKind');

CREATE OR REPLACE FUNCTION zc_Object_StaffListSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StaffListSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_StaffListSumm', 'Cуммы для штатного расписания' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StaffListSumm');

CREATE OR REPLACE FUNCTION zc_Object_ContractStateKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractStateKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContractStateKind', 'Состояние договора' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractStateKind');

CREATE OR REPLACE FUNCTION zc_Object_ContractArticle() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractArticle'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContractArticle', 'Предмет договора' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractArticle');

CREATE OR REPLACE FUNCTION zc_Object_Area() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Area'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Area', 'Регионы' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Area');

CREATE OR REPLACE FUNCTION zc_Object_ContractConditionKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractConditionKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContractConditionKind', 'Типы условий договоров' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractConditionKind');

CREATE OR REPLACE FUNCTION zc_Object_ContractCondition() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractCondition'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContractCondition', 'Условия договора' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractCondition');

CREATE OR REPLACE FUNCTION zc_Object_Calendar() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Calendar'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Calendar', 'Календарь рабочих дней' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Calendar');

CREATE OR REPLACE FUNCTION zc_Object_AccessRole() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AccessRole'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AccessRole', 'Роли доступа' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AccessRole');

CREATE OR REPLACE FUNCTION zc_Object_RoleProcessAccess() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RoleProcessAccess'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RoleProcessAccess', 'Связь ролей и процессов доступа' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RoleProcessAccess');

CREATE OR REPLACE FUNCTION zc_Object_ContractDocument() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractDocument'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContractDocument', 'Связь контрактов и документов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractDocument');

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
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
 21.08.13         * НОВАЯ СХЕМА 2
 08.07.13         * переход всего на НОВУЮ СХЕМУ
 28.06.13                                        * НОВАЯ СХЕМА
*/
