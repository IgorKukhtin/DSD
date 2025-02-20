--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_Object_ReplServer() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReplServer'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ReplServer', 'Сервера для Реплики БД' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReplServer');

CREATE OR REPLACE FUNCTION zc_Object_ReplMovement() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReplMovement'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ReplMovement', 'Репликация документов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReplMovement');

CREATE OR REPLACE FUNCTION zc_Object_ReplObject() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReplObject'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ReplObject', 'Репликация справочников' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReplObject');

--
CREATE OR REPLACE FUNCTION zc_Object_Account() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Account'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Account', 'Счет' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Account');

CREATE OR REPLACE FUNCTION zc_Object_AccountDirection() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AccountDirection'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AccountDirection', 'Аналитика счета (место)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AccountDirection');

CREATE OR REPLACE FUNCTION zc_Object_AccountGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AccountGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AccountGroup', 'Группы счетов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AccountGroup');

CREATE OR REPLACE FUNCTION zc_Object_AccountKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AccountKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AccountKind', 'Виды счетов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AccountKind');

CREATE OR REPLACE FUNCTION zc_Object_Action() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Action'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Action', 'Команды вызова пунктов меню' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Action');

CREATE OR REPLACE FUNCTION zc_Object_AnalyzerId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AnalyzerId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AnalyzerId', 'Типы аналитик для проводок' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AnalyzerId');

CREATE OR REPLACE FUNCTION zc_Object_Area() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Area'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Area', 'Регионы' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Area');

CREATE OR REPLACE FUNCTION zc_Object_AreaContract() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AreaContact'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_AreaContact', 'Регионы(договора)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AreaContact');

CREATE OR REPLACE FUNCTION zc_Object_Asset() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Asset'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Asset', 'Основные средства' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Asset');

CREATE OR REPLACE FUNCTION zc_Object_AssetGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AssetGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AssetGroup', 'Группы основных средств' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AssetGroup');

CREATE OR REPLACE FUNCTION zc_Object_AccessRole() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AccessRole'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AccessRole', 'Роли доступа' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AccessRole');

CREATE OR REPLACE FUNCTION zc_Object_Bank() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Bank'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Bank', 'Банки' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Bank');

CREATE OR REPLACE FUNCTION zc_Object_BankAccount() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_BankAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_BankAccount', 'Расчетный счет' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_BankAccount');

CREATE OR REPLACE FUNCTION zc_Object_BankAccountContract() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_BankAccountContract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_BankAccountContract', 'Расчетный счет(оплата нам)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_BankAccountContract');

CREATE OR REPLACE FUNCTION zc_Object_BarCodeBox() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_BarCodeBox'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_BarCodeBox', 'Справочник Ш/К для ящиков' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_BarCodeBox');

CREATE OR REPLACE FUNCTION zc_Object_Box() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Box'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Box', 'Виды ящиков' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Box');

CREATE OR REPLACE FUNCTION zc_Object_Branch() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Branch'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Branch', 'Филиалы' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Branch');

CREATE OR REPLACE FUNCTION zc_Object_Business() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Business'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Business', 'Бизнесы' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Business');

CREATE OR REPLACE FUNCTION zc_Object_Calendar() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Calendar'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Calendar', 'Календарь рабочих дней' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Calendar');

CREATE OR REPLACE FUNCTION zc_Object_Car() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Car'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Car', 'Автомобили' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Car');

CREATE OR REPLACE FUNCTION zc_Object_CardFuel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CardFuel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CardFuel', 'Топливные карты' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CardFuel');

CREATE OR REPLACE FUNCTION zc_Object_CarExternal() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CarExternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_CarExternal', 'Автомобили (сторонние)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CarExternal');

CREATE OR REPLACE FUNCTION zc_Object_CarModel() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CarModel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
  SELECT 'zc_Object_CarModel', 'Модели автомобиля' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CarModel');

CREATE OR REPLACE FUNCTION zc_Object_Cash() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Cash'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
  SELECT 'zc_Object_Cash', 'Кассы' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Cash');

CREATE OR REPLACE FUNCTION zc_Object_CashRegister() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CashRegister'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
  SELECT 'zc_Object_CashRegister', 'Кассовый аппарат' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CashRegister');

CREATE OR REPLACE FUNCTION zc_Object_CashRegisterKind() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CashRegisterKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
  SELECT 'zc_Object_CashRegisterKind', 'Тип кассового аппарата' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CashRegisterKind');

CREATE OR REPLACE FUNCTION zc_Object_ClientKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ClientKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ClientKind', 'Категории покупателей' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ClientKind');

CREATE OR REPLACE FUNCTION zc_Object_ContactPerson() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContactPerson'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContactPerson', 'Контактные лица' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContactPerson');

CREATE OR REPLACE FUNCTION zc_Object_ContactPersonKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContactPersonKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContactPersonKind', 'Вид контакта' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContactPersonKind');

CREATE OR REPLACE FUNCTION zc_Object_Contract() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Contract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
  SELECT 'zc_Object_Contract', 'Договора' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Contract');

CREATE OR REPLACE FUNCTION zc_Object_ContractArticle() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractArticle'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContractArticle', 'Предмет договора' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractArticle');

CREATE OR REPLACE FUNCTION zc_Object_ContractCondition() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractCondition'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContractCondition', 'Условия договора' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractCondition');

CREATE OR REPLACE FUNCTION zc_Object_ContractConditionKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractConditionKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContractConditionKind', 'Типы условий договоров' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractConditionKind');

CREATE OR REPLACE FUNCTION zc_Object_ContractDocument() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractDocument'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContractDocument', 'Связь контрактов и документов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractDocument');

CREATE OR REPLACE FUNCTION zc_Object_ContractKind() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_ContractKind', 'Виды договоров' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractKind');

CREATE OR REPLACE FUNCTION zc_Object_ContractStateKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractStateKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContractStateKind', 'Состояние договора' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractStateKind');

CREATE OR REPLACE FUNCTION zc_Object_CorrespondentAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CorrespondentAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CorrespondentAccount', 'Корреспондентский счет' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CorrespondentAccount');

CREATE OR REPLACE FUNCTION zc_Object_Currency() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Currency'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Currency', 'Валюты' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Currency');

CREATE OR REPLACE FUNCTION zc_Object_Form() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Form'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Form', 'Формы приложения' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Form');

CREATE OR REPLACE FUNCTION zc_Object_Freight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Freight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Freight', 'Названия грузов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Freight');

CREATE OR REPLACE FUNCTION zc_Object_Fuel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Fuel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Fuel', 'Виды топлива' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Fuel');

CREATE OR REPLACE FUNCTION zc_Object_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Goods', 'Товары' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Goods');

CREATE OR REPLACE FUNCTION zc_Object_GoodsByGoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsByGoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsByGoodsKind', 'Связи Товары и Виды товаров' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsByGoodsKind');

CREATE OR REPLACE FUNCTION zc_Object_GoodsGroupStat() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsGroupStat'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsGroupStat', 'Группы товаров(статистика)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsGroupStat');

CREATE OR REPLACE FUNCTION zc_Object_GoodsGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsGroup', 'Группы товаров' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsGroup');

CREATE OR REPLACE FUNCTION zc_Object_GoodsGroupAnalyst() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsGroupAnalyst'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_GoodsGroupAnalyst', 'Группа товаров(аналитика)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsGroupAnalyst');

CREATE OR REPLACE FUNCTION zc_Object_GoodsExternal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsExternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsExternal', 'Справочник товаров' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsExternal');

CREATE OR REPLACE FUNCTION zc_Object_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsKind', 'Тип товара' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsKind');

CREATE OR REPLACE FUNCTION zc_object_goodskindcomplete() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_object_goodskindcomplete'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_object_goodskindcomplete', 'Виды товаров (готовая продукция)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_object_goodskindcomplete');

CREATE OR REPLACE FUNCTION zc_Object_GoodsProperty() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsProperty'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsProperty', 'Классификаторы свойств товаров' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsProperty');

CREATE OR REPLACE FUNCTION zc_Object_GoodsPropertyValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsPropertyValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsPropertyValue', 'Значения свойств товаров для классификатора' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsPropertyValue');

CREATE OR REPLACE FUNCTION zc_Object_GoodsTag() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsTag'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsTag', 'Значения свойств товаров для классификатора' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsTag');

CREATE OR REPLACE FUNCTION zc_Object_GoodsScaleCeh() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsScaleCeh'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsScaleCeh', 'Товары для накопительного расхода в Производстве-разделении' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsScaleCeh');

CREATE OR REPLACE FUNCTION zc_Object_GlobalConst() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GlobalConst'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GlobalConst', 'Глобальные константы для конфигурации' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GlobalConst');

CREATE OR REPLACE FUNCTION zc_Object_ImportExportLink() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ImportExportLink'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ImportExportLink', 'Связи объектов для загрузки, выгрузки' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ImportExportLink');

CREATE OR REPLACE FUNCTION zc_Object_ImportExportLinkType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ImportExportLinkType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ImportExportLinkType', 'Связи объектов для загрузки, выгрузки' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ImportExportLinkType');

CREATE OR REPLACE FUNCTION zc_Object_ImportGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ImportGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ImportGroup', 'Группа импорта' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ImportGroup');

CREATE OR REPLACE FUNCTION zc_Object_ImportGroupItems() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ImportGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ImportGroupItems', 'Элементы группы импорта' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ImportGroupItems');

CREATE OR REPLACE FUNCTION zc_Object_ImportSettings() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ImportSettings'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ImportSettings', 'Настройки импорта' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ImportSettings');

