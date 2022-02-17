
CREATE OR REPLACE FUNCTION zc_ObjectDate_Protocol_Insert() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Protocol_Insert'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Client(), 'zc_ObjectDate_Protocol_Insert', 'Дата создания' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Protocol_Insert');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Protocol_Update() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Protocol_Update'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Client(), 'zc_ObjectDate_Protocol_Update', 'Дата корректировки' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Protocol_Update');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Product_DateStart() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Product_DateStart'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectDate_Product_DateStart', zc_Object_Product(), 'Начало производства' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Product_DateStart');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Product_DateBegin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Product_DateBegin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectDate_Product_DateBegin', zc_Object_Product(), 'Ввод в эксплуатацию' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Product_DateBegin');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Product_DateSale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Product_DateSale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectDate_Product_DateSale', zc_Object_Product(), 'Продажа' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Product_DateSale');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Goods_PartnerDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_PartnerDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectDate_Goods_PartnerDate', zc_Object_Goods(), 'последняя дата прихода' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_PartnerDate');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Partner_PriceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Partner_PriceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectDate_Partner_PriceList', zc_Object_Partner(), 'Дата прайса' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Partner_PriceList');

/*-------------------------------------------------------------------------------
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.02.22         * zc_ObjectDate_Partner_PriceList
 11.11.20         * zc_ObjectDate_Goods_PartnerDate
 09.10.20         * zc_ObjectDate_Product_
 28.08.20                                        * 
*/
