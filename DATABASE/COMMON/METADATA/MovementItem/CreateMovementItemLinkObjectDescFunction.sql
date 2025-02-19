--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!                

CREATE OR REPLACE FUNCTION zc_MILinkObject_Account() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Account'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Account', 'Счет' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Account');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Asset() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Asset'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Asset', 'Основные средства (для которых закупается ТМЦ)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Asset');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Asset_two() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Asset_two'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Asset_two', 'Выработка на оборудовании-2' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Asset_two');

CREATE OR REPLACE FUNCTION zc_MILinkObject_BankAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_BankAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_BankAccount', 'Счет в банке' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_BankAccount');

CREATE OR REPLACE FUNCTION zc_MILinkObject_BonusKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_BonusKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_BonusKind', 'Виды бонусов' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_BonusKind');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Box() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Box'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Box', 'Ящик (гофро)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Box');


CREATE OR REPLACE FUNCTION zc_MILinkObject_Box1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Box1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Box1', 'Тара-1' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Box1');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Box2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Box2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Box2', 'Тара-2' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Box2');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Box3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Box3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Box3', 'Тара-3' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Box3');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Box4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Box4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Box4', 'Тара-4' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Box4');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Box5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Box5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Box5', 'Тара-5' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Box5');


------------
CREATE OR REPLACE FUNCTION zc_MILinkObject_Branch() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Branch'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Branch', 'Филиал (только для ОПиУ)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Branch');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Business() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Business'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Business', 'Бизнес (только для ОПиУ)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Business');

CREATE OR REPLACE FUNCTION zc_MILinkObject_BranchRoute() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_BranchRoute'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_BranchRoute', 'Филиал (Маршрут)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_BranchRoute');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Car() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Car'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Car', 'Автомобиль' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Car');

CREATE OR REPLACE FUNCTION zc_MILinkObject_CarTrailer() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_CarTrailer'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_CarTrailer', 'Автомобиль (прицеп)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_CarTrailer');


CREATE OR REPLACE FUNCTION zc_MILinkObject_Contract() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Contract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Contract', 'Договора' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Contract');

CREATE OR REPLACE FUNCTION zc_MILinkObject_ContractMaster() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_ContractMaster'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_ContractMaster', 'Договор(условия)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_ContractMaster');

CREATE OR REPLACE FUNCTION zc_MILinkObject_ContractChild() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_ContractChild'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_ContractChild', 'Договор(база)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_ContractChild');

CREATE OR REPLACE FUNCTION zc_MILinkObject_ContractConditionKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_ContractConditionKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_ContractConditionKind', 'Типы условий договоров' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_ContractConditionKind');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Currency() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Currency'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Currency', 'Валюта' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Currency');

CREATE OR REPLACE FUNCTION zc_MILinkObject_CurrencyPartner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_CurrencyPartner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_CurrencyPartner', 'Валюта (контрагента)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_CurrencyPartner');


CREATE OR REPLACE FUNCTION zc_MILinkObject_Freight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Freight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Freight', 'Название груза' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Freight');


CREATE OR REPLACE FUNCTION zc_MILinkObject_DiscountCard() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_DiscountCard'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_DiscountCard', 'Дисконтные карты' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_DiscountCard');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Goods', 'Товар' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Goods');

CREATE OR REPLACE FUNCTION zc_MILinkObject_GoodsBasis() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_GoodsBasis'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_GoodsBasis', 'Товар (основной)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_GoodsBasis');

CREATE OR REPLACE FUNCTION zc_MILinkObject_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_GoodsKind', 'Виды товаров' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_GoodsKind');

CREATE OR REPLACE FUNCTION zc_MILinkObject_GoodsKindComplete() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_GoodsKindComplete'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_GoodsKindComplete', 'Виды товаров(готовая продукция)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_GoodsKindComplete');

CREATE OR REPLACE FUNCTION zc_MILinkObject_GoodsReal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_GoodsReal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_GoodsReal', 'Товар (факт отгрузка)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_GoodsReal');

CREATE OR REPLACE FUNCTION zc_MILinkObject_GoodsKindReal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_GoodsKindReal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_GoodsKindReal', 'Вид товара(факт отгрузка)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_GoodsKindReal');


CREATE OR REPLACE FUNCTION zc_MILinkObject_Receipt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Receipt'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Receipt', 'Рецептуры' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Receipt');