CREATE OR REPLACE FUNCTION zc_Object_ImportSettingsItems() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ImportSettingsItems'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ImportSettingsItems', 'Настройки импорта' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ImportSettingsItems');

CREATE OR REPLACE FUNCTION zc_Object_ImportType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ImportType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ImportType', 'Типы импорта' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ImportType');

CREATE OR REPLACE FUNCTION zc_Object_ImportTypeItems() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ImportTypeItems'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ImportTypeItems', 'Элементы типа импорта' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ImportTypeItems');

CREATE OR REPLACE FUNCTION zc_Object_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_InfoMoney', 'Управленческие статьи' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoney');

CREATE OR REPLACE FUNCTION zc_Object_InfoMoneyDestination() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoneyDestination'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_InfoMoneyDestination', 'Направление' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoneyDestination');

CREATE OR REPLACE FUNCTION zc_Object_InfoMoneyGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoneyGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_InfoMoneyGroup', 'Группа управленческих статей' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoneyGroup');

CREATE OR REPLACE FUNCTION zc_Object_JuridicalGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_JuridicalGroup', 'Группы юр. лиц' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalGroup');

CREATE OR REPLACE FUNCTION zc_Object_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Juridical', 'Юридические лица' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Juridical');

CREATE OR REPLACE FUNCTION zc_Object_MarginCategory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MarginCategory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MarginCategory', 'Категория наценки' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MarginCategory');

CREATE OR REPLACE FUNCTION zc_Object_MarginCategoryItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MarginCategoryItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MarginCategoryItem', 'Элемент категории наценки' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MarginCategoryItem');

CREATE OR REPLACE FUNCTION zc_Object_MarginCategoryLink() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MarginCategoryLink'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MarginCategoryLink', 'Связь категории наценки' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MarginCategoryLink');

CREATE OR REPLACE FUNCTION zc_Object_MarginReport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MarginReport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MarginReport', 'Категория наценки для отчета (Ценовая интервенция)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MarginReport');

CREATE OR REPLACE FUNCTION zc_Object_MarginReportItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MarginReportItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MarginReportItem', 'Элемент категории наценки для отчета (Ценовая интервенция)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MarginReportItem');


CREATE OR REPLACE FUNCTION zc_Object_Measure() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Measure'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Measure', 'Единицы измерения' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Measure');

CREATE OR REPLACE FUNCTION zc_Object_Member() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Member'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Member', 'Физические лица' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Member');

CREATE OR REPLACE FUNCTION zc_Object_MemberExternal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MemberExternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MemberExternal', 'Физические лица(сторонние)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MemberExternal');

CREATE OR REPLACE FUNCTION zc_Object_ModelService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ModelService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ModelService', 'Модели начисления' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ModelService');

CREATE OR REPLACE FUNCTION zc_Object_ModelServiceItemChild() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ModelServiceItemChild'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ModelServiceItemChild', 'Подчиненные элементы Модели начисления' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ModelServiceItemChild');

CREATE OR REPLACE FUNCTION zc_Object_ModelServiceItemMaster() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ModelServiceItemMaster'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ModelServiceItemMaster', 'Главные элементы Модели начисления' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ModelServiceItemMaster');

CREATE OR REPLACE FUNCTION zc_Object_ModelServiceKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ModelServiceKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ModelServiceKind', 'Типы модели начисления' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ModelServiceKind');

CREATE OR REPLACE FUNCTION zc_Object_OrderKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_OrderKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_OrderKind', 'Тип заказа' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_OrderKind');

CREATE OR REPLACE FUNCTION zc_Object_PaidKind() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PaidKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_PaidKind', 'Формы оплат' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PaidKind');

CREATE OR REPLACE FUNCTION zc_Object_Partner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Partner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Partner', 'Контрагенты' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Partner');

CREATE OR REPLACE FUNCTION zc_Object_PartnerTag() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PartnerTag'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_PartnerTag', 'Признак торговой точки' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PartnerTag');

CREATE OR REPLACE FUNCTION zc_Object_Personal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Personal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Personal', 'Сотрудники' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Personal');

CREATE OR REPLACE FUNCTION zc_Object_PersonalGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PersonalGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PersonalGroup', 'Группировки Сотрудников' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PersonalGroup');

CREATE OR REPLACE FUNCTION zc_Object_PersonalServiceList() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PersonalServiceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_PersonalServiceList', 'Ведомости начисления' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PersonalServiceList');

CREATE OR REPLACE FUNCTION zc_Object_Position() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Position'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Position', 'Должности' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Position');

CREATE OR REPLACE FUNCTION zc_Object_PositionLevel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PositionLevel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PositionLevel', 'Разряд должности' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PositionLevel');

CREATE OR REPLACE FUNCTION zc_Object_PriceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PriceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PriceList', 'Прайс-листы' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PriceList');

CREATE OR REPLACE FUNCTION zc_Object_PriceListItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PriceListItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PriceListItem', 'Цены прайс-листа' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PriceListItem');

CREATE OR REPLACE FUNCTION zc_Object_Process() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Process'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Process', 'Процессы' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Process');

CREATE OR REPLACE FUNCTION zc_Object_Program() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Program'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Program', 'Программы' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Program');

CREATE OR REPLACE FUNCTION zc_Object_ProfitLossGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLossGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ProfitLossGroup', 'Группы статей ОПиУ' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLossGroup');

CREATE OR REPLACE FUNCTION zc_Object_ProfitLossDirection() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLossDirection'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ProfitLossDirection', 'Аналитики статей ОПиУ - направления' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLossDirection');

CREATE OR REPLACE FUNCTION zc_Object_ProfitLoss() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLoss'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ProfitLoss', 'Статьи ОПиУ' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLoss');

CREATE OR REPLACE FUNCTION zc_Object_RateFuel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RateFuel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RateFuel', 'Нормы топлива' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RateFuel');

CREATE OR REPLACE FUNCTION zc_Object_RateFuelKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RateFuelKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RateFuelKind', 'Типы норм для топлива' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RateFuelKind');

CREATE OR REPLACE FUNCTION zc_object_receipt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_object_receipt'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_object_receipt', 'Рецептуры' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_object_receipt');

CREATE OR REPLACE FUNCTION zc_Object_ReceiptCost() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReceiptCost'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ReceiptCost', 'Затраты в рецептурах' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReceiptCost');

CREATE OR REPLACE FUNCTION zc_Object_ReceiptChild() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReceiptChild'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ReceiptChild', 'Составляющие рецептур' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReceiptChild');

CREATE OR REPLACE FUNCTION zc_object_receiptkind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_object_receiptkind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_object_receiptkind', 'Виды рецептур' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_object_receiptkind');

CREATE OR REPLACE FUNCTION zc_Object_RetailReport() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RetailReport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_RetailReport', 'Торговая сеть(отчет)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RetailReport');

CREATE OR REPLACE FUNCTION zc_Object_ReturnType() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReturnType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_ReturnType', 'Тип возврата' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReturnType');

CREATE OR REPLACE FUNCTION zc_Object_Role() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Role'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Role', 'Роли' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Role');

CREATE OR REPLACE FUNCTION zc_Object_RoleAction() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RoleAction'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RoleAction', 'Связь роли и команды вызова пунктов меню' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RoleAction');

CREATE OR REPLACE FUNCTION zc_Object_RoleProcessAccess() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RoleProcessAccess'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RoleProcessAccess', 'Связь ролей и процессов доступа' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RoleProcessAccess');

CREATE OR REPLACE FUNCTION zc_Object_RoleRight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RoleRight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RoleRight', 'Установка прав на роли' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RoleRight');

CREATE OR REPLACE FUNCTION zc_Object_Route() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Route'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Route', 'Маршруты' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Route');

CREATE OR REPLACE FUNCTION zc_Object_RouteKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RouteKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RouteKind', 'Типы маршрутов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RouteKind');

CREATE OR REPLACE FUNCTION zc_Object_RouteSorting() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RouteSorting'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RouteSorting', 'Сортировки маршрутов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RouteSorting');

CREATE OR REPLACE FUNCTION zc_Object_RouteMember() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RouteMember'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RouteMember', 'Маршруты(сотрудников)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RouteMember');


CREATE OR REPLACE FUNCTION zc_Object_SelectKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_SelectKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_SelectKind', 'Типы выбора данных' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_SelectKind');

CREATE OR REPLACE FUNCTION zc_Object_StaffList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StaffList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_StaffList', 'Штатное расписание' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StaffList');

CREATE OR REPLACE FUNCTION zc_Object_StaffListCost() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StaffListCost'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_StaffListCost', 'Расценки штатного расписания' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StaffListCost');

CREATE OR REPLACE FUNCTION zc_Object_StaffListSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StaffListSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_StaffListSumm', 'Cуммы для штатного расписания' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StaffListSumm');

CREATE OR REPLACE FUNCTION zc_Object_StaffListSummKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StaffListSummKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_StaffListSummKind', 'Типы сумм для штатного расписания' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StaffListSummKind');

CREATE OR REPLACE FUNCTION zc_Object_Status() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Status'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Status', 'Статусы документов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Status');

CREATE OR REPLACE FUNCTION zc_Object_TicketFuel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_TicketFuel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_TicketFuel', 'Талоны на топливо' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_TicketFuel');

CREATE OR REPLACE FUNCTION zc_Object_TradeMark() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_TradeMark'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_TradeMark', 'Торговые марки' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_TradeMark');

-- CREATE OR REPLACE FUNCTION zc_Object_UnitGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_UnitGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Unit', 'Подразделения' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Unit');

