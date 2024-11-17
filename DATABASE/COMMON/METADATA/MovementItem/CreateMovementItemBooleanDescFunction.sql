--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_MIBoolean_PartionClose() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionClose'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_PartionClose', 'Закрыта ли партия' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionClose'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_OrderSecond() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_OrderSecond'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_OrderSecond', 'на основании дозаявки' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_OrderSecond'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_MasterFuel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_MasterFuel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_MasterFuel', 'Основной вид топлива (да/нет)' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_MasterFuel'); 
  
CREATE OR REPLACE FUNCTION zc_MIBoolean_Calculated() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Calculated'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_Calculated', 'Значение рассчитывается (да/нет) ' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Calculated'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_Main() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Main'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_Main', 'Основное место работы (да/нет)' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Main'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_WeightMain() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_WeightMain'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_WeightMain', 'Входит в общий вес сырья' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_WeightMain'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_TaxExit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_TaxExit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_TaxExit', 'Зависит от % выхода' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_TaxExit'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_StartWeighing() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_StartWeighing'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_StartWeighing', 'Режим начала взвешивания' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_StartWeighing'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_isAuto() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_isAuto'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_isAuto', 'Автоматически' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_isAuto'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_BarCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_BarCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_BarCode', 'По сканеру' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_BarCode'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_NeedPay() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_NeedPay'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_NeedPay', 'Оплачивать' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_NeedPay'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_isAuto() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_isAuto'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_isAuto', '№ п/п НН формируется автоматом' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_isAuto'); 

--
CREATE OR REPLACE FUNCTION zc_MIBoolean_Close() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Close'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_Close', 'Закрыт код по всей сети' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Close'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_First() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_First'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_First', '1-выбор' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_First'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_Second() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Second'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_Second', 'Неприоритет. выбор' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Second'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_TOP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_TOP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_TOP', 'ТОП сети' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_TOP'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_UnitTOP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_UnitTOP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_UnitTOP', 'ТОП точки' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_UnitTOP'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_MCSNotRecalc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_MCSNotRecalc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_MCSNotRecalc', 'Спецконтроль кода' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_MCSNotRecalc'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_MCSIsClose() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_MCSIsClose'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_MCSIsClose', 'Удален код' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_MCSIsClose'); 


CREATE OR REPLACE FUNCTION zc_MIBoolean_Print() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Print'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_Print', 'Печатать стикер' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Print'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_SP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_SP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_SP', 'признак что участвует в Соц. проекте' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_SP'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_isSync() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_isSync'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_isSync', '"успешно" сохранена инфа в Главной БД' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_isSync'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_Checked() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Checked'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_Checked', 'Отмечен' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Checked'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_Report() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Report'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_Report', 'для отчета' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Report'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_Conduct() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Conduct'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_Conduct', 'Проведен по количеству' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Conduct'); 

  CREATE OR REPLACE FUNCTION zc_MIBoolean_ClippedReprice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_ClippedReprice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_ClippedReprice', 'Отсеченные при ночных переоценках' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_ClippedReprice'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_isIssuedBy() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_isIssuedBy'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_isIssuedBy', 'Выдано' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_isIssuedBy'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_ServiceExitv() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_ServiceExit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_ServiceExit', 'Служебный выход' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_ServiceExit'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_isTestingUser() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_isTestingUser'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_isTestingUser', 'Ручной признак сдачи экзамена' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_isTestingUser'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_ApprovedBy() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_ApprovedBy'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_ApprovedBy', 'Утверждено' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_ApprovedBy'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_SummReestr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_SummReestr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_SummReestr', 'Расчет Сумма отгрузки' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_SummReestr'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_Present() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Present'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_Present', 'Подарок' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Present'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_PartialPay() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartialPay'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_PartialPay', 'Частичная оплата' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartialPay'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_Complement() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Complement'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_Complement', 'Дополнить' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Complement'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_PromoBonus() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PromoBonus'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_PromoBonus', 'По маркетинговому бонусу' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PromoBonus'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_Photo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Photo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_Photo', 'Фотография' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Photo'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_VIPSend() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_VIPSend'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_VIPSend', 'Товар в ВИП перемещение' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_VIPSend'); 


