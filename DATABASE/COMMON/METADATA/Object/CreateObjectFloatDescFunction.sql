 СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!
CREATE OR REPLACE FUNCTION zc_ObjectFloat_ReplServer_CountTo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReplServer_CountTo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReplServer(), 'zc_ObjectFloat_ReplServer_CountTo', 'кол-во пакетов в последней сессии при отправке в базу-Child' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReplServer_CountTo');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ReplServer_CountFrom() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReplServer_CountFrom'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReplServer(), 'zc_ObjectFloat_ReplServer_CountFrom', 'кол-во пакетов в последней сессии при получении из базы-Child' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReplServer_CountFrom');

--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_Box_Volume() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Box_Volume'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Box(), 'zc_ObjectFloat_Box_Volume', 'Объем, м3.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Box_Volume');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Box_Weight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Box_Weight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Box(), 'zc_ObjectFloat_Box_Weight', 'Вес ящика' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Box_Weight');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Box_Height() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Box_Height'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Box(), 'zc_ObjectFloat_Box_Height', 'высота' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Box_Height');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Box_Length() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Box_Length'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Box(), 'zc_ObjectFloat_Box_Length', 'длина' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Box_Length');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Box_Width() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Box_Width'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Box(), 'zc_ObjectFloat_Box_Width', 'ширина' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Box_Width');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Box_NPP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Box_NPP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Box(), 'zc_ObjectFloat_Box_NPP', 'NPP' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Box_NPP');


--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_BarCodeBox_Weight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BarCodeBox_Weight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_BarCodeBox(), 'zc_ObjectFloat_BarCodeBox_Weight', 'точный вес ящ.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BarCodeBox_Weight');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_BarCodeBox_Print() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BarCodeBox_Print'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_BarCodeBox(), 'zc_ObjectFloat_BarCodeBox_Print', 'кол-во для печати Ш/К' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BarCodeBox_Print');

--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_CardFuel_Limit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CardFuel_Limit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PersonalGroup(), 'zc_ObjectFloat_CardFuel_Limit', 'Лимит, грн' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CardFuel_Limit');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CardFuel_LimitFuel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CardFuel_LimitFuel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CardFuel(), 'zc_ObjectFloat_CardFuel_LimitFuel', 'Лимит, литры' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CardFuel_LimitFuel');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Contract_ChangePrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_ChangePrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Contract_ChangePrice', zc_Object_Contract(), 'Скидка в цене' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_ChangePrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Contract_ChangePercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_ChangePercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Contract_ChangePercent', zc_Object_Contract(), '(-)% Скидки (+)% Наценки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_ChangePercent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Contract_Term() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_Term'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Contract_Term', zc_Object_Contract(), 'Период пролонгации' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_Term');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ContractCondition_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ContractCondition_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_ContractCondition_Value', zc_Object_ContractCondition(), 'Условия договора Значение' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ContractCondition_Value');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ContractCondition_PercentRetBonus() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ContractCondition_PercentRetBonus'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_ContractCondition_PercentRetBonus', zc_Object_ContractCondition(), 'Условия договора % возврата план' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ContractCondition_PercentRetBonus');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Contract_DocumentCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_DocumentCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Contract_DocumentCount', zc_Object_Contract(), 'Количество докуметов по договору' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_DocumentCount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Contract_Percent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_Percent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectFloat_Contract_Percent', '% Корректировки наценки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_Percent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Contract_DayTaxSummary() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_DayTaxSummary'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectFloat_Contract_DayTaxSummary', 'Кол-во дней для сводной налоговой' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_DayTaxSummary');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Contract_PercentSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_PercentSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Contract_PercentSP', zc_Object_Contract(), '% скидки (СП)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_PercentSP');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Contract_OrderSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_OrderSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectFloat_Contract_OrderSumm', 'минимальная сумма для заказа' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_OrderSumm');

--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_ContractGoods_Price() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ContractGoods_Price'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_ContractGoods_Price', zc_Object_ContractGoods(), 'Цена' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ContractGoods_Price');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Fuel_Ratio() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Fuel_Ratio'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Fuel(), 'zc_ObjectFloat_Fuel_Ratio', 'Коэффициент перевода нормы' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Fuel_Ratio');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_AmountIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_AmountIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_AmountIn', 'Кол-во посл. прихода' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_AmountIn');
CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_PriceIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PriceIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_PriceIn', 'Цена посл. прихода' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PriceIn');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_Site() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_Site'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_Site', 'Ключ товара на сайте' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_Site');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_MinimumLot() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_MinimumLot'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_MinimumLot', 'Минимальная партия' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_MinimumLot');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_PercentMarkup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PercentMarkup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_PercentMarkup', '% наценки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PercentMarkup');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_Price() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_Price'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_Price', 'цена реализации' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_Price');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_ReferCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_ReferCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_ReferCode', 'Код референтной цены' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_ReferCode');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_ReferPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_ReferPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_ReferPrice', 'Референтная цена' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_ReferPrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_Weight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_Weight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_Weight', 'Вес товара' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_Weight');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_WeightTare() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_WeightTare'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_WeightTare', 'Вес втулки/тары' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_WeightTare');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_CountForWeight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_CountForWeight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_CountForWeight', 'Кол-во для веса' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_CountForWeight');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_CountReceipt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_CountReceipt'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(),'zc_ObjectFloat_Goods_CountReceipt', 'Кол-во партий для замеса' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_CountReceipt');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsPropertyValue_Amount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyValue_Amount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsPropertyValue(), 'zc_ObjectFloat_GoodsPropertyValue_Amount', 'Вес товара' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyValue_Amount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsPropertyValue_BoxCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyValue_BoxCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsPropertyValue(), 'zc_ObjectFloat_GoodsPropertyValue_BoxCount', 'Количество в ящике' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyValue_BoxCount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsPropertyValue_AmountDoc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyValue_AmountDoc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsPropertyValue(), 'zc_ObjectFloat_GoodsPropertyValue_AmountDoc', 'Количество вложение' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyValue_AmountDoc');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsPropertyValue_WeightOnBox() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyValue_WeightOnBox'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsPropertyValue(), 'zc_ObjectFloat_GoodsPropertyValue_WeightOnBox', 'количество кг. в ящ.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyValue_WeightOnBox');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsPropertyValue_CountOnBox() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyValue_CountOnBox'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsPropertyValue(), 'zc_ObjectFloat_GoodsPropertyValue_CountOnBox', 'количество ед. в ящ.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyValue_CountOnBox');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Juridical_Percent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_Percent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectFloat_Juridical_Percent', '' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_Percent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Juridical_DayTaxSummary() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_DayTaxSummary'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectFloat_Juridical_DayTaxSummary', 'Кол-во дней для сводной налоговой' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_DayTaxSummary');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Juridical_OrderSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_OrderSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectFloat_Juridical_OrderSumm', 'минимальная сумма для заказа' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_OrderSumm');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Juridical_SummOrderFinance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_SummOrderFinance'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectFloat_Juridical_SummOrderFinance', 'Лимит по сумме отсрочки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_SummOrderFinance');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Juridical_SummOrderMin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_SummOrderMin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectFloat_Juridical_SummOrderMin', 'Минимальный заказ с суммой >= ' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_SummOrderMin');



CREATE OR REPLACE FUNCTION zc_ObjectFloat_MarginCategoryItem_MinPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginCategoryItem_MinPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MarginCategoryItem(), 'zc_ObjectFloat_MarginCategoryItem_MinPrice', 'Минимальная цена' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginCategoryItem_MinPrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MarginCategoryItem_MarginPercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginCategoryItem_MarginPercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MarginCategoryItem(), 'zc_ObjectFloat_MarginCategoryItem_MarginPercent', '% наценки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginCategoryItem_MarginPercent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MarginCategory_Percent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginCategory_Percent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MarginCategory(), 'zc_ObjectFloat_MarginCategory_Percent', '% наценки Общий' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginCategory_Percent');
--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_MarginReportItem_Percent1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginReportItem_Percent1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MarginReportItem(), 'zc_ObjectFloat_MarginReportItem_Percent1', 'вирт. % для 1-ого передела' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginReportItem_Percent1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MarginReportItem_Percent2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginReportItem_Percent2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MarginReportItem(), 'zc_ObjectFloat_MarginReportItem_Percent2', 'вирт. % для 2-ого передела' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginReportItem_Percent2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MarginReportItem_Percent3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginReportItem_Percent3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MarginReportItem(), 'zc_ObjectFloat_MarginReportItem_Percent3', 'вирт. % для 3-ого передела' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginReportItem_Percent3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MarginReportItem_Percent4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginReportItem_Percent4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MarginReportItem(), 'zc_ObjectFloat_MarginReportItem_Percent4', 'вирт. % для 4-ого передела' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginReportItem_Percent4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MarginReportItem_Percent5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginReportItem_Percent5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MarginReportItem(), 'zc_ObjectFloat_MarginReportItem_Percent5', 'вирт. % для 5-ого передела' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginReportItem_Percent5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MarginReportItem_Percent6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginReportItem_Percent6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MarginReportItem(), 'zc_ObjectFloat_MarginReportItem_Percent6', 'вирт. % для 6-ого передела' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginReportItem_Percent6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MarginReportItem_Percent7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginReportItem_Percent7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MarginReportItem(), 'zc_ObjectFloat_MarginReportItem_Percent7', 'вирт. % для 7-ого передела' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginReportItem_Percent7');




CREATE OR REPLACE FUNCTION zc_ObjectFloat_ModelServiceItemMaster_MovementDesc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ModelServiceItemMaster_MovementDesc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_ModelServiceItemMaster_MovementDesc', zc_Object_ModelServiceItemMaster(), 'Код документа' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ModelServiceItemMaster_MovementDesc');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ModelServiceItemMaster_Ratio() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ModelServiceItemMaster_Ratio'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_ModelServiceItemMaster_Ratio', zc_Object_ModelServiceItemMaster(), 'Коэффициент для выбора данных' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ModelServiceItemMaster_Ratio');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionGoods_Price() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionGoods_Price'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PartionGoods_Price', zc_Object_PartionGoods(), 'Цена' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionGoods_Price');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PersonalGroup_WorkHours() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PersonalGroup_WorkHours'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PersonalGroup(), 'zc_ObjectFloat_PersonalGroup_WorkHours', 'Количество часов' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PersonalGroup_WorkHours');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Program_MajorVersion() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Program_MajorVersion'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Program_MajorVersion', zc_Object_Program(), 'Первая часть версии программы' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Program_MajorVersion');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Program_MinorVersion() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Program_MinorVersion'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Program_MinorVersion', zc_Object_Program(), 'Вторая часть версии программы' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Program_MinorVersion');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionMovement_MovementId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionMovement_MovementId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_object_PartionMovement(), 'zc_ObjectFloat_PartionMovement_MovementId', 'Ключ документа Приход от постащика в партиях накладных' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionMovement_MovementId');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionMovementItem_MovementItemId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionMovementItem_MovementItemId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_object_PartionMovementItem(), 'zc_ObjectFloat_PartionMovementItem_MovementItemId', 'Ключ элемента увеличивающего товар в партиях накладных' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionMovementItem_MovementItemId');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Partner_PrepareDayCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_PrepareDayCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Partner(), 'zc_ObjectFloat_Partner_PrepareDayCount', 'За сколько дней принимается заказ' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_PrepareDayCount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Partner_DocumentDayCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_DocumentDayCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Partner(), 'zc_ObjectFloat_Partner_DocumentDayCount', 'Через сколько дней оформляется документально' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_DocumentDayCount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Partner_GPSN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_GPSN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Partner(), 'zc_ObjectFloat_Partner_GPSN', 'GPS координаты точки доставки (широта)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_GPSN');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Partner_GPSE() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_GPSE'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Partner(), 'zc_ObjectFloat_Partner_GPSE', 'GPS координаты точки доставки (долгота)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_GPSE');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Partner_Category() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_Category'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Partner(), 'zc_ObjectFloat_Partner_Category', 'Категория ТТ' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_Category');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Partner_TaxSale_Personal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_TaxSale_Personal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Partner(), 'zc_ObjectFloat_Partner_TaxSale_Personal', 'супервайзер - % от товарооборота' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_TaxSale_Personal');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Partner_TaxSale_PersonalTrade() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_TaxSale_PersonalTrade'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Partner(), 'zc_ObjectFloat_Partner_TaxSale_PersonalTrade', 'ТП - % от товарооборота' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_TaxSale_PersonalTrade');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Partner_TaxSale_MemberSaler1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_TaxSale_MemberSaler1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Partner(), 'zc_ObjectFloat_Partner_TaxSale_MemberSaler1', 'Продавец-1 - % от товарооборота' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_TaxSale_MemberSaler1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Partner_TaxSale_MemberSaler2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_TaxSale_MemberSaler2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Partner(), 'zc_ObjectFloat_Partner_TaxSale_MemberSaler2', 'Продавец-2 - % от товарооборота' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_TaxSale_MemberSaler2');


--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_PriceList_VATPercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceList_VATPercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceList(), 'zc_ObjectFloat_PriceList_VATPercent', '% НДС' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceList_VATPercent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_RateFuel_Amount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RateFuel_Amount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_RateFuel(), 'zc_ObjectFloat_RateFuel_Amount', 'Кол-во норма на 100 км' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RateFuel_Amount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_RateFuel_AmountColdHour() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RateFuel_AmountColdHour'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_RateFuel(), 'zc_ObjectFloat_RateFuel_AmountColdHour', 'Холод, Кол-во норма в час' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RateFuel_AmountColdHour');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_RateFuel_AmountColdDistance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RateFuel_AmountColdDistance'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_RateFuel(), 'zc_ObjectFloat_RateFuel_AmountColdDistance', 'Холод, Кол-во норма на 100 км' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RateFuel_AmountColdDistance');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_RateFuelKind_Tax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RateFuelKind_Tax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_RateFuelKind(), 'zc_ObjectFloat_RateFuelKind_Tax', '% доп. расхода в связи с сезоном/температурой' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RateFuelKind_Tax');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ReceiptChild_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReceiptChild_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReceiptChild(), 'zc_ObjectFloat_ReceiptChild_Value', 'Составляющие рецептур - Значение' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReceiptChild_Value');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_Value', 'Значение (Количество)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_Value');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_ValueCost() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_ValueCost'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_ValueCost', 'Значение затрат(Количество)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_ValueCost');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_TaxExit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TaxExit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_TaxExit', ' % выхода' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TaxExit');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_TaxExitCheck() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TaxExitCheck'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_TaxExitCheck', ' % выхода (проверка ГП)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TaxExitCheck');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_TaxLoss() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TaxLoss'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_TaxLoss', ' % потерь' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TaxLoss');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_PartionValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_PartionValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_PartionValue', 'Количество в партии (количество в кутере)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_PartionValue');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_PartionCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_PartionCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_PartionCount', 'Минимальное количество партий' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_PartionCount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_WeightPackage() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_WeightPackage'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_WeightPackage', 'Вес упаковки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_WeightPackage');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_TotalWeightMain() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TotalWeightMain'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_TotalWeightMain', 'Итого вес основного сырья' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TotalWeightMain');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_TotalWeight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TotalWeight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_TotalWeight', 'Итого вес закладки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TotalWeight');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_TaxLossCEH() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TaxLossCEH'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_TaxLossCEH', ' потерь(цех)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TaxLossCEH');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_TaxLossTRM() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TaxLossTRM'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_TaxLossTRM', '% потерь (термичка)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TaxLossTRM');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_TaxLossVPR() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TaxLossVPR'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_TaxLossVPR', '% вприска' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TaxLossVPR');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_RealDelicShp() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_RealDelicShp'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_RealDelicShp', 'Вес после шприцевания' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_RealDelicShp');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_ValuePF() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_ValuePF'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_ValuePF', '***Вес П/Ф (ГП)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_ValuePF');




CREATE OR REPLACE FUNCTION zc_ObjectFloat_StaffList_HoursPlan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StaffList_HoursPlan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_StaffList(), 'zc_ObjectFloat_StaffList_HoursPlan', 'План счетов' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StaffList_HoursPlan');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StaffList_HoursDay() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StaffList_HoursDay'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_StaffList(), 'zc_ObjectFloat_StaffList_HoursDay', 'План счетов' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StaffList_HoursDay');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StaffList_PersonalCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StaffList_PersonalCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_StaffList(), 'zc_ObjectFloat_StaffList_PersonalCount', 'Кол. человек' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StaffList_PersonalCount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StaffListCost_Price() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StaffListCost_Price'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StaffListCost_Price', zc_Object_StaffListCost(), 'Расценка грн./кг.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StaffListCost_Price');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StaffListSumm_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StaffListSumm_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StaffListSumm_Value', zc_Object_StaffListSumm(), 'Сумма, грн' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StaffListSumm_Value');