-- CREATE OR REPLACE FUNCTION zc_Object_AccountPlan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AccountPlan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_object_User() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_object_User'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_object_User', 'Пользователи' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_object_User');

CREATE OR REPLACE FUNCTION zc_Object_UserRole() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_UserRole'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_UserRole', 'Связь пользователей и ролей' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_UserRole');

CREATE OR REPLACE FUNCTION zc_Object_UserFormSettings() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_UserFormSettings'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_UserFormSettings', 'Пользовательские установки' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_UserFormSettings');

CREATE OR REPLACE FUNCTION zc_Object_WorkTimeKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_WorkTimeKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_WorkTimeKind', 'Типы рабочего времени' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_WorkTimeKind');

CREATE OR REPLACE FUNCTION zc_object_PartionMovement() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_object_PartionMovement'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_object_PartionMovement', 'Партии товаров' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_object_PartionMovement');

CREATE OR REPLACE FUNCTION zc_object_PartionMovementItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_object_PartionMovementItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_object_PartionMovementItem', 'Партии товаров' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_object_PartionMovementItem');

CREATE OR REPLACE FUNCTION zc_Object_DocumentTaxKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_DocumentTaxKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_DocumentTaxKind', 'Типы формирования налогового документа' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_DocumentTaxKind');

CREATE OR REPLACE FUNCTION zc_Object_Country() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Country'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Country', 'Страны' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Country');

CREATE OR REPLACE FUNCTION zc_Object_Maker() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Maker'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Maker', 'Производитель (ОС)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Maker');

CREATE OR REPLACE FUNCTION zc_Object_MakerReport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MakerReport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MakerReport', 'Исключения в отправке Маркет-отчетов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MakerReport');

-- CREATE OR REPLACE FUNCTION zc_Object_Document() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Document'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- INSERT INTO ObjectDesc (Code, ItemName)
--  SELECT 'zc_Object_Document', 'Справочник Документы' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Document');

CREATE OR REPLACE FUNCTION zc_Object_BonusKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_BonusKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_BonusKind', 'Виды бонусов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_BonusKind');

CREATE OR REPLACE FUNCTION zc_Object_ToolsWeighing() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ToolsWeighing'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ToolsWeighing', 'Настройки взвешивания' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ToolsWeighing');

CREATE OR REPLACE FUNCTION zc_Object_GoodsKindWeighing() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsKindWeighing'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsKindWeighing', 'Виды упаковки для взвешивания' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsKindWeighing');

CREATE OR REPLACE FUNCTION zc_Object_GoodsKindWeighingGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsKindWeighingGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsKindWeighingGroup', 'Группы видов упаковки для взвешивания' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsKindWeighingGroup');


CREATE OR REPLACE FUNCTION zc_Object_ContractTag() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractTag'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContractTag', 'Признак договора' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractTag');

CREATE OR REPLACE FUNCTION zc_Object_ContractTagGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractTagGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContractTagGroup', 'Группа Признака договора' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractTagGroup');



CREATE OR REPLACE FUNCTION zc_Object_ContractKey() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractKey'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContractKey', 'Ключ договора' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractKey');

CREATE OR REPLACE FUNCTION zc_Object_InvNumberTax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_InvNumberTax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_InvNumberTax', 'Налоговый номер' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_InvNumberTax');

CREATE OR REPLACE FUNCTION zc_Object_EDIStatus() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_EDIStatus'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_EDIStatus', 'Статусы документов EDI' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_EDIStatus');

CREATE OR REPLACE FUNCTION zc_Object_Retail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Retail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Retail', 'Торговая сеть' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Retail');

CREATE OR REPLACE FUNCTION zc_Object_Region() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Region'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Region', 'Область' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Region');

CREATE OR REPLACE FUNCTION zc_Object_Province() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Province'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Province', 'Район' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Province');


CREATE OR REPLACE FUNCTION zc_Object_CityKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CityKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CityKind', 'Вид населенного пункта' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CityKind');

CREATE OR REPLACE FUNCTION zc_Object_City() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_City'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_City', 'Населенный пункт' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_City');

CREATE OR REPLACE FUNCTION zc_Object_ProvinceCity() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ProvinceCity'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ProvinceCity', 'Район в населенном пункте' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ProvinceCity');

CREATE OR REPLACE FUNCTION zc_Object_StreetKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StreetKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_StreetKind', 'Вид(улица,проспект)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StreetKind');

CREATE OR REPLACE FUNCTION zc_Object_Street() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Street'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Street', 'Улица,проспект' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Street');

CREATE OR REPLACE FUNCTION zc_Object_EDIEvents() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_EDIEvents'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_EDIEvents', 'События EDI' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_EDIEvents');

CREATE OR REPLACE FUNCTION zc_Object_Storage() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Storage'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Storage', 'Места хранения' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Storage');

CREATE OR REPLACE FUNCTION zc_Object_ArticleLoss() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ArticleLoss'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ArticleLoss', 'Статьи списания' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ArticleLoss');

CREATE OR REPLACE FUNCTION zc_Object_Founder() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Founder'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Founder', 'Учредители' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Founder');

CREATE OR REPLACE FUNCTION zc_Object_GoodsGroupStat() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsGroupStat'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsGroupStat', 'Группы товаров(статистика)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsGroupStat');

CREATE OR REPLACE FUNCTION zc_Object_PersonalServiceList() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PersonalServiceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_PersonalServiceList', 'Ведомости начисления' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PersonalServiceList');

CREATE OR REPLACE FUNCTION zc_Object_RetailReport() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RetailReport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_RetailReport', 'Торговая сеть(отчет)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RetailReport');

CREATE OR REPLACE FUNCTION zc_Object_PartnerTag() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PartnerTag'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_PartnerTag', 'Признак торговой точки' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PartnerTag');

CREATE OR REPLACE FUNCTION zc_Object_GoodsQuality() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsQuality'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_GoodsQuality', 'Параметры качественного удостоверения' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsQuality');

CREATE OR REPLACE FUNCTION zc_Object_ContractPartner() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractPartner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_ContractPartner', 'Договора по контрагентам' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractPartner');

CREATE OR REPLACE FUNCTION zc_Object_ContractGoods() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractGoods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_ContractGoods', 'Договора по товарам' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractGoods');

CREATE OR REPLACE FUNCTION zc_Object_Quality() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Quality'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Quality', 'Качественное удостоверение' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Quality');

CREATE OR REPLACE FUNCTION zc_Object_OrderType() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_OrderType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_OrderType', 'Тип расчета заявки на производство' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_OrderType');

CREATE OR REPLACE FUNCTION zc_Object_ServiceDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ServiceDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ServiceDate', 'Месяца начислений' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ServiceDate');

CREATE OR REPLACE FUNCTION zc_Object_GoodsTag() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsTag'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsTag', 'Признак товара' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsTag');

CREATE OR REPLACE FUNCTION zc_Object_GoodsPlatform() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsPlatform'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsPlatform', 'Производственная площадка' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsPlatform');

CREATE OR REPLACE FUNCTION zc_Object_RouteGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RouteGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RouteGroup', 'Группа маршрута' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RouteGroup');

CREATE OR REPLACE FUNCTION zc_Object_PrintKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PrintKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PrintKind', 'Типы печати документа' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PrintKind');

CREATE OR REPLACE FUNCTION zc_Object_PrintKindItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PrintKindItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PrintKindItem', 'Элементы печати' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PrintKindItem');

CREATE OR REPLACE FUNCTION zc_Object_PromoKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PromoKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PromoKind', 'Виды акций' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PromoKind');

CREATE OR REPLACE FUNCTION zc_Object_PromoStateKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PromoStateKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PromoStateKind', 'Состояние Акции' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PromoStateKind');

CREATE OR REPLACE FUNCTION zc_Object_PromoTradeStateKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PromoTradeStateKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PromoTradeStateKind', 'Трейд-маркетинг' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PromoTradeStateKind');

CREATE OR REPLACE FUNCTION zc_Object_Advertising() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Advertising'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Advertising', 'Рекламная поддержка' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Advertising');

CREATE OR REPLACE FUNCTION zc_Object_ConditionPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ConditionPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ConditionPromo', 'Условия участия в акции' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ConditionPromo');

CREATE OR REPLACE FUNCTION zc_Object_ContractTermKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractTermKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContractTermKind', 'Типы пролонгаций договоров' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractTermKind');

CREATE OR REPLACE FUNCTION zc_Object_BranchJuridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_BranchJuridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_BranchJuridical', 'Дополнительный доступ филиалам' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_BranchJuridical');


CREATE OR REPLACE FUNCTION zc_Object_BranchPrintKindItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_BranchPrintKindItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_BranchPrintKindItem', 'Настройка печати по филиалам' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_BranchPrintKindItem');

CREATE OR REPLACE FUNCTION zc_Object_ExportKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ExportKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ExportKind', 'Типы экспорта для почты' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ExportKind');

CREATE OR REPLACE FUNCTION zc_Object_ExportJuridical() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ExportJuridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_ExportJuridical', 'Установки экспорта с отправкой по почте' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ExportJuridical');

CREATE OR REPLACE FUNCTION zc_object_reestrkind() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_object_reestrkind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_object_reestrkind', 'Типы состояния по реестру' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_object_reestrkind');

CREATE OR REPLACE FUNCTION zc_Object_NameBefore() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_NameBefore'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_NameBefore', 'Товар/ОС/работы (предварительное название)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_NameBefore');

CREATE OR REPLACE FUNCTION zc_Object_PartionRemains() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PartionRemains'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_PartionRemains', 'Партии МНМА, может быть и ОС, (остатки)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PartionRemains');

