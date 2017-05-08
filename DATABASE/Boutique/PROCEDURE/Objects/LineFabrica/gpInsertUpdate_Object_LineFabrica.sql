-- Линия коллекции

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_LineFabrica (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_LineFabrica(
 INOUT ioId           Integer,       -- Ключ объекта <Линия коллекции>    
 INOUT ioCode         Integer,       -- Код объекта <Линия коллекции>     
    IN inName         TVarChar,      -- Название объекта <Линия коллекции>
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS record
AS
$BODY$
  DECLARE vbUserId integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_LineFabrica());
   vbUserId:= lpGetUserBySession (inSession);

   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE(ioCode,0) = 0  THEN  ioCode := NEXTVAL ('Object_LineFabrica_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := coalesce((SELECT ObjectCode FROM Object WHERE Id = ioId),0);
   END IF; 

   -- Нужен ВСЕГДА- ДЛЯ НОВОЙ СХЕМЫ С ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 THEN  ioCode := NEXTVAL ('Object_LineFabrica_seq'); 
   END IF; 

   -- проверка уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_LineFabrica(), inName); 

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_LineFabrica(), ioCode, inName);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
08.05.17                                                          *
06.03.17                                                          *
22.02.17                                                          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_LineFabrica()
