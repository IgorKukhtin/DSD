--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Box_Volume() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Box_Volume'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Box(), 'zc_ObjectFloat_Box_Volume', 'Объем, м3.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Box_Volume');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Box_Weight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Box_Weight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Box(), 'zc_ObjectFloat_Box_Weight', 'Вес ящика' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Box_Weight');

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

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Contract_DocumentCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_DocumentCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Contract_DocumentCount', zc_Object_Contract(), 'Количество докуметов по договору' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_DocumentCount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Contract_Percent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_Percent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectFloat_Contract_Percent', '% Корректировки наценки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_Percent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Contract_DayTaxSummary() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_DayTaxSummary'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectFloat_Contract_DayTaxSummary', 'Кол-во дней для сводной налоговой' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_DayTaxSummary');

--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_ContractGoods_Price() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ContractGoods_Price'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_ContractGoods_Price', zc_Object_ContractGoods(), 'Цена' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ContractGoods_Price');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Fuel_Ratio() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Fuel_Ratio'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Fuel(), 'zc_ObjectFloat_Fuel_Ratio', 'Коэффициент перевода нормы' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Fuel_Ratio');
  

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

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsPropertyValue_Amount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyValue_Amount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsPropertyValue(), 'zc_ObjectFloat_GoodsPropertyValue_Amount', 'Вес товара' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyValue_Amount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsPropertyValue_BoxCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyValue_BoxCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsPropertyValue(), 'zc_ObjectFloat_GoodsPropertyValue_BoxCount', 'Количество в ящике' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyValue_BoxCount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Juridical_Percent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_Percent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectFloat_Juridical_Percent', '' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_Percent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Juridical_DayTaxSummary() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_DayTaxSummary'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectFloat_Juridical_DayTaxSummary', 'Кол-во дней для сводной налоговой' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_DayTaxSummary');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Juridical_OrderSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_OrderSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectFloat_Juridical_OrderSumm', 'минимальная сумма для заказа' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_OrderSumm');


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


--!!! АПТЕКА

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Contract_Deferment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_Deferment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Contract_Deferment', zc_Object_Contract(), 'Отсрочка платежа' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_Deferment');

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

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Price_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Price_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectFloat_Price_Value', 'Значение цены реализации' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Price_Value');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Price_MCSValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Price_MCSValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectFloat_Price_MCSValue', 'Неснижаемый товарный запас' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Price_MCSValue');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Price_PercentMarkup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Price_PercentMarkup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectFloat_Price_PercentMarkup', '% наценки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Price_PercentMarkup');


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
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_Asset_PeriodUse() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Asset_PeriodUse'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Asset(), 'zc_ObjectFloat_Asset_PeriodUse', 'Период эксплуатации' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Asset_PeriodUse');

  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_OverSettings_MinPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OverSettings_MinPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_OverSettings(), 'zc_ObjectFloat_OverSettings_MinPrice', 'Минимальная цена' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OverSettings_MinPrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OverSettings_MinimumLot() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OverSettings_MinimumLot'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_OverSettings(), 'zc_ObjectFloat_OverSettings_MinimumLot', 'Кратность (Мин.округление)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OverSettings_MinimumLot');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_PriceSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PriceSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_PriceSP', 'Референтна ціна за уп, грн (Соц. проект)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PriceSP');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_GroupSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_GroupSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_GroupSP', 'Групи відшкоду-вання – І або ІІ' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_GroupSP');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_CountSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_CountSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_object_Goods(),'zc_ObjectFloat_Goods_CountSP', 'Кількість одиниць лікарського засобу у споживчій упаковці (Соц. проект)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_CountSP');

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
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