CREATE OR REPLACE FUNCTION zc_Object_PartionGoods() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PartionGoods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_PartionGoods', 'Партии товаров' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PartionGoods');


CREATE OR REPLACE FUNCTION zc_Object_SignInternal() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_SignInternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_SignInternal', 'Модель электронной подписи' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_SignInternal');

CREATE OR REPLACE FUNCTION zc_Object_SignInternalItem() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_SignInternalItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_SignInternalItem', 'Элементы моделей электронных подписей' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_SignInternalItem');

CREATE OR REPLACE FUNCTION zc_Object_MobileTariff() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MobileTariff'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
 SELECT 'zc_Object_MobileTariff', 'Tарифы мобильных операторов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MobileTariff');

CREATE OR REPLACE FUNCTION zc_Object_MobileEmployee() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MobileEmployee'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
 SELECT 'zc_Object_MobileEmployee', 'Мобильные телефоны сотрудников' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MobileEmployee');

CREATE OR REPLACE FUNCTION zc_Object_GoodsListSale() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsListSale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
 SELECT 'zc_Object_GoodsListSale', 'Товары в реализации покупателям' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsListSale');

CREATE OR REPLACE FUNCTION zc_Object_DayKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_DayKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_DayKind', 'Типы дней' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_DayKind');

CREATE OR REPLACE FUNCTION zc_Object_SheetWorkTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_SheetWorkTime'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_SheetWorkTime', 'Режим работы (Шаблон табеля рабочего времени)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_SheetWorkTime');

CREATE OR REPLACE FUNCTION zc_Object_ReportCollation() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReportCollation'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ReportCollation', 'Акт сверки' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReportCollation');

CREATE OR REPLACE FUNCTION zc_Object_PhotoMobile() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PhotoMobile'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PhotoMobile', 'Фотографии с мобильного устройства' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PhotoMobile');

CREATE OR REPLACE FUNCTION zc_Object_GoodsListIncome() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsListIncome'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
 SELECT 'zc_Object_GoodsListIncome', ' Товары для поставщика' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsListIncome');

CREATE OR REPLACE FUNCTION zc_Object_ReportExternal() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReportExternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_ReportExternal', 'Внешние отчеты' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReportExternal');

CREATE OR REPLACE FUNCTION zc_Object_StorageLine() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StorageLine'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_StorageLine', 'Линия производства' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StorageLine');

CREATE OR REPLACE FUNCTION zc_Object_MobileConst() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MobileConst'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_MobileConst', 'Константы для мобильного приложения' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MobileConst');

CREATE OR REPLACE FUNCTION zc_Object_Sticker() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Sticker'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Sticker', 'Этикетка' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Sticker');

CREATE OR REPLACE FUNCTION zc_Object_StickerGroup() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StickerGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_StickerGroup', 'Вид продукта (Группа)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StickerGroup');

CREATE OR REPLACE FUNCTION zc_Object_StickerType() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StickerType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_StickerType', 'Способ изготовления продукта' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StickerType');

CREATE OR REPLACE FUNCTION zc_Object_StickerTag() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StickerTag'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_StickerTag', 'Название продукта' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StickerTag');

CREATE OR REPLACE FUNCTION zc_Object_StickerSort() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StickerSort'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_StickerSort', 'Сортность продукта' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StickerSort');

CREATE OR REPLACE FUNCTION zc_Object_StickerNorm() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StickerNorm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_StickerNorm', 'ТУ или ДСТУ' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StickerNorm');

CREATE OR REPLACE FUNCTION zc_Object_StickerFile() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StickerFile'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_StickerFile', 'ШАБЛОН' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StickerFile');

CREATE OR REPLACE FUNCTION zc_Object_Language() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Language'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Language', 'Язык' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Language');

CREATE OR REPLACE FUNCTION zc_Object_StickerProperty() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StickerProperty'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_StickerProperty', 'Свойства этикетки' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StickerProperty');

CREATE OR REPLACE FUNCTION zc_Object_StickerSkin() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StickerSkin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_StickerSkin', 'Оболочка' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StickerSkin');

CREATE OR REPLACE FUNCTION zc_Object_StickerPack() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StickerPack'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_StickerPack', 'вид пакування' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StickerPack');

CREATE OR REPLACE FUNCTION zc_Object_GoodsReportSaleInf() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsReportSaleInf'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_GoodsReportSaleInf', 'Статистика продаж по дням недели (протокол)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsReportSaleInf');

CREATE OR REPLACE FUNCTION zc_Object_GoodsReportSale() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsReportSale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_GoodsReportSale', 'Статистика продаж по дням недели' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsReportSale');

CREATE OR REPLACE FUNCTION zc_Object_MemberSheetWorkTime() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MemberSheetWorkTime'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_MemberSheetWorkTime', 'Доступ к Табелю рабочего времени' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MemberSheetWorkTime');

CREATE OR REPLACE FUNCTION zc_Object_MemberPersonalServiceList() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MemberPersonalServiceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_MemberPersonalServiceList', 'Доступ к Ведомости начисления' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MemberPersonalServiceList');

CREATE OR REPLACE FUNCTION zc_Object_GoodsTypeKind() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsTypeKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_GoodsTypeKind', 'Категория товара' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsTypeKind');

CREATE OR REPLACE FUNCTION zc_Object_GoodsBrand() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsBrand'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_GoodsBrand', 'Бренд товара' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsBrand');

CREATE OR REPLACE FUNCTION zc_Object_OrderFinance() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_OrderFinance'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_OrderFinance', 'Виды Планирования платежей' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_OrderFinance');

CREATE OR REPLACE FUNCTION zc_Object_OrderFinanceProperty() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_OrderFinanceProperty'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_OrderFinanceProperty', 'Значения для Планирования платежей' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_OrderFinanceProperty');

CREATE OR REPLACE FUNCTION zc_Object_JuridicalOrderFinance() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalOrderFinance'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_JuridicalOrderFinance', 'Параметры Юр.лица в планировании платежей' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalOrderFinance');


CREATE OR REPLACE FUNCTION zc_Object_SubjectDoc() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_SubjectDoc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_SubjectDoc', 'Основание для перемещения' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_SubjectDoc');

CREATE OR REPLACE FUNCTION zc_Object_MemberMinus() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MemberMinus'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_MemberMinus', 'Удержания по сотрудникам' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MemberMinus');

CREATE OR REPLACE FUNCTION zc_Object_ReportBonus() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReportBonus'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_ReportBonus', 'Проверка начислений по бонусам' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReportBonus');

CREATE OR REPLACE FUNCTION zc_Object_MemberBranch() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MemberBranch'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_MemberBranch', 'Доступ к данным филиала' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MemberBranch');

CREATE OR REPLACE FUNCTION zc_Object_PartnerExternal() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PartnerExternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_PartnerExternal', 'Контрагенты внешние' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PartnerExternal');

CREATE OR REPLACE FUNCTION zc_Object_ContractTradeMark() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractTradeMark'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_ContractTradeMark', 'Торговые марки в договорах(Спецификация)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractTradeMark');

CREATE OR REPLACE FUNCTION zc_Object_AssetType() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AssetType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_AssetType', 'Тип (ОС)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AssetType');

CREATE OR REPLACE FUNCTION zc_Object_ContractConditionPartner() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractConditionPartner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_ContractConditionPartner', 'Контрагенты в условиях к договору' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractConditionPartner');



CREATE OR REPLACE FUNCTION zc_Object_PSLExportKind() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PSLExportKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_PSLExportKind', 'Типы выгрузки ведомости в банк' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PSLExportKind');

CREATE OR REPLACE FUNCTION zc_Object_ReturnKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReturnKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ReturnKind', 'Типы возврата' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReturnKind');

CREATE OR REPLACE FUNCTION zc_Object_Reason() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Reason'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Reason', 'Причина возврата' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Reason');

CREATE OR REPLACE FUNCTION zc_Object_MemberPriceList() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MemberPriceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_MemberPriceList', 'Доступ к Изменениям в Прайс листе' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MemberPriceList');

CREATE OR REPLACE FUNCTION zc_Object_FineSubject() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_FineSubject'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_FineSubject', 'Вид нарушения' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_FineSubject');

CREATE OR REPLACE FUNCTION zc_Object_ContractPriceList() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractPriceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_ContractPriceList', 'История Прайс-листов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractPriceList');

CREATE OR REPLACE FUNCTION zc_Object_OrderPeriodKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_OrderPeriodKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_OrderPeriodKind', 'Вид периода планирования' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_OrderPeriodKind');

CREATE OR REPLACE FUNCTION zc_Object_ReceiptLevel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReceiptLevel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ReceiptLevel', 'Этапы производства' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReceiptLevel');

CREATE OR REPLACE FUNCTION zc_Object_Reason() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Reason'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Reason', 'Причина возврата / перемещения' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Reason');

CREATE OR REPLACE FUNCTION zc_Object_ReturnDescKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReturnDescKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ReturnDescKind', 'Типы возврата' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReturnDescKind');

CREATE OR REPLACE FUNCTION zc_Object_MobilePack() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MobilePack'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MobilePack', 'Название пакета мобильного оператора' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MobilePack');

CREATE OR REPLACE FUNCTION zc_Object_SmsSettings() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_SmsSettings'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_SmsSettings', 'Установки для СМС' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_SmsSettings');

CREATE OR REPLACE FUNCTION zc_Object_MemberSkill() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MemberSkill'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MemberSkill', 'Квалификация' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MemberSkill');

CREATE OR REPLACE FUNCTION zc_Object_Gender() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Gender'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Gender', 'Пол' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Gender');