-- CREATE OR REPLACE FUNCTION zc_ObjectFloat_Document_MovementId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Document_MovementId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
--  SELECT 'zc_ObjectFloat_Document_MovementId', zc_Object_Document(), 'ссылка на документ' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Document_MovementId');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderType_Koeff1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderType_Koeff1', zc_Object_OrderType(), 'Коэффициент сезонности' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderType_Koeff2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderType_Koeff2', zc_Object_OrderType(), 'Коэффициент сезонности' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderType_Koeff3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderType_Koeff3', zc_Object_OrderType(), 'Коэффициент сезонности' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderType_Koeff4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderType_Koeff4', zc_Object_OrderType(), 'Коэффициент сезонности' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderType_Koeff5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderType_Koeff5', zc_Object_OrderType(), 'Коэффициент сезонности' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderType_Koeff6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderType_Koeff6', zc_Object_OrderType(), 'Коэффициент сезонности' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderType_Koeff7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderType_Koeff7', zc_Object_OrderType(), 'Коэффициент сезонности' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff7');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderType_Koeff8() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff8'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderType_Koeff8', zc_Object_OrderType(), 'Коэффициент сезонности' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff8');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderType_Koeff9() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff9'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderType_Koeff9', zc_Object_OrderType(), 'Коэффициент сезонности' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff9');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderType_Koeff10() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff10'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderType_Koeff10', zc_Object_OrderType(), 'Коэффициент сезонности' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff10');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderType_Koeff11() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff11'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderType_Koeff11', zc_Object_OrderType(), 'Коэффициент сезонности' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff11');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderType_Koeff12() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff12'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderType_Koeff12', zc_Object_OrderType(), 'Коэффициент сезонности' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff12');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderType_TermProduction() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_TermProduction'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderType_TermProduction', zc_Object_OrderType(), 'Срок производства' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_TermProduction');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderType_NormInDays() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_NormInDays'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderType_NormInDays', zc_Object_OrderType(), 'Норма в днях' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_NormInDays');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderType_StartProductionInDays() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_StartProductionInDays'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderType_StartProductionInDays', zc_Object_OrderType(), 'Через сколько дней после заявки начинается производство' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_StartProductionInDays');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_WeightPackage() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_WeightPackage'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_WeightPackage', 'Вес пакета' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_WeightPackage');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_WeightTotal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_WeightTotal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_WeightTotal', 'Вес упаковки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_WeightTotal');

  CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_ChangePercentAmount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_ChangePercentAmount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_ChangePercentAmount', '% скидки для кол-ва' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_ChangePercentAmount');

  CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_WeightPackageSticker() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_WeightPackageSticker'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_WeightPackageSticker', 'вес 1-ого пакета' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_WeightPackageSticker');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_WeightMin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_WeightMin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_WeightMin', 'минимальный вес' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_WeightMin');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_WeightMax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_WeightMax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_WeightMax', 'максимальный вес' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_WeightMax');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_Height() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Height'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_Height', ' высота' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Height');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_Length() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Length'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_Length', 'длинна' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Length');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_Width() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Width'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_Width', 'ширина' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Width');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_NormInDays() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_NormInDays'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_NormInDays', 'срок годности в днях' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_NormInDays');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_WmsCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_WmsCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_WmsCode', 'Код ВМС - Integer' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_WmsCode');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_WmsCellNum() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_WmsCellNum'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_WmsCellNum', '№ Ячейки на складе ВМС - Integer' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_WmsCellNum');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_Avg_Sh() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Avg_Sh'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_Avg_Sh', 'средний вес Категория товара "Штучный"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Avg_Sh');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_Avg_Nom() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Avg_Nom'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_Avg_Nom', 'средний вес Категория товара "Номинальный"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Avg_Nom');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_Avg_Ves() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Avg_Ves'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_Avg_Ves', 'средний вес Категория товара "Неноминальный"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Avg_Ves');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_Tax_Sh() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Tax_Sh'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_Tax_Sh', '% отклонения Категория товара "Штучный"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Tax_Sh');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_Tax_Nom() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Tax_Nom'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_Tax_Nom', '% отклонения Категория товара "Номинальный"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Tax_Nom');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_Tax_Ves() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Tax_Ves'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_Tax_Ves', '% отклонения Категория товара "Неноминальный"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Tax_Ves');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_DaysQ() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_DaysQ'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_DaysQ', 'Изменение Даты произв в качественном' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_DaysQ');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_NormRem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_NormRem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_NormRem', 'нормативные остатки, тон' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_NormRem');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_NormOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_NormOut'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_NormOut', ' нормативное потребление в месяц, тон' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_NormOut');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_NormPack() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_NormPack'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_NormPack', 'нормы упаковывания (в кг/час)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_NormPack');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_PackLimit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_PackLimit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_PackLimit', 'Ограничение в днях в заявке на упак' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_PackLimit');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_WeightPackageKorob() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_WeightPackageKorob'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_WeightPackageKorob', 'вес 1-ого пакета (для коробки)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_WeightPackageKorob');


--

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Quality_NumberPrint() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Quality_NumberPrint'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Quality(), 'zc_ObjectFloat_Quality_NumberPrint', 'номер печати' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Quality_NumberPrint');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Member_Limit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Member_Limit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectFloat_Member_Limit', 'Лимит, грн' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Member_Limit');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Member_LimitDistance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Member_LimitDistance'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectFloat_Member_LimitDistance', 'Лимит, км' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Member_LimitDistance');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Member_Summer() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Member_Summer'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectFloat_Member_Summer', 'Лимит, грн' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Member_Summer');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Member_Winter() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Member_Winter'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectFloat_Member_Winter', 'Лимит, литры' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Member_Winter');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Member_Reparation() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Member_Reparation'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectFloat_Member_Reparation', 'Лимит, литры' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Member_Reparation');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Member_ScalePSW() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Member_ScalePSW'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(),'zc_ObjectFloat_Member_ScalePSW', 'пароль для подтверждения в Scale' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Member_ScalePSW');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Founder_Limit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Founder_Limit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Founder(), 'zc_ObjectFloat_Founder_Limit', 'Лимит, грн' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Founder_Limit');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_ImportSettings_Time() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ImportSettings_Time'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ImportSettings(), 'zc_ObjectFloat_ImportSettings_Time', 'Периодичность проверки почты в активном периоде, мин' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ImportSettings_Time');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Route_RateSumma() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Route_RateSumma'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Route(), 'zc_ObjectFloat_Route_RateSumma', 'Сумма коммандировочных' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Route_RateSumma');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Route_RatePrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Route_RatePrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Route(), 'zc_ObjectFloat_Route_RatePrice', 'Ставка грн/км (дальнобойные)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Route_RatePrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Route_RateSummaAdd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Route_RateSummaAdd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Route(), 'zc_ObjectFloat_Route_RateSummaAdd', 'Сумма доплата (дальнобойные)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Route_RateSummaAdd');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Route_RateSummaExp() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Route_RateSummaExp'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Route(), 'zc_ObjectFloat_Route_RateSummaExp', 'Сумма командировочных экспедитору' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Route_RateSummaExp');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Route_TimePrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Route_TimePrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Route(), 'zc_ObjectFloat_Route_TimePrice', 'Ставка грн/ч (коммандировочные)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Route_TimePrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_SignInternal_MovementDesc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SignInternal_MovementDesc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_SignInternal(), 'zc_ObjectFloat_SignInternal_MovementDesc', 'Вид документа' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SignInternal_MovementDesc');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_SignInternal_ObjectDesc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SignInternal_ObjectDesc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_SignInternal(), 'zc_ObjectFloat_SignInternal_ObjectDesc', 'Вид справочника' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SignInternal_ObjectDesc');

--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_MobileTariff_Monthly() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileTariff_Monthly'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MobileTariff(), 'zc_ObjectFloat_MobileTariff_Monthly', 'Ежемесячная абонплата' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileTariff_Monthly');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MobileTariff_PocketMinutes() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileTariff_PocketMinutes'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MobileTariff(), 'zc_ObjectFloat_MobileTariff_PocketMinutes', 'Количество минут в пакете' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileTariff_PocketMinutes');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MobileTariff_PocketSMS() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileTariff_PocketSMS'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MobileTariff(), 'zc_ObjectFloat_MobileTariff_PocketSMS', 'Количество смс в пакете' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileTariff_PocketSMS');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MobileTariff_PocketInet() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileTariff_PocketInet'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MobileTariff(), 'zc_ObjectFloat_MobileTariff_PocketInet', 'Количество МБ интернета в пакете' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileTariff_PocketInet');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MobileTariff_CostSMS() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileTariff_CostSMS'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MobileTariff(), 'zc_ObjectFloat_MobileTariff_CostSMS', 'Стоимость СМС вне пакета' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileTariff_CostSMS');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MobileTariff_CostInet() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileTariff_CostInet'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MobileTariff(), 'zc_ObjectFloat_MobileTariff_CostInet', 'Стоимость 1 МБ интернета вне пакета' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileTariff_CostInet');



CREATE OR REPLACE FUNCTION zc_ObjectFloat_MobileTariff_CostMinutes() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileTariff_CostMinutes'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MobileTariff(), 'zc_ObjectFloat_MobileTariff_CostMinutes', 'Стоимость 1 минуты вне пакета' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileTariff_CostMinutes');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MobileEmployee_Limit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileEmployee_Limit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MobileEmployee(), 'zc_ObjectFloat_MobileEmployee_Limit', 'Лимит' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileEmployee_Limit');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MobileEmployee_Dutylimit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileEmployee_Dutylimit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MobileEmployee(), 'zc_ObjectFloat_MobileEmployee_Dutylimit', 'Служебный лимит' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileEmployee_Dutylimit');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MobileEmployee_Navigator() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileEmployee_Navigator'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MobileEmployee(), 'zc_ObjectFloat_MobileEmployee_Navigator', 'Услуга Навигатор' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileEmployee_Navigator');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsListSale_Amount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsListSale_Amount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsListSale(), 'zc_ObjectFloat_GoodsListSale_Amount', 'Кол-во в реализации' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsListSale_Amount');
CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsListSale_AmountChoice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsListSale_AmountChoice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsListSale(), 'zc_ObjectFloat_GoodsListSale_AmountChoice', 'Кол-во в реализации для МАКС' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsListSale_AmountChoice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsListIncome_Amount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsListIncome_Amount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsListIncome(), 'zc_ObjectFloat_GoodsListIncome_Amount', 'Кол-во' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsListIncome_Amount');
CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsListIncome_AmountChoice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsListIncome_AmountChoice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsListIncome(), 'zc_ObjectFloat_GoodsListIncome_AmountChoice', 'Кол-во для МАКС' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsListIncome_AmountChoice');

--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsTag_ColorReport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsTag_ColorReport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsTag(), 'zc_ObjectFloat_GoodsTag_ColorReport', 'Цвет текста в "отчет по отгрузке"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsTag_ColorReport');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsTag_ColorBgReport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsTag_ColorBgReport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsTag(), 'zc_ObjectFloat_GoodsTag_ColorBgReport', 'Цвет фона в "отчете по отгрузке"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsTag_ColorBgReport');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_TradeMark_ColorReport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_TradeMark_ColorReport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_TradeMark(), 'zc_ObjectFloat_TradeMark_ColorReport', 'Цвет текста в "отчет по отгрузке"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_TradeMark_ColorReport');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_TradeMark_ColorBgReport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_TradeMark_ColorBgReport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_TradeMark(), 'zc_ObjectFloat_TradeMark_ColorBgReport', 'Цвет фона в "отчете по отгрузке"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_TradeMark_ColorBgReport');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MobileConst_OperDateDiff() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileConst_OperDateDiff'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_MobileConst_OperDateDiff', zc_Object_MobileConst(), 'На сколько дней позже создавать док Возврат и Приход денег' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileConst_OperDateDiff');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MobileConst_ReturnDayCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileConst_ReturnDayCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_MobileConst_ReturnDayCount', zc_Object_MobileConst(), 'Сколько дней принимаются возвраты по старым ценам' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileConst_ReturnDayCount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MobileConst_CriticalOverDays() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileConst_CriticalOverDays'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_MobileConst_CriticalOverDays', zc_Object_MobileConst(), 'Количество дней просрочки, после которого формирование заявки невозможно' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileConst_CriticalOverDays');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MobileConst_CriticalDebtSum() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileConst_CriticalDebtSum'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_MobileConst_CriticalDebtSum', zc_Object_MobileConst(), 'Сумма долга, после которого формирование заявки невозможно' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileConst_CriticalDebtSum');

-- Sticker
CREATE OR REPLACE FUNCTION zc_ObjectFloat_Sticker_Value1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Sticker_Value1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Sticker_Value1', zc_Object_Sticker(), 'углеводи не больше' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Sticker_Value1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Sticker_Value2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Sticker_Value2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Sticker_Value2', zc_Object_Sticker(), 'белки не меньше' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Sticker_Value2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Sticker_Value3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Sticker_Value3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Sticker_Value3', zc_Object_Sticker(), 'жири не больше' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Sticker_Value3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Sticker_Value4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Sticker_Value4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Sticker_Value4', zc_Object_Sticker(), 'кКалор' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Sticker_Value4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Sticker_Value5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Sticker_Value5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Sticker_Value5', zc_Object_Sticker(), 'кДж' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Sticker_Value5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Sticker_Value6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Sticker_Value6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Sticker_Value6', zc_Object_Sticker(), 'з них насичені (жири)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Sticker_Value6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Sticker_Value7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Sticker_Value7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Sticker_Value7', zc_Object_Sticker(), 'цукри' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Sticker_Value7');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Sticker_Value8() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Sticker_Value8'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Sticker_Value8', zc_Object_Sticker(), 'сіль ' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Sticker_Value8');

-- StickerFile
CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width1', zc_Object_StickerFile(), 'Ширина 1-ой строки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width2', zc_Object_StickerFile(), 'Ширина 2-ой строки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width3', zc_Object_StickerFile(), 'Ширина 3-ой строки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width4', zc_Object_StickerFile(), 'Ширина 4-ой строки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width5', zc_Object_StickerFile(), 'Ширина 5-ой строки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width6', zc_Object_StickerFile(), 'Ширина 6-ой строки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width7', zc_Object_StickerFile(), 'Ширина 7-ой строки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width7');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width8() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width8'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width8', zc_Object_StickerFile(), 'Ширина 8-ой строки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width8');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width9() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width9'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width9', zc_Object_StickerFile(), 'Ширина 9-ой строки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width9');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width10() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width10'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width10', zc_Object_StickerFile(), 'Ширина 10-ой строки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width10');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Level1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Level1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Level1', zc_Object_StickerFile(), 'Ширина Level1' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Level1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Level2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Level2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Level2', zc_Object_StickerFile(), 'Ширина Level2' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Level2');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Left1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Left1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Left1', zc_Object_StickerFile(), 'Сколько пробелов слева для 1-ой Главной строки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Left1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Left2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Left2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Left2', zc_Object_StickerFile(), 'Сколько пробелов слева для остальных, начиная со 2-ой' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Left2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width1_70_70() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width1_70_70'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width1_70_70', zc_Object_StickerFile(), 'Ширина 1-ой строки 70*70' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width1_70_70');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width2_70_70() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width2_70_70'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width2_70_70', zc_Object_StickerFile(), 'Ширина 2-ой строки 70*70' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width2_70_70');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width3_70_70() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width3_70_70'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width3_70_70', zc_Object_StickerFile(), 'Ширина 3-ой строки 70*70' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width3_70_70');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width4_70_70() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width4_70_70'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width4_70_70', zc_Object_StickerFile(), 'Ширина 4-ой строки 70*70' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width4_70_70');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width5_70_70() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width5_70_70'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width5_70_70', zc_Object_StickerFile(), 'Ширина 5-ой строки 70*70' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width5_70_70');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width6_70_70() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width6_70_70'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width6_70_70', zc_Object_StickerFile(), 'Ширина 6-ой строки 70*70' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width6_70_70');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width7_70_70() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width7_70_70'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width7_70_70', zc_Object_StickerFile(), 'Ширина 7-ой строки 70*70' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width7_70_70');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width8_70_70() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width8_70_70'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width8_70_70', zc_Object_StickerFile(), 'Ширина 8-ой строки 70*70' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width8_70_70');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width9_70_70() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width9_70_70'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width9_70_70', zc_Object_StickerFile(), 'Ширина 9-ой строки 70*70' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width9_70_70');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width10_70_70() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width10_70_70'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width10_70_70', zc_Object_StickerFile(), 'Ширина 10-ой строки 70*70' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width10_70_70');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Level1_70_70() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Level1_70_70'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Level1_70_70', zc_Object_StickerFile(), 'Ширина Level1 70*70' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Level1_70_70');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Level2_70_70() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Level2_70_70'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Level2_70_70', zc_Object_StickerFile(), 'Ширина Level2 70*70' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Level2_70_70');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Left1_70_70() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Left1_70_70'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Left1_70_70', zc_Object_StickerFile(), 'Сколько пробелов слева для 1-ой Главной строки 70*70' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Left1_70_70');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Left2_70_70() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Left2_70_70'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Left2_70_70', zc_Object_StickerFile(), 'Сколько пробелов слева для остальных, начиная со 2-ой 70*70' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Left2_70_70');