CREATE OR REPLACE FUNCTION zc_MILinkObject_ReceiptBasis() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_ReceiptBasis'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_ReceiptBasis', 'Рецептуры (ПФ-гп)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_ReceiptBasis');

  
CREATE OR REPLACE FUNCTION zc_MILinkObject_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_InfoMoney', 'Статьи назначения' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_InfoMoney');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Juridical', 'Юр. лицо' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Juridical');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Member() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Member'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Member', 'Физ лицо (через кого)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Member');

CREATE OR REPLACE FUNCTION zc_MILinkObject_MoneyPlace() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_MoneyPlace'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_MoneyPlace', 'Место операций с деньгами' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_MoneyPlace');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PaidKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PaidKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PaidKind', 'Форма оплаты' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PaidKind');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Partner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Partner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Partner', ' Контрагент' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Partner');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionGoods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionGoods', 'Партии товаров' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionGoods');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PersonalGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PersonalGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PersonalGroup', 'Группировки Сотрудников' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PersonalGroup');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Position() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Position'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Position', 'Должности' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Position');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PositionLevel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PositionLevel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PositionLevel', 'Разряд должности' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PositionLevel');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PriceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PriceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PriceList', 'Прайс' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PriceList');

CREATE OR REPLACE FUNCTION zc_MILinkObject_RateFuelKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_RateFuelKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_RateFuelKind', 'Виды норм для топлива' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_RateFuelKind');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Route() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Route'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Route', 'Маршрут' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Route');

CREATE OR REPLACE FUNCTION zc_MILinkObject_RouteKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_RouteKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_RouteKind', 'Типы маршрутов' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_RouteKind');

CREATE OR REPLACE FUNCTION zc_MILinkObject_RouteKindFreight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_RouteKindFreight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_RouteKindFreight', 'Типы маршрутов(груз)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_RouteKindFreight');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Storage() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Storage'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Storage', 'Место хранения' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Storage');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionModel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionModel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionModel', 'Модель' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionModel');




CREATE OR REPLACE FUNCTION zc_MILinkObject_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Unit', 'Подразделение (только для ОПиУ)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Unit');

CREATE OR REPLACE FUNCTION zc_MILinkObject_UnitRoute() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_UnitRoute'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_UnitRoute', 'Подразделение (Маршрут)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_UnitRoute');

CREATE OR REPLACE FUNCTION zc_MILinkObject_WorkTimeKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_WorkTimeKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_WorkTimeKind', 'Типы рабочего времени' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_WorkTimeKind');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PersonalServiceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PersonalServiceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PersonalServiceList', 'Ведомости начисления' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PersonalServiceList');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Insert() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Insert'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Insert', 'Пользователь (создание)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Insert');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Update() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Update'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Update', 'Пользователь (корректировка)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Update');

CREATE OR REPLACE FUNCTION zc_MILinkObject_ReasonDifferences() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_ReasonDifferences'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_ReasonDifferences', 'Причина разногласия' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_ReasonDifferences');

CREATE OR REPLACE FUNCTION zc_MILinkObject_StaffList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_StaffList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_StaffList', 'Штатное расписание' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_StaffList');

CREATE OR REPLACE FUNCTION zc_MILinkObject_ModelService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_ModelService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_ModelService', 'Модели начисления' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_ModelService');

CREATE OR REPLACE FUNCTION zc_MILinkObject_StaffListSummKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_StaffListSummKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_StaffListSummKind', 'Типы сумм для штатного расписания' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_StaffListSummKind');

CREATE OR REPLACE FUNCTION zc_MILinkObject_NameBefore() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_NameBefore'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_NameBefore', 'Товар/ОС/работы (предварительное название)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_NameBefore');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Region() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Region'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Region', 'Регион' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Region');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Employee() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Employee'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Employee', 'Сотрудник' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Employee');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PrevEmployee() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PrevEmployee'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PrevEmployee', 'Пред.сотрудник' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PrevEmployee');

CREATE OR REPLACE FUNCTION zc_MILinkObject_MobileTariff() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_MobileTariff'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_MobileTariff', 'Текущий тарифный план' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_MobileTariff');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PrevMobileTariff() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PrevMobileTariff'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PrevMobileTariff', 'Предыдущий тарифный план' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PrevMobileTariff');

--
CREATE OR REPLACE FUNCTION zc_MILinkObject_PartnerInTo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartnerInTo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartnerInTo', 'кто сформировал визу Получено от клиента' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartnerInTo');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartnerInFrom() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartnerInFrom'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartnerInFrom', 'кто сдал документ для визы Получено от клиента' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartnerInFrom');