CREATE OR REPLACE FUNCTION zc_Object_JobSource() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_JobSource'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_JobSource', 'Источник информации о вакансии' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_JobSource');

CREATE OR REPLACE FUNCTION zc_Object_ReasonOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReasonOut'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ReasonOut', 'Причина увольнения' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReasonOut');

CREATE OR REPLACE FUNCTION zc_Object_PairDay() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PairDay'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PairDay', 'Вид смены' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PairDay');


CREATE OR REPLACE FUNCTION zc_Object_JuridicalDefermentPayment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalDefermentPayment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_JuridicalDefermentPayment', 'Последние оплаты' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalDefermentPayment');

CREATE OR REPLACE FUNCTION zc_Object_CardFuelKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CardFuelKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CardFuelKind', 'Статус Топливные карты' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CardFuelKind');

CREATE OR REPLACE FUNCTION zc_Object_UserByGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_UserByGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_UserByGroup', 'Группировки пользователей' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_UserByGroup');

CREATE OR REPLACE FUNCTION zc_Object_UserByGroupList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_UserByGroupList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_UserByGroupList', 'Элементы группировки пользователей' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_UserByGroupList');

CREATE OR REPLACE FUNCTION zc_Object_CarInfo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CarInfo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CarInfo', 'Талоны на топливо' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CarInfo');

CREATE OR REPLACE FUNCTION zc_Object_OrderCarInfo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_OrderCarInfo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_OrderCarInfo', 'График отгрузки' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_OrderCarInfo');

CREATE OR REPLACE FUNCTION zc_Object_StickerHeader() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StickerHeader'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_StickerHeader', 'Заголовок для сети' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StickerHeader');

 CREATE OR REPLACE FUNCTION zc_Object_TelegramGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_TelegramGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_TelegramGroup', 'Группа телеграм' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_TelegramGroup');

 CREATE OR REPLACE FUNCTION zc_Object_Section() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Section'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Section', 'Сегмент' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Section');
 

 CREATE OR REPLACE FUNCTION zc_Object_MemberReport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MemberReport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MemberReport', 'Доступ к Просмотру Отчетов по подразделениям' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MemberReport');

 
 CREATE OR REPLACE FUNCTION zc_Object_GoodsKindNew() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsKindNew'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsKindNew', 'Виды товаров (НОВЫЕ)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsKindNew');

 CREATE OR REPLACE FUNCTION zc_Object_TransportKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_TransportKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_TransportKind', 'Вид перевозок' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_TransportKind');
 
 CREATE OR REPLACE FUNCTION zc_Object_AreaUnit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AreaUnit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AreaUnit', 'Участок(Места хранения)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AreaUnit');
 

 CREATE OR REPLACE FUNCTION zc_Object_PartionModel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PartionModel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PartionModel', 'Модель (Партия учета)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PartionModel');
 
 CREATE OR REPLACE FUNCTION zc_Object_CarType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CarType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CarType', 'Модель автомобиля' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CarType');

 CREATE OR REPLACE FUNCTION zc_Object_BodyType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_BodyType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_BodyType', 'Тип кузова' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_BodyType');
 
 CREATE OR REPLACE FUNCTION zc_Object_CarProperty() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CarProperty'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CarProperty', 'Тип авто' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CarProperty');
     
  CREATE OR REPLACE FUNCTION zc_Object_ObjectColor() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ObjectColor'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ObjectColor', 'Цвет авто' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ObjectColor');
 
  CREATE OR REPLACE FUNCTION zc_Object_GoodsGroupProperty() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsGroupProperty'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsGroupProperty', 'Аналитический классификатор' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsGroupProperty');
 
  CREATE OR REPLACE FUNCTION zc_Object_PartionCell() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PartionCell'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PartionCell', 'Ячейка хранения (Партия учета)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PartionCell');
 
 
  CREATE OR REPLACE FUNCTION zc_Object_GoodsByGoodsKindPeresort() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsByGoodsKindPeresort'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsByGoodsKindPeresort', 'Разрешенные пересорты товара+вид товара' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsByGoodsKindPeresort');
 
  CREATE OR REPLACE FUNCTION zc_Object_ViewPriceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ViewPriceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ViewPriceList', 'Доступ к просмотру Прайс листа' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ViewPriceList');
 
  CREATE OR REPLACE FUNCTION zc_Object_ChoiceCell() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ChoiceCell'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ChoiceCell', 'Ячейка отбора' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ChoiceCell');
  
  CREATE OR REPLACE FUNCTION zc_Object_GoodsNormDiff() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsNormDiff'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsNormDiff', 'Нормы отклонений' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsNormDiff');
       
  CREATE OR REPLACE FUNCTION zc_Object_GoodsGroupDirection() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsGroupDirection'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsGroupDirection', 'Аналитическая группа Направление' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsGroupDirection');

  CREATE OR REPLACE FUNCTION zc_Object_PromoItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PromoItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PromoItem', 'Статья затрат' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PromoItem');
 
  CREATE OR REPLACE FUNCTION zc_Object_RouteNum() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RouteNum'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RouteNum', 'Маршрутка' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RouteNum');
        
  CREATE OR REPLACE FUNCTION zc_Object_PositionProperty() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PositionProperty'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PositionProperty', 'Классификатор должности' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PositionProperty');

  CREATE OR REPLACE FUNCTION zc_Object_SiteTag() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_SiteTag'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_SiteTag', 'Категория сайт' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_SiteTag');

  CREATE OR REPLACE FUNCTION zc_Object_UnitPeresort() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_UnitPeresort'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_UnitPeresort', 'Автопересорт по складам' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_UnitPeresort');

  CREATE OR REPLACE FUNCTION zc_Object_MessagePersonalService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MessagePersonalService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MessagePersonalService', 'Сообщения по Авто начислению ЗП' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MessagePersonalService');

 





--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--!!! Аптека


CREATE OR REPLACE FUNCTION zc_Object_FileTypeKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_FileTypeKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_FileTypeKind', 'Типы файла' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_FileTypeKind');

CREATE OR REPLACE FUNCTION zc_Object_JuridicalSettings() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalSettings'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_JuridicalSettings', 'Установки для юр. лиц' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalSettings');

CREATE OR REPLACE FUNCTION zc_Object_JuridicalSettingsItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalSettingsItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_JuridicalSettingsItem', 'Элемент Установки для юр. лиц' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalSettingsItem');


CREATE OR REPLACE FUNCTION zc_Object_LinkGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_LinkGoods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_LinkGoods', '' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_LinkGoods');

CREATE OR REPLACE FUNCTION zc_Object_NDSKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_NDSKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_NDSKind', 'Виды НДС' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_NDSKind');

CREATE OR REPLACE FUNCTION zc_Object_PriceGroupSettings() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PriceGroupSettings'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PriceGroupSettings', 'Установки для ценовых групп' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PriceGroupSettings');

CREATE OR REPLACE FUNCTION zc_Object_PriceGroupSettingsTOP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PriceGroupSettingsTOP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PriceGroupSettingsTOP', 'Установки для ценовых групп ТОП' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PriceGroupSettingsTOP');

CREATE OR REPLACE FUNCTION zc_Object_MedocLoadInfo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MedocLoadInfo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MedocLoadInfo', 'Информация о загрузках их медка' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MedocLoadInfo');

CREATE OR REPLACE FUNCTION zc_Object_Price() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Price'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Price', 'Цена реализации' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Price');

CREATE OR REPLACE FUNCTION zc_Object_AlternativeGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AlternativeGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AlternativeGroup', 'Группы альтернатив' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AlternativeGroup');

CREATE OR REPLACE FUNCTION zc_Object_PaidType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PaidType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PaidType', 'Типы оплат' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PaidType');

CREATE OR REPLACE FUNCTION zc_Object_ReportSoldParams() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReportSoldParams'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ReportSoldParams', 'Параметры отчета по плану продаж' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReportSoldParams');

CREATE OR REPLACE FUNCTION zc_Object_ReportPromoParams() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReportPromoParams'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ReportPromoParams', 'Параметры отчета по плану маркетинга' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReportPromoParams');

CREATE OR REPLACE FUNCTION zc_Object_AdditionalGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AdditionalGoods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AdditionalGoods', 'Дополнительные товары' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AdditionalGoods');

CREATE OR REPLACE FUNCTION zc_Object_Appointment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Appointment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Appointment', 'Назначение товара' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Appointment');

CREATE OR REPLACE FUNCTION zc_Object_ReasonDifferences() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReasonDifferences'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ReasonDifferences', 'Назначение товара' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReasonDifferences');

CREATE OR REPLACE FUNCTION zc_Object_ChangeIncomePaymentKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ChangeIncomePaymentKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ChangeIncomePaymentKind', 'Виды корректировок долга приходных окументов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ChangeIncomePaymentKind');

CREATE OR REPLACE FUNCTION zc_Object_Education() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Education'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Education', 'Специальности' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Education');


CREATE OR REPLACE FUNCTION zc_Object_EmailTools() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_EmailTools'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_EmailTools', 'Параметры установок для почты' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_EmailTools');

CREATE OR REPLACE FUNCTION zc_Object_EmailKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_EmailKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_EmailKind', 'Типы установок для почты' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_EmailKind');
-- UPDATE  ObjectDesc SET ItemName = 'Вид почты' WHERE Id = zc_Object_EmailKind()   --  для проджекта

CREATE OR REPLACE FUNCTION zc_Object_EmailSettings() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_EmailSettings'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_EmailSettings', 'Установки для почты' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_EmailSettings');

CREATE OR REPLACE FUNCTION zc_Object_Email() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Email'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Email', 'Почтовый ящик' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Email');