-- StickerProperty
CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerProperty_Value1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerProperty_Value1', zc_Object_StickerProperty(), 'вологість мін' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerProperty_Value2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerProperty_Value2', zc_Object_StickerProperty(), 'вологість макс' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerProperty_Value3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerProperty_Value3', zc_Object_StickerProperty(), 'Т мін' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerProperty_Value4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerProperty_Value4', zc_Object_StickerProperty(), 'Т макс' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerProperty_Value5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerProperty_Value5', zc_Object_StickerProperty(), 'кількість діб' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerProperty_Value6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerProperty_Value6', zc_Object_StickerProperty(), 'вес' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerProperty_Value7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerProperty_Value7', zc_Object_StickerProperty(), '% отклонения' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value7');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerProperty_Value8() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value8'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerProperty_Value8', zc_Object_StickerProperty(), ' Т мін - второй срок ' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value8');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerProperty_Value9() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value9'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerProperty_Value9', zc_Object_StickerProperty(), 'Т макс - второй срок' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value9');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerProperty_Value10() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value10'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerProperty_Value10', zc_Object_StickerProperty(), 'кількість діб - второй срок' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value10');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerProperty_Value11() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value11'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerProperty_Value11', zc_Object_StickerProperty(), 'вложенность' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value11');

-- GoodsReportSale
CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Amount1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Amount1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Amount1', zc_Object_GoodsReportSale(), 'Кол-во в реализации без Акциий за пн.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Amount1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Amount2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Amount2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Amount2', zc_Object_GoodsReportSale(), 'Кол-во в реализации без Акциий за вт.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Amount2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Amount3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Amount3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Amount3', zc_Object_GoodsReportSale(), 'Кол-во в реализации без Акциий за ср.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Amount3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Amount4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Amount4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Amount4', zc_Object_GoodsReportSale(), 'Кол-во в реализации без Акциий за чт.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Amount4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Amount5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Amount5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Amount5', zc_Object_GoodsReportSale(), 'Кол-во в реализации без Акциий за пт.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Amount5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Amount6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Amount6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Amount6', zc_Object_GoodsReportSale(), 'Кол-во в реализации без Акциий за сб.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Amount6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Amount7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Amount7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Amount7', zc_Object_GoodsReportSale(), 'Кол-во в реализации без Акциий за вс.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Amount7');
--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Promo1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Promo1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Promo1', zc_Object_GoodsReportSale(), 'Кол-во в реализации только Акции за пн.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Promo1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Promo2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Promo2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Promo2', zc_Object_GoodsReportSale(), 'Кол-во в реализации только Акции за вт.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Promo2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Promo3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Promo3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Promo3', zc_Object_GoodsReportSale(), 'Кол-во в реализации только Акции за ср.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Promo3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Promo4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Promo4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Promo4', zc_Object_GoodsReportSale(), 'Кол-во в реализации только Акции за чт.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Promo4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Promo5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Promo5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Promo5', zc_Object_GoodsReportSale(), 'Кол-во в реализации только Акции за пт.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Promo5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Promo6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Promo6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Promo6', zc_Object_GoodsReportSale(), 'Кол-во в реализации только Акции за сб.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Promo6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Promo7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Promo7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Promo7', zc_Object_GoodsReportSale(), 'Кол-во в реализации только Акции за вс.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Promo7');

--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Branch1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Branch1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Branch1', zc_Object_GoodsReportSale(), 'Кол-во в перемещении по цене только расход на филиал за пн.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Branch1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Branch2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Branch2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Branch2', zc_Object_GoodsReportSale(), 'Кол-во в перемещении по цене только расход на филиал за вт.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Branch2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Branch3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Branch3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Branch3', zc_Object_GoodsReportSale(), 'Кол-во в перемещении по цене только расход на филиал за ср.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Branch3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Branch4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Branch4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Branch4', zc_Object_GoodsReportSale(), 'Кол-во в перемещении по цене только расход на филиал за чт.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Branch4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Branch5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Branch5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Branch5', zc_Object_GoodsReportSale(), 'Кол-во в перемещении по цене только расход на филиал за пт.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Branch5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Branch6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Branch6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Branch6', zc_Object_GoodsReportSale(), 'Кол-во в перемещении по цене только расход на филиал за сб.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Branch6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Branch7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Branch7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Branch7', zc_Object_GoodsReportSale(), 'Кол-во в перемещении по цене только расход на филиал за вс.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Branch7');
--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Order1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Order1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Order1', zc_Object_GoodsReportSale(), 'Кол-во в заявках без Акциий за пн.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Order1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Order2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Order2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Order2', zc_Object_GoodsReportSale(), 'Кол-во в заявках без Акциий за вт.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Order2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Order3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Order3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Order3', zc_Object_GoodsReportSale(), 'Кол-во в заявках без Акциий за ср.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Order3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Order4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Order4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Order4', zc_Object_GoodsReportSale(), 'Кол-во в заявках без Акциий за чт.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Order4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Order5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Order5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Order5', zc_Object_GoodsReportSale(), 'Кол-во в заявках без Акциий за пт.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Order5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Order6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Order6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Order6', zc_Object_GoodsReportSale(), 'Кол-во в заявках без Акциий за сб.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Order6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Order7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Order7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Order7', zc_Object_GoodsReportSale(), 'Кол-во в заявках без Акциий за вс.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Order7');
--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_OrderPromo1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderPromo1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_OrderPromo1', zc_Object_GoodsReportSale(), 'Кол-во в заявках только Акции за пн.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderPromo1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_OrderPromo2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderPromo2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_OrderPromo2', zc_Object_GoodsReportSale(), 'Кол-во в заявках только Акции за вт.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderPromo2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_OrderPromo3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderPromo3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_OrderPromo3', zc_Object_GoodsReportSale(), 'Кол-во в заявках только Акции за ср.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderPromo3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_OrderPromo4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderPromo4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_OrderPromo4', zc_Object_GoodsReportSale(), 'Кол-во в заявках только Акции за чт.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderPromo4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_OrderPromo5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderPromo5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_OrderPromo5', zc_Object_GoodsReportSale(), 'Кол-во в заявках только Акции за пт.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderPromo5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_OrderPromo6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderPromo6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_OrderPromo6', zc_Object_GoodsReportSale(), 'Кол-во в заявках только Акции за сб.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderPromo6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_OrderPromo7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderPromo7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_OrderPromo7', zc_Object_GoodsReportSale(), 'Кол-во в заявках только Акции за вс.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderPromo7');
--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_OrderBranch1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderBranch1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_OrderBranch1', zc_Object_GoodsReportSale(), 'Кол-во в заявках только ФИЛИАЛ за пн.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderBranch1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_OrderBranch2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderBranch2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_OrderBranch2', zc_Object_GoodsReportSale(), 'Кол-во в заявках только ФИЛИАЛ за вт.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderBranch2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_OrderBranch3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderBranch3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_OrderBranch3', zc_Object_GoodsReportSale(), 'Кол-во в заявках только ФИЛИАЛ за ср.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderBranch3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_OrderBranch4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderBranch4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_OrderBranch4', zc_Object_GoodsReportSale(), 'Кол-во в заявках только ФИЛИАЛ за чт.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderBranch4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_OrderBranch5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderBranch5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_OrderBranch5', zc_Object_GoodsReportSale(), 'Кол-во в заявках только ФИЛИАЛ за пт.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderBranch5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_OrderBranch6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderBranch6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_OrderBranch6', zc_Object_GoodsReportSale(), 'Кол-во в заявках только ФИЛИАЛ за сб.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderBranch6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_OrderBranch7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderBranch7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_OrderBranch7', zc_Object_GoodsReportSale(), 'Кол-во в заявках только ФИЛИАЛ за вс.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderBranch7');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSaleInf_Week() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSaleInf_Week'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSaleInf_Week', zc_Object_GoodsReportSaleInf(), 'Кол-во недель в Статистике' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSaleInf_Week');


--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_PromoPlan1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoPlan1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_PromoPlan1', zc_Object_GoodsReportSale(), 'Кол-во план в реализации только Акции за пн.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoPlan1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_PromoPlan2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoPlan2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_PromoPlan2', zc_Object_GoodsReportSale(), 'Кол-во план в реализации только Акции за вт.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoPlan2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_PromoPlan3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoPlan3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_PromoPlan3', zc_Object_GoodsReportSale(), 'Кол-во план в реализации только Акции за ср.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoPlan3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_PromoPlan4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoPlan4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_PromoPlan4', zc_Object_GoodsReportSale(), 'Кол-во план в реализации только Акции за чт.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoPlan4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_PromoPlan5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoPlan5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_PromoPlan5', zc_Object_GoodsReportSale(), 'Кол-во план в реализации только Акции за пт.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoPlan5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_PromoPlan6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoPlan6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_PromoPlan6', zc_Object_GoodsReportSale(), 'Кол-во план в реализации только Акции за сб.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoPlan6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_PromoPlan7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoPlan7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_PromoPlan7', zc_Object_GoodsReportSale(), 'Кол-во план в реализации только Акции за вс.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoPlan7');

--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_PromoBranchPlan1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan1', zc_Object_GoodsReportSale(), 'Кол-во план в расходе на филиал только Акции за пн.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_PromoBranchPlan2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan2', zc_Object_GoodsReportSale(), 'Кол-во план в расходе на филиал только Акции за вт.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_PromoBranchPlan3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan3', zc_Object_GoodsReportSale(), 'Кол-во план в расходе на филиал только Акции за ср.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_PromoBranchPlan4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan4', zc_Object_GoodsReportSale(), 'Кол-во план в расходе на филиал только Акции за чт.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_PromoBranchPlan5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan5', zc_Object_GoodsReportSale(), 'Кол-во план в расходе на филиал только Акции за пт.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_PromoBranchPlan6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan6', zc_Object_GoodsReportSale(), 'Кол-во план в расходе на филиал только Акции за сб.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_PromoBranchPlan7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan7', zc_Object_GoodsReportSale(), 'Кол-во план в расходе на филиал только Акции за вс.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan7');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_WorkTimeKind_Tax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_WorkTimeKind_Tax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_WorkTimeKind_Tax', zc_Object_WorkTimeKind(), '% изменения рабочих часов' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_WorkTimeKind_Tax');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_WorkTimeKind_Summ() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_WorkTimeKind_Summ'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_WorkTimeKind_Summ', zc_Object_WorkTimeKind(), 'Сумма в грн за этот рабочий день' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_WorkTimeKind_Summ');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ReportCollation_StartRemainsRep() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReportCollation_StartRemainsRep'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_ReportCollation_StartRemainsRep', zc_Object_ReportCollation(), 'нач. сальдо по данным Отчета' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReportCollation_StartRemainsRep');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ReportCollation_EndRemainsRep() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReportCollation_EndRemainsRep'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_ReportCollation_EndRemainsRep', zc_Object_ReportCollation(), 'кон. сальдо по данным Отчета' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReportCollation_EndRemainsRep');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ReportCollation_StartRemains() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReportCollation_StartRemains'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_ReportCollation_StartRemains', zc_Object_ReportCollation(), 'нач. сальдо по данным Контрагента' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReportCollation_StartRemains');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ReportCollation_EndRemains() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReportCollation_EndRemains'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_ReportCollation_EndRemains', zc_Object_ReportCollation(), 'кон. сальдо по данным Контрагента' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReportCollation_EndRemains');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ReportCollation_StartRemainsCalc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReportCollation_StartRemainsCalc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_ReportCollation_StartRemainsCalc', zc_Object_ReportCollation(), 'нач. сальдо по данным Отчета' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReportCollation_StartRemainsCalc');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ReportCollation_EndRemainsCalc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReportCollation_EndRemainsCalc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_ReportCollation_EndRemainsCalc', zc_Object_ReportCollation(), 'кон. сальдо по данным Отчета' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReportCollation_EndRemainsCalc');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_JuridicalOrderFinance_SummOrderFinance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_JuridicalOrderFinance_SummOrderFinance'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_JuridicalOrderFinance_SummOrderFinance', zc_Object_JuridicalOrderFinance(), 'Лимит по сумме отсрочки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_JuridicalOrderFinance_SummOrderFinance');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Car_KoeffHoursWork() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Car_KoeffHoursWork'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Car_KoeffHoursWork', zc_Object_Car(), 'коэфф. для модели Рабочее время из путевого листа' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Car_KoeffHoursWork');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Car_PartnerMin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Car_PartnerMin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Car_PartnerMin', zc_Object_Car(), 'Кол-во минут на ТТ' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Car_PartnerMin');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Car_Length() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Car_Length'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Car_Length', zc_Object_Car(), 'Длина' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Car_Length');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Car_Width() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Car_Width'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Car_Width', zc_Object_Car(), 'ширина' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Car_Width');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Car_Height() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Car_Height'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Car_Height', zc_Object_Car(), 'высота' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Car_Height');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Car_Weight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Car_Weight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Car_Weight', zc_Object_Car(), 'Вес авто' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Car_Weight');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Car_Year() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Car_Year'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Car_Year', zc_Object_Car(), 'Год выпуска' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Car_Year');

--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_CarExternal_Length() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CarExternal_Length'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_CarExternal_Length', zc_Object_CarExternal(), 'Длина' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CarExternal_Length');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CarExternal_Width() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CarExternal_Width'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_CarExternal_Width', zc_Object_CarExternal(), 'ширина' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CarExternal_Width');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CarExternal_Height() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CarExternal_Height'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_CarExternal_Height', zc_Object_CarExternal(), 'высота' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CarExternal_Height');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CarExternal_Weight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CarExternal_Weight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_CarExternal_Weight', zc_Object_CarExternal(), 'Вес авто' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CarExternal_Weight');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CarExternal_Year() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CarExternal_Year'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_CarExternal_Year', zc_Object_CarExternal(), 'Год выпуска' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CarExternal_Year');

--

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PersonalServiceList_Compensation() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PersonalServiceList_Compensation'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PersonalServiceList_Compensation', zc_Object_PersonalServiceList(), 'В каком месяце начисляется компенсация' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PersonalServiceList_Compensation');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PersonalServiceList_KoeffSummCardSecond() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PersonalServiceList_KoeffSummCardSecond'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PersonalServiceList_KoeffSummCardSecond', zc_Object_PersonalServiceList(), 'Коэфф для выгрузки ведомости Банк 2ф.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PersonalServiceList_KoeffSummCardSecond');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PersonalServiceList_SummAvance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PersonalServiceList_SummAvance'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PersonalServiceList_SummAvance', zc_Object_PersonalServiceList(), 'Сумма аванс(авто)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PersonalServiceList_SummAvance');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PersonalServiceList_SummAvanceMax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PersonalServiceList_SummAvanceMax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PersonalServiceList_SummAvanceMax', zc_Object_PersonalServiceList(), 'Макс Сумма аванс(ввод)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PersonalServiceList_SummAvanceMax');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PersonalServiceList_HourAvance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PersonalServiceList_HourAvance'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PersonalServiceList_HourAvance', zc_Object_PersonalServiceList(), 'Кол-во часов для аванс(авто)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PersonalServiceList_HourAvance');