CREATE OR REPLACE FUNCTION zc_MIBoolean_Goods_Name_new() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Goods_Name_new'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_Goods_Name_new', 'использовать новое название' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Goods_Name_new'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_OrderInternal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_OrderInternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_OrderInternal', 'Товар во внутренний заказ' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_OrderInternal'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_BonusNo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_BonusNo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_BonusNo', 'нет начисления по бонусам' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_BonusNo'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_MandatoryQuestion() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_MandatoryQuestion'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_MandatoryQuestion', 'Обязательный вопрос' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_MandatoryQuestion'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_Deferred() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Deferred'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_Deferred', 'Отложено' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Deferred'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_Storekeeper() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Storekeeper'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_Storekeeper', 'Кладовщик' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Storekeeper'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_Passed() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Passed'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_Passed', 'Сдано' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Passed'); 

CREATE OR REPLACE FUNCTION zc_MovementBoolean_Conduct() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MovementBoolean_Conduct'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_Conduct', 'Проведен по количеству' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MovementBoolean_Conduct'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_JuridicalTwo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_JuridicalTwo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_JuridicalTwo', 'Проведен по количеству' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_JuridicalTwo'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_SupplierFailures() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_SupplierFailures'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_SupplierFailures', 'Отказ поставщика' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_SupplierFailures'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_UsePriceOOC() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_UsePriceOOC'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_UsePriceOOC', 'Использовать цену из Реестра ООЦ' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_UsePriceOOC'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_GoodsPresent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_GoodsPresent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_GoodsPresent', 'Акционный товар' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_GoodsPresent'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_FixedPercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_FixedPercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_FixedPercent', 'Фиксированный процент выполнения' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_FixedPercent'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_PriceNalog() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PriceNalog'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_PriceNalog', 'Сумма удержания сформирована на основании удержания налога по Ф2' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PriceNalog'); 


CREATE OR REPLACE FUNCTION zc_MIBoolean_PartionCell_Close_1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_PartionCell_Close_1', 'Закончился остаток для Ячейка-1(да/нет)' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_1'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_PartionCell_Close_2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_PartionCell_Close_2', 'Закончился остаток для Ячейка-2(да/нет)' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_2'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_PartionCell_Close_3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_PartionCell_Close_3', 'Закончился остаток для Ячейка-3(да/нет)' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_3'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_PartionCell_Close_4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_PartionCell_Close_4', 'Закончился остаток для Ячейка-4(да/нет)' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_4'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_PartionCell_Close_5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_PartionCell_Close_5', 'Закончился остаток для Ячейка-5(да/нет)' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_5'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_PartionCell_Close_6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_PartionCell_Close_6', 'Закончился остаток для Ячейка-6(да/нет)' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_6'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_PartionCell_Close_7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_PartionCell_Close_7', 'Закончился остаток для Ячейка-7(да/нет)' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_7'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_PartionCell_Close_8() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_8'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_PartionCell_Close_8', 'Закончился остаток для Ячейка-8(да/нет)' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_8'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_PartionCell_Close_9() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_9'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_PartionCell_Close_9', 'Закончился остаток для Ячейка-9(да/нет)' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_9'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_PartionCell_Close_10() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_10'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_PartionCell_Close_10', 'Закончился остаток для Ячейка-10(да/нет)' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_10'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_PartionCell_Close_11() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_11'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_PartionCell_Close_11', 'Закончился остаток для Ячейка-11(да/нет)' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_11'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_PartionCell_Close_12() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_12'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_PartionCell_Close_12', 'Закончился остаток для Ячейка-12(да/нет)' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_12'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_PartionCell_Close_13() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_13'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_PartionCell_Close_13', 'Закончился остаток для Ячейка-13(да/нет)' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_13'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_PartionCell_Close_14() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_14'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_PartionCell_Close_14', 'Закончился остаток для Ячейка-14(да/нет)' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_14'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_PartionCell_Close_15() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_15'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_PartionCell_Close_15', 'Закончился остаток для Ячейка-15(да/нет)' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_15'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_PartionCell_Close_16() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_16'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_PartionCell_Close_16', 'Закончился остаток для Ячейка-16(да/нет)' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_16'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_PartionCell_Close_17() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_17'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_PartionCell_Close_17', 'Закончился остаток для Ячейка-17(да/нет)' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_17'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_PartionCell_Close_18() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_18'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_PartionCell_Close_18', 'Закончился остаток для Ячейка-18(да/нет)' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_18'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_PartionCell_Close_19() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_19'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_PartionCell_Close_19', 'Закончился остаток для Ячейка-19(да/нет)' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_19'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_PartionCell_Close_20() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_20'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_PartionCell_Close_20', 'Закончился остаток для Ячейка-20(да/нет)' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_20'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_PartionCell_Close_21() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_21'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_PartionCell_Close_21', 'Закончился остаток для Ячейка-21(да/нет)' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_21'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_PartionCell_Close_22() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_22'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_PartionCell_Close_22', 'Закончился остаток для Ячейка-22(да/нет)' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PartionCell_Close_22'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_Etiketka() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Etiketka'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_Etiketka', 'Признак Переклейка(да/нет)' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Etiketka'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_PriceWithVAT() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PriceWithVAT'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_PriceWithVAT', 'Цена с НДС (да/нет)' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_PriceWithVAT'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_AmountPartnerSecond() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_AmountPartnerSecond'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_AmountPartnerSecond', 'Признак "без оплаты"' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_AmountPartnerSecond'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_ReturnOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_ReturnOut'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_ReturnOut', 'Возврат да/нет' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_ReturnOut'); 



   
 




