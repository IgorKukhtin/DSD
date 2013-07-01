-- Function: lpInsertUpdate_Object_Enum() - делает то то ....

-- DROP FUNCTION lpInsertUpdate_Object_Enum (IN inId Integer, IN inDescId Integer, IN inCode Integer, IN inName TVarChar, IN inEnumName TVarChar);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Enum(
    IN inId           Integer   ,    -- <Ключ объекта>
    IN inDescId       Integer   , 
    IN inCode         Integer   , 
    IN inName         TVarChar  ,
    IN inEnumName     TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbCode Integer;   
BEGIN

   -- !!! ОБЯЗАТЕЛЬНО СДЕЛАТЬ ПРОВЕРКУ УНИКАЛЬНОСТИ !!!
   -- Проверка уникальности inEnumName


   -- Если код не установлен, определяем его как последний + 1
   vbCode:= lfGet_ObjectCode (inCode, inDescId);

   -- сохранили <Объект>
   inId := lpInsertUpdate_Object (inId, inDescId, vbCode, inName);

   -- сохранили свойство <Enum>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), inId, inEnumName);

END;$BODY$ LANGUAGE PLPGSQL;
ALTER FUNCTION lpInsertUpdate_Object_Enum (Integer, Integer, Integer, TVarChar, TVarChar) OWNER TO POSTGRES;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.06.13                                        *

*/

-- тест
-- SELECT * FROM lpInsertUpdate_Object_Enum (inId:= 0, inDescId:= zc_Object_Goods(), inCode:= -1, inName:= 'test-goods-enum', inEnumName:= 'zc_test_goods_enum');
