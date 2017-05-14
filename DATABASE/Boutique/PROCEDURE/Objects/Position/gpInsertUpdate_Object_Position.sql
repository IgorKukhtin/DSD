-- Function: gpInsertUpdate_Object_Position (Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Position (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Position(
 INOUT ioId           Integer,       -- Ключ объекта <Должности>    
 INOUT ioCode         Integer,       -- Код объекта <Должности>     
    IN inName         TVarChar,      -- Название объекта <Должности>
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS record
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Position());
   vbUserId:= lpGetUserBySession (inSession);

   -- Нужен ВСЕГДА- ДЛЯ НОВОЙ СХЕМЫ С ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE(ioCode,0) <> 0 THEN  ioCode := NEXTVAL ('Object_Position_seq'); 
   END IF; 

   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE(ioCode,0) = 0  THEN  ioCode := NEXTVAL ('Object_Position_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := COALESCE((SELECT ObjectCode FROM Object WHERE Id = ioId),0);
   END IF; 

   -- проверка уникальности для свойства <Наименование Должности>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Position(), inName); 

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Position(), ioCode, inName);

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
08.05.17                                                          *
28.03.17                                                          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Position()
