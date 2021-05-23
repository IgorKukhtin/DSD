-- Function: gpInsertUpdate_Object_Maker (Integer,Integer,TVarChar, TFloat,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Maker (Integer,Integer,TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Maker(
 INOUT ioId              Integer   ,    -- ключ объекта <Производитель>
    IN inCode            Integer   ,    -- Код объекта <>
    IN inName            TVarChar  ,    -- Название объекта <>
    IN inCountryId       Integer   ,    -- Страна
    IN inSession         TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;    
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Maker());
   vbUserId:= lpGetUserBySession (inSession);


   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Maker()); 
   
   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Maker(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Maker(), vbCode_calc);
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Maker(), vbCode_calc, inName);

    -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Maker_Country(), ioId, inCountryId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$ LANGUAGE plpgsql;
ALTER FUNCTION gpInsertUpdate_Object_Maker(Integer,Integer,TVarChar, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.02.14         *  
 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Maker()