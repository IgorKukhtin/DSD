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
  SELECT zc_Object_ProdModel(), 'zc_ObjectFloat_ProdModel_Beam', 'Луч' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdModel_Beam');

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
  SELECT zc_Object_ProdEngine(), 'zc_ObjectFloat_ProdEngine_Power', 'Сиденья' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdEngine_Power');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ProdOptions_Level() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdOptions_Level'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ProdOptions(), 'zc_ObjectFloat_ProdOptions_Level', 'Уровень' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdOptions_Level');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Product_Hours() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Product_Hours'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ProdOptions(), 'zc_ObjectFloat_Product_Hours', 'Время обслуживания,ч.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Product_Hours');

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

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.11.20         * zc_ObjectFloat_Goods_...
 09.10.20         * zc_ObjectFloat_Product_Hours
 08.10.20         * zc_ObjectFloat_ProdModel...
                    zc_ObjectFloat_ProdEngine_Power
                    zc_ObjectFloat_ProdOptions_Level
 28.08.20                                        * 
*/
