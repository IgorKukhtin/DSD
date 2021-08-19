--
CREATE OR REPLACE FUNCTION zc_ObjectBoolean_ReplServer_ErrTo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_ReplServer_ErrTo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReplServer(), 'zc_ObjectBoolean_ReplServer_ErrTo', 'была ошибка при отправке в базу-Child' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_ReplServer_ErrTo');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_ReplServer_ErrFrom() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_ReplServer_ErrFrom'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReplServer(), 'zc_ObjectBoolean_ReplServer_ErrFrom', 'была ошибка при получении из базы-Child' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_ReplServer_ErrFrom');

--
CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Account_onComplete() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Account_onComplete'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Account(), 'zc_ObjectBoolean_Account_onComplete', 'признак Создан при проведении' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Account_onComplete');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Account_PrintDetail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Account_PrintDetail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Account(), 'zc_ObjectBoolean_Account_PrintDetail', 'Показать развернутым при печати' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Account_PrintDetail');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Calendar_Working() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Calendar_Working'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Calendar(), 'zc_ObjectBoolean_Calendar_Working', 'Признак рабочий день' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Calendar_Working');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Calendar_Holiday() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Calendar_Holiday'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Calendar(), 'zc_ObjectBoolean_Calendar_Holiday', 'Признак праздничный день' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Calendar_Holiday');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Contract_Default() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Contract_Default'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectBoolean_Contract_Default', 'Признак - по умолчанию' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Contract_Default');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Contract_Standart() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Contract_Standart'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectBoolean_Contract_Standart', 'Признак - типовой' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Contract_Standart');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Contract_Personal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Contract_Personal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectBoolean_Contract_Personal', 'Служебная записка' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Contract_Personal');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Contract_Unique() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Contract_Unique'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectBoolean_Contract_Unique', 'Без группировки' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Contract_Unique');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Contract_VAT() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Contract_VAT'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectBoolean_Contract_VAT', 'ставка 0% (таможня)' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Contract_VAT');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Contract_Report() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Contract_Report'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectBoolean_Contract_Report', 'Участвует в отчете' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Contract_Report');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Contract_DefaultOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Contract_DefaultOut'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectBoolean_Contract_DefaultOut', 'По умолчанию (для исх. платежей)' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Contract_DefaultOut');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Contract_MorionCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Contract_MorionCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectBoolean_Contract_MorionCode', 'Импорт кодов Мориона' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Contract_MorionCode');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Contract_BarCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Contract_BarCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectBoolean_Contract_BarCode', 'Импорт штрих-кодов производителя' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Contract_BarCode');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Contract_MorionCodeLoad() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Contract_MorionCodeLoad'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectBoolean_Contract_MorionCodeLoad', 'Поиск по кодам Мориона при загрузке' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Contract_MorionCodeLoad');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Contract_BarCodeLoad() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Contract_BarCodeLoad'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectBoolean_Contract_BarCodeLoad', 'Поиск по штрих-кодам производителя при загрузке' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Contract_BarCodeLoad');


CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Contract_isWMS() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Contract_isWMS'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectBoolean_Contract_isWMS', 'Отправка данных для ВМС' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Contract_isWMS');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_ImportSettings_HDR() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_ImportSettings_HDR'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_ImportSettings(), 'zc_ObjectBoolean_ImportSettings_HDR', 'Названия колонок в Excel' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_ImportSettings_HDR');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_ImportSettings_MultiLoad() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_ImportSettings_MultiLoad'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_ImportSettings(), 'zc_ObjectBoolean_ImportSettings_MultiLoad', 'Много раз загружать прайс' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_ImportSettings_MultiLoad');


CREATE OR REPLACE FUNCTION zc_ObjectBoolean_isLeaf() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_isLeaf'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT NULL, 'zc_ObjectBoolean_isLeaf', 'признак есть ли потомок у дерева' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_isLeaf');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Juridical_isCorporate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Juridical_isCorporate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectBoolean_Juridical_isCorporate', 'Признак наша ли собственность это юридическое лицо' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Juridical_isCorporate');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Juridical_isTaxSummary() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Juridical_isTaxSummary'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectBoolean_Juridical_isTaxSummary', 'Сводная налоговая' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Juridical_isTaxSummary');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Juridical_isDiscountPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Juridical_isDiscountPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectBoolean_Juridical_isDiscountPrice', 'Печать в накладной цену со скидкой' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Juridical_isDiscountPrice');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Juridical_isPriceWithVAT() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Juridical_isPriceWithVAT'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectBoolean_Juridical_isPriceWithVAT', 'Печать в накладной цену с НДС (да/нет)' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Juridical_isPriceWithVAT');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Juridical_isOrderMin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Juridical_isOrderMin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectBoolean_Juridical_isOrderMin', 'Разрешен минимальный заказ' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Juridical_isOrderMin');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Juridical_isBranchAll() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Juridical_isBranchAll'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectBoolean_Juridical_isBranchAll', 'доступ у всех филиалов' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Juridical_isBranchAll');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Juridical_isVatPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Juridical_isVatPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectBoolean_Juridical_isVatPrice', 'Схема расчета цены с НДС (построчно)' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Juridical_isVatPrice');


CREATE OR REPLACE FUNCTION zc_ObjectBoolean_JuridicalSettings_isPriceClose() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_JuridicalSettings_isPriceClose'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_JuridicalSettings(), 'zc_ObjectBoolean_JuridicalSettings_isPriceClose', 'закрыть прайс' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_JuridicalSettings_isPriceClose');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_JuridicalSettings_isPriceCloseOrder() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_JuridicalSettings_isPriceCloseOrder'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_JuridicalSettings(), 'zc_ObjectBoolean_JuridicalSettings_isPriceCloseOrder', 'закрыть прайс для заказа' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_JuridicalSettings_isPriceCloseOrder');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_JuridicalSettings_isBonusClose() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_JuridicalSettings_isBonusClose'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_JuridicalSettings(), 'zc_ObjectBoolean_JuridicalSettings_isBonusClose', 'бонус закрыт' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_JuridicalSettings_isBonusClose');


CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_Close() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_Close'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_Close', 'Закрыт для заказа' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_Close');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_isMain() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_isMain'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_isMain', 'Общие товары' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_isMain');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_PartionCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_PartionCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_PartionCount', 'Партии поставщика в учете количеств' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_PartionCount');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_PartionSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_PartionSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_PartionSumm', 'Партии поставщика в учете себестоимости' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_PartionSumm');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_TOP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_TOP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_TOP', 'ТОП - позиция' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_TOP');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_First() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_First'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_First', '1-выбор' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_First');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_Second() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_Second'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_Second', 'Неприоритетный выбор' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_Second');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_NotMarion() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_NotMarion'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_NotMarion', 'Не привязывать код Марион' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_NotMarion');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_NOT() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_NOT'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_NOT', 'НОТ-неперемещаемый остаток' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_NOT');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_NOT_Sun_v2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_NOT_Sun_v2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_NOT_Sun_v2', 'НОТ-неперемещаемый остаток для СУН-v2' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_NOT_Sun_v2');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_NOT_Sun_v4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_NOT_Sun_v4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_NOT_Sun_v4', 'НОТ-неперемещаемый остаток для СУН-v2-ПИ' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_NOT_Sun_v4');


CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Member_Official() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Member_Official'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectBoolean_Member_Official', 'Оформлен официально' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Member_Official');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Personal_Main() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Personal_Main'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Personal(), 'zc_ObjectBoolean_Personal_Main', 'Основное место работы' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Personal_Main');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_PriceList_PriceWithVAT() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_PriceList_PriceWithVAT'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_PriceList_PriceWithVAT', 'Цена с НДС (да/нет)' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_PriceList_PriceWithVAT');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_ProfitLoss_onComplete() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_ProfitLoss_onComplete'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_ProfitLoss(), 'zc_ObjectBoolean_ProfitLoss_onComplete', 'признак Создан при проведении' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_ProfitLoss_onComplete');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_ReceiptChild_WeightMain() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_ReceiptChild_WeightMain'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReceiptChild(), 'zc_ObjectBoolean_ReceiptChild_WeightMain', 'Входит в общий вес сырья(100 кг.)' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_ReceiptChild_WeightMain');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_ReceiptChild_TaxExit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_ReceiptChild_TaxExit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReceiptChild(), 'zc_ObjectBoolean_ReceiptChild_TaxExit', 'Зависит от % выхода' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_ReceiptChild_TaxExit');


CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Receipt_Main() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Receipt_Main'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectBoolean_Receipt_Main', 'Признак главный (Рецептура)' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Receipt_Main');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Receipt_ParentMulti() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Receipt_ParentMulti'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectBoolean_Receipt_ParentMulti', 'в составляющих несколько ГП' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Receipt_ParentMulti');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Receipt_Disabled() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Receipt_Disabled'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectBoolean_Receipt_Disabled', 'Признак отключить рецептуру' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Receipt_Disabled');


CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_PartionDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_PartionDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Unit_PartionDate', 'Партии даты в учете' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_PartionDate');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_PartionGoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_PartionGoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Unit_PartionGoodsKind', 'Партии по виду упаковки' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_PartionGoodsKind');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_GoodsCategory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_GoodsCategory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_GoodsCategory', 'для Ассортиментной матрицы' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_GoodsCategory');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_SUN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_SUN', 'Работают по СУН' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_SUN_v2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN_v2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_SUN_v2', 'Работают по СУН - версия 2' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN_v2');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_SUN_v3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN_v3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_SUN_v3', 'Работают по Э-СУН' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN_v3');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_SUN_v3_in() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN_v3_in'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_SUN_v3_in', 'Работают по Э-СУН - только прием' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN_v3_in');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_SUN_v3_out() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN_v3_out'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_SUN_v3_out', 'Работают по Э-СУН - только отправка' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN_v3_out');


CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_SUN_v4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN_v4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_SUN_v4', 'Работают по СУН-ПИ' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN_v4');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_SUN_v4_in() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN_v4_in'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_SUN_v4_in', 'Работают по СУН-ПИ - только прием' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN_v4_in');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_SUN_v4_out() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN_v4_out'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_SUN_v4_out', 'Работают по СУН-ПИ - только отправка' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN_v4_out');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_SUN_in() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN_in'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_SUN_in', 'Работают по СУН - только прием' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN_in');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_SUN_out() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN_out'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_SUN_out', 'Работают по СУН - только отправка' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN_out');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_SUN_v2_in() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN_v2_in'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_SUN_v2_in', 'Работают по СУН версия 2 - только прием' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN_v2_in');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_SUN_v2_out() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN_v2_out'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_SUN_v2_out', 'Работают по СУН версия 2 - только отправка' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN_v2_out');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_SUN_NotSold() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN_NotSold'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_SUN_NotSold', 'отключена модель "без продаж" для СУН' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN_NotSold');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_SUN_v2_LockSale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN_v2_LockSale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_SUN_v2_LockSale', 'Не считать продажи для СУН-2' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN_v2_LockSale');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_TopNo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_TopNo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_TopNo', 'отключить правило ТОПов в аптеке' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_TopNo');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Partner_EdiOrdspr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Partner_EdiOrdspr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Partner(), 'zc_ObjectBoolean_Partner_EdiOrdspr', 'EDI - Подтверждение' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Partner_EdiOrdspr');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Partner_EdiInvoice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Partner_EdiInvoice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Partner(), 'zc_ObjectBoolean_Partner_EdiInvoice', 'EDI - Счет' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Partner_EdiInvoice');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Partner_EdiDesadv() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Partner_EdiDesadv'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Partner(), 'zc_ObjectBoolean_Partner_EdiDesadv', 'EDI - уведомление' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Partner_EdiDesadv');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_GoodsByGoodsKind_Order() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_GoodsByGoodsKind_Order'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectBoolean_GoodsByGoodsKind_Order', 'Используется в заявках' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_GoodsByGoodsKind_Order');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_GoodsByGoodsKind_ScaleCeh() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_GoodsByGoodsKind_ScaleCeh'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectBoolean_GoodsByGoodsKind_ScaleCeh', 'используется в ScaleCeh' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_GoodsByGoodsKind_ScaleCeh');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_GoodsByGoodsKind_NotMobile() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_GoodsByGoodsKind_NotMobile'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectBoolean_GoodsByGoodsKind_NotMobile', 'НЕ использовать в Мобильном агенте' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_GoodsByGoodsKind_NotMobile');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_GoodsByGoodsKind_NewQuality() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_GoodsByGoodsKind_NewQuality'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectBoolean_GoodsByGoodsKind_NewQuality', 'Новая декларация с параметром <Вжити до>' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_GoodsByGoodsKind_NewQuality');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_GoodsByGoodsKind_Top() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_GoodsByGoodsKind_Top'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectBoolean_GoodsByGoodsKind_Top', 'Товар с признаком ТОП' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_GoodsByGoodsKind_Top');


CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Retail_OperDateOrder() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Retail_OperDateOrder'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Retail(), 'zc_ObjectBoolean_Retail_OperDateOrder', 'цена по дате заявки' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Retail_OperDateOrder');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Retail_isOrderMin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Retail_isOrderMin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Retail(), 'zc_ObjectBoolean_Retail_isOrderMin', 'Разрешен минимальный заказ' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Retail_isOrderMin');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Retail_GoodsReprice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Retail_GoodsReprice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Retail(), 'zc_ObjectBoolean_Retail_GoodsReprice', 'Участвует в модели Переоценка в минус' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Retail_GoodsReprice');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Retail_isWMS() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Retail_isWMS'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Retail(), 'zc_ObjectBoolean_Retail_isWMS', 'Отправка данных для ВМС' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Retail_isWMS');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Branch_Medoc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Branch_Medoc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Branch(), 'zc_ObjectBoolean_Branch_Medoc', 'Загрузка налоговых из медка' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Branch_Medoc');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Branch_PartionDoc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Branch_PartionDoc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Branch(), 'zc_ObjectBoolean_Branch_PartionDoc', 'Партионный учет долгов нал' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Branch_PartionDoc');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_InfoMoney_ProfitLoss() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_InfoMoney_ProfitLoss'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_InfoMoney(), 'zc_ObjectBoolean_InfoMoney_ProfitLoss', 'затраты по оплате' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_InfoMoney_ProfitLoss');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Price_MCSIsClose() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Price_MCSIsClose'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectBoolean_Price_MCSIsClose', 'Неснижаемый товарный запас закрыт' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Price_MCSIsClose');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Price_MCSNotRecalc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Price_MCSNotRecalc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectBoolean_Price_MCSNotRecalc', 'Не пересчитывать неснижаемый товарный запас' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Price_MCSNotRecalc');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Price_Fix() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Price_Fix'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectBoolean_Price_Fix', 'Фиксированная цена' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Price_Fix');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Price_MCSAuto() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Price_MCSAuto'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectBoolean_Price_MCSAuto', 'Режим - НТЗ выставил фармацевт на период' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Price_MCSAuto');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Price_MCSNotRecalcOld() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Price_MCSNotRecalcOld'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectBoolean_Price_MCSNotRecalcOld', 'Спецконтроль кода - значение которое вернется по окончании периода' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Price_MCSNotRecalcOld');


CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_Published() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_Published'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_Published', 'Опубликован на сайте' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_Published');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_IsUpload() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_IsUpload'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_IsUpload', 'Выгружается в отчете для поставщика' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_IsUpload');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_Promo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_Promo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_Promo', 'Акция' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_Promo');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_SpecCondition() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_SpecCondition'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_SpecCondition', 'Товар под спецусловия' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_SpecCondition');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_Published() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_Published'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_Published', 'Опубликован на сайте' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_Published');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_UploadBadm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_UploadBadm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_UploadBadm', 'Выгружать в отчете для поставщика БАДМ' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_UploadBadm');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_UploadTeva() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_UploadTeva'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_UploadTeva', 'Выгружать в отчете для поставщика Тева' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_UploadTeva');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_UploadYuriFarm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_UploadYuriFarm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_UploadYuriFarm', 'Выгружать в отчете для поставщика Юрия-Фарм' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_UploadYuriFarm');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_UploadBadm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_UploadBadm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_UploadBadm', 'Выгружать в отчете для поставщика БАДМ' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_UploadBadm');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_RepriceAuto() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_RepriceAuto'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_RepriceAuto', 'Участвует в автопереоценке' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_RepriceAuto');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_Over() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_Over'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_Over', 'Участвует в Автоперемещении' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_Over');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_MarginCategory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_MarginCategory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_MarginCategory', 'Формировать в просмотре Категорий наценки' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_MarginCategory');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_Report() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_Report'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_Report', 'для отчета' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_Report');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_Holiday() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_Holiday'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_Holiday', 'режим вых. дня' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_Holiday');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_StaffList_PositionLevel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_StaffList_PositionLevel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_StaffList(), 'zc_ObjectBoolean_StaffList_PositionLevel', 'Все "Разряды должности"' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_StaffList_PositionLevel');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_MarginCategory_Site() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_MarginCategory_Site'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_MarginCategory(), 'zc_ObjectBoolean_MarginCategory_Site', 'для сайта' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_MarginCategory_Site');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_JuridicalSettings_Site() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_JuridicalSettings_Site'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_JuridicalSettings(), 'zc_ObjectBoolean_JuridicalSettings_Site', 'для сайта' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_JuridicalSettings_Site');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_JuridicalSettings_BonusVirtual() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_JuridicalSettings_BonusVirtual'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_JuridicalSettings(), 'zc_ObjectBoolean_JuridicalSettings_BonusVirtual', 'виртуальный бонус' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_JuridicalSettings_BonusVirtual');


CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Price_TOP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Price_TOP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectBoolean_Price_TOP', 'ТОП-позиция' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Price_TOP');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_SP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_SP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_SP', 'участвует в Соц. проекте' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_SP');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_SUN_v3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_SUN_v3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_SUN_v3', 'Работают по Э-СУН' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_SUN_v3');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_Resolution_224() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_Resolution_224'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_Resolution_224', 'Постанова 224' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_Resolution_224');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Juridical_isLongUKTZED() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Juridical_isLongUKTZED'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectBoolean_Juridical_isLongUKTZED', '10-ти значный код УКТ ЗЕД' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Juridical_isLongUKTZED');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_ReportCollation_Buh() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_ReportCollation_Buh'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReportCollation(), 'zc_ObjectBoolean_ReportCollation_Buh', 'сдали в бухгалтерию' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_ReportCollation_Buh');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_MobileEmployee_Discard() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_MobileEmployee_Discard'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_MobileEmployee(), 'zc_ObjectBoolean_MobileEmployee_Discard', 'Исключен' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_MobileEmployee_Discard');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_PersonalServiceList_Second() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_PersonalServiceList_Second'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_PersonalServiceList(), 'zc_ObjectBoolean_PersonalServiceList_Second', 'Признак - Вторая форма' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_PersonalServiceList_Second');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_PersonalServiceList_Recalc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_PersonalServiceList_Recalc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_PersonalServiceList(), 'zc_ObjectBoolean_PersonalServiceList_Recalc', 'Признак - Вторая форма' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_PersonalServiceList_Recalc');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_PersonalServiceList_PersonalOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_PersonalServiceList_PersonalOut'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_PersonalServiceList(), 'zc_ObjectBoolean_PersonalServiceList_PersonalOut', 'Признак - Разрешено для уволенных' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_PersonalServiceList_PersonalOut');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_PersonalServiceList_BankOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_PersonalServiceList_BankOut'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_PersonalServiceList(), 'zc_ObjectBoolean_PersonalServiceList_BankOut', 'ведомость для выплаты по банку уволенных' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_PersonalServiceList_BankOut');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_PersonalServiceList_Detail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_PersonalServiceList_Detail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_PersonalServiceList(), 'zc_ObjectBoolean_PersonalServiceList_Detail', 'Детализация данных' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_PersonalServiceList_Detail');


CREATE OR REPLACE FUNCTION zc_ObjectBoolean_GoodsListIncome_Last() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_GoodsListIncome_Last'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsListIncome(), 'zc_ObjectBoolean_GoodsListIncome_Last', 'Признак - Вторая форма' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_GoodsListIncome_Last');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_User_ProjectMobile() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_User_ProjectMobile'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectBoolean_User_ProjectMobile', 'признак - это Торговый агент' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_User_ProjectMobile');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_User_ProjectAuthent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_User_ProjectAuthent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectBoolean_User_ProjectAuthent', 'Аутентификация' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_User_ProjectAuthent');


CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Juridical_LoadBarcode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Juridical_LoadBarcode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectBoolean_Juridical_LoadBarcode', 'Разрешать импортировать штрих-коды от поставщика' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Juridical_LoadBarcode');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Juridical_Deferred() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Juridical_Deferred'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectBoolean_Juridical_Deferred', 'Исключение - заказ всегда "Отложен"' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Juridical_Deferred');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_JuridicalArea_Default() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_JuridicalArea_Default'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_JuridicalArea(), 'zc_ObjectBoolean_JuridicalArea_Default', 'Признак - по умолчанию' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_JuridicalArea_Default');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_JuridicalArea_GoodsCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_JuridicalArea_GoodsCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_JuridicalArea(), 'zc_ObjectBoolean_JuridicalArea_GoodsCode', 'Признак - по умолчанию' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_JuridicalArea_GoodsCode');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_JuridicalArea_Only() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_JuridicalArea_Only'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_JuridicalArea(), 'zc_ObjectBoolean_JuridicalArea_Only', 'Только для 1-ого региона' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_JuridicalArea_Only');


CREATE OR REPLACE FUNCTION zc_ObjectBoolean_StickerFile_Default() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_StickerFile_Default'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_StickerFile(), 'zc_ObjectBoolean_StickerFile_Default', 'Признак - по умолчанию' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_StickerFile_Default');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_StickerProperty_Fix() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_StickerProperty_Fix'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_StickerProperty(), 'zc_ObjectBoolean_StickerProperty_Fix', 'Признак - по умолчанию' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_StickerProperty_Fix');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_StickerProperty_CK() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_StickerProperty_CK'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_StickerProperty(), 'zc_ObjectBoolean_StickerProperty_CK', 'Выводить фразу для С/К+С/В' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_StickerProperty_CK');


CREATE OR REPLACE FUNCTION zc_ObjectBoolean_User_Site() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_User_Site'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectBoolean_User_Site', 'Для сайта да/нет' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_User_Site');


