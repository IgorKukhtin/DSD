--------------------------- !!!!!!!!!!!!!!!!!!!!!!!!!
--------------------------- !!! ВРЕМЕННЫЕ ОБЪЕКТЫ !!!
--------------------------- !!!!!!!!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Partner1CLink_Sybase() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Partner1CLink_Sybase'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Partner1CLink(), 'zc_ObjectBoolean_Partner1CLink_Sybase', 'zc_ObjectBoolean_Partner1CLink_Sybase' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Partner1CLink_Sybase');  

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_GoodsByGoodsKind1CLink_Sybase() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_GoodsByGoodsKind1CLink_Sybase'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind1CLink(), 'zc_ObjectBoolean_GoodsByGoodsKind1CLink_Sybase', 'zc_ObjectBoolean_GoodsByGoodsKind1CLink_Sybase' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_GoodsByGoodsKind1CLink_Sybase');  

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 15.02.14                                        * 
*/