CREATE OR REPLACE FUNCTION zc_MILinkObject_RemakeInTo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_RemakeInTo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_RemakeInTo', 'кто сформировал визу Получено для переделки' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_RemakeInTo');

CREATE OR REPLACE FUNCTION zc_MILinkObject_RemakeInFrom() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_RemakeInFrom'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_RemakeInFrom', 'кто сдал документ для визы Получено для переделки' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_RemakeInFrom');

CREATE OR REPLACE FUNCTION zc_MILinkObject_RemakeBuh() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_RemakeBuh'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_RemakeBuh', 'кто сформировал визу Бухгалтерия для исправления' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_RemakeBuh');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Remake() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Remake'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Remake', 'кто сформировал визу Документ исправлен' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Remake');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Buh() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Buh'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Buh', 'кто сформировал визу Бухгалтерия (Финиш)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Buh');

CREATE OR REPLACE FUNCTION zc_MILinkObject_inBuh() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_inBuh'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_inBuh', 'кто сформировал визу Бухгалтерия в работе' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_inBuh');

CREATE OR REPLACE FUNCTION zc_MILinkObject_TransferIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_TransferIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_TransferIn', 'кто сформировал визу Транзит получен' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_TransferIn');

CREATE OR REPLACE FUNCTION zc_MILinkObject_TransferOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_TransferOut'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_TransferOut', 'кто сформировал визу Транзит возвращен' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_TransferOut');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Log() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Log'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Log', 'кто сформировал визу Отдел логистики' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Log');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Econom() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Econom'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Econom', 'кто сформировал визу Экономисты' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Econom');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Snab() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Snab'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Snab', 'кто сформировал визу Снабжение (в работе)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Snab');

CREATE OR REPLACE FUNCTION zc_MILinkObject_SnabRe() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_SnabRe'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_SnabRe', 'кто сформировал визу Снабжение (для переделки)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_SnabRe');

CREATE OR REPLACE FUNCTION zc_MILinkObject_EconomOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_EconomOut'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_EconomOut', 'кто сформировал визу Экономисты (для снабжения)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_EconomOut');

CREATE OR REPLACE FUNCTION zc_MILinkObject_EconomIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_EconomIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_EconomIn', 'кто сформировал визу Экономисты (в работе)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_EconomIn');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Double() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Double'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Double', 'кто сформировал визу "Выведен дубликат"' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Double');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Scan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Scan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Scan', 'кто сформировал визу "В наличии скан"' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Scan');



CREATE OR REPLACE FUNCTION zc_MILinkObject_StorageLine() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_StorageLine'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_StorageLine', 'Линия производства' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_StorageLine');

-- GoodsSP
CREATE OR REPLACE FUNCTION zc_MILinkObject_IntenalSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_IntenalSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_IntenalSP', 'Міжнародна непатентована назва (Соц. проект)(2)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_IntenalSP');

CREATE OR REPLACE FUNCTION zc_MILinkObject_BrandSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_BrandSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_BrandSP', 'Торговельна назва лікарського засобу (Соц. проект)(3)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_BrandSP');

CREATE OR REPLACE FUNCTION zc_MILinkObject_KindOutSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_KindOutSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_KindOutSP', 'Форма випуску (Соц. проект)(4)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_KindOutSP');

CREATE OR REPLACE FUNCTION zc_MILinkObject_List() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_List'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_List', 'Пользователь (лист отказов)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_List');

CREATE OR REPLACE FUNCTION zc_MILinkObject_DiffKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_DiffKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_DiffKind', 'Вид отказа' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_DiffKind');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionDateKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionDateKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionDateKind', 'Типы срок/не срок' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionDateKind');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PayrollType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PayrollType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PayrollType', 'Типы расчета заработной платы' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PayrollType');

CREATE OR REPLACE FUNCTION zc_MILinkObject_MemberExternal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_MemberExternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_MemberExternal', 'Физические лица(сторонние)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_MemberExternal');

CREATE OR REPLACE FUNCTION zc_MILinkObject_CommentTR() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_CommentTR'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_CommentTR', 'Комментарий строк технического переучета' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_CommentTR');

CREATE OR REPLACE FUNCTION zc_MILinkObject_NDSKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_NDSKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_NDSKind', 'Типы НДС' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_NDSKind');

CREATE OR REPLACE FUNCTION zc_MILinkObject_DiscountExternal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_DiscountExternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_DiscountExternal', 'Дисконтная программы' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_DiscountExternal');