/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.   Шаблий О.В.
 21.10.24         * zc_MIBoolean_AmountPartnerSecond
                    zc_MIBoolean_PriceWithVAT
 29.05.24         * zc_MIBoolean_PartionCell_Close_6...12
 04.07.23         * zc_MIBoolean_PriceNalog
 03.01.23                                                                       * zc_MIBoolean_FixedPercent
 10.09.22                                                                       * zc_MIBoolean_GoodsPresent
 10.04.22                                                                       * zc_MIBoolean_UsePriceOOC
 20.02.22                                                                       * zc_MIBoolean_SupplierFailures
 24.11.21                                                                       * zc_MIBoolean_JuridicalTwo
 05.11.21                                                                       * zc_MovementBoolean_Conduct
 23.10.21                                                                       * zc_MIBoolean_Passed
 22.10.21                                                                       * zc_MIBoolean_Storekeeper
 15.10.21                                                                       * zc_MIBoolean_Deferred
 06.09.21                                                                       * zc_MIBoolean_MandatoryQuestion
 25.08.21         * zc_MIBoolean_BonusNo
 29.07.21                                                                       * zc_MIBoolean_OrderInternal
 08.08.21         *
 29.07.21                                                                       * zc_MIBoolean_VIPSend
 22.07.21                                                                       * zc_MIBoolean_Photo
 23.02.21                                                                       * zc_MIBoolean_PromoBonus
 13.11.20                                                                       * zc_MIBoolean_Complement
 03.11.20                                                                       * zc_MIBoolean_PartialPay
 05.10.20                                                                       * zc_MIBoolean_Present
 04.06.20         * zc_MIBoolean_SummReestr
 13.05.20                                                                       * zc_MIBoolean_ApprovedBy
 10.01.20                                                                       * zc_MIBoolean_isTestingUser
 21.09.19                                                                       * zc_MIBoolean_ServiceExitv
 01.09.19                                                                       * zc_MIBoolean_isIssuedBy
 25.10.18                                                                       * zc_MIBoolean_ClippedReprice
 24.06.18                                                                       * zc_MIBoolean_Conduct
 26.11.17         * zc_MIBoolean_Report
 24.11.17         * zc_MIBoolean_Checked
 27.01.17         * add zc_MIBoolean_Print
 14.07.16         *
 29.10.15                                                       *zc_MIBoolean_NeedPay
 31.03.15         * add zc_MIBoolean_StartWeighing
 09.10.13                                        * add zc_MIBoolean_Calculated
 07.10.13                                        * add zc_MIBoolean_MasterFuel
 07.10.13                                        * add zc_MIBoolean_MasterFuel
 29.09.13                                        * add zc_MIBoolean_Calculated
 30.06.13                                        * rename zc_MI...
 30.06.13                                        * НОВАЯ СХЕМА
*/