CREATE OR REPLACE FUNCTION zc_Object_DocumentKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_DocumentKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_DocumentKind', 'Типы документов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_DocumentKind');

CREATE OR REPLACE FUNCTION zc_Object_OverSettings() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_OverSettings'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_OverSettings', 'Установки для формирования документа по излишкам' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_OverSettings');

CREATE OR REPLACE FUNCTION zc_Object_BarCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_BarCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_BarCode', 'Штрих-коды товаров' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_BarCode');

CREATE OR REPLACE FUNCTION zc_Object_DiscountExternal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_DiscountExternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_DiscountExternal', 'Проекты (дисконтные карты)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_DiscountExternal');

CREATE OR REPLACE FUNCTION zc_Object_DiscountExternalTools() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_DiscountExternalTools'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_DiscountExternalTools', 'Настройки Проектов (дисконтные карты)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_DiscountExternalTools');

CREATE OR REPLACE FUNCTION zc_Object_DiscountExternalJuridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_DiscountExternalJuridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_DiscountExternalJuridical', 'Настройки Проектов (дисконтные карты, юридические лица)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_DiscountExternalJuridical');

CREATE OR REPLACE FUNCTION zc_Object_DiscountCard() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_DiscountCard'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_DiscountCard', 'Дисконтные карты' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_DiscountCard');

CREATE OR REPLACE FUNCTION zc_Object_ConfirmedKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ConfirmedKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ConfirmedKind', 'Статус заказа' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ConfirmedKind');

CREATE OR REPLACE FUNCTION zc_Object_OrderShedule() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_OrderShedule'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_OrderShedule', 'График заказа/доставки' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_OrderShedule');

CREATE OR REPLACE FUNCTION zc_Object_ContractSettings() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractSettings'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ContractSettings', 'Установки для договоров' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ContractSettings');

CREATE OR REPLACE FUNCTION zc_Object_BrandSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_BrandSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_BrandSP', 'Торговельна назва лікарського засобу (Соц. проект)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_BrandSP');

CREATE OR REPLACE FUNCTION zc_Object_IntenalSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_IntenalSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_IntenalSP', 'Міжнародна непатентована назва (Соц. проект)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_IntenalSP');

CREATE OR REPLACE FUNCTION zc_Object_KindOutSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_KindOutSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_KindOutSP', 'Форма випуску (Соц. проект)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_KindOutSP');

CREATE OR REPLACE FUNCTION zc_Object_PartnerMedical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PartnerMedical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PartnerMedical', 'Медицинское учреждение' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PartnerMedical');

CREATE OR REPLACE FUNCTION zc_Object_ConditionsKeep() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ConditionsKeep'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ConditionsKeep', 'Условия хранения' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ConditionsKeep');

CREATE OR REPLACE FUNCTION zc_Object_GroupMemberSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GroupMemberSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GroupMemberSP', 'Категория пациента(Соц. проект)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GroupMemberSP');

CREATE OR REPLACE FUNCTION zc_Object_MemberSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MemberSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MemberSP', 'ФИО пациента(Соц. проект)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MemberSP');

CREATE OR REPLACE FUNCTION zc_Object_MedicSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MedicSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MedicSP', 'ФИО врача(Соц. проект)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MedicSP');

CREATE OR REPLACE FUNCTION zc_Object_SPKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_SPKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_SPKind', 'Виды соц.проектов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_SPKind');

CREATE OR REPLACE FUNCTION zc_Object_MemberIncomeCheck() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MemberIncomeCheck'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MemberIncomeCheck', 'Фио Уполномоченных лиц' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MemberIncomeCheck');

CREATE OR REPLACE FUNCTION zc_Object_JuridicalArea() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalArea'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_JuridicalArea', 'Регион поставщика' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalArea');

CREATE OR REPLACE FUNCTION zc_Object_DataExcel() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_DataExcel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_DataExcel', 'временны данные из экселя' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_DataExcel');

CREATE OR REPLACE FUNCTION zc_Object_PromoCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PromoCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PromoCode', 'ПРОМО КОД (Название акции)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PromoCode');

CREATE OR REPLACE FUNCTION zc_Object_Fiscal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Fiscal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Fiscal', 'Кассовый аппарат' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Fiscal');

CREATE OR REPLACE FUNCTION zc_Object_UnitCategory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_UnitCategory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_UnitCategory', 'Категория подразделения' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_UnitCategory');

CREATE OR REPLACE FUNCTION zc_Object_Address() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Address'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Address', 'Адрес' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Address');

CREATE OR REPLACE FUNCTION zc_Object_JuridicalLegalAddress() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalLegalAddress'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_JuridicalLegalAddress', 'Юридический адрес поставщика' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalLegalAddress');

CREATE OR REPLACE FUNCTION zc_Object_JuridicalActualAddress() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalActualAddress'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_JuridicalActualAddress', 'Фактический адрес поставщика' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalActualAddress');

CREATE OR REPLACE FUNCTION zc_Object_GoodsPropertyBox() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsPropertyBox'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsPropertyBox', 'Cвойства товаров для ящиков' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsPropertyBox');

CREATE OR REPLACE FUNCTION zc_Object_PriceChange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PriceChange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PriceChange', 'Справочник Элемент цены СО СКИДКОЙ' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PriceChange');

CREATE OR REPLACE FUNCTION zc_Object_Accommodation() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Accommodation'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Accommodation', 'Размещение товара' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Accommodation');

CREATE OR REPLACE FUNCTION zc_Object_Overdraft() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Overdraft'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Overdraft', 'Овердрафт отчета ликвидности' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Overdraft');

CREATE OR REPLACE FUNCTION zc_Object_Exchange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Exchange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Exchange', 'Одиниці виміру' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Exchange');

CREATE OR REPLACE FUNCTION zc_Object_ClientsByBank() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ClientsByBank'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ClientsByBank', 'Клиенты по безналу' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ClientsByBank');

CREATE OR REPLACE FUNCTION zc_Object_GoodsSeparate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsSeparate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsSeparate', 'Товары в Производстве-разделении' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsSeparate');

CREATE OR REPLACE FUNCTION zc_Object_RepriceUnitSheduler() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RepriceUnitSheduler'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RepriceUnitSheduler', 'Планировщик переоценок' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RepriceUnitSheduler');

CREATE OR REPLACE FUNCTION zc_Object_DiffKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_DiffKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_DiffKind', 'Вид отказа' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_DiffKind');

CREATE OR REPLACE FUNCTION zc_Object_RecalcMCSSheduler() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RecalcMCSSheduler'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RecalcMCSSheduler', 'Планировщик перещета НТЗ' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RecalcMCSSheduler');

CREATE OR REPLACE FUNCTION zc_Object_SettingsService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_SettingsService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_SettingsService', 'Ограничение на просмотр журнала услуг' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_SettingsService');

CREATE OR REPLACE FUNCTION zc_Object_SettingsServiceItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_SettingsServiceItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_SettingsServiceItem', 'Ограничение на просмотр журнала услуг (элементы)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_SettingsServiceItem');

CREATE OR REPLACE FUNCTION zc_Object_GoodsCategory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsCategory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsCategory', 'Ассортиментная матрица(Категории)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsCategory');

CREATE OR REPLACE FUNCTION zc_Object_BankPOSTerminal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_BankPOSTerminal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_BankPOSTerminal', 'Банки предоставляющие POS терминалы' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_BankPOSTerminal');

CREATE OR REPLACE FUNCTION zc_Object_TaxUnit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_TaxUnit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_TaxUnit', 'Наценки для ночных цен' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_TaxUnit');

CREATE OR REPLACE FUNCTION zc_Object_UnitBankPOSTerminal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_UnitBankPOSTerminal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_UnitBankPOSTerminal', 'Связь подразделения и банков POS терминалов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_UnitBankPOSTerminal');

CREATE OR REPLACE FUNCTION zc_Object_JackdawsChecks() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_JackdawsChecks'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_JackdawsChecks', 'Типы галок для чеков' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_JackdawsChecks');

CREATE OR REPLACE FUNCTION zc_Object_GoodsAnalog() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsAnalog'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsAnalog', 'Аналоги товара' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsAnalog');

CREATE OR REPLACE FUNCTION zc_Object_PartionDateKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PartionDateKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PartionDateKind', 'Типы срок/не срок' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PartionDateKind');

CREATE OR REPLACE FUNCTION zc_Object_RetailCostCredit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RetailCostCredit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RetailCostCredit', 'Стоимость кредитных средств по сетям' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RetailCostCredit');

CREATE OR REPLACE FUNCTION zc_Object_HelsiEnum() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_HelsiEnum'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_HelsiEnum', 'Настройки доступа к сайту Хелси' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_HelsiEnum');

CREATE OR REPLACE FUNCTION zc_Object_CreditLimitJuridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CreditLimitJuridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CreditLimitJuridical', 'Кредитный лимит по дистрибьютору' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CreditLimitJuridical');

CREATE OR REPLACE FUNCTION zc_Object_GoodsGroupPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsGroupPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsGroupPromo', 'Группы товаров для маркетинга' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsGroupPromo');

CREATE OR REPLACE FUNCTION zc_Object_Driver() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Driver'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Driver', 'Водители' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Driver');

CREATE OR REPLACE FUNCTION zc_Object_PayrollType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PayrollType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PayrollType', 'Типы расчета заработной платы' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PayrollType');

CREATE OR REPLACE FUNCTION zc_Object_PayrollGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PayrollGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PayrollGroup', 'Группы расчета заработной платы' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PayrollGroup');

CREATE OR REPLACE FUNCTION zc_Object_LabSample() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_LabSample'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_LabSample', 'Название исследования (образца)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_LabSample');