CREATE OR REPLACE FUNCTION zc_ObjectBoolean_ImportSettingsItems_ConvertFormatInExcel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_ImportSettingsItems_ConvertFormatInExcel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectBoolean_ImportSettingsItems_ConvertFormatInExcel', zc_Object_ImportSettingsItems(), 'Конвертировать формат в Excel' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_ImportSettingsItems_ConvertFormatInExcel');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_isNotUploadSites() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_isNotUploadSites'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_isNotUploadSites', 'Не выгружать для сайтов' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_isNotUploadSites');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_MemberPersonalServiceList_All() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_MemberPersonalServiceList_All'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_MemberPersonalServiceList(), 'zc_ObjectBoolean_MemberPersonalServiceList_All', 'Признак - доступ ко всем (да/нет)' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_MemberPersonalServiceList_All');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_GoodsSeparate_Calculated() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_GoodsSeparate_Calculated'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectBoolean_GoodsSeparate_Calculated', zc_Object_GoodsSeparate(), 'Расчет суммы(да/нет)' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_GoodsSeparate_Calculated');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_RepriceUnitSheduler_VAT20() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_RepriceUnitSheduler_VAT20'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectBoolean_RepriceUnitSheduler_VAT20', zc_Object_RepriceUnitSheduler(), 'НДС 20%' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_RepriceUnitSheduler_VAT20');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_RepriceUnitSheduler_Equal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_RepriceUnitSheduler_Equal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectBoolean_RepriceUnitSheduler_Equal', zc_Object_RepriceUnitSheduler(), 'Для уравниваниия' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_RepriceUnitSheduler_Equal');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_DiffKind_Close() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_DiffKind_Close'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_DiffKind(), 'zc_ObjectBoolean_DiffKind_Close', 'Закрыт для заказа' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_DiffKind_Close');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_PharmacyItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_PharmacyItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_PharmacyItem', 'Аптечный пункт' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_PharmacyItem');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_SP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_SP', 'Работают по Соц.проектам' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SP');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Maker_Report1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Maker_Report1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Maker(), 'zc_ObjectBoolean_Maker_Report1', 'отправлять отчет по приходам' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Maker_Report1');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Maker_Report2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Maker_Report2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Maker(), 'zc_ObjectBoolean_Maker_Report2', 'отправлять отчет по продажам' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Maker_Report2');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Maker_Report3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Maker_Report3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Maker(), 'zc_ObjectBoolean_Maker_Report3', 'отправлять Реализация за период с остатками на конец периода' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Maker_Report3');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Maker_Report4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Maker_Report4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Maker(), 'zc_ObjectBoolean_Maker_Report4', 'отправлять Приход расход остаток' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Maker_Report4');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Maker_Report5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Maker_Report5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Maker(), 'zc_ObjectBoolean_Maker_Report5', 'отправлять Отчет по срокам' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Maker_Report5');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Maker_Report6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Maker_Report6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Maker(), 'zc_ObjectBoolean_Maker_Report6', 'отправлять отчет по товару на виртуальном складе' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Maker_Report6');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Maker_Quarter() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Maker_Quarter'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Maker(), 'zc_ObjectBoolean_Maker_Quarter', 'Отправлять дополнительно квартальные отчеты' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Maker_Quarter');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Maker_4Month() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Maker_4Month'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Maker(), 'zc_ObjectBoolean_Maker_4Month', 'Отправлять дополнительно отчеты за 4 месяца' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Maker_4Month');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_GlobalConst_SiteDiscount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_GlobalConst_SiteDiscount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_GlobalConst(), 'zc_ObjectBoolean_GlobalConst_SiteDiscount', ' % скидки для сайта ' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_GlobalConst_SiteDiscount');


CREATE OR REPLACE FUNCTION zc_ObjectBoolean_RecalcMCSSheduler_SelectRun() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_RecalcMCSSheduler_SelectRun'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_RecalcMCSSheduler(), 'zc_ObjectBoolean_RecalcMCSSheduler_SelectRun', 'Пересчет только для отмеченных точек' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_RecalcMCSSheduler_SelectRun');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_RecalcMCSSheduler_SelectRun() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_RecalcMCSSheduler_SelectRun'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_ObjectBoolean_RecalcMCSSheduler_SelectRun(), 'zc_ObjectBoolean_RecalcMCSSheduler_AllRetail', 'Пересчет только для отмеченных точек' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_RecalcMCSSheduler_SelectRun');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_DoesNotShare() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_DoesNotShare'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_DoesNotShare', 'Не делить медикамент на кассах' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_DoesNotShare');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_DocumentKind_isAuto() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_DocumentKind_isAuto'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_DocumentKind(), 'zc_ObjectBoolean_DocumentKind_isAuto', 'Формировать автоматом Перемещение расход при проведении Перемещения приход' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_DocumentKind_isAuto');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_DividePartionDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_DividePartionDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_DividePartionDate', 'Разбивать товар по партиям на кассах' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_DividePartionDate');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_AllowDivision() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_AllowDivision'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_AllowDivision', 'Разрешить деление товара на кассе' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_AllowDivision');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_PartionGoods_Cat_5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_PartionGoods_Cat_5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_PartionGoods(), 'zc_ObjectBoolean_PartionGoods_Cat_5', '5 кат. (просрочка без наценки).' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_PartionGoods_Cat_5');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Driver_AllLetters() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Driver_AllLetters'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Driver(), 'zc_ObjectBoolean_Driver_AllLetters', 'Все письма водителю.' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Driver_AllLetters');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_GoodsPropertyValue_Weigth() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_GoodsPropertyValue_Weigth'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsPropertyValue(), 'zc_ObjectBoolean_GoodsPropertyValue_Weigth', 'В печати накладной показать вес' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_GoodsPropertyValue_Weigth');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_AutoMCS() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_AutoMCS'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_AutoMCS', 'Автоматический пересчет НТЗ' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_AutoMCS');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Member_ManagerPharmacy() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Member_ManagerPharmacy'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectBoolean_Member_ManagerPharmacy', 'Заведующая аптекой' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Member_ManagerPharmacy');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Member_NotSchedule() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Member_NotSchedule'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectBoolean_Member_NotSchedule', 'Не требовать отмечаться в кассе' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Member_NotSchedule');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Member_NotCompensation() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Member_NotCompensation'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectBoolean_Member_NotCompensation', 'Исключить из компенсации отпуска' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Member_NotCompensation');


CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_NotTransferTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_NotTransferTime'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectBoolean_Goods_NotTransferTime', 'Не перевдить в сроки' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_NotTransferTime');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Route_NotPayForWeight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Route_NotPayForWeight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Route(), 'zc_ObjectBoolean_Route_NotPayForWeight', 'Нет оплаты водителю за вес' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Route_NotPayForWeight');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_GoodsReprice_Enabled() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_GoodsReprice_Enabled'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsReprice(), 'zc_ObjectBoolean_GoodsReprice_Enabled', 'Включить условие (да/нет)' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_GoodsReprice_Enabled');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_NotCashMCS() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_NotCashMCS'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_NotCashMCS', 'Блокировать изменение НТЗ на кассах' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_NotCashMCS');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_NotCashListDiff() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_NotCashListDiff'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_NotCashListDiff', 'Блокировать добавление в листы отказов на кассах' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_NotCashListDiff');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_ModelService_Trainee() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_ModelService_Trainee'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_ModelService(), 'zc_ObjectBoolean_ModelService_Trainee', 'ЗП стажеров в общем фонде(да/нет - значит идут как доплата)' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_ModelService_Trainee');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_TechnicalRediscount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_TechnicalRediscount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_TechnicalRediscount', 'Ограничение тех переучета и ПС (полное списание)' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_TechnicalRediscount');


CREATE OR REPLACE FUNCTION zc_ObjectBoolean_MemberBankAccount_All() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_MemberBankAccount_All'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_MemberBankAccount(), 'zc_ObjectBoolean_MemberBankAccount_All', 'Признак - доступ ко всем (да/нет)' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_MemberBankAccount_All');


