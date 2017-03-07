CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Account_onComplete() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Account_onComplete'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Account(), 'zc_ObjectBoolean_Account_onComplete', 'признак Создан при проведении' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Account_onComplete');  

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Calendar_Working() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Calendar_Working'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Calendar(), 'zc_ObjectBoolean_Calendar_Working', 'Признак рабочий день' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Calendar_Working');

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



CREATE OR REPLACE FUNCTION zc_ObjectBoolean_JuridicalSettings_isPriceClose() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_JuridicalSettings_isPriceClose'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_JuridicalSettings(), 'zc_ObjectBoolean_JuridicalSettings_isPriceClose', 'закрыть прайс' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_JuridicalSettings_isPriceClose');  

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


CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_PartionDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_PartionDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Unit_PartionDate', 'Партии даты в учете' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_PartionDate');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_PartionGoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_PartionGoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Unit_PartionGoodsKind', 'Партии по виду упаковки' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_PartionGoodsKind');


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

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Retail_OperDateOrder() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Retail_OperDateOrder'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Retail(), 'zc_ObjectBoolean_Retail_OperDateOrder', 'цена по дате заявки' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Retail_OperDateOrder');

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

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
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
