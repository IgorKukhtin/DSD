-- Страна производитель

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CountryBrand (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CountryBrand(
 INOUT ioId           Integer,       -- Ключ объекта <Страна производитель>
 INOUT ioCode         Integer,       -- Код Объекта <Страна производитель>
    IN inName         TVarChar,      -- Название объекта <Страна производитель>
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_CountryBrand());
   vbUserId:= lpGetUserBySession (inSession);

   -- Нужен ВСЕГДА- ДЛЯ НОВОЙ СХЕМЫ С ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) <> 0 THEN ioCode := NEXTVAL ('Object_CountryBrand_seq'); 
   END IF; 

   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) = 0  THEN ioCode := NEXTVAL ('Object_CountryBrand_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := COALESCE ((SELECT ObjectCode FROM Object WHERE Id = ioId), 0);
   END IF; 

   -- проверка уникальности для свойства <Наименование Страна производитель>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_CountryBrand(), inName);
   -- проверка уникальности для свойства <Код Страна производитель>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_CountryBrand(), ioCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_CountryBrand(), ioCode, inName);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
13.05.17                                                          *
17.02.17                                                          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_CountryBrand()
