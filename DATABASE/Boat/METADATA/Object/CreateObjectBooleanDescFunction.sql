

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_Arc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_Arc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_Arc', 'Архив' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_Arc');


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.11.20         * 
 28.08.20                                        * 
*/
