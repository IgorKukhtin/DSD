-- Function: gpInsertUpdate_Object_City (Integer, Integer,  TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_City (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_City(
 INOUT ioId           Integer,       -- Ключ объекта <Населенный пункт>
 INOUT ioCode         Integer,       -- Код объекта <Населенный пункт>     
    IN inName         TVarChar,      -- Название объекта <Населенный пункт>
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS record 
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_City());
   vbUserId:= lpGetUserBySession (inSession);

   -- Нужен ВСЕГДА- ДЛЯ НОВОЙ СХЕМЫ С ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode,0) <> 0 THEN  ioCode := NEXTVAL ('Object_City_seq'); 
   END IF; 

   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode,0) = 0  THEN  ioCode := NEXTVAL ('Object_City_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := COALESCE ((SELECT ObjectCode FROM Object WHERE Id = ioId),0);
   END IF; 

   -- проверка уникальности для свойства <Наименование Населенный пункт>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_City(), inName);
   -- проверка уникальности для свойства <Код Населенный пункт>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_City(), ioCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_City(), ioCode, inName);

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
06.03.2017                                                        *
28.02.2017                                                        *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_City()