CREATE OR REPLACE FUNCTION zc_ObjectFloat_MemberMinus_TotalSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MemberMinus_TotalSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_MemberMinus_TotalSumm', zc_Object_MemberMinus(), 'Сумма Итого' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MemberMinus_TotalSumm');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MemberMinus_Summ() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MemberMinus_Summ'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_MemberMinus_Summ', zc_Object_MemberMinus(), 'Сумма к удержанию ежемесячно' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MemberMinus_Summ');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MemberMinus_Tax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MemberMinus_Tax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_MemberMinus_Tax', zc_Object_MemberMinus(), '% удержания' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MemberMinus_Tax');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderPeriodKind_Week() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderPeriodKind_Week'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderPeriodKind_Week', zc_Object_WorkTimeKind(), 'Кол-во недель' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderPeriodKind_Week');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Reason_PeriodDays() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Reason_PeriodDays'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Reason_PeriodDays', zc_Object_Reason(), 'Период в дн. от "Срок годности"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Reason_PeriodDays');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Reason_PeriodTax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Reason_PeriodTax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Reason_PeriodTax', zc_Object_Reason(), 'Период в % от "Срок годности"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Reason_PeriodTax');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_JuridicalDefermentPayment_Amount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_JuridicalDefermentPayment_Amount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_JuridicalDefermentPayment_Amount', zc_Object_JuridicalDefermentPayment(), 'Сумма последней оплаты' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_JuridicalDefermentPayment_Amount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_JuridicalDefermentPayment_AmountIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_JuridicalDefermentPayment_AmountIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_JuridicalDefermentPayment_AmountIn', zc_Object_JuridicalDefermentPayment(), 'Сумма последнего прихода' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_JuridicalDefermentPayment_AmountIn');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_ObjectCode_Basis() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ObjectCode_Basis'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_ObjectCode_Basis', zc_Object_Goods(), 'Код АЛАН' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ObjectCode_Basis');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderCarInfo_OperDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderCarInfo_OperDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderCarInfo_OperDate', zc_Object_OrderCarInfo(), 'День недели заказ' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderCarInfo_OperDate');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderCarInfo_OperDatePartner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderCarInfo_OperDatePartner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderCarInfo_OperDatePartner', zc_Object_OrderCarInfo(), 'День отгрузка контрагенту' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderCarInfo_OperDatePartner');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderCarInfo_Days() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderCarInfo_Days'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderCarInfo_Days', zc_Object_OrderCarInfo(), 'Изменение в днях для дата/время отгрузки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderCarInfo_Days');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderCarInfo_Hour() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderCarInfo_Hour'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderCarInfo_Hour', zc_Object_OrderCarInfo(), 'Часы, Время отгрузки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderCarInfo_Hour');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderCarInfo_Min() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderCarInfo_Min'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderCarInfo_Min', zc_Object_OrderCarInfo(), 'Минуты, Время отгрузки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderCarInfo_Min');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionCell_Level() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionCell_Level'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PartionCell_Level', zc_Object_PartionCell(), ' Уровень стелажа' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionCell_Level');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionCell_Length() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionCell_Length'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PartionCell_Length', zc_Object_PartionCell(), ' Длина ячейки, мм' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionCell_Length');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionCell_Width() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionCell_Width'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PartionCell_Width', zc_Object_PartionCell(), ' Ширина ячейки, мм' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionCell_Width');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionCell_Height() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionCell_Height'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PartionCell_Height', zc_Object_PartionCell(), ' Высота ячейки, мм' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionCell_Height');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionCell_BoxCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionCell_BoxCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PartionCell_BoxCount', zc_Object_PartionCell(), ' Кол-во ящиков Е2 (итого в ячейке)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionCell_BoxCount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionCell_RowBoxCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionCell_RowBoxCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PartionCell_RowBoxCount', zc_Object_PartionCell(), ' Кол-во ящиков в ряду' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionCell_RowBoxCount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionCell_RowWidth() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionCell_RowWidth'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PartionCell_RowWidth', zc_Object_PartionCell(), ' Кол-во рядов (глубина)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionCell_RowWidth');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionCell_RowHeight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionCell_RowHeight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PartionCell_RowHeight', zc_Object_PartionCell(), ' Кол-во рядов (высота)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionCell_RowHeight');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsGroupProperty_ColorReport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsGroupProperty_ColorReport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsGroupProperty(), 'zc_ObjectFloat_GoodsGroupProperty_ColorReport', 'Цвет текста в "отчет по отгрузке"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsGroupProperty_ColorReport');

    
CREATE OR REPLACE FUNCTION zc_ObjectFloat_Bank_SummMax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Bank_SummMax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Bank(), 'zc_ObjectFloat_Bank_SummMax', 'Ограничение по максимальной сумме для Банк - Ф2' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Bank_SummMax');
    
CREATE OR REPLACE FUNCTION zc_ObjectFloat_ChoiceCell_BoxCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ChoiceCell_BoxCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Bank(), 'zc_ObjectFloat_ChoiceCell_BoxCount', 'Кол-во ящиков Е2 (итого в ячейке)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ChoiceCell_BoxCount');
        
