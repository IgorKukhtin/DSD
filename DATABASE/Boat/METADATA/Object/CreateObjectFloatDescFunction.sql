CREATE OR REPLACE FUNCTION zc_ObjectFloat_Program_MajorVersion() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Program_MajorVersion'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Program_MajorVersion', zc_Object_Program(), 'Первая часть версии программы' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Program_MajorVersion');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Program_MinorVersion() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Program_MinorVersion'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Program_MinorVersion', zc_Object_Program(), 'Вторая часть версии программы' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Program_MinorVersion');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ImportSettings_StartRow() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ImportSettings_StartRow'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_ImportSettings_StartRow', zc_Object_ImportSettings(), 'Первая строка загрузки для Excel' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ImportSettings_StartRow');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ImportSettings_Time() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ImportSettings_Time'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ImportSettings(), 'zc_ObjectFloat_ImportSettings_Time', 'Периодичность проверки почты в активном периоде, мин' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ImportSettings_Time');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_ProdModel_Length() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdModel_Length'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ProdModel(), 'zc_ObjectFloat_ProdModel_Length', 'Длина' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdModel_Length');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ProdModel_Beam() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdModel_Beam'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ProdModel(), 'zc_ObjectFloat_ProdModel_Beam', 'Ширина' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdModel_Beam');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ProdModel_Height() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdModel_Height'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ProdModel(), 'zc_ObjectFloat_ProdModel_Height', 'Высота' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdModel_Height');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ProdModel_Weight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdModel_Weight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ProdModel(), 'zc_ObjectFloat_ProdModel_Weight', 'Вес' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdModel_Weight');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ProdModel_Fuel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdModel_Fuel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ProdModel(), 'zc_ObjectFloat_ProdModel_Fuel', 'Запас топлива' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdModel_Fuel');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ProdModel_Speed() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdModel_Speed'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ProdModel(), 'zc_ObjectFloat_ProdModel_Speed', 'Скорость' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdModel_Speed');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ProdModel_Seating() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdModel_Seating'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ProdModel(), 'zc_ObjectFloat_ProdModel_Seating', 'Сиденья' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdModel_Seating');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ProdEngine_Power() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdEngine_Power'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ProdEngine(), 'zc_ObjectFloat_ProdEngine_Power', 'Power' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdEngine_Power');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ProdEngine_Volume() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdEngine_Volume'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ProdEngine(), 'zc_ObjectFloat_ProdEngine_Volume', 'Объем cm' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdEngine_Volume');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_ProdColorItems_OrderClient() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdColorItems_OrderClient'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ProdColorItems(), 'zc_ObjectFloat_ProdColorItems_OrderClient', 'Документ Заказ Клиента' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdColorItems_OrderClient');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ProdOptItems_OrderClient() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdOptItems_OrderClient'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ProdOptItems(), 'zc_ObjectFloat_ProdOptItems_OrderClient', 'Документ Заказ Клиента' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdOptItems_OrderClient');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_ProdOptions_Level() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdOptions_Level'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ProdOptions(), 'zc_ObjectFloat_ProdOptions_Level', 'Уровень' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdOptions_Level');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ProdOptions_SalePrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdOptions_SalePrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ProdOptions(), 'zc_ObjectFloat_ProdOptions_SalePrice', 'Цена продажи без ндс' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdOptions_SalePrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Product_Hours() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Product_Hours'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ProdOptions(), 'zc_ObjectFloat_Product_Hours', 'Время обслуживания,ч.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Product_Hours');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Product_DiscountTax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Product_DiscountTax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ProdOptions(), 'zc_ObjectFloat_Product_DiscountTax', '% скидки (основной)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Product_DiscountTax');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Product_DiscountNextTax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Product_DiscountNextTax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ProdOptions(), 'zc_ObjectFloat_Product_DiscountNextTax', '% скидки (дополнительный)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Product_DiscountNextTax');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ProdOptItems_PriceIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdOptItems_PriceIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ProdOptItems(), 'zc_ObjectFloat_ProdOptItems_PriceIn', 'Вх. цена' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdOptItems_PriceIn');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ProdOptItems_PriceOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdOptItems_PriceOut'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ProdOptItems(), 'zc_ObjectFloat_ProdOptItems_PriceOut', 'Исх. цена' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdOptItems_PriceOut');
--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_EmpfPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_EmpfPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_EmpfPrice', 'Рекомендуемая цена без ндс' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_EmpfPrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_EKPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_EKPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_EKPrice', 'Закупочная цена без ндс' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_EKPrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_Refer() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_Refer'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_Refer', 'рекомендов кол-во закупки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_Refer');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_Min() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_Min'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_Min', 'мин кол-во на складе' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_Min');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_TaxKind_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_TaxKind_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_TaxKind(), 'zc_ObjectFloat_TaxKind_Value', 'Значение НДС' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_TaxKind_Value');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_ReceiptProdModelChild_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReceiptProdModelChild_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReceiptProdModelChild(), 'zc_ObjectFloat_ReceiptProdModelChild_Value', 'Значение' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReceiptProdModelChild_Value');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ReceiptGoodsChild_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReceiptGoodsChild_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReceiptGoodsChild(), 'zc_ObjectFloat_ReceiptGoodsChild_Value', 'Значение' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReceiptGoodsChild_Value');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ReceiptService_EKPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReceiptService_EKPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReceiptService(), 'zc_ObjectFloat_ReceiptService_EKPrice', 'Вх. цена без ндс' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReceiptService_EKPrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ReceiptService_SalePrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReceiptService_SalePrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReceiptService(), 'zc_ObjectFloat_ReceiptService_SalePrice', 'Цена продажи без ндс' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReceiptService_SalePrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Client_DiscountTax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Client_DiscountTax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Client(), 'zc_ObjectFloat_Client_DiscountTax', '% скидки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Client_DiscountTax');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ProdOptItems_DiscountTax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdOptItems_DiscountTax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ProdOptItems(), 'zc_ObjectFloat_ProdOptItems_DiscountTax', '% скидки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdOptItems_DiscountTax');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Partner_DiscountTax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_DiscountTax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Partner(), 'zc_ObjectFloat_Partner_DiscountTax', '% скидки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_DiscountTax');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Partner_DayCalendar() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_DayCalendar'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Partner(), 'zc_ObjectFloat_Partner_DayCalendar', 'Отсрочка в календарных днях' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_DayCalendar');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Partner_Bank() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_Bank'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Partner(), 'zc_ObjectFloat_Partner_Bank', 'Отсрочка в банковских днях' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_Bank');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Client_DayCalendar() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Client_DayCalendar'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Client(), 'zc_ObjectFloat_Client_DayCalendar', 'Отсрочка в календарных днях' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Client_DayCalendar');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Client_Bank() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Client_Bank'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Client(), 'zc_ObjectFloat_Client_Bank', 'Отсрочка в банковских днях' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Client_Bank');