CREATE OR REPLACE FUNCTION zc_ObjectBoolean_CommentTR_Explanation() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_CommentTR_Explanation'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_CommentTR(), 'zc_ObjectBoolean_CommentTR_Explanation', 'Обязательное заполнение пояснения' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_CommentTR_Explanation');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_CommentTR_Resort() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_CommentTR_Resort'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_CommentTR(), 'zc_ObjectBoolean_CommentTR_Resort', 'Контроль пересорта' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_CommentTR_Resort');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_CommentTR_DifferenceSum() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_CommentTR_DifferenceSum'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_CommentTR(), 'zc_ObjectBoolean_CommentTR_DifferenceSum', 'Контроль пересорта в сумме' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_CommentTR_DifferenceSum');


CREATE OR REPLACE FUNCTION zc_ObjectBoolean_SunExclusion_v1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_SunExclusion_v1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_SunExclusion(), 'zc_ObjectBoolean_SunExclusion_v1', 'отключен для СУН-1' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_SunExclusion_v1');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_SunExclusion_v2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_SunExclusion_v2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_SunExclusion(), 'zc_ObjectBoolean_SunExclusion_v2', 'отключен для СУН-2' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_SunExclusion_v2');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_SunExclusion_v3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_SunExclusion_v3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_SunExclusion(), 'zc_ObjectBoolean_SunExclusion_v3', 'отключен для СУН-3' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_SunExclusion_v3');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_SunExclusion_v4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_SunExclusion_v4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_SunExclusion(), 'zc_ObjectBoolean_SunExclusion_v4', 'отключен для СУН-4' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_SunExclusion_v4');


CREATE OR REPLACE FUNCTION zc_ObjectBoolean_SunExclusion_MSC_in() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_SunExclusion_MSC_in'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_SunExclusion(), 'zc_ObjectBoolean_SunExclusion_MSC_in', 'отключен если у получателя по товару НТЗ = 0' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_SunExclusion_MSC_in');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_CashRegister_GetHardwareData() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_CashRegister_GetHardwareData'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashRegister(), 'zc_ObjectBoolean_CashRegister_GetHardwareData', 'Получить данные аппаратной части' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_CashRegister_GetHardwareData');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_SignInternal_Main() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_SignInternal_Main'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_SignInternal(), 'zc_ObjectBoolean_SignInternal_Main', 'Признак - главная модель для данного типа документа' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_SignInternal_Main');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_CashSettings_GetHardwareData() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_CashSettings_GetHardwareData'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectBoolean_CashSettings_GetHardwareData', 'Получить данные аппаратной части' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_CashSettings_GetHardwareData');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_AlertRecounting() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_AlertRecounting'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_AlertRecounting', 'Оповещение перед переучетом' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_AlertRecounting');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_OrderPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_OrderPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_OrderPromo', 'распределять заказ (маркет-товары)' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_OrderPromo');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_CashSettings_BanSUN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_CashSettings_BanSUN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectBoolean_CashSettings_BanSUN', 'Запрет работы по СУН' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_CashSettings_BanSUN');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_InvisibleSUN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_InvisibleSUN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_InvisibleSUN', 'Невидимка для ограничений по СУН' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_InvisibleSUN');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_CashSettings_BlockVIP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_CashSettings_BlockVIP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectBoolean_CashSettings_BlockVIP', 'Блокировать формирование перемещений VIP' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_CashSettings_BlockVIP');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_DiscountExternalTools_NotUseAPI() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_DiscountExternalTools_NotUseAPI'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_DiscountExternalTools(), 'zc_ObjectBoolean_DiscountExternalTools_NotUseAPI', 'Не использовать АПИ' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_DiscountExternalTools_NotUseAPI');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_SupplementSUN1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_SupplementSUN1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_SupplementSUN1', 'Дополнение СУН1' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_SupplementSUN1');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_DivisionParties_BanFiscalSale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_DivisionParties_BanFiscalSale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_DivisionParties(), 'zc_ObjectBoolean_DivisionParties_BanFiscalSale', 'Запрет фискальной продажи' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_DivisionParties_BanFiscalSale');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_DiscountExternal_GoodsForProject() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_DiscountExternal_GoodsForProject'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_DiscountExternal(), 'zc_ObjectBoolean_DiscountExternal_GoodsForProject', 'Товар только для проекта (дисконтные карты)' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_DiscountExternal_GoodsForProject');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_CommentSun_Promo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_CommentSun_Promo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_CommentSend(), 'zc_ObjectBoolean_CommentSun_Promo', 'Контроль количества по плану' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_CommentSun_Promo');


CREATE OR REPLACE FUNCTION zc_ObjectBoolean_CommentSun_SendPartionDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_CommentSun_SendPartionDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_CommentSend(), 'zc_ObjectBoolean_CommentSun_SendPartionDate', 'Формировать заявку на изменения срока' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_CommentSun_SendPartionDate');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_CheckSourceKind_Site() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_CheckSourceKind_Site'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_CheckSourceKind(), 'zc_ObjectBoolean_CheckSourceKind_Site', 'Показвыать как чек с сайта' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_CheckSourceKind_Site');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_CashSettings_PairedOnlyPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_CashSettings_PairedOnlyPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectBoolean_CashSettings_PairedOnlyPromo', 'При опускании парных контролировать только акционный' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_CashSettings_PairedOnlyPromo');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CommentTR_BlockFormSUN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectFloat_CommentTR_BlockFormSUN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_CommentTR(), 'zc_ObjectFloat_CommentTR_BlockFormSUN', 'Блокировать формирование СУН при не проведенных ТП' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectFloat_CommentTR_BlockFormSUN');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_CommentSun_LostPositions() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_CommentSun_LostPositions'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_CommentSend(), 'zc_ObjectBoolean_CommentSun_LostPositions', 'Утерянные позиции' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_CommentSun_LostPositions');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_ExceptionUKTZED() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_ExceptionUKTZED'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_ExceptionUKTZED', 'Исключение для запрета к фискальной продаже по УКТВЭД' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_ExceptionUKTZED');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_GoodsQuality_Klipsa() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_GoodsQuality_Klipsa'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsQuality(), 'zc_ObjectBoolean_GoodsQuality_Klipsa', 'Клипсованный товар(да/нет)' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_GoodsQuality_Klipsa');


CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_Present() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_Present'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_Present', 'Подарок' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_Present');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Contract_PartialPay() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Contract_PartialPay'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectBoolean_Contract_PartialPay', 'Оплата частями' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Contract_PartialPay');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_MinPercentMarkup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_MinPercentMarkup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_MinPercentMarkup', 'Использовать минимальную наценку по сети или аптеке' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_MinPercentMarkup');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_DiffKind_LessYear() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_DiffKind_LessYear'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_DiffKind(), 'zc_ObjectBoolean_DiffKind_LessYear', 'Разрешен заказ товара менее года' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_DiffKind_LessYear');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Juridical_UseReprice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Juridical_UseReprice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectBoolean_Juridical_UseReprice', 'Участвуют в автопереоценке' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Juridical_UseReprice');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_SUA() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUA'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_SUA', 'Работают по СУА' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUA');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_MemberMinus_Child() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_MemberMinus_Child'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_MemberMinus_Child', 'Алименты (да/нет)' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_MemberMinus_Child');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_ShareFromPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_ShareFromPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_ShareFromPrice', 'Делить медикамент от цены' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_ShareFromPrice');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_SUN_Supplement_in() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN_Supplement_in'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_SUN_Supplement_in', 'Работают по СУН - версия 1 дополнение - только прием' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN_Supplement_in');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_SUN_Supplement_out() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN_Supplement_out'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_SUN_Supplement_out', 'Работают по СУН - версия 1 дополнение - только отправка' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN_Supplement_out');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Maker_Report7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Maker_Report7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Maker(), 'zc_ObjectBoolean_Maker_Report7', 'отправлять "отчет по оплате приходов"' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Maker_Report7');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Hardware_License() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Hardware_License'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Hardware(), 'zc_ObjectBoolean_Hardware_License', 'Лицензия на ПК' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Hardware_License');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_OutUKTZED_SUN1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_OutUKTZED_SUN1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_OutUKTZED_SUN1', 'Отдача УКТВЭД в СУН1' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_OutUKTZED_SUN1');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_CheckUKTZED() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_CheckUKTZED'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_CheckUKTZED', 'Запрет на печать чека, если есть позиция по УКТВЭД' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_CheckUKTZED');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Hardware_Smartphone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Hardware_Smartphone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Hardware(), 'zc_ObjectBoolean_Hardware_Smartphone', 'Смартфон' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Hardware_Smartphone');
  
CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Hardware_Modem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Hardware_Modem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Hardware(), 'zc_ObjectBoolean_Hardware_Modem', '3G/4G модем' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Hardware_Modem');
  
CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Hardware_BarcodeScanner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Hardware_BarcodeScanner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Hardware(), 'zc_ObjectBoolean_Hardware_BarcodeScanner', 'Сканнер ш/к' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Hardware_BarcodeScanner');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_OnlySP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_OnlySP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_OnlySP', 'Только для СП "Доступные лики"' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_OnlySP');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_DiscountExternal_OneSupplier() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_DiscountExternal_OneSupplier'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_DiscountExternal(), 'zc_ObjectBoolean_DiscountExternal_OneSupplier', 'В чек товар одного поставщика' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_DiscountExternal_OneSupplier');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_DiscountExternal_TwoPackages() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_DiscountExternal_TwoPackages'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_DiscountExternal(), 'zc_ObjectBoolean_DiscountExternal_TwoPackages', '2 упаковки по карте со скидкой на вторую продажу' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_DiscountExternal_TwoPackages');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Juridical_PriorityReprice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Juridical_PriorityReprice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectBoolean_Juridical_PriorityReprice', 'Приоритетный поставщик при переоценке' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Juridical_PriorityReprice');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_MultiplicityError() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_MultiplicityError'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_MultiplicityError', 'Погрешность для кратности при продажи' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_MultiplicityError');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_FinalSUAProtocol_GoodsClose() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_FinalSUAProtocol_GoodsClose'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_FinalSUAProtocol(), 'zc_ObjectBoolean_FinalSUAProtocol_GoodsClose', 'Не показывать Закрыт код' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_FinalSUAProtocol_GoodsClose');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_FinalSUAProtocol_MCSIsClose() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_FinalSUAProtocol_MCSIsClose'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_FinalSUAProtocol(), 'zc_ObjectBoolean_FinalSUAProtocol_MCSIsClose', 'Не показывать Убит код' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_FinalSUAProtocol_MCSIsClose');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_FinalSUAProtocol_NotCheckNoMCS() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_FinalSUAProtocol_NotCheckNoMCS'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_FinalSUAProtocol(), 'zc_ObjectBoolean_FinalSUAProtocol_NotCheckNoMCS', 'Не показывать Продажи не для НТЗ' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_FinalSUAProtocol_NotCheckNoMCS');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_GoodsUKTZEDRRO() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_GoodsUKTZEDRRO'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_GoodsUKTZEDRRO', 'Печать товаров по УКТВЭД через РРО' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_GoodsUKTZEDRRO');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_FinalSUAProtocol_MCSValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_FinalSUAProtocol_MCSValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_FinalSUAProtocol(), 'zc_ObjectBoolean_FinalSUAProtocol_MCSValue', 'Учитывать товар с НТЗ > 0' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_FinalSUAProtocol_MCSValue');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_FinalSUAProtocol_Remains() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_FinalSUAProtocol_Remains'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_FinalSUAProtocol(), 'zc_ObjectBoolean_FinalSUAProtocol_Remains', 'Остаток получателя > 0' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_FinalSUAProtocol_Remains');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_FinalSUAProtocol_AssortmentRound() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_FinalSUAProtocol_AssortmentRound'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_FinalSUAProtocol(), 'zc_ObjectBoolean_FinalSUAProtocol_AssortmentRound', 'Ассортимент округлять по мат принципу' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_FinalSUAProtocol_AssortmentRound');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_FinalSUAProtocol_NeedRound() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_FinalSUAProtocol_NeedRound'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_FinalSUAProtocol(), 'zc_ObjectBoolean_FinalSUAProtocol_NeedRound', 'Потребность округлять по мат принципу' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_FinalSUAProtocol_NeedRound');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_SUN_Supplement_Priority() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN_Supplement_Priority'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_SUN_Supplement_Priority', 'Работают по СУН - версия 1 дополнение - приоритет' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_SUN_Supplement_Priority');

CREATE OR REPLACE FUNCTION zc_ObjectDate_PriceChange_FixEndDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PriceChange_FixEndDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceChange(), 'zc_ObjectDate_PriceChange_FixEndDate', 'Дата окончания действия скидки' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PriceChange_FixEndDate');
  
CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_MessageByTimePD() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_MessageByTimePD'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_MessageByTimePD', 'Сообщение в кассе при опускании если разные сроки по категории' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_MessageByTimePD');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Member_ReleasedMarketingPlan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Member_ReleasedMarketingPlan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectBoolean_Member_ReleasedMarketingPlan', 'Освобожден от плана маркетинга' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Member_ReleasedMarketingPlan');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_GoodsDivisionLock_Lock() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_GoodsDivisionLock_Lock'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsDivisionLock(), 'zc_ObjectBoolean_GoodsDivisionLock_Lock', 'Блокировка деления товара' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_GoodsDivisionLock_Lock');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_PriceSite_Fix() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_PriceSite_Fix'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceSite(), 'zc_ObjectBoolean_PriceSite_Fix', 'фиксированная цена' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_PriceSite_Fix');


CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Reason_ReturnIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Reason_ReturnIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Reason(), 'zc_ObjectBoolean_Reason_ReturnIn', 'фиксированная цена' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Reason_ReturnIn');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Reason_SendOnPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Reason_SendOnPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Reason(), 'zc_ObjectBoolean_Reason_SendOnPrice', 'фиксированная цена' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Reason_SendOnPrice');


CREATE OR REPLACE FUNCTION zc_ObjectBoolean_DiffKind_FormOrder() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_DiffKind_FormOrder'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_DiffKind(), 'zc_ObjectBoolean_DiffKind_FormOrder', 'Сразу формировать заказ' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_DiffKind_FormOrder');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_CheckoutTesting_Updates() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_CheckoutTesting_Updates'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_CheckoutTesting(), 'zc_ObjectBoolean_CheckoutTesting_Updates', 'Касса и сервис обновлены' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_CheckoutTesting_Updates');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Juridical_ChangeExpirationDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Juridical_ChangeExpirationDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectBoolean_Juridical_ChangeExpirationDate', 'Разрешено изменять срок годности в приходе' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Juridical_ChangeExpirationDate');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_DiffKind_FindLeftovers() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_DiffKind_FindLeftovers'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_DiffKind(), 'zc_ObjectBoolean_DiffKind_FindLeftovers', 'Поиск остатков по аптекам' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_DiffKind_FindLeftovers');


CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_ParticipDistribListDiff() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_ParticipDistribListDiff'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_ParticipDistribListDiff', 'Участвует в распределении товара при заказе для покупателя' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_ParticipDistribListDiff');
  

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_PauseDistribListDiff() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_PauseDistribListDiff'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_PauseDistribListDiff', 'Разрешить заказ без контроля остатка по сети' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_PauseDistribListDiff');  

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_RequestDistribListDiff() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_RequestDistribListDiff'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_RequestDistribListDiff', 'Запрос на разрешения заказ без контроля остатка по сети' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_RequestDistribListDiff');  

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_WorkTimeKind_NoSheetChoice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_WorkTimeKind_NoSheetChoice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_WorkTimeKind(), 'zc_ObjectBoolean_WorkTimeKind_NoSheetChoice', 'Блокировать выбор в Табеле' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_WorkTimeKind_NoSheetChoice');  

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.  Ярошенко Р.Ф.   Подмогильный В.В.   Шаблий О.В.
 19.08.21         * zc_ObjectBoolean_WorkTimeKind_NoSheetChoice
 27.07.21                                                                                                          * zc_ObjectBoolean_Unit_ParticipDistribListDiff, zc_ObjectBoolean_Unit_ParticipDistribListDiff
 27.07.21                                                                                                          * zc_ObjectBoolean_DiffKind_FindLeftovers
 07.07.21                                                                                                          * zc_ObjectBoolean_Juridical_ChangeExpirationDate
 25.06.21                                                                                                          * zc_ObjectBoolean_CheckoutTesting_Updates
 23.06.21                                                                                                          * zc_ObjectBoolean_DiffKind_FormOrder
 22.06.21         * zc_ObjectBoolean_Reason_SendOnPrice
                    zc_ObjectBoolean_Reason_ReturnIn
 09.06.21                                                                                                          * zc_ObjectBoolean_PriceSite_Fix
 17.05.21                                                                                                          * zc_ObjectBoolean_GoodsDivisionLock_Lock
 13.05.21         * zc_ObjectBoolean_User_ProjectAuthent
 05.05.21                                                                                                          * zc_ObjectBoolean_Member_ReleasedMarketingPlan
 28.04.21         * zc_ObjectBoolean_PersonalServiceList_Detail
 28.04.21                                                                                                          * zc_ObjectBoolean_Unit_MessageByTime
 22.04.21         * zc_ObjectBoolean_StickerProperty_CK
 18.04.21         * zc_ObjectBoolean_GoodsByGoodsKind_NewQuality
 17.04.21                                                                                                          * zc_ObjectBoolean_Unit_SUN_Supplement_Priority
 24.03.21                                                                                                          * zc_ObjectBoolean_Unit_GoodsUKTZEDRRO
 24.03.21                                                                                                          * zc_ObjectBoolean_FinalSUAProtocol_...
 22.03.21                                                                                                          * zc_ObjectBoolean_Goods_MultiplicityError
 17.03.21                                                                                                          * zc_ObjectBoolean_Juridical_PriorityReprice
 11.03.21                                                                                                          * zc_ObjectBoolean_DiscountExternal_...
 10.03.21                                                                                                          * zc_ObjectBoolean_Goods_OnlySP
 04.02.21                                                                                                          * zc_ObjectBoolean_Hardware_...
 02.02.21                                                                                                          * zc_ObjectBoolean_Contract_MorionCodeLoad, zc_ObjectBoolean_Contract_BarCodeLoad
 31.01.21                                                                                                          * zc_ObjectBoolean_Unit_CheckUKTZED
 29.01.21                                                                                                          * zc_ObjectBoolean_Unit_OutUKTZED_SUN1
 27.01.21                                                                                                          * zc_ObjectBoolean_Hardware_License
 04.01.21                                                                                                          * zc_ObjectBoolean_Maker_Report7
 25.12.20                                                                                                          * zc_ObjectBoolean_Unit_SUN_Supplement_in _out
 09.12.20                                                                                                          * zc_ObjectBoolean_Unit_ShareFromPrice 
 08.12.20         * zc_ObjectBoolean_MemberMinus_Child
 27.11.20                                                                                                          * zc_ObjectBoolean_Unit_SUA 
 17.11.20         * zc_ObjectBoolean_PersonalServiceList_BankOut
 16.11.20                                                                                                          * zc_ObjectBoolean_Juridical_UseReprice 
 10.11.20                                                                                                          * zc_ObjectBoolean_DiffKind_LessYear 
 06.11.20                                                                                                          * zc_ObjectBoolean_Unit_MinPercentMarkup 
 04.10.20                                                                                                          * zc_ObjectBoolean_Contract_PartialPay 
 01.10.20                                                                                                          * zc_ObjectBoolean_Goods_Present 
 23.09.20         * zc_ObjectBoolean_GoodsQuality_Klipsa
 22.09.20                                                                                                          * zc_ObjectBoolean_Goods_ExceptionUKTZED 
 15.09.20                                                                                                          * zc_ObjectBoolean_CommentSun_LostPositions 
 10.09.20         * zc_ObjectBoolean_Receipt_Disabled
 09.09.20                                                                                                          * zc_ObjectFloat_CommentTR_BlockFormSUN 
 06.09.20                                                                                                          * zc_ObjectBoolean_CashSettings_PairedOnlyPromo 
 05.09.20                                                                                                          * zc_ObjectBoolean_CheckSourceKind_Site 
 26.08.20                                                                                                          * zc_ObjectBoolean_CommentSun_Promo 
 16.08.20                                                                                                          * zc_ObjectBoolean_DiscountExternal_GoodsForProject 
 13.08.20                                                                                                          * zc_ObjectBoolean_DivisionParties_BanFiscalSale 
 09.06.20                                                                                                          * zc_ObjectBoolean_Goods_SupplementSUN1 
 05.06.20                                                                                                          * zc_ObjectBoolean_CashSettings_BlockVIP, zc_ObjectBoolean_DiscountExternalTools_NotUseAPI
 25.05.20         * zc_Object_PersonalServiceList
 21.05.20         * zc_ObjectBoolean_Unit_SUN_v2_LockSale
                    zc_ObjectBoolean_Contract_isWMS
                    zc_ObjectBoolean_Retail_isWMS
 18.05.20         * zc_ObjectBoolean_Unit_OrderPromo
 13.05.20                                                                                                          * zc_ObjectBoolean_Goods_InvisibleSUN
 07.05.20                                                                                                          * zc_ObjectBoolean_CashSettings_BanSUN
 06.05.20         * zc_ObjectBoolean_Juridical_isVatPrice
 23.04.20         * zc_ObjectBoolean_SunExclusion_v3
                    zc_ObjectBoolean_SunExclusion_v4
 13.04.20                                                                                                          * zc_ObjectBoolean_Unit_AlertRecounting
 09.04.20         * zc_ObjectBoolean_SignInternal_Main
 08.04.20                                                                                                          * zc_ObjectBoolean_CashRegister_GetHardwareData
 06.04.20         * zc_ObjectBoolean_SunExclusion_v1
                    zc_ObjectBoolean_SunExclusion_v2
                    zc_ObjectBoolean_SunExclusion_MSC_in
 02.04.20                                                                                                          * zc_ObjectBoolean_Goods_Resolution_224
 31.03.20         * zc_ObjectBoolean_Unit_SUN_v3
                    zc_ObjectBoolean_Goods_SUN_v3
                    zc_ObjectBoolean_Unit_SUN_v3_in
                    zc_ObjectBoolean_Unit_SUN_v3_out
 11.03.20                                                                                                          * zc_ObjectBoolean_CommentTR_DifferenceSum
 10.03.20                                                                                                          * zc_ObjectBoolean_CommentTR_Resort
 27.02.20                                                                                                          * zc_ObjectBoolean_CommentTR_Explanation
 17.02.20         * zc_ObjectBoolean_PersonalServiceList_Recalc
                    zc_ObjectBoolean_MemberBankAccount_All
 14.02.20                                                                                                          * zc_ObjectBoolean_Unit_TechnicalRediscount
 13.02.20         * zc_ObjectBoolean_Unit_SUN_v2_in
                    zc_ObjectBoolean_Unit_SUN_v2_out
 06.02.20         * zc_ObjectBoolean_Member_NotCompensation
 05.02.20         * zc_ObjectBoolean_Unit_SUN_NotSold
 14.01.20                                                                                                          * zc_ObjectBoolean_Maker_Report6
 17.12.19         * zc_ObjectBoolean_Retail_GoodsReprice
                    zc_ObjectBoolean_Goods_NOT_Sun_v2
 09.12.19         * zc_ObjectBoolean_ModelService_Trainee
 24.11.19                                                                                                          * zc_ObjectBoolean_Unit_NotCashMCS, zc_ObjectBoolean_Unit_NotCashListDiff
 19.11.19         * zc_ObjectBoolean_GoodsReprice_Enabled
                    zc_ObjectBoolean_Unit_SUN_out
                    zc_ObjectBoolean_Unit_SUN_in
                    zc_ObjectBoolean_Unit_SUN_v2
 29.10.19         * zc_ObjectBoolean_Route_PayForWeight
 24.10.19         * zc_ObjectBoolean_Juridical_isBranchAll
 24.10.19         * zc_ObjectBoolean_Retail_isOrderMin
                    zc_ObjectBoolean_Juridical_isOrderMin
 23.10.19                                                                                                          * zc_ObjectBoolean_Goods_UploadYuriFarm
 18.10.19                                                                                                          * zc_ObjectBoolean_RecalcMCSSheduler_SelectRun
 23.09.19                                                                                                          * zc_ObjectBoolean_Goods_NotTransferTime
 15.09.19                                                                                                          * zc_ObjectBoolean_Member_NotSchedule
 12.09.19         * zc_ObjectBoolean_Contract_MorionCode
                    zc_ObjectBoolean_Contract_BarCode
 04.09.19         * zc_ObjectBoolean_Unit_TopNo
 25.09.19                                                                                                          * zc_ObjectBoolean_Member_ManagerPharmacy
 13.08.19                                                                                                          * zc_ObjectBoolean_Unit_AutoMCS
 10.08.19         * zc_ObjectBoolean_GoodsPropertyValue_Weigth
 07.08.19                                                                                                          * zc_ObjectBoolean_Maker_Report5, zc_ObjectBoolean_Driver_AllLetters
 17.07.19                                                                                                          * zc_ObjectBoolean_PartionGoods_Cat_5
 11.07.19         * zc_ObjectBoolean_Unit_SUN
 14.04.19                                                                                                          * zc_ObjectBoolean_Unit_DividePartionDate, zc_ObjectBoolean_Goods_AllowDivision
 05.04.19                                                                                                          * zc_ObjectBoolean_Maker_4Month
 03.04.19                                                                                                          * zc_ObjectBoolean_Maker_Quarter
 20.03.19         * zc_ObjectBoolean_Unit_SP
 11.03.19         * zc_ObjectBoolean_DocumentKind_isAuto
 06.03.19                                                                                                          * zc_ObjectBoolean_Goods_DoesNotShare
 15.02.19         * zc_ObjectBoolean_Unit_GoodsCategory
 09.02.19                                                                                                          * zc_ObjectBoolean_RecalcMCSSheduler_AllRetail
 06.02.19         * zc_ObjectBoolean_JuridicalSettings_isBonusClose
 21.01.19         * zc_ObjectBoolean_Account_PrintDetail
 18.01.19         * zc_ObjectBoolean_Contract_DefaultOut
 11.01.19         * zc_ObjectBoolean_Maker_Report1...4
 26.12.18         * zc_ObjectBoolean_Calendar_Holiday
 23.10.18                                                                                                          * zc_ObjectBoolean_Unit_PharmacyItem
 11.12.18         * zc_ObjectBoolean_DiffKind_Close
 23.10.18                                                                                                          * zc_ObjectBoolean_RepriceUnitSheduler_Equal
 22.10.18                                                                                                          * zc_ObjectBoolean_RepriceUnitSheduler_VAT20
 19.10.18         * zc_ObjectBoolean_JuridicalSettings_isPriceCloseOrder
 07.10.18         * zc_ObjectBoolean_GoodsSeparate_Calculated
 05.07.18         * zc_ObjectBoolean_MemberPersonalServiceList_All
 20.06.18         * zc_ObjectBoolean_ReplServer_...
 24.05.18                                                                                                          * zc_ObjectBoolean_Goods_isNotUploadSites
 09.02.18                                                                                        * zc_ObjectBoolean_ImportSettingsItems_ConvertFormatInExcel
 05.02.18         * zc_ObjectBoolean_JuridicalArea_Only
 06.11.17         * zc_ObjectBoolean_User_Site
 24.10.17         * zc_ObjectBoolean_StickerFile_Default
                    zc_ObjectBoolean_StickerProperty_Fix
 20.10.17         * zc_ObjectBoolean_JuridicalArea_GoodsCode
 26.09.17         * zc_ObjectBoolean_JuridicalArea_Default
 17.08.17         * zc_ObjectBoolean_Juridical_Deferred
 27.06.17                                                                       * zc_ObjectBoolean_Juridical_LoadBarcode
 09.06.17         * zc_ObjectBoolean_GoodsByGoodsKind_NotMobile
                    zc_ObjectBoolean_Price_MCSAuto
                    zc_ObjectBoolean_Price_MCSNotRecalcOld
 14.04.17         * zc_ObjectBoolean_GoodsListIncome_Last
 20.02.17         * zc_ObjectBoolean_PersonalServiceList_Second
 20.01.17         * zc_ObjectBoolean_ReportCollation_Buh
 17.01.17         * zc_ObjectBoolean_Unit_UploadBadm
                    zc_ObjectBoolean_Goods_UploadBadm
 13.01.17         * zc_ObjectBoolean_Juridical_isLongUKTZED
 19.12.16         * zc_ObjectBoolean_Goods_SP
 14.11.16         * zc_ObjectBoolean_JuridicalSettings_BonusVirtual
 13.10.16         * add zc_ObjectBoolean_Unit_Over
 29.06.16         * add zc_ObjectBoolean_Price_TOP
 23.11.15                                                       * + zc_ObjectBoolean_Goods_IsUpload
 03.11.15                                                       * + zc_ObjectBoolean_Price_Fix
 27.10.15                                                       * + zc_ObjectBoolean_Goods_Published
 29.08.15                                                       * + zc_ObjectBoolean_Price_MCSIsClose, zc_ObjectBoolean_Price_MCSNotRecalc
 28.04.15         * add zc_ObjectBoolean_Branch_PartionDoc
 17.04.15         * add zc_ObjectBoolean_Branch_Medoc
 06.02.15         * add zc_ObjectBoolean_Partner_EdiInvoice
                        zc_ObjectBoolean_Partner_EdiInvoice
                        zc_ObjectBoolean_Partner_EdiDesadv
 12.09.14                                        * add zc_ObjectBoolean_Personal_Main and zc_ObjectBoolean_Member_Official
 09.09.14                         *
 22.05.14         * add zc_ObjectBoolean_Contract_Personal and zc_ObjectBoolean_Contract_Unique
 07.09.13                                        * add zc_ObjectBoolean_PriceList_PriceWithVAT
 20.07.13                                        * add zc_ObjectBoolean_Unit_PartionDate
 12.07.13                                        * add zc_ObjectBoolean_Goods_Partion...
 12.07.13                                        * НОВАЯ СХЕМА2
 28.06.13                                        * НОВАЯ СХЕМА
 08.07.13                         *  zc_ObjectBoolean_isLeaf
*/