CREATE OR REPLACE FUNCTION zc_MILinkObject_DivisionParties() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_DivisionParties'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_DivisionParties', 'Разделение партий в кассе для продажи' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_DivisionParties');

CREATE OR REPLACE FUNCTION zc_MILinkObject_CommentSend() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_CommentSend'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_CommentSend', 'Комментарий строк перемещений по СУН' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_CommentSend');

CREATE OR REPLACE FUNCTION zc_MILinkObject_SubjectDoc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_SubjectDoc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_SubjectDoc', 'Основание для перемещения' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_SubjectDoc');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Reason() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Reason'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Reason', 'Причина возврата / перемещения' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Reason');


CREATE OR REPLACE FUNCTION zc_MILinkObject_ReturnKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_ReturnKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_ReturnKind', 'Тип возврата' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_ReturnKind');

CREATE OR REPLACE FUNCTION zc_MILinkObject_FineSubject() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_FineSubject'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_FineSubject', 'Вид нарушения' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_FineSubject');

CREATE OR REPLACE FUNCTION zc_MILinkObject_UnitFineSubject() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_UnitFineSubject'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_UnitFineSubject', 'Кем налагается взыскание' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_UnitFineSubject');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PersonalKVK() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PersonalKVK'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PersonalKVK', 'Оператор КВК(Ф.И.О)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PersonalKVK');

CREATE OR REPLACE FUNCTION zc_MILinkObject_TopicsTestingTuning() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_TopicsTestingTuning'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_TopicsTestingTuning', 'Тема тестирования сотрудников' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_TopicsTestingTuning');

CREATE OR REPLACE FUNCTION zc_MILinkObject_JuridicalTwo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_JuridicalTwo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_JuridicalTwo', 'Юр. лицо' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_JuridicalTwo');
  
CREATE OR REPLACE FUNCTION zc_MILinkObject_ContractTwo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_ContractTwo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_ContractTwo', 'Договора' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_ContractTwo');

CREATE OR REPLACE FUNCTION zc_MILinkObject_KindOutSP_1303() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_KindOutSP_1303'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_KindOutSP_1303', 'Форма випуску (Соц. проект)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_KindOutSP_1303');
  
CREATE OR REPLACE FUNCTION zc_MILinkObject_Dosage_1303() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Dosage_1303'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Dosage_1303', 'Дозування (Соц. проект)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Dosage_1303');
  
CREATE OR REPLACE FUNCTION zc_MILinkObject_CountSP_1303() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_CountSP_1303'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_CountSP_1303', 'Кількість таблеток в упаковці (Соц. проект)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_CountSP_1303');
  
CREATE OR REPLACE FUNCTION zc_MILinkObject_MakerSP_1303() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_MakerSP_1303'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_MakerSP_1303', 'Назва виробника (Соц. проект)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_MakerSP_1303');
  
CREATE OR REPLACE FUNCTION zc_MILinkObject_Country_1303() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Country_1303'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Country_1303', 'Країна (Соц. проект)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Country_1303');

CREATE OR REPLACE FUNCTION zc_MILinkObject_IntenalSP_1303() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_IntenalSP_1303'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_IntenalSP_1303', 'Міжнародна непатентована або загальноприйнята назва лікарського засобу' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_IntenalSP_1303');
  
CREATE OR REPLACE FUNCTION zc_MILinkObject_MakerCountrySP_1303() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_MakerCountrySP_1303'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_MakerCountrySP_1303', 'Найменування виробника, країна (Соц. проект)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_MakerCountrySP_1303');
  
CREATE OR REPLACE FUNCTION zc_MILinkObject_GoodsPresent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_GoodsPresent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_GoodsPresent', 'Прикркпленный акционный товар' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_GoodsPresent');
  
CREATE OR REPLACE FUNCTION zc_MILinkObject_JuridicalBasis() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_JuridicalBasis'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_JuridicalBasis', 'Главное юр. лицо' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_JuridicalBasis');