/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.02.21         * zc_ObjectFloat_Partner_DiscountTax
                    zc_ObjectFloat_Partner_Bank
                    zc_ObjectFloat_Partner_DayCalendar
                    zc_ObjectFloat_Client_DayCalendar
                    zc_ObjectFloat_Client_Bank
 04.01.21         * zc_ObjectFloat_Client_DiscountTax
                    zc_ObjectFloat_ProdOptItems_DiscountTax
                    zc_ObjectFloat_Product_DiscountTax
                    zc_ObjectFloat_Product_DiscountNextTax
 25.12.20         * zc_ObjectFloat_ProdOptions_SalePrice
 22.12.20         * zc_ObjectFloat_ReceiptService_EKPrice
                    zc_ObjectFloat_ReceiptService_SalePrice
 01.12.20         * zc_ObjectFloat_ReceiptProdModelChild_Value
                    zc_ObjectFloat_ReceiptGoodsChild_Value
 11.11.20         * zc_ObjectFloat_Goods_...
 09.10.20         * zc_ObjectFloat_Product_Hours
 08.10.20         * zc_ObjectFloat_ProdModel...
                    zc_ObjectFloat_ProdEngine_Power
                    zc_ObjectFloat_ProdOptions_Level
 28.08.20                                        * 
*/
