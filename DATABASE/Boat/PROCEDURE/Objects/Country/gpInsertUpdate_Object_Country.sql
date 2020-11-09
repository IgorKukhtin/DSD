-- Страна производитель

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Country (Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Country(
 INOUT ioId           Integer,       -- Ключ объекта <Страна >
    IN inCode         Integer,       -- Код Объекта <Страна >
    IN inName         TVarChar,      -- Название объекта <Страна>
    IN inShortName    TVarChar,      -- Краткое название
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Country());
   vbUserId:= lpGetUserBySession (inSession);

   -- 
   IF COALESCE (ioId, 0) = 0 AND COALESCE (inCode, 0) = 0  THEN inCode := NEXTVAL ('Object_Country_seq'); 
   ELSEIF inCode = 0
         THEN inCode := COALESCE ((SELECT ObjectCode FROM Object WHERE Id = ioId), 0);
   END IF; 

   -- проверка уникальности для свойства <Наименование Страна>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Country(), inName);
   -- проверка уникальности для свойства <Код Страна>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Country(), inCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Country(), ioCode, inName);

   -- сохранили свойство
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Country_ShortName(), ioId, inShortName);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.11.20          *
*/

-- тест
--