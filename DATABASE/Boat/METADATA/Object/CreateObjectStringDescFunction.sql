CREATE OR REPLACE FUNCTION zc_ObjectString_User_Password() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Password'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_User_Password', zc_Object_User(), 'Пароль пользователя' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Password');

-- Это универсальное свойство, может использоваться у всех объектов
CREATE OR REPLACE FUNCTION zc_ObjectString_Enum() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Enum'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Enum', NULL, 'Функция бизнес-логики' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Enum');

CREATE OR REPLACE FUNCTION zc_ObjectString_Form_HelpFile() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Form_HelpFile'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Form_HelpFile', zc_Object_Form(), 'Путь к файлу помощи' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Form_HelpFile');

-- Add ProjectBoat

CREATE OR REPLACE FUNCTION zc_ObjectString_TranslateWord_Name() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_TranslateWord_Name'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_TranslateWord_Name', zc_Object_Form(), 'название Элемента' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_TranslateWord_Name');

CREATE OR REPLACE FUNCTION zc_ObjectString_ProdModel_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ProdModel_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ProdModel_Comment', zc_Object_ProdModel(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ProdModel_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_ProdEngine_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ProdEngine_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ProdEngine_Comment', zc_Object_ProdEngine(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ProdEngine_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Brand_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Brand_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Brand_Comment', zc_Object_Brand(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Brand_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_ProdColorGroup_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ProdColorGroup_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ProdColorGroup_Comment', zc_Object_ProdColorGroup(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ProdColorGroup_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_ProdColor_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ProdColor_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ProdColor_Comment', zc_Object_ProdColor(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ProdColor_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_ProdOptions_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ProdOptions_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ProdOptions_Comment', zc_Object_ProdOptions(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ProdOptions_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Product_CIN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Product_CIN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Product_CIN', zc_Object_Product(), 'CIN' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Product_CIN');

CREATE OR REPLACE FUNCTION zc_ObjectString_Product_EngineNum() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Product_EngineNum'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Product_EngineNum', zc_Object_Product(), 'EngineNum' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Product_EngineNum');

CREATE OR REPLACE FUNCTION zc_ObjectString_Article() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Article'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Article', zc_Object_Product(), 'Артикл' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Article');

CREATE OR REPLACE FUNCTION zc_ObjectString_Product_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Product_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Product_Comment', zc_Object_Product(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Product_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_ProdColorItems_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ProdColorItems_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ProdColorItems_Comment', zc_Object_ProdColorItems(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ProdColorItems_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_ProdOptItems_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ProdOptItems_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ProdOptItems_Comment', zc_Object_ProdOptItems(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ProdOptItems_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_ProdOptItems_PartNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ProdOptItems_PartNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ProdOptItems_PartNumber', zc_Object_ProdOptItems(), '№ уст. доп.оборуд' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ProdOptItems_PartNumber');

CREATE OR REPLACE FUNCTION zc_ObjectString_ProdOptPattern_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ProdOptPattern_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ProdOptPattern_Comment', zc_Object_ProdOptPattern(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ProdOptPattern_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_ProdColorPattern_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ProdColorPattern_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ProdColorPattern_Comment', zc_Object_ProdColorPattern(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ProdColorPattern_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Client_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Client_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Client_Comment', zc_Object_Client(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Client_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_Comment', zc_Object_Partner(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Unit_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Unit_Comment', zc_Object_Unit(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Position_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Position_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Position_Comment', zc_Object_Position(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Position_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Personal_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Personal_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Personal_Comment', zc_Object_Personal(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Personal_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Country_ShortName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Country_ShortName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Country_ShortName', zc_Object_Country(), 'Краткое название' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Country_ShortName');

CREATE OR REPLACE FUNCTION zc_ObjectString_PLZ_City() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PLZ_City'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_PLZ_City', zc_Object_PLZ(), 'Город' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PLZ_City');

CREATE OR REPLACE FUNCTION zc_ObjectString_PLZ_AreaCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PLZ_AreaCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_PLZ_AreaCode', zc_Object_PLZ(), 'Префикс' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PLZ_AreaCode');

CREATE OR REPLACE FUNCTION zc_ObjectString_PLZ_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PLZ_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_PLZ_Comment', zc_Object_PLZ(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PLZ_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_ModelEtiketen_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ModelEtiketen_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ModelEtiketen_Comment', zc_Object_ModelEtiketen(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ModelEtiketen_Comment');

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.11.20         * zc_ObjectString_Country_ShortName
                    zc_ObjectString_PLZ_City
                    zc_ObjectString_PLZ_AreaCode
                    zc_ObjectString_PLZ_Comment
                    zc_ObjectString_ModelEtiketen_Comment
 09.10.20         * zc_ObjectString_Product_...
                    zc_ObjectString_ProdColorItems_Comment
                    zc_ObjectString_ProdOptItems_PartNumber
                    zc_ObjectString_ProdOptItems_Comment
 08.10.20         * zc_ObjectString_ProdModel_Comment
                    zc_ObjectString_ProdEngine_Comment
                    zc_ObjectString_ProdColorGroup_Comment
                    zc_ObjectString_Brand_Comment
                    zc_ObjectString_ProdColor_Comment
                    zc_ObjectString_ProdOptions_Comment
 28.08.20                                        * 
*/