CREATE OR REPLACE FUNCTION zc_Object_LabProduct() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_LabProduct'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_LabProduct', 'Продукт исследования (информативно)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_LabProduct');


CREATE OR REPLACE FUNCTION zc_Object_LabMark() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_LabMark'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_LabMark', 'Название показателя (вид исследования)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_LabMark');

CREATE OR REPLACE FUNCTION zc_Object_LabReceiptChild() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_LabReceiptChild'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_LabReceiptChild', 'Нормы для исследования' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_LabReceiptChild');

CREATE OR REPLACE FUNCTION zc_Object_GoodsReprice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsReprice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsReprice', 'Товары с блокировкой переоценки в минус' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsReprice');

CREATE OR REPLACE FUNCTION zc_Object_CashSettings() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CashSettings'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CashSettings', 'Общие настройки касс' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CashSettings');

CREATE OR REPLACE FUNCTION zc_Object_Buyer() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Buyer'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Buyer', 'Покупатели' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Buyer');

CREATE OR REPLACE FUNCTION zc_Object_PlanIventory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PlanIventory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PlanIventory', 'График инвентаризаций' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PlanIventory');

CREATE OR REPLACE FUNCTION zc_Object_MemberBankAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MemberBankAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MemberBankAccount', 'Доступ к Просмотру Расчетных счетов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MemberBankAccount');

CREATE OR REPLACE FUNCTION zc_Object_CommentTR() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CommentTR'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CommentTR', 'Комментарий строк технического переучета' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CommentTR');

CREATE OR REPLACE FUNCTION zc_Object_DriverSun() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_DriverSun'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_DriverSun', 'Водители СУН' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_DriverSun');

CREATE OR REPLACE FUNCTION zc_Object_SeasonalityCoefficient() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_SeasonalityCoefficient'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_SeasonalityCoefficient', 'Коэффициента сезонности' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_SeasonalityCoefficient');

CREATE OR REPLACE FUNCTION zc_Object_SunExclusion() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_SunExclusion'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_SunExclusion', 'Исключения для СУН' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_SunExclusion');

CREATE OR REPLACE FUNCTION zc_Object_Hardware() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Hardware'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Hardware', 'Аппаратная часть' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Hardware');


CREATE OR REPLACE FUNCTION zc_Object_CheckSourceKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CheckSourceKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CheckSourceKind', 'Источник чека' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CheckSourceKind');


CREATE OR REPLACE FUNCTION zc_Object_CashFlow() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CashFlow'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CashFlow', 'Статьи отчета ДДС' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CashFlow');

CREATE OR REPLACE FUNCTION zc_Object_HouseholdInventory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_HouseholdInventory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_HouseholdInventory', 'Хозяйственный инвентарь' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_HouseholdInventory');

CREATE OR REPLACE FUNCTION zc_Object_PartionHouseholdInventory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PartionHouseholdInventory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PartionHouseholdInventory', 'Партии хозяйственного инвентаря' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PartionHouseholdInventory');

CREATE OR REPLACE FUNCTION zc_Object_ComputerAccessories() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ComputerAccessories'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ComputerAccessories', 'Компьютерные аксессуары' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ComputerAccessories');

CREATE OR REPLACE FUNCTION zc_Object_DivisionParties() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_DivisionParties'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_DivisionParties', 'Разделение партий в кассе для продажи' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_DivisionParties');

CREATE OR REPLACE FUNCTION zc_Object_CommentSend() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CommentSend'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CommentSend', 'Комментарий строк перемещений по СУН' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CommentSend');

CREATE OR REPLACE FUNCTION zc_Object_JuridicalPriorities() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalPriorities'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_JuridicalPriorities', 'Приоритеты при выборе поставщика' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalPriorities');

CREATE OR REPLACE FUNCTION zc_Object_Layout() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Layout'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Layout', 'Название выкладки' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Layout');

CREATE OR REPLACE FUNCTION zc_Object_CancelReason() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CancelReason'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CancelReason', 'Причина отказа для сайта' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CancelReason');

CREATE OR REPLACE FUNCTION zc_Object_BuyerForSale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_BuyerForSale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_BuyerForSale', 'ФИО покупателя (на продажу)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_BuyerForSale');

CREATE OR REPLACE FUNCTION zc_Object_MedicForSale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MedicForSale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MedicForSale', 'ФИО врача (на продажу)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MedicForSale');

CREATE OR REPLACE FUNCTION zc_Object_AmbulantClinicSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AmbulantClinicSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AmbulantClinicSP', 'Амбулатория (Соц. проект)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AmbulantClinicSP');

CREATE OR REPLACE FUNCTION zc_Object_InstructionsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_InstructionsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_InstructionsKind', 'Разделы инструкций' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_InstructionsKind');

CREATE OR REPLACE FUNCTION zc_Object_Instructions() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Instructions'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Instructions', 'Инструкции' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Instructions');

CREATE OR REPLACE FUNCTION zc_Object_MemberKashtan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MemberKashtan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MemberKashtan', 'ФИО пациента (МИС «Каштан»)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MemberKashtan');

CREATE OR REPLACE FUNCTION zc_Object_MedicKashtan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MedicKashtan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MedicKashtan', 'ФИО врача (МИС «Каштан»)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MedicKashtan');

CREATE OR REPLACE FUNCTION zc_Object_DiscountExternalSupplier() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_DiscountExternalSupplier'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_DiscountExternalSupplier', 'Поставщики для проектов дисконтных карт' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_DiscountExternalSupplier');

CREATE OR REPLACE FUNCTION zc_Object_FinalSUAProtocol() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_FinalSUAProtocol'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_FinalSUAProtocol', 'Протокол формирований по СУА' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_FinalSUAProtocol');

CREATE OR REPLACE FUNCTION zc_Object_ScaleCalcMarketingPlan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ScaleCalcMarketingPlan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ScaleCalcMarketingPlan', 'Шкала расчета премии/штрафы в план по маркетингу' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ScaleCalcMarketingPlan');

CREATE OR REPLACE FUNCTION zc_Object_BuyerForSite() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_BuyerForSite'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_BuyerForSite', 'Покупателя сайта "Не болей"' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_BuyerForSite');

CREATE OR REPLACE FUNCTION zc_Object_PriceSite() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PriceSite'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PriceSite', 'Элемент цены для сайта (цена для заказа на сайте)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PriceSite');

CREATE OR REPLACE FUNCTION zc_Object_GoodsDivisionLock() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsDivisionLock'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsDivisionLock', 'Блокировка деления товара по подразделениям' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsDivisionLock');

CREATE OR REPLACE FUNCTION zc_Object_MethodsAssortment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MethodsAssortment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MethodsAssortment', 'Методы выбора аптек ассортимента' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MethodsAssortment');

CREATE OR REPLACE FUNCTION zc_Object_CorrectMinAmount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CorrectMinAmount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CorrectMinAmount', 'Методы выбора аптек ассортимента' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CorrectMinAmount');

CREATE OR REPLACE FUNCTION zc_Object_CheckoutTesting() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CheckoutTesting'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CheckoutTesting', 'Тестированние касс' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CheckoutTesting');

CREATE OR REPLACE FUNCTION zc_Object_TopicsTestingTuning() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_TopicsTestingTuning'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_TopicsTestingTuning', 'Темы тестирования сотрудников' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_TopicsTestingTuning');

CREATE OR REPLACE FUNCTION zc_Object_ZReportLog() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ZReportLog'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ZReportLog', 'Информация по Z отчетам' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ZReportLog');

CREATE OR REPLACE FUNCTION zc_Object_PayrollTypeVIP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PayrollTypeVIP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PayrollTypeVIP', 'Типы расчета заработной платы ВИП менеджеров' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PayrollTypeVIP');

CREATE OR REPLACE FUNCTION zc_Object_InsuranceCompanies() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_InsuranceCompanies'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_InsuranceCompanies', 'Страховые компании' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_InsuranceCompanies');

CREATE OR REPLACE FUNCTION zc_Object_MemberIC() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MemberIC'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MemberIC', 'ФИО покупателя (Страховой компании)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MemberIC');

CREATE OR REPLACE FUNCTION zc_Object_CorrectWagesPercentage() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CorrectWagesPercentage'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CorrectWagesPercentage', 'Корректировочный процент при расчете ЗП по сотруднику' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CorrectWagesPercentage');

CREATE OR REPLACE FUNCTION zc_Object_FormDispensing() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_FormDispensing'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_FormDispensing', 'Форма отпуска' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_FormDispensing');

CREATE OR REPLACE FUNCTION zc_Object_MedicalProgramSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MedicalProgramSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MedicalProgramSP', 'Медицинские программы соц. проектов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MedicalProgramSP');

CREATE OR REPLACE FUNCTION zc_Object_MedicalProgramSPLink() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MedicalProgramSPLink'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MedicalProgramSPLink', 'Связь медицинских программы соц. проектов и подразделений' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MedicalProgramSPLink');

CREATE OR REPLACE FUNCTION zc_Object_BanCommentSend() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_BanCommentSend'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_BanCommentSend', 'Запрет комментарий в перемещениях по подразделениям' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_BanCommentSend');

CREATE OR REPLACE FUNCTION zc_Object_Category1303() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Category1303'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Category1303', 'Группы населения по постановлению КМУ 1303' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Category1303');

CREATE OR REPLACE FUNCTION zc_Object_GroupMedicalProgramSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GroupMedicalProgramSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GroupMedicalProgramSP', 'Группы медицинских программ соц. проектов' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GroupMedicalProgramSP');

