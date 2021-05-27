-- Function: gpInsertUpdate_Object_Currency()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Currency (Integer, Integer, TVarChar, TVarChar, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Currency(
 INOUT ioId                  Integer   ,   	-- ключ объекта <Валюта>
    IN inCode                Integer   ,    -- Международный код объекта <Валюта> 
    IN inName                TVarChar  ,    -- Название объекта <Валюта> 
    IN inInternalName        TVarChar  ,    -- Международное наименование объекта <Валюта> 
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Code_max Integer;   
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Currency());
   vbUserId:= lpGetUserBySession (inSession);

   -- Если код не установлен, определяем его каи последний+1
   IF COALESCE (inCode, 0) = 0
   THEN 
       SELECT MAX (ObjectCode) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_Currency();
   ELSE
       Code_max := inCode;
   END IF;

   -- проверка прав уникальности для свойства <Наименование Валюты>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Currency(), inName);
   -- проверка прав уникальности для свойства <Код Валюты>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Currency(), Code_max);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Currency(), Code_max, inName);
   
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_Currency_InternalName(), ioId, inInternalName);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Currency (Integer, Integer, TVarChar, TVarChar, tvarchar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.12.13                                        *Cyr1251
 11.06.13          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Currency()       