CREATE OR REPLACE FUNCTION zc_ObjectFloat_ChoiceCell_NPP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ChoiceCell_NPP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Bank(), 'zc_ObjectFloat_ChoiceCell_NPP', '№ п/п для сортировки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ChoiceCell_NPP');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsNormDiff_ValuePF() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsNormDiff_ValuePF'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Bank(), 'zc_ObjectFloat_GoodsNormDiff_ValuePF', 'Норма отклонения П/Ф (ГП), кг' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsNormDiff_ValuePF');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsNormDiff_ValueGP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsNormDiff_ValueGP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Bank(), 'zc_ObjectFloat_GoodsNormDiff_ValueGP', 'Норма отклонения ГП, кг' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsNormDiff_ValueGP');






 
--!!! АПТЕКА

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Contract_Deferment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_Deferment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Contract_Deferment', zc_Object_Contract(), 'Отсрочка платежа' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_Deferment');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Contract_TotalSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_TotalSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Contract_TotalSumm', zc_Object_Contract(), 'Сумма осн. договора' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_TotalSumm');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ImportSettings_StartRow() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ImportSettings_StartRow'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_ImportSettings_StartRow', zc_Object_ImportSettings(), 'Первая строка загрузки для Excel' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ImportSettings_StartRow');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_JuridicalSettings_Bonus() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_JuridicalSettings_Bonus'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_JuridicalSettings_Bonus', zc_Object_JuridicalSettings(), 'Бонус' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_JuridicalSettings_Bonus');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_JuridicalSettings_PriceLimit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_JuridicalSettings_PriceLimit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_JuridicalSettings_PriceLimit', zc_Object_JuridicalSettings(), 'Цена до' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_JuridicalSettings_PriceLimit');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_NDSKind_NDS() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_NDSKind_NDS'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_NDSKind_NDS', zc_Object_NDSKind(), 'Значение НДС' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_NDSKind_NDS');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PriceGroupSettings_MinPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceGroupSettings_MinPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PriceGroupSettings_MinPrice', zc_Object_PriceGroupSettings(), 'Начальная цена группы' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceGroupSettings_MinPrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PriceGroupSettings_Percent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceGroupSettings_Percent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PriceGroupSettings_Percent', zc_Object_PriceGroupSettings(), '% для отсрочки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceGroupSettings_Percent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PriceGroupSettingsTOP_MinPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceGroupSettingsTOP_MinPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PriceGroupSettingsTOP_MinPrice', zc_Object_PriceGroupSettingsTOP(), 'Начальная цена группы ТОП' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceGroupSettingsTOP_MinPrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PriceGroupSettingsTOP_Percent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceGroupSettingsTOP_Percent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PriceGroupSettingsTOP_Percent', zc_Object_PriceGroupSettingsTOP(), '% для отсрочки группы  ТОП' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceGroupSettingsTOP_Percent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ServiceDate_Year() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ServiceDate_Year'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ServiceDate(), 'zc_ObjectFloat_ServiceDate_Year', 'Год' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ServiceDate_Year');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ServiceDate_Month() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ServiceDate_Month'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ServiceDate(), 'zc_ObjectFloat_ServiceDate_Month', 'Месяц' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ServiceDate_Month');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Quality_NumberPrint() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Quality_NumberPrint'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Quality(), 'zc_ObjectFloat_Quality_NumberPrint', 'номер печати' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Quality_NumberPrint');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsProperty_StartPosInt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsProperty_StartPosInt'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsProperty(), 'zc_ObjectFloat_GoodsProperty_StartPosInt', 'Целая часть веса в штрих коде(начальная позиция)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsProperty_StartPosInt');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsProperty_EndPosInt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsProperty_EndPosInt'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsProperty(), 'zc_ObjectFloat_GoodsProperty_EndPosInt', 'Целая часть веса в штрих коде(последняя позиция)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsProperty_EndPosInt');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsProperty_StartPosFrac() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsProperty_StartPosFrac'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsProperty(), 'zc_ObjectFloat_GoodsProperty_StartPosFrac', 'Дробная часть веса в штрих коде(начальная позиция)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsProperty_StartPosFrac');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsProperty_EndPosFrac() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsProperty_EndPosFrac'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsProperty(), 'zc_ObjectFloat_GoodsProperty_EndPosFrac', 'Дробная часть веса в штрих коде(последняя позиция)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsProperty_EndPosFrac');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsProperty_StartPosIdent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsProperty_StartPosIdent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsProperty(), 'zc_ObjectFloat_GoodsProperty_StartPosIdent', 'Идентификатор товара(начальная позиция)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsProperty_StartPosIdent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsProperty_EndPosIdent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsProperty_EndPosIdent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsProperty(), 'zc_ObjectFloat_GoodsProperty_EndPosIdent', 'Идентификатор товара(последняя позиция)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsProperty_EndPosIdent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsProperty_TaxDoc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsProperty_TaxDoc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsProperty(), 'zc_ObjectFloat_GoodsProperty_TaxDoc', '% отклонения для вложения' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsProperty_TaxDoc');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Price_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Price_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectFloat_Price_Value', 'Значение цены реализации' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Price_Value');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Price_MCSValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Price_MCSValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectFloat_Price_MCSValue', 'Неснижаемый товарный запас' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Price_MCSValue');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Price_MCSValueSun() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Price_MCSValueSun'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectFloat_Price_MCSValueSun', 'Неснижаемый товарный запас для СУН' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Price_MCSValueSun');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Price_PercentMarkup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Price_PercentMarkup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectFloat_Price_PercentMarkup', '% наценки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Price_PercentMarkup');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Price_MCSValueOld() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Price_MCSValueOld'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectFloat_Price_MCSValueOld', 'НТЗ - значение которое вернется по окончании периода' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Price_MCSValueOld');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Price_MCSValueMin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Price_MCSValueMin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectFloat_Price_MCSValueMin', 'минимальный Неснижаемый товарный запас' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Price_MCSValueMin');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_ReportSoldParams_PlanAmount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReportSoldParams_PlanAmount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReportSoldParams(), 'zc_ObjectFloat_ReportSoldParams_PlanAmount', 'Сумма плана' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReportSoldParams_PlanAmount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ReportPromoParams_PlanAmount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReportPromoParams_PlanAmount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReportPromoParams(), 'zc_ObjectFloat_ReportPromoParams_PlanAmount', 'Сумма плана по маркетингу' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReportPromoParams_PlanAmount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Juridical_PayOrder() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_PayOrder'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectFloat_Juridical_PayOrder', 'Очередь платежа' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_PayOrder');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Juridical_ConditionalPercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_ConditionalPercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectFloat_Juridical_ConditionalPercent', 'Доп.условия по прайсу, %' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_ConditionalPercent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Position_TaxService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Position_TaxService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Position(), 'zc_ObjectFloat_Position_TaxService', '% от выручки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Position_TaxService');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_TaxService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_TaxService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_TaxService', '% от выручки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_TaxService');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_TaxServiceNigth() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_TaxServiceNigth'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_TaxServiceNigth', '% от выручки в ночную смену' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_TaxServiceNigth');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_FarmacyCash() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_FarmacyCash'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_FarmacyCash', 'кол-во данных в синхронизации с FarmacyCash' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_FarmacyCash');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Period() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Period'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Period', zc_Object_Unit(), 'Кол-во дней для анализа НТЗ вых.день' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Period');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Period1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Period1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Period1', zc_Object_Unit(), 'Кол-во дней для анализа НТЗ пн' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Period1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Period2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Period2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Period2', zc_Object_Unit(), 'Кол-во дней для анализа НТЗ вт' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Period2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Period3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Period3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Period3', zc_Object_Unit(), 'Кол-во дней для анализа НТЗ ср' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Period3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Period4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Period4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Period4', zc_Object_Unit(), 'Кол-во дней для анализа НТЗчт' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Period4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Period5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Period5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Period5', zc_Object_Unit(), 'Кол-во дней для анализа НТЗ пт' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Period5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Period6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Period6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Period6', zc_Object_Unit(), 'Кол-во дней для анализа НТЗ сб' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Period6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Period7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Period7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Period7', zc_Object_Unit(), 'Кол-во дней для анализа НТЗ вс' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Period7');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_WeekId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_WeekId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_WeekId', zc_Object_Unit(), 'День недели для запуска пересчата по СУН' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_WeekId');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_PeriodSun1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_PeriodSun1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_PeriodSun1', zc_Object_Unit(), 'Кол-во дней для анализа НТЗ для СУН  пн' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_PeriodSun1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_PeriodSun2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_PeriodSun2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_PeriodSun2', zc_Object_Unit(), 'Кол-во дней для анализа НТЗ для СУН  вт' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_PeriodSun2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_PeriodSun3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_PeriodSun3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_PeriodSun3', zc_Object_Unit(), 'Кол-во дней для анализа НТЗ для СУН  ср' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_PeriodSun3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_PeriodSun4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_PeriodSun4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_PeriodSun4', zc_Object_Unit(), 'Кол-во дней для анализа НТЗ для СУН  чт' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_PeriodSun4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_PeriodSun5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_PeriodSun5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_PeriodSun5', zc_Object_Unit(), 'Кол-во дней для анализа НТЗ для СУН  пт' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_PeriodSun5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_PeriodSun6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_PeriodSun6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_PeriodSun6', zc_Object_Unit(), 'Кол-во дней для анализа НТЗ для СУН  сб' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_PeriodSun6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_PeriodSun7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_PeriodSun7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_PeriodSun7', zc_Object_Unit(), 'Кол-во дней для анализа НТЗ для СУН  вс' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_PeriodSun7');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_DaySun1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_DaySun1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_DaySun1', zc_Object_Unit(), 'Страховой запас НТЗ для СУН  Х дней пн' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_DaySun1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_DaySun2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_DaySun2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_DaySun2', zc_Object_Unit(), 'Страховой запас НТЗ для СУН Х дней вт' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_DaySun2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_DaySun3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_DaySun3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_DaySun3', zc_Object_Unit(), 'Страховой запас НТЗ для СУН Х дней ср' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_DaySun3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_DaySun4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_DaySun4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_DaySun4', zc_Object_Unit(), 'Страховой запас НТЗ для СУН Х днейчт' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_DaySun4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_DaySun5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_DaySun5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_DaySun5', zc_Object_Unit(), 'Страховой запас НТЗ для СУН Х дней пт' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_DaySun5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_DaySun6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_DaySun6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_DaySun6', zc_Object_Unit(), 'Страховой запас НТЗ для СУН Х дней сб' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_DaySun6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_DaySun7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_DaySun7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_DaySun7', zc_Object_Unit(), 'Страховой запас НТЗ для СУН Х дней вс' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_DaySun7');

 CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Day() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Day'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Day', zc_Object_Unit(), 'Страховой запас НТЗ для Х дней вых. день' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Day');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Day1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Day1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Day1', zc_Object_Unit(), 'Страховой запас НТЗ для Х дней пн' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Day1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Day2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Day2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Day2', zc_Object_Unit(), 'Страховой запас НТЗ для Х дней вт' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Day2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Day3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Day3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Day3', zc_Object_Unit(), 'Страховой запас НТЗ для Х дней ср' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Day3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Day4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Day4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Day4', zc_Object_Unit(), 'Страховой запас НТЗ для Х днейчт' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Day4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Day5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Day5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Day5', zc_Object_Unit(), 'Страховой запас НТЗ для Х дней пт' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Day5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Day6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Day6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Day6', zc_Object_Unit(), 'Страховой запас НТЗ для Х дней сб' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Day6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Day7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Day7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Day7', zc_Object_Unit(), 'Страховой запас НТЗ для Х дней вс' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Day7');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_SunIncome() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_SunIncome'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_SunIncome', zc_Object_Unit(), 'Кол-во дней приход от пост. (блокируем СУН)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_SunIncome');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Sun_v2Income() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Sun_v2Income'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Sun_v2Income', zc_Object_Unit(), 'Кол-во дней приход от пост. (блокируем СУН-2)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Sun_v2Income');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Sun_v4Income() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Sun_v4Income'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Sun_v4Income', zc_Object_Unit(), 'Кол-во дней приход от пост. (блокируем СУН-2-пи)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Sun_v4Income');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_HT_SUN_v1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_HT_SUN_v1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_HT_SUN_v1', zc_Object_Unit(), 'кол-во дней для HammerTime СУН-1' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_HT_SUN_v1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_HT_SUN_v2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_HT_SUN_v2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_HT_SUN_v2', zc_Object_Unit(), 'кол-во дней для HammerTime СУН-2' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_HT_SUN_v2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_HT_SUN_All() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_HT_SUN_All'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_HT_SUN_All', zc_Object_Unit(), 'кол-во дней для HammerTime для всех СУН по всем перемещениям' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_HT_SUN_All');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_HT_SUN_v1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_HT_SUN_v1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_HT_SUN_v1', zc_Object_Unit(), 'кол-во дней для HammerTime СУН-1' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_HT_SUN_v1');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Asset_PeriodUse() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Asset_PeriodUse'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Asset(), 'zc_ObjectFloat_Asset_PeriodUse', 'Период эксплуатации' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Asset_PeriodUse');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Asset_Production() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Asset_Production'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Asset(), 'zc_ObjectFloat_Asset_Production', 'Производительность, кг' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Asset_Production');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Asset_KW() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Asset_KW'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Asset(), 'zc_ObjectFloat_Asset_KW', 'Потребляемая Мощность KW' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Asset_KW');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OverSettings_MinPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OverSettings_MinPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_OverSettings(), 'zc_ObjectFloat_OverSettings_MinPrice', 'Минимальная цена' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OverSettings_MinPrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OverSettings_MinimumLot() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OverSettings_MinimumLot'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_OverSettings(), 'zc_ObjectFloat_OverSettings_MinimumLot', 'Кратность (Мин.округление)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OverSettings_MinimumLot');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_PriceSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PriceSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_PriceSP', 'Розмір відшкодування за упаковку лікарського засобу (15)(СП)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PriceSP');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_GroupSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_GroupSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_GroupSP', 'Групи відшкоду-вання – І або ІІ' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_GroupSP');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_CountSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_CountSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(),'zc_ObjectFloat_Goods_CountSP', 'Кількість одиниць лікарського засобу у споживчій упаковці (6)(СП)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_CountSP');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_PriceOptSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PriceOptSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(),'zc_ObjectFloat_Goods_PriceOptSP', 'Оптово-відпускна ціна за упаковку (11)(СП)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PriceOptSP');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_PriceRetSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PriceRetSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(),'zc_ObjectFloat_Goods_PriceRetSP', 'Роздрібна ціна за упаковку (12)(СП)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PriceRetSP');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_DailyNormSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_DailyNormSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(),'zc_ObjectFloat_Goods_DailyNormSP', 'Добова доза лікарського засобу, рекомендована ВООЗ (13)(СП)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_DailyNormSP');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_DailyCompensationSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_DailyCompensationSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(),'zc_ObjectFloat_Goods_DailyCompensationSP', 'Розмір відшкодування добової дози лікарського засобу (14)(СП)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_DailyCompensationSP');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_PaymentSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PaymentSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_object_Goods(),'zc_ObjectFloat_Goods_PaymentSP', 'Сума доплати за упаковку (16)(СП)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PaymentSP');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_ColSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_ColSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(),'zc_ObjectFloat_Goods_ColSP', '№ п.п.(1)(СП)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_ColSP');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_CountPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_CountPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(),'zc_ObjectFloat_Goods_CountPrice', 'Кол-во прайсов' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_CountPrice');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_KoeffSUN_v3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_KoeffSUN_v3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(),'zc_ObjectFloat_Goods_KoeffSUN_v3', 'Кратность по Э-СУН' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_KoeffSUN_v3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_KoeffSUN_v1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_KoeffSUN_v1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(),'zc_ObjectFloat_Goods_KoeffSUN_v1', 'Кратность по СУН v1' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_KoeffSUN_v1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_KoeffSUN_v2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_KoeffSUN_v2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(),'zc_ObjectFloat_Goods_KoeffSUN_v2', 'Кратность по СУН v2' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_KoeffSUN_v2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_KoeffSUN_v4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_KoeffSUN_v4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(),'zc_ObjectFloat_Goods_KoeffSUN_v4', 'Кратность по СУН v2-ПИ' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_KoeffSUN_v4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_LimitSUN_T1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_LimitSUN_T1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(),'zc_ObjectFloat_Goods_LimitSUN_T1', 'Остаток, при котором расчет для СУН-2 и СУН-2-пи значения Т1' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_LimitSUN_T1');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_User_BillNumberMobile() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_User_BillNumberMobile'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(),'zc_ObjectFloat_User_BillNumberMobile', 'Добавляется к № документа' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_User_BillNumberMobile');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_SPKind_Tax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SPKind_Tax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_SPKind(),'zc_ObjectFloat_SPKind_Tax', '% скидки по кассе (Вид Соц.проекта)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SPKind_Tax');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsPropertyBox_WeightOnBox() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyBox_WeightOnBox'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsPropertyBox(), 'zc_ObjectFloat_GoodsPropertyBox_WeightOnBox', 'количество кг. в ящ.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyBox_WeightOnBox');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsPropertyBox_CountOnBox() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyBox_CountOnBox'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsPropertyBox(), 'zc_ObjectFloat_GoodsPropertyBox_CountOnBox', 'количество ед. в ящ.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyBox_CountOnBox');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Maker_CashBack() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Maker_CashBack'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Maker(), 'zc_ObjectFloat_Maker_CashBack', 'Сумма Cash Back для отчета леквидности' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Maker_CashBack');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Overdraft_Summa() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Overdraft_Summa'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Overdraft(), 'zc_ObjectFloat_Overdraft_Summa', 'Сумма овердрафт для отчета леквидности' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Overdraft_Summa');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PriceChange_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceChange_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceChange(), 'zc_ObjectFloat_PriceChange_Value', 'Расчетная цена' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceChange_Value');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PriceChange_FixValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceChange_FixValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceChange(), 'zc_ObjectFloat_PriceChange_FixValue', 'Расчетная цена' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceChange_FixValue');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PriceChange_PercentMarkup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceChange_PercentMarkup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceChange(), 'zc_ObjectFloat_PriceChange_PercentMarkup', 'Расчетная цена' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceChange_PercentMarkup');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PriceChange_FixPercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceChange_FixPercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceChange(), 'zc_ObjectFloat_PriceChange_FixPercent', 'фиксированный % скидки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceChange_FixPercent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PriceChange_FixDiscount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceChange_FixDiscount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceChange(), 'zc_ObjectFloat_PriceChange_FixDiscount', 'фиксированпая сумма скидки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceChange_FixDiscount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PriceChange_Multiplicity() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceChange_Multiplicity'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceChange(), 'zc_ObjectFloat_PriceChange_Multiplicity', 'Кратность отпуска' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceChange_Multiplicity');


  CREATE OR REPLACE FUNCTION zc_ObjectFloat_RepriceUnitSheduler_PercentDifference() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RepriceUnitSheduler_PercentDifference'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_RepriceUnitSheduler(), 'zc_ObjectFloat_RepriceUnitSheduler_PercentDifference', '% разницы цен' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RepriceUnitSheduler_PercentDifference');

  CREATE OR REPLACE FUNCTION zc_ObjectFloat_RepriceUnitSheduler_PercentRepriceMax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RepriceUnitSheduler_PercentRepriceMax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_RepriceUnitSheduler(), 'zc_ObjectFloat_RepriceUnitSheduler_PercentRepriceMax', 'Переоц. с % не более' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RepriceUnitSheduler_PercentRepriceMax');

  CREATE OR REPLACE FUNCTION zc_ObjectFloat_RepriceUnitSheduler_PercentRepriceMin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RepriceUnitSheduler_PercentRepriceMin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_RepriceUnitSheduler(), 'zc_ObjectFloat_RepriceUnitSheduler_PercentRepriceMin', 'Переоц. с % не менее' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RepriceUnitSheduler_PercentRepriceMin');

  CREATE OR REPLACE FUNCTION zc_ObjectFloat_RepriceUnitSheduler_EqualRepriceMax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RepriceUnitSheduler_EqualRepriceMax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_RepriceUnitSheduler(), 'zc_ObjectFloat_RepriceUnitSheduler_EqualRepriceMax', 'Уравн. с % не более' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RepriceUnitSheduler_EqualRepriceMax');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_RepriceUnitSheduler_EqualRepriceMin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RepriceUnitSheduler_EqualRepriceMin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_RepriceUnitSheduler(), 'zc_ObjectFloat_RepriceUnitSheduler_EqualRepriceMin', 'Уравн. с % не менее' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RepriceUnitSheduler_EqualRepriceMin');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_DocumentTaxKind_Price() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_DocumentTaxKind_Price'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_DocumentTaxKind(), 'zc_ObjectFloat_DocumentTaxKind_Price', 'Цена' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_DocumentTaxKind_Price');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_RecalcMCSSheduler_Week() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RecalcMCSSheduler_Week'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_RecalcMCSSheduler(), 'zc_ObjectFloat_RecalcMCSSheduler_Week', 'День недели' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RecalcMCSSheduler_Week');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_JuridicalSettingsItem_Bonus() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_JuridicalSettingsItem_Bonus'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_JuridicalSettingsItem(), 'zc_ObjectFloat_JuridicalSettingsItem_Bonus', '% бонусирования' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_JuridicalSettingsItem_Bonus');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_JuridicalSettingsItem_PriceLimit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_JuridicalSettingsItem_PriceLimit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_JuridicalSettingsItem(), 'zc_ObjectFloat_JuridicalSettingsItem_PriceLimit', '% бонусирования' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_JuridicalSettingsItem_PriceLimit');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Maker_Day() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Maker_Day'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Maker(), 'zc_ObjectFloat_Maker_Day', 'периодичность отправки в дня' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Maker_Day');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Maker_Month() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Maker_Month'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Maker(), 'zc_ObjectFloat_Maker_Month', 'периодичность отправки в месяцах' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Maker_Month');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GlobalConst_SiteDiscount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GlobalConst_SiteDiscount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GlobalConst(), 'zc_ObjectFloat_GlobalConst_SiteDiscount', ' % скидки для сайта ' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GlobalConst_SiteDiscount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_NormOfManDays() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_NormOfManDays'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_NormOfManDays', 'Норма человекодней в месяце' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_NormOfManDays');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_KoeffInSUN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_KoeffInSUN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_KoeffInSUN', 'Коэффициент баланса приход/расход' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_KoeffInSUN');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_KoeffOutSUN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_KoeffOutSUN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_KoeffOutSUN', 'Коэффициент баланса расход/приход' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_KoeffOutSUN');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_KoeffOutSUN_v3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_KoeffOutSUN_v3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_KoeffOutSUN_v3', 'коэф. СЗО' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_KoeffOutSUN_v3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_KoeffInSUN_v3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_KoeffInSUN_v3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_KoeffInSUN_v3', 'коэф. СЗП' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_KoeffInSUN_v3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_T1_SUN_v2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_T1_SUN_v2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_T1_SUN_v2', 'кол-во дней для T1' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_T1_SUN_v2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_T2_SUN_v2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_T2_SUN_v2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_T2_SUN_v2', 'кол-во дней для T2' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_T2_SUN_v2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_T1_SUN_v4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_T1_SUN_v4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_T1_SUN_v4', 'кол-во дней для T1' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_T1_SUN_v4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_LimitSUN_N() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_LimitSUN_N'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_LimitSUN_N', 'Остаток, при котором работает СУН-1 и СУН-2 и СУН-2-пи значения Т1' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_LimitSUN_N');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_UnitCategory_PenaltyNonMinPlan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_UnitCategory_PenaltyNonMinPlan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_UnitCategory(), 'zc_ObjectFloat_UnitCategory_PenaltyNonMinPlan', '% штрафа за невыполнение минимального плана' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_UnitCategory_PenaltyNonMinPlan');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_UnitCategory_PremiumImplPlan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_UnitCategory_PremiumImplPlan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_UnitCategory(), 'zc_ObjectFloat_UnitCategory_PremiumImplPlan', '% премии за выполнение плана продаж' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_UnitCategory_PremiumImplPlan');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_UnitCategory_MinLineByLineImplPlan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_UnitCategory_MinLineByLineImplPlan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_UnitCategory(), 'zc_ObjectFloat_UnitCategory_MinLineByLineImplPlan', 'Минимальный % построчного выполнения минимального плана для получения премии' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_UnitCategory_MinLineByLineImplPlan');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsCategory_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsCategory_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsCategory(), 'zc_ObjectFloat_GoodsCategory_Value', 'Кол-во' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsCategory_Value');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_TaxUnit_Price() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_TaxUnit_Price'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_TaxUnit(), 'zc_ObjectFloat_TaxUnit_Price', 'Цены с...' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_TaxUnit_Price');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_TaxUnit_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_TaxUnit_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_TaxUnit(), 'zc_ObjectFloat_TaxUnit_Value', '% наценки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_TaxUnit_Value');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Retail_MarginPercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_MarginPercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Retail(), 'zc_ObjectFloat_Retail_MarginPercent', '% наценки для срока годности < 6 мес.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_MarginPercent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Retail_SummSUN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_SummSUN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Retail(), 'zc_ObjectFloat_Retail_SummSUN', 'сумма, при которой включается СУН' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_SummSUN');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Retail_LimitSUN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_LimitSUN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Retail(), 'zc_ObjectFloat_Retail_LimitSUN', 'Лимит для Отложен (перемещения СУН)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_LimitSUN');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Retail_ShareFromPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_ShareFromPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Retail(), 'zc_ObjectFloat_Retail_ShareFromPrice', 'Делить медикамент от цены' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_ShareFromPrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Retail_RoundWeight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_RoundWeight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Retail(), 'zc_ObjectFloat_Retail_RoundWeight', 'Кол-во знаков для округления веса' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_RoundWeight');
 
 
