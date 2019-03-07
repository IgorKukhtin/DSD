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

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Unit_GoodsCategory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_GoodsCategory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectBoolean_Unit_GoodsCategory', 'для Ассортиментной матрицы' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Unit_GoodsCategory');

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

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_GoodsListIncome_Last() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_GoodsListIncome_Last'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsListIncome(), 'zc_ObjectBoolean_GoodsListIncome_Last', 'Признак - Вторая форма' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_GoodsListIncome_Last');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_User_ProjectMobile() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_User_ProjectMobile'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectBoolean_User_ProjectMobile', 'признак - это Торговый агент' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_User_ProjectMobile');

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

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_GlobalConst_SiteDiscount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_GlobalConst_SiteDiscount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_GlobalConst(), 'zc_ObjectBoolean_GlobalConst_SiteDiscount', ' % скидки для сайта ' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_GlobalConst_SiteDiscount');


CREATE OR REPLACE FUNCTION zc_ObjectBoolean_RecalcMCSSheduler_AllRetail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_RecalcMCSSheduler_AllRetail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_RecalcMCSSheduler(), 'zc_ObjectBoolean_RecalcMCSSheduler_AllRetail', 'Пересчет для всей сети' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_RecalcMCSSheduler_AllRetail');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_DoesNotShare() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_DoesNotShare'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_DoesNotShare', 'Не делить медикамент на кассах' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_DoesNotShare');


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.  Ярошенко Р.Ф.   Подмогильный В.В.   Шаблий О.В.
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