CREATE OR REPLACE FUNCTION zc_MILinkObject_CommentCheck() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_CommentCheck'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_CommentCheck', 'Комментарий строк в заказах' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_CommentCheck');
    

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_1', 'Ячейка-1' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_1');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_2', 'Ячейка-2' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_2');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_3', 'Ячейка-3' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_3');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_4', 'Ячейка-4' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_4');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_5', 'Ячейка-5' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_5');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_6', 'Ячейка-6' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_6');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_7', 'Ячейка-7' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_7');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_8() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_8'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_8', 'Ячейка-8' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_8');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_9() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_9'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_9', 'Ячейка-9' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_9');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_10() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_10'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_10', 'Ячейка-10' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_10');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_11() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_11'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_11', 'Ячейка-11' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_11');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_12() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_12'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_12', 'Ячейка-12' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_12');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_13() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_13'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_13', 'Ячейка-13' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_13');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_14() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_14'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_14', 'Ячейка-14' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_14');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_15() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_15'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_15', 'Ячейка-15' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_15');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_16() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_16'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_16', 'Ячейка-16' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_16');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_17() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_17'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_17', 'Ячейка-17' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_17');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_18() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_18'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_18', 'Ячейка-18' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_18');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_19() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_19'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_19', 'Ячейка-19' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_19');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_20() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_20'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_20', 'Ячейка-20' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_20');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_21() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_21'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_21', 'Ячейка-21' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_21');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_22() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_22'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_22', 'Ячейка-22' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_22');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell', 'Ячейка хранения' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell');