CREATE OR REPLACE FUNCTION zc_ObjectFloat_Juridical_CreditLimit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_CreditLimit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectFloat_Juridical_CreditLimit', 'Кредитный лимит по дистрибьютору' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_CreditLimit');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionDateKind_Month() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionDateKind_Month'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PartionDateKind(), 'zc_ObjectFloat_PartionDateKind_Month', 'Кол-во месяцев' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionDateKind_Month');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionDateKind_Day() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionDateKind_Day'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PartionDateKind(), 'zc_ObjectFloat_PartionDateKind_Day', 'Кол-во дней' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionDateKind_Day');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_RetailCostCredit_MinPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RetailCostCredit_MinPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_RetailCostCredit(), 'zc_ObjectFloat_RetailCostCredit_MinPrice', 'Начальная цена' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RetailCostCredit_MinPrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_RetailCostCredit_Percent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RetailCostCredit_Percent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_RetailCostCredit(), 'zc_ObjectFloat_RetailCostCredit_Percent', '% кредитных средств' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RetailCostCredit_Percent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionGoods_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionGoods_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PartionGoods(), 'zc_ObjectFloat_PartionGoods_Value', '% скидки в партии для срок от 1 до 6 мес.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionGoods_Value');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionGoods_ValueMin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionGoods_ValueMin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PartionGoods(), 'zc_ObjectFloat_PartionGoods_ValueMin', '% скидки в партии для срок от 0 до 1 мес.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionGoods_ValueMin');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionGoods_MovementId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionGoods_MovementId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PartionGoods(), 'zc_ObjectFloat_PartionGoods_MovementId', 'Партия документа Срок' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionGoods_MovementId');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MaxOrderAmount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MaxOrderAmount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_DiffKind(), 'zc_ObjectFloat_MaxOrderAmount', 'Максимальная сумма заказа' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MaxOrderAmount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MaxOrderAmountSecond() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MaxOrderAmountSecond'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_DiffKind(), 'zc_ObjectFloat_MaxOrderAmountSecond', 'Максимальная сумма заказа вторая шкала' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MaxOrderAmountSecond');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CreditLimitJuridical_CreditLimit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CreditLimitJuridical_CreditLimit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CreditLimitJuridical(), 'zc_ObjectFloat_CreditLimitJuridical_CreditLimit', 'Кредитный лимит' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CreditLimitJuridical_CreditLimit');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionGoods_PriceWithVAT() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionGoods_PriceWithVAT'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PartionGoods(), 'zc_ObjectFloat_PartionGoods_PriceWithVAT', 'Цена закупки с НДС.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionGoods_PriceWithVAT');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PayrollType_Percent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PayrollType_Percent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PayrollType(), 'zc_ObjectFloat_PayrollType_Percent', 'Процент от базы' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PayrollType_Percent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PayrollType_MinAccrualAmount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PayrollType_MinAccrualAmount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PayrollType(), 'zc_ObjectFloat_PayrollType_MinAccrualAmount', 'Мин сумма начисления' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PayrollType_MinAccrualAmount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_LabReceiptChild_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_LabReceiptChild_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_LabReceiptChild(), 'zc_ObjectFloat_LabReceiptChild_Value', 'Значение(Нормы для исследования)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_LabReceiptChild_Value');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Latitude() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Latitude'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_Latitude', 'Географическая широта' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Latitude');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Longitude() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Longitude'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_Longitude', 'Географическая долгота' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Longitude');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Juridical_CodeRazom() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_CodeRazom'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectFloat_Juridical_CodeRazom', 'Код в системе "РАЗОМ"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_CodeRazom');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_MorionCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_MorionCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_MorionCode', 'Код мориона' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_MorionCode');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_CommentTR_DifferenceSum() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CommentTR_DifferenceSum'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CommentTR(), 'zc_ObjectFloat_CommentTR_DifferenceSum', 'Допустимая разница в сумме' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CommentTR_DifferenceSum');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_MoneyBoxSun() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_MoneyBoxSun'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_MoneyBoxSun', 'Копилка по результатам СУН1' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_MoneyBoxSun');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_MoneyBoxSunUsed() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_MoneyBoxSunUsed'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_MoneyBoxSunUsed', 'Использование копилки по результатам СУН1' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_MoneyBoxSunUsed');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_SeasonalityCoefficient_Koeff1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_SeasonalityCoefficient_Koeff1', zc_Object_SeasonalityCoefficient(), 'Коэффициент сезонности' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_SeasonalityCoefficient_Koeff2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_SeasonalityCoefficient_Koeff2', zc_Object_SeasonalityCoefficient(), 'Коэффициент сезонности' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_SeasonalityCoefficient_Koeff3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_SeasonalityCoefficient_Koeff3', zc_Object_SeasonalityCoefficient(), 'Коэффициент сезонности' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_SeasonalityCoefficient_Koeff4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_SeasonalityCoefficient_Koeff4', zc_Object_SeasonalityCoefficient(), 'Коэффициент сезонности' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_SeasonalityCoefficient_Koeff5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_SeasonalityCoefficient_Koeff5', zc_Object_SeasonalityCoefficient(), 'Коэффициент сезонности' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_SeasonalityCoefficient_Koeff6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_SeasonalityCoefficient_Koeff6', zc_Object_SeasonalityCoefficient(), 'Коэффициент сезонности' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_SeasonalityCoefficient_Koeff7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_SeasonalityCoefficient_Koeff7', zc_Object_SeasonalityCoefficient(), 'Коэффициент сезонности' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff7');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_SeasonalityCoefficient_Koeff8() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff8'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_SeasonalityCoefficient_Koeff8', zc_Object_SeasonalityCoefficient(), 'Коэффициент сезонности' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff8');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_SeasonalityCoefficient_Koeff9() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff9'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_SeasonalityCoefficient_Koeff9', zc_Object_SeasonalityCoefficient(), 'Коэффициент сезонности' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff9');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_SeasonalityCoefficient_Koeff10() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff10'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_SeasonalityCoefficient_Koeff10', zc_Object_SeasonalityCoefficient(), 'Коэффициент сезонности' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff10');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_SeasonalityCoefficient_Koeff11() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff11'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_SeasonalityCoefficient_Koeff11', zc_Object_SeasonalityCoefficient(), 'Коэффициент сезонности' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff11');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_SeasonalityCoefficient_Koeff12() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff12'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_SeasonalityCoefficient_Koeff12', zc_Object_SeasonalityCoefficient(), 'Коэффициент сезонности' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff12');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashRegister_PhysicalMemoryCapacity() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashRegister_PhysicalMemoryCapacity'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_CashRegister_PhysicalMemoryCapacity', zc_Object_CashRegister(), 'Оперативная память' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashRegister_PhysicalMemoryCapacity');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Retail_Fund() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_Fund'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Retail(), 'zc_ObjectFloat_Retail_Fund', 'Накопленный фонд' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_Fund');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Retail_FundUsed() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_FundUsed'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Retail(), 'zc_ObjectFloat_Retail_FundUsed', 'Использование из Фонда' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_FundUsed');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Retail_OccupancySUN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_OccupancySUN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Retail(), 'zc_ObjectFloat_Retail_OccupancySUN', 'Заполняемость документа по СУН' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_OccupancySUN');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_DriverSun_ChatIDSendVIP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_DriverSun_ChatIDSendVIP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_DriverSun(), 'zc_ObjectFloat_DriverSun_ChatIDSendVIP', 'Чат ID для отправки сообщений в Telegram по перемещениям VIP' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_DriverSun_ChatIDSendVIP');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_SummaFormSendVIP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_SummaFormSendVIP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_SummaFormSendVIP', 'Сумма от которой показан товар при формировании перемещений VIP' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_SummaFormSendVIP');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_SummaUrgentlySendVIP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_SummaUrgentlySendVIP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_SummaUrgentlySendVIP', 'Сумма перемещения от которой разрешен признак срочно' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_SummaUrgentlySendVIP');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_DeySupplSun1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_DeySupplSun1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_DeySupplSun1', 'Дни продаж в Дополнение СУН1' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_DeySupplSun1');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_MonthSupplSun1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_MonthSupplSun1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_MonthSupplSun1', 'Количество месяцев назад в Дополнение СУН1' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_MonthSupplSun1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Juridical_CodeMedicard() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_CodeMedicard'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectFloat_Juridical_CodeMedicard', 'Код в системе "Medicard"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_CodeMedicard');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionGoods_ValueLess() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionGoods_ValueLess'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PartionGoods(), 'zc_ObjectFloat_PartionGoods_ValueLess', '% скидки в партии для срок от 1 до 3 мес.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionGoods_ValueLess');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionHouseholdInventory_MovementItemId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionHouseholdInventory_MovementItemId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PartionHouseholdInventory(), 'zc_ObjectFloat_PartionHouseholdInventory_MovementItemId', 'Ключ элемента прихода хозяйственного инвентаря' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionHouseholdInventory_MovementItemId');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_HouseholdInventory_CountForPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_HouseholdInventory_CountForPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_HouseholdInventory(), 'zc_ObjectFloat_HouseholdInventory_CountForPrice', 'Себестоимость' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_HouseholdInventory_CountForPrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_SerialNumberTabletki() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_SerialNumberTabletki'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_SerialNumberTabletki', 'Серийный номер на сайте таблеток' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_SerialNumberTabletki');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_JuridicalPriorities_Priorities() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_JuridicalPriorities_Priorities'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_JuridicalPriorities(), 'zc_ObjectFloat_JuridicalPriorities_Priorities', '% Приоритета - уменьшает приоритет + увеличивает' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_JuridicalPriorities_Priorities');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_DaySaleForSUN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_DaySaleForSUN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_DaySaleForSUN', 'Количество дней для контроля <Продано/Продажа до след СУН>' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_DaySaleForSUN');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_DiffKind_DaysForSale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_DiffKind_DaysForSale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_DiffKind(), 'zc_ObjectFloat_DiffKind_DaysForSale', 'Дней для продажы' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_DiffKind_DaysForSale');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_BarCode_MaxPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BarCode_MaxPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_BarCode(), 'zc_ObjectFloat_BarCode_MaxPrice', 'Максимально допустимая цена' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BarCode_MaxPrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ConditionsKeep_RelatedProduct() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ConditionsKeep_RelatedProduct'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ConditionsKeep(), 'zc_ObjectFloat_ConditionsKeep_RelatedProduct', 'Сопутствующие товары' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ConditionsKeep_RelatedProduct');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_AttemptsSub() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AttemptsSub'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_AttemptsSub', 'Количество попыток до успешной сдачи теста для предложения подмен' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AttemptsSub');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_PercentSAUA() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_PercentSAUA'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_PercentSAUA', 'Процент количество кодов в чеках для САУА' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_PercentSAUA');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_SummaWages() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_SummaWages'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_SummaWages', 'Статичиское значение за 1 единицу продажи в зарплату' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_SummaWages');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_PercentWages() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PercentWages'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_PercentWages', '% от продажи в зарплату' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PercentWages');  

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_SummaWagesStore() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_SummaWagesStore'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_SummaWagesStore', 'Статичиское значение за 1 единицу продажи в зарплату для кладовщика' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_SummaWagesStore');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_PercentWagesStore() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PercentWagesStore'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_PercentWagesStore', '% от продажи в зарплату для кладовщика' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PercentWagesStore');  

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Juridical_CodeOrangeCard() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_CodeOrangeCard'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectFloat_Juridical_CodeOrangeCard', 'Код в системе "Оранж Кард"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_CodeOrangeCard');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_KoeffSUN_Supplementv1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_KoeffSUN_Supplementv1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(),'zc_ObjectFloat_Goods_KoeffSUN_Supplementv1', 'Кратность по дополнению СУН1' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_KoeffSUN_Supplementv1');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_ShareFromPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_ShareFromPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(),'zc_ObjectFloat_Unit_ShareFromPrice', 'Делить медикамент от цены' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_ShareFromPrice');  

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_DayNonCommoditySUN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_DayNonCommoditySUN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_DayNonCommoditySUN', 'Количество дней для контроля Комментария "Нетоварный вид"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_DayNonCommoditySUN');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_SerialNumberMypharmacy() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_SerialNumberMypharmacy'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_SerialNumberMypharmacy', 'Серийный номер на сайте моя аптека' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_SerialNumberMypharmacy');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_UpperLimitPromoBonus() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_UpperLimitPromoBonus'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_UpperLimitPromoBonus', 'Верхний предел сравнения (маркет бонусы)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_UpperLimitPromoBonus');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_LowerLimitPromoBonus() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_LowerLimitPromoBonus'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_LowerLimitPromoBonus', 'Нижний предел сравнения (маркет бонусы)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_LowerLimitPromoBonus');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_MinPercentPromoBonus() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_MinPercentPromoBonus'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_MinPercentPromoBonus', 'Минимальная наценка (маркет бонусы)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_MinPercentPromoBonus');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartnerMedical_LikiDniproId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartnerMedical_LikiDniproId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PartnerMedical(), 'zc_ObjectFloat_PartnerMedical_LikiDniproId', 'Id медицинского учреждения в системе МИС «Каштан»' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartnerMedical_LikiDniproId');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MedicSP_LikiDniproId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MedicSP_LikiDniproId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MedicSP(), 'zc_ObjectFloat_MedicSP_LikiDniproId', 'Id врача в системе МИС «Каштан»' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MedicSP_LikiDniproId');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MemberSP_LikiDniproId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MemberSP_LikiDniproId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MemberSP(), 'zc_ObjectFloat_MemberSP_LikiDniproId', 'Id пациента в системе МИС «Каштан»' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MemberSP_LikiDniproId');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_DiscountExternalSupplier_SupplierID() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_DiscountExternalSupplier_SupplierID'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_DiscountExternalSupplier(), 'zc_ObjectFloat_DiscountExternalSupplier_SupplierID', 'ID - поставщика в проекте' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_DiscountExternalSupplier_SupplierID');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_Multiplicity() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_Multiplicity'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_Multiplicity', 'Кратность при придаже' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_Multiplicity');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Juridical_ExpirationDateMonth() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_ExpirationDateMonth'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectFloat_Juridical_ExpirationDateMonth', 'Брать в переоценку товар со сроком более месяцев' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_ExpirationDateMonth');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_FinalSUAProtocol_Threshold() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_FinalSUAProtocol_Threshold'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_FinalSUAProtocol(), 'zc_ObjectFloat_FinalSUAProtocol_Threshold', 'Порог минимальных продаж' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_FinalSUAProtocol_Threshold');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_FinalSUAProtocol_DaysStock() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_FinalSUAProtocol_DaysStock'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_FinalSUAProtocol(), 'zc_ObjectFloat_FinalSUAProtocol_DaysStock', 'Дней запаса у получателя' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_FinalSUAProtocol_DaysStock');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_FinalSUAProtocol_CountPharmacies() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_FinalSUAProtocol_CountPharmacies'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_FinalSUAProtocol(), 'zc_ObjectFloat_FinalSUAProtocol_CountPharmacies', 'Мин. кол-во аптек ассортимента' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_FinalSUAProtocol_CountPharmacies');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_FinalSUAProtocol_ResolutionParameter() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_FinalSUAProtocol_ResolutionParameter'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_FinalSUAProtocol(), 'zc_ObjectFloat_FinalSUAProtocol_ResolutionParameter', 'Гранич. параметр разрешения' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_FinalSUAProtocol_ResolutionParameter');
  
  CREATE OR REPLACE FUNCTION c() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_DayCompensDiscount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_DayCompensDiscount', 'Дней до компенсации по дисконтным проектам' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_DayCompensDiscount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_FinalSUAProtocol_ThresholdMCS() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_FinalSUAProtocol_ThresholdMCS'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_FinalSUAProtocol(), 'zc_ObjectFloat_FinalSUAProtocol_ThresholdMCS', 'Порог минимального НТЗ' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_FinalSUAProtocol_ThresholdMCS');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_FinalSUAProtocol_ThresholdRemains() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_FinalSUAProtocol_ThresholdRemains'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_FinalSUAProtocol(), 'zc_ObjectFloat_FinalSUAProtocol_ThresholdRemains', 'Порог остатка' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_FinalSUAProtocol_ThresholdRemains');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_FinalSUAProtocol_ThresholdMCSLarge() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_FinalSUAProtocol_ThresholdMCSLarge'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_FinalSUAProtocol(), 'zc_ObjectFloat_FinalSUAProtocol_ThresholdMCSLarge', 'Порог минимального НТЗ верхний' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_FinalSUAProtocol_ThresholdMCSLarge');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_FinalSUAProtocol_ThresholdRemainsLarge() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_FinalSUAProtocol_ThresholdRemainsLarge'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_FinalSUAProtocol(), 'zc_ObjectFloat_FinalSUAProtocol_ThresholdRemainsLarge', 'Порог остатка верхний' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_FinalSUAProtocol_ThresholdRemainsLarge');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PriceSite_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceSite_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceSite(), 'zc_ObjectFloat_PriceSite_Value', 'Значение' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceSite_Value');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PriceSite_PercentMarkup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceSite_PercentMarkup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceSite(), 'zc_ObjectFloat_PriceSite_PercentMarkup', 'фиксированная цена' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceSite_PercentMarkup');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_MarketingDiscount_Multiplicity() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarketingDiscount_Multiplicity'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MarketingDiscount(), 'zc_ObjectFloat_MarketingDiscount_Multiplicity', 'Кратность отпуска' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarketingDiscount_Multiplicity');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MarketingDiscount_FixValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarketingDiscount_FixValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MarketingDiscount(), 'zc_ObjectFloat_MarketingDiscount_FixValue', 'Фиксированная цена' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarketingDiscount_FixValue');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_AssortmentGeograph() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AssortmentGeograph'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_AssortmentGeograph', 'Аптек аналитиков по географии' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AssortmentGeograph');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_AssortmentSales() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AssortmentSales'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_AssortmentSales', 'Аптек аналитиков по продажам' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AssortmentSales');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_CustomerThreshold() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_CustomerThreshold'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_CustomerThreshold', 'Порог срабатывание при заказе под клиента' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_CustomerThreshold');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ReceiptLevel_MovementDesc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReceiptLevel_MovementDesc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReceiptLevel(), 'zc_ObjectFloat_ReceiptLevel_MovementDesc', 'Код документа' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReceiptLevel_MovementDesc');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CorrectMinAmount_Amount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CorrectMinAmount_Amount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CorrectMinAmount(), 'zc_ObjectFloat_CorrectMinAmount_Amount', 'Сумма корректировки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CorrectMinAmount_Amount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_PairSunAmount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PairSunAmount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_PairSunAmount', 'Количество упаковок товара к единице основного' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PairSunAmount');

  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_ZReportLog_SummaCash() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ZReportLog_SummaCash'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ZReportLog(), 'zc_ObjectFloat_ZReportLog_SummaCash', 'Оборот наличный' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ZReportLog_SummaCash');
  
  CREATE OR REPLACE FUNCTION zc_ObjectFloat_ZReportLog_SummaCard() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ZReportLog_SummaCard'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ZReportLog(), 'zc_ObjectFloat_ZReportLog_SummaCard', 'Оборот карта' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ZReportLog_SummaCard');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_PriceCorrectionDay() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_PriceCorrectionDay'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_PriceCorrectionDay', 'Период дней для системы коррекции цены по итогам роста/падения средних продаж' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_PriceCorrectionDay');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PayrollTypeVIP_PercentPhone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PayrollTypeVIP_PercentPhone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PayrollTypeVIP(), 'zc_ObjectFloat_PayrollTypeVIP_PercentPhone', 'Процент от заказов, которые принимают в телеф.режиме' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PayrollTypeVIP_PercentPhone');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PayrollTypeVIP_PercentOther() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PayrollTypeVIP_PercentOther'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PayrollTypeVIP(), 'zc_ObjectFloat_PayrollTypeVIP_PercentOther', 'Процент от остальных заказов' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PayrollTypeVIP_PercentOther');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_BarCode_DiscountProcent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BarCode_DiscountProcent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_BarCode(), 'zc_ObjectFloat_BarCode_DiscountProcent', 'Процент скидки по дисконтной программе' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BarCode_DiscountProcent');
    
CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_PromoBonus() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PromoBonus'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_PromoBonus', 'Бонус по акции' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PromoBonus');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CorrectWagesPercentage_Percent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CorrectWagesPercentage_Percent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CorrectWagesPercentage(), 'zc_ObjectFloat_CorrectWagesPercentage_Percent', 'Процент от начислено' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CorrectWagesPercentage_Percent');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_NumberPlates() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_NumberPlates'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_NumberPlates', 'Кол-во пластин в упаковке' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_NumberPlates');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_QtyPackage() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_QtyPackage'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_QtyPackage', 'Кол-во в упаковке' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_QtyPackage');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_PriceSamples() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_PriceSamples'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_PriceSamples', 'Порог цены Сэмплов от' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_PriceSamples');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_Samples21() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_Samples21'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_Samples21', 'Скидка сэмплов кат 2.1 (от 90-200 дней)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_Samples21');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_Samples22() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_Samples22'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_Samples22', 'Скидка сэмплов кат 2.2 (от 50-90 дней)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_Samples22');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_Samples3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_Samples3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_Samples3', 'Скидка сэмплов кат 3 (от 0 до 50 дней)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_Samples3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_Cat_5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_Cat_5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_Cat_5', 'Скидка кат 5 от цены' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_Cat_5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_BarCode_DiscountWithVAT() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BarCode_DiscountWithVAT'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_BarCode(), 'zc_ObjectFloat_BarCode_DiscountWithVAT', 'Фиксированная скидка с НДС' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BarCode_DiscountWithVAT');
    
CREATE OR REPLACE FUNCTION zc_ObjectFloat_BarCode_DiscountWithoutVAT() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BarCode_DiscountWithoutVAT'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_BarCode(), 'zc_ObjectFloat_BarCode_DiscountWithoutVAT', 'Фиксированная скидка без НДС' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BarCode_DiscountWithoutVAT');
    
CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_SupplementMin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_SupplementMin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_SupplementMin', 'Размазать в дополнении СУН не менее чем' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_SupplementMin');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_SupplementMinPP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_SupplementMinPP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_SupplementMinPP', 'Размазать в дополнении СУН для аптечных пунктов не менее чем' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_SupplementMinPP');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_PercentIC() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_PercentIC'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_PercentIC', 'Процент от продажи страховым компаниям для з/п фармацевтам' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_PercentIC');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_SurchargeWages_Summa() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SurchargeWages_Summa'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_SurchargeWages(), 'zc_ObjectFloat_SurchargeWages_Summa', 'Сумма доплаты' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SurchargeWages_Summa');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_PercentUntilNextSUN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_PercentUntilNextSUN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_PercentUntilNextSUN', 'Процент для подсветки комента "Продано/Продажа до след СУН"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_PercentUntilNextSUN');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Left() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Left'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_Left', 'Положение относительно левого края' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Left');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Top() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Top'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_Top', 'Положение относительно верхнего края' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Top');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Width() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Width'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_Width', 'Ширина' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Width');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Height() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Height'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_Height', 'Высота' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Height');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_DiscontAmountSite() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_DiscontAmountSite'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_DiscontAmountSite', 'Сумма скидки на сайте' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_DiscontAmountSite');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_DiscontPercentSite() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_DiscontPercentSite'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_DiscontPercentSite', 'Процент скидки на сайте' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_DiscontPercentSite');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_PriceSite_DiscontAmount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceSite_DiscontAmount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceSite(), 'zc_ObjectFloat_PriceSite_DiscontAmount', 'Сумма скидки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceSite_DiscontAmount');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_PriceSite_DiscontPercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceSite_DiscontPercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceSite(), 'zc_ObjectFloat_PriceSite_DiscontPercent', 'Процент скидки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceSite_DiscontPercent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_DiffKind_Packages() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_DiffKind_Packages'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_DiffKind(), 'zc_ObjectFloat_DiffKind_Packages', 'Количествову упаковок' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_DiffKind_Packages');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ExchangeRates_Exchange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ExchangeRates_Exchange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ExchangeRates(), 'zc_ObjectFloat_ExchangeRates_Exchange', 'Курс' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ExchangeRates_Exchange');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_TurnoverMoreSUN2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_TurnoverMoreSUN2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_TurnoverMoreSUN2', 'Оборот больше за прошлый месяц для распределения СУН 2' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_TurnoverMoreSUN2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_DeySupplOutSUN2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_DeySupplOutSUN2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_DeySupplOutSUN2', 'Продажи дней для аптек откуда' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_DeySupplOutSUN2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_DeySupplInSUN2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_DeySupplInSUN2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_DeySupplInSUN2', 'Продажи дней для аптек куда' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_DeySupplInSUN2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_DiffKindPrice_MinPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_DiffKindPrice_MinPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_DiffKindPrice(), 'zc_ObjectFloat_DiffKindPrice_MinPrice', 'Минимальная цена' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_DiffKindPrice_MinPrice');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_DiffKindPrice_Amount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_DiffKindPrice_Amount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_DiffKindPrice(), 'zc_ObjectFloat_DiffKindPrice_Amount', 'Количество упаковок заказа' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_DiffKindPrice_Amount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_DiffKindPrice_Summa() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_DiffKindPrice_Summa'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_DiffKindPrice(), 'zc_ObjectFloat_DiffKindPrice_Summa', 'Максимальная сумма заказа' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_DiffKindPrice_Summa');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MCRequestItem_MinPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MCRequestItem_MinPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MCRequestList(), 'zc_ObjectFloat_MCRequestItem_MinPrice', 'Минимальная цена' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MCRequestItem_MinPrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MCRequestItem_MarginPercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MCRequestItem_MarginPercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MCRequestList(), 'zc_ObjectFloat_MCRequestItem_MarginPercent', '% наценки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MCRequestItem_MarginPercent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MCRequestItem_MarginPercentOld() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MCRequestItem_MarginPercentOld'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MCRequestList(), 'zc_ObjectFloat_MCRequestItem_MarginPercentOld', '% наценки старый' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MCRequestItem_MarginPercentOld');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_ExpressVIPConfirm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_ExpressVIPConfirm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_ExpressVIPConfirm', 'Чеков для экспресс подтверждение ВИП' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_ExpressVIPConfirm');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_PriceFormSendVIP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_PriceFormSendVIP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_PriceFormSendVIP', 'Цена от которой показан товар при формировании перемещений VIP' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_PriceFormSendVIP');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_MinPriceSale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_MinPriceSale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_MinPriceSale', 'Минимальная цена товара при отпуске' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_MinPriceSale');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_DeviationsPrice1303() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_DeviationsPrice1303'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_DeviationsPrice1303', 'Процент отклонение от отпускной цены при отпуске по 1303' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_DeviationsPrice1303');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_BuyerForSite_Bonus() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BuyerForSite_Bonus'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_BuyerForSite(), 'zc_ObjectFloat_BuyerForSite_Bonus', 'Текущий бонус' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BuyerForSite_Bonus');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_BuyerForSite_BonusAdd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BuyerForSite_BonusAdd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_BuyerForSite(), 'zc_ObjectFloat_BuyerForSite_BonusAdd', 'Добавить к бонусу' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BuyerForSite_BonusAdd');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_BuyerForSite_BonusAdded() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BuyerForSite_BonusAdded'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_BuyerForSite(), 'zc_ObjectFloat_BuyerForSite_BonusAdded', 'Добавлено к бонусу' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BuyerForSite_BonusAdded');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_MultiplicityDiscontSite() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_MultiplicityDiscontSite'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_BuyerForSite(), 'zc_ObjectFloat_Goods_MultiplicityDiscontSite', 'Кратность при продаже на сайте со скидкой' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_MultiplicityDiscontSite');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_User_InternshipConfirmation() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_User_InternshipConfirmation'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectFloat_User_InternshipConfirmation', 'Подтверждение стажировки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_User_InternshipConfirmation');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_NormNewMobileOrders() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_NormNewMobileOrders'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_NormNewMobileOrders', '	Норма по новым заказам мобильного приложения' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_NormNewMobileOrders');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_LimitCash() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_LimitCash'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_LimitCash', 'Ограничение при покупки наличными' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_LimitCash');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_AddMarkupTabletki() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AddMarkupTabletki'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_AddMarkupTabletki', 'Доп наценка на Таблетки на поз по выставленным наценкам' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AddMarkupTabletki');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PayrollTypeVIP_Rate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PayrollTypeVIP_Rate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PayrollTypeVIP(), 'zc_ObjectFloat_PayrollTypeVIP_Rate', 'Ставка' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PayrollTypeVIP_Rate');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_FixedPercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_FixedPercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_FixedPercent', 'Фиксированный процент выполнения плана' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_FixedPercent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionDateWages_Percent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionDateWages_Percent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PartionDateWages(), 'zc_ObjectFloat_PartionDateWages_Percent', 'Поправочный коэффициент при начислении' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionDateWages_Percent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_MobMessSum() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_MobMessSum'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_MobMessSum', 'Сообщение по созданию заказа по приложению от суммы чека' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_MobMessSum');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_MobMessCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_MobMessCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_MobMessCount', 'Сообщение по созданию заказа по приложению после чека' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_MobMessCount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_AccountSalesDE_Amount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_AccountSalesDE_Amount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_AccountSalesDE(), 'zc_ObjectFloat_AccountSalesDE_Amount', 'Сумма акта' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_AccountSalesDE_Amount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_AntiTOPMP_Count() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AntiTOPMP_Count'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_AntiTOPMP_Count', 'Анти ТОП моб. прил. Количество сотрудников для отображения' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AntiTOPMP_Count');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_AntiTOPMP_CountFine() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AntiTOPMP_CountFine'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_AntiTOPMP_CountFine', 'Анти ТОП моб. прил. Количество сотрудников для начисления штрафа' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AntiTOPMP_CountFine');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_AntiTOPMP_SumFine() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AntiTOPMP_SumFine'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_AntiTOPMP_SumFine', 'Анти ТОП моб. прил. Сумма штрафа' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AntiTOPMP_SumFine');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_AntiTOPMP_CountAward() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AntiTOPMP_CountAward'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_AntiTOPMP_CountAward', 'Анти ТОП моб. прил. Количество сотрудников для начисления премии' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AntiTOPMP_CountAward');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_AntiTOPMP_MinProcAward() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AntiTOPMP_MinProcAward'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_AntiTOPMP_MinProcAward', 'Анти ТОП моб. прил. Минимальный процент выполнения плана для премии' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AntiTOPMP_MinProcAward');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_CourseReport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_CourseReport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_CourseReport', 'Курс для "Отчет остатки по подразделению для маркетинга"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_CourseReport');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_SmashSumSend() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_SmashSumSend'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_SmashSumSend', 'Разбивка перемещений по сумме' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_SmashSumSend');

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.   Шаблий О.В.
 21.03.25         * zc_ObjectFloat_GoodsByGoodsKind_WeightPackageKorob
 11.03.24         * zc_ObjectFloat_Bank_SummMax
 16.02.24         * zc_ObjectFloat_GoodsByGoodsKind_PackLimit
 27.12.23         * zc_ObjectFloat_PartionCell_...
 27.12.23                                                                                      * zc_ObjectFloat_CashSettings_SmashSumSend
 24.10.23                                                                                      * zc_ObjectFloat_CashSettings_CourseReport
 13.10.23                                                                                      * zc_ObjectFloat_CashSettings_Cat_5
 11.07.23                                                                                      * zc_ObjectFloat_CashSettings_AntiTOPMP_MinProcAward
 10.07.23                                                                                      * zc_ObjectFloat_CashSettings_AntiTOPMP_CountAward
 13.06.23                                                                                      * zc_ObjectFloat_CashSettings_AntiTOPMP_...
 21.03.23                                                                                      * zc_ObjectFloat_AccountSalesDE_Amount
 14.03.23         * zc_ObjectFloat_PersonalServiceList_SummAvance
                    zc_ObjectFloat_PersonalServiceList_SummAvanceMax
                    zc_ObjectFloat_PersonalServiceList_HourAvance
 02.02.23                                                                                      * zc_ObjectFloat_CashSettings_MobMessSum, zc_ObjectFloat_CashSettings_MobMessCount
 18.01.23                                                                                      * zc_ObjectFloat_PartionDateWages_Percent
 17.01.23                                                                                      * zc_ObjectFloat_CashSettings_FixedPercent
 12.01.23                                                                                      * zc_ObjectFloat_PayrollTypeVIP_Rate
 02.01.23                                                                                      * zc_ObjectFloat_CashSettings_AddMarkupTabletki
 25.11.22                                                                                      * zc_ObjectFloat_CashSettings_LimitCash
 13.10.22                                                                                      * zc_ObjectFloat_CashSettings_NormNewMobileOrders
 26.09.22                                                                                      * zc_ObjectFloat_User_InternshipConfirmation
 21.09.22                                                                                      * zc_ObjectFloat_Goods_MultiplicityDiscontSite
 20.09.22                                                                                      * zc_ObjectFloat_BuyerForSite_Bonus, zc_ObjectFloat_BuyerForSite_BonusAdd, zc_ObjectFloat_BuyerForSite_BonusAdded
 01.09.22         * zc_ObjectFloat_JuridicalDefermentPayment_AmountIn
 12.07.22         * zc_ObjectFloat_OrderCarInfo_...
 04.07.22                                                                                      * zc_ObjectFloat_CashSettings_DeviationsPrice1303
 20.06.22                                                                                      * zc_ObjectFloat_CashSettings_MinPriceSale
 15.06.22                                                                                      * zc_ObjectFloat_CashSettings_PriceFormSendVIP
 07.06.22                                                                                      * zc_ObjectFloat_CashSettings_ExpressVIPConfirm
 20.05.22                                                                                      * zc_ObjectFloat_DiffKindPrice_Price, zc_ObjectFloat_DiffKindPrice_Amount, zc_ObjectFloat_MCRequestItem_MinPrice, zc_ObjectFloat_MCRequestItem_MarginPercent, zc_ObjectFloat_MCRequestItem_MarginPercentOld
 27.04.22         * zc_ObjectFloat_ObjectCode_Basis
 08.04.22                                                                                      * zc_ObjectFloat_CashSettings_DeySupplOutSUN2, zc_ObjectFloat_CashSettings_DeySupplInSUN2 
 15.03.22                                                                                      * zc_ObjectFloat_CashSettings_TurnoverMoreSUN2 
 24.02.22                                                                                      * zc_ObjectFloat_ExchangeRates_Exchange 
 16.02.22                                                                                      * zc_ObjectFloat_DiffKind_Packages 
 15.02.22                                                                                      * zc_ObjectFloat_PriceSite_DiscontAmount, zc_ObjectFloat_PriceSite_DiscontPercent
 15.02.22                                                                                      * zc_ObjectFloat_Goods_DiscontAmountSite, zc_ObjectFloat_Goods_DiscontPercentSite
 11.02.22                                                                                      * c_ObjectFloat_Unit_...
 22.12.21         * zc_ObjectFloat_MemberMinus_Tax
 02.12.21                                                                                      * zc_ObjectFloat_CashSettings_PercentUntilNextSUN
 25.11.21                                                                                      * zc_ObjectFloat_SurchargeWages_Summa
 25.11.21                                                                                      * zc_ObjectFloat_CashSettings_PercentIC
 18.11.21         * zc_ObjectFloat_PersonalServiceList_KoeffSummCardSecond
 10.11.21                                                                                      * zc_ObjectFloat_Goods_SupplementMinPP
 02.11.21         * zc_ObjectFloat_Car_Weight
                    zc_ObjectFloat_Car_Year 
 29.10.21                                                                                      * zc_ObjectFloat_Goods_SupplementMin
 27.10.21                                                                                      * zc_ObjectFloat_BarCode_DiscountWithVAT, zc_ObjectFloat_BarCode_DiscountWithoutVAT
 18.10.21                                                                                      * zc_ObjectFloat_CashSettings_Samples...
 29.09.21                                                                                      * zc_ObjectFloat_Goods_NumberPlates, zc_ObjectFloat_Goods_QtyPackage
 24.09.21                                                                                      * zc_ObjectFloat_CorrectWagesPercentage_Percent
 16.09.21                                                                                      * zc_ObjectFloat_Goods_PromoBonus
 15.09.21                                                                                      * zc_ObjectFloat_BarCode_DiscountProcent
 14.09.21                                                                                      * zc_ObjectFloat_PayrollTypeVIP_Percent...
 10.09.21                                                                                      * zc_ObjectFloat_CashSettings_PriceCorrectionDay
 30.07.21                                                                                      * zc_ObjectFloat_ZReportLog_Summa...
 27.07.21                                                                                      * zc_ObjectFloat_CashSettings_CustomerThreshold
 01.07.21                                                                                      * zc_ObjectFloat_Goods_PairSunAmount
 24.06.21         * zc_ObjectFloat_Reason_PeriodDays
                    zc_ObjectFloat_Reason_PeriodTax
 22.06.21                                                                                      * zc_ObjectFloat_CorrectMinAmount_Amount
 14.06.21         * zc_ObjectFloat_ReceiptLevel_MovementDesc
 08.06.21         * zc_ObjectFloat_OrderPeriodKind_Week
 07.06.21                                                                                      * zc_ObjectFloat_CashSettings_Assortment...
 29.04.21         * zc_ObjectFloat_Partner_Category
 27.04.21                                                                                      * zc_ObjectFloat_MarketingDiscount_...
 27.04.21         * zc_ObjectFloat_Car_PartnerMin
 14.04.21                                                                                      * zc_ObjectFloat_CashSettings_DayCompensDiscount
 25.03.21         * zc_ObjectFloat_GoodsByGoodsKind_NormRem
                    zc_ObjectFloat_GoodsByGoodsKind_NormOut
 23.03.21                                                                                      * zc_ObjectFloat_FinalSUAProtocol_...
 18.03.21                                                                                      * zc_ObjectFloat_Juridical_ExpirationDateMonth
 17.03.21                                                                                      * zc_ObjectFloat_Goods_Multiplicity
 11.03.21                                                                                      * zc_ObjectFloat_DiscountExternalSupplier_SupplierID
 01.03.21                                                                                      * zc_ObjectFloat_PartnerMedical_LikiDniproId
 19.02.21         * zc_ObjectFloat_GoodsByGoodsKind_DaysQ
 18.02.21                                                                                      * zc_ObjectFloat_CashSettings_UpperLimitPromoBonus, zc_ObjectFloat_CashSettings_LowerLimitPromoBonus
 09.02.21                                                                                      * zc_ObjectFloat_Unit_SerialNumberMypharmacy
 05.02.21                                                                                      * zc_ObjectFloat_CashSettings_DayNonCommoditySUN
 09.12.20                                                                                      * zc_ObjectFloat_Unit_ShareFromPrice
 05.12.20                                                                                      * zc_ObjectFloat_Goods_KoeffSUN_Supplementv1
 20.11.20                                                                                      * zc_ObjectFloat_Juridical_CodeOrangeCard
 17.11.20         * zc_ObjectFloat_Asset_KW
 29.10.20                                                                                      * zc_ObjectFloat_Goods_SummaWages, zc_ObjectFloat_Goods_PercentWages
 26.10.20                                                                                      * zc_ObjectFloat_Unit_PercentSAUA
 21.10.20                                                                                      * zc_ObjectFloat_CashSettings_AttemptsSub
 14.10.20                                                                                      * zc_ObjectFloat_ConditionsKeep_RelatedProduct
 07.09.20                                                                                      * zc_ObjectFloat_BarCode_MaxPrice
 24.09.20                                                                                      * zc_ObjectFloat_DiffKind_DaysForSale
 15.09.20                                                                                      * zc_ObjectFloat_CashSettings_DaySaleForSUN
 04.09.20         * zc_ObjectFloat_MemberMinus_TotalSumm
                    zc_ObjectFloat_MemberMinus_Summ
 22.08.20                                                                                      * zc_ObjectFloat_JuridicalPriorities_Priorities
 21.07.20                                                                                      * zc_ObjectFloat_Unit_SerialNumberTabletki
 14.07.20                                                                                      * zc_ObjectFloat_HouseholdInventory_CountForPrice
 09.07.20                                                                                      * zc_ObjectFloat_PartionHouseholdInventory_MovementItemId
 06.07.20                                                                                      * zc_ObjectFloat_PartionGoods_ValueLess
 22.06.20                                                                                      * zc_ObjectFloat_Unit_HT_SUN_All
 10.06.20                                                                                      * zc_ObjectFloat_Juridical_CodeMedicard
 09.06.20                                                                                      * zc_ObjectFloat_Unit_DeySupplSun1, zc_ObjectFloat_Unit_MonthSupplSun1
 04.06.20         * zc_ObjectFloat_WorkTimeKind_Summ
 02.06.20                                                                                      * zc_ObjectFloat_CashSettings_SummaUrgentlySendVIP
 27.05.20                                                                                      * zc_ObjectFloat_CashSettings_SummaFormSendVIP
 28.05.20         * zc_ObjectFloat_ContractCondition_PercentRetBonus
 26.05.20                                                                                      * zc_ObjectFloat_DriverSun_ChatIDSendVIP
 19.05.20         * zc_ObjectFloat_Unit_LimitSUN_N
 16.05.20         * zc_ObjectFloat_Goods_LimitSUN_T1
 15.05.20         * zc_ObjectFloat_Unit_HT_SUN_v1
                    zc_ObjectFloat_Unit_HT_SUN_v2
                    zc_ObjectFloat_Unit_HT_SUN_v4
 12.05.20         * zc_ObjectFloat_Unit_Sun_v2Income
                    zc_ObjectFloat_Unit_Sun_v4Income
                  * zc_ObjectFloat_GoodsByGoodsKind_Avg_Sh
                    zc_ObjectFloat_GoodsByGoodsKind_Avg_Ves
                    zc_ObjectFloat_GoodsByGoodsKind_Avg_Nom
                    zc_ObjectFloat_GoodsByGoodsKind_Tax_Ves
                    zc_ObjectFloat_GoodsByGoodsKind_Tax_Nom
                    zc_ObjectFloat_GoodsByGoodsKind_Tax_Sh
 11.05.20         * zc_ObjectFloat_Goods_KoeffSUN_v1/v2/v4
 04.05.20         * zc_ObjectFloat_BarCodeBox_Print
 29.04.20         * zc_ObjectFloat_Asset_Production
                    zc_ObjectFloat_Goods_CountReceipt
 28.04.20                                                                                      * zc_ObjectFloat_Retail_OccupancySUN
 23.04.20                                                                                      * zc_ObjectFloat_Retail_Fund, zc_ObjectFloat_Retail_FundUsed
 08.04.20                                                                                      * zc_ObjectFloat_CashRegister_PhysicalMemoryCapacity
 05.04.20                                                                                      * zc_ObjectFloat_SeasonalityCoefficient_Koeff1..12
 31.03.20         * zc_ObjectFloat_Unit_KoeffOutSUN_v3
                    zc_ObjectFloat_Unit_KoeffInSUN_v3
                    zc_ObjectFloat_Goods_KoeffSUN_v3
 19.03.20                                                                                      * zc_ObjectFloat_Unit_MoneyBoxSunUsed
 13.03.20                                                                                      * zc_ObjectFloat_Unit_MoneyBoxSun
 11.03.20                                                                                      * zc_ObjectFloat_CommentTR_DifferenceSum
 27.01.20         * zc_ObjectFloat_PersonalServiceList_Compensation
 21.12.19                                                                                      * zc_ObjectFloat_Price_MCSValueSun
 17.12.19         * zc_ObjectFloat_Unit_SunIncome
 13.12.19                                                                                      * zc_ObjectFloat_Unit_MorionCode
 11.12.19                                                                                      * zc_ObjectFloat_Retail_LimitSUN
 10.12.19                                                                                      * zc_ObjectFloat_Unit_... for Sun
 04.12.19                                                                                      * zc_ObjectFloat_PriceChange_FixDiscount
 03.12.19                                                                                      * zc_ObjectFloat_MaxOrderAmountSecond
 19.11.19                                                                                      * zc_ObjectFloat_Juridical_CodeRazom
 29.10.19         * zc_ObjectFloat_Car_KoeffHoursWork
 28.10.19                                                                                      * zc_ObjectFloat_Unit_Latitude, zc_ObjectFloat_Unit_Longitude
 25.10.19                                                                                      * zc_ObjectFloat_Retail_ShareFromPrice
 23.10.19         * zc_ObjectFloat_Goods_CountForWeight
 16.10.19         * zc_ObjectFloat_LabReceiptChild_Value
 09.10.19         * zc_ObjectFloat_Goods_WeightTare
 26.08.19         * zc_ObjectFloat_Unit_KoeffInSUN, zc_ObjectFloat_Unit_KoeffOutSUN
 22.08.19                                                                                      * zc_ObjectFloat_PayrollType_Percent, zc_ObjectFloat_PayrollType_MinAccrualAmount
 06.08.19         * zc_ObjectFloat_JuridicalOrderFinance_SummOrderFinance
 05.08.19         * zc_ObjectFloat_GoodsByGoodsKind_WmsCellNum
 23.07.19         * zc_ObjectFloat_Retail_SummSUN
 15.07.19                                                                                      * zc_ObjectFloat_PartionDateKind_Day
 21.06.19                                                                                      * zc_ObjectFloat_PartionGoods_PriceWithVAT
 07.06.19                                                                                      * zc_ObjectFloat_CreditLimitJuridical_CreditLimit
 05.06.19                                                                                      * zc_ObjectFloat_MaxOrderAmount
 23.04.19         * zc_ObjectFloat_RetailCostCredit_MinPrice
                    zc_ObjectFloat_RetailCostCredit_Percent
 19.04.19         * zc_ObjectFloat_PartionDateKind_Month
 10.04.19         * zc_ObjectFloat_GoodsPropertyValue_WeightOnBox
                    zc_ObjectFloat_GoodsPropertyValue_CountOnBox
 10.04.19                                                                                      * zc_ObjectFloat_Juridical_CreditLimit
 03.04.19         * zc_ObjectFloat_GoodsByGoodsKind_WmsCode
 25.03.19         * zc_ObjectFloat_Retail_MarginPercent
 13.03.19         * zc_ObjectFloat_PriceChange_Multiplicity
                    zc_ObjectFloat_GoodsByGoodsKind_NormInDays
 17.02.19         * zc_ObjectFloat_TaxUnit_Price
                    zc_ObjectFloat_TaxUnit_Value
 11.02.19         * zc_ObjectFloat_GoodsCategory_Value
 07.02.19         * zc_ObjectFloat_PriceChange_FixPercent
 29.01.19         * zc_ObjectFloat_Route_RateSummaExp
 18.01.19         * zc_ObjectFloat_Maker_Day
                    zc_ObjectFloat_Maker_Month
 13.01.19         * zc_ObjectFloat_JuridicalSettingsItem_Bonus
                    zc_ObjectFloat_JuridicalSettingsItem_PriceLimit
 21.12.18                                                                                     * zc_ObjectFloat_RecalcMCSSheduler_Week ...
 14,12,18         * zc_ObjectFloat_DocumentTaxKind_Price
 22.10.18                                                                                     * zc_ObjectFloat_RepriceUnitSheduler_ ...
 14.10.18         *zc_ObjectFloat_ReportCollation_...
 27.08.18                                                                                     * zc_ObjectFloat_Overdraft_Summa
 20.08.18         * zc_ObjectFloat_Contract_TotalSumm
 16.08.18         * zc_ObjectFloat_PriceChange_Value
                    zc_ObjectFloat_PriceChange_FixValue
                    zc_ObjectFloat_PriceChange_PercentMarkup
 09.08.18                                                                                     * zc_ObjectFloat_Maker_CashBack, zc_ObjectFloat_Bank_Overdraft
 24.06.18         * zc_ObjectFloat_Box_...
                    zc_ObjectFloat_GoodsPropertyBox_...
 22.06.18         * zc_ObjectFloat_GoodsByGoodsKind_...
 20.06.18         * zc_ObjectFloat_ReplServer_CountTo
                    zc_ObjectFloat_ReplServer_CountFrom
 18.02.18         * zc_ObjectFloat_GoodsByGoodsKind_WeightPackageSticker
 05.12.17         * zc_ObjectFloat_WorkTimeKind_Tax
 02.11.17         * zc_ObjectFloat_GoodsReportSale_..........
                    zc_ObjectFloat_GoodsReportSaleInf_Week
 23.10.17         * zc_ObjectFloat_Sticker_Value1/2/3/4/5
 20.10.17         * zc_ObjectFloat_Member_ScalePSW
 08.08.17         * zc_ObjectFloat_Contract_OrderSumm
 22.06.17         * zc_ObjectFloat_GoodsProperty_TaxDoc
                    zc_ObjectFloat_GoodsPropertyValue_AmountDoc
 09.06.17         * zc_ObjectFloat_Price_MCSValueOld
 23.05.17         * zc_ObjectFloat_SPKind_Tax
 21.04.17         * add zc_ObjectFloat_Goods_CountPrice
 04.04.17         *
 30.03.17         * zc_ObjectFloat_GoodsListIncome_Amount
                    zc_ObjectFloat_GoodsListIncome_AmountChoice
 03.03.17         * zc_ObjectFloat_Contract_DayTaxSummary
 19.12.16         * zc_ObjectFloat_Goods_PriceSP
                    zc_ObjectFloat_Goods_GroupSP
 19.10.16         * zc_ObjectFloat_GoodsListSale_Amount
 23.09.16         * zc_ObjectFloat_MobileTariff_CostMinutes
 27.08.16         * zc_ObjectFloat_PriceGroupSettingsTOP_MinPrice
                    zc_ObjectFloat_PriceGroupSettingsTOP_Percent
 19.07.16         * zc_ObjectFloat_OverSettings_MinimumLot
                  , zc_ObjectFloat_OverSettings_MinPrice
 13.07.16         * zc_ObjectFloat_Asset_PeriodUse
 13.03.16         * zc_ObjectFloat_Unit_FarmacyCash
 03.03.16         * zc_ObjectFloat_ImportSettings_Time
 27.09.15                                                                       *zc_ObjectFloat_ReportSoldParams_PlanAmount
 17.09.15         * add zc_ObjectFloat_GoodsPropertyValue_BoxCount
 16.07.15         * add zc_ObjectFloat_Juridical_DayTaxSummary
 01.04.15                                        * add zc_ObjectFloat_Quality_NumberPrint
 11.03.15         * add zc_ObjectFloat_OrderType_ ...
 05.02.15         * add zc_ObjectFloat_ContractGoods_Price
 09.10.14                                                        * add zc_ObjectFloat_Box_Volumeб zc_ObjectFloat_Box_Weight
 09.09.14                      	                 * add zc_ObjectFloat_ServiceDate...
 26.07.14                      	                 * add zc_ObjectFloat_PartionGoods_Price
 21.07.14                      	                 * add zc_ObjectFloat_Contract_DocumentCount
 11.02.14                      	                 * del 10.02.14 :)
 11.02.14                      			                * add zc_ObjectFloat_Document_MovementId

 30.11.13                                        * add _StaffList_HoursDay
 30.10.13         * add zc_ObjectFloat_StaffListSumm_Value
 30.10.13         * del zc_ObjectFloat_StaffList_FundPayMonth, zc_ObjectFloat_StaffList_FundPayTurn
 19.10.13         * add zc_ObjectFloat_StaffListCost_Price, _ModelServiceItemMaster_MovementDesc, _ModelServiceItemMaster_Ratio

 19.10.13                                        * add zc_ObjectFloat_Contract_ChangePrice and zc_ObjectFloat_Contract_ChangePercent
 18.10.13         * add _StaffList_FundPayMonth, _StaffList_FundPayTurn
 17.10.13         * add _StaffList_HoursPlan, _StaffList_PersonalCount
 16.10.13                                        * add   zc_ObjectFloat_CardFuel_Limit
 29.09.13         * add   zc_ObjectFloat_PersonalGroup_WorkHours
 27.09.13         * add   zc_ObjectFloat_RateFuelKind_Tax
 24.09.13         * add  _Fuel_Ratio, _RateFuel_AmountColdHour, _RateFuel_Amount, _RateFuel_AmountColdDistance
 07.09.13                                        * add zc_ObjectFloat_PriceList_VATPercent
 15.08.13                         *  Перенес все из InsertUpdateObjectFloat
 29.07.13         * add zc_ObjectFloat_Partner_PrepareDayCount, zc_ObjectFloat_Partner_DocumentDayCount
 28.06.13                                        * НОВАЯ СХЕМА
*/
