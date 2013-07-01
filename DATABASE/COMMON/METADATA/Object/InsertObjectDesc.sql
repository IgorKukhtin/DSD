INSERT INTO ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_Cash(), 'Cash', 'Кассы' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_Cash());

INSERT INTO ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_Currency(), 'Currency', 'Валюты' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_Currency());

INSERT INTO ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_PaidKind(), 'PaidKind', 'Формы оплат' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_PaidKind());

INSERT INTO ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_Branch(), 'Branch', 'Филиалы' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_Branch());

INSERT INTO ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_ContractKind(), 'ContractKind', 'Виды договоров' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_ContractKind());

INSERT INTO ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_Business(), 'Business', 'Бизнесы' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_Business());

INSERT INTO ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_Bank(), 'Bank', 'Банки' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_Bank());

INSERT INTO ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_BankAccount(), 'BankAccount', 'Расчетный счет' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_BankAccount());

INSERT INTO ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_Contract(), 'Contract', 'Договора' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_Contract());

INSERT INTO ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_CarModel(), 'CarModel', 'Модели автомобиля' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_CarModel());

INSERT INTO ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_Car(), 'Car', 'Автомобиль' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_Car());


--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

-- !!! Меняем автоинкрементное поле !!!
DO $$
BEGIN
PERFORM setval('objectdesc_id_seq', (select max (id) + 1 from ObjectDesc));
END $$;


INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Status', 'Статусы документов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Status');

INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsGroup', 'Группы товаров' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsGroup');
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Goods', 'Справочник товаров' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Goods');
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsKind', 'Тип товара' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsKind');
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsProperty', 'Классификаторы свойств товаров' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsProperty');
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsPropertyValue', '???' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsPropertyValue');
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Measure', 'Единицы измерения' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Measure');
  
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_InfoMoneyGroup', 'Группа управленческих статей' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoneyGroup');
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_InfoMoneyDestination', 'Направление' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoneyDestination');
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_InfoMoney', 'Управленческие статьи' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoney');
  
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AccountGroup', 'Группы счетов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AccountGroup');
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AccountDirection', 'Аналитика счета (место)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AccountDirection');
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Account', 'Счет' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Account');

INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ProfitLossGroup', 'Группы отчета по прибылям' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLossGroup');
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ProfitLossDirection', 'Группы отчета по прибылям' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLossDirection');
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ProfitLoss', 'Отчеты по прибылям' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLoss');

INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_JuridicalGroup', 'Группы юр. лиц' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalGroup');
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Juridical', 'Юр лица' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Juridical');
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Partner', 'Контрагент' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Partner');
-- INSERT INTO ObjectDesc (Code, ItemName)
--  SELECT 'zc_Object_UnitGroup', 'Группы подразеделений' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_UnitGroup');
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Unit', 'Справочник подразделений' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Unit');

INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Route', 'Маршруты' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Route');
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RouteSorting', 'Сортировки маршрутов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RouteSorting');

INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PriceList', 'Прайс-лист' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PriceList');
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PriceListItem', 'Цены' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PriceListItem');

INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Process', 'Процессы' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Process');
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Role', 'Роли' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Role');
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_object_User', 'Пользователи' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_object_User');
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RoleRight', 'Установка прав на роли' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RoleRight');
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_UserRole', 'Связь пользователей и ролей' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_UserRole');
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Form', 'Формы приложения' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Form');
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_UserFormSettings', 'Пользовательские установки' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_UserFormSettings');
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Member', 'Физические лица' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Member');
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Position', 'Должности' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Position');
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Personal', 'Сотрудники' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Personal');
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AssetGroup', 'Группы основных средств' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AssetGroup');


-- INSERT INTO ObjectDesc (Code, ItemName)
--  SELECT 'zc_Object_AccountPlan', 'План счетов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AccountPlan');


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.06.13                                        * НОВАЯ СХЕМА
*/
