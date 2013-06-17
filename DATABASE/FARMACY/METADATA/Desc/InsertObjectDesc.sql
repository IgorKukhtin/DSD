insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_Process(), 'Process', 'Процессы' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_Process());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_Role(), 'Role', 'Роли' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_Role());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_object_user(), 'User', 'Пользователи' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_object_user());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_RoleRight(), 'RoleRight', 'Установка прав на роли' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_RoleRight());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_UserRole(), 'UserRole', 'Связь пользователей и ролей' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_UserRole());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_Goods(), 'Goods', 'Справочник товаров' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_Goods());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_Unit(), 'Unit', 'Справочник подразделений' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_Unit());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_Form(), 'Form', 'Формы приложения' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_Form());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_Measure(), 'Measure', 'Единицы измерения' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_Measure());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_Cash(), 'Cash', 'Кассы' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_Cash());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_AccountPlan(), 'AccountPlan', 'План счетов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_AccountPlan());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_Status(), 'Status', 'Статусы документов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_Status());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_Currency(), 'Currency', 'Валюты' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_Currency());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_PaidKind(), 'PaidKind', 'Формы оплат' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_PaidKind());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_Branch(), 'Branch', 'Филиалы' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_Branch());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_JuridicalGroup(), 'JuridicalGroup', 'Группы юр. лиц' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_JuridicalGroup());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_Juridical(), 'Juridical', 'Юр лица' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_Juridical());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_GoodsProperty(), 'GoodsProperty', 'Классификаторы свойств товаров' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_GoodsProperty());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_Partner(), 'Partner', 'Контрагент' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_Partner());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_ContractKind(), 'ContractKind', 'Виды договоров' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_ContractKind());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_Business(), 'Business', 'Бизнесы' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_Business());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_UnitGroup(), 'UnitGroup', 'Группы подразеделений' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_UnitGroup());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_GoodsGroup(), 'GoodsGroup', 'Группы товаров' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_GoodsGroup());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_Bank(), 'Bank', 'Банки' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_Bank());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_GoodsKind(), 'GoodsKind', 'Тип товара' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_GoodsKind());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_BankAccount(), 'BankAccount', 'Расчетный счет' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_BankAccount());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_PriceList(), 'PriceList', 'Прайс-лист' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_PriceList());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_Contract(), 'Contract', 'Договора' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_Contract());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_CarModel(), 'CarModel', 'Модели автомобиля' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_CarModel());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_Car(), 'Car', 'Автомобиль' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_Car());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_GoodsPropertyValue(), 'GoodsPropertyValue', '' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_GoodsPropertyValue());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_AccountGroup(), 'AccountGroup', 'Группы счетов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_AccountGroup());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_AccountDirection(), 'AccountDirection', 'Аналитика счета (место)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_AccountDirection());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_Account(), 'Account', 'Счет' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_Account());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_InfoMoneyGroup(), 'InfoMoneyGroup', 'Группа управленческих статей' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_InfoMoneyGroup());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_InfoMoneyDestination(), 'InfoMoneyDestination', 'Направление' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_InfoMoneyDestination());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_InfoMoney(), 'InfoMoney', 'Управленческие статьи' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_InfoMoney());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_ProfitLossGroup(), 'ProfitLossGroup', 'Группы отчета по прибылям' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_ProfitLossGroup());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_ProfitLossDirection(), 'ProfitLossDirection', 'Группы отчета по прибылям' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_ProfitLossDirection());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_ProfitLoss(), 'ProfitLoss', 'Отчеты по прибылям' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_ProfitLoss());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_Route(), 'Route', 'Маршруты' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_Route());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_RouteSorting(), 'RouteSorting', 'Сортировки маршрутов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_RouteSorting());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_UserFormSettings(), 'UserFormSettings', 'Пользовательские установки' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_UserFormSettings());

insert into ObjectDesc(Id, Code, ItemName)
SELECT zc_Object_PriceListItem(), 'PriceListItem', 'Цены' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Id = zc_Object_PriceListItem());
