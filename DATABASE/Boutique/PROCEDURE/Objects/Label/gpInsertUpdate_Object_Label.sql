-- Function: gpInsertUpdate_Object_Label (Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Label (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Label(
 INOUT ioId           Integer,       -- Ключ объекта <Название для ценника>    
    IN inCode         Integer,       -- Код объекта <Название для ценника>     
    IN inName         TVarChar,      -- Название объекта <Название для ценника>
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Label());
   vbUserId:= lpGetUserBySession (inSession);

   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF inCode = 0 THEN  inCode := NEXTVAL ('Object_Label_seq'); END IF; 

   -- проверка уникальности для свойства <Наименование Название для ценника>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Label(), inName); 

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Label(), inCode, inName);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
03.03.17                                                          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Label()