CREATE OR REPLACE FUNCTION zc_Object_SurchargeWages() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_SurchargeWages'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_SurchargeWages', 'Доплаты сотрудникам в ЗП' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_SurchargeWages');

CREATE OR REPLACE FUNCTION zc_Object_PickUpLogsAndDBF() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PickUpLogsAndDBF'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PickUpLogsAndDBF', 'Забрать логи и ДБФ' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PickUpLogsAndDBF');

CREATE OR REPLACE FUNCTION zc_Object_ExchangeRates() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ExchangeRates'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ExchangeRates', 'Курсы валют' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ExchangeRates');

CREATE OR REPLACE FUNCTION  zc_Object_Competitor() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Competitor'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Competitor', 'Конкуренты' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Competitor');

CREATE OR REPLACE FUNCTION zc_Object_KindOutSP_1303() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_KindOutSP_1303'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_KindOutSP_1303', 'Форма випуску (Соц. проект)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_KindOutSP_1303');

CREATE OR REPLACE FUNCTION zc_Object_Dosage_1303() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Dosage_1303'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Dosage_1303', 'Дозування (Соц. проект)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Dosage_1303');

CREATE OR REPLACE FUNCTION zc_Object_CountSP_1303() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CountSP_1303'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CountSP_1303', 'Кількість таблеток в упаковці (Соц. проект)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CountSP_1303');

CREATE OR REPLACE FUNCTION zc_Object_MakerSP_1303() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MakerSP_1303'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MakerSP_1303', 'Назва виробника (Соц. проект)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MakerSP_1303');

CREATE OR REPLACE FUNCTION zc_Object_Country_1303() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Country_1303'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Country_1303', 'Країна (Соц. проект)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Country_1303');

CREATE OR REPLACE FUNCTION zc_Object_DiffKindPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_DiffKindPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_DiffKindPrice', 'Вид отказов ограничения от цены' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_DiffKindPrice');

CREATE OR REPLACE FUNCTION zc_Object_MCRequest() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MCRequest'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MCRequest', 'Запрос на изменение категории наценки' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MCRequest');

CREATE OR REPLACE FUNCTION zc_Object_MCRequestItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MCRequestItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MCRequestItem', 'Элемент запроса на изменение категории наценки' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MCRequestItem');
    
CREATE OR REPLACE FUNCTION zc_Object_IntenalSP_1303() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_IntenalSP_1303'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_IntenalSP_1303', 'Міжнародна непатентована або загальноприйнята назва лікарського засобу (Соц. проект)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_IntenalSP_1303');
    
CREATE OR REPLACE FUNCTION zc_Object_MakerCountrySP_1303() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_MakerCountrySP_1303'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_MakerCountrySP_1303', 'Найменування виробника, країна (Соц. проект)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_MakerCountrySP_1303');

CREATE OR REPLACE FUNCTION zc_Object_GoodsWhoCan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsWhoCan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsWhoCan', 'Кому можно' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsWhoCan');

CREATE OR REPLACE FUNCTION zc_Object_GoodsMethodAppl() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsMethodAppl'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsMethodAppl', 'Способ применения' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsMethodAppl');

CREATE OR REPLACE FUNCTION zc_Object_GoodsSignOrigin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsSignOrigin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsSignOrigin', 'Признак происхождения' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsSignOrigin');    

CREATE OR REPLACE FUNCTION zc_Object_InternetRepair() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_InternetRepair'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_InternetRepair', 'Ремонт интернет' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_InternetRepair');    

CREATE OR REPLACE FUNCTION zc_Object_PartionDateWages() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PartionDateWages'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PartionDateWages', 'Коэффищиенты при продаже сроковых товаров в ЗП кассиров' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PartionDateWages');    

CREATE OR REPLACE FUNCTION zc_Object_AccountSalesDE() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AccountSalesDE'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AccountSalesDE', 'Счета с суммами для продаж по дисконтным проектам' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AccountSalesDE');    

CREATE OR REPLACE FUNCTION zc_Object_CommentCheck() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CommentCheck'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CommentCheck', 'Комментарий строк в заказах' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CommentCheck');    

CREATE OR REPLACE FUNCTION zc_Object_StoredProcExternal() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_StoredProcExternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_StoredProcExternal', 'Внешние процедуры' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_StoredProcExternal');

CREATE OR REPLACE FUNCTION zc_Object_UKTZED() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_UKTZED'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_UKTZED', 'Коды УКТВЭД' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_UKTZED');

--------------------------- !!!!!!!!!!!!!!!!!!!!!!!!!
--------------------------- !!! ВРЕМЕННЫЕ ОБЪЕКТЫ !!!
--------------------------- !!!!!!!!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_Object_Partner1CLink() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Partner1CLink'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Partner1CLink', 'Связь точек доставки и кодов в 1С' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Partner1CLink');

CREATE OR REPLACE FUNCTION  zc_Object_GoodsByGoodsKind1CLink() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsByGoodsKind1CLink'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsByGoodsKind1CLink', 'Связь видов товара и кодов в 1С' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsByGoodsKind1CLink');

CREATE OR REPLACE FUNCTION  zc_Object_SupplierFailures() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_SupplierFailures'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_SupplierFailures', 'Отказы поставщиков' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_SupplierFailures');


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А. А.   Шаблий О.В.
 19.02.25         * zc_Object_MessagePersonalService
 11.12.24         * zc_Object_UnitPeresort
 02.12.24         * zc_Object_SiteTag
 28.10.24         * zc_Object_PositionProperty
 23.07.24         * zc_Object_GoodsNormDiff
 22.06.24         * zc_Object_ViewPriceList
 23.05.24         * zc_Object_GoodsByGoodsKindPeresort
 27.12.23         * zc_Object_PartionCell
 19.12.23         * zc_Object_GoodsGroupProperty
 12.10.23                                                                                        * zc_Object_UKTZED
 18.08.23                                                                                        * zc_Object_StoredProcExternal
 16.07.23         * zc_Object_CarType
                    zc_Object_BodyType
 18.05.23         * zc_Object_AreaUnit
 16.05.23         * zc_Object_TransportKind
 18.04.23                                                                                        * zc_Object_CommentCheck
 21.03.23                                                                                        * zc_Object_AccountSalesDE
 14.11.22         * zc_Object_MemberReport
 02.11.22         * zc_Object_Section
 12.09.22                                                                                        * zc_Object_InternetRepair
 08.08.22         * zc_Object_StickerHeader
 28.07.22                                                                                        * zc_Object_GoodsWhoCan, zc_Object_GoodsMethodAppl, zc_Object_GoodsSignOrigin
 12.07.22         * zc_Object_OrderCarInfo
 24.06.22                                                                                        * zc_Object_IntenalSP_1303, zc_Object_MakerCountrySP_1303
 20.05.22                                                                                        * zc_Object_DiffKindPrice, zc_Object_MCRequest, zc_Object_MCRequestItem
 14.05.22                                                                                        * zc_Object_..._1303()
 04.05.22                                                                                        * zc_Object_Competitor
 14.04.22         * zc_Object_UserByGroup
                    zc_Object_UserByGroupList
 24.02.22                                                                                        * zc_Object_ExchangeRates
 09.02.22                                                                                        * zc_Object_SupplierFailures
 20.01.22                                                                                        * zc_Object_PickUpLogsAndDBF
 25.11.21                                                                                        * zc_Object_SurchargeWages
 22.11.21         * zc_Object_PairDay
 03.11.21                                                                                        * zc_Object_GroupMedicalProgramSP
 27.10.21                                                                                        * zc_Object_Category1303
 06.10.21                                                                                        * zc_Object_BanCommentSend
 01.10.21                                                                                        * zc_Object_MedicalProgramSP, zc_Object_MedicalProgramSPLink
 29.09.21                                                                                        * zc_Object_FormDispensing
 24.09.21                                                                                        * zc_Object_CorrectWagesPercentage
 20.09.21                                                                                        * zc_Object_InsuranceCompanies, zc_Object_MemberIC
 14.09.21                                                                                        * zc_Object_PayrollTypeVIP
 30.07.21                                                                                        * zc_Object_ZReportLog
 12.07.21         * zc_Object_MobilePack
 05.07.21                                                                                        * zc_Object_TopicsTestingTuning
 01.07.21         * zc_Object_ReturnDescKind
 25.06.21                                                                                        * zc_Object_CheckoutTesting
 22.06.21                                                                                        * zc_Object_CorrectMinAmount
 14.06.21         * zc_Object_ReceiptLevel
 27.04.21                                                                                        * zc_Object_PriceSite
 08.06.21         * zc_Object_OrderPeriodKind
 31.05.21                                                                                        * zc_Object_MethodsAssortment
 27.05.21         * zc_Object_ContractPriceList
 17.05.21                                                                                        * zc_Object_GoodsDivisionLock
 28.04.21         * zc_Object_FineSubject
 20.04.21                                                                                        * zc_Object_BuyerForSite
 19.04.21                                                                                        * zc_Object_ScaleCalcMarketingPlan
 07.04.21         * zc_Object_ReturnKind
                    zc_Object_Reason
 24.03.21                                                                                        * zc_Object_FinalSUAProtocol
 11.03.21                                                                                        * zc_Object_DiscountExternalSupplier
 05.03.21                                                                                        * zc_Object_MemberKashtan, zc_Object_MedicKashtan
 16.02.21                                                                                        * zc_Object_InstructionsKind, zc_Object_Instructions
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
 22.01.16         * add zc_Object_Education (аптека)
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
 21.08.13         * НОВАЯ СХЕМА 2
 08.07.13         * переход всего на НОВУЮ СХЕМУ
 28.06.13                                        * НОВАЯ СХЕМА
*/