/*
-- !!!delete!!!  
CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_real_1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_real_1', 'Ячейка-1 (старт)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_1');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_real_2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_real_2', 'Ячейка-2 (старт)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_2');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_real_3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_real_3', 'Ячейка-3 (старт)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_3');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_real_4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_real_4', 'Ячейка-4 (старт)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_4');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_real_5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_real_5', 'Ячейка-5 (старт)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_5');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_real_6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_real_6', 'Ячейка-6 (старт)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_6');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_real_7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_real_7', 'Ячейка-7 (старт)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_7');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_real_8() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_8'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_real_8', 'Ячейка-8 (старт)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_8');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_real_9() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_9'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_real_9', 'Ячейка-9 (старт)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_9');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_real_10() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_10'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_real_10', 'Ячейка-10 (старт)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_10');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_real_11() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_11'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_real_11', 'Ячейка-11 (старт)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_11');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_real_12() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_12'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_real_12', 'Ячейка-12 (старт)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_12');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_real_13() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_13'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_real_13', 'Ячейка-13 (старт)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_13');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_real_14() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_14'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_real_14', 'Ячейка-14 (старт)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_14');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_real_15() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_15'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_real_15', 'Ячейка-15 (старт)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_15');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_real_16() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_16'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_real_16', 'Ячейка-16 (старт)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_16');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_real_17() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_17'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_real_17', 'Ячейка-17 (старт)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_17');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_real_18() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_18'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_real_18', 'Ячейка-18 (старт)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_18');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_real_19() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_19'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_real_19', 'Ячейка-19 (старт)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_19');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_real_20() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_20'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_real_20', 'Ячейка-20 (старт)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_20');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_real_21() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_21'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_real_21', 'Ячейка-21 (старт)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_21');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionCell_real_22() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_22'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionCell_real_22', 'Ячейка-22 (старт)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionCell_real_22');

-- !!!delete!!!  
*/

     
 CREATE OR REPLACE FUNCTION zc_MILinkObject_BankSecond_num() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_BankSecond_num'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_BankSecond_num', 'Банк - 2ф.(Восток, по приоритету)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_BankSecond_num');
 
 CREATE OR REPLACE FUNCTION zc_MILinkObject_BankSecondTwo_num() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_BankSecondTwo_num'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_BankSecondTwo_num', 'Банк - 2ф.(ОТП, по приоритету)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_BankSecondTwo_num');
 
 CREATE OR REPLACE FUNCTION zc_MILinkObject_BankSecondDiff_num() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_BankSecondDiff_num'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_BankSecondDiff_num', 'Банк - 2ф.(личный, по приоритету)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_BankSecondDiff_num');

 CREATE OR REPLACE FUNCTION zc_MILinkObject_TradeMark() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_TradeMark'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_TradeMark', 'Торговая марка' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_TradeMark');

 CREATE OR REPLACE FUNCTION zc_MILinkObject_GoodsGroupProperty() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_GoodsGroupProperty'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_GoodsGroupProperty', 'Аналитический классификатор' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_GoodsGroupProperty');

 CREATE OR REPLACE FUNCTION zc_MILinkObject_GoodsGroupDirection() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_GoodsGroupDirection'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_GoodsGroupDirection', 'Аналитическая группа Направление' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_GoodsGroupDirection');
     
     
     

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Шаблий О.В.
 12.02.25         * zc_MILinkObject_inBuh
 29.05.24         * zc_MILinkObject_PartionCell_6...12
                    zc_MILinkObject_PartionCell_real_6...12
 11.03.24         * zc_MILinkObject_BankSecond_num
                    zc_MILinkObject_BankSecondTwo_num  
                    zc_MILinkObject_BankSecondDiff_num
 18.04.23                                                                    * zc_MILinkObject_CommentCheck
 19.10.22         * zc_MILinkObject_JuridicalBasis
 30.09.22         * zc_MILinkObject_GoodsReal
                    zc_MILinkObject_GoodsKindReal
 10.09.22                                                                    * zc_MILinkObject_GoodsPresent
 24.06.22                                                                    * zc_MILinkObject_IntenalSP_1303, zc_MILinkObject_MakerCountrySP_1303
 16.05.22                                                                    * zc_MILinkObject_KindOutSP_1303, zc_MILinkObject_Dosage_1303, zc_MILinkObject_CountSP_1303, zc_MILinkObject_MakerSP_1303, zc_MILinkObject_Country_1303
 05.05.22         * zc_MILinkObject_Double
                    zc_MILinkObject_Scan
 24.11.21                                                                    * zc_MILinkObject_JuridicalTwo, zc_MILinkObject_ContractTwo
 05.10.21         * zc_MILinkObject_CarTrailer
 06.07.21                                                                    * zc_MILinkObject_TopicsTestingTuning
 30.06.21         * zc_MILinkObject_PersonalKVK
 17.06.21         * zc_MILinkObject_Reason
 06.05.21         * zc_MILinkObject_UnitFineSubject
 28.04.21         * zc_MILinkObject_FineSubject
 07.04.21         * zc_MILinkObject_SubjectDoc
                    zc_MILinkObject_ReturnKind
 19.08.20                                                                    * zc_MILinkObject_CommentSend
 14.08.20                                                                    * zc_MILinkObject_DivisionParties
 21.06.20                                                                    * zc_MILinkObject_DiscountExternal
 14.04.20                                                                    * zc_MILinkObject_NDSKind
 27.02.20                                                                    * zc_MILinkObject_CommentTR
 27.01.20         * zc_MILinkObject_MemberExternal
 26.08.19                                                                    * zc_MILinkObject_PayrollType
 11.12.18         * zc_MILinkObject_DiffKind
 07.11.18         * zc_MILinkObject_List
 13.08.18         * for GoodsSP
 25.05.17         * zc_MILinkObject_StorageLine
 27.09.16         * zc_MILinkObject_Region
 12.07.16         *
 21.06.16         * zc_MILinkObject_StaffList
                    zc_MILinkObject_ModelService
                    zc_MILinkObject_StaffListSummKind
 07.05.15                                        * add zc_MILinkObject_PersonalServiceList
 19.12.14                                                       * add zc_MILinkObject_GoodsKindComplete
 09.10.14                                                       * add zc_MIFloat_BoxCount
 30.08.14                      	                 * add zc_MILinkObject_Member
 27.08.14                      	                 * add zc_MILinkObject_Partner
 30.07.14                      	                 * add zc_MILinkObject_PartionGoods
 26.07.14                      	                 * add zc_MILinkObject_Storage
 17.06.14                         * add zc_MILinkObject_BankAccount
 29.03.14                                        * add zc_MILinkObject_Juridical
 15.01.14                         * add zc_MILinkObject_Currency
 24.12.13         * add zc_MILinkObject_Contract, zc_MILinkObject_ContractConditionKind
 21.11.13                                        * add zc_MILinkObject_PositionLevel
 01.11.13                                        * add zc_MILinkObject_Branch and zc_MILinkObject_UnitRoute and zc_MILinkObject_BranchRoute
 26.10.13                                        * add zc_MILinkObject_RouteKindFreight
 02.10.13         * add zc_MILinkObject_Unit
 01.10.13         * add PersonalGroup, Position, WorkTimeKind
 01.10.13                                        * НОВАЯ СХЕМА
 30.09.13                                        * add for PersonalSendCash
 29.09.13                                        * add for Transport
 29.09.13                                        * del zc_MILinkObject_Goods - Товар
 29.09.13                                        * del zc_MILinkObject_AmountNorm - Количество по норме
 29.09.13                                        * del zc_MILinkObject_From - Откуда идет заправка
 20.08.13         * add zc_MILinkObject_From, zc_MILinkObject_Goods
 30.06.13                                        * rename zc_MI...
 29.06.13                                        * НОВАЯ СХЕМА
 29.06.13                                        * zc_MovementItemFloat_AmountPacker
*/
