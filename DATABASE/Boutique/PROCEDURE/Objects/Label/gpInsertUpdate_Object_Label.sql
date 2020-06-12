-- Название для ценника

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Label (Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Label (Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Label(
 INOUT ioId           Integer,       -- Ключ объекта <Название для ценника>    
 INOUT ioCode         Integer,       -- Код объекта <Название для ценника>     
    IN inName         TVarChar,      -- Название объекта <Название для ценника>
    IN inName_UKR     TVarChar,      -- Название объекта <Название для ценника> укр
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Label());
   vbUserId:= lpGetUserBySession (inSession);

   -- Нужен ВСЕГДА- ДЛЯ НОВОЙ СХЕМЫ С ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) <> 0 THEN ioCode := NEXTVAL ('Object_Label_seq'); 
   END IF; 

   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) = 0  THEN ioCode := NEXTVAL ('Object_Label_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := COALESCE ((SELECT ObjectCode FROM Object WHERE Id = ioId), 0);
   END IF; 

   -- проверка уникальности для свойства <Наименование Название для ценника>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Label(), inName); 

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Label(), ioCode, inName);

   -- сохранили свойство
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Label_UKR(), ioId, inName_UKR);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
09.06.20          *
13.05.17                                                          *
08.05.17                                                          *
03.03.17                                                          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Label()
